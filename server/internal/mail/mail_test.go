package mail_test

import (
	"errors"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/mail"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/mail/mailtest"
)

func sender(s *mailtest.Server) *mail.Sender {
	return mail.New(mail.Account{Host: s.Host, Port: s.Port, Username: "feedback@tutunsoft.com", Password: "secret pass"}, "Mobil Arıcı")
}

func TestSendPlainTextWithReplyTo(t *testing.T) {
	s := mailtest.Start(t)
	err := sender(s).Send(mail.Message{
		To:      "team@tutunsoft.com",
		ReplyTo: "arici@example.com",
		Subject: "[Mobil Arıcı] Öneri — Çiçek Arıcılık",
		Text:    "Merhaba\nikinci satır\n.nokta ile başlayan satır",
	})
	if err != nil {
		t.Fatal(err)
	}
	got := s.WaitFor(1, time.Second)
	if len(got) != 1 {
		t.Fatalf("%d mails", len(got))
	}
	m := got[0]
	if m.User != "feedback@tutunsoft.com" || m.Pass != "secret pass" {
		t.Errorf("login = %q / %q", m.User, m.Pass)
	}
	if m.From != "feedback@tutunsoft.com" || len(m.To) != 1 || m.To[0] != "team@tutunsoft.com" {
		t.Errorf("envelope = %q → %v", m.From, m.To)
	}
	if m.Subject != "[Mobil Arıcı] Öneri — Çiçek Arıcılık" {
		t.Errorf("subject = %q", m.Subject)
	}
	if m.Text != "Merhaba\nikinci satır\n.nokta ile başlayan satır" {
		t.Errorf("text = %q", m.Text)
	}
	if got := m.Header.Get("Reply-To"); got != "arici@example.com" {
		t.Errorf("Reply-To = %q", got)
	}
	from, err := m.Header.AddressList("From")
	if err != nil || len(from) != 1 || from[0].Name != "Mobil Arıcı" || from[0].Address != "feedback@tutunsoft.com" {
		t.Errorf("From = %v (%v)", from, err)
	}
	if ct := m.Header.Get("Content-Type"); ct == "" {
		t.Error("no Content-Type")
	}
}

func TestSendWithoutReplyTo(t *testing.T) {
	s := mailtest.Start(t)
	if err := sender(s).Send(mail.Message{To: "team@tutunsoft.com", Subject: "x", Text: "y"}); err != nil {
		t.Fatal(err)
	}
	got := s.WaitFor(1, time.Second)
	if len(got) != 1 || got[0].Header.Get("Reply-To") != "" {
		t.Fatalf("mails = %+v", got)
	}
}

// A Reply-To that is not one address never reaches the wire.
func TestSendRejectsBadAddresses(t *testing.T) {
	s := mailtest.Start(t)
	for _, m := range []mail.Message{
		{To: "team@tutunsoft.com", ReplyTo: "a@example.com\r\nBcc: evil@example.com", Subject: "x", Text: "y"},
		{To: "team@tutunsoft.com", ReplyTo: "a@example.com, b@example.com", Subject: "x", Text: "y"},
		{To: "not an address", Subject: "x", Text: "y"},
	} {
		if err := sender(s).Send(m); !errors.Is(err, mail.ErrBadAddress) {
			t.Errorf("%+v: err = %v", m, err)
		}
	}
	if got := s.Mails(); len(got) != 0 {
		t.Fatalf("sent %d mails", len(got))
	}
}

// Header injection through the subject is stripped by the transport.
func TestSendSubjectStaysOneLine(t *testing.T) {
	s := mailtest.Start(t)
	if err := sender(s).Send(mail.Message{To: "team@tutunsoft.com", Subject: "a\r\nBcc: evil@example.com", Text: "y"}); err != nil {
		t.Fatal(err)
	}
	got := s.WaitFor(1, time.Second)
	if len(got) != 1 || got[0].Header.Get("Bcc") != "" || len(got[0].To) != 1 {
		t.Fatalf("mails = %+v", got)
	}
}
