package notify_test

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/json"
	"encoding/pem"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"slices"
	"strings"
	"sync"
	"sync/atomic"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/fcm"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/notify"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const (
	owner      = "11111111-1111-1111-1111-111111111111" // orgTR owner
	partner    = "22222222-2222-2222-2222-222222222222" // orgTR partner
	worker     = "33333333-3333-3333-3333-333333333333" // orgTR worker
	removed    = "66666666-6666-6666-6666-666666666666" // left orgTR
	deOwner    = "99999999-9999-9999-9999-999999999999" // orgDE owner
	goneOwner  = "88888888-8888-8888-8888-888888888888" // deleted TR org's owner
	trAndDE    = "44444444-4444-4444-4444-444444444444" // orgDE partner and orgTR partner
	orgTR      = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
	orgDE      = "dddddddd-dddd-dddd-dddd-dddddddddddd"
	orgGone    = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"
	missingRef = "a1000000-0000-0000-0000-0000000000ff"

	testTime = "2026-11-10T10:15:30.123456Z"
)

// fakeGoogle is OAuth and FCM in one httptest server.
type fakeGoogle struct {
	server    *httptest.Server
	oauthFail atomic.Bool
	mu        sync.Mutex
	sends     []push
	// gone are tokens FCM answers 404 UNREGISTERED for.
	gone map[string]bool
}

// push is one FCM message as the fake received it.
type push struct {
	Token, Title, Body string
	Data               map[string]string
}

func newFakeGoogle(t *testing.T) *fakeGoogle {
	t.Helper()
	g := &fakeGoogle{gone: map[string]bool{}}
	g.server = httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/token" {
			if g.oauthFail.Load() {
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			_, _ = io.WriteString(w, `{"access_token":"ya29.test","expires_in":3599}`)
			return
		}
		var body struct {
			Message struct {
				Token        string            `json:"token"`
				Notification map[string]string `json:"notification"`
				Data         map[string]string `json:"data"`
			} `json:"message"`
		}
		_ = json.NewDecoder(r.Body).Decode(&body)
		m := body.Message
		g.mu.Lock()
		g.sends = append(g.sends, push{m.Token, m.Notification["title"], m.Notification["body"], m.Data})
		gone := g.gone[m.Token]
		g.mu.Unlock()
		if gone {
			w.WriteHeader(http.StatusNotFound)
			_, _ = io.WriteString(w, `{"error":{"status":"NOT_FOUND","details":[{"errorCode":"UNREGISTERED"}]}}`)
			return
		}
		_, _ = io.WriteString(w, `{"name":"projects/arici-test/messages/1"}`)
	}))
	t.Cleanup(g.server.Close)
	return g
}

func (g *fakeGoogle) taken() []push {
	g.mu.Lock()
	defer g.mu.Unlock()
	out := g.sends
	g.sends = nil
	slices.SortFunc(out, func(a, b push) int { return strings.Compare(a.Token, b.Token) })
	return out
}

// testKey is a throwaway service account key, generated once.
var testKey = sync.OnceValue(func() *rsa.PrivateKey {
	k, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		panic(err)
	}
	return k
})

