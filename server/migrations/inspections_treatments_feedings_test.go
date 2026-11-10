package migrations

import (
	"slices"
	"strings"
	"testing"

	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
)

const (
	testHive       = "0195f2a4-cccc-7000-8000-000000000001"
	testInspection = "0195f2a4-1234-7000-8000-000000000001"
	testTreatment  = "0195f2a4-5678-7000-8000-000000000001"
	testMedia      = "0195f2a4-9999-7000-8000-000000000001"
	testRefDrug    = "01900000-0000-7000-8000-000000000201"
)

func TestInspectionTreatmentCollectionShapes(t *testing.T) {
	app := newApp(t)

	cases := []struct {
		name    string
		fields  fieldSpec
		indexes []string
	}{
		{
			name: "inspections",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":            "text!",
				"hive_id":           "text!",
				"apiary_id":         "text!",
				"inspected_at":      "text!",
				"queen_state":       "select",
				"bee_frames":        "json",
				"brood_frames":      "json",
				"honey_frames":      "json",
				"temperament":       "select",
				"swarm_signs":       "json",
				"queen_cells":       "select",
				"disease_suspected": "json",
				"data":              "json",
			}),
			indexes: []string{
				"idx_inspections_apiary_id||apiary_id|",
				"idx_inspections_hive_id||hive_id|",
				"idx_inspections_org_id_server_seq||org_id,server_seq|",
				"idx_inspections_server_seq|unique|server_seq|",
			},
		},
		{
			name: "media",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":        "text!",
				"hive_id":       "text!",
				"inspection_id": "text",
				"kind":          "select!",
				"storage_path":  "text!",
				"captured_at":   "text!",
				"byte_size":     "number!",
				"duration_ms":   "json",
				"treatment_id":  "text",
			}),
			indexes: []string{
				"idx_media_hive_id||hive_id|",
				"idx_media_inspection_id||inspection_id|",
				"idx_media_org_id_server_seq||org_id,server_seq|",
				"idx_media_server_seq|unique|server_seq|",
				"idx_media_treatment_id||treatment_id|",
			},
		},
		{
			name: "mite_counts",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":      "text!",
				"hive_id":     "text!",
				"apiary_id":   "text!",
				"counted_at":  "text!",
				"method":      "select!",
				"mites":       "number",
				"sample_bees": "json",
				"days":        "json",
			}),
			indexes: []string{
				"idx_mite_counts_apiary_id||apiary_id|",
				"idx_mite_counts_hive_id||hive_id|",
				"idx_mite_counts_org_id_server_seq||org_id,server_seq|",
				"idx_mite_counts_server_seq|unique|server_seq|",
			},
		},
		{
			// No org_id: a reference collection.
			name: "ref_drugs",
			fields: with(commonSyncFields, fieldSpec{
				"country_code":      "text!",
				"name_tr":           "text!",
				"name_en":           "text!",
				"active_ingredient": "select!",
				"dose_unit":         "select!",
				"withdrawal_days":   "json",
				"license_no":        "text",
			}),
			indexes: []string{
				"idx_ref_drugs_server_seq|unique|server_seq|",
			},
		},
		{
			name: "drugs",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":            "text!",
				"name":              "text!",
				"active_ingredient": "select!",
				"dose_unit":         "select!",
				"withdrawal_days":   "json",
				"license_no":        "text",
			}),
			indexes: []string{
				"idx_drugs_org_id_server_seq||org_id,server_seq|",
				"idx_drugs_server_seq|unique|server_seq|",
			},
		},
		{
			name: "treatments",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":             "text!",
				"hive_id":            "text!",
				"apiary_id":          "text!",
				"ref_drug_id":        "text",
				"drug_id":            "text",
				"product_name":       "text!",
				"active_ingredient":  "select!",
				"batch_no":           "text",
				"dose":               "number!",
				"dose_unit":          "select!",
				"started_at":         "text!",
				"planned_removal_at": "text",
				"withdrawal_days":    "number",
				"application_id":     "text",
			}),
			indexes: []string{
				"idx_treatments_apiary_id||apiary_id|",
				"idx_treatments_application_id||application_id|",
				"idx_treatments_drug_id||drug_id|",
				"idx_treatments_hive_id||hive_id|",
				"idx_treatments_org_id_server_seq||org_id,server_seq|",
				"idx_treatments_ref_drug_id||ref_drug_id|",
				"idx_treatments_server_seq|unique|server_seq|",
			},
		},
		{
			name: "feedings",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":           "text!",
				"hive_id":          "text!",
				"apiary_id":        "text!",
				"feeding_group_id": "text!",
				"fed_at":           "text!",
				"kind":             "select!",
				"amount":           "number!",
			}),
			indexes: []string{
				"idx_feedings_apiary_id||apiary_id|",
				"idx_feedings_feeding_group_id||feeding_group_id|",
				"idx_feedings_hive_id||hive_id|",
				"idx_feedings_org_id_server_seq||org_id,server_seq|",
				"idx_feedings_server_seq|unique|server_seq|",
			},
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			c, err := app.FindCollectionByNameOrId(tc.name)
			if err != nil {
				t.Fatal(err)
			}
			if c.Type != core.CollectionTypeBase {
				t.Errorf("type = %s, want base", c.Type)
			}
			if got := describeFields(c); !mapsEqual(got, tc.fields) {
				t.Errorf("fields\n got  %v\n want %v", got, tc.fields)
			}
			if got := describeIndexes(c); !slices.Equal(got, tc.indexes) {
				t.Errorf("indexes\n got  %q\n want %q", got, tc.indexes)
			}
			for rule, v := range map[string]*string{
				"list": c.ListRule, "view": c.ViewRule, "create": c.CreateRule,
				"update": c.UpdateRule, "delete": c.DeleteRule,
			} {
				if v != nil {
					t.Errorf("%s rule = %q, want nil", rule, *v)
				}
			}
			for _, f := range c.Fields {
				if f.Type() == core.FieldTypeAutodate {
					t.Errorf("autodate field %q", f.GetName())
				}
			}
		})
	}
}

