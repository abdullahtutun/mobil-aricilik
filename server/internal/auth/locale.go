package auth

import (
	"slices"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/users"
)

// Locales are the app's languages, in the order of AppLanguage and
// supabase/functions/_shared/locale.ts (supportedLocales). A new language
// is added there, here, to otpTexts and to the users.locale pattern.
var Locales = []string{"tr", "en", "de", "es", "pt", "ru", "uk", "fa", "hi"}

// rtlLocales are written right to left; the e-mail gets dir="rtl".
var rtlLocales = map[string]bool{"fa": true}

// ParseLocale returns the language of a value such as "de", "de-DE" or
// "pt_BR", and whether it is one of [Locales]. The rule is pickLocale in
// supabase/functions/_shared/locale.ts: trim, lower-case, the part before
// the first "-" or "_".
func ParseLocale(value string) (string, bool) {
	code := strings.ToLower(strings.TrimSpace(value))
	if i := strings.IndexAny(code, "-_"); i >= 0 {
		code = code[:i]
	}
	if slices.Contains(Locales, code) {
		return code, true
	}
	return "", false
}

// PickLocale is [ParseLocale] with English for an unknown or empty value
// (locale.ts fallbackLocale).
func PickLocale(value string) string {
	if code, ok := ParseLocale(value); ok {
		return code
	}
	return users.DefaultLocale
}
