package config

import (
	"strconv"
	"strings"
)

// feedbackMailVars are the feedback mailbox variables, in the order they
// are reported. SMTP_HOST and SMTP_PORT are shared with the noreply
// account: both mailboxes are on the same Hostinger server.
var feedbackMailVars = []string{
	"SMTP_HOST",
	"SMTP_PORT",
	"MAIL_FEEDBACK_USER",
	"MAIL_FEEDBACK_PASS",
	"FEEDBACK_TO_EMAIL",
}

// FeedbackMail is the feedback mailbox (P5.7): its own SMTP login, apart
// from PocketBase's mailer, which sends as noreply. It holds a password;
// never log it.
//
// Feedback e-mail is on only when all five variables are set and the port
// is valid. Otherwise feedback is still stored and the e-mail is skipped.
type FeedbackMail struct {
	Host     string
	Port     int
	Username string
	Password string
	// To is the recipient, FEEDBACK_TO_EMAIL.
	To string
	// Missing names the unset variables; empty when all are set.
	Missing []string
	// InvalidPort is true when SMTP_PORT is set but not in 1..65535.
	InvalidPort bool
}

func loadFeedbackMail(getenv func(string) string) FeedbackMail {
	var f FeedbackMail
	values := make([]string, len(feedbackMailVars))
	for i, name := range feedbackMailVars {
		values[i] = strings.TrimSpace(getenv(name))
		if values[i] == "" {
			f.Missing = append(f.Missing, name)
		}
	}
	f.Host = values[0]
	if values[1] != "" {
		p, err := strconv.Atoi(values[1])
		if err != nil || p < 1 || p > 65535 {
			f.InvalidPort = true
		} else {
			f.Port = p
		}
	}
	f.Username = values[2]
	// The password is taken as is: spaces may be part of it.
	if values[3] != "" {
		f.Password = getenv("MAIL_FEEDBACK_PASS")
	}
	f.To = values[4]
	return f
}

// Ready reports whether the environment holds a complete feedback mailbox.
func (f FeedbackMail) Ready() bool {
	return f.Host != "" && f.Port > 0 && f.Username != "" && f.Password != "" && f.To != ""
}

// Problems returns the names to report for an incomplete mailbox.
func (f FeedbackMail) Problems() []string {
	names := append([]string(nil), f.Missing...)
	if f.InvalidPort {
		names = append(names, "SMTP_PORT (not a port number)")
	}
	return names
}
