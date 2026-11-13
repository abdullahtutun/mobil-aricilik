package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// The users password's minimum length goes from PocketBase's 8 to 6 (P8.1).
// The demo account's password is the 6-digit code written in the App Store
// and Play review forms (the app sends the typed code as the password,
// `reviewDemoEmail`); Supabase had no such minimum. Only the demo account
// may sign in with a password (internal/auth), every other account has a
// random 40-character one, so the shorter minimum opens no way in.
const usersPasswordMin = 6

func init() {
	m.Register(upDemoPasswordLength, downDemoPasswordLength)
}

func upDemoPasswordLength(app core.App) error {
	return setUsersPasswordMin(app, usersPasswordMin)
}

func downDemoPasswordLength(app core.App) error {
	return setUsersPasswordMin(app, 8)
}

func setUsersPasswordMin(app core.App, minLength int) error {
	c, err := app.FindCollectionByNameOrId(auth.UsersCollection)
	if err != nil {
		return err
	}
	f, ok := c.Fields.GetByName(core.FieldNamePassword).(*core.PasswordField)
	if !ok {
		return nil
	}
	f.Min = minLength
	return app.Save(c)
}
