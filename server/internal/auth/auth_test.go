package auth_test

import (
	"encoding/json"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/types"
)

const (
	otpURL      = "/api/app/auth/otp"
	localeURL   = "/api/app/auth/locale"
	authOTPURL  = "/api/collections/users/auth-with-otp"
	authPassURL = "/api/collections/users/auth-with-password"

	// demoPassword exists only in this test's temporary database.
	demoPassword = "test-only-demo-password"
)

// testMail turns e-mail on; the test mailer catches every message, nothing
// is sent.
var testMail = config.Mail{
	Host:     "smtp.example.com",
	Port:     465,
	Username: "noreply@example.com",
	Password: "test-only-smtp-password",
}

func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev, Mail: testMail}, "test")
	return app
}

// response is a finished request: status and body.
type response struct {
	status int
	body   []byte
}

func (r response) json(t *testing.T) map[string]any {
	t.Helper()
	var out map[string]any
	if err := json.Unmarshal(r.body, &out); err != nil {
		t.Fatalf("body %q: %v", r.body, err)
	}
	return out
}

func (r response) code(t *testing.T) string {
	t.Helper()
	data, _ := r.json(t)["data"].(map[string]any)
	code, _ := data["code"].(string)
	return code
}

// call sends a JSON request through the app's router and checks the status.
func call(t *testing.T, app *tests.TestApp, url string, body any, token string, wantStatus int) response {
	t.Helper()
	raw, err := json.Marshal(body)
	if err != nil {
		t.Fatal(err)
	}
	headers := map[string]string{"Content-Type": "application/json"}
	if token != "" {
		headers["Authorization"] = token
	}
	var out response
	s := tests.ApiScenario{
		Name:                  url,
		Method:                http.MethodPost,
		URL:                   url,
		Body:                  strings.NewReader(string(raw)),
		Headers:               headers,
		ExpectedStatus:        wantStatus,
		ExpectedContent:       []string{""},
		TestAppFactory:        func(testing.TB) *tests.TestApp { return app },
		DisableTestAppCleanup: true,
		AfterTestFunc: func(t testing.TB, _ *tests.TestApp, res *http.Response) {
			b, err := io.ReadAll(res.Body)
			if err != nil {
				t.Fatal(err)
			}
			out = response{status: res.StatusCode, body: b}
		},
	}
	s.Test(t)
	return out
}

func requestCode(t *testing.T, app *tests.TestApp, email, locale string, wantStatus int) response {
	t.Helper()
	return call(t, app, otpURL, map[string]string{"email": email, "locale": locale}, "", wantStatus)
}

var codeInText = regexp.MustCompile(`(?m)^(\d{6})$`)

// lastCode is the code in the last e-mail the test mailer caught.
func lastCode(t *testing.T, app *tests.TestApp) string {
	t.Helper()
	m := codeInText.FindStringSubmatch(app.TestMailer.LastMessage().Text)
	if m == nil {
		t.Fatalf("no code in the last e-mail: %q", app.TestMailer.LastMessage().Text)
	}
	return m[1]
}

func otpID(t *testing.T, r response) string {
	t.Helper()
	id, _ := r.json(t)["otpId"].(string)
	if id == "" {
		t.Fatalf("no otpId in %s", r.body)
	}
	return id
}

func findUser(t *testing.T, app *tests.TestApp, email string) *core.Record {
	t.Helper()
	u, err := app.FindAuthRecordByEmail(auth.UsersCollection, email)
	if err != nil {
		t.Fatalf("user %s: %v", email, err)
	}
	return u
}

func newUser(t *testing.T, app *tests.TestApp, email, locale, password string) *core.Record {
	t.Helper()
	c, err := app.FindCollectionByNameOrId(auth.UsersCollection)
	if err != nil {
		t.Fatal(err)
	}
	u := core.NewRecord(c)
	u.SetEmail(email)
	u.SetPassword(password)
	u.Set("locale", locale)
	if err := app.Save(u); err != nil {
		t.Fatal(err)
	}
	return u
}

// ageOTPs moves the user's codes back in time.
func ageOTPs(t *testing.T, app *tests.TestApp, user *core.Record, by time.Duration) {
	t.Helper()
	created, err := types.ParseDateTime(time.Now().Add(-by))
	if err != nil {
		t.Fatal(err)
	}
	_, err = app.DB().NewQuery("UPDATE _otps SET created = {:c} WHERE recordRef = {:r}").
		Bind(map[string]any{"c": created.String(), "r": user.Id}).Execute()
	if err != nil {
		t.Fatal(err)
	}
}

