package loadtest_test

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/loadtest"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/orgs"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const (
	suEmail    = "root@example.com"
	suPassword = "superuser-password-1"
)

// server is the real app (bootstrap.Register with env) behind an HTTP
// server, with one superuser.
type server struct {
	app *tests.TestApp
	url string
}

func newServer(t *testing.T, env string) *server {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: env}, "test-version")

	sus, err := app.FindCollectionByNameOrId(core.CollectionNameSuperusers)
	if err != nil {
		t.Fatal(err)
	}
	su := core.NewRecord(sus)
	su.SetEmail(suEmail)
	su.SetPassword(suPassword)
	if err := app.Save(su); err != nil {
		t.Fatal(err)
	}

	router, err := apis.NewRouter(app)
	if err != nil {
		t.Fatal(err)
	}
	var handler http.Handler
	err = app.OnServe().Trigger(&core.ServeEvent{App: app, Router: router}, func(e *core.ServeEvent) error {
		mux, err := e.Router.BuildMux()
		handler = mux
		return err
	})
	if err != nil {
		t.Fatal(err)
	}
	hs := httptest.NewServer(handler)
	t.Cleanup(hs.Close)
	return &server{app: app, url: hs.URL}
}

func (s *server) config() loadtest.Config {
	return loadtest.Config{URL: s.url, SuperuserEmail: suEmail, SuperuserPassword: suPassword}
}

// user opens an ordinary account (not a load test one).
func (s *server) user(t *testing.T, email string) *core.Record {
	t.Helper()
	users, err := s.app.FindCollectionByNameOrId(auth.UsersCollection)
	if err != nil {
		t.Fatal(err)
	}
	u := core.NewRecord(users)
	u.SetEmail(email)
	u.SetPassword("password-123456")
	u.SetVerified(true)
	if err := s.app.Save(u); err != nil {
		t.Fatal(err)
	}
	return u
}

func (s *server) org(t *testing.T, owner *core.Record) string {
	t.Helper()
	id := ids.New()
	name, country, currency := "Org "+owner.Email(), "TR", "TRY"
	req := orgs.Request{ID: id, Name: &name, CountryCode: &country, Currency: &currency}
	if _, err := orgs.Create(s.app, owner.Id, req); err != nil {
		t.Fatal(err)
	}
	return id
}

func (s *server) count(t *testing.T, collection string, where dbx.Expression) int {
	t.Helper()
	var n int
	q := s.app.DB().Select("count(*)").From(collection)
	if where != nil {
		q = q.Where(where)
	}
	if err := q.Row(&n); err != nil {
		t.Fatal(err)
	}
	return n
}

func (s *server) rateLimits(t *testing.T, on bool) {
	t.Helper()
	settings := s.app.Settings()
	settings.RateLimits.Enabled = on
	if err := s.app.Save(settings); err != nil {
		t.Fatal(err)
	}
}

