package sync_test

import (
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"slices"
	"strings"
	stdsync "sync"
	"sync/atomic"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// The users and organizations of supabase/tests/database/sync_pull.test.sql
// (owner of A, owner of B as "outsider") and of the RLS tests, same ids.
const (
	pOwner    = "11111111-1111-1111-1111-111111111111"
	pPartner  = "22222222-2222-2222-2222-222222222222"
	pWorker   = "33333333-3333-3333-3333-333333333333"
	pViewer   = "55555555-5555-5555-5555-555555555555"
	pRemoved  = "66666666-6666-6666-6666-666666666666"
	pStranger = "77777777-7777-7777-7777-777777777777"
	pOutsider = "99999999-9999-9999-9999-999999999999"

	pOrgA = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	pOrgB = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"

	deletedTime = "2026-10-23T10:00:00.000000Z"
)

// pullFixture is the app as main.go wires it, with organizations A and B,
// their memberships and an auth token per user. pRemoved is a worker of A
// whose membership is soft-deleted; pWorker also has a removed membership in
// B; pStranger has no membership.
type pullFixture struct {
	app    *tests.TestApp
	tokens map[string]string
}

func newPullFixture(t *testing.T) *pullFixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev}, "test")

	f := &pullFixture{app: app, tokens: map[string]string{}}
	for i, id := range []string{pOwner, pPartner, pWorker, pViewer, pRemoved, pStranger, pOutsider} {
		u := core.NewRecord(mustCollection(t, app, "users"))
		u.Id = id
		u.SetEmail(fmt.Sprintf("user%d@example.com", i))
		u.SetPassword("1234567890")
		mustSave(t, app, u)
		tok, err := u.NewAuthToken()
		if err != nil {
			t.Fatal(err)
		}
		f.tokens[id] = tok
	}

	for _, o := range []struct{ id, name, by string }{
		{pOrgA, "Petek Arıcılık", pOwner},
		{pOrgB, "Başka İşletme", pOutsider},
	} {
		f.insert(t, "organizations", o.id, map[string]any{
			"name": o.name, "country_code": "TR", "currency": "TRY",
			"operation_type": "migratory", "created_by": o.by,
		})
	}
	for _, m := range []struct {
		id, org, user string
		role          authz.Role
		deletedAt     string
	}{
		{"c0000000-0000-0000-0000-000000000001", pOrgA, pOwner, authz.Owner, ""},
		{"c0000000-0000-0000-0000-000000000002", pOrgA, pPartner, authz.Partner, ""},
		{"c0000000-0000-0000-0000-000000000003", pOrgA, pWorker, authz.Worker, ""},
		{"c0000000-0000-0000-0000-000000000005", pOrgA, pViewer, authz.Viewer, ""},
		{"c0000000-0000-0000-0000-000000000006", pOrgA, pRemoved, authz.Worker, deletedTime},
		{"c0000000-0000-0000-0000-000000000009", pOrgB, pOutsider, authz.Owner, ""},
		{"c0000000-0000-0000-0000-00000000000b", pOrgB, pWorker, authz.Worker, deletedTime},
	} {
		f.insert(t, "memberships", m.id, map[string]any{
			"org_id": m.org, "user_id": m.user, "role": string(m.role), "deleted_at": m.deletedAt,
		})
	}
	return f
}

func mustCollection(t testing.TB, app core.App, name string) *core.Collection {
	t.Helper()
	c, err := app.FindCachedCollectionByNameOrId(name)
	if err != nil {
		t.Fatal(err)
	}
	return c
}

func mustSave(t testing.TB, app core.App, r *core.Record) {
	t.Helper()
	if err := app.Save(r); err != nil {
		t.Fatalf("save %s %s: %v", r.Collection().Name, r.Id, err)
	}
}

