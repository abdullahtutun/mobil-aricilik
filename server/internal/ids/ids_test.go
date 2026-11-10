package ids_test

import (
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/users"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/google/uuid"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

func TestNewIsV7(t *testing.T) {
	a, b := ids.New(), ids.New()
	for _, id := range []string{a, b} {
		if !pattern.IsUUID(id) {
			t.Errorf("%q does not match the UUID pattern", id)
		}
		if v := uuid.MustParse(id).Version(); v != 7 {
			t.Errorf("%q is version %d", id, v)
		}
	}
	if a == b {
		t.Error("two equal ids")
	}
}

func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	ids.Register(app)
	users.Register(app)
	return app
}

func newUser(t *testing.T, app core.App) *core.Record {
	t.Helper()
	c, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	u := core.NewRecord(c)
	u.SetEmail("u@example.com")
	u.SetPassword("12345678901234")
	return u
}

func TestUserGetsV7IdAndDefaultLocale(t *testing.T) {
	app := newApp(t)
	u := newUser(t, app)
	if err := app.Save(u); err != nil {
		t.Fatal(err)
	}
	if uuid.MustParse(u.Id).Version() != 7 {
		t.Errorf("id %q is not v7", u.Id)
	}
	got, err := app.FindRecordById("users", u.Id)
	if err != nil {
		t.Fatal(err)
	}
	if l := got.GetString("locale"); l != users.DefaultLocale {
		t.Errorf("locale = %q, want %q", l, users.DefaultLocale)
	}
}

func TestClientIdAndLocaleKept(t *testing.T) {
	app := newApp(t)
	const id = "0195f2a4-2222-7000-8000-000000000002"
	u := newUser(t, app)
	u.Id = id
	u.Set("locale", "fa")
	if err := app.Save(u); err != nil {
		t.Fatal(err)
	}
	got, err := app.FindRecordById("users", id)
	if err != nil {
		t.Fatal(err)
	}
	if got.GetString("locale") != "fa" {
		t.Errorf("locale = %q", got.GetString("locale"))
	}
}

func TestPocketBaseCollectionsKeepTheirIds(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId(core.CollectionNameSuperusers)
	if err != nil {
		t.Fatal(err)
	}
	su := core.NewRecord(c)
	su.SetEmail("admin@example.com")
	su.SetPassword("12345678901234")
	if err := app.Save(su); err != nil {
		t.Fatal(err)
	}
	if pattern.IsUUID(su.Id) {
		t.Errorf("superuser got a UUID id %q", su.Id)
	}
}