func fcmClient(t *testing.T, g *fakeGoogle) *fcm.Client {
	t.Helper()
	der, _ := x509.MarshalPKCS8PrivateKey(testKey())
	c, err := fcm.New(fcm.ServiceAccount{
		ClientEmail: "push@arici-test.iam.gserviceaccount.com",
		PrivateKey:  string(pem.EncodeToMemory(&pem.Block{Type: "PRIVATE KEY", Bytes: der})),
		ProjectID:   "arici-test",
	}, fcm.Options{TokenURL: g.server.URL + "/token", SendBaseURL: g.server.URL})
	if err != nil {
		t.Fatal(err)
	}
	return c
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

type fixture struct {
	app      *tests.TestApp
	google   *fakeGoogle
	notifier *notify.Notifier
	log      *lockedBuffer
	now      time.Time
	tokens   map[string]string
	seq      int
}

// newFixture builds the app; withFCM false leaves FCM_SERVICE_ACCOUNT_B64
// unset.
func newFixture(t *testing.T, withFCM bool) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	ids.Register(app)
	appsync.RegisterSeq(app)

	f := &fixture{
		app:    app,
		google: newFakeGoogle(t),
		log:    &lockedBuffer{},
		now:    time.Date(2026, 11, 10, 6, 0, 0, 0, time.UTC),
		tokens: map[string]string{},
	}
	opts := notify.Options{
		Logger: slog.New(slog.NewTextHandler(f.log, nil)),
		Now:    func() time.Time { return f.now },
	}
	if withFCM {
		opts.FCM = fcmClient(t, f.google)
	}
	f.notifier = notify.Register(app, opts)
	// The app's background sends end before its cleanup.
	t.Cleanup(f.notifier.Wait)

	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	locales := map[string]string{owner: "tr", partner: "en", worker: "es", removed: "tr", deOwner: "de", goneOwner: "tr", trAndDE: "pt"}
	for id, locale := range locales {
		u := core.NewRecord(users)
		u.Id = id
		u.SetEmail(id[:4] + "@test.local")
		u.SetPassword("1234567890")
		u.Set("locale", locale)
		if err := app.Save(u); err != nil {
			t.Fatal(err)
		}
		tok, err := u.NewAuthToken()
		if err != nil {
			t.Fatal(err)
		}
		f.tokens[id] = tok
	}

	org := func(id, country, deletedAt string) {
		f.save(t, "organizations", map[string]any{"id": id, "name": "İşletme", "country_code": country,
			"currency": "TRY", "operation_type": "migratory", "deleted_at": deletedAt})
	}
	org(orgTR, "TR", "")
	org(orgDE, "DE", "")
	org(orgGone, "TR", testTime)
	member := func(org, user, role, deletedAt string) {
		f.save(t, "memberships", map[string]any{"org_id": org, "user_id": user, "role": role, "deleted_at": deletedAt})
	}
	member(orgTR, owner, "owner", "")
	member(orgTR, partner, "partner", "")
	member(orgTR, worker, "worker", "")
	member(orgTR, removed, "partner", testTime)
	member(orgDE, deOwner, "owner", "")
	member(orgGone, goneOwner, "owner", "")
	member(orgDE, trAndDE, "partner", "")
	member(orgTR, trAndDE, "partner", "")

	// Phones. The worker's first phone speaks German (device locale); the
	// second has none and falls back to the user's Spanish.
	device := func(user, token, locale string) {
		f.save(t, "device_tokens", map[string]any{"user_id": user, "token": token, "platform": "android", "locale": locale})
	}
	device(owner, "owner-phone", "")
	device(partner, "partner-phone", "")
	device(worker, "worker-de", "de")
	device(worker, "worker-es", "")
	device(removed, "removed-phone", "")
	device(deOwner, "de-phone", "")
	device(goneOwner, "gone-phone", "")
	device(trAndDE, "both-phone", "")
	return f
}

func (f *fixture) save(t *testing.T, collection string, values map[string]any) *core.Record {
	t.Helper()
	c, err := f.app.FindCachedCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	if id, ok := values["id"].(string); ok {
		r.Id = id
	}
	if c.Fields.GetByName("created_at") != nil {
		r.Set("created_at", testTime)
		r.Set("updated_at", testTime)
	}
	for k, v := range values {
		if k != "id" {
			r.Set(k, v)
		}
	}
	if err := f.app.Save(r); err != nil {
		t.Fatalf("%s %v: %v", collection, values, err)
	}
	return r
}

// later is a K-5 time n seconds after testTime: LWW needs newer stamps.
func (f *fixture) later() string {
	f.seq++
	base, _ := time.Parse(time.RFC3339Nano, testTime)
	return base.Add(time.Duration(f.seq) * time.Second).UTC().Format("2006-01-02T15:04:05.000000Z")
}

// task is a push payload.
func (f *fixture) task(id string, extra map[string]any) map[string]any {
	stamp := f.later()
	p := map[string]any{
		"id": id, "org_id": orgTR, "title": "Kontrol", "due_at": stamp, "source": "manual",
		"assigned_to": nil, "completed_at": nil, "deleted_at": nil,
		"created_at": stamp, "updated_at": stamp,
	}
	for k, v := range extra {
		p[k] = v
	}
	return p
}

// push writes the tasks through the sync push as user, expects every change
// accepted and waits for the background sends.
func (f *fixture) push(t *testing.T, user string, payloads ...map[string]any) {
	t.Helper()
	for i, r := range f.pushResults(t, user, payloads...) {
		if r.Status != appsync.StatusOK {
			t.Fatalf("change %d: %+v", i+1, r)
		}
	}
}

