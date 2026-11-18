package migrations

import (
	"slices"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

func documentTypeValues(t *testing.T, app core.App) []string {
	t.Helper()
	_, f, err := documentTypeField(app)
	if err != nil {
		t.Fatal(err)
	}
	if f == nil {
		t.Fatal("documents.type is not a select")
	}
	return f.Values
}

func TestDocumentTypeInsurance(t *testing.T) {
	app := newApp(t)
	if !slices.Contains(documentTypeValues(t, app), documentTypeInsurance) {
		t.Fatal("documents.type has no insurance")
	}
	// up is idempotent.
	if err := upDocumentTypeInsurance(app); err != nil {
		t.Fatal(err)
	}
	if n := len(slices.DeleteFunc(slices.Clone(documentTypeValues(t, app)), func(v string) bool {
		return v != documentTypeInsurance
	})); n != 1 {
		t.Fatalf("insurance appears %d times", n)
	}

	orgID := "0194a3b2-0000-7000-8000-000000000001"
	docID := "0194a3b2-0000-7000-8000-000000000002"
	if _, err := app.DB().NewQuery(
		"INSERT INTO documents (id, org_id, type, name, file_kind, storage_path, byte_size) " +
			"VALUES ('" + docID + "', '" + orgID + "', 'insurance', 'Kovan sigortası', 'pdf', 'x', 1)",
	).Execute(); err != nil {
		t.Fatal(err)
	}

	if err := downDocumentTypeInsurance(app); err != nil {
		t.Fatal(err)
	}
	if slices.Contains(documentTypeValues(t, app), documentTypeInsurance) {
		t.Fatal("down kept insurance")
	}
	if !slices.Contains(documentTypeValues(t, app), "custom") {
		t.Fatal("down removed another value")
	}
	var row struct {
		Type           string `db:"type"`
		CustomTypeName string `db:"custom_type_name"`
	}
	if err := app.DB().NewQuery("SELECT type, custom_type_name FROM documents WHERE id = '" + docID + "'").One(&row); err != nil {
		t.Fatal(err)
	}
	if row.Type != "custom" || row.CustomTypeName != "Insurance" {
		t.Fatalf("row after down = %+v, want custom Insurance", row)
	}

	if err := upDocumentTypeInsurance(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
