package seed_test

import (
	"bytes"
	"encoding/json"
	"errors"
	"os"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/orgs"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/seed"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/spf13/cobra"
)

const demoPassword = "482913"

// wantCounts are the rows demo_account.sql writes, table by table, in
// writing order (and the live Supabase demo organization's counts,
// 2026-11-12):
//
//   - 1 organization and its owner membership.
//   - 3 apiaries.
//   - 6 + 5 + 4 = 15 hives, each with a queen and a first location entry.
//   - The village apiary's 4th hive (n = 15) is dead: 1 status event and no
//     inspection, varroa count, feeding or treatment.
//   - 14 live hives × 2 inspections = 28; 14 varroa counts.
//   - Feeding: the active hives of every apiary, 6 + 5 + 3 = 14.
//   - Treatment: the village apiary's active hives = 3.
//   - 2 harvests; harvest_hives: all 6 hives of the plateau apiary (the SQL
//     has no status filter there) + the 5 active hives of the chestnut
//     apiary = 11.
//   - 4 tasks, 6 transactions.
var wantCounts = []seed.TableCount{
	{Table: "organizations", Rows: 1},
	{Table: "memberships", Rows: 1},
	{Table: "apiaries", Rows: 3},
	{Table: "queens", Rows: 15},
	{Table: "hives", Rows: 15},
	{Table: "hive_location_history", Rows: 15},
	{Table: "inspections", Rows: 28},
	{Table: "mite_counts", Rows: 14},
	{Table: "hive_status_events", Rows: 1},
	{Table: "feedings", Rows: 14},
	{Table: "treatments", Rows: 3},
	{Table: "harvests", Rows: 2},
	{Table: "harvest_hives", Rows: 11},
	{Table: "tasks", Rows: 4},
	{Table: "transactions", Rows: 6},
}

const wantTotal = 133

// fixedNow is the clock of the runs; the data's reference time comes from
// --date or from it.
var fixedNow = time.Date(2026, 11, 12, 9, 41, 7, 0, time.UTC)

func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev}, "test")
	return app
}

func newDemoUser(t *testing.T, app core.App) *core.Record {
	t.Helper()
	if _, err := seed.DemoUser(app, auth.DemoEmail, demoPassword); err != nil {
		t.Fatal(err)
	}
	u, err := seed.FindDemoUser(app)
	if err != nil {
		t.Fatal(err)
	}
	return u
}

func runDemo(t *testing.T, app core.App, opts seed.DemoOptions) seed.DemoReport {
	t.Helper()
	if opts.Now == nil {
		opts.Now = func() time.Time { return fixedNow }
	}
	r, err := seed.Demo(app, opts)
	if err != nil {
		t.Fatal(err)
	}
	return r
}

// orgRows counts the demo organization's rows per table in the database.
func orgRows(t *testing.T, app core.App, orgID string) map[string]int {
	t.Helper()
	out := map[string]int{}
	for _, c := range wantCounts {
		col := "org_id"
		if c.Table == "organizations" {
			col = "id"
		}
		n, err := app.CountRecords(c.Table, dbx.HashExp{col: orgID})
		if err != nil {
			t.Fatal(err)
		}
		out[c.Table] = int(n)
	}
	return out
}

func lastSeq(t *testing.T, app core.App) int64 {
	t.Helper()
	seq, err := appsync.LastSeq(app)
	if err != nil {
		t.Fatal(err)
	}
	return seq
}

func checkCounts(t *testing.T, got []seed.TableCount, zero bool) {
	t.Helper()
	if len(got) != len(wantCounts) {
		t.Fatalf("counts = %v, want tables %v", got, wantCounts)
	}
	for i, w := range wantCounts {
		if zero {
			w.Rows = 0
		}
		if got[i] != w {
			t.Errorf("count %d = %+v, want %+v", i, got[i], w)
		}
	}
}

