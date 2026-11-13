package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// P9.3: every collection with the UUID id pattern (K-4) gets an index on
// `id COLLATE NOCASE`.
//
// PocketBase v0.40.6 (core/field_text.go, TextField.ValidateValue) checks a
// new record's id against the table with `id = {:id} COLLATE NOCASE`
// whenever the id pattern is not its default `^[a-z0-9]+$`. The primary
// key index is BINARY, so without this index every insert scanned the
// whole table: on dev, 50 accounts x 2000 rows made a 100-row push take
// 10 s (p50) and 49 s (p95), growing with the table.
func init() {
	m.Register(upIDNocaseIndex, downIDNocaseIndex)
}

// defaultIDPattern is PocketBase's own id pattern; collections with it are
// not checked case-insensitively.
const defaultIDPattern = "^[a-z0-9]+$"

// IDNocaseIndexName is the index on `id COLLATE NOCASE` of a collection.
func IDNocaseIndexName(collection string) string {
	return "idx_" + collection + "_id_nocase"
}

// NeedsIDNocaseIndex reports whether inserts into c check the id
// case-insensitively.
func NeedsIDNocaseIndex(c *core.Collection) bool {
	if c.IsView() {
		return false
	}
	id, ok := c.Fields.GetByName(core.FieldNameId).(*core.TextField)
	return ok && id.PrimaryKey && id.Pattern != defaultIDPattern
}

func upIDNocaseIndex(app core.App) error {
	cs, err := app.FindAllCollections()
	if err != nil {
		return err
	}
	for _, c := range cs {
		if !NeedsIDNocaseIndex(c) || c.GetIndex(IDNocaseIndexName(c.Name)) != "" {
			continue
		}
		c.AddIndex(IDNocaseIndexName(c.Name), false, "`id` COLLATE NOCASE", "")
		if err := app.Save(c); err != nil {
			return err
		}
	}
	return nil
}

func downIDNocaseIndex(app core.App) error {
	cs, err := app.FindAllCollections()
	if err != nil {
		return err
	}
	for _, c := range cs {
		if c.GetIndex(IDNocaseIndexName(c.Name)) == "" {
			continue
		}
		c.RemoveIndex(IDNocaseIndexName(c.Name))
		if err := app.Save(c); err != nil {
			return err
		}
	}
	return nil
}
