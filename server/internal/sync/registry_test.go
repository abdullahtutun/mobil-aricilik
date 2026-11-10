package sync_test

import (
	"slices"
	"testing"

	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
)

func TestRegistry(t *testing.T) {
	if got, want := appsync.Names(), []string{"organizations", "memberships"}; !slices.Equal(got, want) {
		t.Errorf("Names() = %v, want %v (pull order)", got, want)
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