func TestDemoUser(t *testing.T) {
	app := newApp(t)

	if _, err := seed.DemoUser(app, "someone@test.local", demoPassword); err == nil {
		t.Error("a non-demo address was accepted")
	}
	for _, bad := range []string{"", "12345", "1234567", "12345a", " 123456"} {
		if _, err := seed.DemoUser(app, auth.DemoEmail, bad); !errors.Is(err, seed.ErrDemoPassword) {
			t.Errorf("password %q: err = %v, want ErrDemoPassword", bad, err)
		}
	}
	if n, _ := app.CountRecords(auth.UsersCollection); n != 0 {
		t.Fatalf("refused calls wrote %d users", n)
	}

	created, err := seed.DemoUser(app, " Demo@Tutunsoft.com ", demoPassword)
	if err != nil || !created {
		t.Fatalf("created = %v, err = %v", created, err)
	}
	u, err := seed.FindDemoUser(app)
	if err != nil {
		t.Fatal(err)
	}
	if u.GetString("locale") != "en" || !u.Verified() || !u.ValidatePassword(demoPassword) {
		t.Errorf("user: locale %q verified %v password ok %v", u.GetString("locale"), u.Verified(), u.ValidatePassword(demoPassword))
	}

	// Again: the same account, the new password.
	created, err = seed.DemoUser(app, auth.DemoEmail, "111222")
	if err != nil || created {
		t.Fatalf("second call: created = %v, err = %v", created, err)
	}
	u, _ = seed.FindDemoUser(app)
	if !u.ValidatePassword("111222") || u.ValidatePassword(demoPassword) {
		t.Error("the password was not replaced")
	}
	if n, _ := app.CountRecords(auth.UsersCollection); n != 1 {
		t.Errorf("users = %d, want 1", n)
	}
}

func TestDemoNeedsTheUser(t *testing.T) {
	app := newApp(t)
	for _, dry := range []bool{true, false} {
		_, err := seed.Demo(app, seed.DemoOptions{DryRun: dry})
		if !errors.Is(err, seed.ErrNoDemoUser) {
			t.Errorf("dry %v: err = %v, want ErrNoDemoUser", dry, err)
		}
	}
	if n, _ := app.CountRecords("organizations"); n != 0 {
		t.Errorf("organizations = %d", n)
	}
}

func TestDemoDryRunWritesNothing(t *testing.T) {
	app := newApp(t)
	newDemoUser(t, app)
	before := lastSeq(t, app)

	r := runDemo(t, app, seed.DemoOptions{DryRun: true})
	if !r.DryRun || r.OrgExisted || r.Reset || r.Total() != wantTotal {
		t.Errorf("report = %+v", r)
	}
	checkCounts(t, r.Counts, false)
	for table, n := range orgRows(t, app, seed.DemoOrgID) {
		if n != 0 {
			t.Errorf("%s: %d rows after a dry run", table, n)
		}
	}
	if got := lastSeq(t, app); got != before {
		t.Errorf("server_seq moved: %d → %d", before, got)
	}
}

func TestDemoWritesTheSQLRowsOnce(t *testing.T) {
	app := newApp(t)
	user := newDemoUser(t, app)
	before := lastSeq(t, app)

	r := runDemo(t, app, seed.DemoOptions{})
	if r.DryRun || r.OrgExisted || r.Total() != wantTotal {
		t.Errorf("report = %+v", r)
	}
	checkCounts(t, r.Counts, false)
	got := orgRows(t, app, seed.DemoOrgID)
	for _, w := range wantCounts {
		if got[w.Table] != w.Rows {
			t.Errorf("%s: %d rows in the database, want %d", w.Table, got[w.Table], w.Rows)
		}
	}
	// Every row went through the seq hook: one number each.
	if got := lastSeq(t, app); got != before+wantTotal {
		t.Errorf("last_seq = %d, want %d", got, before+wantTotal)
	}
	m, err := app.FindFirstRecordByData("memberships", "org_id", seed.DemoOrgID)
	if err != nil {
		t.Fatal(err)
	}
	if m.GetString("user_id") != user.Id || m.GetString("role") != "owner" || m.GetInt("server_seq") <= int(before) {
		t.Errorf("membership = %v", m.FieldsData())
	}

	// The second run writes nothing: no row, no number.
	org, _ := app.FindRecordById("organizations", seed.DemoOrgID)
	seqAfter := lastSeq(t, app)
	for _, dry := range []bool{true, false} {
		r2 := runDemo(t, app, seed.DemoOptions{DryRun: dry})
		if !r2.OrgExisted || r2.Reset || r2.Total() != 0 {
			t.Errorf("dry %v: second report = %+v", dry, r2)
		}
		checkCounts(t, r2.Counts, true)
		if !strings.Contains(r2.String(), "nothing") {
			t.Errorf("dry %v: report text %q", dry, r2.String())
		}
	}
	if got := lastSeq(t, app); got != seqAfter {
		t.Errorf("second run moved server_seq: %d → %d", seqAfter, got)
	}
	org2, _ := app.FindRecordById("organizations", seed.DemoOrgID)
	if org.GetString("updated_at") != org2.GetString("updated_at") || org.GetInt("server_seq") != org2.GetInt("server_seq") {
		t.Error("the second run changed the organization")
	}
}

