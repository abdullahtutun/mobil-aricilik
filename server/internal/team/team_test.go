package team_test

import (
	"encoding/json"
	"io"
	"net/http"
	"regexp"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/team"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/google/uuid"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// The rows of supabase/tests/database/invites_rls.test.sql and
// memberships_rls.test.sql: 1111 owner, 2222 partner, 3333 worker, 4444 new
// user, 5555 viewer of aaaa; 9999 owns eeee.
const (
	owner    = "11111111-1111-1111-1111-111111111111"
	partner  = "22222222-2222-2222-2222-222222222222"
	worker   = "33333333-3333-3333-3333-333333333333"
	newcomer = "44444444-4444-4444-4444-444444444444"
	viewer   = "55555555-5555-5555-5555-555555555555"
	outsider = "99999999-9999-9999-9999-999999999999"
	orgA     = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	orgE     = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"
	testTime = "2026-10-01T00:00:00.000000Z"
)

var emails = map[string]string{
	owner: "owner@test.local", partner: "partner@test.local", worker: "worker@test.local",
	newcomer: "new@test.local", viewer: "viewer@test.local", outsider: "outsider@test.local",
}

type fixture struct {
	app    *tests.TestApp
	tokens map[string]string
}

func newFixture(t *testing.T) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev}, "test")

	f := &fixture{app: app, tokens: map[string]string{}}
	for _, id := range []string{owner, partner, worker, newcomer, viewer, outsider} {
		u := core.NewRecord(f.collection(t, "users"))
		u.Id = id
		u.SetEmail(emails[id])
		u.SetPassword("1234567890")
		f.save(t, u)
		tok, err := u.NewAuthToken()
		if err != nil {
			t.Fatal(err)
		}
		f.tokens[id] = tok
	}
	for _, o := range []struct{ id, name, by string }{
		{orgA, "Petek Arıcılık", owner},
		{orgE, "Başka İşletme", outsider},
	} {
		f.insert(t, "organizations", o.id, map[string]any{
			"name": o.name, "country_code": "TR", "currency": "TRY",
			"operation_type": "migratory", "created_by": o.by,
		})
	}
	for _, m := range []struct{ id, org, user, role string }{
		{"c0000000-0000-0000-0000-000000000001", orgA, owner, "owner"},
		{"c0000000-0000-0000-0000-000000000002", orgA, partner, "partner"},
		{"c0000000-0000-0000-0000-000000000003", orgA, worker, "worker"},
		{"c0000000-0000-0000-0000-000000000005", orgA, viewer, "viewer"},
		{"c0000000-0000-0000-0000-000000000009", orgE, outsider, "owner"},
	} {
		f.insert(t, "memberships", m.id, map[string]any{"org_id": m.org, "user_id": m.user, "role": m.role})
	}
	return f
}

func (f *fixture) collection(t testing.TB, name string) *core.Collection {
	t.Helper()
	c, err := f.app.FindCachedCollectionByNameOrId(name)
	if err != nil {
		t.Fatal(err)
	}
	return c
}

func (f *fixture) save(t testing.TB, r *core.Record) {
	t.Helper()
	if err := f.app.Save(r); err != nil {
		t.Fatalf("save %s %s: %v", r.Collection().Name, r.Id, err)
	}
}

func (f *fixture) insert(t testing.TB, collection, id string, fields map[string]any) *core.Record {
	t.Helper()
	r := core.NewRecord(f.collection(t, collection))
	r.Id = id
	r.Set("created_at", testTime)
	if r.Collection().Fields.GetByName("updated_at") != nil {
		r.Set("updated_at", testTime)
	}
	for k, v := range fields {
		r.Set(k, v)
	}
	f.save(t, r)
	return r
}

// invite stores a code directly, like the pgTAP files' inserts.
func (f *fixture) invite(t testing.TB, code, role, expiresAt string) *core.Record {
	t.Helper()
	r := core.NewRecord(f.collection(t, "invites"))
	r.Set("org_id", orgA)
	r.Set("code", code)
	r.Set("role", role)
	r.Set("created_at", testTime)
	r.Set("created_by", owner)
	r.Set("expires_at", expiresAt)
	f.save(t, r)
	return r
}

type response struct {
	status int
	body   []byte
}

func (r response) object(t testing.TB) map[string]any {
	t.Helper()
	var out map[string]any
	if err := json.Unmarshal(r.body, &out); err != nil {
		t.Fatalf("body %s: %v", r.body, err)
	}
	return out
}

func (r response) code(t testing.TB) string {
	t.Helper()
	data, _ := r.object(t)["data"].(map[string]any)
	c, _ := data["code"].(string)
	return c
}

