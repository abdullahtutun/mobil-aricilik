package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// The users collection's auth options (P4.1). Supabase: e-mail OTP with 6
// digits and 600 s, the demo account by password. The values come from
// internal/auth, which also renders "valid for 10 minutes" from the
// collection's OTP duration.
//
//   - OTP on, 6 digits, 10 minutes. Codes are requested through
//     POST /api/app/auth/otp (internal/auth); PocketBase's own request-otp
//     is closed by a hook, auth-with-otp is what the app signs in with.
//   - Password login on, by e-mail only; a hook lets only the demo account
//     through (internal/auth).
//   - OAuth2, MFA and the "new device" alert e-mail off: Supabase had none
//     of them, and the alert would go out in English.
//   - Auth token 90 days (K-6).
//
// The schema dump (P2.8) does not cover auth options; users_auth_test.go
// checks them.
func init() {
	m.Register(upUsersAuth, downUsersAuth)
}

func upUsersAuth(app core.App) error {
	c, err := app.FindCollectionByNameOrId(auth.UsersCollection)
	if err != nil {
		return err
	}
	c.OTP.Enabled = true
	c.OTP.Length = auth.OTPLength
	c.OTP.Duration = int64(auth.OTPDuration.Seconds())
	c.PasswordAuth.Enabled = true
	c.PasswordAuth.IdentityFields = []string{core.FieldNameEmail}
	c.OAuth2.Enabled = false
	c.MFA.Enabled = false
	c.AuthAlert.Enabled = false
	c.AuthToken.Duration = int64(auth.TokenDuration.Seconds())
	return app.Save(c)
}

// downUsersAuth restores PocketBase's defaults for a new auth collection
// (core.NewAuthCollection in v0.40.6).
func downUsersAuth(app core.App) error {
	c, err := app.FindCollectionByNameOrId(auth.UsersCollection)
	if err != nil {
		return err
	}
	c.OTP.Enabled = false
	c.OTP.Length = 8
	c.OTP.Duration = 180
	c.AuthAlert.Enabled = true
	c.AuthToken.Duration = 432000
	return app.Save(c)
}
