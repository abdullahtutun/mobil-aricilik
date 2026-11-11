package feedback_test

import (
	"bytes"
	"encoding/json"
	"errors"
	"image"
	"image/jpeg"
	"log/slog"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/feedback"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/mail"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/mail/mailtest"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/filesystem"
)

const (
	member  = "0195f2a4-a000-7000-8000-0000000000a1"
	orgA    = "0195f2a4-0a0a-7000-8000-00000000000a"
	shotID  = "0195f2a4-f000-7000-8000-000000000001"
	plainID = "0195f2a4-f000-7000-8000-000000000002"

	encryptionKey = "0123456789abcdef0123456789abcdef"
	appURL        = "https://dev.arici.example"
	testTime      = "2026-11-10T10:15:30.123456Z"
	memberEmail   = "arici@example.com"
	teamEmail     = "feedback@tutunsoft.com"
)

var jpegBytes = func() []byte {
	var b bytes.Buffer
	if err := jpeg.Encode(&b, image.NewRGBA(image.Rect(0, 0, 8, 8)), nil); err != nil {
		panic(err)
	}
	return b.Bytes()
}()

func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	return app
}

// newBareApp is an app with only the model hooks seed needs; the test
// registers the feedback package itself.
func newBareApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app := newApp(t)
	ids.Register(app)
	appsync.RegisterSeq(app)
	return app
}

// seed adds the member, their organization and membership.
func seed(t *testing.T, app core.App) *core.Record {
	t.Helper()
	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	u := core.NewRecord(users)
	u.Id = member
	u.SetEmail(memberEmail)
	u.SetPassword("1234567890")
	save(t, app, u)

	org := newRecord(t, app, "organizations")
	org.Id = orgA
	org.Set("name", "Çiçek Arıcılık")
	org.Set("country_code", "TR")
	org.Set("currency", "TRY")
	org.Set("operation_type", "migratory")
	stamp(org)
	save(t, app, org)

	m := newRecord(t, app, "memberships")
	m.Id = "0195f2a4-c000-7000-8000-000000000001"
	m.Set("org_id", orgA)
	m.Set("user_id", member)
	m.Set("role", "worker")
	stamp(m)
	save(t, app, m)
	return u
}

func newRecord(t *testing.T, app core.App, collection string) *core.Record {
	t.Helper()
	c, err := app.FindCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	return core.NewRecord(c)
}

func stamp(r *core.Record) {
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
}

func save(t *testing.T, app core.App, r *core.Record) {
	t.Helper()
	if err := app.Save(r); err != nil {
		t.Fatalf("%s %s: %v", r.Collection().Name, r.Id, err)
	}
}

// storeShot saves the screenshot in feedback_files, as the upload would.
func storeShot(t *testing.T, app core.App, id string) {
	t.Helper()
	file, err := filesystem.NewFileFromBytes(jpegBytes, id+".jpg")
	if err != nil {
		t.Fatal(err)
	}
	r := newRecord(t, app, "feedback_files")
	r.Id = id
	r.Set("org_id", orgA)
	r.Set("path", orgA+"/"+id+".jpg")
	r.Set("file", file)
	save(t, app, r)
}

// postFeedback sends feedback through the record API as the member.
func postFeedback(t *testing.T, app *tests.TestApp, user *core.Record, id string, withShot bool) {
	t.Helper()
	body := map[string]any{
		"id": id, "org_id": orgA, "kind": "bug", "message": "Kovan kartı açılmıyor",
		"created_at": testTime, "received_at": testTime, "created_by": member,
		"device_info": map[string]any{"platform": "android", "app_version": "1.2.0"},
	}
	if withShot {
		body["screenshot_path"] = orgA + "/" + id + ".jpg"
	}
	raw, _ := json.Marshal(body)
	token, err := user.NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}
	(&tests.ApiScenario{
		Name:   "member sends feedback " + id,
		Method: http.MethodPost, URL: "/api/collections/feedback/records",
		Body:                  bytes.NewReader(raw),
		Headers:               map[string]string{"Authorization": token, "Content-Type": "application/json"},
		ExpectedStatus:        200,
		ExpectedContent:       []string{`"id":"` + id + `"`},
		TestAppFactory:        func(testing.TB) *tests.TestApp { return app },
		DisableTestAppCleanup: true,
	}).Test(t)
}

