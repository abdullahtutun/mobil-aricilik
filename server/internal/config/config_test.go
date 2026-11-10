package config

import (
	"slices"
	"testing"
)

func env(m map[string]string) func(string) string {
	return func(k string) string { return m[k] }
}

func TestLoadEmpty(t *testing.T) {
	cfg := Load(env(nil))
	if cfg.Env != "" || cfg.InvalidEnv {
		t.Fatalf("Env = %q, InvalidEnv = %v", cfg.Env, cfg.InvalidEnv)
	}
	if len(cfg.Missing) != len(Known) {
		t.Fatalf("missing %d, want %d", len(cfg.Missing), len(Known))
	}
}

func TestLoadValues(t *testing.T) {
	cfg := Load(env(map[string]string{
		"APP_ENV":           " prod ",
		"APP_URL":           "https://arici-api.tutunsoft.com",
		"PB_ENCRYPTION_KEY": "secret",
	}))
	if cfg.Env != EnvProd {
		t.Fatalf("Env = %q", cfg.Env)
	}
	if cfg.URL != "https://arici-api.tutunsoft.com" {
		t.Fatalf("URL = %q", cfg.URL)
	}
	names := cfg.MissingNames()
	for _, set := range []string{"APP_ENV", "APP_URL", "PB_ENCRYPTION_KEY"} {
		if slices.Contains(names, set) {
			t.Fatalf("%s reported missing", set)
		}
	}
	if !slices.Contains(names, "SMTP_HOST") {
		t.Fatal("SMTP_HOST not reported missing")
	}
}

func TestLoadInvalidEnv(t *testing.T) {
	cfg := Load(env(map[string]string{"APP_ENV": "staging"}))
	if cfg.Env != "" || !cfg.InvalidEnv {
		t.Fatalf("Env = %q, InvalidEnv = %v", cfg.Env, cfg.InvalidEnv)
	}
}

func TestBlankCountsAsMissing(t *testing.T) {
	cfg := Load(env(map[string]string{"SMTP_HOST": "  "}))
	if !slices.Contains(cfg.MissingNames(), "SMTP_HOST") {
		t.Fatal("blank SMTP_HOST not reported missing")
	}
}

func TestLoad_weather(t *testing.T) {
	cfg := Load(env(map[string]string{"WEATHERAPI_KEY": " k3y ", "WEATHERAPI_DAYS": " 3 "}))
	if cfg.Weather.Key != "k3y" || cfg.Weather.Days != "3" {
		t.Errorf("Weather = %+v", cfg.Weather)
	}
	if cfg := Load(env(nil)); cfg.Weather.Key != "" {
		t.Errorf("Weather without env = %+v", cfg.Weather)
	}
}