// insert saves a row of collection with the common time fields filled.
func (f *pullFixture) insert(t testing.TB, collection, id string, fields map[string]any) *core.Record {
	t.Helper()
	r := core.NewRecord(mustCollection(t, f.app, collection))
	r.Id = id
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	for k, v := range fields {
		r.Set(k, v)
	}
	mustSave(t, f.app, r)
	return r
}

func (f *pullFixture) apiary(t testing.TB, id, org, name string) *core.Record {
	t.Helper()
	return f.insert(t, "apiaries", id, map[string]any{"org_id": org, "name": name})
}

func (f *pullFixture) seqOf(t *testing.T, collection, id string) int64 {
	t.Helper()
	return storedSeq(t, f.app, collection, id)
}

func (f *pullFixture) pull(t testing.TB, user, table string, since int64, size int) appsync.Page {
	t.Helper()
	page, err := appsync.Pull(f.app, user, table, since, size)
	if err != nil {
		t.Fatalf("pull %s since %d: %v", table, since, err)
	}
	return page
}

func names(page appsync.Page) []string {
	out := []string{}
	for _, r := range page.Rows {
		out = append(out, fmt.Sprint(r["name"]))
	}
	return out
}

func rowIDs(page appsync.Page) []string {
	out := []string{}
	for _, r := range page.Rows {
		out = append(out, fmt.Sprint(r["id"]))
	}
	return out
}

