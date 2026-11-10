package deletion

import (
	"errors"
	"net/http"
	"strings"
	"testing"
	"time"

	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/types"
)

const (
	testLogID   = "0195f2a4-dede-7000-8000-000000000001"
	testRequest = "0195f2a4-dfdf-7000-8000-000000000001"
	testHash    = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
)

func newApp(t testing.TB) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	RegisterLogGuard(app)
	return app
}

// addLog saves a deletion record created `age` ago. The creation time is
// written with SQL, which skips the record hooks, like rows that have aged
// in place.
func addLog(t testing.TB, app core.App, age time.Duration) *core.Record {
	t.Helper()
	c, err := app.FindCollectionByNameOrId(LogCollection)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = testLogID
	r.Set("request_id", testRequest)
	r.Set("user_hash", testHash)
	r.Set("kind", "hesap")
	r.Set("channel", "uygulama")
	r.Set("requested_at", "2026-11-03T10:15:30.123456Z")
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	created, err := types.ParseDateTime(time.Now().Add(-age))
	if err != nil {
		t.Fatal(err)
	}
	if _, err := app.DB().Update(LogCollection, dbx.Params{"created": created.String()}, dbx.HashExp{"id": r.Id}).Execute(); err != nil {
		t.Fatal(err)
	}
	stored, err := app.FindRecordById(LogCollection, r.Id)
	if err != nil {
		t.Fatal(err)
	}
	return stored
}

func exists(t testing.TB, app core.App) bool {
	t.Helper()
	_, err := app.FindRecordById(LogCollection, testLogID)
	return err == nil
}

const year = 365 * 24 * time.Hour

func TestLogCannotBeUpdated(t *testing.T) {
	app := newApp(t)
	defer app.Cleanup()

	// Even a record past its retention stays as it is.
	for _, age := range []time.Duration{0, 4 * year} {
		r := addLog(t, app, age)
		r.Set("kind", "hesap_ve_isletme")
		if err := app.Save(r); !errors.Is(err, ErrLogImmutable) {
			t.Errorf("age %v: update err = %v, want ErrLogImmutable", age, err)
		}
		stored, err := app.FindRecordById(LogCollection, testLogID)
		if err != nil || stored.GetString("kind") != "hesap" {
			t.Errorf("age %v: record changed: %v %v", age, stored, err)
		}
		if _, err := app.DB().Delete(LogCollection, dbx.HashExp{"id": testLogID}).Execute(); err != nil {
			t.Fatal(err)
		}
	}
}

func TestLogKeptThreeYears(t *testing.T) {
	cases := []struct {
		name    string
		age     time.Duration
		deleted bool
	}{
		{"new", 0, false},
		{"one year", year, false},
		{"a minute short of three years", 3*year + 24*time.Hour - time.Minute, false},
		{"three years and a day", 3*year + 2*24*time.Hour, true},
		{"ten years", 10 * year, true},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			app := newApp(t)
			defer app.Cleanup()
			r := addLog(t, app, tc.age)
			err := app.Delete(r)
			if tc.deleted {
				if err != nil || exists(t, app) {
					t.Errorf("delete err = %v, exists = %v; want deleted", err, exists(t, app))
				}
				return
			}
			if !errors.Is(err, ErrLogRetained) || !exists(t, app) {
				t.Errorf("delete err = %v, exists = %v; want ErrLogRetained", err, exists(t, app))
			}
		})
	}
}

// The boundary, with the clock fixed: allowed exactly when created is at or
// before now - 3 years (Postgres: rejected while completed_at > now() -
// interval '3 years').
func TestLogRetentionBoundary(t *testing.T) {
	app := newApp(t)
	defer app.Cleanup()
	r := addLog(t, app, 0)
	created := r.GetDateTime("created").Time()

	defer func(old func() time.Time) { now = old }(now)
	now = func() time.Time { return yearsBefore(created, -3).Add(-time.Millisecond) }
	if err := app.Delete(r); !errors.Is(err, ErrLogRetained) {
		t.Errorf("1 ms before: err = %v, want ErrLogRetained", err)
	}
	now = func() time.Time { return yearsBefore(created, -3) }
	if err := app.Delete(r); err != nil || exists(t, app) {
		t.Errorf("at 3 years: err = %v, exists = %v", err, exists(t, app))
	}
}

