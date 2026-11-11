package feedback

import (
	"errors"
	"net/url"
	"strconv"
	"strings"
	"testing"
	"time"
)

const linkID = "0195f2a4-f000-7000-8000-000000000001"

// parts splits a link into id, exp and sig.
func parts(t *testing.T, link string) (string, string, string) {
	t.Helper()
	u, err := url.Parse(link)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.HasPrefix(u.Path, RoutePrefix) {
		t.Fatalf("path = %s", u.Path)
	}
	return strings.TrimPrefix(u.Path, RoutePrefix), u.Query().Get("exp"), u.Query().Get("sig")
}

func TestLinkRoundTrip(t *testing.T) {
	s := NewSigner("0123456789abcdef0123456789abcdef")
	now := time.Date(2026, 11, 11, 9, 0, 0, 0, time.UTC)
	link := s.URL("https://dev.example/", linkID, now.Add(LinkTTL))
	if !strings.HasPrefix(link, "https://dev.example/api/app/feedback-shot/"+linkID+"?") {
		t.Fatalf("link = %s", link)
	}
	id, exp, sig := parts(t, link)
	if exp != strconv.FormatInt(now.Add(LinkTTL).Unix(), 10) {
		t.Errorf("exp = %s", exp)
	}
	for _, at := range []time.Time{now, now.Add(LinkTTL - time.Second)} {
		if err := s.Verify(id, exp, sig, at); err != nil {
			t.Errorf("at %v: %v", at, err)
		}
	}
	for _, at := range []time.Time{now.Add(LinkTTL), now.Add(LinkTTL + time.Hour)} {
		if err := s.Verify(id, exp, sig, at); !errors.Is(err, ErrExpired) {
			t.Errorf("at %v: err = %v", at, err)
		}
	}
}

func TestLinkTampered(t *testing.T) {
	s := NewSigner("0123456789abcdef0123456789abcdef")
	now := time.Date(2026, 11, 11, 9, 0, 0, 0, time.UTC)
	id, exp, sig := parts(t, s.URL("https://dev.example", linkID, now.Add(LinkTTL)))
	later := strconv.FormatInt(now.Add(30*24*time.Hour).Unix(), 10)

	flip := []byte(sig)
	flip[0] ^= 1
	for name, c := range map[string][3]string{
		"signature changed":       {id, exp, string(flip)},
		"signature empty":         {id, exp, ""},
		"another id":              {"0195f2a4-f000-7000-8000-000000000002", exp, sig},
		"exp pushed later":        {id, later, sig},
		"exp with a leading zero": {id, "0" + exp, sig},
		"exp missing":             {id, "", sig},
		"exp not a number":        {id, "soon", sig},
	} {
		if err := s.Verify(c[0], c[1], c[2], now); !errors.Is(err, ErrBadSignature) {
			t.Errorf("%s: err = %v", name, err)
		}
	}

	// Another encryption key (another server) signs differently.
	if err := NewSigner("another key").Verify(id, exp, sig, now); !errors.Is(err, ErrBadSignature) {
		t.Errorf("other key: err = %v", err)
	}
	// Without PB_ENCRYPTION_KEY no link is valid.
	var none *Signer = NewSigner("")
	if none != nil {
		t.Fatal("NewSigner(\"\") is not nil")
	}
	if err := none.Verify(id, exp, sig, now); !errors.Is(err, ErrBadSignature) {
		t.Errorf("no key: err = %v", err)
	}
}

// The link key is derived: the raw encryption key does not sign links.
func TestLinkKeyIsDerived(t *testing.T) {
	key := "0123456789abcdef0123456789abcdef"
	if s := NewSigner(key); string(s.key) == key {
		t.Fatal("the encryption key is used as is")
	}
}