// post calls POST /api/app/team/<action> as user ("" for anonymous) and
// checks the status and, for a refusal, data.code.
func (f *fixture) post(t *testing.T, user, action string, body any, wantStatus int, wantCode string) response {
	t.Helper()
	headers := map[string]string{"Content-Type": "application/json"}
	if user != "" {
		headers["Authorization"] = f.tokens[user]
	}
	raw, ok := body.(string)
	if !ok {
		b, err := json.Marshal(body)
		if err != nil {
			t.Fatal(err)
		}
		raw = string(b)
	}
	var out response
	s := tests.ApiScenario{
		Name:                  action,
		Method:                http.MethodPost,
		URL:                   team.RoutePrefix + action,
		Body:                  strings.NewReader(raw),
		Headers:               headers,
		ExpectedStatus:        wantStatus,
		ExpectedContent:       []string{""},
		TestAppFactory:        func(testing.TB) *tests.TestApp { return f.app },
		DisableTestAppCleanup: true,
		AfterTestFunc: func(t testing.TB, _ *tests.TestApp, res *http.Response) {
			b, err := io.ReadAll(res.Body)
			if err != nil {
				t.Fatal(err)
			}
			out = response{status: res.StatusCode, body: b}
		},
	}
	s.Test(t)
	if wantCode != "" {
		if got := out.code(t); got != wantCode {
			t.Fatalf("%s as %s: code = %q, want %q (%s)", action, user, got, wantCode, out.body)
		}
	}
	return out
}

func (f *fixture) createInvite(t *testing.T, user, org, role string, wantStatus int, wantCode string) response {
	t.Helper()
	return f.post(t, user, "create", map[string]any{"org_id": org, "role": role}, wantStatus, wantCode)
}

func (f *fixture) liveMembership(t testing.TB, org, user string) *core.Record {
	t.Helper()
	r := &core.Record{}
	err := f.app.RecordQuery("memberships").
		AndWhere(dbx.HashExp{"org_id": org, "user_id": user, "deleted_at": ""}).
		Limit(1).One(r)
	if err != nil {
		return nil
	}
	return r
}

func (f *fixture) inviteByCode(t testing.TB, code string) *core.Record {
	t.Helper()
	r, err := f.app.FindFirstRecordByData("invites", "code", code)
	if err != nil {
		t.Fatalf("invite %s: %v", code, err)
	}
	return r
}

func k5(t time.Time) string { return pattern.FormatTimestamp(t) }

func mustTime(t testing.TB, s string) time.Time {
	t.Helper()
	v, err := time.Parse(pattern.TimestampLayout, s)
	if err != nil {
		t.Fatal(err)
	}
	return v
}

// fixedCodes makes the code source return codes in order, then panic.
func fixedCodes(t *testing.T, codes ...string) {
	t.Helper()
	var mu sync.Mutex
	t.Cleanup(team.SetGenerateCode(func() string {
		mu.Lock()
		defer mu.Unlock()
		if len(codes) == 0 {
			t.Fatal("no more test codes")
		}
		c := codes[0]
		codes = codes[1:]
		return c
	}))
}