// The guard reads the stored creation time; a caller's edited copy of the
// record does not get it deleted.
func TestLogGuardIgnoresCallerCopy(t *testing.T) {
	app := newApp(t)
	defer app.Cleanup()
	r := addLog(t, app, 0)
	r.SetRaw("created", types.NowDateTime().AddDate(-10, 0, 0))
	if err := app.Delete(r); !errors.Is(err, ErrLogRetained) || !exists(t, app) {
		t.Errorf("err = %v, exists = %v", err, exists(t, app))
	}
}

// Superusers bypass API rules, not the guard.
func TestLogGuardHoldsForSuperusers(t *testing.T) {
	url := "/api/collections/deletion_log/records/" + testLogID

	cases := []struct {
		name    string
		method  string
		body    string
		age     time.Duration
		status  int
		deleted bool
	}{
		{"update rejected", http.MethodPatch, `{"kind":"hesap_ve_isletme"}`, 4 * year, http.StatusBadRequest, false},
		{"young delete rejected", http.MethodDelete, "", year, http.StatusBadRequest, false},
		{"old delete allowed", http.MethodDelete, "", 4 * year, http.StatusNoContent, true},
	}
	for _, c := range cases {
		headers := map[string]string{}
		s := tests.ApiScenario{
			Name:           c.name,
			Method:         c.method,
			URL:            url,
			Body:           strings.NewReader(c.body),
			Headers:        headers,
			ExpectedStatus: c.status,
			ExpectedContent: map[bool][]string{
				true:  {""},
				false: {`"status":400`},
			}[c.deleted],
			TestAppFactory: func(t testing.TB) *tests.TestApp {
				app := newApp(t)
				addLog(t, app, c.age)
				su := core.NewRecord(mustCollection(t, app, core.CollectionNameSuperusers))
				su.SetEmail("admin@example.com")
				su.SetPassword("1234567890123")
				if err := app.Save(su); err != nil {
					t.Fatal(err)
				}
				tok, err := su.NewAuthToken()
				if err != nil {
					t.Fatal(err)
				}
				// Read when the request is built, after the factory.
				headers["Authorization"] = tok
				return app
			},
			AfterTestFunc: func(t testing.TB, app *tests.TestApp, _ *http.Response) {
				if got := exists(t, app); got == c.deleted {
					t.Errorf("exists = %v after %s", got, c.name)
				}
				if !c.deleted {
					stored, _ := app.FindRecordById(LogCollection, testLogID)
					if stored == nil || stored.GetString("kind") != "hesap" {
						t.Error("record changed")
					}
				}
			},
		}
		s.Test(t)
	}
}

func mustCollection(t testing.TB, app core.App, name string) *core.Collection {
	t.Helper()
	c, err := app.FindCollectionByNameOrId(name)
	if err != nil {
		t.Fatal(err)
	}
	return c
}

func TestYearsBefore(t *testing.T) {
	cases := map[string]string{
		"2026-11-10T10:15:30Z": "2023-11-10T10:15:30Z",
		"2028-02-29T12:00:00Z": "2025-02-28T12:00:00Z",
		"2027-03-01T00:00:00Z": "2024-03-01T00:00:00Z",
	}
	for in, want := range cases {
		tm, _ := time.Parse(time.RFC3339, in)
		if got := yearsBefore(tm, 3).Format(time.RFC3339); got != want {
			t.Errorf("yearsBefore(%s, 3) = %s, want %s", in, got, want)
		}
	}
}