// TestPullPagingSyncPullTest ports the paging, deletion and other-
// organization scenarios of sync_pull.test.sql. The lookback scenarios
// (T1/T2, the fresh zone) have no counterpart: there is no lookback (K-7);
// TestPullConcurrentWritesMissNoRow covers what they guarded.
func TestPullPagingSyncPullTest(t *testing.T) {
	f := newPullFixture(t)
	a1 := f.apiary(t, "a1000000-0000-0000-0000-000000000001", pOrgA, "A1")
	a1.Set("latitude", 40.98)
	a1.Set("longitude", 40.52)
	mustSave(t, f.app, a1)
	// B's rows sit between A's.
	f.apiary(t, "e1000000-0000-0000-0000-000000000001", pOrgB, "B1")
	f.apiary(t, "a1000000-0000-0000-0000-000000000002", pOrgA, "A2")
	f.apiary(t, "a1000000-0000-0000-0000-000000000003", pOrgA, "A3")
	f.apiary(t, "e1000000-0000-0000-0000-000000000002", pOrgB, "B2")
	f.apiary(t, "a1000000-0000-0000-0000-000000000004", pOrgA, "A4")
	seq := func(n int) int64 {
		return f.seqOf(t, "apiaries", fmt.Sprintf("a1000000-0000-0000-0000-%012d", n))
	}

	// "ilk sayfa A'nın ilk iki satırı; aradaki B satırı sayılmaz, konum
	// enlem ve boylam olur"
	page1 := f.pull(t, pOwner, "apiaries", 0, 2)
	if got := names(page1); !slices.Equal(got, []string{"A1", "A2"}) {
		t.Fatalf("page 1 = %v, want [A1 A2]", got)
	}
	first, second := page1.Rows[0], page1.Rows[1]
	if jsonText(t, first["latitude"]) != "40.98" || jsonText(t, first["longitude"]) != "40.52" {
		t.Errorf("A1 location = %v, %v; want 40.98, 40.52", first["latitude"], first["longitude"])
	}
	if _, ok := first["location"]; ok {
		t.Error("row has a location column")
	}
	if second["latitude"] != nil || second["longitude"] != nil {
		t.Errorf("A2 location = %v, %v; want null", second["latitude"], second["longitude"])
	}
	// "dolu sayfa son satırın server_seq'ini ve has_more döner"
	if page1.NextSeq != seq(2) || !page1.HasMore {
		t.Errorf("page 1 next_seq, has_more = %d, %v; want %d, true", page1.NextSeq, page1.HasMore, seq(2))
	}

	// "ikinci sayfa imleçten sonraki satırlarla devam eder"
	page2 := f.pull(t, pOwner, "apiaries", page1.NextSeq, 2)
	if got := names(page2); !slices.Equal(got, []string{"A3", "A4"}) {
		t.Errorf("page 2 = %v, want [A3 A4]", got)
	}
	// "son sayfa tam dolsa da has_more false döner"
	if page2.NextSeq != seq(4) || page2.HasMore {
		t.Errorf("page 2 next_seq, has_more = %d, %v; want %d, false", page2.NextSeq, page2.HasMore, seq(4))
	}

	// "yeni satır yoksa boş sayfa döner, imleç yerinde kalır"
	page3 := f.pull(t, pOwner, "apiaries", page2.NextSeq, 2)
	if len(page3.Rows) != 0 || page3.NextSeq != seq(4) || page3.HasMore {
		t.Errorf("page 3 = %+v, want no rows, next_seq %d, has_more false", page3, seq(4))
	}
	body, err := json.Marshal(page3)
	if err != nil {
		t.Fatal(err)
	}
	if want := fmt.Sprintf(`{"rows":[],"next_seq":%d,"has_more":false}`, seq(4)); string(body) != want {
		t.Errorf("empty page JSON = %s, want %s", body, want)
	}

	// "silinen satır deleted_at ile ve yeni server_seq'iyle sonda gelir"
	a2, err := f.app.FindRecordById("apiaries", "a1000000-0000-0000-0000-000000000002")
	if err != nil {
		t.Fatal(err)
	}
	a2.Set("deleted_at", deletedTime)
	a2.Set("updated_at", deletedTime)
	mustSave(t, f.app, a2)
	afterDelete := f.pull(t, pOwner, "apiaries", page3.NextSeq, 10)
	if got := names(afterDelete); !slices.Equal(got, []string{"A2"}) {
		t.Fatalf("after delete = %v, want [A2]", got)
	}
	if got := afterDelete.Rows[0]["deleted_at"]; got != deletedTime {
		t.Errorf("deleted_at = %v, want %s", got, deletedTime)
	}
	if got := afterDelete.Rows[0]["server_seq"]; got != seq(2) || seq(2) <= seq(4) {
		t.Errorf("server_seq = %v (A4 %d), want a new number after A4", got, seq(4))
	}

	// "baştan çekme A'nın bütün satırlarını sırayla verir, B'ninkileri vermez"
	if got := names(f.pull(t, pOwner, "apiaries", 0, 100)); !slices.Equal(got, []string{"A1", "A3", "A4", "A2"}) {
		t.Errorf("full pull of A = %v, want [A1 A3 A4 A2]", got)
	}
	// "işletmelerden yalnız üyesi olunan gelir"
	if got := rowIDs(f.pull(t, pOwner, "organizations", 0, 100)); !slices.Equal(got, []string{pOrgA}) {
		t.Errorf("organizations of A's owner = %v, want [%s]", got, pOrgA)
	}
	// "B yalnız kendi arılıklarını alır"
	if got := names(f.pull(t, pOutsider, "apiaries", 0, 100)); !slices.Equal(got, []string{"B1", "B2"}) {
		t.Errorf("apiaries of B's owner = %v, want [B1 B2]", got)
	}
}

// TestPullOtherOrgRowsDoNotFillPage: a page of 1 behind many rows of another
// organization still returns the user's next row.
func TestPullOtherOrgRowsDoNotFillPage(t *testing.T) {
	f := newPullFixture(t)
	for i := range 20 {
		f.apiary(t, fmt.Sprintf("e2000000-0000-0000-0000-%012d", i), pOrgB, fmt.Sprint("B", i))
	}
	f.apiary(t, "a2000000-0000-0000-0000-000000000001", pOrgA, "A")
	page := f.pull(t, pOwner, "apiaries", 0, 1)
	if got := names(page); !slices.Equal(got, []string{"A"}) || page.HasMore {
		t.Errorf("page = %v, has_more %v; want [A], false", got, page.HasMore)
	}
}

