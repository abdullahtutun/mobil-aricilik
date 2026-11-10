package auth

import (
	"errors"
	"strings"

	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/mails"
)

// errLoginFailed is PocketBase's own answer to a wrong password
// (apis/record_auth_with_password.go), so a refused account cannot be told
// apart from a wrong demo password. The app shows it as a wrong code.
const errLoginFailed = "Failed to authenticate."

// registerDemoPasswordOnly lets only [DemoEmail] sign in with a password.
// Every account has a random password (PocketBase needs one), but nobody
// knows it; the hook makes sure it can never become a way in.
func registerDemoPasswordOnly(app core.App) {
	app.OnRecordAuthWithPasswordRequest(UsersCollection).BindFunc(func(e *core.RecordAuthWithPasswordRequestEvent) error {
		identity := strings.ToLower(strings.TrimSpace(e.Identity))
		if identity != DemoEmail || e.Record == nil || e.Record.Email() != DemoEmail {
			return e.BadRequestError(errLoginFailed, errors.New("password login is only for the demo account"))
		}
		return e.Next()
	})
}

// registerNoRecordAPIOTPRequest closes PocketBase's own
// /api/collections/users/request-otp: it would skip the per-e-mail limit
// of /api/app/auth/otp. auth-with-otp stays; the app signs in with it.
func registerNoRecordAPIOTPRequest(app core.App) {
	app.OnRecordRequestOTPRequest(UsersCollection).BindFunc(func(e *core.RecordCreateOTPRequestEvent) error {
		return e.NotFoundError("Use /api/app/auth/otp.", nil)
	})
}

// sendOTP sends the code e-mail through PocketBase, which also records the
// address on the OTP ("sentTo"); auth-with-otp then marks the account
// verified. The text comes from [registerOTPMail].
func sendOTP(app core.App, user *core.Record, otpID, code string) error {
	return mails.SendRecordOTP(app, user, otpID, code)
}