func mustExist(t *testing.T, app core.App, id string) {
	t.Helper()
	if _, err := app.FindRecordById("feedback", id); err != nil {
		t.Fatalf("feedback %s was not stored: %v", id, err)
	}
}

// fullConfig is the environment with the feedback mailbox on the test
// SMTP server.
func fullConfig(s *mailtest.Server) config.Config {
	return config.Config{
		Env:           config.EnvDev,
		URL:           appURL,
		EncryptionKey: encryptionKey,
		FeedbackMail: config.FeedbackMail{
			Host: s.Host, Port: s.Port,
			Username: "feedback-sender@tutunsoft.com", Password: "mailbox pass",
			To: teamEmail,
		},
	}
}

// The whole path through bootstrap: record API → hook → SMTP.
func TestFeedbackMailThroughSMTP(t *testing.T) {
	smtp := mailtest.Start(t)
	app := newApp(t)
	bootstrap.Register(app, fullConfig(smtp), "test")
	user := seed(t, app)

	start := time.Now()
	postFeedback(t, app, user, shotID, true)
	mustExist(t, app, shotID)

	got := smtp.WaitFor(1, 5*time.Second)
	if len(got) != 1 {
		t.Fatalf("%d mails", len(got))
	}
	m := got[0]
	if m.User != "feedback-sender@tutunsoft.com" || m.Pass != "mailbox pass" {
		t.Errorf("login = %q / %q", m.User, m.Pass)
	}
	if m.From != "feedback-sender@tutunsoft.com" || len(m.To) != 1 || m.To[0] != teamEmail {
		t.Errorf("envelope = %q → %v", m.From, m.To)
	}
	if got := m.Header.Get("Reply-To"); got != memberEmail {
		t.Errorf("Reply-To = %q", got)
	}
	from, _ := m.Header.AddressList("From")
	if len(from) != 1 || from[0].Name != "Mobil Arıcı" {
		t.Errorf("From = %v", from)
	}
	if m.Subject != "[Mobil Arıcı] Hata — Çiçek Arıcılık" {
		t.Errorf("subject = %q", m.Subject)
	}

	text, link, _ := strings.Cut(m.Text, "Ekran görüntüsü (7 gün geçerli): ")
	wantHead := "Kovan kartı açılmıyor\n\n—\nTür: Hata\nİşletme: Çiçek Arıcılık\nGönderen: " + memberEmail +
		"\nYazıldığı an: " + testTime + "\nCihaz:\n  app_version: 1.2.0\n  platform: android\n"
	if text != wantHead {
		t.Errorf("text head =\n%s", text)
	}
	link, tail, _ := strings.Cut(link, "\n")
	if tail != "Kayıt: feedback.id = "+shotID {
		t.Errorf("text tail = %q", tail)
	}

	// The link points at this server, lives 7 days and opens the shot.
	u, err := url.Parse(link)
	if err != nil || u.Scheme+"://"+u.Host != appURL || u.Path != feedback.RoutePrefix+shotID {
		t.Fatalf("link = %q", link)
	}
	expUnix, err := strconv.ParseInt(u.Query().Get("exp"), 10, 64)
	if err != nil {
		t.Fatalf("exp = %q", u.Query().Get("exp"))
	}
	if d := time.Unix(expUnix, 0).Sub(start); d < feedback.LinkTTL-time.Minute || d > feedback.LinkTTL+time.Minute {
		t.Errorf("link lives %v", d)
	}
	storeShot(t, app, shotID)
	getShot(t, app, u.RequestURI(), 200)
}

