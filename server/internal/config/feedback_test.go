package config

import (
	"slices"
	"testing"
)

var fullFeedbackMail = map[string]string{
	"SMTP_HOST":          " smtp.hostinger.com ",
	"SMTP_PORT":          "465",
	"MAIL_FEEDBACK_USER": "feedback@tutunsoft.com",
	"MAIL_FEEDBACK_PASS": " pass with spaces ",
	"FEEDBACK_TO_EMAIL":  " feedback@tutunsoft.com ",
}

func TestFeedbackMailFull(t *testing.T) {
	f := Load(env(fullFeedbackMail)).FeedbackMail
	if !f.Ready() || f.Missing != nil || f.InvalidPort {
		t.Fatalf("FeedbackMail = %+v", f)
	}
	if f.Host != "smtp.hostinger.com" || f.Port != 465 || f.Username != "feedback@tutunsoft.com" ||
		f.Password != " pass with spaces " || f.To != "feedback@tutunsoft.com" {
		t.Fatalf("FeedbackMail = %+v", f)
	}
}

func TestFeedbackMailEmpty(t *testing.T) {
	f := Load(env(nil)).FeedbackMail
	if f.Ready() {
		t.Fatal("Ready with an empty environment")
	}
	if !slices.Equal(f.Problems(), feedbackMailVars) {
		t.Fatalf("Problems = %v", f.Problems())
	}
}

func TestFeedbackMailPartial(t *testing.T) {
	for _, name := range feedbackMailVars {
		vars := map[string]string{}
		for k, v := range fullFeedbackMail {
			if k != name {
				vars[k] = v
			}
		}
		f := Load(env(vars)).FeedbackMail
		if f.Ready() {
			t.Errorf("Ready without %s", name)
		}
		if !slices.Equal(f.Problems(), []string{name}) {
			t.Errorf("without %s: Problems = %v", name, f.Problems())
		}
	}

	vars := map[string]string{}
	for k, v := range fullFeedbackMail {
		vars[k] = v
	}
	vars["SMTP_PORT"] = "smtp"
	f := Load(env(vars)).FeedbackMail
	if f.Ready() || !f.InvalidPort || !slices.Equal(f.Problems(), []string{"SMTP_PORT (not a port number)"}) {
		t.Fatalf("bad port: %+v, Problems = %v", f, f.Problems())
	}
}

// The noreply account does not stand in for the feedback mailbox: the
// mailer of the OTP e-mails is noreply's alone.
func TestFeedbackMailIgnoresNoreply(t *testing.T) {
	f := Load(env(fullMail)).FeedbackMail
	if f.Ready() || f.Username != "" || f.Password != "" {
		t.Fatalf("FeedbackMail = %+v", f)
	}
}
