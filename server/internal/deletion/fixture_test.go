package deletion_test

import (
	"encoding/json"
	"io"
	"net/http"
	"regexp"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// The users and organizations of the pgTAP files: 1111 owner of A (with a
// team), 2222 partner of A, 3333 worker of A, 4444 owner of the one-person
// B, 5555 a second partner of A (account_deletion_transfer), 9999 in no
// organization.
const (
	owner    = "11111111-1111-1111-1111-111111111111"
	partner  = "22222222-2222-2222-2222-222222222222"
	worker   = "33333333-3333-3333-3333-333333333333"
	solo     = "44444444-4444-4444-4444-444444444444"
	leaving  = "55555555-5555-5555-5555-555555555555"
	outsider = "99999999-9999-9999-9999-999999999999"
	orgA     = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	orgB     = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
	testTime = "2026-10-01T00:00:00.000000Z"
)

var emails = map[string]string{
	owner: "owner@test.local", partner: "partner@test.local", worker: "worker@test.local",
	solo: "solo@test.local", leaving: "leaving@test.local", outsider: "outsider@test.local",
}

// startTime makes the requests scheduled for 2026-11-12T09:30Z, the date
// of handler_test.ts's e-mail ("12 Kasım 2026 12:30 (TSİ)").
var startTime = time.Date(2026, 11, 5, 9, 30, 0, 0, time.UTC)

// testMail turns e-mail on; the test mailer catches every message.
var testMail = config.Mail{
	Host:     "smtp.example.com",
	Port:     465,
	Username: "noreply@example.com",
	Password: "test-only-smtp-password",
}

type fixture struct {
	app    *tests.TestApp
	tokens map[string]string
	clock  time.Time
	seq    int
}

type member struct{ org, user, role string }

// newFixture opens an app with every user of the constants and the given
// memberships; organizations A and B exist.
func newFixture(t *testing.T, members ...member) *fixture {
	t.Helper()
	return newFixtureWith(t, config.Config{Env: config.EnvDev, Mail: testMail}, members...)
}

func newFixtureWith(t *testing.T, cfg config.Config, members ...member) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, cfg, "test")

	f := &fixture{app: app, tokens: map[string]string{}, clock: startTime}
	t.Cleanup(deletion.SetNow(func() time.Time { return f.clock }))
	for _, id := range []string{owner, partner, worker, solo, leaving, outsider} {
		u := core.NewRecord(f.collection(t, "users"))
		u.Id = id
		u.SetEmail(emails[id])
		u.SetPassword("1234567890")
		u.Set("locale", "tr")
		f.save(t, u)
		f.signIn(t, id)
	}
	for _, o := range []struct{ id, name, by string }{
		{orgA, "Ekipli", owner},
		{orgB, "Tek Kişilik", solo},
	} {
		f.insert(t, "organizations", o.id, map[string]any{
			"name": o.name, "country_code": "TR", "currency": "TRY",
			"operation_type": "migratory", "created_by": o.by,
		})
	}
	for i, m := range members {
		f.insert(t, "memberships", "c0000000-0000-0000-0000-00000000000"+string(rune('1'+i)), map[string]any{
			"org_id": m.org, "user_id": m.user, "role": m.role,
		})
	}
	return f
}

func (f *fixture) advance(d time.Duration) { f.clock = f.clock.Add(d) }

// signIn gives the user a fresh token, as signing in again does.
func (f *fixture) signIn(t testing.TB, user string) string {
	t.Helper()
	u, err := f.app.FindRecordById("users", user)
	if err != nil {
		t.Fatal(err)
	}
	tok, err := u.NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}
	f.tokens[user] = tok
	return tok
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
	if id != "" {
		r.Id = id
	}
	if r.Collection().Fields.GetByName("created_at") != nil {
		r.Set("created_at", testTime)
	}
	if r.Collection().Fields.GetByName("updated_at") != nil {
		r.Set("updated_at", testTime)
	}
	for k, v := range fields {
		r.Set(k, v)
	}
	f.save(t, r)
	return r
}

// row writes a synced row with SQL and only the columns the counts read
// (org_id, deleted_at, kind, published), like the pgTAP inserts; each row
// gets its own server_seq.
func (f *fixture) row(t testing.TB, table, id, org string, extra dbx.Params) {
	t.Helper()
	f.seq++
	p := dbx.Params{"id": id, "org_id": org, "server_seq": 100000 + f.seq}
	for k, v := range extra {
		p[k] = v
	}
	if _, err := f.app.DB().Insert(table, p).Execute(); err != nil {
		t.Fatalf("insert %s: %v", table, err)
	}
}

func (f *fixture) deviceToken(t testing.TB, user, token string) {
	t.Helper()
	f.insert(t, "device_tokens", "", map[string]any{"user_id": user, "token": token, "platform": "android"})
}

