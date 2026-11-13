package orgs_test

import (
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/bootstrap"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/orgs"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/google/uuid"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// Users and ids of supabase/tests/database/create_organization.test.sql.
const (
	founder = "11111111-1111-1111-1111-111111111111"
	other   = "22222222-2222-2222-2222-222222222222"
	orgD    = "dddddddd-dddd-dddd-dddd-dddddddddddd"
	orgE    = "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"
)

type fixture struct {
	app    *tests.TestApp
	tokens map[string]string
}

func newFixture(t *testing.T) *fixture {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	bootstrap.Register(app, config.Config{Env: config.EnvDev}, "test")

	f := &fixture{app: app, tokens: map[string]string{}}
	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	for i, id := range []string{founder, other} {
		u := core.NewRecord(users)
		u.Id = id
		u.SetEmail([]string{"owner@test.local", "other@test.local"}[i])
		u.SetPassword("1234567890")
		if err := app.Save(u); err != nil {
			t.Fatal(err)
		}
		tok, err := u.NewAuthToken()
		if err != nil {
			t.Fatal(err)
		}
		f.tokens[id] = tok
	}
	return f
}

type response struct {
	status int
	body   []byte
}

func (r response) object(t *testing.T) map[string]any {
	t.Helper()
	var out map[string]any
	if err := json.Unmarshal(r.body, &out); err != nil {
		t.Fatalf("body %s: %v", r.body, err)
	}
	return out
}

func (r response) errorCode(t *testing.T) string {
	t.Helper()
	data, _ := r.object(t)["data"].(map[string]any)
	code, _ := data["code"].(string)
	return code
}

func (f *fixture) call(t *testing.T, method, url, user string, body any, wantStatus int) response {
	t.Helper()
	headers := map[string]string{"Content-Type": "application/json"}
	if user != "" {
		headers["Authorization"] = f.tokens[user]
	}
	var reader io.Reader
	if body != nil {
		raw, ok := body.(string)
		if !ok {
			b, err := json.Marshal(body)
			if err != nil {
				t.Fatal(err)
			}
			raw = string(b)
		}
		reader = strings.NewReader(raw)
	}
	var out response
	s := tests.ApiScenario{
		Name:                  method + " " + url,
		Method:                method,
		URL:                   url,
		Body:                  reader,
		Headers:               headers,
		ExpectedStatus:        wantStatus,
		ExpectedContent:       []string{""},
		TestAppFactory:        func(testing.TB) *tests.TestApp { return f.app },
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

func (f *fixture) create(t *testing.T, user string, body map[string]any, wantStatus int) response {
	t.Helper()
	return f.call(t, http.MethodPost, orgs.CreateRoute, user, body, wantStatus)
}

func (f *fixture) mine(t *testing.T, user string) map[string]any {
	t.Helper()
	r := f.call(t, http.MethodGet, orgs.MineRoute, user, nil, http.StatusOK)
	if string(r.body) == "null" {
		return nil
	}
	return r.object(t)
}

func orgBody(id, name, country, currency string, extra map[string]any) map[string]any {
	b := map[string]any{"id": id, "name": name, "country_code": country, "currency": currency}
	for k, v := range extra {
		b[k] = v
	}
	return b
}

func (f *fixture) memberships(t *testing.T, org string) []*core.Record {
	t.Helper()
	rows, err := f.app.FindAllRecords("memberships", dbx.HashExp{"org_id": org})
	if err != nil {
		t.Fatal(err)
	}
	return rows
}

func (f *fixture) count(t *testing.T, collection string) int64 {
	t.Helper()
	n, err := f.app.CountRecords(collection)
	if err != nil {
		t.Fatal(err)
	}
	return n
}

// TestCreateOrganization_create_organization_test_sql carries every
// scenario of supabase/tests/database/create_organization.test.sql, in its
// order.
func TestCreateOrganization_create_organization_test_sql(t *testing.T) {
	f := newFixture(t)

	// anon işletme oluşturamaz
	f.create(t, "", orgBody(orgD, "Sahte", "TR", "TRY", nil), http.StatusUnauthorized)
	if n := f.count(t, "organizations"); n != 0 {
		t.Fatalf("anon wrote %d organizations", n)
	}

	// işletmeyi çağıranın adına oluşturur, adı kırpar ve satırı döner
	row := f.create(t, founder, orgBody(orgD, "  Yeni İşletme ", "DE", "EUR",
		map[string]any{"hive_count_range": "up_to_50"}), http.StatusOK).object(t)
	for k, want := range map[string]any{
		"id": orgD, "name": "Yeni İşletme", "country_code": "DE", "currency": "EUR",
		"hive_count_range": "up_to_50", "created_by": founder,
		"operation_type": orgs.DefaultOperationType, "deleted_at": nil,
	} {
		if row[k] != want {
			t.Errorf("row[%s] = %v, want %v", k, row[k], want)
		}
	}
	for _, k := range []string{"created_at", "updated_at"} {
		if s, _ := row[k].(string); !pattern.IsTimestamp(s) {
			t.Errorf("row[%s] = %v, want a K-5 time", k, row[k])
		}
	}

	// oluşturan owner olur
	ms := f.memberships(t, orgD)
	if len(ms) != 1 || ms[0].GetString("user_id") != founder || ms[0].GetString("role") != "owner" {
		t.Fatalf("memberships = %v, want one owner %s", ms, founder)
	}
	m := ms[0]
	if v := uuid.MustParse(m.Id).Version(); v != 7 {
		t.Errorf("membership id %s is UUIDv%d, want v7", m.Id, v)
	}
	if m.GetString("created_by") != founder || m.GetString("deleted_at") != "" ||
		m.GetString("created_at") != row["created_at"] {
		t.Errorf("membership = %v", m.PublicExport())
	}

	// oluşturan işletmeyi hemen görür
	if got := f.mine(t, founder); got["id"] != orgD {
		t.Fatalf("mine = %v, want %s", got, orgD)
	}

	// işletme server_seq alır (üyelik de: diğer cihazlara iner)
	if seq, _ := row["server_seq"].(float64); seq <= 0 {
		t.Errorf("server_seq = %v, want > 0", row["server_seq"])
	}
	if m.GetInt("server_seq") <= 0 {
		t.Errorf("membership server_seq = %d", m.GetInt("server_seq"))
	}

	// aynı kimlikle yeniden çağrı mevcut işletmeyi döner
	again := f.create(t, founder, orgBody(orgD, "Başka ad", "TR", "TRY", nil), http.StatusOK).object(t)
	if again["id"] != orgD || again["name"] != "Yeni İşletme" || again["server_seq"] != row["server_seq"] {
		t.Errorf("again = %v", again)
	}

	// yeniden çağrı ikinci owner üyeliği açmaz
	if n := len(f.memberships(t, orgD)); n != 1 {
		t.Errorf("%d memberships after the retry", n)
	}

	// boş ad reddedilir
	r := f.create(t, founder, orgBody(orgE, "   ", "TR", "TRY", nil), http.StatusBadRequest)
	if c := r.errorCode(t); c != orgs.CodeInvalid {
		t.Errorf("blank name code = %q", c)
	}

	// ülke kodu büyük harf iki harf olmalı
	f.create(t, founder, orgBody(orgE, "Küçük harf", "tr", "TRY", nil), http.StatusBadRequest)
	if _, err := f.app.FindRecordById("organizations", orgE); err == nil {
		t.Fatal("a refused organization was written")
	}

	// kovan sayısı verilmeyebilir
	row = f.create(t, founder, orgBody(orgE, "Kovansız", "TR", "TRY", nil), http.StatusOK).object(t)
	if row["hive_count_range"] != nil {
		t.Errorf("hive_count_range = %v, want null", row["hive_count_range"])
	}

	// başkasının işletme kimliğiyle çağrı reddedilir
	r = f.create(t, other, orgBody(orgD, "Ele geçirildi", "TR", "TRY", nil), http.StatusConflict)
	if c := r.errorCode(t); c != orgs.CodeConflict {
		t.Errorf("taken id code = %q", c)
	}
	if n := len(f.memberships(t, orgD)); n != 1 {
		t.Errorf("the refused call added a membership (%d)", n)
	}

	// başka kullanıcı bu işletmeleri görmez
	if got := f.mine(t, other); got != nil {
		t.Errorf("other's mine = %v, want null", got)
	}
}

// TestCreateOrganizationBody: the parameters' types and the defaults of the
// last create_organization (20261112120000).
func TestCreateOrganizationBody(t *testing.T) {
	f := newFixture(t)
	const id = "0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a"

	for name, body := range map[string]any{
		"not JSON":             "{",
		"array":                []any{},
		"no id":                map[string]any{"name": "A", "country_code": "TR", "currency": "TRY"},
		"upper-case id":        orgBody(strings.ToUpper(id), "A", "TR", "TRY", nil),
		"null name":            map[string]any{"id": id, "country_code": "TR", "currency": "TRY"},
		"name not a string":    orgBody(id, "A", "TR", "TRY", map[string]any{"name": 5}),
		"unknown hive range":   orgBody(id, "A", "TR", "TRY", map[string]any{"hive_count_range": "lots"}),
		"unknown operation":    orgBody(id, "A", "TR", "TRY", map[string]any{"operation_type": "nomadic"}),
		"no currency":          map[string]any{"id": id, "name": "A", "country_code": "TR"},
		"three-letter country": orgBody(id, "A", "TUR", "TRY", nil),
		"lower-case currency":  orgBody(id, "A", "TR", "try", nil),
	} {
		r := f.call(t, http.MethodPost, orgs.CreateRoute, founder, body, http.StatusBadRequest)
		if c := r.errorCode(t); c != orgs.CodeInvalid {
			t.Errorf("%s: code = %q", name, c)
		}
	}
	if n := f.count(t, "organizations"); n != 0 {
		t.Fatalf("%d organizations written by refused bodies", n)
	}

	// operation_type: null → migratory (coalesce), stationary is kept.
	row := f.create(t, founder, orgBody(id, "A", "TR", "TRY", map[string]any{"operation_type": nil}), http.StatusOK).object(t)
	if row["operation_type"] != "migratory" {
		t.Errorf("null operation_type → %v", row["operation_type"])
	}
	const id2 = "0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8b"
	row = f.create(t, founder, orgBody(id2, "B", "TR", "TRY", map[string]any{"operation_type": "stationary"}), http.StatusOK).object(t)
	if row["operation_type"] != "stationary" {
		t.Errorf("operation_type → %v", row["operation_type"])
	}

	// btrim trims spaces only, like Postgres' one-argument btrim.
	const id3 = "0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8c"
	row = f.create(t, founder, orgBody(id3, " \tC ", "TR", "TRY", nil), http.StatusOK).object(t)
	if row["name"] != "\tC" {
		t.Errorf("name = %q", row["name"])
	}

	// The same id with a refused body still returns the existing one:
	// create_organization looks the id up before checking the name.
	row = f.create(t, founder, orgBody(id, "   ", "TR", "TRY", nil), http.StatusOK).object(t)
	if row["name"] != "A" {
		t.Errorf("retry with a blank name = %v", row)
	}
}

// TestCreateOrganizationIsOneTransaction: when the owner membership cannot
// be written, the organization is not either.
func TestCreateOrganizationIsOneTransaction(t *testing.T) {
	f := newFixture(t)
	f.app.OnRecordCreate("memberships").BindFunc(func(e *core.RecordEvent) error {
		return errors.New("membership refused")
	})
	f.create(t, founder, orgBody(orgD, "Yarım", "TR", "TRY", nil), http.StatusInternalServerError)
	if n := f.count(t, "organizations"); n != 0 {
		t.Fatalf("%d organizations without an owner", n)
	}
}

// TestMine is fetchCurrent's query: the oldest live organization of a live
// membership; null when there is none.
func TestMine(t *testing.T) {
	f := newFixture(t)
	base := time.Date(2026, 11, 1, 9, 0, 0, 0, time.UTC)
	at := func(d time.Duration) func() { return orgs.SetNow(func() time.Time { return base.Add(d) }) }

	if got := f.mine(t, founder); got != nil {
		t.Fatalf("mine without organizations = %v", got)
	}

	const (
		newer  = "0199a3b2-0000-7000-8000-000000000002"
		older  = "0199a3b2-0000-7000-8000-000000000003"
		oldest = "0199a3b2-0000-7000-8000-000000000001"
	)
	restore := at(2 * time.Hour)
	f.create(t, founder, orgBody(newer, "Yeni", "TR", "TRY", nil), http.StatusOK)
	restore()
	restore = at(time.Hour)
	f.create(t, founder, orgBody(older, "Eski", "TR", "TRY", nil), http.StatusOK)
	restore()
	// other founds the oldest; founder is not its member.
	restore = at(0)
	f.create(t, other, orgBody(oldest, "Başkası", "TR", "TRY", nil), http.StatusOK)
	restore()

	if got := f.mine(t, founder)["id"]; got != older {
		t.Fatalf("mine = %v, want the oldest member organization %s", got, older)
	}
	if got := f.mine(t, other)["id"]; got != oldest {
		t.Fatalf("other's mine = %v", got)
	}

	// A deleted organization is skipped.
	org, err := f.app.FindRecordById("organizations", older)
	if err != nil {
		t.Fatal(err)
	}
	org.Set("deleted_at", pattern.FormatTimestamp(base.Add(3*time.Hour)))
	if err := f.app.Save(org); err != nil {
		t.Fatal(err)
	}
	if got := f.mine(t, founder)["id"]; got != newer {
		t.Fatalf("mine after deleting %s = %v, want %s", older, got, newer)
	}

	// A removed membership is skipped.
	m := f.memberships(t, newer)[0]
	m.Set("deleted_at", pattern.FormatTimestamp(base.Add(3*time.Hour)))
	if err := f.app.Save(m); err != nil {
		t.Fatal(err)
	}
	if got := f.mine(t, founder); got != nil {
		t.Fatalf("mine after removal = %v, want null", got)
	}

	f.call(t, http.MethodGet, orgs.MineRoute, "", nil, http.StatusUnauthorized)
}

// dartRow is the organizations row the client's fake HTTP answers carry
// (test/features/organization/data/organization_service_test.dart, _row and
// the create test's answer). The routes must answer a superset with the
// same values and types.
var dartRow = map[string]any{
	"id":               "0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a",
	"name":             "Petek Arıcılık",
	"country_code":     "DE",
	"currency":         "EUR",
	"hive_count_range": "up_to_200",
	"operation_type":   "migratory",
}

func TestResponsesMatchClientFixtures(t *testing.T) {
	f := newFixture(t)
	body := map[string]any{}
	for k, v := range dartRow {
		body[k] = v
	}
	created := f.create(t, founder, body, http.StatusOK).object(t)
	mine := f.mine(t, founder)
	for name, got := range map[string]map[string]any{"create": created, "mine": mine} {
		for k, want := range dartRow {
			if got[k] != want {
				t.Errorf("%s: %s = %#v, want %#v", name, k, got[k], want)
			}
		}
	}
}
