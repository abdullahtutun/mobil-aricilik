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

// IsRTL reports whether a language of [Locales] is written right to left
// (locale.ts rtlLocales); HTML pages get dir="rtl".
func IsRTL(locale string) bool { return rtlLocales[locale] }

// PickAcceptLanguage returns the first supported language of an
// Accept-Language header in the browser's order, English when none is
// (pickAcceptLanguage in locale.ts). The q weights are not read: browsers
// already list the tags by weight.
func PickAcceptLanguage(header string) string {
	for part := range strings.SplitSeq(header, ",") {
		tag, _, _ := strings.Cut(part, ";")
		tag = strings.TrimSpace(tag)
		if tag == "" {
			continue
		}
		if code, ok := ParseLocale(tag); ok {
			return code
		}
		// locale.ts: an unsupported tag that starts with "en" (say
		// "english") also stops the search, with English.
		if strings.HasPrefix(strings.ToLower(tag), users.DefaultLocale) {
			return users.DefaultLocale
		}
	}
	return users.DefaultLocale
}

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
