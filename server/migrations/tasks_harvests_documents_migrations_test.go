package migrations

import (
	"slices"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

const (
	testTask          = "0195f2a4-d1d1-7000-8000-000000000001"
	testHarvest       = "0195f2a4-d2d2-7000-8000-000000000001"
	testHarvestHive   = "0195f2a4-d3d3-7000-8000-000000000001"
	testDocument      = "0195f2a4-d4d4-7000-8000-000000000001"
	testDocumentFile  = "0195f2a4-d5d5-7000-8000-000000000001"
	testMigration     = "0195f2a4-d6d6-7000-8000-000000000001"
	testMigrationStop = "0195f2a4-d7d7-7000-8000-000000000001"
	testTransport     = "0195f2a4-d8d8-7000-8000-000000000001"
	testOtherApiary   = "0195f2a4-aaaa-7000-8000-000000000002"
)

func TestTaskHarvestDocumentCollectionShapes(t *testing.T) {
	app := newApp(t)

	cases := []struct {
		name    string
		fields  fieldSpec
		indexes []string
	}{
		{
			name: "tasks",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":       "text!",
				"title":        "text",
				"due_at":       "text!",
				"apiary_id":    "text",
				"hive_id":      "text",
				"assigned_to":  "text",
				"completed_at": "text",
				"source":       "select!",
				"source_id":    "text",
				"ref_drug_id":  "text",
				"drug_id":      "text",
				"dose":         "json",
				"source_step":  "json",
			}),
			indexes: []string{
				"idx_tasks_apiary_id||apiary_id|",
				"idx_tasks_assigned_to||assigned_to|",
				"idx_tasks_drug_id||drug_id|",
				"idx_tasks_hive_id||hive_id|",
				"idx_tasks_org_id_server_seq||org_id,server_seq|",
				"idx_tasks_ref_drug_id||ref_drug_id|",
				"idx_tasks_server_seq|unique|server_seq|",
				"idx_tasks_source_id||source_id|",
			},
		},
		{
			name: "harvests",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":       "text!",
				"apiary_id":    "text!",
				"harvested_at": "text!",
				"honey_kind":   "select!",
				"unit":         "select!",
				"unit_count":   "number!",
				"net_kg":       "number!",
			}),
			indexes: []string{
				"idx_harvests_apiary_id||apiary_id|",
				"idx_harvests_org_id_server_seq||org_id,server_seq|",
				"idx_harvests_server_seq|unique|server_seq|",
			},
		},
		{
			name: "harvest_hives",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":                     "text!",
				"harvest_id":                 "text!",
				"hive_id":                    "text!",
				"withdrawal_treatment_id":    "text",
				"withdrawal_override_reason": "select",
			}),
			indexes: []string{
				"idx_harvest_hives_harvest_id_hive_id|unique|harvest_id,hive_id|`deleted_at` = ''",
				"idx_harvest_hives_hive_id||hive_id|",
				"idx_harvest_hives_org_id_server_seq||org_id,server_seq|",
				"idx_harvest_hives_server_seq|unique|server_seq|",
				"idx_harvest_hives_withdrawal_treatment_id||withdrawal_treatment_id|",
			},
		},
		{
			name: "documents",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":           "text!",
				"type":             "select!",
				"custom_type_name": "text",
				"name":             "text!",
				"description":      "text",
				"expires_on":       "text",
				"file_kind":        "select!",
				"storage_path":     "text!",
				"byte_size":        "number!",
			}),
			indexes: []string{
				"idx_documents_org_id_server_seq||org_id,server_seq|",
				"idx_documents_server_seq|unique|server_seq|",
			},
		},
		{
			name: "migrations",
			fields: with(commonSyncFields, fieldSpec{
				"org_id": "text!",
				"year":   "number!",
				"name":   "text!",
			}),
			indexes: []string{
				"idx_migrations_org_id_server_seq||org_id,server_seq|",
				"idx_migrations_server_seq|unique|server_seq|",
			},
		},
		{
			name: "migration_stops",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":           "text!",
				"migration_id":     "text!",
				"position":         "number!",
				"name":             "text!",
				"place":            "text",
				"planned_start_on": "text!",
				"planned_end_on":   "text!",
				"apiary_id":        "text",
				"hive_count":       "json",
				"status":           "select!",
			}),
			indexes: []string{
				"idx_migration_stops_apiary_id||apiary_id|",
				"idx_migration_stops_migration_id||migration_id|",
				"idx_migration_stops_org_id_server_seq||org_id,server_seq|",
				"idx_migration_stops_server_seq|unique|server_seq|",
			},
		},
		{
			name: "transports",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":                "text!",
				"migration_stop_id":     "text",
				"source_apiary_id":      "text!",
				"destination_apiary_id": "text!",
				"vehicles":              "json",
				"status":                "select!",
				"completed_at":          "text",
			}),
			indexes: []string{
				"idx_transports_destination_apiary_id||destination_apiary_id|",
				"idx_transports_migration_stop_id||migration_stop_id|",
				"idx_transports_org_id_server_seq||org_id,server_seq|",
				"idx_transports_server_seq|unique|server_seq|",
				"idx_transports_source_apiary_id||source_apiary_id|",
			},
		},
		{
			name: "transport_items",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":       "text!",
				"transport_id": "text!",
				"hive_id":      "text!",
				"vehicle":      "text!",
				"loaded_at":    "text!",
				"unloaded_at":  "text",
			}),
			indexes: []string{
				"idx_transport_items_hive_id||hive_id|",
				"idx_transport_items_org_id_server_seq||org_id,server_seq|",
				"idx_transport_items_server_seq|unique|server_seq|",
				"idx_transport_items_transport_id||transport_id|",
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

func TestTaskHarvestDocumentSelectValues(t *testing.T) {
	app := newApp(t)
	want := map[string]map[string][]string{
		"tasks":           {"source": {"manual", "inspection", "treatment", "queen_rearing", "aks_update"}},
		"harvests":        {"honey_kind": {"pine", "flower", "chestnut", "citrus", "other"}, "unit": {"super", "frame"}},
		"harvest_hives":   {"withdrawal_override_reason": {"removed_early", "not_for_sale"}},
		"migration_stops": {"status": {"past", "current", "planned"}},
		"transports":      {"status": {"loading", "unloading", "completed"}},
		"documents": {
			"type": {
				"health_report", "transport_permit", "migratory_certificate",
				"business_registration", "land_permit", "analysis_report", "custom",
			},
			"file_kind": {"photo", "pdf"},
		},
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

func TestTaskHarvestDocumentFields(t *testing.T) {
	app := newApp(t)

	task := func() *core.Record {
		r := newRow(t, app, "tasks", testTask, 1)
		r.Set("title", "Kat ver")
		r.Set("due_at", testTime)
		r.Set("source", "manual")
		return r
	}
	harvest := func() *core.Record {
		r := newRow(t, app, "harvests", testHarvest, 1)
		r.Set("apiary_id", testApiary)
		r.Set("harvested_at", testTime)
		r.Set("honey_kind", "pine")
		r.Set("unit", "super")
		r.Set("unit_count", 4)
		r.Set("net_kg", 42.5)
		return r
	}
	harvestHive := func() *core.Record {
		r := newRow(t, app, "harvest_hives", testHarvestHive, 1)
		r.Set("harvest_id", testHarvest)
		r.Set("hive_id", testHive)
		return r
	}
	document := func() *core.Record {
		r := newRow(t, app, "documents", testDocument, 1)
		r.Set("type", "health_report")
		r.Set("name", "Sağlık raporu 2026")
		r.Set("file_kind", "pdf")
		r.Set("storage_path", testOrg+"/"+testDocument+"/"+testDocumentFile+".pdf")
		r.Set("byte_size", 204800)
		return r
	}
	migration := func() *core.Record {
		r := newRow(t, app, "migrations", testMigration, 1)
		r.Set("year", 2026)
		r.Set("name", "Göç planı 2026")
		return r
	}
	migrationStop := func() *core.Record {
		r := newRow(t, app, "migration_stops", testMigrationStop, 1)
		r.Set("migration_id", testMigration)
		r.Set("position", 1)
		r.Set("name", "Narenciye")
		r.Set("planned_start_on", "2026-04-01")
		r.Set("planned_end_on", "2026-05-15")
		r.Set("status", "planned")
		return r
	}
	transport := func() *core.Record {
		r := newRow(t, app, "transports", testTransport, 1)
		r.Set("source_apiary_id", testApiary)
		r.Set("destination_apiary_id", testOtherApiary)
		r.Set("vehicles", []string{"Kamyon 1"})
		r.Set("status", "loading")
		return r
	}
	transportItem := func() *core.Record {
		r := newRow(t, app, "transport_items", "0195f2a4-d9d9-7000-8000-000000000001", 1)
		r.Set("transport_id", testTransport)
		r.Set("hive_id", testHive)
		r.Set("vehicle", "Kamyon 1")
		r.Set("loaded_at", testTime)
		return r
	}
	for _, base := range []func() *core.Record{task, harvest, harvestHive, document, migration, migrationStop, transport, transportItem} {
		r := base()
		if err := app.Validate(r); err != nil {
			t.Fatalf("valid %s rejected: %v", r.Collection().Name, err)
		}
	}

	long := func(n int) string { return strings.Repeat("ş", n) }

	checkValues(t, app, task,
		map[string][]any{
			"title":        {"", long(200)},
			"apiary_id":    {"", testApiary},
			"hive_id":      {"", testHive},
			"assigned_to":  {"", testUser},
			"completed_at": {"", testTime},
			"source":       {"inspection", "treatment", "queen_rearing", "aks_update"},
			"source_id":    {"", testInspection},
			"ref_drug_id":  {"", testRefDrug},
			"drug_id":      {"", "0195f2a4-5656-7000-8000-000000000001"},
			"dose":         {nil, 0.5, 4},
			"source_step":  {nil, 1, 24},
		},
		map[string][]any{
			"title":       {long(201)},
			"due_at":      {"", "2026-11-10"},
			"assigned_to": {"user-1", strings.ToUpper(testUser)},
			"source":      {"", "auto"},
			"source_id":   {"x"},
			// The type is validate.TasksDoseCheck's; the field caps the size.
			"dose": {strings.Repeat("9", 40)},
		})
	checkValues(t, app, harvest,
		map[string][]any{
			"unit_count": {1, 1000},
			"net_kg":     {0.001, 100000},
			"honey_kind": {"flower", "chestnut", "citrus", "other"},
			"unit":       {"frame"},
		},
		map[string][]any{
			"apiary_id":    {""},
			"harvested_at": {""},
			"honey_kind":   {"", "acacia"},
			"unit":         {"", "box"},
			"unit_count":   {0, 1001, 1.5},
			"net_kg":       {0, -1, 100000.5},
		})
	checkValues(t, app, harvestHive,
		map[string][]any{
			"withdrawal_treatment_id":    {"", testTreatment},
			"withdrawal_override_reason": {"", "removed_early", "not_for_sale"},
		},
		map[string][]any{
			"harvest_id":                 {""},
			"hive_id":                    {"", "hive-1"},
			"withdrawal_override_reason": {"other"},
		})
	checkValues(t, app, document,
		map[string][]any{
			"type":             {"custom", "analysis_report"},
			"custom_type_name": {"", long(60)},
			"name":             {long(120)},
			"description":      {"", long(500)},
			"expires_on":       {"", "2027-01-31"},
			"byte_size":        {1, 20971520},
			"storage_path": {
				testOrg + "/" + testDocument + "/" + testDocumentFile + ".jpg",
				// Supabase's file part is 36 hex-or-hyphen characters.
				testOrg + "/" + testDocument + "/" + strings.Repeat("a", 36) + ".pdf",
			},
		},
		map[string][]any{
			"type":             {"", "invoice"},
			"file_kind":        {"", "png"},
			"name":             {"", long(121)},
			"custom_type_name": {long(61)},
			"description":      {long(501)},
			"expires_on":       {"2027-1-31", "31.01.2027", testTime},
			"byte_size":        {0, 20971521, 1.5},
			"storage_path": {
				"",
				testOrg + "/" + testDocument + "/" + testDocumentFile + ".png",
				testOrg + "/" + testDocumentFile + ".pdf",
				strings.ToUpper(testOrg) + "/" + testDocument + "/" + testDocumentFile + ".pdf",
				"../" + testDocument + "/" + testDocumentFile + ".pdf",
				testOrg + "/" + testDocument + "/" + testDocumentFile + ".pdf/x",
			},
		})
	checkValues(t, app, migration,
		map[string][]any{
			"year": {2000, 2100},
			"name": {long(120)},
		},
		map[string][]any{
			"year": {0, 1999, 2101, 2026.5},
			"name": {"", long(121)},
		})
	checkValues(t, app, migrationStop,
		map[string][]any{
			"position":   {1, 1000},
			"place":      {"", "Erdemli, Mersin", long(120)},
			"apiary_id":  {"", testApiary},
			"hive_count": {nil, 0, 100000},
			"status":     {"past", "current"},
		},
		map[string][]any{
			"migration_id":     {""},
			"position":         {0, 1001, 1.5},
			"name":             {""},
			"place":            {long(121)},
			"planned_start_on": {"", "2026-13-01"},
			"planned_end_on":   {""},
			"status":           {"", "done"},
		})
	checkValues(t, app, transport,
		map[string][]any{
			"migration_stop_id": {"", testMigrationStop},
			"vehicles":          {[]string{}, []string{"Kamyon 1", "Kamyon 2"}},
			"status":            {"unloading", "completed"},
			"completed_at":      {"", testTime},
		},
		map[string][]any{
			"source_apiary_id":      {""},
			"destination_apiary_id": {"", "apiary-2"},
			"status":                {"", "done"},
			"vehicles":              {"[" + strings.Repeat(`"x",`, 5000) + `"x"]`},
		})
	checkValues(t, app, transportItem,
		map[string][]any{
			"vehicle":     {long(60)},
			"unloaded_at": {"", testTime},
		},
		map[string][]any{
			"transport_id": {""},
			"hive_id":      {""},
			"vehicle":      {"", long(61)},
			"loaded_at":    {""},
		})
}

// Null and 0 stay apart for the nullable numbers; vehicles keeps `[]`.
func TestTaskHarvestDocumentNullables(t *testing.T) {
	app := newApp(t)

	stop := newRow(t, app, "migration_stops", testMigrationStop, 1)
	stop.Set("migration_id", testMigration)
	stop.Set("position", 1)
	stop.Set("name", "Çam")
	stop.Set("planned_start_on", "2026-06-01")
	stop.Set("planned_end_on", "2026-06-01")
	stop.Set("status", "current")
	stop.Set("hive_count", 0)
	if err := app.Save(stop); err != nil {
		t.Fatal(err)
	}

	task := newRow(t, app, "tasks", testTask, 2)
	task.Set("due_at", testTime)
	task.Set("source", "inspection")
	task.Set("source_id", testInspection)
	task.Set("dose", nil)
	if err := app.Save(task); err != nil {
		t.Fatal(err)
	}

	transport := newRow(t, app, "transports", testTransport, 3)
	transport.Set("source_apiary_id", testApiary)
	transport.Set("destination_apiary_id", testOtherApiary)
	transport.Set("vehicles", []string{})
	transport.Set("status", "loading")
	if err := app.Save(transport); err != nil {
		t.Fatal(err)
	}

	got, err := app.FindRecordById("migration_stops", testMigrationStop)
	if err != nil {
		t.Fatal(err)
	}
	if raw := got.GetString("hive_count"); raw != "0" {
		t.Errorf("hive_count 0 stored as %q", raw)
	}
	gotTask, err := app.FindRecordById("tasks", testTask)
	if err != nil {
		t.Fatal(err)
	}
	for _, f := range []string{"dose", "source_step"} {
		if raw := gotTask.GetString(f); raw != "" && raw != "null" {
			t.Errorf("null %s stored as %q", f, raw)
		}
	}
	gotTransport, err := app.FindRecordById("transports", testTransport)
	if err != nil {
		t.Fatal(err)
	}
	if raw := gotTransport.GetString("vehicles"); raw != "[]" {
		t.Errorf("empty vehicles stored as %q", raw)
	}
}

// A hive is in a harvest once among live rows; a deleted row frees the pair.
func TestHarvestHivesUniqueAmongLive(t *testing.T) {
	app := newApp(t)
	row := func(id string, seq int, harvestID string) *core.Record {
		r := newRow(t, app, "harvest_hives", id, seq)
		r.Set("harvest_id", harvestID)
		r.Set("hive_id", testHive)
		return r
	}

	first := row("0195f2a4-e1e1-7000-8000-000000000001", 1, testHarvest)
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}
	if err := app.Save(row("0195f2a4-e1e1-7000-8000-000000000002", 2, testHarvest)); err == nil {
		t.Fatal("same hive saved twice in one harvest")
	}
	// Another harvest is fine.
	if err := app.Save(row("0195f2a4-e1e1-7000-8000-000000000003", 3, "0195f2a4-d2d2-7000-8000-000000000002")); err != nil {
		t.Fatalf("other harvest: %v", err)
	}
	// After the soft delete the hive can be added again.
	first.Set("deleted_at", testTime)
	first.Set("server_seq", 4)
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}
	if err := app.Save(row("0195f2a4-e1e1-7000-8000-000000000004", 5, testHarvest)); err != nil {
		t.Fatalf("re-add after delete: %v", err)
	}
}

func TestDownTasksHarvestsDocumentsMigrations(t *testing.T) {
	app := newApp(t)
	if err := downTasksHarvestsDocumentsMigrations(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range taskHarvestDocumentCollections {
		if _, err := app.FindCollectionByNameOrId(name); err == nil {
			t.Errorf("%s still exists", name)
		}
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}
	for _, name := range inspectionTreatmentCollections {
		if _, err := app.FindCollectionByNameOrId(name); err != nil {
			t.Errorf("%s removed: %v", name, err)
		}
	}
	if err := upTasksHarvestsDocumentsMigrations(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
