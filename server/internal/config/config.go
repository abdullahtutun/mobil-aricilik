// Package config reads the server's environment variables.
//
// Secret values never leave this package's caller: logging only ever uses
// variable names (K-10). A missing variable never stops the server; the
// feature that needs it stays off and the startup log names it.
package config

import (
	"os"
	"strings"
)

// Environment names accepted in APP_ENV.
const (
	EnvDev  = "dev"
	EnvProd = "prod"
)

// Var is one known environment variable and the feature that needs it.
type Var struct {
	Name    string
	Feature string
}

// Known lists every environment variable the server reads, grouped by the
// feature that needs it (docs/pocketbase-gecis.md, "Ortak bilgiler").
// Values are set only in Coolify.
var Known = []Var{
	{"APP_ENV", "core"},
	{"APP_URL", "core"},
	{"PB_ENCRYPTION_KEY", "core"},
	{"GOMEMLIMIT", "core"},
	{"TRUSTED_PROXY_HEADERS", "core"},
	{"SMTP_HOST", "mail"},
	{"SMTP_PORT", "mail"},
	{"MAIL_NOREPLY_USER", "mail"},
	{"MAIL_NOREPLY_PASS", "mail"},
	{"MAIL_FEEDBACK_USER", "feedback"},
	{"MAIL_FEEDBACK_PASS", "feedback"},
	{"FEEDBACK_TO_EMAIL", "feedback"},
	{"WEATHERAPI_KEY", "weather"},
	{"WEATHERAPI_DAYS", "weather"},
	{"FCM_SERVICE_ACCOUNT_B64", "push"},
	{"BACKUPS_CRON", "backups"},
	{"BACKUPS_MAX_KEEP", "backups"},
	{"BACKUPS_S3_ENDPOINT", "backups_s3"},
	{"BACKUPS_S3_BUCKET", "backups_s3"},
	{"BACKUPS_S3_REGION", "backups_s3"},
	{"BACKUPS_S3_ACCESS_KEY", "backups_s3"},
	{"BACKUPS_S3_SECRET", "backups_s3"},
}

// Config is the non-secret part of the environment plus the names of the
// variables that are not set.
type Config struct {
	// Env is "dev" or "prod"; empty when APP_ENV is unset or invalid.
	Env string
	// URL is the server's own root address (APP_URL).
	URL string
	// Missing holds the names of the unset known variables, in [Known] order.
	Missing []Var
	// InvalidEnv is true when APP_ENV is set to something other than dev/prod.
	InvalidEnv bool
	// Backups is the backup schedule and optional S3 target (P1.4).
	Backups Backups
	// Mail is the noreply SMTP account (P4.2).
	Mail Mail
	// FeedbackMail is the feedback mailbox (P5.7).
	FeedbackMail FeedbackMail
	// EncryptionKey is PB_ENCRYPTION_KEY. Secret; never log it. The
	// feedback screenshot links derive their signing key from it (P5.7).
	EncryptionKey string
	// TrustedProxy is the client IP header behind the proxy (P4.2).
	TrustedProxy TrustedProxy
	// Weather is the WeatherAPI key and day count (P5.5).
	Weather Weather
	// FCMServiceAccountB64 is FCM_SERVICE_ACCOUNT_B64 (P5.6): the Firebase
	// service account JSON, base64. Secret; never log it. Empty turns push
	// sending off.
	FCMServiceAccountB64 string
}

// Load reads the environment through getenv (os.Getenv when nil).
func Load(getenv func(string) string) Config {
	if getenv == nil {
		getenv = os.Getenv
	}

	var cfg Config
	for _, v := range Known {
		if strings.TrimSpace(getenv(v.Name)) == "" {
			cfg.Missing = append(cfg.Missing, v)
		}
	}

	switch env := strings.TrimSpace(getenv("APP_ENV")); env {
	case EnvDev, EnvProd:
		cfg.Env = env
	case "":
	default:
		cfg.InvalidEnv = true
	}
	cfg.URL = strings.TrimSpace(getenv("APP_URL"))
	cfg.Backups = loadBackups(getenv)
	cfg.Mail = loadMail(getenv)
	cfg.FeedbackMail = loadFeedbackMail(getenv)
	cfg.EncryptionKey = getenv("PB_ENCRYPTION_KEY")
	cfg.TrustedProxy = loadTrustedProxy(getenv)
	cfg.Weather = Weather{
		Key:  strings.TrimSpace(getenv("WEATHERAPI_KEY")),
		Days: strings.TrimSpace(getenv("WEATHERAPI_DAYS")),
	}
	cfg.FCMServiceAccountB64 = strings.TrimSpace(getenv("FCM_SERVICE_ACCOUNT_B64"))

	return cfg
}

// MissingNames returns the names of the unset variables.
func (c Config) MissingNames() []string {
	names := make([]string, len(c.Missing))
	for i, v := range c.Missing {
		names[i] = v.Name
	}
	return names
}

// Weather is WEATHERAPI_KEY and WEATHERAPI_DAYS (P5.5). Key is a secret;
// never log it. Days is the raw value; weather.ForecastDays parses it. An
// empty Key turns the weather route off (503).
type Weather struct {
	Key  string
	Days string
}
