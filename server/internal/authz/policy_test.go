package authz_test

import (
	"os"
	"path/filepath"
	"regexp"
	"slices"
	"sort"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
)

// routeOnly are the tables in Policies that are not synced: only routes
// touch them (see the Policies doc).
var routeOnly = []string{"invites", "device_tokens"}

// apiRuleTables have Supabase policies but no Policies entry: clients reach
// them through PocketBase API rules (P3.2).
var apiRuleTables = []string{"feedback", "analytics_events", "deletion_requests"}

// The registry ↔ Policy match: every synced collection has a policy whose
// scope fits its push kind, and every policy belongs to a synced or a
// route-only collection that exists, with the column its scope reads.
// Counterpart of the policy half of rls_enabled.test.sql.
func TestPolicyForEveryTable(t *testing.T) {
	wantScope := map[appsync.Kind]authz.Scope{
		appsync.KindState:         authz.ScopeOrg,
		appsync.KindEvent:         authz.ScopeOrg,
		appsync.KindOrganization:  authz.ScopeOrganization,
		appsync.KindOwnMembership: authz.ScopeMembership,
		appsync.KindReference:     authz.ScopeAnyUser,
	}
	for _, table := range appsync.Tables {
		p, err := authz.Lookup(table.Name)
		if err != nil {
			t.Errorf("%s: synced but %v", table.Name, err)
			continue
		}
		if p.Scope != wantScope[table.Kind] {
			t.Errorf("%s: scope %q, want %q for kind %q", table.Name, p.Scope, wantScope[table.Kind], table.Kind)
		}
		if table.Kind == appsync.KindReference && (p.Read != nil || p.Insert != nil || p.Update != nil) {
			t.Errorf("%s: reference table with roles %+v; every signed-in user reads, no one writes", table.Name, p)
		}
		if table.Kind != appsync.KindReference && len(p.Read) == 0 {
			t.Errorf("%s: no read roles", table.Name)
		}
	}

	app := newApp(t)
	for name, p := range authz.Policies {
		if _, synced := appsync.Lookup(name); !synced && !slices.Contains(routeOnly, name) {
			t.Errorf("%s: has a policy but is neither synced nor route-only", name)
		}
		c, err := app.FindCollectionByNameOrId(name)
		if err != nil {
			t.Errorf("%s: has a policy but no collection: %v", name, err)
			continue
		}
		var column string
		switch p.Scope {
		case authz.ScopeOrg:
			column = "org_id"
		case authz.ScopeMembership:
			column = "org_id"
			if c.Fields.GetByName("user_id") == nil {
				t.Errorf("%s: scope %q but no user_id field", name, p.Scope)
			}
		case authz.ScopeOwnUser:
			column = "user_id"
		case authz.ScopeOrganization, authz.ScopeAnyUser:
			continue
		default:
			t.Errorf("%s: unknown scope %q", name, p.Scope)
			continue
		}
		if c.Fields.GetByName(column) == nil {
			t.Errorf("%s: scope %q but no %s field", name, p.Scope, column)
		}
	}
}

// The prompt's named rules, spelled out so a change to the shared
// policies shows up here too.
func TestPolicyNamedRules(t *testing.T) {
	for _, name := range []string{"transactions", "customers", "customer_payments"} {
		p := authz.Policies[name]
		for _, roles := range [][]authz.Role{p.Read, p.Insert, p.Update} {
			if !sameRoles(roles, authz.Managers) {
				t.Errorf("%s: %+v, want owner+partner for read, insert and update", name, p)
				break
			}
		}
	}
	if p := authz.Policies["organizations"]; !sameRoles(p.Update, authz.Managers) || p.Insert != nil {
		t.Errorf("organizations: %+v, want update owner+partner (20261112120000) and no insert", p)
	}
	if p := authz.Policies["hive_status_events"]; !sameRoles(p.Insert, authz.Writers) || !sameRoles(p.Update, authz.Writers) {
		t.Errorf("hive_status_events: %+v, want owner/partner/worker writes", p)
	}
	if p := authz.Policies["memberships"]; p.Scope != authz.ScopeMembership || !sameRoles(p.Read, authz.AllRoles) {
		t.Errorf("memberships: %+v, want members and the row's own user to read", p)
	}
}

// supabasePolicy is what a table's Supabase policies allow for one command.
type supabasePolicy struct {
	roles   []authz.Role
	ownRow  bool // user_id = auth.uid()
	anyUser bool // using (true)
}

var (
	policyStmt = regexp.MustCompile(`(?is)\b(create|drop)\s+policy\s+"([^"]+)"\s+on\s+(\w+)\.(\w+)(.*?);`)
	policyFor  = regexp.MustCompile(`(?is)^\s+for\s+(\w+)`)
	hasRole    = regexp.MustCompile(`private\.has_role\([^,]+,\s*'\{([a-z,]+)\}'\)`)
	isMember   = regexp.MustCompile(`private\.is_member\(`)
	ownRow     = regexp.MustCompile(`user_id\s*=\s*\(select auth\.uid\(\)\)`)
	usingTrue  = regexp.MustCompile(`using\s*\(\s*true\s*\)`)
	signedIn   = regexp.MustCompile(`\(select auth\.uid\(\)\) is not null`)
)