func TestUsersAuthSettings(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId(auth.UsersCollection)
	if err != nil {
		t.Fatal(err)
	}
	if !c.OTP.Enabled || c.OTP.Length != 6 || c.OTP.Duration != 600 {
		t.Errorf("otp = %+v, want on, 6 digits, 600 s", c.OTP)
	}
	if !c.PasswordAuth.Enabled || len(c.PasswordAuth.IdentityFields) != 1 || c.PasswordAuth.IdentityFields[0] != "email" {
		t.Errorf("password auth = %+v, want on, email only", c.PasswordAuth)
	}
	if c.OAuth2.Enabled || c.MFA.Enabled || c.AuthAlert.Enabled {
		t.Errorf("oauth2 %v, mfa %v, auth alert %v; want all off", c.OAuth2.Enabled, c.MFA.Enabled, c.AuthAlert.Enabled)
	}
	if c.AuthToken.Duration != 90*24*3600 {
		t.Errorf("token duration = %d, want 90 days", c.AuthToken.Duration)
	}
}

func TestNewUserIsOpenedAndMailed(t *testing.T) {
	app := newApp(t)
	r := requestCode(t, app, "  New.User@Example.COM ", "tr-TR", 200)
	otpID(t, r)

	u := findUser(t, app, "new.user@example.com")
	if u.Verified() {
		t.Error("a new account starts unverified")
	}
	if got := u.GetString("locale"); got != "tr" {
		t.Errorf("locale = %q, want tr", got)
	}
	var hash string
	if err := app.DB().NewQuery("SELECT password FROM users WHERE id = {:id}").
		Bind(map[string]any{"id": u.Id}).Row(&hash); err != nil || len(hash) < 50 {
		t.Errorf("a new account needs a (random) password hash; got %q, %v", hash, err)
	}

	if app.TestMailer.TotalSend() != 1 {
		t.Fatalf("sent %d e-mails, want 1", app.TestMailer.TotalSend())
	}
	m := app.TestMailer.LastMessage()
	if len(m.To) != 1 || m.To[0].Address != "new.user@example.com" {
		t.Errorf("to = %v", m.To)
	}
	if m.Subject != "Mobil Arıcı giriş kodunuz" {
		t.Errorf("subject = %q", m.Subject)
	}
	code := lastCode(t, app)
	for _, want := range []string{code, "Kod 10 dakika geçerlidir", `lang="tr"`, `dir="ltr"`} {
		if !strings.Contains(m.HTML, want) {
			t.Errorf("HTML lacks %q", want)
		}
	}
	for _, link := range []string{"href", "http://", "https://", "{minutes}", "{email}"} {
		if strings.Contains(m.HTML, link) {
			t.Errorf("HTML contains %q", link)
		}
	}
}

func TestExistingUserLocaleUnchanged(t *testing.T) {
	app := newApp(t)
	newUser(t, app, "old@example.com", "de", "irrelevant-password")

	requestCode(t, app, "old@example.com", "tr", 200)

	if got := findUser(t, app, "old@example.com").GetString("locale"); got != "de" {
		t.Errorf("locale = %q, want de (unchanged)", got)
	}
	if got := app.TestMailer.LastMessage().Subject; got != "Dein Anmeldecode für Mobil Arıcı" {
		t.Errorf("subject = %q, want the account's German", got)
	}
}

func TestResendInterval(t *testing.T) {
	app := newApp(t)
	requestCode(t, app, "wait@example.com", "en", 200)

	r := requestCode(t, app, "WAIT@example.com", "en", 429)
	if r.code(t) != auth.CodeTooManyRequests {
		t.Errorf("code = %q", r.code(t))
	}
	if app.TestMailer.TotalSend() != 1 {
		t.Errorf("sent %d e-mails, want 1", app.TestMailer.TotalSend())
	}

	ageOTPs(t, app, findUser(t, app, "wait@example.com"), auth.ResendInterval+time.Second)
	requestCode(t, app, "wait@example.com", "en", 200)
	if app.TestMailer.TotalSend() != 2 {
		t.Errorf("sent %d e-mails, want 2", app.TestMailer.TotalSend())
	}
}

func TestSignInWithCode(t *testing.T) {
	app := newApp(t)
	id := otpID(t, requestCode(t, app, "code@example.com", "en", 200))
	code := lastCode(t, app)

	r := call(t, app, authOTPURL, map[string]string{"otpId": id, "password": code}, "", 200)
	if tok, _ := r.json(t)["token"].(string); tok == "" {
		t.Fatalf("no token in %s", r.body)
	}
	if !findUser(t, app, "code@example.com").Verified() {
		t.Error("the first code verifies the account")
	}

	t.Run("the same code twice", func(t *testing.T) {
		call(t, app, authOTPURL, map[string]string{"otpId": id, "password": code}, "", 400)
	})
}