func TestDemoValues(t *testing.T) {
	app := newApp(t)
	newDemoUser(t, app)
	runDemo(t, app, seed.DemoOptions{Date: "2026-11-12"})

	org, err := app.FindRecordById("organizations", seed.DemoOrgID)
	if err != nil {
		t.Fatal(err)
	}
	want := map[string]string{
		"name": "Demo Arıcılık", "country_code": "TR", "currency": "TRY",
		"hive_count_range": "up_to_50", "operation_type": "migratory", "avatar_color": "honey",
		// The SQL's column default now(): the run's clock.
		"created_at": "2026-11-12T09:41:07.000000Z",
	}
	for k, v := range want {
		if got := org.GetString(k); got != v {
			t.Errorf("organizations.%s = %q, want %q", k, got, v)
		}
	}

	hive := func(number string) *core.Record {
		t.Helper()
		h, err := app.FindFirstRecordByFilter("hives", "org_id = {:o} && number = {:n}", dbx.Params{"o": seed.DemoOrgID, "n": number})
		if err != nil {
			t.Fatal(err)
		}
		return h
	}
	dead := hive("15")
	if dead.GetString("status") != "dead" || dead.GetString("queen_id") != "" {
		t.Errorf("hive 15 = %v", dead.FieldsData())
	}
	if n, _ := app.CountRecords("inspections", dbx.HashExp{"hive_id": dead.Id}); n != 0 {
		t.Errorf("dead hive has %d inspections", n)
	}
	ev, err := app.FindFirstRecordByData("hive_status_events", "hive_id", dead.Id)
	if err != nil || ev.GetString("loss_reason") != "varroa" || ev.GetString("changed_at") != "2026-10-31T12:00:00.000000Z" {
		t.Errorf("status event = %v, %v", ev, err)
	}
	if h4 := hive("4"); h4.GetString("type") != "dadant" || h4.GetInt("box_count") != 2 {
		t.Errorf("hive 4 = %v", h4.FieldsData())
	}

	// Hive 1, first inspection: now_ts - 40 days + 1 × 7 minutes.
	h1 := hive("1")
	insp, err := app.FindRecordsByFilter("inspections", "hive_id = {:h}", "inspected_at", 0, 0, dbx.Params{"h": h1.Id})
	if err != nil || len(insp) != 2 {
		t.Fatalf("hive 1 inspections = %d, %v", len(insp), err)
	}
	if got := insp[0].GetString("inspected_at"); got != "2026-10-03T12:07:00.000000Z" {
		t.Errorf("inspected_at = %s", got)
	}
	if got := insp[0].GetString("data"); got != `{"actions":["super_removed"]}` {
		t.Errorf("data = %s", got)
	}
	h5 := hive("5")
	second, err := app.FindFirstRecordByFilter("inspections", "hive_id = {:h} && inspected_at > '2026-11'", dbx.Params{"h": h5.Id})
	if err != nil || second.GetString("queen_cells") != "emergency" || second.GetString("queen_state") != "none" {
		t.Errorf("hive 5 second inspection = %v, %v", second, err)
	}

	tr, err := app.FindRecordsByFilter("treatments", "org_id = {:o}", "", 0, 0, dbx.Params{"o": seed.DemoOrgID})
	if err != nil || len(tr) != 3 {
		t.Fatalf("treatments = %d, %v", len(tr), err)
	}
	for _, r := range tr {
		if r.GetString("product_name") != "Bayvarol Kovan İçi Şerit" || r.GetInt("withdrawal_days") != 0 ||
			r.GetString("planned_removal_at") != "2026-12-06T12:00:00.000000Z" ||
			r.GetString("application_id") != tr[0].GetString("application_id") {
			t.Errorf("treatment = %v", r.FieldsData())
		}
	}

	task, err := app.FindFirstRecordByData("tasks", "title", "5 numaralı kovanda ana arı kontrolü")
	if err != nil || task.GetString("hive_id") != h5.Id || task.GetString("apiary_id") != h5.GetString("apiary_id") {
		t.Errorf("task = %v, %v", task, err)
	}
	sale, err := app.FindFirstRecordByData("transactions", "description", "Çam balı, 162 kg")
	if err != nil || sale.GetString("occurred_on") != "2026-09-28" || sale.GetFloat("amount") != 48750 {
		t.Errorf("transaction = %v, %v", sale, err)
	}
}

