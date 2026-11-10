package migrations

import (
	"maps"
	"slices"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

// expectedOpenRules is every non-nil API rule of every collection, system
// collections included. Counterpart of the RLS half of rls_enabled.test.sql:
// a rule opened anywhere else, or changed here, breaks TestNoUnexpectedRules.
// Key: "<collection>.<list|view|create|update|delete>".
var expectedOpenRules = map[string]string{
	// P3.2 (1794300010_api_rules.go).
	"users.list":              `@request.auth.id != "" && id = @request.auth.id`,
	"users.view":              `@request.auth.id != "" && id = @request.auth.id`,
	"feedback.create":         `@request.auth.id != "" && created_by = @request.auth.id && @collection.memberships:own.user_id ?= @request.auth.id && @collection.memberships:own.org_id ?= org_id && @collection.memberships:own.deleted_at ?= ""`,
	"analytics_events.create": `@request.auth.id != ""`,
	"deletion_requests.list":  `@request.auth.id != "" && user_id = @request.auth.id`,
	"deletion_requests.view":  `@request.auth.id != "" && user_id = @request.auth.id`,
	"device_tokens.list":      `@request.auth.id != "" && user_id = @request.auth.id`,
	"device_tokens.view":      `@request.auth.id != "" && user_id = @request.auth.id`,

	// PocketBase's own system collections (1640988000_init), unchanged: a
	// user sees, and for the last two deletes, only their own entries.
	"_mfas.list":            pbOwnerRule,
	"_mfas.view":            pbOwnerRule,
	"_otps.list":            pbOwnerRule,
	"_otps.view":            pbOwnerRule,
	"_externalAuths.list":   pbOwnerRule,
	"_externalAuths.view":   pbOwnerRule,
	"_externalAuths.delete": pbOwnerRule,
	"_authOrigins.list":     pbOwnerRule,
	"_authOrigins.view":     pbOwnerRule,
	"_authOrigins.delete":   pbOwnerRule,
}

const pbOwnerRule = "@request.auth.id != '' && recordRef = @request.auth.id && collectionRef = @request.auth.collectionId"

// openRules returns the non-nil rules of every collection, keyed like
// [expectedOpenRules].
func openRules(t *testing.T, app core.App) map[string]string {
	t.Helper()
	all, err := app.FindAllCollections()
	if err != nil {
		t.Fatal(err)
	}
	got := map[string]string{}
	for _, c := range all {
		for action, rule := range map[string]*string{
			"list": c.ListRule, "view": c.ViewRule, "create": c.CreateRule,
			"update": c.UpdateRule, "delete": c.DeleteRule,
		} {
			if rule != nil {
				got[c.Name+"."+action] = *rule
			}
		}
	}
	return got
}

func TestNoUnexpectedRules(t *testing.T) {
	app := newApp(t)
	got := openRules(t, app)

	for _, key := range slices.Sorted(maps.Keys(got)) {
		rule := got[key]
		// "" lets anyone, signed in or not, through.
		if rule == "" {
			t.Errorf("%s is public (\"\")", key)
			continue
		}
		want, ok := expectedOpenRules[key]
		switch {
		case !ok:
			t.Errorf("%s = %q, want nil (not in expectedOpenRules)", key, rule)
		case rule != want:
			t.Errorf("%s\n got  %q\n want %q", key, rule, want)
		}
	}
	for _, key := range slices.Sorted(maps.Keys(expectedOpenRules)) {
		if _, ok := got[key]; !ok {
			t.Errorf("%s is nil, want %q", key, expectedOpenRules[key])
		}
	}
}

// The test above must see every collection: a sync collection, an unsynced
// one and a system one are among those it walked.
func TestNoUnexpectedRulesWalksAll(t *testing.T) {
	app := newApp(t)
	all, err := app.FindAllCollections()
	if err != nil {
		t.Fatal(err)
	}
	var names []string
	for _, c := range all {
		names = append(names, c.Name)
	}
	for _, want := range []string{"hives", "deletion_log", core.CollectionNameSuperusers, "users"} {
		if !slices.Contains(names, want) {
			t.Errorf("%s not among the collections", want)
		}
	}
}

// Auth collections have two more rules: users may authenticate (authRule
// "", PocketBase's default), and nobody manages another user (manageRule).
func TestAuthCollectionRules(t *testing.T) {
	app := newApp(t)
	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	if users.AuthRule == nil || *users.AuthRule != "" {
		t.Errorf("users authRule = %v, want \"\"", users.AuthRule)
	}
	if users.ManageRule != nil {
		t.Errorf("users manageRule = %q, want nil", *users.ManageRule)
	}
}

func TestDownAPIRules(t *testing.T) {
	app := newApp(t)
	if err := downAPIRules(app); err != nil {
		t.Fatal(err)
	}
	got := openRules(t, app)
	for _, name := range []string{"feedback", "analytics_events", "deletion_requests", "device_tokens"} {
		for _, action := range []string{"list", "view", "create", "update", "delete"} {
			if r, ok := got[name+"."+action]; ok {
				t.Errorf("%s.%s = %q after down, want nil", name, action, r)
			}
		}
	}
	// users is back to PocketBase's default, as before P3.2.
	if got["users.create"] != "" || got["users.update"] != "id = @request.auth.id" {
		t.Errorf("users rules after down: create %q, update %q", got["users.create"], got["users.update"])
	}
	if err := upAPIRules(app); err != nil {
		t.Fatal(err)
	}
	if got := openRules(t, app); !maps.Equal(got, expectedOpenRules) {
		t.Errorf("rules after up again differ:\n%v", got)
	}
}
