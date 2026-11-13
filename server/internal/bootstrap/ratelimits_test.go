package bootstrap

import (
	"bytes"
	"log/slog"
	"net/http"
	"slices"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

func TestApplyRateLimitsPersists(t *testing.T) {
	app := newApp(t)
	var buf bytes.Buffer
	applyRateLimits(app, slog.New(slog.NewTextHandler(&buf, nil)))

	// Read back from the database: the settings validated and were saved.
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	got := app.Settings().RateLimits
	if !got.Enabled {
		t.Fatal("rate limiter not enabled")
	}
	if !slices.Equal(got.Rules, rateLimitRules) {
		t.Errorf("rules\n got  %v\n want %v", got.Rules, rateLimitRules)
	}
	if !strings.Contains(buf.String(), "Rate limits applied") {
		t.Errorf("log = %s", buf.String())
	}
}

// The dashboard is not the source: a changed rule is replaced on the next
// start, excluded IPs are kept.
func TestApplyRateLimitsOverwritesStored(t *testing.T) {
	app := newApp(t)
	s := app.Settings()
	s.RateLimits.Enabled = false
	s.RateLimits.Rules = []core.RateLimitRule{{Label: "/api/", MaxRequests: 1, Duration: 1}}
	s.RateLimits.ExcludedIPs = []string{"10.0.0.0/8"}
	if err := app.Save(s); err != nil {
		t.Fatal(err)
	}

	applyRateLimits(app, slog.New(slog.DiscardHandler))
	got := app.Settings().RateLimits
	if !got.Enabled || !slices.Equal(got.Rules, rateLimitRules) {
		t.Errorf("stored = %+v", got)
	}
	if !slices.Equal(got.ExcludedIPs, []string{"10.0.0.0/8"}) {
		t.Errorf("excluded IPs = %v", got.ExcludedIPs)
	}
}

// Each request finds the rule meant for it, with the labels PocketBase
// builds (apis/middlewares_rate_limit.go): for the record API
// "<collection>:<action>", "*:<action>", then "<METHOD> <path>", "<path>".
func TestRateLimitRuleMatching(t *testing.T) {
	cfg := core.RateLimitsConfig{Enabled: true, Rules: rateLimitRules}
	cases := []struct {
		name   string
		labels []string
		want   string
	}{
		{"OTP route", []string{"POST /api/app/auth/otp", "/api/app/auth/otp"}, "POST /api/app/auth/otp"},
		{"invite redeem", []string{"POST /api/app/team/redeem", "/api/app/team/redeem"}, "POST /api/app/team/redeem"},
		{"other team action", []string{"POST /api/app/team/create", "/api/app/team/create"}, "/api/"},
		{"PocketBase request-otp", []string{"users:requestOTP", "*:requestOTP", "POST /api/collections/users/request-otp", "/api/collections/users/request-otp"}, "users:requestOTP"},
		{"OTP code", []string{"users:authWithOTP", "users:auth", "*:authWithOTP", "*:auth", "POST /api/collections/users/auth-with-otp", "/api/collections/users/auth-with-otp"}, "users:authWithOTP"},
		{"password login", []string{"users:authWithPassword", "users:auth", "*:authWithPassword", "*:auth", "POST /api/collections/users/auth-with-password", "/api/collections/users/auth-with-password"}, "*:auth"},
		{"feedback", []string{"feedback:create", "*:create", "POST /api/collections/feedback/records", "/api/collections/feedback/records"}, "feedback:create"},
		{"analytics", []string{"analytics_events:create", "*:create", "POST /api/collections/analytics_events/records", "/api/collections/analytics_events/records"}, "analytics_events:create"},
		{"sync pull", []string{"GET /api/sync/pull", "/api/sync/pull"}, "/api/"},
		{"token refresh", []string{"users:authRefresh", "*:authRefresh", "POST /api/collections/users/auth-refresh", "/api/collections/users/auth-refresh"}, "/api/"},
	}
	for _, c := range cases {
		rule, ok := cfg.FindRateLimitRule(c.labels, core.RateLimitRuleAudienceAll, core.RateLimitRuleAudienceGuest)
		if !ok || rule.Label != c.want {
			t.Errorf("%s: rule = %q (found %v), want %q", c.name, rule.Label, ok, c.want)
		}
	}
}

// End to end through the router: PocketBase's request-otp answers 429 once
// the IP has used its 3 requests a minute; another route is not affected.
func TestRateLimitTriggers(t *testing.T) {
	app := factory(config.Config{Env: config.EnvDev}, "x")(t)
	t.Cleanup(app.Cleanup)
	applyRateLimits(app, slog.New(slog.DiscardHandler))

	request := func(name string, status int) tests.ApiScenario {
		return tests.ApiScenario{
			Name:                  name,
			Method:                http.MethodPost,
			URL:                   "/api/collections/users/request-otp",
			Body:                  strings.NewReader(`{"email":"a@example.com"}`),
			Headers:               map[string]string{"Content-Type": "application/json"},
			ExpectedStatus:        status,
			ExpectedContent:       []string{`"status":` + map[bool]string{true: "429", false: ""}[status == 429]},
			TestAppFactory:        func(testing.TB) *tests.TestApp { return app },
			DisableTestAppCleanup: true,
		}
	}
	// PocketBase's request-otp is closed (internal/auth, P4.1): it answers
	// 404, after the rate limit check.
	for _, s := range []tests.ApiScenario{
		request("request 1", http.StatusNotFound),
		request("request 2", http.StatusNotFound),
		request("request 3", http.StatusNotFound),
		request("request 4 is limited", http.StatusTooManyRequests),
		{
			Name:                  "health is still served",
			Method:                http.MethodGet,
			URL:                   "/api/health",
			ExpectedStatus:        http.StatusOK,
			ExpectedContent:       []string{`"code":200`},
			TestAppFactory:        func(testing.TB) *tests.TestApp { return app },
			DisableTestAppCleanup: true,
		},
	} {
		s.Test(t)
	}
}
