package sync_test

import (
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"strings"
	"testing"

	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
)

func TestRegistry(t *testing.T) {
	want := []string{
		"organizations", "memberships",
		"apiaries", "queens", "hives", "hive_location_history", "hive_status_events",
		"inspections", "media", "mite_counts", "ref_drugs", "drugs", "treatments", "feedings",
		"tasks", "harvests", "harvest_hives", "documents",
		"migrations", "migration_stops", "transports", "transport_items",
		"inventory_items", "inventory_moves", "queen_rearing_batches", "mating_nucs",
		"lots", "lot_harvests", "lot_treatments", "lab_results", "lot_sales",
		"customers", "transactions", "customer_payments", "ref_support_periods",
	}
	if len(want) != 35 {
		t.Fatalf("want lists %d tables, the client syncs 35", len(want))
	}
	if got := appsync.Names(); !slices.Equal(got, want) {
		t.Errorf("Names() = %v, want %v (pull order)", got, want)
	}

	// Kinds of Supabase's private.sync_push_change.
	wantKinds := map[string]appsync.Kind{
		"organizations":         appsync.KindOrganization,
		"memberships":           appsync.KindOwnMembership,
		"apiaries":              appsync.KindState,
		"queens":                appsync.KindState,
		"hives":                 appsync.KindState,
		"hive_location_history": appsync.KindEvent,
		"hive_status_events":    appsync.KindEvent,
		"inspections":           appsync.KindEvent,
		"media":                 appsync.KindEvent,
		"mite_counts":           appsync.KindEvent,
		"ref_drugs":             appsync.KindReference,
		"drugs":                 appsync.KindState,
		"treatments":            appsync.KindEvent,
		"feedings":              appsync.KindEvent,
		"tasks":                 appsync.KindState,
		"harvests":              appsync.KindEvent,
		"harvest_hives":         appsync.KindEvent,
		"documents":             appsync.KindState,
		"migrations":            appsync.KindState,
		"migration_stops":       appsync.KindState,
		"transports":            appsync.KindState,
		"transport_items":       appsync.KindState,
		"inventory_items":       appsync.KindState,
		"inventory_moves":       appsync.KindEvent,
		"queen_rearing_batches": appsync.KindState,
		"mating_nucs":           appsync.KindState,
		"lots":                  appsync.KindState,
		"lot_harvests":          appsync.KindEvent,
		"lot_treatments":        appsync.KindEvent,
		"lab_results":           appsync.KindEvent,
		"lot_sales":             appsync.KindEvent,
		"customers":             appsync.KindState,
		"transactions":          appsync.KindEvent,
		"customer_payments":     appsync.KindEvent,
		"ref_support_periods":   appsync.KindReference,
	}
	if len(wantKinds) != len(want) {
		t.Errorf("wantKinds has %d tables, want %d", len(wantKinds), len(want))
	}
	for name, kind := range wantKinds {
		if tbl, ok := appsync.Lookup(name); !ok || tbl.Kind != kind {
			t.Errorf("Lookup(%s) = %v, %v; want kind %q", name, tbl, ok, kind)
		}
	}

	kinds := map[appsync.Kind]bool{
		appsync.KindState: true, appsync.KindEvent: true, appsync.KindOrganization: true,
		appsync.KindOwnMembership: true, appsync.KindReference: true,
	}
	seen := map[string]bool{}
	for _, tbl := range appsync.Tables {
		if seen[tbl.Name] {
			t.Errorf("%s listed twice", tbl.Name)
		}
		seen[tbl.Name] = true
		if !kinds[tbl.Kind] {
			t.Errorf("%s has unknown kind %q", tbl.Name, tbl.Kind)
		}
	}

	if tbl, ok := appsync.Lookup("memberships"); !ok || tbl.Kind != appsync.KindOwnMembership {
		t.Errorf("Lookup(memberships) = %v, %v", tbl, ok)
	}
	if _, ok := appsync.Lookup("users"); ok {
		t.Error("users is not synced")
	}
}

// Every listed table is a migrated collection with the sync columns.
func TestRegistryMatchesSchema(t *testing.T) {
	app := newApp(t)
	for _, tbl := range appsync.Tables {
		c, err := app.FindCollectionByNameOrId(tbl.Name)
		if err != nil {
			t.Errorf("%s: %v", tbl.Name, err)
			continue
		}
		seq, ok := c.Fields.GetByName(appsync.FieldServerSeq).(*core.NumberField)
		if !ok || !seq.Required || !seq.OnlyInt {
			t.Errorf("%s: server_seq missing or not a required integer", tbl.Name)
		}
		if c.Fields.GetByName("updated_at") == nil || c.Fields.GetByName("deleted_at") == nil {
			t.Errorf("%s: sync time fields missing", tbl.Name)
		}
	}
}

// The registry is SyncService.pullTables of the client, name by name and in
// order: lib/core/sync/sync_service.dart lists `_db.<camelCase>` getters,
// whose snake_case names are the table names.
func TestRegistryMatchesPullTables(t *testing.T) {
	src, err := os.ReadFile(filepath.Join("..", "..", "..", "lib", "core", "sync", "sync_service.dart"))
	if err != nil {
		t.Fatal(err)
	}
	block := regexp.MustCompile(`(?s)get pullTables => \[(.*?)\];`).FindSubmatch(src)
	if block == nil {
		t.Fatal("pullTables not found in sync_service.dart")
	}
	var dart []string
	for _, m := range regexp.MustCompile(`_db\.(\w+)`).FindAllSubmatch(block[1], -1) {
		dart = append(dart, snakeCase(string(m[1])))
	}
	if len(dart) != 35 {
		t.Errorf("pullTables has %d tables, want 35", len(dart))
	}
	if got := appsync.Names(); !slices.Equal(got, dart) {
		t.Errorf("Names() = %v\npullTables = %v", got, dart)
	}
}

func snakeCase(s string) string {
	var b strings.Builder
	for _, r := range s {
		if r >= 'A' && r <= 'Z' {
			b.WriteByte('_')
			r += 'a' - 'A'
		}
		b.WriteRune(r)
	}
	return b.String()
}