func TestInspectionTreatmentSelectValues(t *testing.T) {
	app := newApp(t)
	ingredients := []string{
		"amitraz", "oxalic_acid", "formic_acid", "thymol", "flumethrin",
		"tau_fluvalinate", "coumaphos", "lactic_acid", "other",
	}
	units := []string{"strip", "ml", "g", "dose"}
	want := map[string]map[string][]string{
		"inspections": {
			"queen_state": {"seen", "eggs", "none"},
			"temperament": {"calm", "nervous"},
			"queen_cells": {"none", "swarm", "supersedure", "emergency"},
		},
		"media":       {"kind": {"photo", "audio"}},
		"mite_counts": {"method": {"sugar_roll", "alcohol_wash", "sticky_board"}},
		"ref_drugs":   {"active_ingredient": ingredients, "dose_unit": units},
		"drugs":       {"active_ingredient": ingredients, "dose_unit": units},
		"treatments":  {"active_ingredient": ingredients, "dose_unit": units},
		"feedings":    {"kind": {"syrup_1_1", "syrup_2_1", "bee_cake", "pollen_substitute"}},
	}
	for collection, fields := range want {
		c, err := app.FindCollectionByNameOrId(collection)
		if err != nil {
			t.Fatal(err)
		}
		for name, values := range fields {
			f, ok := c.Fields.GetByName(name).(*core.SelectField)
			if !ok {
				t.Fatalf("%s.%s is not a select", collection, name)
			}
			if !slices.Equal(f.Values, values) || f.MaxSelect != 1 {
				t.Errorf("%s.%s = %v (max %d), want %v (max 1)", collection, name, f.Values, f.MaxSelect, values)
			}
		}
	}
}

