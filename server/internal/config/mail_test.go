package config

import (
	"slices"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

var fullMail = map[string]string{
	"SMTP_HOST":         " smtp.hostinger.com ",
	"SMTP_PORT":         "465",
	"MAIL_NOREPLY_USER": "noreply@tutunsoft.com",
	"MAIL_NOREPLY_PASS": " pass with spaces ",
}

func withMail(over map[string]string) map[string]string {
	m := map[string]string{}
	for k, v := range fullMail {
		m[k] = v
	}
	for k, v := range over {
		m[k] = v
	}
	return m
}

func TestMailEnvFullWritesSettings(t *testing.T) {
	m := Load(env(fullMail)).Mail
	if !m.Ready() || m.Missing != nil || m.InvalidPort {
		t.Fatalf("Mail = %+v", m)
	}

	s := &core.Settings{}
	s.SMTP.LocalName = "kept"
	if !m.Apply(s) {
		t.Fatal("Apply reported no change")
	}
	got := s.SMTP
	if !got.Enabled || got.Host != "smtp.hostinger.com" || got.Port != 465 ||
		got.Username != "noreply@tutunsoft.com" || got.Password != " pass with spaces " ||
		!got.TLS || got.AuthMethod != "PLAIN" || got.LocalName != "kept" {
		t.Fatalf("SMTP = %+v", got)
	}
	if s.Meta.SenderName != "Mobil Arıcı" || s.Meta.SenderAddress != "noreply@tutunsoft.com" {
		t.Fatalf("Meta = %+v", s.Meta)
	}
	if m.Apply(s) {
		t.Fatal("second Apply reported a change")
	}
}

func TestMailEnvOverwritesStored(t *testing.T) {
	s := &core.Settings{}
	s.SMTP = core.SMTPConfig{Enabled: true, Host: "old.example.com", Port: 25, Username: "old@example.com", Password: "old"}
	s.Meta.SenderName = "Acme"
	s.Meta.SenderAddress = "old@example.com"

	if !Load(env(fullMail)).Mail.Apply(s) {
		t.Fatal("Apply reported no change")
	}
	if s.SMTP.Host != "smtp.hostinger.com" || s.SMTP.Password != " pass with spaces " ||
		s.Meta.SenderName != "Mobil Arıcı" || s.Meta.SenderAddress != "noreply@tutunsoft.com" {
		t.Fatalf("settings = %+v %+v", s.SMTP, s.Meta)
	}
}

func TestMailStartTLSPort(t *testing.T) {
	s := &core.Settings{}
	Load(env(withMail(map[string]string{"SMTP_PORT": "587"}))).Mail.Apply(s)
	if s.SMTP.Port != 587 || s.SMTP.TLS {
		t.Fatalf("SMTP = %+v", s.SMTP)
	}
}

func TestMailEnvEmptyLeavesSettings(t *testing.T) {
	m := Load(env(nil)).Mail
	if m.Ready() {
		t.Fatal("empty environment is ready")
	}
	if !slices.Equal(m.Missing, mailVars) {
		t.Fatalf("Missing = %v", m.Missing)
	}

	s := &core.Settings{}
	s.SMTP = core.SMTPConfig{Enabled: true, Host: "old.example.com", Port: 25}
	before := s.SMTP
	if m.Apply(s) {
		t.Fatal("Apply reported a change")
	}
	if s.SMTP != before || s.Meta.SenderName != "" {
		t.Fatalf("settings changed: %+v %+v", s.SMTP, s.Meta)
	}
}

func TestMailEnvHalfNotApplied(t *testing.T) {
	m := Load(env(map[string]string{
		"SMTP_HOST":         "smtp.hostinger.com",
		"MAIL_NOREPLY_PASS": "secret",
	})).Mail
	if m.Ready() {
		t.Fatal("half environment is ready")
	}
	if want := []string{"SMTP_PORT", "MAIL_NOREPLY_USER"}; !slices.Equal(m.Missing, want) {
		t.Fatalf("Missing = %v, want %v", m.Missing, want)
	}
	s := &core.Settings{}
	if m.Apply(s) || s.SMTP.Enabled {
		t.Fatalf("half account applied: %+v", s.SMTP)
	}
}

func TestMailInvalidPort(t *testing.T) {
	for _, port := range []string{"smtp", "0", "70000", "-1"} {
		m := Load(env(withMail(map[string]string{"SMTP_PORT": port}))).Mail
		if m.Ready() || !m.InvalidPort || m.Missing != nil {
			t.Fatalf("port %q: Mail = %+v", port, m)
		}
	}
}

func TestMailZeroValueNotReady(t *testing.T) {
	if (Mail{}).Ready() {
		t.Fatal("zero Mail is ready")
	}
}

func TestTrustedProxy(t *testing.T) {
	tp := Load(env(map[string]string{"TRUSTED_PROXY_HEADERS": " X-Forwarded-For , ,X-Real-IP"})).TrustedProxy
	if want := []string{"X-Forwarded-For", "X-Real-IP"}; !slices.Equal(tp.Headers, want) {
		t.Fatalf("Headers = %v", tp.Headers)
	}

	c := &core.TrustedProxyConfig{UseLeftmostIP: true}
	if !tp.Apply(c) {
		t.Fatal("Apply reported no change")
	}
	if !slices.Equal(c.Headers, tp.Headers) || c.UseLeftmostIP {
		t.Fatalf("config = %+v", c)
	}
	if tp.Apply(c) {
		t.Fatal("second Apply reported a change")
	}
}

func TestTrustedProxyEmptyLeavesSettings(t *testing.T) {
	tp := Load(env(nil)).TrustedProxy
	c := &core.TrustedProxyConfig{Headers: []string{"CF-Connecting-IP"}, UseLeftmostIP: true}
	if tp.Apply(c) {
		t.Fatal("Apply reported a change")
	}
	if !slices.Equal(c.Headers, []string{"CF-Connecting-IP"}) || !c.UseLeftmostIP {
		t.Fatalf("config changed: %+v", c)
	}
}
