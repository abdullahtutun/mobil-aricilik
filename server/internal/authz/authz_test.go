package authz_test

import (
	"errors"
	"slices"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/pocketbase/pocketbase/core"
)

// private.is_member / private.has_role (20261021200110): a live membership
// counts, a removed one does not; has_role also needs one of the roles.
func TestIsMemberHasRole(t *testing.T) {
	app, _ := fixture(t)

	cases := []struct {
		user, org string
		member    bool
		role      authz.Role // "" = none
	}{
		{owner, orgA, true, authz.Owner},
		{partner, orgA, true, authz.Partner},
		{worker, orgA, true, authz.Worker},
		{viewer, orgA, true, authz.Viewer},
		{removed, orgA, false, ""},
		{outsider, orgA, false, ""},
		{outsider, orgE, true, authz.Owner},
		{owner, orgE, false, ""},
		{newcomer, orgA, false, ""},
		{anon, orgA, false, ""},
		{owner, "", false, ""},
	}
	for _, c := range cases {
		got, err := authz.IsMember(app, c.user, c.org)
		if err != nil {
			t.Fatal(err)
		}
		if got != c.member {
			t.Errorf("IsMember(%s, %s) = %v, want %v", c.user, c.org, got, c.member)
		}
		for _, r := range authz.AllRoles {
			got, err := authz.HasRole(app, c.user, c.org, r)
			if err != nil {
				t.Fatal(err)
			}
			if want := r == c.role; got != want {
				t.Errorf("HasRole(%s, %s, %s) = %v, want %v", c.user, c.org, r, got, want)
			}
		}
		got, err = authz.HasRole(app, c.user, c.org, authz.AllRoles...)
		if err != nil {
			t.Fatal(err)
		}
		if got != c.member {
			t.Errorf("HasRole(%s, %s, all) = %v, want IsMember = %v", c.user, c.org, got, c.member)
		}
		if got, _ := authz.HasRole(app, c.user, c.org); got {
			t.Errorf("HasRole(%s, %s) with no roles = true, want false", c.user, c.org)
		}
	}
}

func TestOrgIDsForUser(t *testing.T) {
	app, _ := fixture(t)
	// A second organization for the worker, as viewer, to see the role
	// filter and the sort order.
	const orgB = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
	saveMembership(t, app, "c0000000-0000-0000-0000-000000000013", orgB, worker, authz.Viewer, "")

	cases := []struct {
		user  string
		roles []authz.Role
		want  []string
	}{
		{worker, nil, []string{orgA, orgB}},
		{worker, authz.AllRoles, []string{orgA, orgB}},
		{worker, authz.Writers, []string{orgA}},
		{worker, authz.Managers, []string{}},
		{viewer, authz.Writers, []string{}},
		{partner, authz.Managers, []string{orgA}},
		{outsider, nil, []string{orgE}},
		{removed, nil, []string{}},
		{newcomer, nil, []string{}},
		{anon, nil, []string{}},
	}
	for _, c := range cases {
		got, err := authz.OrgIDsForUser(app, c.user, c.roles...)
		if err != nil {
			t.Fatal(err)
		}
		if got == nil || !slices.Equal(got, c.want) {
			t.Errorf("OrgIDsForUser(%s, %v) = %#v, want %#v", c.user, c.roles, got, c.want)
		}
	}
}

// Inside a transaction the answer sees the transaction's writes: push
// checks roles with the transaction's app.
func TestAuthzSeesTransactionWrites(t *testing.T) {
	app, _ := fixture(t)
	err := app.RunInTransaction(func(tx core.App) error {
		saveMembership(t, tx, "c0000000-0000-0000-0000-000000000004", orgA, newcomer, authz.Worker, "")
		ok, err := authz.HasRole(tx, newcomer, orgA, authz.Writers...)
		if err != nil {
			return err
		}
		if !ok {
			t.Error("HasRole in the transaction does not see the new membership")
		}
		return errRollback
	})
	if !errors.Is(err, errRollback) {
		t.Fatal(err)
	}
	if ok, _ := authz.IsMember(app, newcomer, orgA); ok {
		t.Error("rolled back membership still counts")
	}
}

var errRollback = errors.New("rollback")

func TestUnknownTable(t *testing.T) {
	app, _ := fixture(t)
	if _, err := authz.Can(app, owner, "no_such_table", orgA, authz.Read); !errors.Is(err, authz.ErrNoPolicy) {
		t.Errorf("Can on an unknown table: err = %v, want ErrNoPolicy", err)
	}
	if _, err := authz.CanSeeRow(app, "weather_cache", rowOf("weather_cache", orgA, owner), owner); !errors.Is(err, authz.ErrNoPolicy) {
		t.Errorf("CanSeeRow on a table without policy: err = %v, want ErrNoPolicy", err)
	}
}