// TestPullRowJSON: the row carries every column under the server's name,
// null where the field is empty, server_seq as an integer, JSON fields as
// JSON.
func TestPullRowJSON(t *testing.T) {
	f := newPullFixture(t)
	f.apiary(t, "a1000000-0000-0000-0000-000000000001", pOrgA, "A1")
	row := f.pull(t, pOwner, "apiaries", 0, 1).Rows[0]

	c := mustCollection(t, f.app, "apiaries")
	if len(row) != len(c.Fields) {
		t.Errorf("row has %d columns, collection %d", len(row), len(c.Fields))
	}
	for _, field := range c.Fields {
		if _, ok := row[field.GetName()]; !ok {
			t.Errorf("row lacks %s", field.GetName())
		}
	}
	for _, k := range []string{"deleted_at", "created_by", "land_tenure", "altitude_m", "latitude"} {
		if row[k] != nil {
			t.Errorf("%s = %#v, want null", k, row[k])
		}
	}
	if _, ok := row["server_seq"].(int64); !ok {
		t.Errorf("server_seq = %#v, want an integer", row["server_seq"])
	}
	body, err := json.Marshal(row)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(body), `"deleted_at":null`) || !strings.Contains(string(body), `"org_id":"`+pOrgA+`"`) {
		t.Errorf("row JSON = %s", body)
	}
}

// TestPullRowJSONEveryCollection: every synced collection can be pulled
// (its fields have a JSON mapping, its org index exists) by a member and
// by a stranger.
func TestPullRowJSONEveryCollection(t *testing.T) {
	f := newPullFixture(t)
	for _, name := range appsync.Names() {
		for _, user := range []string{pOwner, pStranger} {
			page, err := appsync.Pull(f.app, user, name, 0, appsync.MaxPageSize)
			if err != nil {
				t.Errorf("%s by %s: %v", name, user, err)
				continue
			}
			for _, row := range page.Rows {
				if _, err := json.Marshal(row); err != nil {
					t.Errorf("%s: %v", name, err)
				}
			}
		}
	}
}

// TestPullFinanceRoles: finance tables go to owner and partner only (RLS
// "finance" policies); worker and viewer get an empty page.
func TestPullFinanceRoles(t *testing.T) {
	f := newPullFixture(t)
	f.insert(t, "transactions", "f1000000-0000-0000-0000-000000000001", map[string]any{
		"org_id": pOrgA, "kind": "expense", "category": "feeding", "amount": 125.5,
		"currency": "TRY", "occurred_on": "2026-11-10",
	})
	f.insert(t, "customers", "f2000000-0000-0000-0000-000000000001", map[string]any{
		"org_id": pOrgA, "name": "Ayşe",
	})
	for _, table := range []string{"transactions", "customers"} {
		for user, want := range map[string]int{
			pOwner: 1, pPartner: 1, pWorker: 0, pViewer: 0, pRemoved: 0, pOutsider: 0, pStranger: 0,
		} {
			if got := len(f.pull(t, user, table, 0, 100).Rows); got != want {
				t.Errorf("%s by %s: %d rows, want %d", table, user, got, want)
			}
		}
	}
	// Ordinary tables still go to worker and viewer.
	f.apiary(t, "a1000000-0000-0000-0000-000000000001", pOrgA, "A1")
	for _, user := range []string{pWorker, pViewer} {
		if got := len(f.pull(t, user, "apiaries", 0, 100).Rows); got != 1 {
			t.Errorf("apiaries by %s: %d rows, want 1", user, got)
		}
	}
	if got := f.pull(t, pOwner, "transactions", 0, 1).Rows[0]["amount"]; got != 125.5 {
		t.Errorf("amount = %#v, want 125.5", got)
	}
}

