package seed

import (
	"database/sql"
	"errors"
	"fmt"
	"regexp"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/pocketbase/pocketbase/core"
)

// demoUserLocale is the demo account's e-mail language, as in Supabase
// (user_metadata.locale = en): the reviewers read English.
const demoUserLocale = "en"

// demoPasswordRe: the password is the 6-digit code of the store review
// forms; the app sends the typed code as the password (`reviewDemoEmail`).
var demoPasswordRe = regexp.MustCompile(`^[0-9]{6}$`)

// ErrDemoPassword: the password is not 6 digits.
var ErrDemoPassword = errors.New("the demo password must be exactly 6 digits (the code in the store review forms)")

// DemoUser is `seed demo-user`: it opens the demo account (locale en,
// verified) with password, or sets the password of the existing one. Only
// [auth.DemoEmail] is accepted: password login is closed for every other
// address. The password is never logged or stored in plain text.
func DemoUser(app core.App, email, password string) (created bool, err error) {
	email = strings.ToLower(strings.TrimSpace(email))
	if email != auth.DemoEmail {
		return false, fmt.Errorf("only %s may sign in with a password; got %q", auth.DemoEmail, email)
	}
	if !demoPasswordRe.MatchString(password) {
		return false, ErrDemoPassword
	}
	user, err := app.FindAuthRecordByEmail(auth.UsersCollection, email)
	switch {
	case errors.Is(err, sql.ErrNoRows):
		users, err := app.FindCollectionByNameOrId(auth.UsersCollection)
		if err != nil {
			return false, err
		}
		user = core.NewRecord(users)
		user.SetEmail(email)
		user.Set("locale", demoUserLocale)
		created = true
	case err != nil:
		return false, err
	}
	user.SetVerified(true)
	user.SetPassword(password)
	if err := app.Save(user); err != nil {
		return false, err
	}
	return created, nil
}
