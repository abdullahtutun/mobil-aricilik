package migrations

import (
	"slices"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	"github.com/pocketbase/pocketbase/core"
)

func TestFileCollectionShapes(t *testing.T) {
	app := newApp(t)

	want := map[string]struct {
		maxSize int64
		mimes   []string
	}{
		"media_files":      {10 << 20, []string{"image/jpeg", "audio/mp4", "audio/x-m4a", "video/mp4"}},
		"document_files":   {20 << 20, []string{"image/jpeg", "application/pdf"}},
		"receipt_files":    {10 << 20, []string{"image/jpeg"}},
		"feedback_files":   {5 << 20, []string{"image/jpeg"}},
		"org_logo_files":   {2 << 20, []string{"image/jpeg"}},
		"public_lot_files": {20 << 20, []string{"image/jpeg", "application/pdf"}},
	}
	if len(want) != len(files.Specs) {
		t.Fatalf("%d cases for %d specs", len(want), len(files.Specs))
	}

	for name, w := range want {
		t.Run(name, func(t *testing.T) {
			c, err := app.FindCollectionByNameOrId(name)
			if err != nil {
				t.Fatal(err)
			}
			fields := fieldSpec{"id": "text!", "org_id": "text!", "path": "text!", "file": "file!", "created": "autodate"}
			if got := describeFields(c); !mapsEqual(got, fields) {
				t.Errorf("fields\n got  %v\n want %v", got, fields)
			}
			indexes := []string{"idx_" + name + "_org_id||org_id|", "idx_" + name + "_path|unique|path|"}
			if got := describeIndexes(c); !slices.Equal(got, indexes) {
				t.Errorf("indexes\n got  %q\n want %q", got, indexes)
			}
			f := c.Fields.GetByName("file").(*core.FileField)
			if f.MaxSize != w.maxSize || !slices.Equal(f.MimeTypes, w.mimes) {
				t.Errorf("file maxSize %d mimes %v, want %d %v", f.MaxSize, f.MimeTypes, w.maxSize, w.mimes)
			}
			if !f.Protected || f.MaxSelect != 1 || len(f.Thumbs) != 0 {
				t.Errorf("file protected=%v maxSelect=%d thumbs=%v, want protected, one file, no thumbs", f.Protected, f.MaxSelect, f.Thumbs)
			}
			created := mustAutodate(t, app, name, "created")
			if !created.OnCreate || created.OnUpdate {
				t.Errorf("created onCreate=%v onUpdate=%v", created.OnCreate, created.OnUpdate)
			}
			id := c.Fields.GetByName("id").(*core.TextField)
			if id.Min != 36 || id.Max != 36 || id.AutogeneratePattern != "" {
				t.Errorf("id is not the UUID primary key (K-4): %+v", id)
			}
			// Supabase had no update or delete policy on any bucket.
			if c.UpdateRule != nil || c.DeleteRule != nil {
				t.Error("update or delete rule is open")
			}
		})
	}
}

func TestFilePathPatterns(t *testing.T) {
	const (
		u1 = "0195f2a4-1111-7000-8000-000000000001"
		u2 = "0195f2a4-2222-7000-8000-000000000002"
		u3 = "0195f2a4-3333-7000-8000-000000000003"
	)
	app := newApp(t)
	cases := []struct {
		collection, path string
		ok               bool
	}{
		{"media_files", u1 + "/" + u2 + "/" + u3 + ".jpg", true},
		{"media_files", u1 + "/" + u2 + "/" + u3 + ".m4a", true},
		{"media_files", u1 + "/" + u2 + "/" + u3 + ".pdf", false},
		{"media_files", u1 + "/" + u3 + ".jpg", false},
		{"document_files", u1 + "/" + u2 + "/" + u3 + ".pdf", true},
		{"document_files", u1 + "/" + u2 + "/" + u3 + ".m4a", false},
		{"receipt_files", u1 + "/" + u2 + "/" + u3 + ".jpg", true},
		{"receipt_files", u1 + "/" + u2 + "/" + u3 + ".pdf", false},
		{"feedback_files", u1 + "/" + u3 + ".jpg", true},
		{"feedback_files", u1 + "/" + u2 + "/" + u3 + ".jpg", false},
		{"org_logo_files", u1 + "/" + u3 + ".jpg", true},
		{"org_logo_files", "../" + u3 + ".jpg", false},
		{"public_lot_files", u1 + "/" + u3 + ".pdf", true},
		{"public_lot_files", u1 + "/" + u3 + ".JPG", false},
		{"media_files", "0195F2A4-1111-7000-8000-000000000001/" + u2 + "/" + u3 + ".jpg", false},
	}
	for _, tc := range cases {
		c, err := app.FindCollectionByNameOrId(tc.collection)
		if err != nil {
			t.Fatal(err)
		}
		field := c.Fields.GetByName("path").(*core.TextField)
		r := core.NewRecord(c)
		r.Set("path", tc.path)
		err = field.ValidateValue(t.Context(), app, r)
		if (err == nil) != tc.ok {
			t.Errorf("%s %q: err = %v, want ok=%v", tc.collection, tc.path, err, tc.ok)
		}
	}
}

func TestDownFileCollections(t *testing.T) {
	app := newApp(t)
	if err := downFileCollections(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range files.Names() {
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}
	if !app.HasTable("feedback") {
		t.Error("down removed another collection")
	}
	if err := upFileCollections(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