func TestInspectionTreatmentFields(t *testing.T) {
	app := newApp(t)

	inspection := func() *core.Record {
		r := newRow(t, app, "inspections", testInspection, 1)
		r.Set("hive_id", testHive)
		r.Set("apiary_id", testApiary)
		r.Set("inspected_at", testTime)
		r.Set("data", map[string]any{})
		return r
	}
	media := func() *core.Record {
		r := newRow(t, app, "media", testMedia, 1)
		r.Set("hive_id", testHive)
		r.Set("kind", "photo")
		r.Set("storage_path", testOrg+"/"+testHive+"/"+testMedia+".jpg")
		r.Set("captured_at", testTime)
		r.Set("byte_size", 2048)
		return r
	}
	miteCount := func() *core.Record {
		r := newRow(t, app, "mite_counts", "0195f2a4-3434-7000-8000-000000000001", 1)
		r.Set("hive_id", testHive)
		r.Set("apiary_id", testApiary)
		r.Set("counted_at", testTime)
		r.Set("method", "sugar_roll")
		r.Set("mites", 3)
		r.Set("sample_bees", 300)
		return r
	}
	refDrug := func() *core.Record {
		c, err := app.FindCollectionByNameOrId("ref_drugs")
		if err != nil {
			t.Fatal(err)
		}
		r := core.NewRecord(c) // no org_id
		r.Id = "0195f2a4-4545-7000-8000-000000000001"
		r.Set("created_at", testTime)
		r.Set("updated_at", testTime)
		r.Set("server_seq", 1)
		r.Set("country_code", "GLOBAL")
		r.Set("name_tr", "Timol")
		r.Set("name_en", "Thymol")
		r.Set("active_ingredient", "thymol")
		r.Set("dose_unit", "g")
		return r
	}
	drug := func() *core.Record {
		r := newRow(t, app, "drugs", "0195f2a4-5656-7000-8000-000000000001", 1)
		r.Set("name", "Kendi şeridim")
		r.Set("active_ingredient", "other")
		r.Set("dose_unit", "strip")
		return r
	}
	treatment := func() *core.Record {
		r := newRow(t, app, "treatments", testTreatment, 1)
		r.Set("hive_id", testHive)
		r.Set("apiary_id", testApiary)
		r.Set("ref_drug_id", testRefDrug)
		r.Set("product_name", "Bayvarol Kovan İçi Şerit")
		r.Set("active_ingredient", "flumethrin")
		r.Set("dose", 4)
		r.Set("dose_unit", "strip")
		r.Set("started_at", testTime)
		r.Set("withdrawal_days", 0)
		return r
	}
	feeding := func() *core.Record {
		r := newRow(t, app, "feedings", "0195f2a4-6767-7000-8000-000000000001", 1)
		r.Set("hive_id", testHive)
		r.Set("apiary_id", testApiary)
		r.Set("feeding_group_id", "0195f2a4-7878-7000-8000-000000000001")
		r.Set("fed_at", testTime)
		r.Set("kind", "syrup_1_1")
		r.Set("amount", 1.5)
		return r
	}
	for _, base := range []func() *core.Record{inspection, media, miteCount, refDrug, drug, treatment, feeding} {
		r := base()
		if err := app.Validate(r); err != nil {
			t.Fatalf("valid %s rejected: %v", r.Collection().Name, err)
		}
	}

	long := func(n int) string { return strings.Repeat("ş", n) }

	checkValues(t, app, inspection,
		map[string][]any{
			"queen_state":       {"", "eggs"},
			"bee_frames":        {nil, 0, 8},
			"swarm_signs":       {nil, true, false},
			"disease_suspected": {nil, false},
			"queen_cells":       {"", "supersedure"},
			"data":              {map[string]any{"actions": []string{"added_super"}}},
		},
		map[string][]any{
			"hive_id":      {"", "hive-1"},
			"apiary_id":    {""},
			"inspected_at": {"", "2026-11-10"},
			"queen_state":  {"laying"},
			"temperament":  {"angry"},
			"queen_cells":  {"many"},
			"swarm_signs":  {"x" + strings.Repeat("y", 10)},
			"data":         {"x" + strings.Repeat("y", 70000)},
		})
	checkValues(t, app, media,
		map[string][]any{
			"inspection_id": {"", testInspection},
			"treatment_id":  {"", testTreatment},
			"byte_size":     {1, 10485760},
			"duration_ms":   {nil, 0, 1500},
			"storage_path":  {testOrg + "/" + testHive + "/" + testMedia + ".m4a"},
		},
		map[string][]any{
			"kind":      {"", "video"},
			"byte_size": {0, -1, 10485761, 1.5},
			"storage_path": {
				"",
				testOrg + "/" + testHive + "/" + testMedia + ".png",
				testOrg + "/" + testMedia + ".jpg",
				strings.ToUpper(testOrg) + "/" + testHive + "/" + testMedia + ".jpg",
				"../" + testHive + "/" + testMedia + ".jpg",
				testOrg + "/" + testHive + "/" + testMedia + ".jpg/x",
			},
			"captured_at": {""},
		})
	checkValues(t, app, miteCount,
		map[string][]any{
			"mites":       {0, 100000},
			"method":      {"alcohol_wash", "sticky_board"},
			"sample_bees": {nil, 1},
			"days":        {nil, 3},
		},
		map[string][]any{
			"mites":  {-1, 100001, 2.5},
			"method": {"", "visual"},
		})
	checkValues(t, app, refDrug,
		map[string][]any{
			"country_code":    {"GLOBAL", "TR", "DE"},
			"name_tr":         {long(120)},
			"withdrawal_days": {nil, 0, 365},
			"license_no":      {"", "TR-123", long(60)},
		},
		map[string][]any{
			"country_code":      {"", "tr", "TUR", "global", "T1"},
			"name_tr":           {"", long(121)},
			"name_en":           {"", long(121)},
			"active_ingredient": {"", "neem"},
			"dose_unit":         {"", "kg"},
			"license_no":        {long(61)},
		})
	checkValues(t, app, drug,
		map[string][]any{
			"name":            {"A", long(120)},
			"withdrawal_days": {nil, 0, 30},
			"license_no":      {"", long(60)},
		},
		map[string][]any{
			"name":              {"", long(121)},
			"active_ingredient": {""},
			"dose_unit":         {"pill"},
			"license_no":        {long(61)},
		})
	checkValues(t, app, treatment,
		map[string][]any{
			"ref_drug_id":        {"", testRefDrug},
			"drug_id":            {"", "0195f2a4-5656-7000-8000-000000000001"},
			"batch_no":           {"", "L-2026", long(60)},
			"dose":               {0.01, 10000},
			"planned_removal_at": {"", testTime},
			"withdrawal_days":    {0, 365},
			"application_id":     {"", "0195f2a4-8989-7000-8000-000000000001"},
		},
		map[string][]any{
			"product_name":    {"", long(121)},
			"batch_no":        {long(61)},
			"dose":            {0, -1, 10000.5},
			"started_at":      {""},
			"withdrawal_days": {-1, 366, 1.5},
			"ref_drug_id":     {"drug-1"},
			"application_id":  {"app-1"},
		})
	checkValues(t, app, feeding,
		map[string][]any{
			"amount": {0.001, 100},
			"kind":   {"bee_cake", "pollen_substitute"},
		},
		map[string][]any{
			"amount":           {0, -0.5, 100.5},
			"kind":             {"", "honey"},
			"feeding_group_id": {"", "group-1"},
			"fed_at":           {""},
		})
}