func TestWrongCode(t *testing.T) {
	app := newApp(t)
	id := otpID(t, requestCode(t, app, "wrong@example.com", "en", 200))
	code := lastCode(t, app)
	wrong := "000000"
	if code == wrong {
		wrong = "111111"
	}
	call(t, app, authOTPURL, map[string]string{"otpId": id, "password": wrong}, "", 400)
	// The right code still works afterwards.
	call(t, app, authOTPURL, map[string]string{"otpId": id, "password": code}, "", 200)
}

func TestExpiredCode(t *testing.T) {
	app := newApp(t)
	id := otpID(t, requestCode(t, app, "late@example.com", "en", 200))
	code := lastCode(t, app)
	ageOTPs(t, app, findUser(t, app, "late@example.com"), auth.OTPDuration+time.Second)
	call(t, app, authOTPURL, map[string]string{"otpId": id, "password": code}, "", 400)
}

func TestNoEnumeration(t *testing.T) {
	app := newApp(t)
	newUser(t, app, "known@example.com", "en", "irrelevant-password")

	known := requestCode(t, app, "known@example.com", "en", 200)
	unknown := requestCode(t, app, "unknown@example.com", "en", 200)
	if len(known.body) != len(unknown.body) || len(known.json(t)) != 1 || len(unknown.json(t)) != 1 {
		t.Errorf("answers differ: %s / %s", known.body, unknown.body)
	}

	knownAgain := requestCode(t, app, "known@example.com", "en", 429)
	unknownAgain := requestCode(t, app, "unknown@example.com", "en", 429)
	if string(knownAgain.body) != string(unknownAgain.body) {
		t.Errorf("429 differs: %s / %s", knownAgain.body, unknownAgain.body)
	}
}

func TestInvalidEmail(t *testing.T) {
	app := newApp(t)
	var first string
	for _, email := range []string{"", "a", "a@b", "@example.com", "Ali <ali@example.com>", "a b@example.com", strings.Repeat("a", 250) + "@x.com"} {
		r := requestCode(t, app, email, "en", 400)
		if r.code(t) != auth.CodeInvalidEmail {
			t.Errorf("%q: code %q", email, r.code(t))
		}
		if first == "" {
			first = string(r.body)
		} else if string(r.body) != first {
			t.Errorf("%q: body %s differs from %s", email, r.body, first)
		}
	}
	if app.TestMailer.TotalSend() != 0 {
		t.Error("no e-mail for an invalid address")
	}
}

func TestRecordAPIRequestOTPClosed(t *testing.T) {
	app := newApp(t)
	newUser(t, app, "pb@example.com", "en", "irrelevant-password")
	call(t, app, "/api/collections/users/request-otp", map[string]string{"email": "pb@example.com"}, "", 404)
	if app.TestMailer.TotalSend() != 0 {
		t.Error("PocketBase's request-otp sent an e-mail")
	}
}

func TestUserWithoutLocaleGetsEnglish(t *testing.T) {
	app := newApp(t)
	u := newUser(t, app, "nolocale@example.com", "en", "irrelevant-password")
	if _, err := app.DB().NewQuery("UPDATE users SET locale = '' WHERE id = {:id}").
		Bind(map[string]any{"id": u.Id}).Execute(); err != nil {
		t.Fatal(err)
	}
	requestCode(t, app, "nolocale@example.com", "tr", 200)
	if got := app.TestMailer.LastMessage().Subject; got != "Your Mobil Arıcı sign-in code" {
		t.Errorf("subject = %q, want English", got)
	}
}

func TestNewUserUnknownLocaleIsEnglish(t *testing.T) {
	app := newApp(t)
	requestCode(t, app, "xx@example.com", "xx", 200)
	if got := findUser(t, app, "xx@example.com").GetString("locale"); got != "en" {
		t.Errorf("locale = %q, want en", got)
	}
}

func TestSetLocale(t *testing.T) {
	app := newApp(t)
	u := newUser(t, app, "lang@example.com", "en", "irrelevant-password")
	tok, err := u.NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}

	call(t, app, localeURL, map[string]string{"locale": "pt"}, "", 401)

	r := call(t, app, localeURL, map[string]string{"locale": "pt_BR"}, tok, 200)
	if got := r.json(t)["locale"]; got != "pt" {
		t.Errorf("answer locale = %v", got)
	}
	if got := findUser(t, app, "lang@example.com").GetString("locale"); got != "pt" {
		t.Errorf("stored locale = %q, want pt", got)
	}

	r = call(t, app, localeURL, map[string]string{"locale": "xx"}, tok, 400)
	if r.code(t) != auth.CodeInvalidLocale {
		t.Errorf("code = %q", r.code(t))
	}
	if got := findUser(t, app, "lang@example.com").GetString("locale"); got != "pt" {
		t.Errorf("a refused locale changed it to %q", got)
	}

	// The next code comes in the new language.
	requestCode(t, app, "lang@example.com", "en", 200)
	if got := app.TestMailer.LastMessage().Subject; got != "Seu código de acesso ao Mobil Arıcı" {
		t.Errorf("subject = %q", got)
	}
}