func TestRunEndToEnd(t *testing.T) {
	s := newServer(t, config.EnvDev)
	s.rateLimits(t, true)
	bystander := s.user(t, "arici@example.com")
	bystanderOrg := s.org(t, bystander)

	cfg := s.config()
	cfg.Accounts, cfg.Records, cfg.Concurrency = 3, 250, 2
	cfg.PageSize, cfg.FileEvery, cfg.FileBytes = 100, 1, 4096
	var log strings.Builder
	cfg.Log = &log

	rep, err := loadtest.Run(context.Background(), cfg)
	if err != nil {
		t.Fatalf("Run: %v\n%s", err, log.String())
	}
	if rep.Failed != 0 || rep.RowsRejected != 0 || len(rep.ErrorSamples) != 0 {
		t.Fatalf("errors in the run: failed %d, rejected %d: %v", rep.Failed, rep.RowsRejected, rep.ErrorSamples)
	}
	if rep.RowsPushed != 3*250 {
		t.Errorf("rows pushed = %d, want 750", rep.RowsPushed)
	}
	// 250 rows: 3 packets of 100, 100, 50; a file after each.
	if rep.Files != 9 || rep.Ops[loadtest.OpUpload].Count != 9 {
		t.Errorf("files = %d (ops %d), want 9", rep.Files, rep.Ops[loadtest.OpUpload].Count)
	}
	if got := rep.Ops[loadtest.OpPush].Count; got != 9 {
		t.Errorf("push requests = %d, want 9", got)
	}
	if got := rep.Ops[loadtest.OpCreateOrg].Count; got != 3 {
		t.Errorf("organizations = %d, want 3", got)
	}
	if got := rep.Ops[loadtest.OpFullPull].Count; got != 3 {
		t.Errorf("full pulls = %d, want 3", got)
	}
	// Each account pulls its own 250 rows, its organization and
	// membership, and the reference rows; never the bystander's.
	refs := s.count(t, "ref_drugs", nil) + s.count(t, "ref_support_periods", nil)
	if want := 3 * (250 + 2 + refs); rep.RowsPulled != want {
		t.Errorf("rows pulled = %d, want %d", rep.RowsPulled, want)
	}
	if rep.Requests == 0 || rep.ErrorRate != 0 || rep.Ops[loadtest.OpPush].P95Ms <= 0 {
		t.Errorf("report numbers: %+v", rep)
	}
	if rep.Version != "test-version" || !rep.RateLimitsOff {
		t.Errorf("version %q, rate limits off %v", rep.Version, rep.RateLimitsOff)
	}

	// Cleaned up: accounts, organizations, rows and files gone.
	if rep.Cleanup == nil || rep.Cleanup.Users != 3 || rep.Cleanup.Organizations != 3 || rep.CleanupError != "" {
		t.Fatalf("cleanup = %+v, error %q", rep.Cleanup, rep.CleanupError)
	}
	if n := s.count(t, auth.UsersCollection, dbx.Like("email", "loadtest-")); n != 0 {
		t.Errorf("%d load test accounts left", n)
	}
	for _, c := range []string{"apiaries", "hives", "hive_location_history", "inspections", "media_files", "memberships"} {
		if n := s.count(t, c, dbx.Not(dbx.HashExp{"org_id": bystanderOrg})); n != 0 {
			t.Errorf("%d rows left in %s", n, c)
		}
	}
	if n := s.count(t, "organizations", nil); n != 1 {
		t.Errorf("%d organizations, want only the bystander's", n)
	}
	if n := s.count(t, "memberships", dbx.HashExp{"org_id": bystanderOrg, "deleted_at": ""}); n != 1 {
		t.Errorf("bystander membership touched: %d live", n)
	}
	if !s.app.Settings().RateLimits.Enabled {
		t.Error("the rate limiter was not turned back on")
	}
	if !strings.Contains(log.String(), "cleaning up") {
		t.Errorf("log: %s", log.String())
	}
	var out strings.Builder
	rep.Write(&out)
	for _, want := range []string{"push", "p95 ms", "Cleanup: 3 organizations, 3 accounts removed"} {
		if !strings.Contains(out.String(), want) {
			t.Errorf("report lacks %q:\n%s", want, out.String())
		}
	}
}

func TestRunLeavesTheLimiterOffWhenItWasOff(t *testing.T) {
	s := newServer(t, config.EnvDev)
	s.rateLimits(t, false)
	cfg := s.config()
	cfg.Accounts, cfg.Records, cfg.FileEvery = 1, 10, 100
	rep, err := loadtest.Run(context.Background(), cfg)
	if err != nil || rep.Failed != 0 {
		t.Fatalf("Run: %v %+v", err, rep)
	}
	if rep.RateLimitsOff || s.app.Settings().RateLimits.Enabled {
		t.Error("the limiter was off before; it must stay so and not be reported as turned off")
	}
}

func TestRunRefusesServersOtherThanDev(t *testing.T) {
	for _, env := range []string{config.EnvProd, ""} {
		t.Run("env="+env, func(t *testing.T) {
			s := newServer(t, env)
			rep, err := loadtest.Run(context.Background(), s.config())
			if !errors.Is(err, loadtest.ErrServerEnv) || rep != nil {
				t.Fatalf("Run = %v, %v; want ErrServerEnv", rep, err)
			}
			if n := s.count(t, auth.UsersCollection, nil); n != 0 {
				t.Errorf("%d accounts opened on a %q server", n, env)
			}
			if _, err := loadtest.Cleanup(context.Background(), s.config(), ""); !errors.Is(err, loadtest.ErrServerEnv) {
				t.Errorf("Cleanup = %v; want ErrServerEnv", err)
			}
		})
	}
}

