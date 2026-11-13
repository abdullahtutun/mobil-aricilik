package migrations

import (
	"slices"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

func TestApiaryHiveCollectionShapes(t *testing.T) {
	app := newApp(t)

	cases := []struct {
		name    string
		fields  fieldSpec
		indexes []string
	}{
		{
			name: "apiaries",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":             "text!",
				"name":               "text!",
				"latitude":           "json",
				"longitude":          "json",
				"altitude_m":         "json",
				"land_tenure":        "select",
				"water_source":       "text",
				"vehicle_distance_m": "json",
				"road_notes":         "text",
				"notes":              "text",
			}),
			indexes: []string{
				"idx_apiaries_org_id_server_seq||org_id,server_seq|",
				"idx_apiaries_server_seq|unique|server_seq|",
			},
		},
		{
			name: "queens",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":          "text!",
				"year":            "json",
				"mark_color":      "select",
				"breed":           "text",
				"breed_line":      "text",
				"source":          "select",
				"mating_status":   "select",
				"wing_clipped":    "bool",
				"mother_queen_id": "text",
			}),
			indexes: []string{
				"idx_queens_mother_queen_id||mother_queen_id|",
				"idx_queens_org_id_server_seq||org_id,server_seq|",
				"idx_queens_server_seq|unique|server_seq|",
			},
		},
		{
			name: "hives",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":             "text!",
				"number":             "text!",
				"tag_code":           "text",
				"type":               "select!",
				"status":             "select!",
				"apiary_id":          "text!",
				"queen_id":           "text",
				"box_count":          "number!",
				"frame_count":        "json",
				"source":             "select",
				"marking":            "text",
				"quarantined":        "bool",
				"quarantined_at":     "text",
				"quarantine_disease": "text",
			}),
			indexes: []string{
				"idx_hives_apiary_id||apiary_id|",
				"idx_hives_org_id_server_seq||org_id,server_seq|",
				"idx_hives_org_id_tag_code|unique|org_id,tag_code|`tag_code` != '' AND `deleted_at` = ''",
				"idx_hives_queen_id||queen_id|",
				"idx_hives_server_seq|unique|server_seq|",
			},
		},
		{
			name: "hive_location_history",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":    "text!",
				"hive_id":   "text!",
				"apiary_id": "text!",
				"moved_at":  "text!",
			}),
			indexes: []string{
				"idx_hive_location_history_apiary_id||apiary_id|",
				"idx_hive_location_history_hive_id||hive_id|",
				"idx_hive_location_history_org_id_server_seq||org_id,server_seq|",
				"idx_hive_location_history_server_seq|unique|server_seq|",
			},
		},
		{
			name: "hive_status_events",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":      "text!",
				"hive_id":     "text!",
				"apiary_id":   "text!",
				"from_status": "select!",
				"to_status":   "select!",
				"changed_at":  "text!",
				"loss_reason": "select",
			}),
			indexes: []string{
				"idx_hive_status_events_hive_id||hive_id|",
				"idx_hive_status_events_org_id_server_seq||org_id,server_seq|",
				"idx_hive_status_events_server_seq|unique|server_seq|",
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

func TestApiaryHiveSelectValues(t *testing.T) {
	app := newApp(t)
	statuses := []string{"active", "dead", "merged", "sold", "lost"}
	want := map[string]map[string][]string{
		"apiaries": {
			"land_tenure": {"owned", "rented", "permitted"},
		},
		"queens": {
			"mark_color":    {"white", "yellow", "red", "green", "blue"},
			"source":        {"own_rearing", "purchased", "certified_breeder"},
			"mating_status": {"virgin", "mated"},
		},
		"hives": {
			"type":   {"langstroth", "dadant", "local", "other"},
			"status": statuses,
			"source": {"swarm", "split", "purchase", "package"},
		},
		"hive_status_events": {
			"from_status": statuses,
			"to_status":   statuses,
			"loss_reason": {
				"wintering", "queenless", "varroa", "disease", "starvation",
				"robbing", "predator", "poisoning", "other",
			},
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

const (
	testApiary = "0195f2a4-aaaa-7000-8000-000000000001"
	testQueen  = "0195f2a4-bbbb-7000-8000-000000000001"
)

// newRow is a row of collection with the common fields set; tests add the
// rest.
func newRow(t *testing.T, app core.App, collection, id string, seq int) *core.Record {
	t.Helper()
	c, err := app.FindCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = id
	r.Set("org_id", testOrg)
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	r.Set("server_seq", seq)
	return r
}

func newHive(t *testing.T, app core.App, id string, seq int) *core.Record {
	t.Helper()
	r := newRow(t, app, "hives", id, seq)
	r.Set("number", "101")
	r.Set("type", "langstroth")
	r.Set("status", "active")
	r.Set("apiary_id", testApiary)
	r.Set("box_count", 1)
	return r
}

// checkValues saves base with each value of field and expects acceptance or
// rejection.
func checkValues(t *testing.T, app core.App, base func() *core.Record, accepted, rejected map[string][]any) {
	t.Helper()
	for field, values := range accepted {
		for _, v := range values {
			r := base()
			r.Set(field, v)
			if err := app.Validate(r); err != nil {
				t.Errorf("%s.%s=%v rejected: %v", r.Collection().Name, field, v, err)
			}
		}
	}
	for field, values := range rejected {
		for _, v := range values {
			r := base()
			r.Set(field, v)
			if err := app.Validate(r); err == nil {
				t.Errorf("%s.%s=%v accepted", r.Collection().Name, field, v)
			}
		}
	}
}

func TestApiaryHiveFields(t *testing.T) {
	app := newApp(t)

	apiary := func() *core.Record {
		r := newRow(t, app, "apiaries", testApiary, 1)
		r.Set("name", "Yayla")
		return r
	}
	queen := func() *core.Record { return newRow(t, app, "queens", testQueen, 1) }
	hive := func() *core.Record { return newHive(t, app, "0195f2a4-cccc-7000-8000-000000000001", 1) }
	history := func() *core.Record {
		r := newRow(t, app, "hive_location_history", "0195f2a4-dddd-7000-8000-000000000001", 1)
		r.Set("hive_id", "0195f2a4-cccc-7000-8000-000000000001")
		r.Set("apiary_id", testApiary)
		r.Set("moved_at", testTime)
		return r
	}
	event := func() *core.Record {
		r := newRow(t, app, "hive_status_events", "0195f2a4-eeee-7000-8000-000000000001", 1)
		r.Set("hive_id", "0195f2a4-cccc-7000-8000-000000000001")
		r.Set("apiary_id", testApiary)
		r.Set("from_status", "active")
		r.Set("to_status", "dead")
		r.Set("changed_at", testTime)
		return r
	}
	for _, base := range []func() *core.Record{apiary, queen, hive, history, event} {
		r := base()
		if err := app.Validate(r); err != nil {
			t.Fatalf("valid %s rejected: %v", r.Collection().Name, err)
		}
	}

	checkValues(t, app, apiary,
		map[string][]any{
			"latitude":    {nil, 39.92, -90, 90},
			"longitude":   {nil, 32.85, -180, 180},
			"land_tenure": {"", "rented"},
		},
		map[string][]any{
			"name":        {""},
			"land_tenure": {"leased"},
			// Type and range are validate.ApiariesLocationCheck; the field
			// only caps the size.
			"latitude": {"x" + strings.Repeat("9", 40)},
		})
	checkValues(t, app, queen,
		map[string][]any{
			"year":            {nil, 2026},
			"mark_color":      {"", "blue"},
			"source":          {"", "purchased"},
			"mating_status":   {"", "virgin"},
			"wing_clipped":    {true, false},
			"mother_queen_id": {"", "0195f2a4-bbbb-7000-8000-000000000002"},
		},
		map[string][]any{
			"mark_color":      {"black"},
			"source":          {"swarm"},
			"mating_status":   {"drone_layer"},
			"mother_queen_id": {"queen-1"},
		})
	checkValues(t, app, hive,
		map[string][]any{
			"status":         {"active", "dead", "merged", "sold", "lost"},
			"box_count":      {1, 32767},
			"frame_count":    {nil, 0, 10},
			"queen_id":       {"", testQueen},
			"source":         {"", "swarm"},
			"quarantined_at": {"", testTime},
		},
		map[string][]any{
			"number":         {""},
			"type":           {"", "top_bar"},
			"status":         {"", "quarantined"},
			"apiary_id":      {"", "apiary-1"},
			"queen_id":       {"queen-1"},
			"box_count":      {0, -1, 1.5, 32768},
			"quarantined_at": {"2026-11-10"},
		})
	checkValues(t, app, history,
		nil,
		map[string][]any{
			"hive_id":   {"", "hive-1"},
			"apiary_id": {""},
			"moved_at":  {"", "2026-11-10T10:15:30Z"},
		})
	checkValues(t, app, event,
		map[string][]any{
			"loss_reason": {"", "varroa", "wintering"},
		},
		map[string][]any{
			"from_status": {"", "gone"},
			"to_status":   {""},
			"changed_at":  {""},
			"loss_reason": {"bears"},
			"hive_id":     {""},
		})
}

// Null and 0 stay apart for the coordinates (0, 0 is a real place).
func TestApiaryLocationNullAndZero(t *testing.T) {
	app := newApp(t)
	r := newRow(t, app, "apiaries", testApiary, 1)
	r.Set("name", "Yayla")
	r.Set("latitude", nil)
	r.Set("longitude", nil)
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	got, err := app.FindRecordById("apiaries", testApiary)
	if err != nil {
		t.Fatal(err)
	}
	for _, f := range []string{"latitude", "longitude"} {
		if raw := got.GetString(f); raw != "" && raw != "null" {
			t.Errorf("null %s stored as %q", f, raw)
		}
	}

	got.Set("latitude", 0)
	got.Set("longitude", 0)
	got.Set("server_seq", 2)
	if err := app.Save(got); err != nil {
		t.Fatal(err)
	}
	got, _ = app.FindRecordById("apiaries", testApiary)
	for _, f := range []string{"latitude", "longitude"} {
		if raw := got.GetString(f); raw != "0" {
			t.Errorf("0 %s stored as %q", f, raw)
		}
	}

	got.Set("latitude", 39.925533)
	got.Set("longitude", 32.866287)
	got.Set("server_seq", 3)
	if err := app.Save(got); err != nil {
		t.Fatal(err)
	}
	got, _ = app.FindRecordById("apiaries", testApiary)
	if got.GetString("latitude") != "39.925533" || got.GetString("longitude") != "32.866287" {
		t.Errorf("coordinates stored as %q, %q", got.GetString("latitude"), got.GetString("longitude"))
	}
}

func TestHiveTagCodeUnique(t *testing.T) {
	app := newApp(t)
	seq := 0
	next := func() int { seq++; return seq }
	hive := func(id, tag string) *core.Record {
		r := newHive(t, app, id, next())
		r.Set("tag_code", tag)
		return r
	}

	first := hive("0195f2a4-cccc-7000-8000-000000000001", "QR-0001")
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}
	if err := app.Save(hive("0195f2a4-cccc-7000-8000-000000000002", "QR-0001")); err == nil {
		t.Fatal("second live hive with the same tag saved")
	}

	// The same tag in another organization is fine.
	other := hive("0195f2a4-cccc-7000-8000-000000000003", "QR-0001")
	other.Set("org_id", "0195f2a4-1111-7000-8000-000000000099")
	if err := app.Save(other); err != nil {
		t.Fatalf("same tag in another organization: %v", err)
	}

	// Hives without a tag never collide.
	for _, id := range []string{"0195f2a4-cccc-7000-8000-000000000004", "0195f2a4-cccc-7000-8000-000000000005"} {
		if err := app.Save(hive(id, "")); err != nil {
			t.Fatalf("untagged hive %s: %v", id, err)
		}
	}

	// A deleted hive's tag can be reused.
	first.Set("deleted_at", testTime)
	first.Set("server_seq", next())
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}
	reuse := hive("0195f2a4-cccc-7000-8000-000000000006", "QR-0001")
	if err := app.Save(reuse); err != nil {
		t.Fatalf("reusing a deleted hive's tag: %v", err)
	}

	// Restoring the deleted hive now collides with the new owner of the tag.
	first.Set("deleted_at", "")
	first.Set("server_seq", next())
	if err := app.Save(first); err == nil {
		t.Fatal("restored hive took a tag in use")
	}
}

func TestDownApiariesHivesQueens(t *testing.T) {
	app := newApp(t)
	if err := downApiariesHivesQueens(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range apiaryHiveCollections {
		if _, err := app.FindCollectionByNameOrId(name); err == nil {
			t.Errorf("%s still exists", name)
		}
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}
	// The earlier collections stay.
	for _, name := range []string{"organizations", "memberships"} {
		if _, err := app.FindCollectionByNameOrId(name); err != nil {
			t.Errorf("%s removed: %v", name, err)
		}
	}
	if err := upApiariesHivesQueens(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
