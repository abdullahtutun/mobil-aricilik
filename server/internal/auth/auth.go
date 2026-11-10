// Package auth is sign-in (P4.1): the e-mail OTP route that opens an account
// on the first request, the language route, the OTP e-mail in the user's
// language and the demo account's password login.
//
// The flow is Supabase's: the app sends the e-mail, gets a 6-digit code by
// e-mail and signs in with PocketBase's own auth-with-otp. There is no
// sign-up step and no link in the e-mail.
package auth

import (
	"database/sql"
	"errors"
	"net/http"
	"net/mail"
	"strings"
	"time"

	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/security"
)

// UsersCollection is the auth collection of the app's users.
const UsersCollection = "users"

// The users collection's auth settings; migrations/1794300011_users_auth.go
// writes them and the e-mail text reads the duration from the collection,
// so "10 minutes" has one source.
const (
	// OTPLength is the number of digits in a code (Supabase otp_length).
	OTPLength = 6
	// OTPDuration is how long a code is valid (Supabase otp_expiry 600).
	OTPDuration = 10 * time.Minute
	// TokenDuration is the auth token's lifetime (K-6); the app refreshes
	// it on start and on every sync round.
	TokenDuration = 90 * 24 * time.Hour
)

// ResendInterval is the shortest time between two codes to one e-mail
// (Supabase auth.email.max_frequency 60s).
const ResendInterval = 60 * time.Second

// DemoEmail is the only account that may sign in with a password: the
// store reviewers' demo account (K-12). Its password is set on the server
// (P8.1 `seed demo-user`) and is not in the repository.
const DemoEmail = "demo@tutunsoft.com"

// randomPasswordLength is the length of the unused password a new account
// gets; PocketBase's auth records require one.
const randomPasswordLength = 40

// Error codes in the JSON body's "data.code"; the app (P7.2) maps them.
const (
	CodeInvalidEmail    = "invalid_email"
	CodeInvalidLocale   = "invalid_locale"
	CodeTooManyRequests = "too_many_requests"
	CodeMailFailed      = "mail_failed"
)

// Register binds the routes and hooks of this package.
func Register(app core.App) {
	registerOTPMail(app)
	registerDevMailLog(app)
	registerDemoPasswordOnly(app)
	registerNoRecordAPIOTPRequest(app)

	app.OnServe().BindFunc(func(se *core.ServeEvent) error {
		se.Router.POST("/api/app/auth/otp", requestOTP)
		se.Router.POST("/api/app/auth/locale", setLocale).
			Bind(apis.RequireAuth(UsersCollection))
		return se.Next()
	})
}

// NormalizeEmail trims and lower-cases an address and checks that it is a
// bare address (no display name). Supabase stored e-mails lower-cased too.
func NormalizeEmail(value string) (string, bool) {
	email := strings.ToLower(strings.TrimSpace(value))
	if email == "" || len(email) > 255 {
		return "", false
	}
	addr, err := mail.ParseAddress(email)
	if err != nil || addr.Address != email || addr.Name != "" {
		return "", false
	}
	at := strings.LastIndexByte(email, '@')
	if at < 1 || !strings.Contains(email[at+1:], ".") {
		return "", false
	}
	return email, true
}

type otpRequest struct {
	Email  string `json:"email"`
	Locale string `json:"locale"`
}

// OTPResponse is the body of a successful POST /api/app/auth/otp; otpId
// goes to /api/collections/users/auth-with-otp with the code.
type OTPResponse struct {
	OTPID string `json:"otpId"`
}

