package plans_test

import (
	"encoding/json"
	"io"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/plans"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const (
	owner    = "11111111-1111-1111-1111-111111111111"
	outsider = "99999999-9999-9999-9999-999999999999"
	orgA     = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	orgB     = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
	orgE     = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"
	unknown  = "cccccccc-cccc-cccc-cccc-cccccccccccc"
	testTime = "2026-11-10T10:15:30.123456Z"
	auth     = "Bearer whsec-test"
)

var now = time.Date(2026, 11, 21, 12, 0, 0, 0, time.UTC)

func TestResolve(t *testing.T) {
	future := pattern.FormatTimestamp(now.Add(time.Hour))
	past := pattern.FormatTimestamp(now.Add(-time.Hour))
	free := plans.Status{PlansEnabled: true, Plan: plans.PlanFree, HiveLimit: ptr(30), ForecastDays: ptr(3)}
	cases := []struct {
		name    string
		enabled bool
		sub     *plans.Subscription
		want    plans.Status
	}{
		{"off, no row: everything", false, nil, plans.Status{Plan: plans.PlanFree, Team: true}},
		{"off, pro row: everything, plan reported", false, &plans.Subscription{Plan: "pro", ExpiresAt: future},
			plans.Status{Plan: plans.PlanPro, ExpiresAt: future, Team: true}},
		{"on, no row: free", true, nil, free},
		{"on, free row: free", true, &plans.Subscription{Plan: "free"}, free},
		{"on, expired pro: free", true, &plans.Subscription{Plan: "pro", ExpiresAt: past}, free},
		{"on, pro ending now: free", true, &plans.Subscription{Plan: "pro", ExpiresAt: pattern.FormatTimestamp(now)}, free},
		{"on, unreadable expiry: free", true, &plans.Subscription{Plan: "pro", ExpiresAt: "yarın"}, free},
		{"on, active pro", true, &plans.Subscription{Plan: "pro", ExpiresAt: future},
			plans.Status{PlansEnabled: true, Plan: plans.PlanPro, ExpiresAt: future, Team: true}},
		{"on, lifetime pro", true, &plans.Subscription{Plan: "pro"},
			plans.Status{PlansEnabled: true, Plan: plans.PlanPro, Team: true}},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			got := plans.Resolve(tc.enabled, tc.sub, now)
			if !equal(got, tc.want) {
				t.Errorf("Resolve = %s, want %s", js(got), js(tc.want))
			}
		})
	}
}

func ptr(n int) *int { return &n }

func js(v any) string {
	b, _ := json.Marshal(v)
	return string(b)
}

func equal(a, b plans.Status) bool { return js(a) == js(b) }

type fixture struct {
	app    *tests.TestApp
	tokens map[string]string
}

func newFixture(t *testing.T, opts plans.Options) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	ids.Register(app)
	appsync.RegisterSeq(app)
	opts.Now = func() time.Time { return now }
	plans.Register(app, opts)

	f := &fixture{app: app, tokens: map[string]string{}}
	for _, id := range []string{owner, outsider} {
		u := core.NewRecord(f.collection(t, "users"))
		u.Id = id
		u.SetEmail(id[:4] + "@test.local")
		u.SetPassword("1234567890")
		f.save(t, u)
		tok, err := u.NewAuthToken()
		if err != nil {
			t.Fatal(err)
		}
		f.tokens[id] = tok
	}
	for _, o := range []struct{ id, by string }{{orgA, owner}, {orgB, owner}, {orgE, outsider}} {
		f.insert(t, "organizations", o.id, map[string]any{
			"name": "İşletme", "country_code": "TR", "currency": "TRY",
			"operation_type": "migratory", "created_by": o.by,
		})
	}
	f.insert(t, "memberships", "c0000000-0000-0000-0000-000000000001", map[string]any{"org_id": orgA, "user_id": owner, "role": "owner"})
	f.insert(t, "memberships", "c0000000-0000-0000-0000-000000000002", map[string]any{"org_id": orgB, "user_id": owner, "role": "owner"})
	f.insert(t, "memberships", "c0000000-0000-0000-0000-000000000009", map[string]any{"org_id": orgE, "user_id": outsider, "role": "owner"})
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

func (f *fixture) insert(t testing.TB, collection, id string, fields map[string]any) {
	t.Helper()
	r := core.NewRecord(f.collection(t, collection))
	r.Id = id
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	for k, v := range fields {
		r.Set(k, v)
	}
	f.save(t, r)
}

func (f *fixture) subscription(t testing.TB, orgID string) *core.Record {
	t.Helper()
	r, err := f.app.FindFirstRecordByData(plans.Collection, "org_id", orgID)
	if err != nil {
		return nil
	}
	return r
}

