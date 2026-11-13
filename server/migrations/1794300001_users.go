package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// users: PocketBase's own auth collection, reshaped for the app. Supabase's
// auth.users had no profile columns of ours; the language lived in
// user_metadata.locale (OTP template). Auth options (OTP, token lifetime,
// password login) are P4.1/P4.2; API rules are P3.2.
//
//   - id: UUID (K-4); a missing id becomes a UUIDv7 (internal/ids).
//   - email, verified: PocketBase system fields, kept as they are.
//   - locale: one of the nine app languages; empty becomes "en"
//     (internal/users).
//   - name, avatar: removed; the app keeps no personal names
//     (20261116120000_drop_personal_names).
func init() {
	m.Register(upUsers, downUsers)
}

// locales are the app's languages (AppLanguage, supabase/functions/_shared/locale.ts).
var locales = []string{"tr", "en", "de", "es", "pt", "ru", "uk", "fa", "hi"}

// localePattern accepts exactly one of [locales].
const localePattern = `^(tr|en|de|es|pt|ru|uk|fa|hi)$`

func upUsers(app core.App) error {
	c, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		return err
	}
	useUUIDPrimaryKey(c)
	c.Fields.RemoveByName("name")
	c.Fields.RemoveByName("avatar")
	c.Fields.Add(&core.TextField{
		Name:    "locale",
		Min:     2,
		Max:     2,
		Pattern: localePattern,
	})
	// OAuth2 is not used; the default mapping points at the removed fields.
	c.OAuth2.MappedFields.Name = ""
	c.OAuth2.MappedFields.AvatarURL = ""
	return app.Save(c)
}

// downUsers restores PocketBase's default users fields (1640988000_init).
func downUsers(app core.App) error {
	c, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		return err
	}
	id := c.Fields.GetByName("id").(*core.TextField)
	id.Pattern = "^[a-z0-9]+$"
	id.Min = 15
	id.Max = 15
	id.AutogeneratePattern = "[a-z0-9]{15}"

	c.Fields.RemoveByName("locale")
	c.Fields.Add(&core.TextField{Name: "name", Max: 255})
	c.Fields.Add(&core.FileField{
		Name:      "avatar",
		MaxSelect: 1,
		MimeTypes: []string{"image/jpeg", "image/png", "image/svg+xml", "image/gif", "image/webp"},
	})
	c.OAuth2.MappedFields.Name = "name"
	c.OAuth2.MappedFields.AvatarURL = "avatar"
	return app.Save(c)
}
