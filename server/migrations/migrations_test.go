package migrations

import (
	"slices"
	"strings"
	"testing"

	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
	"github.com/pocketbase/pocketbase/tools/dbutils"
)

const (
	testOrg  = "0195f2a4-1111-7000-8000-000000000001"
	testUser = "0195f2a4-2222-7000-8000-000000000002"
	testTime = "2026-11-10T10:15:30.123456Z"
)

// newApp opens an empty app with every migration of this package applied.
// No hooks: these tests look at the schema and field validation only.
func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	return app
}

// fieldSpec is how a field must look: "type" plus "!" when required.
type fieldSpec map[string]string

func describeFields(c *core.Collection) fieldSpec {
	out := fieldSpec{}
	for _, f := range c.Fields {
		spec := f.Type()
		if isRequired(f) {
			spec += "!"
		}
		out[f.GetName()] = spec
	}
	return out
}

func isRequired(f core.Field) bool {
	switch f := f.(type) {
	case *core.TextField:
		return f.Required || f.PrimaryKey
	case *core.NumberField:
		return f.Required
	case *core.SelectField:
		return f.Required
	case *core.EmailField:
		return f.Required
	case *core.JSONField:
		return f.Required
	}
	return false
}

// describeIndexes returns "name|unique|columns|where" per index, sorted.
func describeIndexes(c *core.Collection) []string {
	var out []string
	for _, raw := range c.Indexes {
		idx := dbutils.ParseIndex(raw)
		var cols []string
		for _, col := range idx.Columns {
			cols = append(cols, col.Name)
		}
		out = append(out, strings.Join([]string{
			idx.IndexName,
			map[bool]string{true: "unique", false: ""}[idx.Unique],
			strings.Join(cols, ","),
			idx.Where,
		}, "|"))
	}
	slices.Sort(out)
	return out
}

var commonSyncFields = fieldSpec{
	"id":         "text!",
	"created_at": "text!",
	"updated_at": "text!",
	"created_by": "text",
	"deleted_at": "text",
	"server_seq": "number!",
}

func with(base fieldSpec, extra fieldSpec) fieldSpec {
	out := fieldSpec{}
	for k, v := range base {
		out[k] = v
	}
	for k, v := range extra {
		out[k] = v
	}
	return out
}

func TestCollectionShapes(t *testing.T) {
	app := newApp(t)

	cases := []struct {
		name    string
		fields  fieldSpec
		indexes []string
	}{
		{
			name: "organizations",
			fields: with(commonSyncFields, fieldSpec{
				"name":               "text!",
				"country_code":       "text!",
				"currency":           "text!",
				"tr_registration_no": "text",
				"tr_aks_no":          "text",
				"hive_count_range":   "select",
				"tr_aks_hive_count":  "json",
				"operation_type":     "select!",
				"avatar_color":       "select",
				"logo_path":          "text",
			}),
			indexes: []string{
				"idx_organizations_server_seq|unique|server_seq|",
			},
		},
		{
			name: "memberships",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":                 "text!",
				"user_id":                "text!",
				"role":                   "select!",
				"deletion_scheduled_for": "text",
			}),
			indexes: []string{
				"idx_memberships_org_id_server_seq||org_id,server_seq|",
				"idx_memberships_org_id_user_id|unique|org_id,user_id|`deleted_at` = ''",
				"idx_memberships_server_seq|unique|server_seq|",
				"idx_memberships_user_id||user_id|",
			},
		},
		{
			name:   "sync_meta",
			fields: fieldSpec{"id": "text!", "last_seq": "number"},
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
			// K-7: only server code reads and writes.
			for rule, v := range map[string]*string{
				"list": c.ListRule, "view": c.ViewRule, "create": c.CreateRule,
				"update": c.UpdateRule, "delete": c.DeleteRule,
			} {
				if v != nil {
					t.Errorf("%s rule = %q, want nil", rule, *v)
				}
			}
			// K-5: no PocketBase autodate fields on sync collections.
			for _, f := range c.Fields {
				if f.Type() == core.FieldTypeAutodate {
					t.Errorf("autodate field %q", f.GetName())
				}
			}
		})
	}
}