// pushResults is push without the expectation.
func (f *fixture) pushResults(t *testing.T, user string, payloads ...map[string]any) []appsync.Result {
	t.Helper()
	var changes []json.RawMessage
	for i, p := range payloads {
		raw, _ := json.Marshal(map[string]any{"id": i + 1, "table": "tasks", "operation": "upsert", "payload": p})
		changes = append(changes, raw)
	}
	results, err := appsync.Push(f.app, user, changes)
	if err != nil {
		t.Fatal(err)
	}
	f.notifier.Wait()
	return results
}

func (f *fixture) tokenExists(t *testing.T, token string) bool {
	t.Helper()
	r, _ := f.app.FindFirstRecordByData("device_tokens", "token", token)
	return r != nil
}

func wantSends(t *testing.T, name string, got []push, want ...push) {
	t.Helper()
	if len(got) != len(want) {
		t.Fatalf("%s: %d sends %+v, want %d", name, len(got), got, len(want))
	}
	for i := range want {
		g, w := got[i], want[i]
		if g.Token != w.Token || g.Title != w.Title || g.Body != w.Body || !mapsEqual(g.Data, w.Data) {
			t.Errorf("%s: send %d\n got %+v\nwant %+v", name, i, g, w)
		}
	}
}

func mapsEqual(a, b map[string]string) bool {
	if len(a) != len(b) {
		return false
	}
	for k, v := range a {
		if b[k] != v {
			return false
		}
	}
	return true
}

func taskData(id string) map[string]string { return map[string]string{"type": "task", "task_id": id} }

func TestTaskAssignment(t *testing.T) {
	f := newFixture(t, true)
	const t1, t2, t3 = "a7000000-0000-0000-0000-000000000001", "a7000000-0000-0000-0000-000000000002", "a7000000-0000-0000-0000-000000000003"

	// The owner assigns the worker: both phones, each in its language.
	f.push(t, owner, f.task(t1, map[string]any{"assigned_to": worker, "title": "  Kat ekle "}))
	wantSends(t, "new task", f.google.taken(),
		push{"worker-de", "Neue Aufgabe für dich", "Kat ekle", taskData(t1)},
		push{"worker-es", "Tienes una tarea nueva", "Kat ekle", taskData(t1)},
	)

	// An untitled (automatic) task gets the general text.
	f.push(t, owner, f.task(t2, map[string]any{"assigned_to": partner, "title": nil, "source": "inspection",
		"source_id": "b0000000-0000-0000-0000-000000000001"}))
	wantSends(t, "untitled", f.google.taken(),
		push{"partner-phone", "New task for you", "A task was assigned to you.", taskData(t2)})

	// Same assignee, other fields changed: nothing.
	f.push(t, owner, f.task(t1, map[string]any{"assigned_to": worker, "title": "Kat ekle!"}))
	wantSends(t, "unchanged assignee", f.google.taken())

	// Reassigned: the new assignee.
	f.push(t, worker, f.task(t1, map[string]any{"assigned_to": owner}))
	wantSends(t, "reassigned", f.google.taken(),
		push{"owner-phone", "Sana yeni görev atandı", "Kontrol", taskData(t1)})

	// Unassigned, then assigned to oneself: nothing.
	f.push(t, owner, f.task(t1, map[string]any{"assigned_to": nil}))
	f.push(t, owner, f.task(t1, map[string]any{"assigned_to": owner}))
	f.push(t, worker, f.task(t3, map[string]any{"assigned_to": worker}))
	wantSends(t, "self or nobody", f.google.taken())

	// A completed or deleted task, or a removed member: nothing.
	f.push(t, owner,
		f.task("a7000000-0000-0000-0000-000000000004", map[string]any{"assigned_to": worker, "completed_at": f.later()}),
		f.task("a7000000-0000-0000-0000-000000000005", map[string]any{"assigned_to": worker, "deleted_at": f.later()}),
		f.task("a7000000-0000-0000-0000-000000000006", map[string]any{"assigned_to": removed}),
	)
	wantSends(t, "closed task or former member", f.google.taken())
}

