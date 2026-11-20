package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// Document files stay on the phone (2026-11-20): the app no longer uploads
// or downloads document_files, so its stored files are deleted and its API
// rules turn nil (no one may upload, list or view). The documents rows still
// sync; only the file is local. A published lot's analysis report reaches
// the lot page through the lot page's own upload route (internal/lotpage),
// straight into public_lot_files.
//
// The collection itself stays, empty: account deletion and the schema dump
// keep their shape, and down can open it again. The deleted files are not
// restored by down.
func init() {
	m.Register(upLocalDocumentFiles, downLocalDocumentFiles)
}

func upLocalDocumentFiles(app core.App) error {
	return closeFileCollection(app, "document_files")
}

func downLocalDocumentFiles(app core.App) error {
	return reopenFileCollection(app, "document_files")
}

// closeFileCollection deletes every record of the file collection (the
// stored files with them) and sets all its API rules to nil.
func closeFileCollection(app core.App, name string) error {
	return app.RunInTransaction(func(tx core.App) error {
		c, err := tx.FindCollectionByNameOrId(name)
		if err != nil {
			return err
		}
		records, err := tx.FindAllRecords(c)
		if err != nil {
			return err
		}
		for _, r := range records {
			// Deleting the record deletes its file after the commit.
			if err := tx.Delete(r); err != nil {
				return err
			}
		}
		apiRules{}.apply(c)
		return tx.Save(c)
	})
}

// reopenFileCollection puts back the collection's rules from
// 1794300012_file_collections.go.
func reopenFileCollection(app core.App, name string) error {
	c, err := app.FindCollectionByNameOrId(name)
	if err != nil {
		return err
	}
	fileRules[name].apply(c)
	return app.Save(c)
}