// TestInvites_invites_rls_test_sql carries invites_rls.test.sql. The
// inserts become create calls; the code comes from the stubbed source. The
// two select scenarios have no counterpart: no route lists invites (only
// the server reads them), so "worker davetleri göremez" is "the invites
// collection's API rules are null" (migrations/api_rules_test.go).
func TestInvites_invites_rls_test_sql(t *testing.T) {
	f := newFixture(t)
	base := time.Date(2026, 10, 27, 9, 0, 0, 0, time.UTC)
	t.Cleanup(team.SetNow(func() time.Time { return base }))

	// owner davet üretir
	fixedCodes(t, "AR7K2Q", "AR7K2Q", "MN3PQ4")
	got := f.createInvite(t, owner, orgA, "worker", http.StatusOK, "").object(t)
	if got["code"] != "AR7K2Q" || got["role"] != "worker" {
		t.Fatalf("create = %v", got)
	}
	inv := f.inviteByCode(t, "AR7K2Q")
	if inv.GetString("org_id") != orgA || inv.GetString("created_by") != owner ||
		inv.GetString("used_at") != "" || inv.GetString("role") != "worker" {
		t.Errorf("invite = %v", inv.PublicExport())
	}
	if v := uuid.MustParse(inv.Id).Version(); v != 7 {
		t.Errorf("invite id is UUIDv%d", v)
	}

	// davet 48 saat geçerli
	if d := mustTime(t, inv.GetString("expires_at")).Sub(mustTime(t, inv.GetString("created_at"))); d != 48*time.Hour {
		t.Errorf("expires_at - created_at = %v", d)
	}
	if got["expires_at"] != inv.GetString("expires_at") {
		t.Errorf("answered expires_at %v, stored %s", got["expires_at"], inv.GetString("expires_at"))
	}

	// owner rolüyle davet olmaz
	f.createInvite(t, owner, orgA, "owner", http.StatusBadRequest, team.CodeBadRole)

	// aynı kod ikinci kez üretilemez: the route draws another one.
	// partner davet üretir
	got = f.createInvite(t, partner, orgA, "viewer", http.StatusOK, "").object(t)
	if got["code"] != "MN3PQ4" {
		t.Fatalf("taken code was not drawn again: %v", got)
	}
	if n, _ := f.app.CountRecords("invites"); n != 2 {
		t.Errorf("%d invites, want 2", n)
	}

	// worker, viewer and an outsider (başka işletmeye) cannot create.
	for _, u := range []string{worker, viewer, outsider} {
		f.createInvite(t, u, orgA, "worker", http.StatusForbidden, team.CodeForbidden)
	}
	// A removed member cannot either.
	m := f.liveMembership(t, orgA, partner)
	m.Set("deleted_at", k5(base))
	f.save(t, m)
	f.createInvite(t, partner, orgA, "worker", http.StatusForbidden, team.CodeForbidden)
	if n, _ := f.app.CountRecords("invites"); n != 2 {
		t.Errorf("refused creates wrote invites: %d", n)
	}
}

func TestCreateInviteRequests(t *testing.T) {
	f := newFixture(t)
	f.post(t, "", "create", map[string]any{"org_id": orgA, "role": "worker"}, http.StatusUnauthorized, "")
	f.post(t, owner, "create", "{", http.StatusBadRequest, team.CodeBadRequest)
	f.post(t, owner, "create", "[]", http.StatusBadRequest, team.CodeBadRequest)
	f.post(t, owner, "create", map[string]any{"role": "worker"}, http.StatusBadRequest, team.CodeBadRequest)
	f.createInvite(t, owner, "not-a-uuid", "worker", http.StatusBadRequest, team.CodeBadRequest)
	// bad_request comes before bad_role, bad_role before forbidden.
	f.createInvite(t, owner, "x", "owner", http.StatusBadRequest, team.CodeBadRequest)
	f.createInvite(t, worker, orgA, "admin", http.StatusBadRequest, team.CodeBadRole)
	f.post(t, owner, "create", map[string]any{"org_id": orgA}, http.StatusBadRequest, team.CodeBadRole)

	// Every code drawn is taken: 500 server after five tries.
	f.invite(t, "AAAAAA", "worker", k5(time.Now().Add(time.Hour)))
	fixedCodes(t, "AAAAAA", "AAAAAA", "AAAAAA", "AAAAAA", "AAAAAA")
	f.createInvite(t, owner, orgA, "worker", http.StatusInternalServerError, team.CodeServer)
}

func TestGeneratedCodes(t *testing.T) {
	re := regexp.MustCompile(`^[ABCDEFGHJKMNPQRSTUVWXYZ23456789]{6}$`)
	seen := map[rune]bool{}
	for range 2000 {
		c := team.GenerateCode()
		if !team.IsCode(c) || !re.MatchString(c) {
			t.Fatalf("%q is not a code", c)
		}
		for _, r := range c {
			seen[r] = true
		}
	}
	if len(seen) != len(team.CodeAlphabet) {
		t.Errorf("2000 codes used %d of %d characters", len(seen), len(team.CodeAlphabet))
	}
	// The alphabet is the invites code pattern's.
	f := newFixture(t)
	field, _ := f.collection(t, "invites").Fields.GetByName("code").(*core.TextField)
	if field == nil || field.Pattern != "^["+team.CodeAlphabet+"]{6}$" {
		t.Errorf("invites.code pattern %v does not use the alphabet", field)
	}

	for in, want := range map[string]string{
		"ar7k2q": "AR7K2Q", " AR7-K2Q\n": "AR7K2Q", "ar 7k\t2q": "AR7K2Q",
	} {
		if got := team.NormalizeCode(in); got != want {
			t.Errorf("NormalizeCode(%q) = %q", in, got)
		}
	}
	for _, c := range []string{"AR0K2Q", "AR7K2", "AR7K2QQ", "ar7k2q", "ARİK2Q"} {
		if team.IsCode(c) {
			t.Errorf("IsCode(%q)", c)
		}
	}
}

