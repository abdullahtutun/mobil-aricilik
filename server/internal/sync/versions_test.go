package sync_test

import (
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"testing"

	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
)

// TestSchemaVersionMatchesDrift: the app's current Drift schemaVersion is
// accepted (Supabase's supported_versions; schema_mirror_test.dart checked
// the same on the client side), and no version outside 1..current is.
func TestSchemaVersionMatchesDrift(t *testing.T) {
	src, err := os.ReadFile(filepath.Join("..", "..", "..", "lib", "core", "db", "app_database.dart"))
	if err != nil {
		t.Fatal(err)
	}
	m := regexp.MustCompile(`int get schemaVersion => (\d+);`).FindSubmatch(src)
	if m == nil {
		t.Fatal("schemaVersion not found in app_database.dart")
	}
	current, _ := strconv.Atoi(string(m[1]))
	if !appsync.SchemaVersionSupported(current) {
		t.Errorf("Drift schemaVersion %d is not in SupportedSchemaVersions %v", current, appsync.SupportedSchemaVersions)
	}
	for _, v := range appsync.SupportedSchemaVersions {
		if v < 1 || v > current {
			t.Errorf("SupportedSchemaVersions has %d, outside 1..%d", v, current)
		}
	}
}
