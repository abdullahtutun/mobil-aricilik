package validate

import (
	"fmt"
	"regexp"
)

// Checks of documents (20261027180000).

// documentFilePart is the file name part Supabase accepts in a documents
// path: 36 characters of hex digits and hyphens (documents_check1 and
// private.document_object_org_id), looser than a UUID.
const documentFilePart = `[0-9a-f-]{36}`

// DocumentStoragePath is the shape of documents.storage_path:
// `<org_id>/<id>/<file_id>.jpg|pdf`, the object name Supabase's
// private.document_object_org_id accepted, with the first two folders
// lower-case UUIDs as documents_check1 produces them. The migration uses it
// as the field pattern; [DocumentsCheck1] ties the parts to the row.
var DocumentStoragePath = "^" + uuidPart + "/" + uuidPart + "/" + documentFilePart + `\.(jpg|pdf)$`

// DocumentsCheck is documents_check: custom_type_name is set exactly for
// type custom.
func DocumentsCheck(docType, customTypeName string) error {
	if (docType == "custom") != (customTypeName != "") {
		return fmt.Errorf("custom_type_name must be set exactly for type custom, type is %q", docType)
	}
	return nil
}

// DocumentsCheck1 is documents_check1: storage_path is
// `<org_id>/<id>/<file_id>.<ext>`, jpg for a photo and pdf for a PDF, so a
// row cannot point at another organization's or document's folder. A new
// file gets a new file_id; the old object stays (no update in the bucket).
func DocumentsCheck1(id, orgID, fileKind, storagePath string) error {
	ext := "pdf"
	if fileKind == "photo" {
		ext = "jpg"
	}
	re := regexp.MustCompile("^" + regexp.QuoteMeta(orgID+"/"+id+"/") + documentFilePart + `\.` + ext + "$")
	if !re.MatchString(storagePath) {
		return fmt.Errorf("storage_path must be %s/%s/<file_id>.%s, got %s", orgID, id, ext, storagePath)
	}
	return nil
}

// DocumentsCustomTypeNameCheck is documents_custom_type_name_check: null, or
// 1–60 characters after trimming spaces.
func DocumentsCustomTypeNameCheck(customTypeName string) error {
	return btrimLength("custom_type_name", customTypeName, true, 1, 60)
}

// DocumentsNameCheck is documents_name_check: 1–120 characters after
// trimming spaces.
func DocumentsNameCheck(name string) error {
	return btrimLength("name", name, false, 1, 120)
}
