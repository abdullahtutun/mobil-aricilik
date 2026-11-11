// Package files holds the file collections, the counterpart of Supabase's
// storage buckets (K-13, P6.1): one collection per bucket, one record per
// object. The record's id is the last UUID of the object path, `path` is
// the Supabase storage_path verbatim, and `org_id` is the first folder of
// the path (public_lot_files: the lot's organization, see [Spec.OrgInPath]).
//
// The collections and their API rules are created by
// migrations/1794300012_file_collections.go from [Specs]; this package keeps
// what both the migration and the hooks need, so the path patterns, size
// limits and MIME types have one definition.
package files

import (
	"regexp"
	"strings"

	validation "github.com/pocketbase/ozzo-validation/v4"
	"github.com/pocketbase/pocketbase/core"
)

// Field names shared by every file collection.
const (
	FieldOrgID   = "org_id"
	FieldPath    = "path"
	FieldFile    = "file"
	FieldCreated = "created"
)

// uuidPart is one UUID segment of an object path. Supabase's
// *_object_org_id functions accept `[0-9a-f-]{36}`; every segment is a
// client-generated UUID (K-4), so the stricter form loses nothing and keeps
// org_id and id valid.
const uuidPart = `[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}`

// MiB is one mebibyte; Supabase's file_size_limit values are multiples.
const MiB = 1 << 20

// Spec is one bucket's collection.
type Spec struct {
	// Name is the collection name.
	Name string
	// Bucket is the Supabase bucket it replaces.
	Bucket string
	// PathPattern is the bucket's object path pattern: the regular
	// expression of its private.*_object_org_id function, segments as
	// strict UUIDs.
	PathPattern string
	// MaxSize is the bucket's file_size_limit in bytes.
	MaxSize int64
	// MimeTypes are what PocketBase accepts, detected from the content.
	// Supabase checked the declared content type against
	// allowed_mime_types; see [mediaMimeTypes] for the one difference.
	MimeTypes []string
	// OrgInPath is true when the first path folder is the organization.
	// public-lots paths start with the lot id instead; the server code that
	// copies the report (P5.10) sets org_id to the lot's organization.
	OrgInPath bool
}

// mediaMimeTypes: Supabase allowed image/jpeg and audio/mp4 by declared
// content type. PocketBase detects the type from the bytes, and an AAC voice
// note (`.m4a`) is detected by its ftyp brand: "M4A " (iOS) is
// audio/x-m4a, Android's MediaRecorder writes "isom"/"mp42", which is
// video/mp4. All three are the same container; the path still has to end in
// .jpg or .m4a.
var mediaMimeTypes = []string{"image/jpeg", "audio/mp4", "audio/x-m4a", "video/mp4"}

// Specs lists the file collections in creation order. Sources
// (supabase/migrations/…): media 20261024190000, documents 20261027180000,
// receipts 20261103120000, feedback 20261027120000, org-logos
// 20261112120000, public-lots 20261102180000. The knowledge bucket is
// P6.2; map-packs is gone (K-13).
var Specs = []Spec{
	{
		Name:        "media_files",
		Bucket:      "media",
		PathPattern: `^` + uuidPart + `/` + uuidPart + `/` + uuidPart + `\.(jpg|m4a)$`,
		MaxSize:     10 * MiB,
		MimeTypes:   mediaMimeTypes,
		OrgInPath:   true,
	},
	{
		Name:        "document_files",
		Bucket:      "documents",
		PathPattern: `^` + uuidPart + `/` + uuidPart + `/` + uuidPart + `\.(jpg|pdf)$`,
		MaxSize:     20 * MiB,
		MimeTypes:   []string{"image/jpeg", "application/pdf"},
		OrgInPath:   true,
	},
	{
		Name:        "receipt_files",
		Bucket:      "receipts",
		PathPattern: `^` + uuidPart + `/` + uuidPart + `/` + uuidPart + `\.jpg$`,
		MaxSize:     10 * MiB,
		MimeTypes:   []string{"image/jpeg"},
		OrgInPath:   true,
	},
	{
		Name:        "feedback_files",
		Bucket:      "feedback",
		PathPattern: `^` + uuidPart + `/` + uuidPart + `\.jpg$`,
		MaxSize:     5 * MiB,
		MimeTypes:   []string{"image/jpeg"},
		OrgInPath:   true,
	},
	{
		Name:        "org_logo_files",
		Bucket:      "org-logos",
		PathPattern: `^` + uuidPart + `/` + uuidPart + `\.jpg$`,
		MaxSize:     2 * MiB,
		MimeTypes:   []string{"image/jpeg"},
		OrgInPath:   true,
	},
	{
		// `<lot_id>/<document_id>.pdf|jpg` (supabase/functions/lot-page).
		Name:        "public_lot_files",
		Bucket:      "public-lots",
		PathPattern: `^` + uuidPart + `/` + uuidPart + `\.(jpg|pdf)$`,
		MaxSize:     20 * MiB,
		MimeTypes:   []string{"image/jpeg", "application/pdf"},
		OrgInPath:   false,
	},
}

