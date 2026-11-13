package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// The file collections (P6.1, K-13): one per Supabase storage bucket, from
// files.Specs (path pattern, size limit, MIME types). A record is uploaded
// on its own, independent of the row that points to it, as the upload queue
// does today.
//
// Fields: id (the last UUID of the path, K-4), org_id, path (the Supabase
// storage_path, unique, the bucket's pattern), file (one protected file:
// downloading needs a file token and passes the view rule) and created.
// internal/files.Register checks on every save that id and org_id agree with
// the path. No thumbnails: the field lists none and internal/files drops
// the `thumb` parameter.
//
// API rules, from the Supabase storage policies. Every rule names one
// memberships alias, so user, organization, live and role hold on the same
// membership row (as feedback's create rule, P3.2):
//
//   - media_files, document_files: members view; owner, partner, worker
//     upload.
//   - receipt_files: owner and partner view and upload.
//   - org_logo_files: members view; owner and partner upload.
//   - feedback_files: any member uploads, viewer included. No read: the
//     Supabase bucket had no select policy either; the feedback mail
//     (P5.7) reads it as server code.
//   - public_lot_files: all nil; the lot page (P5.10) writes and serves it.
//   - Update and delete are nil everywhere; Supabase had no such policies.
//     Account deletion (P5.9) removes files as server code.
//
// A second upload with the same id is rejected with 400 and
// data.id.code = "validation_pk_invalid"; the client takes that as "already
// uploaded" (Supabase answered 409). A refused rule is also 400, but with
// empty data. files_test.go pins both.
func init() {
	m.Register(upFileCollections, downFileCollections)
}

// Rule pieces. memberOf: a live membership in the record's organization.
const (
	ruleMemberOf = `@request.auth.id != "" && ` +
		`@collection.memberships:m.user_id ?= @request.auth.id && ` +
		`@collection.memberships:m.org_id ?= org_id && ` +
		`@collection.memberships:m.deleted_at ?= ""`
	ruleWriters = ruleMemberOf + ` && (` +
		`@collection.memberships:m.role ?= "owner" || ` +
		`@collection.memberships:m.role ?= "partner" || ` +
		`@collection.memberships:m.role ?= "worker")`
	ruleManagers = ruleMemberOf + ` && (` +
		`@collection.memberships:m.role ?= "owner" || ` +
		`@collection.memberships:m.role ?= "partner")`
)

// fileRules are the API rules per file collection; a missing one is nil.
var fileRules = map[string]apiRules{
	"media_files": {
		list: types.Pointer(ruleMemberOf), view: types.Pointer(ruleMemberOf),
		create: types.Pointer(ruleWriters),
	},
	"document_files": {
		list: types.Pointer(ruleMemberOf), view: types.Pointer(ruleMemberOf),
		create: types.Pointer(ruleWriters),
	},
	"receipt_files": {
		list: types.Pointer(ruleManagers), view: types.Pointer(ruleManagers),
		create: types.Pointer(ruleManagers),
	},
	"feedback_files": {create: types.Pointer(ruleMemberOf)},
	"org_logo_files": {
		list: types.Pointer(ruleMemberOf), view: types.Pointer(ruleMemberOf),
		create: types.Pointer(ruleManagers),
	},
	"public_lot_files": {},
}

// fileCollection builds one bucket's collection.
func fileCollection(s files.Spec) *core.Collection {
	c := core.NewBaseCollection(s.Name)
	useUUIDPrimaryKey(c)
	c.Fields.Add(
		uuidField(files.FieldOrgID, true),
		// Supabase object names are at most 1024 bytes; the longest pattern
		// here is 3 UUIDs and an extension.
		&core.TextField{Name: files.FieldPath, Required: true, Max: 120, Pattern: s.PathPattern},
		&core.FileField{
			Name:      files.FieldFile,
			Required:  true,
			MaxSelect: 1,
			MaxSize:   s.MaxSize,
			MimeTypes: s.MimeTypes,
			Protected: true,
		},
		&core.AutodateField{Name: files.FieldCreated, OnCreate: true},
	)
	c.AddIndex("idx_"+s.Name+"_path", true, "`path`", "")
	c.AddIndex("idx_"+s.Name+"_org_id", false, "`org_id`", "")
	fileRules[s.Name].apply(c)
	return c
}

func upFileCollections(app core.App) error {
	for _, s := range files.Specs {
		if err := app.Save(fileCollection(s)); err != nil {
			return err
		}
	}
	return nil
}

func downFileCollections(app core.App) error {
	for i := len(files.Specs) - 1; i >= 0; i-- {
		c, err := app.FindCollectionByNameOrId(files.Specs[i].Name)
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