// TestPullMemberships: members see their organizations' memberships,
// removed ones included; a removed member sees only their own row.
func TestPullMemberships(t *testing.T) {
	f := newPullFixture(t)
	a := []string{
		"c0000000-0000-0000-0000-000000000001", "c0000000-0000-0000-0000-000000000002",
		"c0000000-0000-0000-0000-000000000003", "c0000000-0000-0000-0000-000000000005",
		"c0000000-0000-0000-0000-000000000006",
	}
	cases := []struct {
		user string
		want []string
	}{
		{pOwner, a},
		{pViewer, a},
		// A's rows and the own removed row in B, in server_seq order.
		{pWorker, append(slices.Clone(a), "c0000000-0000-0000-0000-00000000000b")},
		{pRemoved, []string{"c0000000-0000-0000-0000-000000000006"}},
		// B's owner also sees pWorker's removed row: it is B's.
		{pOutsider, []string{"c0000000-0000-0000-0000-000000000009", "c0000000-0000-0000-0000-00000000000b"}},
		{pStranger, []string{}},
	}
	for _, c := range cases {
		if got := rowIDs(f.pull(t, c.user, "memberships", 0, 100)); !slices.Equal(got, c.want) {
			t.Errorf("memberships of %s = %v, want %v", c.user, got, c.want)
		}
	}
	// A removed member gets no organization row (Supabase: is_member).
	if got := rowIDs(f.pull(t, pRemoved, "organizations", 0, 100)); len(got) != 0 {
		t.Errorf("organizations of removed member = %v, want none", got)
	}
}

// TestPullReferenceForEveryone: ref_* go to any signed-in user, member or
// not, deleted rows included.
func TestPullReferenceForEveryone(t *testing.T) {
	f := newPullFixture(t)
	// ref_drugs comes seeded; ref_support_periods is empty (live too).
	for i := range 3 {
		f.insert(t, "ref_support_periods", fmt.Sprintf("50000000-0000-0000-0000-%012d", i), map[string]any{
			"name": fmt.Sprint("Dönem ", i), "application_starts_on": "2026-11-01",
			"application_ends_on": "2026-11-30", "deleted_at": map[bool]string{true: deletedTime}[i == 2],
		})
	}
	for _, table := range []string{"ref_drugs", "ref_support_periods"} {
		total, err := f.app.CountRecords(table)
		if err != nil {
			t.Fatal(err)
		}
		if total == 0 {
			t.Fatalf("%s: no seeded rows", table)
		}
		for _, user := range []string{pStranger, pOwner} {
			var got []string
			var since int64
			for {
				page := f.pull(t, user, table, since, 7)
				got = append(got, rowIDs(page)...)
				since = page.NextSeq
				if !page.HasMore {
					break
				}
			}
			if int64(len(got)) != total {
				t.Errorf("%s by %s: %d rows, want %d", table, user, len(got), total)
			}
		}
	}
}

func TestPullUnsupportedTable(t *testing.T) {
	f := newPullFixture(t)
	for _, table := range []string{"", "users", "invites", "device_tokens", "sync_meta", "apiaries; drop table hives", "_superusers"} {
		if _, err := appsync.Pull(f.app, pOwner, table, 0, 10); !errors.Is(err, appsync.ErrUnsupported) {
			t.Errorf("%q: err = %v, want ErrUnsupported", table, err)
		}
	}
}

