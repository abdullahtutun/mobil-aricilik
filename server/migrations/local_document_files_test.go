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