// Without --date the data follows the clock, truncated to the hour.
func TestDemoDatesFollowTheClock(t *testing.T) {
	app := newApp(t)
	newDemoUser(t, app)
	runDemo(t, app, seed.DemoOptions{})
	ev, err := app.FindFirstRecordByData("hive_status_events", "org_id", seed.DemoOrgID)
	if err != nil {
		t.Fatal(err)
	}
	if got := ev.GetString("changed_at"); got != "2026-10-31T09:00:00.000000Z" {
		t.Errorf("changed_at = %s", got)
	}
	if _, err := seed.Demo(app, seed.DemoOptions{Date: "12.11.2026"}); err == nil {
		t.Error("a bad --date was accepted")
	}
}

func TestDemoForceResetTouchesOnlyTheDemoOrganization(t *testing.T) {
	app := newApp(t)
	user := newDemoUser(t, app)
	runDemo(t, app, seed.DemoOptions{Date: "2026-11-12"})
	firstIDs := ids(t, app, "inspections")

	// Another user's organization with an apiary, and a row added to the
	// demo organization after the seed.
	users, _ := app.FindCollectionByNameOrId("users")
	other := core.NewRecord(users)
	other.SetEmail("other@test.local")
	other.SetPassword("1234567890")
	if err := app.Save(other); err != nil {
		t.Fatal(err)
	}
	const otherOrg = "0195f2a4-0000-7000-8000-0000000000aa"
	name, country, currency := "Başka", "DE", "EUR"
	if _, err := orgs.Create(app, other.Id, orgs.Request{ID: otherOrg, Name: &name, CountryCode: &country, Currency: &currency}); err != nil {
		t.Fatal(err)
	}
	for _, org := range []string{otherOrg, seed.DemoOrgID} {
		addApiary(t, app, org, user.Id)
	}

	dry := runDemo(t, app, seed.DemoOptions{DryRun: true, ForceReset: true})
	if !dry.Reset || dry.Total() != wantTotal || orgRows(t, app, seed.DemoOrgID)["apiaries"] != 4 {
		t.Errorf("dry reset = %+v", dry)
	}

	r := runDemo(t, app, seed.DemoOptions{ForceReset: true, Date: "2026-11-12"})
	if !r.Reset || r.Total() != wantTotal {
		t.Errorf("report = %+v", r)
	}
	got := orgRows(t, app, seed.DemoOrgID)
	for _, w := range wantCounts {
		if got[w.Table] != w.Rows {
			t.Errorf("%s: %d rows after reset, want %d", w.Table, got[w.Table], w.Rows)
		}
	}
	// The same fixed ids again.
	if again := ids(t, app, "inspections"); strings.Join(again, ",") != strings.Join(firstIDs, ",") {
		t.Error("the reset wrote other ids")
	}
	// The other organization and both users stay.
	if o := orgRows(t, app, otherOrg); o["organizations"] != 1 || o["memberships"] != 1 || o["apiaries"] != 1 {
		t.Errorf("other organization = %v", o)
	}
	if n, _ := app.CountRecords("users"); n != 2 {
		t.Errorf("users = %d", n)
	}
}

func addApiary(t *testing.T, app core.App, orgID, userID string) {
	t.Helper()
	c, _ := app.FindCollectionByNameOrId("apiaries")
	r := core.NewRecord(c)
	r.Set("org_id", orgID)
	r.Set("name", "Ek arılık")
	r.Set("created_by", userID)
	r.Set("created_at", "2026-11-12T10:00:00.000000Z")
	r.Set("updated_at", "2026-11-12T10:00:00.000000Z")
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
}

func ids(t *testing.T, app core.App, table string) []string {
	t.Helper()
	var out []string
	err := app.DB().Select("id").From(table).Where(dbx.HashExp{"org_id": seed.DemoOrgID}).OrderBy("id").Column(&out)
	if err != nil {
		t.Fatal(err)
	}
	return out
}