// A change rejected after its save (missing reference) is rolled back to
// its savepoint; the hook still fires at commit, but no push goes out.
func TestRejectedChangeNotifiesNoOne(t *testing.T) {
	f := newFixture(t, true)
	const ok, bad = "a7000000-0000-0000-0000-000000000001", "a7000000-0000-0000-0000-000000000002"
	results := f.pushResults(t, owner,
		f.task(bad, map[string]any{"assigned_to": worker, "apiary_id": missingRef}),
		f.task(ok, map[string]any{"assigned_to": partner}),
	)
	if results[0].Status != appsync.StatusRejected || results[0].Reason != appsync.ReasonMissingReference || results[1].Status != appsync.StatusOK {
		t.Fatalf("results %+v", results)
	}
	wantSends(t, "rolled back", f.google.taken(),
		push{"partner-phone", "New task for you", "Kontrol", taskData(ok)})

	// A reassignment rolled back the same way leaves the stored assignee.
	f.pushResults(t, owner, f.task(ok, map[string]any{"assigned_to": worker, "apiary_id": missingRef}))
	wantSends(t, "rolled back update", f.google.taken())
}

// A task written another way (superuser, tool) has no actor: the assignee
// is notified.
func TestTaskWrittenOutsidePush(t *testing.T) {
	f := newFixture(t, true)
	f.save(t, "tasks", map[string]any{"id": "a7000000-0000-0000-0000-000000000001", "org_id": orgTR,
		"title": "Panel", "due_at": testTime, "source": "manual", "assigned_to": owner})
	f.notifier.Wait()
	wantSends(t, "panel", f.google.taken(),
		push{"owner-phone", "Sana yeni görev atandı", "Panel", taskData("a7000000-0000-0000-0000-000000000001")})
}

func TestInvalidTokenDeleted(t *testing.T) {
	f := newFixture(t, true)
	f.google.gone["worker-de"] = true
	f.push(t, owner, f.task("a7000000-0000-0000-0000-000000000001", map[string]any{"assigned_to": worker}))
	if got := len(f.google.taken()); got != 2 {
		t.Fatalf("%d sends", got)
	}
	if f.tokenExists(t, "worker-de") || !f.tokenExists(t, "worker-es") {
		t.Error("only the token FCM no longer knows is deleted")
	}
}

// Without FCM (env unset) or with Google down, the write is untouched.
func TestWriteUnaffectedByPush(t *testing.T) {
	for _, c := range []struct {
		name    string
		withFCM bool
	}{{"FCM env unset", false}, {"OAuth fails", true}} {
		t.Run(c.name, func(t *testing.T) {
			f := newFixture(t, c.withFCM)
			f.google.oauthFail.Store(true)
			const id = "a7000000-0000-0000-0000-000000000001"
			results := f.pushResults(t, owner, f.task(id, map[string]any{"assigned_to": worker}))
			if results[0].Status != appsync.StatusOK || results[0].Applied == nil || !*results[0].Applied {
				t.Fatalf("results %+v", results)
			}
			r, err := f.app.FindRecordById("tasks", id)
			if err != nil || r.GetString("assigned_to") != worker {
				t.Fatalf("task not stored: %v", err)
			}
			if got := f.google.taken(); len(got) != 0 {
				t.Errorf("sends %+v", got)
			}
			if c.withFCM && !strings.Contains(f.log.String(), "FCM authorization failed") {
				t.Errorf("log: %s", f.log.String())
			}
		})
	}
}

// ---------------------------------------------------------------------------
// Support periods
// ---------------------------------------------------------------------------

func (f *fixture) period(t *testing.T, id, name, starts, ends, deletedAt string) {
	t.Helper()
	f.save(t, "ref_support_periods", map[string]any{"id": id, "name": name,
		"application_starts_on": starts, "application_ends_on": ends, "deleted_at": deletedAt})
}