func TestRunRefusesTheProductionHost(t *testing.T) {
	for _, u := range []string{
		"https://arici-api.tutunsoft.com",
		"https://ARICI-API.tutunsoft.com/",
		"http://arici-api.tutunsoft.com:443",
	} {
		cfg := loadtest.Config{URL: u, SuperuserEmail: suEmail, SuperuserPassword: suPassword,
			HTTP: &http.Client{Transport: failTransport{t}}}
		if _, err := loadtest.Run(context.Background(), cfg); !errors.Is(err, loadtest.ErrProd) {
			t.Errorf("%s: %v; want ErrProd", u, err)
		}
		if _, err := loadtest.Cleanup(context.Background(), cfg, ""); !errors.Is(err, loadtest.ErrProd) {
			t.Errorf("cleanup %s: %v; want ErrProd", u, err)
		}
	}
	for _, u := range []string{"arici-api-dev.tutunsoft.com", "ftp://x", "https://x/api", "https://x?a=1", "https://u:p@x"} {
		cfg := loadtest.Config{URL: u, SuperuserEmail: suEmail, SuperuserPassword: suPassword,
			HTTP: &http.Client{Transport: failTransport{t}}}
		if _, err := loadtest.Run(context.Background(), cfg); !errors.Is(err, loadtest.ErrBadURL) {
			t.Errorf("%s: %v; want ErrBadURL", u, err)
		}
	}
}

// failTransport fails the test on any request: refusals send nothing.
type failTransport struct{ t *testing.T }

func (f failTransport) RoundTrip(r *http.Request) (*http.Response, error) {
	f.t.Errorf("unexpected request %s %s", r.Method, r.URL)
	return nil, errors.New("no requests expected")
}

func TestRunNeedsTheSecretsAndTheRoute(t *testing.T) {
	s := newServer(t, config.EnvDev)
	cfg := s.config()
	cfg.SuperuserPassword = ""
	if _, err := loadtest.Run(context.Background(), cfg); !errors.Is(err, loadtest.ErrNoSecrets) {
		t.Errorf("no password: %v", err)
	}
	cfg = s.config()
	cfg.SuperuserPassword = "wrong-password-0"
	_, err := loadtest.Run(context.Background(), cfg)
	if err == nil || strings.Contains(err.Error(), suEmail) || strings.Contains(err.Error(), "wrong-password-0") {
		t.Errorf("wrong password: %v (must fail without echoing secrets)", err)
	}

	// A dev server of an older version: no cleanup route, so nothing is
	// opened.
	old := http.NewServeMux()
	var created bool
	old.HandleFunc("GET /api/app/info", func(w http.ResponseWriter, _ *http.Request) {
		_ = json.NewEncoder(w).Encode(map[string]string{"env": "dev", "version": "old"})
	})
	old.HandleFunc("POST /api/collections/_superusers/auth-with-password", func(w http.ResponseWriter, _ *http.Request) {
		_ = json.NewEncoder(w).Encode(map[string]string{"token": "t"})
	})
	old.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if strings.Contains(r.URL.Path, "/records") || strings.Contains(r.URL.Path, "/settings") {
			created = true
		}
		http.NotFound(w, r)
	})
	hs := httptest.NewServer(old)
	defer hs.Close()
	cfg = loadtest.Config{URL: hs.URL, SuperuserEmail: suEmail, SuperuserPassword: suPassword}
	if _, err := loadtest.Run(context.Background(), cfg); !errors.Is(err, loadtest.ErrNoCleanup) {
		t.Errorf("old server: %v; want ErrNoCleanup", err)
	}
	if created {
		t.Error("the tool wrote to a server without the cleanup route")
	}
}

