package schemadump_test

import (
	"bytes"
	"encoding/json"
	"os"
	"strconv"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/schemadump"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const repoFile = "../../" + schemadump.File

// TestDumpUpToDate is the K-3 guard: the committed dump must equal the
// schema the Go migrations build.
func TestDumpUpToDate(t *testing.T) {
	got, err := schemadump.Fresh()
	if err != nil {
		t.Fatal(err)
	}
	want, err := os.ReadFile(repoFile)
	if err != nil {
		t.Fatalf("%v; run `go run . schema dump` in server/", err)
	}
	if !bytes.Equal(got, want) {
		t.Fatalf("server/%s is out of date with the migrations: run `go run . schema dump` in server/ and commit the result\n%s",
			schemadump.File, firstDiff(want, got))
	}
}

func TestFreshIsStable(t *testing.T) {
	a, err := schemadump.Fresh()
	if err != nil {
		t.Fatal(err)
	}
	b, err := schemadump.Fresh()
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(a, b) {
		t.Fatalf("two dumps differ:\n%s", firstDiff(a, b))
	}
}

// A dashboard-style change on a migrated app changes the dump and its hash.
func TestChangeShowsInDumpAndHash(t *testing.T) {
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)

	before, err := schemadump.Hash(app)
	if err != nil {
		t.Fatal(err)
	}
	fresh, err := schemadump.Fresh()
	if err != nil {
		t.Fatal(err)
	}
	dump, err := schemadump.Dump(app)
	if err != nil {
		t.Fatal(err)
	}
	if !bytes.Equal(dump, fresh) {
		t.Fatalf("migrated test app differs from Fresh:\n%s", firstDiff(fresh, dump))
	}

	hives, err := app.FindCollectionByNameOrId("hives")
	if err != nil {
		t.Fatal(err)
	}
	hives.Fields.GetByName("status").(*core.SelectField).Values = append(
		hives.Fields.GetByName("status").(*core.SelectField).Values, "stolen")
	if err := app.Save(hives); err != nil {
		t.Fatal(err)
	}

	after, err := schemadump.Hash(app)
	if err != nil {
		t.Fatal(err)
	}
	if after == before {
		t.Fatal("hash unchanged after adding a select value")
	}
}

func TestDumpShape(t *testing.T) {
	b, err := os.ReadFile(repoFile)
	if err != nil {
		t.Fatal(err)
	}
	var cols []schemadump.Collection
	if err := json.Unmarshal(b, &cols); err != nil {
		t.Fatal(err)
	}
	byName := map[string]schemadump.Collection{}
	for i, c := range cols {
		if i > 0 && cols[i-1].Name >= c.Name {
			t.Errorf("not sorted by name: %s before %s", cols[i-1].Name, c.Name)
		}
		if strings.HasPrefix(c.Name, "_") {
			t.Errorf("system collection %s in the dump", c.Name)
		}
		byName[c.Name] = c
	}

	hives, ok := byName["hives"]
	if !ok {
		t.Fatal("hives missing")
	}
	if hives.ListRule != nil || hives.Type != core.CollectionTypeBase {
		t.Errorf("hives: type %q, listRule %v", hives.Type, hives.ListRule)
	}
	var status map[string]any
	for _, f := range hives.Fields {
		if _, hasID := f["id"]; hasID {
			t.Errorf("hives.%v carries its id", f["name"])
		}
		if f["name"] == "status" {
			status = f
		}
	}
	if status["type"] != "select" || status["required"] != true {
		t.Errorf("hives.status = %v", status)
	}
	if _, ok := byName["users"]; !ok {
		t.Error("users missing")
	}
}

// firstDiff shows the first differing line of two dumps.
func firstDiff(want, got []byte) string {
	w := strings.Split(string(want), "\n")
	g := strings.Split(string(got), "\n")
	for i := 0; i < len(w) || i < len(g); i++ {
		var wl, gl string
		if i < len(w) {
			wl = w[i]
		}
		if i < len(g) {
			gl = g[i]
		}
		if wl != gl {
			return "line " + strconv.Itoa(i+1) + ":\n  file:       " + wl + "\n  migrations: " + gl
		}
	}
	return "(no line difference)"
}
