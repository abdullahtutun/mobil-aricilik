package sync_test

import (
	"slices"
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
