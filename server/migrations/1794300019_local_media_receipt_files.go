package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// Photos, voice notes and receipts stay on the phone too (2026-11-20),
// like document files (1794300018): media_files and receipt_files lose
// their stored files and all their API rules. The media and transactions
// rows still sync; only the files are local. The collections stay, empty;
// down opens them again without the deleted files.
func init() {
	m.Register(upLocalMediaReceiptFiles, downLocalMediaReceiptFiles)
}

var localFileCollections = []string{"media_files", "receipt_files"}

func upLocalMediaReceiptFiles(app core.App) error {
	for _, name := range localFileCollections {
		if err := closeFileCollection(app, name); err != nil {
			return err
		}
	}
	return nil
}

func downLocalMediaReceiptFiles(app core.App) error {
	for _, name := range localFileCollections {
		if err := reopenFileCollection(app, name); err != nil {
			return err
		}
	}
	return nil
}
