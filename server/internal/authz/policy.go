package authz

import (
	"errors"
	"fmt"

	"github.com/pocketbase/pocketbase/core"
)

// Action is what a caller wants to do with a row. There is no delete: no
// Supabase table has a delete policy, a delete is an update that sets
// deleted_at. Any other value is refused.
type Action string

// The actions of the Supabase policies (`for select|insert|update`).
const (
	Read   Action = "read"
	Insert Action = "insert"
	Update Action = "update"
)

// Scope says which column ties a row to its organization or user.
type Scope string

const (
	// ScopeOrg rows belong to the organization in org_id.
	ScopeOrg Scope = "org"
	// ScopeOrganization is organizations: the row's id is the organization.
	ScopeOrganization Scope = "organization"
	// ScopeMembership is memberships: org_id, and the user in user_id also
	// sees the row, removed or not ("user_id = auth.uid() or
	// is_member(org_id)"), so a removed member's device learns it was
	// removed.
	ScopeMembership Scope = "membership"
	// ScopeOwnUser rows are seen only by the user in user_id (device_tokens).
	ScopeOwnUser Scope = "own_user"
	// ScopeAnyUser rows are seen by every signed-in user (ref_*).
	ScopeAnyUser Scope = "any_user"
)

// Policy is one table's Supabase RLS policies.
//
// Read, Insert and Update are the membership roles of the policy's
// is_member / has_role call on the row's organization; nil means no policy,
// so no one. For [ScopeOwnUser] and [ScopeAnyUser] Read is nil: the scope
// alone decides who reads.
type Policy struct {
	Scope  Scope
	Read   []Role
	Insert []Role
	Update []Role
}

// roles returns the roles allowed to do action.
func (p Policy) roles(a Action) []Role {
	switch a {
	case Read:
		return p.Read
	case Insert:
		return p.Insert
	case Update:
		return p.Update
	}
	return nil
}

// member is the ordinary data table: members read; owner, partner and worker
// insert and update.
var member = Policy{Scope: ScopeOrg, Read: AllRoles, Insert: Writers, Update: Writers}

// finance is transactions, customers and customer_payments: owner and
// partner only, also for reading.
var finance = Policy{Scope: ScopeOrg, Read: Managers, Insert: Managers, Update: Managers}

// reference is ref_*: every signed-in user reads; no one writes (the sync
// push answers "unsupported", the data comes from migrations and seed tools).
var reference = Policy{Scope: ScopeAnyUser}

// Policies holds every table's policies, read one by one from the
// `create policy` / `drop policy` statements of supabase/migrations (the
// last state counts). policy_test.go reads the migrations again and
// compares; registry_test.go checks that every synced collection has an
// entry.
//
// Besides the 35 synced tables there are two tables only routes touch,
// because their Supabase tests are RLS tests: invites (the team route,
// P5.4) and device_tokens (the device-token route, P5.6). The other
// collections clients reach directly get API rules in P3.2.
var Policies = map[string]Policy{
	// 20261021200110: members see; 20261022190700 dropped the insert policy
	// (create_organization only, P5.4); 20261112120000 lets owner and
	// partner update (it was owner only).
	"organizations": {Scope: ScopeOrganization, Read: AllRoles, Update: Managers},
	// 20261021200110: members and the row's own user see; owner inserts and
	// updates. The sync push writes no membership ("own_membership" is
	// answered "not applied"); the team routes (P5.4) do.
	"memberships": {Scope: ScopeMembership, Read: AllRoles, Insert: []Role{Owner}, Update: []Role{Owner}},

	// 20261021201714
	"apiaries":              member,
	"queens":                member,
	"hives":                 member,
	"hive_location_history": member,
	// 20261108120000
	"hive_status_events": member,
	// 20261024142500
	"inspections": member,
	// 20261024190000
	"media": member,
	// 20261025120000
	"mite_counts": member,
	// 20261025200000
	"ref_drugs":  reference,
	"drugs":      member,
	"treatments": member,
	// 20261026120000
	"feedings": member,
	// 20261026180000
	"tasks": member,
	// 20261026235000
	"harvests":      member,
	"harvest_hives": member,
	// 20261027180000
	"documents": member,
	// 20261028120000
	"migrations":      member,
	"migration_stops": member,
	// 20261031120000
	"transports":      member,
	"transport_items": member,
	// 20261101180000
	"inventory_items": member,
	"inventory_moves": member,
	// 20261101230000
	"queen_rearing_batches": member,
	"mating_nucs":           member,
	// 20261102120000
	"lots":           member,
	"lot_harvests":   member,
	"lot_treatments": member,
	"lab_results":    member,
	"lot_sales":      member,
	// 20261104120000
	"customers": finance,
	// 20261103120000
	"transactions": finance,
	// 20261104120000
	"customer_payments": finance,
	// 20261105120000
	"ref_support_periods": reference,

	// Route-only tables.
	// 20261027140000: owner and partner see and create (also created_by =
	// the caller, used_at and used_by empty: the route's job); redeeming
	// is the route's, so no update policy.
	"invites": {Scope: ScopeOrg, Read: Managers, Insert: Managers},
	// 20261027160000: the user sees only their own tokens; clients do not
	// write, the route does.
	"device_tokens": {Scope: ScopeOwnUser},
}

// ErrNoPolicy is returned for a table without an entry in [Policies]:
// refuse rather than guess.
var ErrNoPolicy = errors.New("authz: no policy for table")

// Lookup returns the table's policy.
func Lookup(table string) (Policy, error) {
	p, ok := Policies[table]
	if !ok {
		return Policy{}, fmt.Errorf("%w %q", ErrNoPolicy, table)
	}
	return p, nil
}

// Can reports whether the user may do action on a row of table that belongs
// to orgID (for organizations: the organization's id). It answers the
// role part of a policy; for reading a row of a [ScopeMembership] or
// [ScopeOwnUser] table, whose answer also depends on the row's user_id, use
// [CanSeeRow]. Can never allows a signed-out user (empty userID).
func Can(app core.App, userID, table, orgID string, action Action) (bool, error) {
	p, err := Lookup(table)
	if err != nil {
		return false, err
	}
	if userID == "" {
		return false, nil
	}
	if action == Read {
		switch p.Scope {
		case ScopeAnyUser:
			return true, nil
		case ScopeOwnUser:
			return false, nil
		}
	}
	roles := p.roles(action)
	if len(roles) == 0 {
		return false, nil
	}
	return HasRole(app, userID, orgID, roles...)
}

// Row is a row read from the database; *core.Record satisfies it.
type Row interface {
	GetString(key string) string
}

// CanSeeRow reports whether the user may read row of table: the select
// policy. The pull route uses it where an org filter is not enough, and
// tests use it to check [OrgIDsForUser] filtering.
func CanSeeRow(app core.App, table string, row Row, userID string) (bool, error) {
	p, err := Lookup(table)
	if err != nil {
		return false, err
	}
	if userID == "" {
		return false, nil
	}
	switch p.Scope {
	case ScopeAnyUser:
		return true, nil
	case ScopeOwnUser:
		return row.GetString("user_id") == userID, nil
	case ScopeMembership:
		if row.GetString("user_id") == userID {
			return true, nil
		}
		return HasRole(app, userID, row.GetString("org_id"), p.Read...)
	case ScopeOrganization:
		return HasRole(app, userID, row.GetString("id"), p.Read...)
	case ScopeOrg:
		return HasRole(app, userID, row.GetString("org_id"), p.Read...)
	}
	return false, fmt.Errorf("authz: table %q has unknown scope %q", table, p.Scope)
}