// Null, false and true stay apart for the nullable booleans.
func TestInspectionNullableBooleans(t *testing.T) {
	app := newApp(t)
	r := newRow(t, app, "inspections", testInspection, 1)
	r.Set("hive_id", testHive)
	r.Set("apiary_id", testApiary)
	r.Set("inspected_at", testTime)
	r.Set("data", map[string]any{})
	r.Set("swarm_signs", nil)
	r.Set("disease_suspected", false)
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	got, err := app.FindRecordById("inspections", testInspection)
	if err != nil {
		t.Fatal(err)
	}
	if raw := got.GetString("swarm_signs"); raw != "" && raw != "null" {
		t.Errorf("null swarm_signs stored as %q", raw)
	}
	if raw := got.GetString("disease_suspected"); raw != "false" {
		t.Errorf("false disease_suspected stored as %q", raw)
	}
	if raw := got.GetString("data"); raw != "{}" {
		t.Errorf("empty data stored as %q", raw)
	}
}

// refDrugsSupabaseRows is the ref_drugs row count in Supabase: the insert
// rows of 20261025200000 (10), 20261031200000 (7) and 20261101120000 (4);
// `grep -c "^  ('01900000-" supabase/migrations/*ref_drugs*.sql
// supabase/migrations/20261025200000_treatments.sql` prints them. Two are
// soft-deleted. The live project had 21 rows on 2026-11-10.
const (
	refDrugsSupabaseRows    = 21
	refDrugsSupabaseDeleted = 2
)

