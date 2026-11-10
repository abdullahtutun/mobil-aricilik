package bootstrap

import (
	"crypto/sha256"
	"encoding/hex"
	"net/http"
	"os"
	"path/filepath"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/schemadump"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

// appWithToken returns a registered app and an auth token of a new record
// in collection (a superuser or a users row).
func appWithToken(t *testing.T, collection string) (*tests.TestApp, string) {
	t.Helper()
	app := factory(config.Config{Env: config.EnvDev}, "x")(t)
	col, err := app.FindCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(col)
	r.SetEmail("someone@example.com")
	r.SetPassword("1234567890")
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	token, err := r.NewAuthToken()
	if err != nil {
		t.Fatal(err)
	}
	return app, token
}

func TestSchemaHashRoute(t *testing.T) {
	// The repo's dump: a fresh app with the migrations has the same schema,
	// so the route answers the file's SHA-256 (what schema_check.sh compares).
	file, err := os.ReadFile(filepath.Join("..", "..", schemadump.File))
	if err != nil {
		t.Fatal(err)
	}
	sum := sha256.Sum256(file)
	want := hex.EncodeToString(sum[:])

	superApp, superToken := appWithToken(t, core.CollectionNameSuperusers)
	userApp, userToken := appWithToken(t, "users")

	scenarios := []tests.ApiScenario{
		{
			Name:            "superuser gets the dump's SHA-256",
			Method:          http.MethodGet,
			URL:             "/api/app/schema-hash",
			Headers:         map[string]string{"Authorization": superToken},
			ExpectedStatus:  http.StatusOK,
			ExpectedContent: []string{`"sha256":"` + want + `"`},
			TestAppFactory:  func(testing.TB) *tests.TestApp { return superApp },
		},
		{
			Name:            "anonymous is rejected",
			Method:          http.MethodGet,
			URL:             "/api/app/schema-hash",
			ExpectedStatus:  http.StatusUnauthorized,
			ExpectedContent: []string{`"data":{}`},
			TestAppFactory:  factory(config.Config{Env: config.EnvDev}, "x"),
		},
		{
			Name:            "users token is rejected",
			Method:          http.MethodGet,
			URL:             "/api/app/schema-hash",
			Headers:         map[string]string{"Authorization": userToken},
			ExpectedStatus:  http.StatusForbidden,
			ExpectedContent: []string{`"data":{}`},
			TestAppFactory:  func(testing.TB) *tests.TestApp { return userApp },
		},
	}
	for _, s := range scenarios {
		s.Test(t)
	}
}
