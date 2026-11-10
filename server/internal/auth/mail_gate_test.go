package auth_test

import (
	"errors"
	"net/http"
	"net/mail"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/mailer"
)

// newAppWithMail is newApp with the SMTP part of the environment given.
// The test app is not in --dev mode, like production.
func newAppWithMail(t *testing.T, m config.Mail) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev, Mail: m}, "test")
	return app
}

func TestOTPUnavailableWithoutSMTP(t *testing.T) {
	cases := map[string]config.Mail{
		"empty": {},
		"half":  {Host: "smtp.example.com", Port: 465},
	}
	for name, m := range cases {
		t.Run(name, func(t *testing.T) {
			app := newAppWithMail(t, m)
			// Stored settings from earlier do not turn e-mail on (K-10).
			s := app.Settings()
			s.SMTP = core.SMTPConfig{Enabled: true, Host: "old.example.com", Port: 465}
			if err := app.Save(s); err != nil {
				t.Fatal(err)
			}

			r := requestCode(t, app, "new@example.com", "tr", http.StatusServiceUnavailable)
			if got := r.code(t); got != auth.CodeMailUnavailable {
				t.Fatalf("code = %q", got)
			}

			// Nothing else happened: no account, no code, no e-mail.
			users, err := app.FindCollectionByNameOrId(auth.UsersCollection)
			if err != nil {
				t.Fatal(err)
			}
			if _, err := app.FindAuthRecordByEmail(users, "new@example.com"); err == nil {
				t.Fatal("account opened")
			}
			if n, _ := app.CountRecords(core.CollectionNameOTPs); n != 0 {
				t.Fatalf("%d OTPs stored", n)
			}
			if app.TestMailer.TotalSend() != 0 {
				t.Fatalf("%d e-mails sent", app.TestMailer.TotalSend())
			}
		})
	}
}

func TestMailerRefusesWithoutSMTP(t *testing.T) {
	app := newAppWithMail(t, config.Mail{})
	err := app.NewMailClient().Send(&mailer.Message{
		From:    mail.Address{Address: "noreply@example.com"},
		To:      []mail.Address{{Address: "a@example.com"}},
		Subject: "x",
		Text:    "x",
	})
	if !errors.Is(err, auth.ErrMailOff) {
		t.Fatalf("err = %v", err)
	}
	if app.TestMailer.TotalSend() != 0 {
		t.Fatal("e-mail reached the mailer")
	}
}

func TestOTPSentWithSMTP(t *testing.T) {
	app := newAppWithMail(t, testMail)
	requestCode(t, app, "new@example.com", "tr", http.StatusOK)
	if app.TestMailer.TotalSend() != 1 {
		t.Fatalf("%d e-mails sent", app.TestMailer.TotalSend())
	}
}