// Feedback without a screenshot, from a user whose record is gone: no link,
// no Reply-To, the sender is "bilinmiyor".
func TestFeedbackMailWithoutShotOrSender(t *testing.T) {
	smtp := mailtest.Start(t)
	app := newApp(t)
	bootstrap.Register(app, fullConfig(smtp), "test")
	user := seed(t, app)
	postFeedback(t, app, user, plainID, false)
	if err := app.Delete(user); err != nil {
		t.Fatal(err)
	}
	// A second one after the user is gone, stored directly.
	r := newRecord(t, app, "feedback")
	r.Id = "0195f2a4-f000-7000-8000-000000000003"
	r.Set("org_id", orgA)
	r.Set("kind", "thanks")
	r.Set("message", "Teşekkürler")
	r.Set("created_at", testTime)
	r.Set("received_at", testTime)
	r.Set("created_by", member)
	save(t, app, r)

	got := smtp.WaitFor(2, 5*time.Second)
	if len(got) != 2 {
		t.Fatalf("%d mails", len(got))
	}
	var gone *mailtest.Mail
	for i := range got {
		if strings.Contains(got[i].Text, "feedback.id = "+r.Id) {
			gone = &got[i]
		}
		if strings.Contains(got[i].Text, "Ekran görüntüsü") {
			t.Errorf("a screenshot line without a screenshot:\n%s", got[i].Text)
		}
	}
	if gone == nil {
		t.Fatal("no mail for the second feedback")
	}
	if gone.Header.Get("Reply-To") != "" || !strings.Contains(gone.Text, "Gönderen: bilinmiyor") {
		t.Errorf("mail = %+v", *gone)
	}
}

// Without the mailbox variables the feedback is stored and no mail goes out.
func TestFeedbackStoredWithoutMailEnv(t *testing.T) {
	smtp := mailtest.Start(t)
	app := newApp(t)
	cfg := fullConfig(smtp)
	cfg.FeedbackMail = config.Load(func(string) string { return "" }).FeedbackMail
	bootstrap.Register(app, cfg, "test")
	user := seed(t, app)

	postFeedback(t, app, user, shotID, true)
	mustExist(t, app, shotID)
	if got := smtp.WaitFor(1, 300*time.Millisecond); len(got) != 0 {
		t.Fatalf("sent %d mails", len(got))
	}
}

// fakeSender records or fails.
type fakeSender struct {
	mu   sync.Mutex
	got  []mail.Message
	fail error
}

func (f *fakeSender) Send(m mail.Message) error {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.got = append(f.got, m)
	return f.fail
}

type lockedBuffer struct {
	mu  sync.Mutex
	buf bytes.Buffer
}

func (b *lockedBuffer) Write(p []byte) (int, error) {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.buf.Write(p)
}

func (b *lockedBuffer) String() string {
	b.mu.Lock()
	defer b.mu.Unlock()
	return b.buf.String()
}

// A failing SMTP server never undoes the feedback, and the password never
// reaches the log.
func TestFeedbackStoredWhenSendFails(t *testing.T) {
	app := newBareApp(t)
	sender := &fakeSender{fail: errors.New("535 authentication failed")}
	log := &lockedBuffer{}
	m := feedback.Register(app, feedback.Options{
		Sender: sender, To: teamEmail, BaseURL: appURL, Signer: feedback.NewSigner(encryptionKey),
		Logger: slog.New(slog.NewTextHandler(log, nil)),
	})
	user := seed(t, app)
	postFeedback(t, app, user, shotID, true)
	m.Wait()
	mustExist(t, app, shotID)
	if len(sender.got) != 1 {
		t.Fatalf("%d sends", len(sender.got))
	}
	if !strings.Contains(log.String(), "feedback mail: send failed") || strings.Contains(log.String(), encryptionKey) {
		t.Errorf("log = %s", log.String())
	}
}

// A rolled back insert sends nothing: the hook runs after commit only.
func TestFeedbackRollbackSendsNothing(t *testing.T) {
	app := newBareApp(t)
	sender := &fakeSender{}
	m := feedback.Register(app, feedback.Options{Sender: sender, To: teamEmail})
	seed(t, app)
	err := app.RunInTransaction(func(tx core.App) error {
		r := newRecord(t, tx, "feedback")
		r.Id = shotID
		r.Set("org_id", orgA)
		r.Set("kind", "bug")
		r.Set("message", "x")
		r.Set("created_at", testTime)
		r.Set("received_at", testTime)
		if err := tx.Save(r); err != nil {
			return err
		}
		return errors.New("roll back")
	})
	if err == nil {
		t.Fatal("transaction committed")
	}
	m.Wait()
	if len(sender.got) != 0 {
		t.Fatalf("%d sends after rollback", len(sender.got))
	}
}

// ---------------------------------------------------------------------------
// Screenshot route
// ---------------------------------------------------------------------------