// TestRedeem is index.ts's redeem: the code is claimed and the membership
// added together; unknown, expired and used codes are the same 404.
func TestRedeem(t *testing.T) {
	f := newFixture(t)
	future := k5(time.Now().Add(time.Hour))
	f.invite(t, "AR7K2Q", "viewer", future)

	// owner üye ekler: the newcomer joins with the code's role. The code is
	// typed loosely.
	got := f.post(t, newcomer, "redeem", map[string]any{"code": " ar7-k2q "}, http.StatusOK, "").object(t)
	if got["org_id"] != orgA || got["role"] != "viewer" || len(got) != 2 {
		t.Fatalf("redeem = %v", got)
	}
	m := f.liveMembership(t, orgA, newcomer)
	if m == nil || m.GetString("role") != "viewer" || m.GetString("created_by") != newcomer {
		t.Fatalf("membership = %v", m)
	}
	if v := uuid.MustParse(m.Id).Version(); v != 7 {
		t.Errorf("membership id is UUIDv%d", v)
	}
	if m.GetInt("server_seq") <= 0 || !pattern.IsTimestamp(m.GetString("updated_at")) {
		t.Errorf("membership seq/time = %d %q", m.GetInt("server_seq"), m.GetString("updated_at"))
	}
	inv := f.inviteByCode(t, "AR7K2Q")
	if inv.GetString("used_by") != newcomer || inv.GetString("used_at") != m.GetString("created_at") {
		t.Errorf("invite after redeem = %v", inv.PublicExport())
	}
	// The new member reaches the devices: it is in the organization's pull.
	page, err := appsync.Pull(f.app, owner, "memberships", 0, 100)
	if err != nil {
		t.Fatal(err)
	}
	found := false
	for _, row := range page.Rows {
		found = found || row["user_id"] == newcomer
	}
	if !found {
		t.Error("the new membership is not pulled")
	}

	// A used code, an unknown code, an expired code and a malformed one
	// are all invalid_code.
	f.invite(t, "XY5Z67", "worker", k5(time.Now().Add(-time.Second)))
	for _, code := range []any{"AR7K2Q", "BCDEFG", "XY5Z67", "AR0K2Q", "", 7, nil} {
		f.post(t, outsider, "redeem", map[string]any{"code": code}, http.StatusNotFound, team.CodeInvalidCode)
	}
	f.post(t, outsider, "redeem", map[string]any{}, http.StatusNotFound, team.CodeInvalidCode)
	f.post(t, outsider, "redeem", "{", http.StatusBadRequest, team.CodeBadRequest)
	f.post(t, "", "redeem", map[string]any{"code": "AR7K2Q"}, http.StatusUnauthorized, "")
	if f.liveMembership(t, orgA, outsider) != nil {
		t.Fatal("a refused redeem added a membership")
	}

	// already_member leaves the code unused, so someone else can use it.
	f.invite(t, "MN3PQ4", "worker", future)
	f.post(t, worker, "redeem", map[string]any{"code": "MN3PQ4"}, http.StatusConflict, team.CodeAlreadyMember)
	if inv := f.inviteByCode(t, "MN3PQ4"); inv.GetString("used_at") != "" || inv.GetString("used_by") != "" {
		t.Fatalf("already_member claimed the code: %v", inv.PublicExport())
	}
	if m := f.liveMembership(t, orgA, worker); m.GetString("role") != "worker" {
		t.Fatalf("worker's role changed to %s", m.GetString("role"))
	}
	f.post(t, outsider, "redeem", map[string]any{"code": "MN3PQ4"}, http.StatusOK, "")

	// A removed member may join again with a new code.
	removed := f.liveMembership(t, orgA, viewer)
	removed.Set("deleted_at", k5(time.Now()))
	f.save(t, removed)
	f.invite(t, "PQ4RS5", "partner", future)
	f.post(t, viewer, "redeem", map[string]any{"code": "PQ4RS5"}, http.StatusOK, "")
	if m := f.liveMembership(t, orgA, viewer); m == nil || m.GetString("role") != "partner" || m.Id == removed.Id {
		t.Fatalf("rejoin = %v", m)
	}
}