func TestCleanupRouteOnlyOnDevForSuperusers(t *testing.T) {
	body := strings.NewReader(`{"run":""}`)
	scenarios := []tests.ApiScenario{
		{
			Name:            "prod: no route",
			Method:          http.MethodPost,
			URL:             loadtest.CleanupRoute,
			Body:            body,
			Headers:         map[string]string{},
			ExpectedStatus:  http.StatusNotFound,
			ExpectedContent: []string{`"status":404`},
			TestAppFactory:  appWithEnv(config.EnvProd),
		},
		{
			Name:            "dev: anonymous",
			Method:          http.MethodPost,
			URL:             loadtest.CleanupRoute,
			Body:            strings.NewReader(`{"run":""}`),
			ExpectedStatus:  http.StatusUnauthorized,
			ExpectedContent: []string{`"status":401`},
			TestAppFactory:  appWithEnv(config.EnvDev),
		},
	}
	for _, sc := range scenarios {
		sc.Test(t)
	}

	// A signed-in app user is not a superuser.
	s := newServer(t, config.EnvDev)
	u := s.user(t, loadtest.Email("r1", 1))
	token, err := u.NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}
	req, _ := http.NewRequest(http.MethodPost, s.url+loadtest.CleanupRoute, strings.NewReader(`{"run":""}`))
	req.Header.Set("Authorization", token)
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		t.Fatal(err)
	}
	res.Body.Close()
	if res.StatusCode != http.StatusForbidden {
		t.Errorf("app user: HTTP %d, want 403", res.StatusCode)
	}
	if n := s.count(t, auth.UsersCollection, nil); n != 1 {
		t.Errorf("the app user's call removed accounts")
	}
}

func appWithEnv(env string) func(t testing.TB) *tests.TestApp {
	return func(t testing.TB) *tests.TestApp {
		app, err := tests.NewTestApp(t.TempDir())
		if err != nil {
			t.Fatal(err)
		}
		bootstrap.Register(app, config.Config{Env: env}, "test")
		return app
	}
}

func TestRemoveRunScope(t *testing.T) {
	s := newServer(t, config.EnvDev)
	mine1 := s.user(t, loadtest.Email("20261113120000-aaaaaa", 1))
	mine2 := s.user(t, loadtest.Email("20261113120000-aaaaaa", 2))
	other := s.user(t, loadtest.Email("20261113130000-bbbbbb", 1))
	lookalike := s.user(t, "loadtest-20261113120000-aaaaaa-3@example.org")
	person := s.user(t, "arici@example.com")

	org1 := s.org(t, mine1)
	org2 := s.org(t, mine2)
	orgOther := s.org(t, other)
	orgLookalike := s.org(t, lookalike)
	// mine2's organization has a real member too: it must stay, and so
	// must its founder.
	addMember(t, s.app, org2, person.Id)

	if _, err := loadtest.RemoveRun(s.app, config.EnvProd, "20261113120000-aaaaaa"); !errors.Is(err, loadtest.ErrNotDev) {
		t.Fatalf("prod: %v", err)
	}
	res, err := loadtest.RemoveRun(s.app, config.EnvDev, "20261113120000-aaaaaa")
	if err != nil {
		t.Fatal(err)
	}
	if res.Organizations != 1 || res.Users != 1 {
		t.Errorf("result %+v, want 1 organization and 1 user", res)
	}
	exists := func(collection, id string) bool {
		_, err := s.app.FindRecordById(collection, id)
		return err == nil
	}
	if exists("organizations", org1) || exists(auth.UsersCollection, mine1.Id) {
		t.Error("the run's own organization and account must go")
	}
	for _, kept := range []struct{ c, id string }{
		{"organizations", org2}, {auth.UsersCollection, mine2.Id},
		{"organizations", orgOther}, {auth.UsersCollection, other.Id},
		{"organizations", orgLookalike}, {auth.UsersCollection, lookalike.Id},
		{auth.UsersCollection, person.Id},
	} {
		if !exists(kept.c, kept.id) {
			t.Errorf("%s %s removed", kept.c, kept.id)
		}
	}

	// Every run: the other run's account goes, the shared organization
	// and the look-alike stay.
	res, err = loadtest.RemoveRun(s.app, config.EnvDev, "")
	if err != nil {
		t.Fatal(err)
	}
	if res.Organizations != 1 || res.Users != 1 || exists("organizations", orgOther) || !exists("organizations", org2) {
		t.Errorf("all runs: %+v", res)
	}
}

func addMember(t *testing.T, app core.App, orgID, userID string) {
	t.Helper()
	c, err := app.FindCollectionByNameOrId("memberships")
	if err != nil {
		t.Fatal(err)
	}
	m := core.NewRecord(c)
	m.Set("org_id", orgID)
	m.Set("user_id", userID)
	m.Set("role", "worker")
	m.Set("created_at", "2026-11-13T10:00:00.000000Z")
	m.Set("updated_at", "2026-11-13T10:00:00.000000Z")
	if err := app.Save(m); err != nil {
		t.Fatal(err)
	}
}
