package validate

import (
	"regexp"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

func TestHarvestsNetKgCheck(t *testing.T) {
	for _, v := range []float64{0.001, 0.0005, 42.5, 100000, 100000.0004} {
		if err := HarvestsNetKgCheck(v); err != nil {
			t.Errorf("net_kg %v rejected: %v", v, err)
		}
	}
	for _, v := range []float64{0, 0.0004, -1, 100000.0005, 100001} {
		if err := HarvestsNetKgCheck(v); err == nil {
			t.Errorf("net_kg %v accepted", v)
		}
	}
}

func TestHarvestHivesCheck(t *testing.T) {
	const treatment = "0195f2a4-5678-7000-8000-000000000001"
	if err := HarvestHivesCheck("", ""); err != nil {
		t.Error(err)
	}
	if err := HarvestHivesCheck(treatment, "removed_early"); err != nil {
		t.Error(err)
	}
	if err := HarvestHivesCheck(treatment, ""); err == nil {
		t.Error("treatment without reason accepted")
	}
	if err := HarvestHivesCheck("", "not_for_sale"); err == nil {
		t.Error("reason without treatment accepted")
	}
}

func TestMigrationStopsChecks(t *testing.T) {
	if err := MigrationStopsCheck("2026-04-01", "2026-04-01"); err != nil {
		t.Error(err)
	}
	if err := MigrationStopsCheck("2026-04-01", "2026-05-15"); err != nil {
		t.Error(err)
	}
	if err := MigrationStopsCheck("2026-04-01", "2026-03-31"); err == nil {
		t.Error("end before start accepted")
	}

	for _, raw := range []types.JSONRaw{nil, types.JSONRaw("null"), types.JSONRaw("0"), types.JSONRaw("100000")} {
		if err := MigrationStopsHiveCountCheck(raw); err != nil {
			t.Errorf("hive_count %s rejected: %v", raw, err)
		}
	}
	for _, raw := range []types.JSONRaw{types.JSONRaw("-1"), types.JSONRaw("100001"), types.JSONRaw("2.5"), types.JSONRaw(`"3"`)} {
		if err := MigrationStopsHiveCountCheck(raw); err == nil {
			t.Errorf("hive_count %s accepted", raw)
		}
	}
}

func TestTransportsChecks(t *testing.T) {
	const a, b = "0195f2a4-aaaa-7000-8000-000000000001", "0195f2a4-aaaa-7000-8000-000000000002"
	if err := TransportsCheck(a, b); err != nil {
		t.Error(err)
	}
	if err := TransportsCheck(a, a); err == nil {
		t.Error("same apiary accepted")
	}

	for _, raw := range []string{`[]`, `["Kamyon 1","Kamyon 2"]`, `[1]`} {
		if err := TransportsVehiclesCheck(types.JSONRaw(raw)); err != nil {
			t.Errorf("vehicles %s rejected: %v", raw, err)
		}
	}
	// Not null in Supabase: empty and null fail like any non-array.
	for _, raw := range []string{``, `null`, `{}`, `"Kamyon"`, `[`, `[` + strings.Repeat(`"x",`, 5000) + `"x"]`} {
		if err := TransportsVehiclesCheck(types.JSONRaw(raw)); err == nil {
			t.Errorf("vehicles %.20s accepted", raw)
		}
	}
}

const (
	docOrg  = "0195f2a4-1111-7000-8000-000000000001"
	docID   = "0195f2a4-d4d4-7000-8000-000000000001"
	docFile = "0195f2a4-d5d5-7000-8000-000000000001"
)

func TestDocumentsCheck(t *testing.T) {
	if err := DocumentsCheck("custom", "Arazi kira sözleşmesi"); err != nil {
		t.Error(err)
	}
	if err := DocumentsCheck("health_report", ""); err != nil {
		t.Error(err)
	}
	if err := DocumentsCheck("custom", ""); err == nil {
		t.Error("custom without name accepted")
	}
	if err := DocumentsCheck("health_report", "Rapor"); err == nil {
		t.Error("ready type with custom name accepted")
	}
}

func TestDocumentsCheck1(t *testing.T) {
	ok := []struct{ kind, path string }{
		{"pdf", docOrg + "/" + docID + "/" + docFile + ".pdf"},
		{"photo", docOrg + "/" + docID + "/" + docFile + ".jpg"},
		// A replaced file has a new file id in the same folder.
		{"pdf", docOrg + "/" + docID + "/0195f2a4-d5d5-7000-8000-000000000002.pdf"},
		{"pdf", docOrg + "/" + docID + "/" + strings.Repeat("-", 36) + ".pdf"},
	}
	for _, c := range ok {
		if err := DocumentsCheck1(docID, docOrg, c.kind, c.path); err != nil {
			t.Errorf("%s %s rejected: %v", c.kind, c.path, err)
		}
	}
	other := "0195f2a4-1111-7000-8000-000000000099"
	bad := []struct{ kind, path string }{
		{"pdf", docOrg + "/" + docID + "/" + docFile + ".jpg"},      // wrong extension
		{"photo", docOrg + "/" + docID + "/" + docFile + ".pdf"},    // wrong extension
		{"pdf", other + "/" + docID + "/" + docFile + ".pdf"},       // other org
		{"pdf", docOrg + "/" + other + "/" + docFile + ".pdf"},      // other document
		{"pdf", docOrg + "/" + docID + "/" + docFile[:35] + ".pdf"}, // short file id
		{"pdf", docOrg + "/" + docID + "/" + docFile + ".pdf/x"},
		{"pdf", ""},
	}
	for _, c := range bad {
		if err := DocumentsCheck1(docID, docOrg, c.kind, c.path); err == nil {
			t.Errorf("%s %s accepted", c.kind, c.path)
		}
	}
	// An org id with regexp metacharacters cannot widen the pattern.
	if err := DocumentsCheck1(docID, "....", "pdf", "abcd/"+docID+"/"+docFile+".pdf"); err == nil {
		t.Error("metacharacters in org_id matched")
	}
}

func TestDocumentStoragePathPattern(t *testing.T) {
	re := regexp.MustCompile(DocumentStoragePath)
	for _, p := range []string{
		docOrg + "/" + docID + "/" + docFile + ".pdf",
		docOrg + "/" + docID + "/" + docFile + ".jpg",
	} {
		if !re.MatchString(p) {
			t.Errorf("%s rejected", p)
		}
	}
	for _, p := range []string{
		docOrg + "/" + docID + "/" + docFile + ".png",
		docOrg + "/" + docFile + ".pdf",
		strings.ToUpper(docOrg) + "/" + docID + "/" + docFile + ".pdf",
		docOrg + "/" + docID + "/" + docFile + ".pdf\n",
	} {
		if re.MatchString(p) {
			t.Errorf("%q accepted", p)
		}
	}
}
