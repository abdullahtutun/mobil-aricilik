package recordapi_test

import (
	"encoding/json"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const (
	// memberA is a live member of orgA and a removed member of orgE.
	// memberE is a live member of orgE. stranger has no membership.
	memberA  = "0195f2a4-a000-7000-8000-00000000000a"
	memberE  = "0195f2a4-a000-7000-8000-00000000000e"
	stranger = "0195f2a4-a000-7000-8000-000000000099"

	orgA = "0195f2a4-0a0a-7000-8000-00000000000a"
	orgE = "0195f2a4-0e0e-7000-8000-00000000000e"

	requestOfA   = "0195f2a4-d000-7000-8000-00000000000a"
	requestEmpty = "0195f2a4-d000-7000-8000-000000000000"
	tokenOfA     = "0195f2a4-e000-7000-8000-00000000000a"

	testTime  = "2026-11-10T10:15:30.123456Z"
	clientNow = "2000-01-01T00:00:00.000000Z"
	hash      = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
)

// fixture is one app for all scenarios (they only add rows nobody else
// reads) and an auth token per user.
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
	for _, id := range []string{memberA, memberE, stranger} {
		u := core.NewRecord(f.collection(t, "users"))
		u.Id = id
		u.SetEmail(id[len(id)-2:] + "@example.com")
		u.SetPassword("1234567890")
		f.save(t, u)
		tok, err := u.NewAuthToken()
		if err != nil {
			t.Fatal(err)
		}
		f.tokens[id] = tok
	}

	for _, m := range []struct{ id, org, user, deletedAt string }{
		{"0195f2a4-c000-7000-8000-00000000000a", orgA, memberA, ""},
		{"0195f2a4-c000-7000-8000-0000000000ae", orgE, memberA, testTime},
		{"0195f2a4-c000-7000-8000-00000000000e", orgE, memberE, ""},
	} {
		r := core.NewRecord(f.collection(t, "memberships"))
		r.Id = m.id
		r.Set("org_id", m.org)
		r.Set("user_id", m.user)
		r.Set("role", "worker")
		r.Set("created_at", testTime)
		r.Set("updated_at", testTime)
		r.Set("deleted_at", m.deletedAt)
		f.save(t, r)
	}

	// A's pending request and a finished one whose user_id was emptied when
	// the account went (Supabase: on delete set null).
	for _, d := range []struct{ id, user string }{{requestOfA, memberA}, {requestEmpty, ""}} {
		r := core.NewRecord(f.collection(t, "deletion_requests"))
		r.Id = d.id
		r.Set("user_id", d.user)
		r.Set("kind", "hesap")
		r.Set("channel", "uygulama")
		r.Set("status", map[bool]string{true: "bekliyor", false: "tamamlandi"}[d.user != ""])
		r.Set("requested_at", testTime)
		r.Set("scheduled_for", "2026-11-17T10:15:30.123456Z")
		r.Set("user_hash", hash)
		// The checks of deletion_requests (internal/deletion hook):
		// delete_org_ids is an array, completed_at goes with tamamlandi.
		r.Set("delete_org_ids", []string{})
		if d.user == "" {
			r.Set("completed_at", "2026-11-17T10:16:00.000000Z")
		}
		f.save(t, r)
	}

	tok := core.NewRecord(f.collection(t, "device_tokens"))
	tok.Id = tokenOfA
	tok.Set("user_id", memberA)
	tok.Set("token", "fcm-token-of-a")
	tok.Set("platform", "android")
	tok.Set("created_at", testTime)
	tok.Set("updated_at", testTime)
	f.save(t, tok)
	return f
}

func (f *fixture) collection(t *testing.T, name string) *core.Collection {
	t.Helper()
	c, err := f.app.FindCollectionByNameOrId(name)
	if err != nil {
		t.Fatal(err)
	}
	return c
}

func (f *fixture) save(t *testing.T, r *core.Record) {
	t.Helper()
	if err := f.app.Save(r); err != nil {
		t.Fatalf("%s %s: %v", r.Collection().Name, r.Id, err)
	}
}