// TestRedeemIsAtomic: the claim and the membership are one transaction; a
// failing membership write leaves the code unused.
func TestRedeemIsAtomic(t *testing.T) {
	f := newFixture(t)
	f.invite(t, "AR7K2Q", "worker", k5(time.Now().Add(time.Hour)))
	fail := true
	f.app.OnRecordCreate("memberships").BindFunc(func(e *core.RecordEvent) error {
		if fail {
			return io.ErrUnexpectedEOF
		}
		return e.Next()
	})
	f.post(t, newcomer, "redeem", map[string]any{"code": "AR7K2Q"}, http.StatusInternalServerError, team.CodeServer)
	if inv := f.inviteByCode(t, "AR7K2Q"); inv.GetString("used_at") != "" {
		t.Fatal("the code stayed claimed after the membership failed")
	}
	fail = false
	f.post(t, newcomer, "redeem", map[string]any{"code": "AR7K2Q"}, http.StatusOK, "")
}

// TestRedeemRace: many users redeem one code at once; exactly one joins.
func TestRedeemRace(t *testing.T) {
	f := newFixture(t)
	f.invite(t, "AR7K2Q", "worker", k5(time.Now().Add(time.Hour)))
	users := []string{newcomer, outsider}
	for i := range 10 {
		users = append(users, uuid.Must(uuid.NewV7()).String())
		_ = i
	}
	var (
		wg      sync.WaitGroup
		mu      sync.Mutex
		ok      int
		invalid int
	)
	for _, u := range users {
		wg.Add(1)
		go func() {
			defer wg.Done()
			_, err := team.Redeem(f.app, u, "AR7K2Q")
			mu.Lock()
			defer mu.Unlock()
			switch {
			case err == nil:
				ok++
			case team.FailureCode(err) == team.CodeInvalidCode:
				invalid++
			default:
				t.Errorf("redeem: %v", err)
			}
		}()
	}
	wg.Wait()
	if ok != 1 || invalid != len(users)-1 {
		t.Fatalf("%d joined, %d invalid_code; want 1 and %d", ok, invalid, len(users)-1)
	}
	n, err := f.app.CountRecords("memberships", dbx.HashExp{"org_id": orgA, "role": "worker"})
	if err != nil {
		t.Fatal(err)
	}
	if n != 2 { // the fixture's worker and the winner
		t.Fatalf("%d workers, want 2", n)
	}
}

// TestRedeemRateLimit: 10 attempts a minute per user, whatever the
// outcome; other users are not affected.
func TestRedeemRateLimit(t *testing.T) {
	f := newFixture(t)
	base := time.Now()
	clock := base
	t.Cleanup(team.SetNow(func() time.Time { return clock }))

	for range team.RedeemLimit {
		f.post(t, newcomer, "redeem", map[string]any{"code": "BCDEFG"}, http.StatusNotFound, team.CodeInvalidCode)
	}
	f.invite(t, "AR7K2Q", "worker", k5(base.Add(time.Hour)))
	f.post(t, newcomer, "redeem", map[string]any{"code": "AR7K2Q"}, http.StatusTooManyRequests, team.CodeTooManyRequests)
	if f.liveMembership(t, orgA, newcomer) != nil {
		t.Fatal("a limited attempt joined")
	}
	f.post(t, outsider, "redeem", map[string]any{"code": "BCDEFG"}, http.StatusNotFound, team.CodeInvalidCode)
	// The other routes are not limited.
	f.post(t, newcomer, "members", map[string]any{"org_id": orgA}, http.StatusForbidden, team.CodeForbidden)

	clock = base.Add(team.RedeemWindow + time.Second)
	f.post(t, newcomer, "redeem", map[string]any{"code": "AR7K2Q"}, http.StatusOK, "")
}

func TestLimiter(t *testing.T) {
	l := team.NewLimiter(2, time.Minute)
	t0 := time.Date(2026, 11, 10, 9, 0, 0, 0, time.UTC)
	steps := []struct {
		key  string
		at   time.Duration
		want bool
	}{
		{"a", 0, true},
		{"a", 10 * time.Second, true},
		{"a", 20 * time.Second, false},
		{"b", 20 * time.Second, true},
		{"a", time.Minute, true}, // the first attempt left the window
		{"a", time.Minute + 5*time.Second, false},
		{"a", time.Minute + 10*time.Second, true},
	}
	for i, s := range steps {
		if got := l.Allow(s.key, t0.Add(s.at)); got != s.want {
			t.Fatalf("step %d: allow(%s, +%v) = %v", i, s.key, s.at, got)
		}
	}
	// Idle keys are swept once many are held.
	for i := range 1100 {
		l.Allow(uuid.NewString()+string(rune(i)), t0)
	}
	l.Allow("late", t0.Add(2*time.Minute))
	if n := l.Keys(); n > 10 {
		t.Errorf("%d keys held after the sweep", n)
	}
}

