package bootstrap

import (
	"bytes"
	"log/slog"
	"net/http"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/pocketbase/pocketbase/tests"
)

func factory(cfg config.Config, version string) func(testing.TB) *tests.TestApp {
	return func(t testing.TB) *tests.TestApp {
		// Empty temp data dir: the app bootstraps from scratch with our
		// (still empty) schema, not PocketBase's own fixture data.
		app, err := tests.NewTestApp(t.TempDir())
		if err != nil {
			t.Fatal(err)
		}
		Register(app, cfg, version)
		return app
	}
}

func TestRoutes(t *testing.T) {
	cfg := config.Load(func(k string) string {
		return map[string]string{"APP_ENV": "dev", "PB_ENCRYPTION_KEY": "secret-value"}[k]
	})

	scenarios := []tests.ApiScenario{
		{
			Name:            "health is 200",
			Method:          http.MethodGet,
			URL:             "/api/health",
			ExpectedStatus:  http.StatusOK,
			ExpectedContent: []string{`"code":200`},
			TestAppFactory:  factory(cfg, "abc1234"),
		},
		{
			Name:               "info returns env and version without auth",
			Method:             http.MethodGet,
			URL:                "/api/app/info",
			ExpectedStatus:     http.StatusOK,
			ExpectedContent:    []string{`"env":"dev"`, `"version":"abc1234"`},
			NotExpectedContent: []string{"secret-value"},
			TestAppFactory:     factory(cfg, "abc1234"),
		},
		{
			Name:            "info reports prod",
			Method:          http.MethodGet,
			URL:             "/api/app/info",
			ExpectedStatus:  http.StatusOK,
			ExpectedContent: []string{`"env":"prod"`},
			TestAppFactory:  factory(config.Config{Env: config.EnvProd}, "x"),
		},
		{
			Name:            "info with unset APP_ENV reports empty env",
			Method:          http.MethodGet,
			URL:             "/api/app/info",
			ExpectedStatus:  http.StatusOK,
			ExpectedContent: []string{`"env":""`},
			TestAppFactory:  factory(config.Load(func(string) string { return "" }), "x"),
		},
	}

	for _, s := range scenarios {
		s.Test(t)
	}
}

func TestStartupLogNamesMissingWithoutValues(t *testing.T) {
	cfg := config.Load(func(k string) string {
		return map[string]string{
			"APP_ENV":           "prod",
			"PB_ENCRYPTION_KEY": "secret-value",
			"SMTP_HOST":         "smtp.example.com",
		}[k]
	})

	var buf bytes.Buffer
	logStartup(slog.New(slog.NewTextHandler(&buf, nil)), cfg, "abc1234")
	out := buf.String()

	for _, want := range []string{"env=prod", "version=abc1234", "SMTP_PORT", "WEATHERAPI_KEY", "feature=weather"} {
		if !strings.Contains(out, want) {
			t.Errorf("log lacks %q:\n%s", want, out)
		}
	}
	for _, notWant := range []string{"secret-value", "smtp.example.com", "PB_ENCRYPTION_KEY", "SMTP_HOST"} {
		if strings.Contains(out, notWant) {
			t.Errorf("log contains %q:\n%s", notWant, out)
		}
	}
}

func TestStartupLogInvalidEnv(t *testing.T) {
	var buf bytes.Buffer
	logStartup(slog.New(slog.NewTextHandler(&buf, nil)), config.Load(func(k string) string {
		return map[string]string{"APP_ENV": "staging"}[k]
	}), "x")
	if !strings.Contains(buf.String(), "APP_ENV must be dev or prod") {
		t.Fatalf("no invalid env error:\n%s", buf.String())
	}
}
