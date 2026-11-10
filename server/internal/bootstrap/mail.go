package bootstrap

import (
	"log/slog"
	"strings"
	"sync/atomic"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/pocketbase/pocketbase/core"
)

// mailGate says whether e-mail may be sent. It starts as "the environment
// holds a complete SMTP account" and is turned off if writing that account
// into the settings fails at startup.
type mailGate struct{ on atomic.Bool }

func newMailGate(m config.Mail) *mailGate {
	g := &mailGate{}
	g.on.Store(m.Ready())
	return g
}

func (g *mailGate) On() bool { return g.on.Load() }

// applyMail writes the SMTP account from the environment into the stored
// PocketBase settings on every start (K-10): the panel is never the source.
// With an incomplete environment the stored settings stay as they are, the
// gate is off and the e-mail routes answer 503. It reports whether e-mail
// is on.
func applyMail(app core.App, m config.Mail, log *slog.Logger) bool {
	if !m.Ready() {
		names := mailProblems(m)
		log.Warn("E-mail is off (OTP answers 503): SMTP variables are empty or invalid",
			"names", strings.Join(names, ","))
		return false
	}

	// Change a copy: if validation fails, the live settings stay as loaded.
	s, err := app.Settings().Clone()
	if err != nil {
		log.Error("SMTP settings not applied; e-mail is off", "error", err.Error())
		return false
	}
	if m.Apply(s) {
		if err := app.Save(s); err != nil {
			// The validation error may echo values; log only field names.
			log.Error("SMTP settings from environment rejected; e-mail is off",
				"fields", invalidFields(err))
			return false
		}
	}

	got := app.Settings().SMTP
	log.Info("SMTP settings applied from environment",
		"host", got.Host, "port", got.Port, "tls", got.TLS)
	return true
}

// mailProblems returns the names to report for an incomplete account.
func mailProblems(m config.Mail) []string {
	names := append([]string(nil), m.Missing...)
	if m.InvalidPort {
		names = append(names, "SMTP_PORT (not a port number)")
	}
	return names
}

// applyTrustedProxy writes TRUSTED_PROXY_HEADERS into the stored settings,
// so rate limits and logs see the client's IP, not the proxy's. Unset
// leaves the stored setting alone.
func applyTrustedProxy(app core.App, t config.TrustedProxy, log *slog.Logger) {
	s, err := app.Settings().Clone()
	if err != nil {
		log.Error("Trusted proxy settings not applied", "error", err.Error())
		return
	}
	if !t.Apply(&s.TrustedProxy) {
		return
	}
	if err := app.Save(s); err != nil {
		log.Error("Trusted proxy settings rejected", "fields", invalidFields(err))
		return
	}
	log.Info("Trusted proxy headers applied from environment",
		"headers", strings.Join(app.Settings().TrustedProxy.Headers, ","))
}