func TestSupportPeriods(t *testing.T) {
	f := newFixture(t, true)
	const (
		open     = "50000000-0000-0000-0000-000000000001"
		opensTod = "50000000-0000-0000-0000-000000000002"
		future   = "50000000-0000-0000-0000-000000000003"
		past     = "50000000-0000-0000-0000-000000000004"
		deleted  = "50000000-0000-0000-0000-000000000005"
		notified = "50000000-0000-0000-0000-000000000006"
	)
	// 22:30 UTC on 30 November is 1 December in Turkey.
	f.now = time.Date(2026, 11, 30, 22, 30, 0, 0, time.UTC)
	f.period(t, open, "Kovan başı destek", "2026-11-15", "2026-12-31", "")
	f.period(t, opensTod, "Ana arı desteği", "2026-12-01", "2027-01-05", "")
	f.period(t, future, "Gelecek", "2026-12-02", "2026-12-31", "")
	f.period(t, past, "Geçmiş", "2026-10-01", "2026-11-30", "")
	f.period(t, deleted, "Silinmiş", "2026-11-01", "2026-12-31", testTime)
	f.period(t, notified, "Bildirilmiş", "2026-11-01", "2026-12-31", "")
	f.save(t, "support_period_notifications", map[string]any{"period_id": notified, "notified_at": testTime})

	recipients, err := notify.SupportPeriodRecipients(f.app)
	if err != nil {
		t.Fatal(err)
	}
	if want := []string{owner, partner, trAndDE}; !slices.Equal(recipients, want) {
		t.Errorf("recipients %v, want %v (TR owners and partners only)", recipients, want)
	}

	n, err := f.notifier.NotifySupportPeriods(context.Background(), f.app)
	if err != nil || n != 2 {
		t.Fatalf("announced %d, %v", n, err)
	}
	data := func(id string) map[string]string { return map[string]string{"type": "support_period", "period_id": id} }
	wantSends(t, "first run", f.google.taken(),
		push{"both-phone", "A solicitação de subsídio está aberta", "Kovan başı destek · último dia 31/12/2026", data(open)},
		push{"both-phone", "A solicitação de subsídio está aberta", "Ana arı desteği · último dia 05/01/2027", data(opensTod)},
		push{"owner-phone", "Destek başvurusu açıldı", "Kovan başı destek · son gün 31.12.2026", data(open)},
		push{"owner-phone", "Destek başvurusu açıldı", "Ana arı desteği · son gün 05.01.2027", data(opensTod)},
		push{"partner-phone", "Support application is open", "Kovan başı destek · last day 31/12/2026", data(open)},
		push{"partner-phone", "Support application is open", "Ana arı desteği · last day 05/01/2027", data(opensTod)},
	)
	marks, _ := f.app.FindAllRecords("support_period_notifications")
	if len(marks) != 3 {
		t.Errorf("%d marks, want 3", len(marks))
	}

	// Once: the next day's run sends nothing.
	f.now = f.now.Add(24 * time.Hour)
	n, err = f.notifier.NotifySupportPeriods(context.Background(), f.app)
	if err != nil || n != 1 {
		t.Fatalf("second run %d, %v (only the period opening 2 December)", n, err)
	}
	for _, p := range f.google.taken() {
		if p.Data["period_id"] != future {
			t.Errorf("announced again: %+v", p)
		}
	}
	n, _ = f.notifier.NotifySupportPeriods(context.Background(), f.app)
	if n != 0 || len(f.google.taken()) != 0 {
		t.Errorf("third run announced %d", n)
	}
}

// Without FCM or without recipients nothing is marked: the period goes out
// on the first run that can send it.
func TestSupportPeriodsWait(t *testing.T) {
	f := newFixture(t, false)
	f.period(t, "50000000-0000-0000-0000-000000000001", "Destek", "2026-11-01", "2026-12-31", "")
	n, err := f.notifier.NotifySupportPeriods(context.Background(), f.app)
	if err != nil || n != 0 {
		t.Fatalf("FCM off: %d, %v", n, err)
	}
	if marks, _ := f.app.FindAllRecords("support_period_notifications"); len(marks) != 0 {
		t.Error("FCM off marks nothing")
	}

	g := newFixture(t, true)
	g.period(t, "50000000-0000-0000-0000-000000000001", "Destek", "2026-11-01", "2026-12-31", "")
	for _, m := range []string{"memberships"} {
		rows, _ := g.app.FindAllRecords(m)
		for _, r := range rows {
			if err := g.app.Delete(r); err != nil {
				t.Fatal(err)
			}
		}
	}
	n, err = g.notifier.NotifySupportPeriods(context.Background(), g.app)
	if err != nil || n != 0 {
		t.Fatalf("no recipients: %d, %v", n, err)
	}
	if marks, _ := g.app.FindAllRecords("support_period_notifications"); len(marks) != 0 {
		t.Error("no recipients marks nothing")
	}
}

