package migrations

import (
	"slices"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	"github.com/pocketbase/pocketbase/core"
)

func TestKnowledgePacksShape(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId(knowledgePacksName)
	if err != nil {
		t.Fatal(err)
	}
	fields := fieldSpec{"id": "text!", "name": "text!", "file": "file!"}
	if got := describeFields(c); !mapsEqual(got, fields) {
		t.Errorf("fields\n got  %v\n want %v", got, fields)
	}
	indexes := []string{"idx_knowledge_packs_name|unique|name|"}
	if got := describeIndexes(c); !slices.Equal(got, indexes) {
		t.Errorf("indexes\n got  %q\n want %q", got, indexes)
	}
	f := c.Fields.GetByName("file").(*core.FileField)
	if f.MaxSize != 10*files.MiB || !slices.Equal(f.MimeTypes, []string{"application/json"}) ||
		f.Protected || f.MaxSelect != 1 || len(f.Thumbs) != 0 {
		t.Errorf("file field %+v", f)
	}
	id := c.Fields.GetByName("id").(*core.TextField)
	if id.Min != 36 || id.Max != 36 || id.AutogeneratePattern != "" {
		t.Errorf("id is not the UUID primary key (K-4): %+v", id)
	}
	if c.CreateRule != nil || c.UpdateRule != nil || c.DeleteRule != nil {
		t.Error("a write rule is open")
	}

	name := c.Fields.GetByName("name").(*core.TextField)
	for v, ok := range map[string]bool{
		"manifest.json": true, "knowledge-v1.json": true, "knowledge-v42.json": true,
		"knowledge-v0.json": false, "knowledge-v01.json": false, "knowledge.json": false,
		"../manifest.json": false, "Manifest.json": false, "knowledge-v2.json.bak": false,
	} {
		r := core.NewRecord(c)
		r.Set("name", v)
		if err := name.ValidateValue(t.Context(), app, r); (err == nil) != ok {
			t.Errorf("name %q: err = %v, want ok=%v", v, err, ok)
		}
	}
}

func TestDownKnowledgePacks(t *testing.T) {
	app := newApp(t)
	if err := downKnowledgePacks(app); err != nil {
		t.Fatal(err)
	}
	if app.HasTable(knowledgePacksName) {
		t.Error("table still exists")
	}
	if err := upKnowledgePacks(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