// TestPullUsesOrgSeqIndex checks the query plan: each organization's branch
// searches the (org_id, server_seq) index, no table is scanned.
func TestPullUsesOrgSeqIndex(t *testing.T) {
	f := newPullFixture(t)
	for _, orgs := range [][]string{{pOrgA}, {pOrgA, pOrgB}} {
		for _, table := range []string{"apiaries", "transactions", "memberships"} {
			scope := authz.ScopeOrg
			if table == "memberships" {
				scope = authz.ScopeMembership
			}
			sub, params, err := appsync.PageIDsQuery(table, scope, pOwner, orgs, 0, 11)
			if err != nil {
				t.Fatal(err)
			}
			var plan []dbx.NullStringMap
			err = f.app.DB().
				NewQuery("EXPLAIN QUERY PLAN SELECT * FROM {{" + table + "}} WHERE [[id]] IN (" + sub + ") ORDER BY [[server_seq]]").
				Bind(params).
				All(&plan)
			if err != nil {
				t.Fatalf("%s: %v", table, err)
			}
			var details []string
			for _, row := range plan {
				details = append(details, row["detail"].String)
			}
			text := strings.Join(details, "\n")
			index := appsync.OrgSeqIndex(table)
			if got := strings.Count(text, "USING INDEX "+index+" (org_id=? AND server_seq>?)"); got != len(orgs) {
				t.Errorf("%s with %d orgs: %d searches of %s, want %d\n%s", table, len(orgs), got, index, len(orgs), text)
			}
			for _, d := range details {
				if strings.HasPrefix(d, "SCAN "+table) && !strings.Contains(d, "INDEX") {
					t.Errorf("%s: full scan: %s\n%s", table, d, text)
				}
			}
		}
	}
}

// TestPullConcurrentWritesMissNoRow: while 1000 rows are written from
// several goroutines, a puller follows the cursor; when writing stops and a
// last pull says has_more false, it has every id exactly once. With a
// lookback-free cursor this holds only because numbers are taken in commit
// order (K-7).
func TestPullConcurrentWritesMissNoRow(t *testing.T) {
	f := newPullFixture(t)
	const writers, perWriter = 8, 125

	var wg stdsync.WaitGroup
	var done atomic.Bool
	errs := make(chan error, writers+1)
	want := map[string]bool{}
	for w := range writers {
		for i := range perWriter {
			want[fmt.Sprintf("a3%06d-0000-0000-0000-%012d", w, i)] = true
		}
	}
	apiaries := mustCollection(t, f.app, "apiaries")
	for w := range writers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for i := range perWriter {
				r := core.NewRecord(apiaries)
				r.Id = fmt.Sprintf("a3%06d-0000-0000-0000-%012d", w, i)
				r.Set("org_id", pOrgA)
				r.Set("name", r.Id)
				r.Set("created_at", testTime)
				r.Set("updated_at", testTime)
				if err := f.app.Save(r); err != nil {
					errs <- err
					return
				}
				// Rows of B interleave and must not be pulled.
				if i%10 == 0 {
					b := core.NewRecord(apiaries)
					b.Id = fmt.Sprintf("b3%06d-0000-0000-0000-%012d", w, i)
					b.Set("org_id", pOrgB)
					b.Set("name", b.Id)
					b.Set("created_at", testTime)
					b.Set("updated_at", testTime)
					if err := f.app.Save(b); err != nil {
						errs <- err
						return
					}
				}
			}
		}()
	}

	got := map[string]int{}
	pulls := 0
	var pullWG stdsync.WaitGroup
	pullWG.Add(1)
	go func() {
		defer pullWG.Done()
		var since int64
		for {
			finished := done.Load()
			page, err := appsync.Pull(f.app, pOwner, "apiaries", since, 50)
			if err != nil {
				errs <- err
				return
			}
			pulls++
			for _, row := range page.Rows {
				got[row["id"].(string)]++
			}
			since = page.NextSeq
			// Writing had stopped before this pull began and nothing is left.
			if finished && !page.HasMore {
				return
			}
		}
	}()

	wg.Wait()
	done.Store(true)
	pullWG.Wait()
	close(errs)
	for err := range errs {
		t.Fatal(err)
	}

	if len(got) != len(want) {
		t.Errorf("pulled %d distinct rows, want %d", len(got), len(want))
	}
	for id := range want {
		if got[id] != 1 {
			t.Errorf("%s pulled %d times, want once", id, got[id])
		}
	}
	for id := range got {
		if !want[id] {
			t.Errorf("pulled %s, not a row of A", id)
		}
	}
	t.Logf("%d pulls", pulls)
}