// request posts body (a string is sent as is) and returns the decoded
// answer.
func (f *fixture) request(t *testing.T, url string, headers map[string]string, body any, wantStatus int) map[string]any {
	t.Helper()
	raw, ok := body.(string)
	if !ok {
		raw = js(body)
	}
	var out map[string]any
	s := tests.ApiScenario{
		Name:                  "POST " + url,
		Method:                http.MethodPost,
		URL:                   url,
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
			if err := json.Unmarshal(b, &out); err != nil {
				t.Fatalf("body %s: %v", b, err)
			}
		},
	}
	s.Test(t)
	return out
}

func (f *fixture) plan(t *testing.T, user, orgID string, wantStatus int) map[string]any {
	t.Helper()
	headers := map[string]string{}
	if user != "" {
		headers["Authorization"] = f.tokens[user]
	}
	return f.request(t, plans.PlanRoute, headers, map[string]any{"org_id": orgID}, wantStatus)
}

func (f *fixture) webhook(t *testing.T, event map[string]any, wantStatus int) map[string]any {
	t.Helper()
	return f.request(t, plans.WebhookRoute, map[string]string{"Authorization": auth}, map[string]any{"event": event}, wantStatus)
}

func code(body map[string]any) string {
	data, _ := body["data"].(map[string]any)
	s, _ := data["code"].(string)
	return s
}

func TestPlanRoute(t *testing.T) {
	f := newFixture(t, plans.Options{Enabled: true})

	got := f.plan(t, owner, orgA, http.StatusOK)
	want := map[string]any{
		"plans_enabled": true, "plan": "free", "expires_at": "",
		"hive_limit": float64(30), "team": false, "forecast_days": float64(3),
	}
	if js(got) != js(want) {
		t.Errorf("plan = %s, want %s", js(got), js(want))
	}

	expires := pattern.FormatTimestamp(now.Add(30 * 24 * time.Hour))
	f.insert(t, plans.Collection, "c1000000-0000-0000-0000-000000000001", map[string]any{"org_id": orgA, "plan": "pro", "expires_at": expires})
	got = f.plan(t, owner, orgA, http.StatusOK)
	want = map[string]any{
		"plans_enabled": true, "plan": "pro", "expires_at": expires,
		"hive_limit": nil, "team": true, "forecast_days": nil,
	}
	if js(got) != js(want) {
		t.Errorf("plan = %s, want %s", js(got), js(want))
	}

	// Another organization's plan is not readable.
	if c := code(f.plan(t, outsider, orgA, http.StatusForbidden)); c != plans.CodeForbidden {
		t.Errorf("outsider code = %q", c)
	}
	f.plan(t, "", orgA, http.StatusUnauthorized)
	for _, body := range []string{"{", `{"org_id":"x"}`, `{}`} {
		headers := map[string]string{"Authorization": f.tokens[owner]}
		if c := code(f.request(t, plans.PlanRoute, headers, body, http.StatusBadRequest)); c != plans.CodeBadRequest {
			t.Errorf("%s: code = %q", body, c)
		}
	}
}

func TestPlanRoute_off(t *testing.T) {
	f := newFixture(t, plans.Options{})
	got := f.plan(t, owner, orgA, http.StatusOK)
	want := map[string]any{
		"plans_enabled": false, "plan": "free", "expires_at": "",
		"hive_limit": nil, "team": true, "forecast_days": nil,
	}
	if js(got) != js(want) {
		t.Errorf("plan = %s, want %s", js(got), js(want))
	}
}

func TestWebhookAuth(t *testing.T) {
	ev := map[string]any{"type": "INITIAL_PURCHASE", "app_user_id": orgA, "event_timestamp_ms": 1}
	body := map[string]any{"event": ev}

	off := newFixture(t, plans.Options{})
	if c := code(off.request(t, plans.WebhookRoute, map[string]string{"Authorization": auth}, body, http.StatusServiceUnavailable)); c != plans.CodeConfig {
		t.Errorf("no secret: code = %q", c)
	}

	f := newFixture(t, plans.Options{WebhookAuth: auth})
	for _, h := range []map[string]string{{}, {"Authorization": "Bearer wrong"}, {"Authorization": "bearer whsec-test"}} {
		f.request(t, plans.WebhookRoute, h, body, http.StatusUnauthorized)
	}
	f.request(t, plans.WebhookRoute, map[string]string{"Authorization": auth}, "{", http.StatusBadRequest)
	f.request(t, plans.WebhookRoute, map[string]string{"Authorization": auth}, map[string]any{}, http.StatusBadRequest)
	if f.subscription(t, orgA) != nil {
		t.Fatal("a refused event wrote a row")
	}
}