func TestCronJobRegistered(t *testing.T) {
	f := newFixture(t, false)
	for _, j := range f.app.Cron().Jobs() {
		if j.Id() == notify.CronJob {
			if j.Expression() != "0 6 * * *" {
				t.Errorf("expression %q", j.Expression())
			}
			return
		}
	}
	t.Errorf("no %s job", notify.CronJob)
}

// ---------------------------------------------------------------------------
// Device token route
// ---------------------------------------------------------------------------

func (f *fixture) call(t *testing.T, user, body string, wantStatus int, wantContent ...string) {
	t.Helper()
	headers := map[string]string{"Content-Type": "application/json"}
	if user != "" {
		headers["Authorization"] = f.tokens[user]
	}
	if wantContent == nil {
		wantContent = []string{""}
	}
	s := tests.ApiScenario{
		Name:                  "POST " + notify.Route + " " + body,
		Method:                http.MethodPost,
		URL:                   notify.Route,
		Body:                  strings.NewReader(body),
		Headers:               headers,
		ExpectedStatus:        wantStatus,
		ExpectedContent:       wantContent,
		TestAppFactory:        func(testing.TB) *tests.TestApp { return f.app },
		DisableTestAppCleanup: true,
	}
	s.Test(t)
}

func (f *fixture) device(t *testing.T, token string) *core.Record {
	t.Helper()
	r, err := f.app.FindFirstRecordByData("device_tokens", "token", token)
	if err != nil {
		return nil
	}
	return r
}

func TestDeviceTokenRoute(t *testing.T) {
	// The route works without FCM: tokens wait for the variable.
	f := newFixture(t, false)

	f.call(t, worker, `{"action":"register","token":"new-phone","platform":"ios","locale":"de-DE"}`, 200, `{"ok":true}`)
	r := f.device(t, "new-phone")
	if r == nil || r.GetString("user_id") != worker || r.GetString("platform") != "ios" || r.GetString("locale") != "de" ||
		r.GetString("created_at") != "2026-11-10T06:00:00.000000Z" {
		t.Fatalf("stored %v", r)
	}

	// Another user signs in on the phone: the token moves; no locale keeps
	// the device's.
	f.now = f.now.Add(time.Hour)
	f.call(t, owner, `{"action":"register","token":"new-phone","platform":"android"}`, 200, `{"ok":true}`)
	r = f.device(t, "new-phone")
	if r.GetString("user_id") != owner || r.GetString("platform") != "android" || r.GetString("locale") != "de" ||
		r.GetString("created_at") != "2026-11-10T06:00:00.000000Z" || r.GetString("updated_at") != "2026-11-10T07:00:00.000000Z" {
		t.Errorf("moved %v", r)
	}
	rows, _ := f.app.FindAllRecords("device_tokens")
	if len(rows) != 9 {
		t.Errorf("%d tokens; the token is unique", len(rows))
	}

	// An unsupported language is stored empty (users.locale is used).
	f.call(t, owner, `{"action":"register","token":"new-phone","platform":"android","locale":"it"}`, 200)
	if l := f.device(t, "new-phone").GetString("locale"); l != "" {
		t.Errorf("locale %q", l)
	}

	// Unregister removes only the caller's token.
	f.call(t, worker, `{"action":"unregister","token":"new-phone"}`, 200, `{"ok":true}`)
	if f.device(t, "new-phone") == nil {
		t.Error("another user's token is kept")
	}
	f.call(t, owner, `{"action":"unregister","token":"new-phone"}`, 200, `{"ok":true}`)
	if f.device(t, "new-phone") != nil {
		t.Error("own token removed")
	}

	long := strings.Repeat("x", 4097)
	for _, body := range []string{
		`{"action":"register","platform":"android"}`,
		`{"action":"register","token":"","platform":"android"}`,
		`{"action":"register","token":"` + long + `","platform":"android"}`,
		`{"action":"register","token":"t","platform":"web"}`,
		`{"action":"register","token":"t"}`,
		`{"action":"forget","token":"t"}`,
		`{"token":"t","platform":"android"}`,
		`{"action":"register","token":5,"platform":"android"}`,
		`not json`,
	} {
		f.call(t, owner, body, 400, `"code":"bad_request"`)
	}
	f.call(t, "", `{"action":"register","token":"t","platform":"android"}`, 401)
	if f.device(t, "t") != nil {
		t.Error("a refused request wrote a token")
	}
}