func getShot(t *testing.T, app *tests.TestApp, uri string, status int) {
	t.Helper()
	s := tests.ApiScenario{
		Name:   "GET " + uri,
		Method: http.MethodGet, URL: uri,
		ExpectedStatus:        status,
		TestAppFactory:        func(testing.TB) *tests.TestApp { return app },
		DisableTestAppCleanup: true,
	}
	switch status {
	case 200:
		s.ExpectedContent = []string{string(jpegBytes[:3])}
	case 403:
		s.ExpectedContent = []string{`"status":403`}
		s.NotExpectedContent = []string{string(jpegBytes[:3])}
	case 404:
		s.ExpectedContent = []string{`"status":404`}
	}
	s.Test(t)
}

func TestShotLink(t *testing.T) {
	app := newBareApp(t)
	now := time.Date(2026, 11, 11, 9, 0, 0, 0, time.UTC)
	clock := now
	signer := feedback.NewSigner(encryptionKey)
	feedback.Register(app, feedback.Options{Signer: signer, Now: func() time.Time { return clock }})
	storeShot(t, app, shotID)

	path := func(link string) string {
		u, err := url.Parse(link)
		if err != nil {
			t.Fatal(err)
		}
		return u.RequestURI()
	}
	valid := path(signer.URL(appURL, shotID, now.Add(feedback.LinkTTL)))

	t.Run("valid link serves the screenshot", func(t *testing.T) {
		getShot(t, app, valid, 200)
	})
	t.Run("valid link headers", func(t *testing.T) {
		(&tests.ApiScenario{
			Method: http.MethodGet, URL: valid, ExpectedStatus: 200,
			ExpectedContent:       []string{string(jpegBytes[:3])},
			TestAppFactory:        func(testing.TB) *tests.TestApp { return app },
			DisableTestAppCleanup: true,
			AfterTestFunc: func(t testing.TB, _ *tests.TestApp, res *http.Response) {
				if got := res.Header.Get("Content-Type"); got != "image/jpeg" {
					t.Errorf("Content-Type = %q", got)
				}
				if got := res.Header.Get("Cache-Control"); got != "private, no-store" {
					t.Errorf("Cache-Control = %q", got)
				}
			},
		}).Test(t)
	})

	t.Run("expired link is 403", func(t *testing.T) {
		clock = now.Add(feedback.LinkTTL)
		defer func() { clock = now }()
		getShot(t, app, valid, 403)
	})
	t.Run("link signed for the past is 403", func(t *testing.T) {
		getShot(t, app, path(signer.URL(appURL, shotID, now.Add(-time.Second))), 403)
	})

	u, _ := url.Parse(valid)
	q := u.Query()
	sig := []byte(q.Get("sig"))
	sig[len(sig)/2] ^= 1
	broken := url.Values{"exp": {q.Get("exp")}, "sig": {string(sig)}}
	t.Run("broken signature is 403", func(t *testing.T) {
		getShot(t, app, u.Path+"?"+broken.Encode(), 403)
	})
	later := url.Values{"exp": {"9999999999"}, "sig": {q.Get("sig")}}
	t.Run("pushed expiry is 403", func(t *testing.T) {
		getShot(t, app, u.Path+"?"+later.Encode(), 403)
	})
	t.Run("missing signature is 403", func(t *testing.T) {
		getShot(t, app, u.Path, 403)
	})
	t.Run("another id with this signature is 403", func(t *testing.T) {
		storeShot(t, app, plainID)
		getShot(t, app, feedback.RoutePrefix+plainID+"?"+q.Encode(), 403)
	})
	t.Run("another server's key is 403", func(t *testing.T) {
		getShot(t, app, path(feedback.NewSigner("another key").URL(appURL, shotID, now.Add(time.Hour))), 403)
	})
	t.Run("valid link without an upload is 404", func(t *testing.T) {
		missing := "0195f2a4-f000-7000-8000-000000000009"
		getShot(t, app, path(signer.URL(appURL, missing, now.Add(time.Hour))), 404)
	})
}

// Without PB_ENCRYPTION_KEY every link is refused.
func TestShotLinkWithoutKey(t *testing.T) {
	app := newBareApp(t)
	feedback.Register(app, feedback.Options{})
	storeShot(t, app, shotID)
	link := feedback.NewSigner(encryptionKey).URL(appURL, shotID, time.Now().Add(time.Hour))
	u, _ := url.Parse(link)
	getShot(t, app, u.RequestURI(), 403)
}