// TestMemberships_memberships_rls_test_sql carries memberships_rls.test.sql
// to the routes that now do what the client did through RLS: members (the
// select), redeem (the only insert), set_role and remove (the updates).
func TestMemberships_memberships_rls_test_sql(t *testing.T) {
	f := newFixture(t)
	// memberships_rls has only owner and worker in aaaa.
	for _, u := range []string{partner, viewer} {
		m := f.liveMembership(t, orgA, u)
		if err := f.app.Delete(m); err != nil {
			t.Fatal(err)
		}
	}

	// üye olmayan işletmenin üyeliklerini göremez
	f.post(t, outsider, "members", map[string]any{"org_id": orgA}, http.StatusForbidden, team.CodeForbidden)

	// worker işletmedeki tüm üyelikleri görür
	got := f.post(t, worker, "members", map[string]any{"org_id": orgA}, http.StatusOK, "").object(t)
	wantMembers(t, got, map[string]any{owner: emails[owner], worker: emails[worker]})

	// worker üye ekleyemez: the only way in is a code, and a worker gets
	// none.
	f.createInvite(t, worker, orgA, "viewer", http.StatusForbidden, team.CodeForbidden)

	// worker kendi rolünü yükseltemez
	f.post(t, worker, "set_role", map[string]any{"org_id": orgA, "user_id": worker, "role": "partner"},
		http.StatusForbidden, team.CodeForbidden)
	f.post(t, worker, "set_role", map[string]any{"org_id": orgA, "user_id": worker, "role": "owner"},
		http.StatusBadRequest, team.CodeBadRole)
	if m := f.liveMembership(t, orgA, worker); m.GetString("role") != "worker" {
		t.Fatalf("worker's role is %s", m.GetString("role"))
	}

	// owner üye ekler
	code := f.createInvite(t, owner, orgA, "viewer", http.StatusOK, "").object(t)["code"]
	f.post(t, newcomer, "redeem", map[string]any{"code": code}, http.StatusOK, "")
	if m := f.liveMembership(t, orgA, newcomer); m == nil || m.GetString("role") != "viewer" {
		t.Fatalf("newcomer = %v", m)
	}

	// owner başka işletmeye üye ekleyemez
	f.createInvite(t, owner, orgE, "worker", http.StatusForbidden, team.CodeForbidden)

	// owner üyeyi deleted_at ile çıkarır
	before := f.liveMembership(t, orgA, worker)
	f.post(t, owner, "remove", map[string]any{"org_id": orgA, "user_id": worker}, http.StatusOK, "")

	// üyelik satırı silinemez: the row stays, soft-deleted.
	after, err := f.app.FindRecordById("memberships", before.Id)
	if err != nil {
		t.Fatalf("membership row is gone: %v", err)
	}
	if after.GetString("deleted_at") == "" || after.GetString("updated_at") != after.GetString("deleted_at") ||
		after.GetInt("server_seq") <= before.GetInt("server_seq") {
		t.Fatalf("removed membership = %v", after.PublicExport())
	}

	// çıkarılan üye işletmeyi göremez
	f.post(t, worker, "members", map[string]any{"org_id": orgA}, http.StatusForbidden, team.CodeForbidden)
	page, err := appsync.Pull(f.app, worker, "organizations", 0, 100)
	if err != nil {
		t.Fatal(err)
	}
	if len(page.Rows) != 0 {
		t.Fatalf("removed worker pulls %d organizations", len(page.Rows))
	}

	// çıkarılan üye yalnız kendi silinmiş üyeliğini görür
	page, err = appsync.Pull(f.app, worker, "memberships", 0, 100)
	if err != nil {
		t.Fatal(err)
	}
	if len(page.Rows) != 1 || page.Rows[0]["user_id"] != worker || page.Rows[0]["deleted_at"] == nil {
		t.Fatalf("removed worker pulls %v", page.Rows)
	}
}

func wantMembers(t *testing.T, got map[string]any, want map[string]any) {
	t.Helper()
	list, _ := got["members"].([]any)
	have := map[string]any{}
	for _, m := range list {
		row := m.(map[string]any)
		if len(row) != 2 {
			t.Errorf("member %v has extra keys", row)
		}
		have[row["user_id"].(string)] = row["email"]
	}
	if len(have) != len(want) || len(list) != len(want) {
		t.Fatalf("members = %v, want %v", list, want)
	}
	for id, email := range want {
		if have[id] != email {
			t.Fatalf("members = %v, want %v", list, want)
		}
	}
}