func (f *fixture) invite(t testing.TB, org, code, by string) {
	t.Helper()
	f.insert(t, "invites", "", map[string]any{
		"org_id": org, "code": code, "role": "worker", "created_by": by,
		"created_at": pattern.FormatTimestamp(f.clock),
		"expires_at": pattern.FormatTimestamp(f.clock.Add(48 * time.Hour)),
	})
}

func (f *fixture) inviteLive(t testing.TB, code string) bool {
	t.Helper()
	r, err := f.app.FindFirstRecordByData("invites", "code", code)
	if err != nil {
		t.Fatal(err)
	}
	return r.GetString("expires_at") > pattern.FormatTimestamp(f.clock)
}

func (f *fixture) membership(t testing.TB, org, user string) *core.Record {
	t.Helper()
	r := &core.Record{}
	err := f.app.RecordQuery("memberships").
		AndWhere(dbx.HashExp{"org_id": org, "user_id": user, "deleted_at": ""}).
		Limit(1).One(r)
	if err != nil {
		t.Fatalf("membership %s %s: %v", org, user, err)
	}
	return r
}

func (f *fixture) count(t testing.TB, table string, where dbx.Expression) int {
	t.Helper()
	var n int
	q := f.app.DB().Select("count(*)").From(table)
	if where != nil {
		q = q.Where(where)
	}
	if err := q.Row(&n); err != nil {
		t.Fatal(err)
	}
	return n
}

// requests returns the user's deletion requests, oldest first.
func (f *fixture) requests(t testing.TB, user string) []*core.Record {
	t.Helper()
	rs, err := f.app.FindRecordsByFilter(deletion.RequestsCollection, "user_id = {:u}", "requested_at", 0, 0, dbx.Params{"u": user})
	if err != nil {
		t.Fatal(err)
	}
	return rs
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

// call is any request with an explicit Authorization value ("" for none);
// the status must be wantStatus.
func (f *fixture) call(t *testing.T, method, url, token, body string, wantStatus int) response {
	t.Helper()
	headers := map[string]string{"Content-Type": "application/json"}
	if token != "" {
		headers["Authorization"] = token
	}
	var out response
	s := tests.ApiScenario{
		Name:                  method + " " + url,
		Method:                method,
		URL:                   url,
		Body:                  strings.NewReader(body),
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
	return out
}

// post calls an action as user ("" for anonymous) with the user's current
// token and checks the status and, for a refusal, data.code.
func (f *fixture) post(t *testing.T, user, action string, body any, wantStatus int, wantCode string) response {
	t.Helper()
	token := ""
	if user != "" {
		token = f.tokens[user]
	}
	return f.postToken(t, token, action, body, wantStatus, wantCode)
}

func (f *fixture) postToken(t *testing.T, token, action string, body any, wantStatus int, wantCode string) response {
	t.Helper()
	raw, ok := body.(string)
	if !ok {
		b, err := json.Marshal(body)
		if err != nil {
			t.Fatal(err)
		}
		raw = string(b)
	}
	out := f.call(t, http.MethodPost, deletion.RoutePrefix+action, token, raw, wantStatus)
	if wantCode != "" {
		if got := out.code(t); got != wantCode {
			t.Fatalf("%s: code = %q, want %q (%s)", action, got, wantCode, out.body)
		}
	}
	return out
}

var codeInText = regexp.MustCompile(`: ([0-9]{6})\n`)

// sendCode asks for a code as user and returns it from the e-mail.
func (f *fixture) sendCode(t *testing.T, user string) string {
	t.Helper()
	before := f.app.TestMailer.TotalSend()
	f.post(t, user, "send_code", map[string]any{}, http.StatusOK, "")
	if f.app.TestMailer.TotalSend() != before+1 {
		t.Fatalf("send_code sent %d e-mails", f.app.TestMailer.TotalSend()-before)
	}
	m := codeInText.FindStringSubmatch(f.app.TestMailer.LastMessage().Text)
	if m == nil {
		t.Fatalf("no code in %q", f.app.TestMailer.LastMessage().Text)
	}
	return m[1]
}

// confirm is the app's code step: a code is sent (a minute after the last
// one) and verified.
func (f *fixture) confirm(t *testing.T, user string) {
	t.Helper()
	f.advance(deletion.CodeResendInterval + time.Second)
	code := f.sendCode(t, user)
	f.post(t, user, "verify_code", map[string]any{"code": code}, http.StatusOK, "")
}

// request confirms with a code and asks for the deletion.
func (f *fixture) request(t *testing.T, user string, body map[string]any, wantStatus int, wantCode string) response {
	t.Helper()
	f.confirm(t, user)
	return f.post(t, user, "request", body, wantStatus, wantCode)
}

func requestOf(t testing.TB, r response) map[string]any {
	t.Helper()
	req, _ := r.object(t)["request"].(map[string]any)
	return req
}

func step(t *testing.T, name string, fn func(t *testing.T)) {
	t.Helper()
	if !t.Run(name, fn) {
		t.FailNow()
	}
}