func TestRefDrugsSeed(t *testing.T) {
	app := newApp(t)

	n, err := app.CountRecords("ref_drugs")
	if err != nil {
		t.Fatal(err)
	}
	if n != refDrugsSupabaseRows {
		t.Errorf("ref_drugs rows = %d, want %d", n, refDrugsSupabaseRows)
	}
	deleted, err := app.FindRecordsByFilter("ref_drugs", "deleted_at != ''", "id", 0, 0)
	if err != nil {
		t.Fatal(err)
	}
	var deletedIDs []string
	for _, r := range deleted {
		deletedIDs = append(deletedIDs, r.Id)
	}
	if want := []string{
		"01900000-0000-7000-8000-000000000101",
		"01900000-0000-7000-8000-000000000102",
	}; len(deleted) != refDrugsSupabaseDeleted || !slices.Equal(deletedIDs, want) {
		t.Errorf("deleted rows = %v, want %v", deletedIDs, want)
	}

	// Spot checks against the SQL.
	type row struct {
		country, nameTR, nameEN, ingredient, unit, withdrawal, created, updated, deletedAt string
	}
	want := map[string]row{
		"01900000-0000-7000-8000-000000000001": {"GLOBAL", "Amitraz", "Amitraz", "amitraz", "strip", "null", refDrugsTime1, refDrugsTime1, ""},
		"01900000-0000-7000-8000-000000000102": {"TR", "Oksalik asit damlatma", "Oxalic acid trickling", "oxalic_acid", "ml", "null", refDrugsTime1, refDrugsTime2, refDrugsTime2},
		"01900000-0000-7000-8000-000000000201": {"TR", "Bayvarol Kovan İçi Şerit", "Bayvarol in-hive strip", "flumethrin", "strip", "0", refDrugsTime2, refDrugsTime2, ""},
		"01900000-0000-7000-8000-000000000202": {"TR", "BEERAZ Arı Kovanı Şeridi", "BEERAZ hive strip", "amitraz", "strip", "null", refDrugsTime2, refDrugsTime2, ""},
		"01900000-0000-7000-8000-000000000211": {"TR", "Varroset", "Varroset", "amitraz", "dose", "null", refDrugsTime3, refDrugsTime3, ""},
	}
	for id, w := range want {
		r, err := app.FindRecordById("ref_drugs", id)
		if err != nil {
			t.Errorf("%s: %v", id, err)
			continue
		}
		got := row{
			r.GetString("country_code"), r.GetString("name_tr"), r.GetString("name_en"),
			r.GetString("active_ingredient"), r.GetString("dose_unit"), r.GetString("withdrawal_days"),
			r.GetString("created_at"), r.GetString("updated_at"), r.GetString("deleted_at"),
		}
		if got.withdrawal == "" {
			got.withdrawal = "null"
		}
		if got != w {
			t.Errorf("%s\n got  %+v\n want %+v", id, got, w)
		}
		if r.GetString("license_no") != "" || r.GetString("created_by") != "" {
			t.Errorf("%s: license_no/created_by not empty", id)
		}
	}
	// Withdrawal days are set (0) exactly for the five strips that state it.
	zero, err := app.FindRecordsByFilter("ref_drugs", "withdrawal_days = 0", "", 0, 0)
	if err != nil {
		t.Fatal(err)
	}
	if len(zero) != 5 {
		t.Errorf("rows with withdrawal_days 0 = %d, want 5", len(zero))
	}

	// Every row has its own server_seq.
	last, err := appsync.LastSeq(app)
	if err != nil {
		t.Fatal(err)
	}
	if last != refDrugsSupabaseRows {
		t.Errorf("last_seq = %d, want %d", last, refDrugsSupabaseRows)
	}
}

// With the seq hook bound (as in serve and the CLI), the seed still gives
// every row a distinct number.
func TestRefDrugsSeedWithSeqHook(t *testing.T) {
	app := newApp(t)
	if err := downRefDrugsSeed(app); err != nil {
		t.Fatal(err)
	}
	if n, _ := app.CountRecords("ref_drugs"); n != 0 {
		t.Fatalf("rows after down = %d", n)
	}
	appsync.RegisterSeq(app)
	if err := upRefDrugsSeed(app); err != nil {
		t.Fatal(err)
	}
	rows, err := app.FindAllRecords("ref_drugs")
	if err != nil {
		t.Fatal(err)
	}
	seen := map[int]bool{}
	for _, r := range rows {
		seq := r.GetInt("server_seq")
		if seq <= refDrugsSupabaseRows || seen[seq] {
			t.Errorf("%s: server_seq %d not new or repeated", r.Id, seq)
		}
		seen[seq] = true
	}
	if len(rows) != refDrugsSupabaseRows {
		t.Errorf("rows = %d, want %d", len(rows), refDrugsSupabaseRows)
	}
}

func TestDownInspectionsTreatmentsFeedings(t *testing.T) {
	app := newApp(t)
	if err := downRefDrugsSeed(app); err != nil {
		t.Fatal(err)
	}
	if err := downInspectionsTreatmentsFeedings(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range inspectionTreatmentCollections {
		if _, err := app.FindCollectionByNameOrId(name); err == nil {
			t.Errorf("%s still exists", name)
		}
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}
	for _, name := range apiaryHiveCollections {
		if _, err := app.FindCollectionByNameOrId(name); err != nil {
			t.Errorf("%s removed: %v", name, err)
		}
	}
	if err := upInspectionsTreatmentsFeedings(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
	if err := upRefDrugsSeed(app); err != nil {
		t.Fatalf("seed after down: %v", err)
	}
	if n, _ := app.CountRecords("ref_drugs"); n != refDrugsSupabaseRows {
		t.Errorf("rows after re-seed = %d", n)
	}
}