func TestMembers(t *testing.T) {
	f := newFixture(t)
	got := f.post(t, viewer, "members", map[string]any{"org_id": orgA}, http.StatusOK, "").object(t)
	wantMembers(t, got, map[string]any{
		owner: emails[owner], partner: emails[partner], worker: emails[worker], viewer: emails[viewer],
	})

	// A member whose account is gone has a null e-mail (getUserById fails).
	gone := "66666666-6666-6666-6666-666666666666"
	f.insert(t, "memberships", "c0000000-0000-0000-0000-000000000006", map[string]any{
		"org_id": orgA, "user_id": gone, "role": "worker",
	})
	got = f.post(t, viewer, "members", map[string]any{"org_id": orgA}, http.StatusOK, "").object(t)
	wantMembers(t, got, map[string]any{
		owner: emails[owner], partner: emails[partner], worker: emails[worker], viewer: emails[viewer], gone: nil,
	})

	f.post(t, viewer, "members", map[string]any{"org_id": "x"}, http.StatusBadRequest, team.CodeBadRequest)
	f.post(t, viewer, "members", map[string]any{}, http.StatusBadRequest, team.CodeBadRequest)
	f.post(t, viewer, "members", map[string]any{"org_id": orgE}, http.StatusForbidden, team.CodeForbidden)
	f.post(t, "", "members", map[string]any{"org_id": orgA}, http.StatusUnauthorized, "")
}

// TestSetRoleAndRemove: owner only; the owner's membership and a leaving
// member's are not touched.
func TestSetRoleAndRemove(t *testing.T) {
	f := newFixture(t)
	body := func(user string, role any) map[string]any {
		b := map[string]any{"org_id": orgA, "user_id": user}
		if role != nil {
			b["role"] = role
		}
		return b
	}

	for _, action := range []string{"set_role", "remove"} {
		f.post(t, "", action, body(worker, "viewer"), http.StatusUnauthorized, "")
		f.post(t, owner, action, "{", http.StatusBadRequest, team.CodeBadRequest)
		f.post(t, owner, action, map[string]any{"org_id": orgA, "user_id": "x", "role": "viewer"}, http.StatusBadRequest, team.CodeBadRequest)
		f.post(t, owner, action, map[string]any{"user_id": worker, "role": "viewer"}, http.StatusBadRequest, team.CodeBadRequest)
		// Partners manage invites but not members.
		for _, u := range []string{partner, worker, viewer, outsider} {
			f.post(t, u, action, body(worker, "viewer"), http.StatusForbidden, team.CodeForbidden)
		}
		// Not a live member of the organization.
		f.post(t, owner, action, body(outsider, "viewer"), http.StatusNotFound, team.CodeNotFound)
		f.post(t, owner, action, body(newcomer, "viewer"), http.StatusNotFound, team.CodeNotFound)
		// The owner, including themself.
		f.post(t, owner, action, body(owner, "viewer"), http.StatusConflict, team.CodeOwnerLocked)
		// Another organization's owner cannot reach into aaaa.
		f.post(t, outsider, action, body(owner, "viewer"), http.StatusForbidden, team.CodeForbidden)
	}
	for _, role := range []any{"owner", "admin", nil, 3} {
		f.post(t, owner, "set_role", body(worker, role), http.StatusBadRequest, team.CodeBadRole)
	}

	// A member whose account deletion is pending: 409 member_leaving.
	leaving := f.liveMembership(t, orgA, viewer)
	leaving.Set("deletion_scheduled_for", "2026-11-20T00:00:00.000000Z")
	f.save(t, leaving)
	f.post(t, owner, "set_role", body(viewer, "worker"), http.StatusConflict, team.CodeMemberLeaving)
	f.post(t, owner, "remove", body(viewer, nil), http.StatusConflict, team.CodeMemberLeaving)
	if m := f.liveMembership(t, orgA, viewer); m == nil || m.GetString("role") != "viewer" {
		t.Fatalf("leaving member changed: %v", m)
	}

	// set_role writes the role, a new updated_at and server_seq.
	before := f.liveMembership(t, orgA, worker)
	got := f.post(t, owner, "set_role", body(worker, "partner"), http.StatusOK, "").object(t)
	if len(got) != 1 || got["ok"] != true {
		t.Fatalf("set_role = %v", got)
	}
	after := f.liveMembership(t, orgA, worker)
	if after.Id != before.Id || after.GetString("role") != "partner" ||
		after.GetString("updated_at") <= before.GetString("updated_at") ||
		after.GetInt("server_seq") <= before.GetInt("server_seq") {
		t.Fatalf("after set_role = %v", after.PublicExport())
	}

	// remove soft-deletes; a second remove finds no live member.
	got = f.post(t, owner, "remove", body(worker, nil), http.StatusOK, "").object(t)
	if got["ok"] != true {
		t.Fatalf("remove = %v", got)
	}
	if f.liveMembership(t, orgA, worker) != nil {
		t.Fatal("worker is still a live member")
	}
	f.post(t, owner, "remove", body(worker, nil), http.StatusNotFound, team.CodeNotFound)
	f.post(t, owner, "set_role", body(worker, "viewer"), http.StatusNotFound, team.CodeNotFound)
}