func TestWebhookEvents(t *testing.T) {
	f := newFixture(t, plans.Options{Enabled: true, WebhookAuth: auth})
	exp := now.Add(365 * 24 * time.Hour)
	result := func(body map[string]any) string { s, _ := body["result"].(string); return s }

	// TEST and other types are acknowledged and ignored.
	if r := result(f.webhook(t, map[string]any{"type": "TEST", "app_user_id": orgA}, http.StatusOK)); r != plans.ResultIgnored {
		t.Errorf("TEST: %q", r)
	}

	// A purchase makes the organization Pro until the expiration.
	r := result(f.webhook(t, map[string]any{
		"id": "e1", "type": "INITIAL_PURCHASE", "app_user_id": orgA, "entitlement_ids": []string{"pro"},
		"product_id": "mobil_arici_pro_yearly", "store": "PLAY_STORE", "environment": "SANDBOX",
		"expiration_at_ms": exp.UnixMilli(), "event_timestamp_ms": 1000,
	}, http.StatusOK))
	if r != plans.ResultUpdated {
		t.Fatalf("purchase: %q", r)
	}
	sub := f.subscription(t, orgA)
	if sub == nil || sub.GetString("plan") != "pro" || sub.GetString("expires_at") != pattern.FormatTimestamp(exp) ||
		sub.GetString("product_id") != "mobil_arici_pro_yearly" || sub.GetString("store") != "PLAY_STORE" ||
		sub.GetString("environment") != "SANDBOX" || sub.GetInt("last_event_ms") != 1000 ||
		sub.GetString("updated_at") != pattern.FormatTimestamp(now) {
		t.Fatalf("row = %v", sub)
	}
	if st, _ := plans.Lookup(f.app, orgA); st.Plan != plans.PlanPro || !st.Team {
		t.Fatalf("status = %s", js(st))
	}

	// An older event arriving late changes nothing.
	if r := result(f.webhook(t, map[string]any{"type": "EXPIRATION", "app_user_id": orgA, "event_timestamp_ms": 900}, http.StatusOK)); r != plans.ResultStale {
		t.Errorf("late event: %q", r)
	}
	// A cancellation keeps Pro until the period ends.
	f.webhook(t, map[string]any{"type": "CANCELLATION", "app_user_id": orgA, "expiration_at_ms": exp.UnixMilli(), "event_timestamp_ms": 2000}, http.StatusOK)
	if st, _ := plans.Lookup(f.app, orgA); st.Plan != plans.PlanPro {
		t.Fatalf("after cancellation: %s", js(st))
	}
	// Expiration ends it.
	f.webhook(t, map[string]any{"type": "EXPIRATION", "app_user_id": orgA, "entitlement_ids": []string{"pro"}, "event_timestamp_ms": 3000}, http.StatusOK)
	if st, _ := plans.Lookup(f.app, orgA); st.Plan != plans.PlanFree {
		t.Fatalf("after expiration: %s", js(st))
	}

	// Another entitlement, an unknown organization and a non-UUID user are
	// acknowledged without a row.
	if r := result(f.webhook(t, map[string]any{"type": "INITIAL_PURCHASE", "app_user_id": orgB, "entitlement_ids": []string{"other"}, "event_timestamp_ms": 1}, http.StatusOK)); r != plans.ResultEntitlement {
		t.Errorf("other entitlement: %q", r)
	}
	if r := result(f.webhook(t, map[string]any{"type": "INITIAL_PURCHASE", "app_user_id": unknown, "event_timestamp_ms": 1}, http.StatusOK)); r != plans.ResultUnknownOrg {
		t.Errorf("unknown org: %q", r)
	}
	if r := result(f.webhook(t, map[string]any{"type": "INITIAL_PURCHASE", "app_user_id": "$RCAnonymousID:abc", "event_timestamp_ms": 1}, http.StatusOK)); r != plans.ResultUnknownOrg {
		t.Errorf("anonymous: %q", r)
	}
	if f.subscription(t, orgB) != nil || f.subscription(t, unknown) != nil {
		t.Fatal("an ignored event wrote a row")
	}

	// An anonymous purchase merged into the organization is found by alias;
	// a purchase without expiration does not expire.
	f.webhook(t, map[string]any{
		"type": "NON_RENEWING_PURCHASE", "app_user_id": "$RCAnonymousID:abc",
		"aliases": []string{"$RCAnonymousID:abc", orgB}, "event_timestamp_ms": 5000,
	}, http.StatusOK)
	if st, _ := plans.Lookup(f.app, orgB); st.Plan != plans.PlanPro || st.ExpiresAt != "" {
		t.Fatalf("alias purchase: %s", js(st))
	}

	// A transfer moves Pro with its period.
	f.webhook(t, map[string]any{
		"type": "RENEWAL", "app_user_id": orgA, "expiration_at_ms": exp.UnixMilli(), "event_timestamp_ms": 6000,
	}, http.StatusOK)
	if r := result(f.webhook(t, map[string]any{
		"type": "TRANSFER", "transferred_from": []string{orgA}, "transferred_to": []string{orgE}, "event_timestamp_ms": 7000,
	}, http.StatusOK)); r != plans.ResultTransferred {
		t.Fatalf("transfer: %q", r)
	}
	if st, _ := plans.Lookup(f.app, orgA); st.Plan != plans.PlanFree {
		t.Errorf("transfer source: %s", js(st))
	}
	if st, _ := plans.Lookup(f.app, orgE); st.Plan != plans.PlanPro || st.ExpiresAt != pattern.FormatTimestamp(exp) {
		t.Errorf("transfer target: %s", js(st))
	}
}