// The route: query parameters, auth, error bodies.
func TestPullRoute(t *testing.T) {
	f := newPullFixture(t)
	f.apiary(t, "a1000000-0000-0000-0000-000000000001", pOrgA, "A1")
	f.apiary(t, "e1000000-0000-0000-0000-000000000001", pOrgB, "B1")

	su := core.NewRecord(mustCollection(t, f.app, core.CollectionNameSuperusers))
	su.SetEmail("admin@example.com")
	su.SetPassword("1234567890")
	mustSave(t, f.app, su)
	suToken, err := su.NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}

	url := func(q string) string { return appsync.PullRoute + "?" + q }
	scenarios := []struct {
		name    string
		url     string
		token   string
		status  int
		content []string
		not     []string
	}{
		{
			name: "owner of A gets A's row", url: url("table=apiaries&since_seq=0&page_size=10"), token: f.tokens[pOwner],
			status: 200, content: []string{`"name":"A1"`, `"has_more":false`, `"deleted_at":null`}, not: []string{`"B1"`},
		},
		{
			name: "worker gets no finance", url: url("table=transactions&since_seq=0&page_size=10"), token: f.tokens[pWorker],
			status: 200, content: []string{`"rows":[]`, `"next_seq":0`},
		},
		{
			name: "stranger gets reference rows", url: url("table=ref_drugs&since_seq=0&page_size=1"), token: f.tokens[pStranger],
			status: 200, content: []string{`"has_more":true`, `"name_tr":`},
		},
		{name: "no token", url: url("table=apiaries&since_seq=0&page_size=10"), status: 401, content: []string{`"status":401`}},
		{name: "superuser", url: url("table=apiaries&since_seq=0&page_size=10"), token: suToken, status: 403, content: []string{`"status":403`}},
		{
			name: "unknown table", url: url("table=users&since_seq=0&page_size=10"), token: f.tokens[pOwner],
			status: 400, content: []string{`"code":"unsupported"`},
		},
		{
			name: "missing table", url: url("since_seq=0&page_size=10"), token: f.tokens[pOwner],
			status: 400, content: []string{`"code":"unsupported"`},
		},
		{name: "page_size 0", url: url("table=apiaries&since_seq=0&page_size=0"), token: f.tokens[pOwner], status: 400, content: []string{`"code":"invalid"`}},
		{name: "page_size 1001", url: url("table=apiaries&since_seq=0&page_size=1001"), token: f.tokens[pOwner], status: 400, content: []string{`"code":"invalid"`}},
		{name: "page_size missing", url: url("table=apiaries&since_seq=0"), token: f.tokens[pOwner], status: 400, content: []string{`"code":"invalid"`}},
		{name: "since_seq negative", url: url("table=apiaries&since_seq=-1&page_size=10"), token: f.tokens[pOwner], status: 400, content: []string{`"code":"invalid"`}},
		{name: "since_seq text", url: url("table=apiaries&since_seq=x&page_size=10"), token: f.tokens[pOwner], status: 400, content: []string{`"code":"invalid"`}},
		{name: "page_size 1000", url: url("table=apiaries&since_seq=0&page_size=1000"), token: f.tokens[pOwner], status: 200, content: []string{`"A1"`}},
	}
	for _, s := range scenarios {
		headers := map[string]string{}
		if s.token != "" {
			headers["Authorization"] = s.token
		}
		sc := tests.ApiScenario{
			Name:               s.name,
			Method:             http.MethodGet,
			URL:                s.url,
			Headers:            headers,
			ExpectedStatus:     s.status,
			ExpectedContent:    s.content,
			NotExpectedContent: s.not,
			// A pull writes nothing.
			ExpectedEvents:        map[string]int{"*": 0},
			TestAppFactory:        func(testing.TB) *tests.TestApp { return f.app },
			DisableTestAppCleanup: true,
		}
		sc.Test(t)
		f.app.ResetEventCalls()
	}
}

func jsonText(t *testing.T, v any) string {
	t.Helper()
	b, err := json.Marshal(v)
	if err != nil {
		t.Fatal(err)
	}
	return string(b)
}
