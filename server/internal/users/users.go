// Package users holds the users collection's server-side defaults.
package users

import "github.com/pocketbase/pocketbase/core"

// DefaultLocale is the language of a user who has not chosen one.
const DefaultLocale = "en"

// Register sets locale to [DefaultLocale] on a new user without one.
// PocketBase text fields have no column default.
func Register(app core.App) {
	app.OnRecordCreate("users").BindFunc(func(e *core.RecordEvent) error {
		if e.Record.GetString("locale") == "" {
			e.Record.Set("locale", DefaultLocale)
		}
		return e.Next()
	})
}
