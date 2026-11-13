package migrations

import (
	"strings"
	"testing"

	"github.com/pocketbase/dbx"
)

// Every collection whose inserts PocketBase checks with
// `id = ? COLLATE NOCASE` has the index, and SQLite uses it instead of
// scanning the table (P9.3: without it a push slowed down with the table).
func TestIDNocaseIndexOnEveryUUIDCollection(t *testing.T) {
	app := newApp(t)
	cs, err := app.FindAllCollections()
	if err != nil {
		t.Fatal(err)
	}
	checked := 0
	for _, c := range cs {
		if !NeedsIDNocaseIndex(c) {
			continue
		}
		checked++
		if c.GetIndex(IDNocaseIndexName(c.Name)) == "" {
			t.Errorf("%s: no %s", c.Name, IDNocaseIndexName(c.Name))
			continue
		}
		// The query of core.TextField.ValidateValue (v0.40.6).
		var plan []struct {
			Detail string `db:"detail"`
		}
		err := app.DB().NewQuery("EXPLAIN QUERY PLAN SELECT (1) FROM {{" + c.Name + "}} WHERE id = {:id} COLLATE NOCASE LIMIT 1").
			Bind(dbx.Params{"id": "0195f2a4-0000-7000-8000-000000000001"}).
			All(&plan)
		if err != nil {
			t.Fatalf("%s: %v", c.Name, err)
		}
		var details []string
		for _, p := range plan {
			details = append(details, p.Detail)
		}
		if got := strings.Join(details, "; "); !strings.Contains(got, IDNocaseIndexName(c.Name)) {
			t.Errorf("%s: plan %q does not use the index", c.Name, got)
		}
	}
	// 35 synced collections, the unsynced ones, files and users.
	if checked < 40 {
		t.Errorf("only %d collections checked", checked)
	}
}
