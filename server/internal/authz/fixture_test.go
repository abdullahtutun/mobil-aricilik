package authz_test

import (
	"slices"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// The users and organizations of the pgTAP RLS tests, same ids.
const (
	owner    = "11111111-1111-1111-1111-111111111111"
	partner  = "22222222-2222-2222-2222-222222222222"
	worker   = "33333333-3333-3333-3333-333333333333"
	newcomer = "44444444-4444-4444-4444-444444444444"
	viewer   = "55555555-5555-5555-5555-555555555555"
	removed  = "66666666-6666-6666-6666-666666666666"
	outsider = "99999999-9999-9999-9999-999999999999"
	anon     = ""

	// orgA is Petek Arıcılık: owner, partner, worker, viewer, and removed
	// (a worker whose membership has deleted_at set). orgE is the other
	// organization: outsider is its owner.
	orgA = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	orgE = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"

	testTime    = "2026-11-10T10:15:30.123456Z"
	removedTime = "2026-11-10T11:00:00.000000Z"
)

// Compile-time check: the pull route hands records to CanSeeRow.
var _ authz.Row = (*core.Record)(nil)

func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	appsync.RegisterSeq(app)
	return app
}

// fixture is newApp plus the memberships of orgA and orgE; it returns the
// saved membership records by user.
func fixture(t *testing.T) (*tests.TestApp, map[string]*core.Record) {
	t.Helper()
	app := newApp(t)
	rows := []struct {
		id, org, user string
		role          authz.Role
		deletedAt     string
	}{
		{"c0000000-0000-0000-0000-000000000001", orgA, owner, authz.Owner, ""},
		{"c0000000-0000-0000-0000-000000000002", orgA, partner, authz.Partner, ""},
		{"c0000000-0000-0000-0000-000000000003", orgA, worker, authz.Worker, ""},
		{"c0000000-0000-0000-0000-000000000005", orgA, viewer, authz.Viewer, ""},
		{"c0000000-0000-0000-0000-000000000006", orgA, removed, authz.Worker, removedTime},
		{"c0000000-0000-0000-0000-000000000009", orgE, outsider, authz.Owner, ""},
	}
	byUser := map[string]*core.Record{}
	for _, m := range rows {
		r := saveMembership(t, app, m.id, m.org, m.user, m.role, m.deletedAt)
		byUser[m.user] = r
	}
	return app, byUser
}

func saveMembership(t *testing.T, app core.App, id, org, user string, role authz.Role, deletedAt string) *core.Record {
	t.Helper()
	c, err := app.FindCachedCollectionByNameOrId("memberships")
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = id
	r.Set("org_id", org)
	r.Set("user_id", user)
	r.Set("role", string(role))
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	r.Set("deleted_at", deletedAt)
	if err := app.Save(r); err != nil {
		t.Fatalf("membership %s: %v", id, err)
	}
	return r
}

// row is a bare row for CanSeeRow.
type row map[string]string

func (r row) GetString(key string) string { return r[key] }

// rowOf is a row of table in org (for organizations, the organization
// itself) whose user_id is user.
func rowOf(table, org, user string) row {
	r := row{"id": "d0000000-0000-0000-0000-000000000001", "org_id": org, "user_id": user}
	if table == "organizations" {
		r["id"] = org
		delete(r, "org_id")
	}
	return r
}

func sameRoles(a, b []authz.Role) bool {
	a, b = slices.Clone(a), slices.Clone(b)
	slices.Sort(a)
	slices.Sort(b)
	return slices.Equal(a, b)
}