func TestSelectValuesMatchSupabaseEnums(t *testing.T) {
	app := newApp(t)
	want := map[string]map[string][]string{
		"organizations": {
			"hive_count_range": {"none", "up_to_10", "up_to_50", "up_to_200", "over_200"},
			"operation_type":   {"migratory", "stationary"},
			"avatar_color":     {"pine", "honey", "sky", "slate"},
		},
		"memberships": {
			"role": {"owner", "partner", "worker", "viewer"},
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

func TestUsersCollection(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	if c.Type != core.CollectionTypeAuth {
		t.Fatalf("type = %s, want auth", c.Type)
	}
	for _, name := range []string{"email", "verified", "locale"} {
		if c.Fields.GetByName(name) == nil {
			t.Errorf("missing field %q", name)
		}
	}
	for _, name := range []string{"name", "avatar"} {
		if c.Fields.GetByName(name) != nil {
			t.Errorf("field %q should be removed", name)
		}
	}

	newUser := func(id, locale string) *core.Record {
		r := core.NewRecord(c)
		r.Id = id
		r.SetEmail("u@example.com")
		r.SetPassword("12345678901234")
		r.Set("locale", locale)
		return r
	}
	if err := app.Validate(newUser(testUser, "tr")); err != nil {
		t.Errorf("valid user rejected: %v", err)
	}
	for _, l := range locales {
		if err := app.Validate(newUser(testUser, l)); err != nil {
			t.Errorf("locale %q rejected: %v", l, err)
		}
	}
	for _, l := range []string{"TR", "it", "en-US", "e"} {
		if err := app.Validate(newUser(testUser, l)); err == nil {
			t.Errorf("locale %q accepted", l)
		}
	}
	if err := app.Validate(newUser("abcdefghijklmno", "en")); err == nil {
		t.Error("PocketBase-style id accepted")
	}
}

// newMembership is a valid memberships row; tests change one field.
func newMembership(t *testing.T, app core.App, id string) *core.Record {
	t.Helper()
	c, err := app.FindCollectionByNameOrId("memberships")
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = id
	r.Set("org_id", testOrg)
	r.Set("user_id", testUser)
	r.Set("role", "worker")
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	r.Set("server_seq", 1)
	return r
}

func TestCommonFieldPatterns(t *testing.T) {
	app := newApp(t)
	const id = "0195f2a4-3333-7000-8000-000000000003"

	if err := app.Validate(newMembership(t, app, id)); err != nil {
		t.Fatalf("valid row rejected: %v", err)
	}

	validUUIDs := []string{
		"0195f2a4-3333-7000-8000-000000000003",
		"00000000-0000-0000-0000-000000000000",
		"ffffffff-ffff-4fff-bfff-ffffffffffff",
	}
	invalidUUIDs := []string{
		"0195F2A4-3333-7000-8000-000000000003",  // upper case
		"0195f2a43333700080000000000000000003",  // no hyphens
		"0195f2a4-3333-7000-8000-00000000000",   // short
		"0195f2a4-3333-7000-8000-0000000000033", // long
		"{0195f2a4-3333-7000-8000-000000000003}",
		"0195f2a4-3333-7000-8000-00000000000g",
		"abcdefghijklmno", // PocketBase default id
	}
	validTimes := []string{
		testTime,
		"2026-01-01T00:00:00.000000Z",
		"2026-12-31T23:59:59.999999Z",
	}
	invalidTimes := []string{
		"2026-11-10T10:15:30Z",             // no fraction
		"2026-11-10T10:15:30.123Z",         // milliseconds
		"2026-11-10T10:15:30.123456+00:00", // offset instead of Z
		"2026-11-10 10:15:30.123456Z",      // space
		"2026-13-10T10:15:30.123456Z",      // month 13
		"2026-11-10T24:15:30.123456Z",      // hour 24
		"2026-11-10T10:15:30.123456z",
		"2026-11-10",
	}

	type check struct {
		field  string
		values []string
		valid  bool
	}
	checks := []check{
		{"org_id", validUUIDs, true}, {"org_id", invalidUUIDs, false},
		{"user_id", validUUIDs, true}, {"user_id", invalidUUIDs, false},
		{"created_by", validUUIDs, true}, {"created_by", invalidUUIDs, false},
		{"created_at", validTimes, true}, {"created_at", invalidTimes, false},
		{"updated_at", validTimes, true}, {"updated_at", invalidTimes, false},
		{"deleted_at", validTimes, true}, {"deleted_at", invalidTimes, false},
		{"deletion_scheduled_for", validTimes, true}, {"deletion_scheduled_for", invalidTimes, false},
	}
	for _, c := range checks {
		for _, v := range c.values {
			r := newMembership(t, app, id)
			r.Set(c.field, v)
			err := app.Validate(r)
			if c.valid && err != nil {
				t.Errorf("%s=%q rejected: %v", c.field, v, err)
			}
			if !c.valid && err == nil {
				t.Errorf("%s=%q accepted", c.field, v)
			}
		}
	}

	for _, v := range validUUIDs {
		if err := app.Validate(newMembership(t, app, v)); err != nil {
			t.Errorf("id %q rejected: %v", v, err)
		}
	}
	for _, v := range invalidUUIDs {
		if err := app.Validate(newMembership(t, app, v)); err == nil {
			t.Errorf("id %q accepted", v)
		}
	}

	// Required and optional fields.
	for _, field := range []string{"org_id", "user_id", "role", "created_at", "updated_at"} {
		r := newMembership(t, app, id)
		r.Set(field, "")
		if err := app.Validate(r); err == nil {
			t.Errorf("empty %s accepted", field)
		}
	}
	r := newMembership(t, app, id)
	r.Set("server_seq", 0)
	if err := app.Validate(r); err == nil {
		t.Error("server_seq 0 accepted")
	}
	r = newMembership(t, app, id)
	r.Set("server_seq", 1.5)
	if err := app.Validate(r); err == nil {
		t.Error("fractional server_seq accepted")
	}
	r = newMembership(t, app, id)
	r.Set("role", "admin")
	if err := app.Validate(r); err == nil {
		t.Error("unknown role accepted")
	}
}

func TestOrganizationFields(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId("organizations")
	if err != nil {
		t.Fatal(err)
	}
	newOrg := func() *core.Record {
		r := core.NewRecord(c)
		r.Id = testOrg
		r.Set("name", "Tutun Arıcılık")
		r.Set("country_code", "TR")
		r.Set("currency", "TRY")
		r.Set("operation_type", "migratory")
		r.Set("created_at", testTime)
		r.Set("updated_at", testTime)
		r.Set("server_seq", 1)
		return r
	}
	if err := app.Validate(newOrg()); err != nil {
		t.Fatalf("valid organization rejected: %v", err)
	}

	accepted := map[string][]any{
		"tr_aks_hive_count": {nil, 0, 120},
		"logo_path":         {"", testOrg + "/0195f2a4-4444-7000-8000-000000000004.jpg"},
		"hive_count_range":  {"", "up_to_50"},
		"avatar_color":      {"", "sky"},
	}
	rejected := map[string][]any{
		"name":              {""},
		"country_code":      {"tr", "TUR", "", "T1"},
		"currency":          {"try", "TL", "", "TRYY"},
		"operation_type":    {"", "nomad"},
		"hive_count_range":  {"many"},
		"avatar_color":      {"red"},
		"logo_path":         {testOrg + "/logo.jpg", testOrg + "/0195f2a4-4444-7000-8000-000000000004.png"},
		"tr_aks_hive_count": {"x" + strings.Repeat("9", 40)},
	}
	for field, values := range accepted {
		for _, v := range values {
			r := newOrg()
			r.Set(field, v)
			if err := app.Validate(r); err != nil {
				t.Errorf("%s=%v rejected: %v", field, v, err)
			}
		}
	}
	for field, values := range rejected {
		for _, v := range values {
			r := newOrg()
			r.Set(field, v)
			if err := app.Validate(r); err == nil {
				t.Errorf("%s=%v accepted", field, v)
			}
		}
	}

	// Null and 0 stay apart (decision 2026-11-10).
	r := newOrg()
	r.Set("tr_aks_hive_count", nil)
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	got, err := app.FindRecordById("organizations", testOrg)
	if err != nil {
		t.Fatal(err)
	}
	if raw := got.GetString("tr_aks_hive_count"); raw != "" && raw != "null" {
		t.Errorf("null stored as %q", raw)
	}
	got.Set("tr_aks_hive_count", 0)
	got.Set("server_seq", 2)
	if err := app.Save(got); err != nil {
		t.Fatal(err)
	}
	got, _ = app.FindRecordById("organizations", testOrg)
	if raw := got.GetString("tr_aks_hive_count"); raw != "0" {
		t.Errorf("0 stored as %q", raw)
	}
}

func TestOneLiveMembershipPerUser(t *testing.T) {
	app := newApp(t)
	first := newMembership(t, app, "0195f2a4-5555-7000-8000-000000000001")
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}

	second := newMembership(t, app, "0195f2a4-5555-7000-8000-000000000002")
	second.Set("server_seq", 2)
	if err := app.Save(second); err == nil {
		t.Fatal("second live membership saved")
	}

	// Another organization is fine.
	other := newMembership(t, app, "0195f2a4-5555-7000-8000-000000000003")
	other.Set("org_id", "0195f2a4-1111-7000-8000-000000000099")
	other.Set("server_seq", 3)
	if err := app.Save(other); err != nil {
		t.Fatalf("membership in another organization: %v", err)
	}

	// A removed member can be added again.
	first.Set("deleted_at", testTime)
	first.Set("server_seq", 4)
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}
	again := newMembership(t, app, "0195f2a4-5555-7000-8000-000000000004")
	again.Set("server_seq", 5)
	if err := app.Save(again); err != nil {
		t.Fatalf("re-adding a removed member: %v", err)
	}
}

func TestServerSeqUnique(t *testing.T) {
	app := newApp(t)
	if err := app.Save(newMembership(t, app, "0195f2a4-6666-7000-8000-000000000001")); err != nil {
		t.Fatal(err)
	}
	dup := newMembership(t, app, "0195f2a4-6666-7000-8000-000000000002")
	dup.Set("user_id", "0195f2a4-2222-7000-8000-000000000099")
	if err := app.Save(dup); err == nil {
		t.Fatal("duplicate server_seq saved")
	}
}

func TestSyncMetaRow(t *testing.T) {
	app := newApp(t)
	got, err := appsync.LastSeq(app)
	if err != nil {
		t.Fatal(err)
	}
	if got != 0 {
		t.Errorf("last_seq = %d, want 0", got)
	}
	n, err := app.CountRecords(appsync.MetaCollection)
	if err != nil {
		t.Fatal(err)
	}
	if n != 1 {
		t.Errorf("sync_meta rows = %d, want 1", n)
	}
}

func TestDownMigrations(t *testing.T) {
	app := newApp(t)

	if err := downOrganizationsMemberships(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range []string{"organizations", "memberships"} {
		if _, err := app.FindCollectionByNameOrId(name); err == nil {
			t.Errorf("%s still exists", name)
		}
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}

	if err := downUsers(app); err != nil {
		t.Fatal(err)
	}
	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	if users.Fields.GetByName("locale") != nil || users.Fields.GetByName("name") == nil {
		t.Error("users not restored")
	}
	if id := users.Fields.GetByName("id").(*core.TextField); id.Pattern != "^[a-z0-9]+$" {
		t.Errorf("users id pattern = %q", id.Pattern)
	}

	if err := downSyncMeta(app); err != nil {
		t.Fatal(err)
	}
	if app.HasTable(appsync.MetaCollection) {
		t.Error("sync_meta still exists")
	}
}

func mapsEqual(a, b fieldSpec) bool {
	if len(a) != len(b) {
		return false
	}
	for k, v := range a {
		if b[k] != v {
			return false
		}
	}
	return true
}
