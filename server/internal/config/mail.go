package config

import (
	"slices"
	"strconv"
	"strings"

	"github.com/pocketbase/pocketbase/core"
)

// mailVars are the noreply SMTP variables, in the order they are reported.
var mailVars = []string{
	"SMTP_HOST",
	"SMTP_PORT",
	"MAIL_NOREPLY_USER",
	"MAIL_NOREPLY_PASS",
}

// SenderName is the "From" name of every e-mail PocketBase sends.
const SenderName = "Mobil Arıcı"

// implicitTLSPort is SMTPS: the connection is TLS from the first byte.
// Other ports (587) upgrade with STARTTLS, which PocketBase's client does
// on its own when TLS is false.
const implicitTLSPort = 465

// Mail is the noreply SMTP account (K-10). It holds a password; never log it.
//
// E-mail is on only when all four variables are set and the port is valid.
// Otherwise the stored PocketBase settings stay as they are and the
// e-mail routes answer 503.
type Mail struct {
	Host     string
	Port     int
	Username string
	Password string
	// Missing names the unset variables; empty when all are set.
	Missing []string
	// InvalidPort is true when SMTP_PORT is set but not in 1..65535.
	InvalidPort bool
}

func loadMail(getenv func(string) string) Mail {
	var m Mail
	values := make([]string, len(mailVars))
	for i, name := range mailVars {
		values[i] = strings.TrimSpace(getenv(name))
		if values[i] == "" {
			m.Missing = append(m.Missing, name)
		}
	}
	m.Host = values[0]
	if values[1] != "" {
		p, err := strconv.Atoi(values[1])
		if err != nil || p < 1 || p > 65535 {
			m.InvalidPort = true
		} else {
			m.Port = p
		}
	}
	m.Username = values[2]
	// The password is taken as is: spaces may be part of it.
	if values[3] != "" {
		m.Password = getenv("MAIL_NOREPLY_PASS")
	}
	return m
}

// Ready reports whether the environment holds a complete SMTP account.
func (m Mail) Ready() bool {
	return m.Host != "" && m.Port > 0 && m.Username != "" && m.Password != ""
}

// Apply writes the account into s (SMTP and sender) and reports whether
// anything changed. It does nothing unless [Mail.Ready].
func (m Mail) Apply(s *core.Settings) bool {
	if !m.Ready() {
		return false
	}
	changed := false

	want := s.SMTP
	want.Enabled = true
	want.Host = m.Host
	want.Port = m.Port
	want.Username = m.Username
	want.Password = m.Password
	want.TLS = m.Port == implicitTLSPort
	want.AuthMethod = "PLAIN"
	if s.SMTP != want {
		s.SMTP = want
		changed = true
	}

	if s.Meta.SenderName != SenderName || s.Meta.SenderAddress != m.Username {
		s.Meta.SenderName = SenderName
		s.Meta.SenderAddress = m.Username
		changed = true
	}

	return changed
}

// TrustedProxy is TRUSTED_PROXY_HEADERS: the headers that carry the real
// client IP behind Coolify's proxy. Nil when unset; the stored setting stays.
type TrustedProxy struct {
	Headers []string
}

func loadTrustedProxy(getenv func(string) string) TrustedProxy {
	var t TrustedProxy
	for _, h := range strings.Split(getenv("TRUSTED_PROXY_HEADERS"), ",") {
		if h = strings.TrimSpace(h); h != "" {
			t.Headers = append(t.Headers, h)
		}
	}
	return t
}

// Apply writes the headers into c and reports whether anything changed.
// The rightmost IP is used (UseLeftmostIP false): the proxy appends the
// address it saw, while the leftmost one is whatever the client sent.
func (t TrustedProxy) Apply(c *core.TrustedProxyConfig) bool {
	if len(t.Headers) == 0 {
		return false
	}
	if slices.Equal(c.Headers, t.Headers) && !c.UseLeftmostIP {
		return false
	}
	c.Headers = append([]string(nil), t.Headers...)
	c.UseLeftmostIP = false
	return true
}