// scenario fills in the shared app and the user's token ("" = anonymous).
func (f *fixture) scenario(user string, s tests.ApiScenario) tests.ApiScenario {
	s.TestAppFactory = func(testing.TB) *tests.TestApp { return f.app }
	s.DisableTestAppCleanup = true
	if user != "" {
		s.Headers = map[string]string{"Authorization": f.tokens[user]}
	}
	if s.Body == nil && s.Method == http.MethodPost {
		s.Body = strings.NewReader(`{}`)
		s.Headers = withJSON(s.Headers)
	}
	return s
}

func withJSON(h map[string]string) map[string]string {
	out := map[string]string{"Content-Type": "application/json"}
	for k, v := range h {
		out[k] = v
	}
	return out
}

// post is a JSON create request body.
func post(f *fixture, user, url string, body map[string]any, s tests.ApiScenario) tests.ApiScenario {
	raw, _ := json.Marshal(body)
	s.Method = http.MethodPost
	s.URL = url
	s.Body = strings.NewReader(string(raw))
	s = f.scenario(user, s)
	s.Headers = withJSON(s.Headers)
	return s
}

const (
	forbidden  = `"status":403`
	badRequest = `"status":400`
	notFound   = `"status":404`
	none       = `"totalItems":0`
	one        = `"totalItems":1`
)