// readSupabasePolicies replays every create/drop policy statement on public
// tables of supabase/migrations in file order; the result is table →
// command (select, insert, update, …) → what the policy allows.
func readSupabasePolicies(t *testing.T) map[string]map[string]supabasePolicy {
	t.Helper()
	dir := filepath.Join("..", "..", "..", "archive", "supabase", "migrations")
	files, err := filepath.Glob(filepath.Join(dir, "*.sql"))
	if err != nil || len(files) == 0 {
		t.Fatalf("no Supabase migrations in %s (until P11.1 they are the source of the policies): %v", dir, err)
	}
	sort.Strings(files)

	type key struct{ table, name string }
	type entry struct {
		command string
		policy  supabasePolicy
	}
	live := map[key]entry{}
	for _, f := range files {
		src, err := os.ReadFile(f)
		if err != nil {
			t.Fatal(err)
		}
		for _, m := range policyStmt.FindAllStringSubmatch(stripComments(string(src)), -1) {
			verb, name, schema, table, rest := strings.ToLower(m[1]), m[2], m[3], m[4], m[5]
			if schema != "public" {
				continue // storage.objects: file collections, P6.1
			}
			k := key{table, name}
			if verb == "drop" {
				if _, ok := live[k]; !ok {
					t.Errorf("%s: drops unknown policy %q on %s", filepath.Base(f), name, table)
				}
				delete(live, k)
				continue
			}
			cmd := "all"
			if fm := policyFor.FindStringSubmatch(rest); fm != nil {
				cmd = strings.ToLower(fm[1])
			}
			p := supabasePolicy{
				ownRow:  ownRow.MatchString(rest),
				anyUser: usingTrue.MatchString(rest) || signedIn.MatchString(rest),
			}
			if isMember.MatchString(rest) {
				p.roles = slices.Clone(authz.AllRoles)
			}
			for _, hm := range hasRole.FindAllStringSubmatch(rest, -1) {
				for _, r := range strings.Split(hm[1], ",") {
					if !slices.Contains(p.roles, authz.Role(r)) {
						p.roles = append(p.roles, authz.Role(r))
					}
				}
			}
			live[k] = entry{cmd, p}
		}
	}

	out := map[string]map[string]supabasePolicy{}
	for k, e := range live {
		if out[k.table] == nil {
			out[k.table] = map[string]supabasePolicy{}
		}
		if _, dup := out[k.table][e.command]; dup {
			t.Errorf("%s: two %s policies; the comparison expects one", k.table, e.command)
		}
		out[k.table][e.command] = e.policy
	}
	return out
}

func stripComments(sql string) string {
	lines := strings.Split(sql, "\n")
	for i, l := range lines {
		if j := strings.Index(l, "--"); j >= 0 {
			lines[i] = l[:j]
		}
	}
	return strings.Join(lines, "\n")
}

// Policies is a faithful copy of the Supabase RLS policies: the last state
// of every create/drop policy in supabase/migrations, table by table.
func TestPoliciesMatchSupabase(t *testing.T) {
	sb := readSupabasePolicies(t)

	for table, cmds := range sb {
		for cmd := range cmds {
			if cmd != "select" && cmd != "insert" && cmd != "update" {
				t.Errorf("%s: Supabase has a %q policy; authz knows select, insert and update only", table, cmd)
			}
		}
		if _, ok := authz.Policies[table]; !ok && !slices.Contains(apiRuleTables, table) {
			t.Errorf("%s: Supabase has policies %v but authz.Policies has no entry", table, cmds)
		}
	}

	for table, p := range authz.Policies {
		cmds, ok := sb[table]
		if !ok {
			t.Errorf("%s: in authz.Policies but Supabase has no policy for it", table)
			continue
		}

		sel, hasSel := cmds["select"]
		switch p.Scope {
		case authz.ScopeAnyUser:
			if !hasSel || !sel.anyUser {
				t.Errorf("%s: any signed-in user reads, Supabase select = %+v", table, sel)
			}
		case authz.ScopeOwnUser:
			if !hasSel || !sel.ownRow || len(sel.roles) > 0 {
				t.Errorf("%s: only the row's user reads, Supabase select = %+v", table, sel)
			}
		case authz.ScopeMembership:
			if !hasSel || !sel.ownRow || !sameRoles(sel.roles, p.Read) {
				t.Errorf("%s: read %v + own row, Supabase select = %+v", table, p.Read, sel)
			}
		default:
			if !hasSel || sel.ownRow || sel.anyUser || !sameRoles(sel.roles, p.Read) {
				t.Errorf("%s: read %v, Supabase select = %+v", table, p.Read, sel)
			}
		}

		for _, w := range []struct {
			cmd   string
			roles []authz.Role
		}{{"insert", p.Insert}, {"update", p.Update}} {
			s, has := cmds[w.cmd]
			if !has {
				if len(w.roles) > 0 {
					t.Errorf("%s: %s %v, Supabase has no %s policy", table, w.cmd, w.roles, w.cmd)
				}
				continue
			}
			if s.anyUser || s.ownRow || !sameRoles(s.roles, w.roles) {
				t.Errorf("%s: %s %v, Supabase %s = %+v", table, w.cmd, w.roles, w.cmd, s)
			}
		}
	}
}

// The parser itself: a policy missing from Policies, a dropped policy and a
// role change are seen.
func TestReadSupabasePoliciesSeesChanges(t *testing.T) {
	sb := readSupabasePolicies(t)
	if _, ok := sb["organizations"]["insert"]; ok {
		t.Error("organizations insert policy still live; drop policy not replayed")
	}
	if got := sb["organizations"]["update"].roles; !sameRoles(got, authz.Managers) {
		t.Errorf("organizations update = %v, want owner+partner (20261112120000)", got)
	}
	if got := sb["transactions"]["select"].roles; !sameRoles(got, authz.Managers) {
		t.Errorf("transactions select = %v, want owner+partner", got)
	}
	if got := sb["hives"]["select"].roles; !sameRoles(got, authz.AllRoles) {
		t.Errorf("hives select = %v, want is_member", got)
	}
	// 35 synced + invites, device_tokens + feedback, analytics_events,
	// deletion_requests.
	if n := len(sb); n != 40 {
		t.Errorf("read policies of %d tables, want 40", n)
	}
}
