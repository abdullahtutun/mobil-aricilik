package auth

import (
	"bytes"
	_ "embed"
	"errors"
	"fmt"
	"html/template"
	"strconv"
	"strings"
	"time"

	"github.com/pocketbase/pocketbase/core"
)

//go:embed templates/otp.html
var otpHTML string

var otpTemplate = template.Must(template.New("otp").Parse(otpHTML))

// OTPMail is a rendered OTP e-mail.
type OTPMail struct {
	Subject string
	HTML    string
	// Text is the plain-text part; it is also what the dev log prints.
	Text string
}

// RenderOTPMail renders the OTP e-mail for code in the language of locale
// ([PickLocale]: unknown or empty is English). valid is the code's lifetime;
// the text says it in whole minutes.
func RenderOTPMail(locale, code, email string, valid time.Duration) (OTPMail, error) {
	lang := PickLocale(locale)
	t := otpTexts[lang]
	fill := strings.NewReplacer(
		"{minutes}", strconv.Itoa(int(valid/time.Minute)),
		"{email}", email,
	)
	dir := "ltr"
	if rtlLocales[lang] {
		dir = "rtl"
	}

	var buf bytes.Buffer
	err := otpTemplate.Execute(&buf, map[string]any{
		"Lang":     lang,
		"Dir":      dir,
		"T":        t,
		"Code":     code,
		"Validity": fill.Replace(t.Validity),
		"SentTo":   fill.Replace(t.SentTo),
	})
	if err != nil {
		return OTPMail{}, fmt.Errorf("render OTP mail: %w", err)
	}

	text := strings.Join([]string{
		t.Heading,
		t.Instruction,
		code,
		fill.Replace(t.Validity),
		t.Ignore,
		fill.Replace(t.SentTo),
	}, "\n\n")
	return OTPMail{Subject: t.Subject, HTML: buf.String(), Text: text}, nil
}

// registerOTPMail replaces PocketBase's OTP e-mail (one English template
// per collection) with ours, in the user's language. It runs for every OTP
// mail of the users collection, so PocketBase's sending, its "sentTo"
// bookkeeping and the test mailer stay as they are.
func registerOTPMail(app core.App) {
	app.OnMailerRecordOTPSend(UsersCollection).BindFunc(func(e *core.MailerRecordEvent) error {
		code, _ := e.Meta["password"].(string)
		m, err := RenderOTPMail(
			e.Record.GetString("locale"),
			code,
			e.Record.Email(),
			e.Record.Collection().OTP.DurationTime(),
		)
		if err != nil {
			return err
		}
		e.Message.Subject = m.Subject
		e.Message.HTML = m.HTML
		e.Message.Text = m.Text
		return e.Next()
	})
}

// ErrMailOff is returned for an e-mail sent while the gate is off.
var ErrMailOff = errors.New("e-mail is off: SMTP is not configured from the environment")

// registerMailGate stops every e-mail while mailOn is false (P4.2), so an
// incomplete environment never falls back to the local sendmail or to SMTP
// settings stored earlier. With --dev (`go run . serve`) the e-mail is
// printed to the log instead, so the app can sign in locally; --dev is
// never set in production.
func registerMailGate(app core.App, mailOn MailOn) {
	app.OnMailerSend().BindFunc(func(e *core.MailerEvent) error {
		if mailOn() {
			return e.Next()
		}
		if !e.App.IsDev() {
			return ErrMailOff
		}
		to := make([]string, 0, len(e.Message.To))
		for _, a := range e.Message.To {
			to = append(to, a.Address)
		}
		e.App.Logger().Info("E-mail not sent (SMTP off, dev mode)",
			"to", strings.Join(to, ","),
			"subject", e.Message.Subject,
			"text", e.Message.Text,
		)
		return nil
	})
}