func TestVerifyRef(t *testing.T) {
	app := newApp(t)
	expect, err := os.ReadFile("../../ops/ref_expected.json")
	if err != nil {
		t.Fatal(err)
	}
	r, err := seed.VerifyRef(app, expect)
	if err != nil {
		t.Fatal(err)
	}
	if !r.OK() {
		t.Fatalf("migration ref data differs from Supabase:\n%s", r)
	}

	mutate := func(f func(map[string]map[string]any)) []byte {
		var d map[string]map[string]any
		_ = json.Unmarshal(expect, &d)
		f(d)
		b, _ := json.Marshal(d)
		return b
	}

	// A different count.
	r, err = seed.VerifyRef(app, mutate(func(d map[string]map[string]any) { d["ref_drugs"]["count"] = 22 }))
	if err != nil || r.OK() || !strings.Contains(r.String(), "DIFFERENT") {
		t.Errorf("count 22: ok %v, err %v\n%s", r.OK(), err, r)
	}
	// A different value, and a time with another offset that is the same
	// instant.
	r, err = seed.VerifyRef(app, mutate(func(d map[string]map[string]any) {
		s := d["ref_drugs"]["samples"].([]any)
		s[0].(map[string]any)["name_en"] = "Amitraz X"
		s[1].(map[string]any)["deleted_at"] = "2026-10-31T23:32:34.866517+03:00"
	}))
	if err != nil || r.OK() || len(r.Tables[0].Differences) != 1 || !strings.Contains(r.Tables[0].Differences[0], "name_en") {
		t.Errorf("changed sample: err %v\n%s", err, r)
	}
	// A missing row.
	r, _ = seed.VerifyRef(app, mutate(func(d map[string]map[string]any) {
		d["ref_support_periods"]["samples"] = []any{map[string]any{"id": "01900000-0000-7000-8000-000000000999"}}
	}))
	if r.OK() || !strings.Contains(r.String(), "missing") {
		t.Errorf("missing row:\n%s", r)
	}
	// Malformed files.
	for _, bad := range []string{`[]`, `{"ref_drugs": {"count": 21}}`, `{"other": {"count": 1}}`} {
		if _, err := seed.VerifyRef(app, []byte(bad)); err == nil {
			t.Errorf("%s was accepted", bad)
		}
	}
}

func run(t *testing.T, app core.App, read seed.PasswordReader, stdin string, args ...string) (string, error) {
	t.Helper()
	cmd := seed.NewCommand(app, read, config.EnvDev)
	var out bytes.Buffer
	cmd.SetOut(&out)
	cmd.SetErr(&out)
	cmd.SetIn(strings.NewReader(stdin))
	cmd.SetArgs(args)
	err := cmd.Execute()
	return out.String(), err
}

func TestCommands(t *testing.T) {
	app := newApp(t)

	out, err := run(t, app, nil, "", "demo", "--dry-run")
	if !errors.Is(err, seed.ErrNoDemoUser) {
		t.Errorf("demo without user: %v\n%s", err, out)
	}

	read := func(*cobra.Command) (string, error) { return demoPassword, nil }
	out, err = run(t, app, read, "", "demo-user", "--email", auth.DemoEmail)
	if err != nil || !strings.Contains(out, "Opened") || strings.Contains(out, demoPassword) {
		t.Errorf("demo-user: %v\n%s", err, out)
	}
	// Not a terminal: one line of stdin (the default reader).
	out, err = run(t, app, nil, "654321\n", "demo-user")
	if err != nil || !strings.Contains(out, "existed") {
		t.Errorf("demo-user from stdin: %v\n%s", err, out)
	}
	if u, _ := seed.FindDemoUser(app); !u.ValidatePassword("654321") {
		t.Error("stdin password not set")
	}

	out, err = run(t, app, nil, "", "demo", "--dry-run", "--date", "2026-11-12")
	if err != nil || !strings.Contains(out, "Dry run") || !strings.Contains(out, "inspections") || !strings.Contains(out, "133") {
		t.Errorf("dry run: %v\n%s", err, out)
	}
	if n, _ := app.CountRecords("organizations"); n != 0 {
		t.Error("the dry run wrote")
	}
	if _, err = run(t, app, nil, "", "demo"); err != nil {
		t.Fatal(err)
	}
	out, err = run(t, app, nil, "", "demo", "--dry-run")
	if err != nil || !strings.Contains(out, "total                     0") {
		t.Errorf("second dry run: %v\n%s", err, out)
	}

	expect, _ := os.ReadFile("../../ops/ref_expected.json")
	out, err = run(t, app, nil, string(expect), "verify-ref", "--expect", "-")
	if err != nil || strings.Contains(out, "DIFFERENT") {
		t.Errorf("verify-ref: %v\n%s", err, out)
	}
	out, err = run(t, app, nil, `{"ref_drugs":{"count":1},"ref_support_periods":{"count":0}}`, "verify-ref", "--expect", "-")
	if err == nil || !strings.Contains(out, "DIFFERENT") {
		t.Errorf("verify-ref with a wrong count: %v\n%s", err, out)
	}
}