// requestOTP is POST /api/app/auth/otp {email, locale}.
//
// It opens the account if the e-mail is new (locale from the request,
// verified false; the first code verifies it), refuses a second code to the
// same e-mail within [ResendInterval] and sends a new code. The answer is
// the same whether the account existed or not; errors depend only on the
// request and the timing, never on the account's existence.
func requestOTP(e *core.RequestEvent) error {
	var body otpRequest
	if err := e.BindBody(&body); err != nil {
		return invalidEmail(e)
	}
	email, ok := NormalizeEmail(body.Email)
	if !ok {
		return invalidEmail(e)
	}

	users, err := e.App.FindCollectionByNameOrId(UsersCollection)
	if err != nil {
		return e.InternalServerError("", err)
	}
	user, err := findOrCreateUser(e.App, users, email, PickLocale(body.Locale))
	if err != nil {
		return e.InternalServerError("", err)
	}

	otps, err := e.App.FindAllOTPsByRecord(user)
	if err != nil {
		return e.InternalServerError("", err)
	}
	for _, o := range otps {
		if time.Since(o.Created().Time()) < ResendInterval {
			return apiError(e, http.StatusTooManyRequests, CodeTooManyRequests,
				"Please wait before requesting another code.")
		}
	}

	code := security.RandomStringWithAlphabet(users.OTP.Length, "0123456789")
	otp := core.NewOTP(e.App)
	otp.SetCollectionRef(users.Id)
	otp.SetRecordRef(user.Id)
	otp.SetPassword(code)
	if err := e.App.Save(otp); err != nil {
		return e.InternalServerError("", err)
	}

	// Sent before answering, unlike PocketBase's request-otp: the app must
	// know when no e-mail went out. The account exists in both branches,
	// so the extra time tells nothing about it.
	if err := sendOTP(e.App, user, otp.Id, code); err != nil {
		e.App.Logger().Error("OTP e-mail not sent", "error", err, "userId", user.Id)
		if delErr := e.App.Delete(otp); delErr != nil {
			e.App.Logger().Error("Unsent OTP not deleted", "error", delErr, "otpId", otp.Id)
		}
		return apiError(e, http.StatusServiceUnavailable, CodeMailFailed,
			"The code could not be sent. Please try again later.")
	}
	return e.JSON(http.StatusOK, OTPResponse{OTPID: otp.Id})
}

// findOrCreateUser returns the account of email, opening it with locale if
// there is none. An existing account's locale is left alone; the app
// changes it with /api/app/auth/locale.
func findOrCreateUser(app core.App, users *core.Collection, email, locale string) (*core.Record, error) {
	user, err := app.FindAuthRecordByEmail(users, email)
	if err == nil {
		return user, nil
	}
	if !errors.Is(err, sql.ErrNoRows) {
		return nil, err
	}

	user = core.NewRecord(users)
	user.SetEmail(email)
	user.SetVerified(false)
	user.SetPassword(security.RandomString(randomPasswordLength))
	user.Set("locale", locale)
	if err := app.Save(user); err != nil {
		// Two first requests at once: the other one opened it.
		if again, findErr := app.FindAuthRecordByEmail(users, email); findErr == nil {
			return again, nil
		}
		return nil, err
	}
	return user, nil
}

type localeRequest struct {
	Locale string `json:"locale"`
}

// LocaleResponse is the body of a successful POST /api/app/auth/locale.
type LocaleResponse struct {
	Locale string `json:"locale"`
}

// setLocale is POST /api/app/auth/locale {locale}: the signed-in user's
// language, used by the e-mails. "pt_BR" is stored as "pt"; a language the
// app does not have is refused.
func setLocale(e *core.RequestEvent) error {
	var body localeRequest
	if err := e.BindBody(&body); err != nil {
		return invalidLocale(e)
	}
	locale, ok := ParseLocale(body.Locale)
	if !ok {
		return invalidLocale(e)
	}
	user := e.Auth
	if user.GetString("locale") != locale {
		user.Set("locale", locale)
		if err := e.App.Save(user); err != nil {
			return e.InternalServerError("", err)
		}
	}
	return e.JSON(http.StatusOK, LocaleResponse{Locale: locale})
}

func invalidEmail(e *core.RequestEvent) error {
	return apiError(e, http.StatusBadRequest, CodeInvalidEmail, "Enter a valid e-mail address.")
}

func invalidLocale(e *core.RequestEvent) error {
	return apiError(e, http.StatusBadRequest, CodeInvalidLocale, "Unsupported language.")
}

// apiError is PocketBase's error body ({status, message, data}) with our
// code in data.code.
func apiError(e *core.RequestEvent, status int, code, message string) error {
	return e.JSON(status, ErrorBody{Status: status, Message: message, Data: ErrorData{Code: code}})
}

// ErrorBody is the JSON of a refused request; a struct keeps the key order
// fixed, so equal errors are equal bytes.
type ErrorBody struct {
	Status  int       `json:"status"`
	Message string    `json:"message"`
	Data    ErrorData `json:"data"`
}

// ErrorData carries the machine-readable code.
type ErrorData struct {
	Code string `json:"code"`
}