func TestUsersRecordAPI(t *testing.T) {
	f := newFixture(t)
	list := "/api/collections/users/records"
	for _, s := range []tests.ApiScenario{
		f.scenario(memberA, tests.ApiScenario{
			Name: "a user lists only themselves", Method: http.MethodGet, URL: list,
			ExpectedStatus: 200, ExpectedContent: []string{one, `"id":"` + memberA + `"`},
			NotExpectedContent: []string{memberE, stranger},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "another user's record is not visible", Method: http.MethodGet, URL: list + "/" + memberE,
			ExpectedStatus: 404, ExpectedContent: []string{notFound},
		}),
		f.scenario("", tests.ApiScenario{
			Name: "anonymous lists nothing", Method: http.MethodGet, URL: list,
			ExpectedStatus: 200, ExpectedContent: []string{none},
		}),
		post(f, "", list, map[string]any{"email": "new@example.com", "password": "1234567890", "passwordConfirm": "1234567890"}, tests.ApiScenario{
			Name: "nobody signs up through the record API", ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		post(f, memberA, list, map[string]any{"email": "new@example.com", "password": "1234567890", "passwordConfirm": "1234567890"}, tests.ApiScenario{
			Name: "a user does not create users", ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "a user does not update themselves", Method: http.MethodPatch, URL: list + "/" + memberA,
			Body: strings.NewReader(`{"locale":"tr"}`), ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "a user does not delete themselves", Method: http.MethodDelete, URL: list + "/" + memberA,
			ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
	} {
		s.Test(t)
	}
}

func feedbackBody(id, org, createdBy string) map[string]any {
	b := map[string]any{
		"id": id, "org_id": org, "kind": "bug", "message": "Kovan kartı açılmıyor",
		"created_at": testTime, "received_at": clientNow,
	}
	if createdBy != "" {
		b["created_by"] = createdBy
	}
	return b
}

func TestFeedbackRecordAPI(t *testing.T) {
	f := newFixture(t)
	url := "/api/collections/feedback/records"
	accepted := "0195f2a4-f000-7000-8000-000000000001"
	rejected := "0195f2a4-f000-7000-8000-000000000002"

	start := time.Now().Add(-time.Second)
	for _, s := range []tests.ApiScenario{
		post(f, memberA, url, feedbackBody(accepted, orgA, memberA), tests.ApiScenario{
			Name: "a live member sends feedback for their organization", ExpectedStatus: 200,
			ExpectedContent:    []string{`"id":"` + accepted + `"`},
			NotExpectedContent: []string{clientNow},
		}),
		// A has a membership row in orgE (removed) and E has a live one: each
		// condition alone finds a row, but no single row has all three.
		post(f, memberA, url, feedbackBody(rejected, orgE, memberA), tests.ApiScenario{
			Name: "a removed member cannot send for that organization", ExpectedStatus: 400, ExpectedContent: []string{badRequest},
		}),
		post(f, stranger, url, feedbackBody(rejected, orgA, stranger), tests.ApiScenario{
			Name: "a non-member cannot send for an organization", ExpectedStatus: 400, ExpectedContent: []string{badRequest},
		}),
		post(f, memberA, url, feedbackBody(rejected, orgA, memberE), tests.ApiScenario{
			Name: "created_by must be the sender", ExpectedStatus: 400, ExpectedContent: []string{badRequest},
		}),
		post(f, memberA, url, feedbackBody(rejected, orgA, ""), tests.ApiScenario{
			Name: "created_by is required", ExpectedStatus: 400, ExpectedContent: []string{badRequest},
		}),
		post(f, "", url, feedbackBody(rejected, orgA, ""), tests.ApiScenario{
			Name: "anonymous cannot send feedback", ExpectedStatus: 400, ExpectedContent: []string{badRequest},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "feedback is not readable", Method: http.MethodGet, URL: url,
			ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "feedback is not updatable", Method: http.MethodPatch, URL: url + "/" + accepted,
			Body: strings.NewReader(`{}`), ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
	} {
		s.Test(t)
	}

	if _, err := f.app.FindRecordById("feedback", rejected); err == nil {
		t.Error("a rejected feedback was stored")
	}
	r, err := f.app.FindRecordById("feedback", accepted)
	if err != nil {
		t.Fatal(err)
	}
	receivedAtFromServer(t, r.GetString("received_at"), start)
}

// receivedAtFromServer checks that received_at is the server's clock, not
// the client's value.
func receivedAtFromServer(t *testing.T, got string, start time.Time) {
	t.Helper()
	if !pattern.IsTimestamp(got) {
		t.Fatalf("received_at = %q, not a K-5 time", got)
	}
	at, err := time.Parse(pattern.TimestampLayout, got)
	if err != nil {
		t.Fatal(err)
	}
	if at.Before(start) || at.After(time.Now().Add(time.Second)) {
		t.Errorf("received_at = %s, want about now", got)
	}
}

func TestAnalyticsRecordAPI(t *testing.T) {
	f := newFixture(t)
	url := "/api/collections/analytics_events/records"
	accepted := "0195f2a4-f100-7000-8000-000000000001"
	body := func(id string) map[string]any {
		return map[string]any{
			"id": id, "install_id": "0195f2a4-f1f1-7000-8000-000000000001", "name": "inspection_saved",
			"props": map[string]any{"count": 3}, "occurred_at": testTime, "received_at": clientNow,
			"app_version": "1.0.0", "platform": "android",
		}
	}
	start := time.Now().Add(-time.Second)
	for _, s := range []tests.ApiScenario{
		post(f, "", url, body("0195f2a4-f100-7000-8000-000000000002"), tests.ApiScenario{
			Name: "anonymous cannot add events", ExpectedStatus: 400, ExpectedContent: []string{badRequest},
		}),
		post(f, stranger, url, body(accepted), tests.ApiScenario{
			Name: "any signed-in user adds events", ExpectedStatus: 200,
			ExpectedContent: []string{`"id":"` + accepted + `"`}, NotExpectedContent: []string{clientNow},
		}),
		f.scenario(stranger, tests.ApiScenario{
			Name: "events are not readable", Method: http.MethodGet, URL: url,
			ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
	} {
		s.Test(t)
	}
	if n, _ := f.app.CountRecords("analytics_events"); n != 1 {
		t.Errorf("events = %d, want 1", n)
	}
	r, err := f.app.FindRecordById("analytics_events", accepted)
	if err != nil {
		t.Fatal(err)
	}
	receivedAtFromServer(t, r.GetString("received_at"), start)
}

func TestOwnRowsRecordAPI(t *testing.T) {
	f := newFixture(t)
	requests := "/api/collections/deletion_requests/records"
	tokens := "/api/collections/device_tokens/records"
	for _, s := range []tests.ApiScenario{
		f.scenario(memberA, tests.ApiScenario{
			Name: "a user sees their deletion request", Method: http.MethodGet, URL: requests,
			ExpectedStatus: 200, ExpectedContent: []string{one, requestOfA}, NotExpectedContent: []string{requestEmpty},
		}),
		f.scenario(memberE, tests.ApiScenario{
			Name: "another user sees none", Method: http.MethodGet, URL: requests,
			ExpectedStatus: 200, ExpectedContent: []string{none},
		}),
		f.scenario(memberE, tests.ApiScenario{
			Name: "another user cannot view it", Method: http.MethodGet, URL: requests + "/" + requestOfA,
			ExpectedStatus: 404, ExpectedContent: []string{notFound},
		}),
		// @request.auth.id is "" for anonymous, like the emptied user_id.
		f.scenario("", tests.ApiScenario{
			Name: "anonymous does not see requests without a user", Method: http.MethodGet, URL: requests,
			ExpectedStatus: 200, ExpectedContent: []string{none},
		}),
		f.scenario("", tests.ApiScenario{
			Name: "anonymous cannot view a request without a user", Method: http.MethodGet, URL: requests + "/" + requestEmpty,
			ExpectedStatus: 404, ExpectedContent: []string{notFound},
		}),
		post(f, memberA, requests, map[string]any{"user_id": memberA}, tests.ApiScenario{
			Name: "requests are made by the route, not the record API", ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "a user cannot cancel through the record API", Method: http.MethodPatch, URL: requests + "/" + requestOfA,
			Body: strings.NewReader(`{"status":"iptal"}`), ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "a user sees their device token", Method: http.MethodGet, URL: tokens,
			ExpectedStatus: 200, ExpectedContent: []string{one, tokenOfA},
		}),
		f.scenario(memberE, tests.ApiScenario{
			Name: "another user sees no device token", Method: http.MethodGet, URL: tokens,
			ExpectedStatus: 200, ExpectedContent: []string{none},
		}),
		post(f, memberA, tokens, map[string]any{"user_id": memberA, "token": "x", "platform": "ios"}, tests.ApiScenario{
			Name: "tokens are written by the route", ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
		f.scenario(memberA, tests.ApiScenario{
			Name: "a user cannot delete a token through the record API", Method: http.MethodDelete, URL: tokens + "/" + tokenOfA,
			ExpectedStatus: 403, ExpectedContent: []string{forbidden},
		}),
	} {
		s.Test(t)
	}
}

// Sync collections are reached only through the sync routes (K-7): the
// record API answers 403 to members and anonymous alike, for every action.
func TestSyncCollectionsClosed(t *testing.T) {
	f := newFixture(t)
	member, err := f.app.FindRecordById("memberships", "0195f2a4-c000-7000-8000-00000000000a")
	if err != nil {
		t.Fatal(err)
	}
	for _, table := range appsync.Tables {
		url := "/api/collections/" + table.Name + "/records"
		for _, user := range []string{memberA, ""} {
			who := map[bool]string{true: "member", false: "anonymous"}[user != ""]
			for _, s := range []tests.ApiScenario{
				f.scenario(user, tests.ApiScenario{
					Name: table.Name + " list, " + who, Method: http.MethodGet, URL: url,
					ExpectedStatus: 403, ExpectedContent: []string{forbidden},
				}),
				f.scenario(user, tests.ApiScenario{
					Name: table.Name + " view, " + who, Method: http.MethodGet, URL: url + "/" + member.Id,
					ExpectedStatus: 403, ExpectedContent: []string{forbidden},
				}),
				post(f, user, url, map[string]any{"org_id": orgA}, tests.ApiScenario{
					Name: table.Name + " create, " + who, ExpectedStatus: 403, ExpectedContent: []string{forbidden},
				}),
				f.scenario(user, tests.ApiScenario{
					Name: table.Name + " update, " + who, Method: http.MethodPatch, URL: url + "/" + member.Id,
					Body: strings.NewReader(`{}`), ExpectedStatus: 403, ExpectedContent: []string{forbidden},
				}),
				f.scenario(user, tests.ApiScenario{
					Name: table.Name + " delete, " + who, Method: http.MethodDelete, URL: url + "/" + member.Id,
					ExpectedStatus: 403, ExpectedContent: []string{forbidden},
				}),
			} {
				s.Test(t)
			}
		}
	}
	// Nothing changed: the membership is as before the scenarios (the
	// fixture's pending deletion request already marked it).
	after, err := f.app.FindRecordById("memberships", member.Id)
	if err != nil || after.GetString("updated_at") != member.GetString("updated_at") ||
		after.GetInt("server_seq") != member.GetInt("server_seq") {
		t.Errorf("membership changed: %v", err)
	}
}
