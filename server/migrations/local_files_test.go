package migrations

import (
	"testing"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/filesystem"
)

func TestLocalDocumentFiles(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId("document_files")
	if err != nil {
		t.Fatal(err)
	}
	for name, rule := range map[string]*string{
		"list": c.ListRule, "view": c.ViewRule, "create": c.CreateRule,
		"update": c.UpdateRule, "delete": c.DeleteRule,
	} {
		if rule != nil {
			t.Errorf("document_files.%s = %q, want nil", name, *rule)
		}
	}

	// A file stored before the migration (down → upload → up) is deleted.
	if err := downLocalDocumentFiles(app); err != nil {
		t.Fatal(err)
	}
	c, err = app.FindCollectionByNameOrId("document_files")
	if err != nil {
		t.Fatal(err)
	}
	if c.CreateRule == nil || *c.CreateRule != ruleWriters {
		t.Errorf("down: create rule %v", c.CreateRule)
	}
	const org, doc, file = "0194a3b2-0000-7000-8000-000000000001", "0194a3b2-0000-7000-8000-000000000002", "0194a3b2-0000-7000-8000-000000000003"
	pdf, err := filesystem.NewFileFromBytes([]byte("%PDF-1.4\n%%EOF\n"), "a.pdf")
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = file
	r.Set("org_id", org)
	r.Set("path", org+"/"+doc+"/"+file+".pdf")
	r.Set("file", pdf)
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}

	if err := upLocalDocumentFiles(app); err != nil {
		t.Fatal(err)
	}
	if n, err := app.CountRecords("document_files"); err != nil || n != 0 {
		t.Errorf("records after up: %d (%v)", n, err)
	}
	c, err = app.FindCollectionByNameOrId("document_files")
	if err != nil {
		t.Fatal(err)
	}
	if c.ListRule != nil || c.ViewRule != nil || c.CreateRule != nil {
		t.Error("up left a rule open")
	}
}

func TestLocalMediaReceiptFiles(t *testing.T) {
	app := newApp(t)
	for _, name := range localFileCollections {
		c, err := app.FindCollectionByNameOrId(name)
		if err != nil {
			t.Fatal(err)
		}
		if c.ListRule != nil || c.ViewRule != nil || c.CreateRule != nil || c.UpdateRule != nil || c.DeleteRule != nil {
			t.Errorf("%s has an open rule", name)
		}
	}

	if err := downLocalMediaReceiptFiles(app); err != nil {
		t.Fatal(err)
	}
	const org, hive, id = "0194a3b2-0000-7000-8000-000000000001", "0194a3b2-0000-7000-8000-000000000002", "0194a3b2-0000-7000-8000-000000000003"
	jpeg, err := filesystem.NewFileFromBytes([]byte{0xFF, 0xD8, 0xFF, 0xE0, 0, 0x10, 'J', 'F', 'I', 'F', 0}, "a.jpg")
	if err != nil {
		t.Fatal(err)
	}
	for _, name := range localFileCollections {
		c, err := app.FindCollectionByNameOrId(name)
		if err != nil {
			t.Fatal(err)
		}
		if c.CreateRule == nil {
			t.Errorf("down: %s create rule nil", name)
		}
		r := core.NewRecord(c)
		r.Id = id
		r.Set("org_id", org)
		r.Set("path", org+"/"+hive+"/"+id+".jpg")
		r.Set("file", jpeg)
		if err := app.Save(r); err != nil {
			t.Fatalf("%s: %v", name, err)
		}
	}

	if err := upLocalMediaReceiptFiles(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range localFileCollections {
		if n, err := app.CountRecords(name); err != nil || n != 0 {
			t.Errorf("%s records after up: %d (%v)", name, n, err)
		}
	}
}