func TestPasswordLoginOnlyForDemo(t *testing.T) {
	app := newApp(t)
	newUser(t, app, auth.DemoEmail, "en", demoPassword)
	newUser(t, app, "other@example.com", "en", demoPassword)

	r := call(t, app, authPassURL, map[string]string{"identity": auth.DemoEmail, "password": demoPassword}, "", 200)
	if tok, _ := r.json(t)["token"].(string); tok == "" {
		t.Fatalf("demo: no token in %s", r.body)
	}

	wrongDemo := call(t, app, authPassURL, map[string]string{"identity": auth.DemoEmail, "password": "not-it"}, "", 400)
	other := call(t, app, authPassURL, map[string]string{"identity": "other@example.com", "password": demoPassword}, "", 400)
	nobody := call(t, app, authPassURL, map[string]string{"identity": "nobody@example.com", "password": demoPassword}, "", 400)
	for name, r := range map[string]response{"other account": other, "no account": nobody} {
		if string(r.body) != string(wrongDemo.body) {
			t.Errorf("%s: %s, want the wrong-password answer %s", name, r.body, wrongDemo.body)
		}
	}
}

func TestOTPMailEveryLanguage(t *testing.T) {
	// OTP_MAIL_PREVIEW=<dir> keeps the nine HTML files for a look.
	dir := os.Getenv("OTP_MAIL_PREVIEW")
	if dir == "" {
		dir = t.TempDir()
	}
	want := map[string]string{
		"tr": "Mobil Arıcı giriş kodunuz",
		"en": "Your Mobil Arıcı sign-in code",
		"de": "Dein Anmeldecode für Mobil Arıcı",
		"es": "Tu código para iniciar sesión en Mobil Arıcı",
		"pt": "Seu código de acesso ao Mobil Arıcı",
		"ru": "Ваш код для входа в Mobil Arıcı",
		"uk": "Ваш код для входу в Mobil Arıcı",
		"fa": "کد ورود شما به Mobil Arıcı",
		"hi": "आपका Mobil Arıcı साइन-इन कोड",
	}
	if len(want) != len(auth.Locales) {
		t.Fatalf("%d subjects for %d languages", len(want), len(auth.Locales))
	}
	for _, l := range auth.Locales {
		m, err := auth.RenderOTPMail(l, "123456", "ali@example.com", auth.OTPDuration)
		if err != nil {
			t.Fatal(err)
		}
		if m.Subject != want[l] {
			t.Errorf("%s: subject %q, want %q", l, m.Subject, want[l])
		}
		for _, s := range []string{`lang="` + l + `"`, "123456", "10", "ali@example.com", "<title>" + want[l] + "</title>"} {
			if !strings.Contains(m.HTML, s) {
				t.Errorf("%s: HTML lacks %q", l, s)
			}
		}
		if (l == "fa") != strings.Contains(m.HTML, `dir="rtl"`) {
			t.Errorf("%s: wrong direction", l)
		}
		if err := os.WriteFile(filepath.Join(dir, "otp_"+l+".html"), []byte(m.HTML), 0o600); err != nil {
			t.Fatal(err)
		}
	}

	for _, l := range []string{"", "xx", "zh-CN"} {
		m, _ := auth.RenderOTPMail(l, "123456", "a@example.com", auth.OTPDuration)
		if m.Subject != want["en"] {
			t.Errorf("%q: subject %q, want English", l, m.Subject)
		}
	}

	m, _ := auth.RenderOTPMail("en", "123456", "a@example.com", 15*time.Minute)
	if !strings.Contains(m.HTML, "valid for 15 minutes") {
		t.Error("the minutes follow the duration")
	}
	m, _ = auth.RenderOTPMail("en", "123456", `<b>"x"</b>@example.com`, auth.OTPDuration)
	if strings.Contains(m.HTML, "<b>") {
		t.Error("the address is not escaped")
	}
}

func TestParseLocale(t *testing.T) {
	for in, want := range map[string]string{
		"tr": "tr", " DE ": "de", "pt_BR": "pt", "fa-IR": "fa", "hi": "hi",
		"": "en", "xx": "en", "zh-CN": "en", "-": "en",
	} {
		if got := auth.PickLocale(in); got != want {
			t.Errorf("PickLocale(%q) = %q, want %q", in, got, want)
		}
	}
	if _, ok := auth.ParseLocale("xx"); ok {
		t.Error("xx is not a language of the app")
	}
}