// TestResponsesMatchClientFixtures compares the answers with the fake HTTP
// answers of test/features/team/data/team_service_test.dart: the same keys
// and JSON types (the client reads expires_at with DateTime.parse, which
// takes K-5's six fraction digits), and the error statuses and codes of its
// "hata eşleme" table.
func TestResponsesMatchClientFixtures(t *testing.T) {
	f := newFixture(t)
	dart := map[string]map[string]any{
		"create":  {"code": "AR7K2Q", "role": "worker", "expires_at": "2026-10-29T09:00:00.000Z"},
		"redeem":  {"org_id": "0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a", "role": "worker"},
		"members": {"members": []any{map[string]any{"user_id": "u1", "email": "a@x.test"}, map[string]any{"user_id": "u2", "email": nil}}},
	}
	gone := "66666666-6666-6666-6666-666666666666"
	f.insert(t, "memberships", "c0000000-0000-0000-0000-000000000006", map[string]any{
		"org_id": orgA, "user_id": gone, "role": "worker",
	})

	created := f.createInvite(t, owner, orgA, "worker", http.StatusOK, "").object(t)
	sameShape(t, "create", created, dart["create"])
	if _, err := time.Parse(time.RFC3339Nano, created["expires_at"].(string)); err != nil {
		t.Errorf("expires_at: %v", err)
	}
	redeemed := f.post(t, newcomer, "redeem", map[string]any{"code": created["code"]}, http.StatusOK, "").object(t)
	sameShape(t, "redeem", redeemed, dart["redeem"])
	listed := f.post(t, owner, "members", map[string]any{"org_id": orgA}, http.StatusOK, "").object(t)
	sameShape(t, "members", listed, dart["members"])
	var sawNull bool
	for _, m := range listed["members"].([]any) {
		sameShape(t, "member", m.(map[string]any), map[string]any{"user_id": "", "email": ""})
		sawNull = sawNull || m.(map[string]any)["email"] == nil
	}
	if !sawNull {
		t.Error("no null e-mail in members")
	}
	ok := f.post(t, owner, "remove", map[string]any{"org_id": orgA, "user_id": gone}, http.StatusOK, "").object(t)
	if len(ok) != 1 || ok["ok"] != true {
		t.Errorf("remove = %v", ok)
	}

	// The client's error table: (404, invalid_code), (409, already_member),
	// (409, owner_locked), (409, member_leaving), (403, forbidden), (400,
	// bad_request); 401 comes from PocketBase's RequireAuth.
	f.post(t, outsider, "redeem", map[string]any{"code": "BCDEFG"}, http.StatusNotFound, "invalid_code")
	f.invite(t, "MN3PQ4", "worker", k5(time.Now().Add(time.Hour)))
	f.post(t, worker, "redeem", map[string]any{"code": "MN3PQ4"}, http.StatusConflict, "already_member")
	f.post(t, owner, "set_role", map[string]any{"org_id": orgA, "user_id": owner, "role": "viewer"}, http.StatusConflict, "owner_locked")
	f.post(t, worker, "members", map[string]any{"org_id": orgE}, http.StatusForbidden, "forbidden")
	f.post(t, worker, "members", map[string]any{"org_id": 1}, http.StatusBadRequest, "bad_request")
	f.post(t, "", "members", map[string]any{"org_id": orgA}, http.StatusUnauthorized, "")
}

// sameShape: got has exactly want's keys, each with the same JSON type.
func sameShape(t *testing.T, what string, got, want map[string]any) {
	t.Helper()
	if len(got) != len(want) {
		t.Errorf("%s: keys %v, client fixture %v", what, got, want)
	}
	for k, w := range want {
		g, ok := got[k]
		if !ok {
			t.Errorf("%s: missing %s", what, k)
			continue
		}
		if w == nil || g == nil {
			continue // a nullable value
		}
		if gt, wt := jsonType(g), jsonType(w); gt != wt {
			t.Errorf("%s: %s is %s, client fixture has %s", what, k, gt, wt)
		}
	}
}

func jsonType(v any) string {
	switch v.(type) {
	case string:
		return "string"
	case float64:
		return "number"
	case bool:
		return "bool"
	case []any:
		return "array"
	case map[string]any:
		return "object"
	}
	return "null"
}