// pathPatterns are the compiled [Spec.PathPattern]s by collection name.
var pathPatterns = func() map[string]*regexp.Regexp {
	out := make(map[string]*regexp.Regexp, len(Specs))
	for _, s := range Specs {
		out[s.Name] = regexp.MustCompile(s.PathPattern)
	}
	return out
}()

// Names returns the file collection names in [Specs] order.
func Names() []string {
	out := make([]string, len(Specs))
	for i, s := range Specs {
		out[i] = s.Name
	}
	return out
}

// SpecFor returns the spec of a file collection.
func SpecFor(name string) (Spec, bool) {
	for _, s := range Specs {
		if s.Name == name {
			return s, true
		}
	}
	return Spec{}, false
}

// Error codes of [CheckPath], under data.<field>.code in a 400 response.
const (
	CodePathInvalid = "validation_path_invalid"
	CodeIDMismatch  = "validation_path_id_mismatch"
	CodeOrgMismatch = "validation_path_org_mismatch"
)

// CheckPath checks a record against its path: the path matches the bucket's
// pattern, the id is the last UUID of the path and, when [Spec.OrgInPath],
// org_id is the first folder. Supabase's insert policies passed only when
// the path's organization was one the user could write to; here the API
// rule checks the role against org_id, and this ties org_id to the path.
func CheckPath(s Spec, id, orgID, path string) validation.Errors {
	errs := validation.Errors{}
	if !pathPatterns[s.Name].MatchString(path) {
		errs[FieldPath] = validation.NewError(CodePathInvalid, "The path does not match the bucket's pattern.")
		return errs
	}
	parts := strings.Split(path, "/")
	last := parts[len(parts)-1]
	if id != last[:strings.IndexByte(last, '.')] {
		errs["id"] = validation.NewError(CodeIDMismatch, "The id must be the last UUID of the path.")
	}
	if s.OrgInPath && orgID != parts[0] {
		errs[FieldOrgID] = validation.NewError(CodeOrgMismatch, "org_id must be the first folder of the path.")
	}
	if len(errs) == 0 {
		return nil
	}
	return errs
}

// Register binds the path check to every save of a file collection, from
// the record API and from server code alike, and turns thumbnails off.
func Register(app core.App) {
	app.OnRecordValidate(Names()...).BindFunc(func(e *core.RecordEvent) error {
		s, _ := SpecFor(e.Record.Collection().Name)
		if errs := CheckPath(s, e.Record.Id, e.Record.GetString(FieldOrgID), e.Record.GetString(FieldPath)); errs != nil {
			return errs
		}
		return e.Next()
	})

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.BindFunc(dropThumb)
		return se.Next()
	})
}

// dropThumb removes the `thumb` query parameter from file downloads.
// PocketBase makes a thumbnail for any image when asked for its default
// 100x100 size even if the field lists no thumbs (apis/file.go), decoding
// the whole image in memory; the app never asks for one, so the original is
// served instead (RAM, P9.3).
func dropThumb(e *core.RequestEvent) error {
	if strings.HasPrefix(e.Request.URL.Path, "/api/files/") {
		q := e.Request.URL.Query()
		if q.Has("thumb") {
			q.Del("thumb")
			e.Request.URL.RawQuery = q.Encode()
		}
	}
	return e.Next()
}
