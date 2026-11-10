package bootstrap

import (
	"bytes"
	"log/slog"
	"slices"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const smtpSecret = "smtp-secret-value"

var fullMailEnv = map[string]string{
	"SMTP_HOST":         "smtp.hostinger.com",
	"SMTP_PORT":         "465",
	"MAIL_NOREPLY_USER": "noreply@tutunsoft.com",
	"MAIL_NOREPLY_PASS": smtpSecret,
}

func mailFrom(m map[string]string) config.Mail {
	return config.Load(func(k string) string { return m[k] }).Mail
}

// storeSMTP saves an SMTP account as if it had been entered earlier, so
// "untouched" is distinguishable from defaults.
func storeSMTP(t *testing.T, app *tests.TestApp) core.SMTPConfig {
	t.Helper()
	s := app.Settings()
	s.SMTP = core.SMTPConfig{Enabled: true, Host: "old.example.com", Port: 25, Username: "old@example.com", Password: "old"}
	if err := app.Save(s); err != nil {
		t.Fatal(err)
	}
	return app.Settings().SMTP
}

func assertNoSecret(t *testing.T, out string) {
	t.Helper()
	if strings.Contains(out, smtpSecret) {
		t.Fatalf("log contains the SMTP password:\n%s", out)
	}
}

func TestApplyMailPersists(t *testing.T) {
	app := newApp(t)
	storeSMTP(t, app)
	var buf bytes.Buffer
	if !applyMail(app, mailFrom(fullMailEnv), slog.New(slog.NewTextHandler(&buf, nil))) {
		t.Fatal("applyMail reported e-mail off")
	}

	// Read back from the database, not the in-memory copy.
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	s := app.Settings()
	if !s.SMTP.Enabled || s.SMTP.Host != "smtp.hostinger.com" || s.SMTP.Port != 465 || !s.SMTP.TLS ||
		s.SMTP.Username != "noreply@tutunsoft.com" || s.SMTP.Password != smtpSecret {
		t.Fatalf("stored SMTP = %+v", s.SMTP)
	}
	if s.Meta.SenderName != "Mobil Arıcı" || s.Meta.SenderAddress != "noreply@tutunsoft.com" {
		t.Fatalf("stored sender = %q <%s>", s.Meta.SenderName, s.Meta.SenderAddress)
	}

	out := buf.String()
	if !strings.Contains(out, "SMTP settings applied") {
		t.Fatalf("no apply log:\n%s", out)
	}
	assertNoSecret(t, out)
}

func TestApplyMailEmptyKeepsStored(t *testing.T) {
	app := newApp(t)
	before := storeSMTP(t, app)
	var buf bytes.Buffer
	if applyMail(app, mailFrom(nil), slog.New(slog.NewTextHandler(&buf, nil))) {
		t.Fatal("applyMail reported e-mail on")
	}
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	if app.Settings().SMTP != before {
		t.Fatalf("stored SMTP changed: %+v", app.Settings().SMTP)
	}
	out := buf.String()
	if !strings.Contains(out, "SMTP_HOST,SMTP_PORT,MAIL_NOREPLY_USER,MAIL_NOREPLY_PASS") ||
		!strings.Contains(out, "503") {
		t.Fatalf("missing names not logged:\n%s", out)
	}
}

func TestApplyMailHalfKeepsStored(t *testing.T) {
	app := newApp(t)
	before := storeSMTP(t, app)
	var buf bytes.Buffer
	ok := applyMail(app, mailFrom(map[string]string{
		"SMTP_HOST":         "smtp.hostinger.com",
		"SMTP_PORT":         "465",
		"MAIL_NOREPLY_PASS": smtpSecret,
	}), slog.New(slog.NewTextHandler(&buf, nil)))
	if ok {
		t.Fatal("applyMail reported e-mail on")
	}
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	if app.Settings().SMTP != before {
		t.Fatalf("stored SMTP changed: %+v", app.Settings().SMTP)
	}
	out := buf.String()
	if !strings.Contains(out, "names=MAIL_NOREPLY_USER") || strings.Contains(out, "smtp.hostinger.com") {
		t.Fatalf("unexpected log:\n%s", out)
	}
	assertNoSecret(t, out)
}

func TestApplyMailInvalidPortKeepsStored(t *testing.T) {
	app := newApp(t)
	before := storeSMTP(t, app)
	env := map[string]string{}
	for k, v := range fullMailEnv {
		env[k] = v
	}
	env["SMTP_PORT"] = "smtps"
	var buf bytes.Buffer
	if applyMail(app, mailFrom(env), slog.New(slog.NewTextHandler(&buf, nil))) {
		t.Fatal("applyMail reported e-mail on")
	}
	if app.Settings().SMTP != before {
		t.Fatalf("SMTP changed: %+v", app.Settings().SMTP)
	}
	if !strings.Contains(buf.String(), "SMTP_PORT") {
		t.Fatalf("port not named:\n%s", buf.String())
	}
}

func TestApplyMailRejectedKeepsStored(t *testing.T) {
	app := newApp(t)
	before := storeSMTP(t, app)
	env := map[string]string{}
	for k, v := range fullMailEnv {
		env[k] = v
	}
	// The sender address is the user name; this one is not an address.
	env["MAIL_NOREPLY_USER"] = "noreply"
	var buf bytes.Buffer
	if applyMail(app, mailFrom(env), slog.New(slog.NewTextHandler(&buf, nil))) {
		t.Fatal("applyMail reported e-mail on")
	}
	if app.Settings().SMTP != before {
		t.Fatalf("live SMTP changed: %+v", app.Settings().SMTP)
	}
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	if app.Settings().SMTP != before {
		t.Fatalf("stored SMTP changed: %+v", app.Settings().SMTP)
	}
	out := buf.String()
	if !strings.Contains(out, "fields=meta.senderAddress") {
		t.Fatalf("rejected field not logged:\n%s", out)
	}
	assertNoSecret(t, out)
}

func TestApplyTrustedProxy(t *testing.T) {
	app := newApp(t)
	var buf bytes.Buffer
	log := slog.New(slog.NewTextHandler(&buf, nil))
	applyTrustedProxy(app, config.Load(func(k string) string {
		return map[string]string{"TRUSTED_PROXY_HEADERS": "X-Forwarded-For"}[k]
	}).TrustedProxy, log)

	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	got := app.Settings().TrustedProxy
	if !slices.Equal(got.Headers, []string{"X-Forwarded-For"}) || got.UseLeftmostIP {
		t.Fatalf("stored trusted proxy = %+v", got)
	}

	// Unset: the stored value stays.
	buf.Reset()
	applyTrustedProxy(app, config.Load(func(string) string { return "" }).TrustedProxy, log)
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	if !slices.Equal(app.Settings().TrustedProxy.Headers, []string{"X-Forwarded-For"}) {
		t.Fatalf("stored trusted proxy changed: %+v", app.Settings().TrustedProxy)
	}
	if buf.Len() != 0 {
		t.Fatalf("unexpected log:\n%s", buf.String())
	}
}

func TestMailGateStartsFromEnvironment(t *testing.T) {
	if !newMailGate(mailFrom(fullMailEnv)).On() {
		t.Fatal("complete environment: gate off")
	}
	if newMailGate(mailFrom(nil)).On() {
		t.Fatal("empty environment: gate on")
	}
}
