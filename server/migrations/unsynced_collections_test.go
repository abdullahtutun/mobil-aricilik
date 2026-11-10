package migrations

import (
	"slices"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

const (
	testInvite       = "0195f2a4-b1b1-7000-8000-000000000001"
	testDeviceToken  = "0195f2a4-b2b2-7000-8000-000000000001"
	testFeedback     = "0195f2a4-b3b3-7000-8000-000000000001"
	testEvent        = "0195f2a4-b4b4-7000-8000-000000000001"
	testInstall      = "0195f2a4-b5b5-7000-8000-000000000001"
	testWeather      = "0195f2a4-b6b6-7000-8000-000000000001"
	testRequest      = "0195f2a4-b7b7-7000-8000-000000000001"
	testDeletionLog  = "0195f2a4-b8b8-7000-8000-000000000001"
	testDeletionCode = "0195f2a4-b9b9-7000-8000-000000000001"
	testNotification = "0195f2a4-baba-7000-8000-000000000001"
	testHash         = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"
	testLater        = "2026-11-17T10:15:30.123456Z"
)

func TestUnsyncedCollectionShapes(t *testing.T) {
	app := newApp(t)

	cases := []struct {
		name    string
		fields  fieldSpec
		indexes []string
	}{
		{
			name: "invites",
			fields: fieldSpec{
				"id": "text!", "org_id": "text!", "code": "text!", "role": "select!",
				"created_at": "text!", "created_by": "text!", "expires_at": "text!",
				"used_at": "text", "used_by": "text",
			},
			indexes: []string{
				"idx_invites_code|unique|code|",
				"idx_invites_created_by||created_by|",
				"idx_invites_org_id||org_id|",
				"idx_invites_used_by||used_by|",
			},
		},
		{
			name: "device_tokens",
			fields: fieldSpec{
				"id": "text!", "user_id": "text!", "token": "text!", "platform": "select!",
				"locale": "text", "created_at": "text!", "updated_at": "text!",
			},
			indexes: []string{
				"idx_device_tokens_token|unique|token|",
				"idx_device_tokens_user_id||user_id|",
			},
		},
		{
			name: "feedback",
			fields: fieldSpec{
				"id": "text!", "org_id": "text!", "kind": "select!", "message": "text!",
				"screenshot_path": "text", "device_info": "json",
				"created_at": "text!", "received_at": "text!", "created_by": "text",
			},
			indexes: []string{
				"idx_feedback_created_by||created_by|",
				"idx_feedback_org_id||org_id|",
			},
		},
		{
			name: "analytics_events",
			fields: fieldSpec{
				"id": "text!", "install_id": "text!", "name": "text!", "props": "json",
				"occurred_at": "text!", "app_version": "text", "platform": "select",
				"received_at": "text!",
			},
			indexes: []string{
				"idx_analytics_events_name_occurred_at||name,occurred_at|",
			},
		},
		{
			name: "weather_cache",
			fields: fieldSpec{
				"id": "text!", "cell": "text!", "forecast": "json!", "fetched_at": "text!",
			},
			indexes: []string{"idx_weather_cache_cell|unique|cell|"},
		},
		{
			name: "deletion_requests",
			fields: fieldSpec{
				"id": "text!", "user_id": "text", "org_id": "text", "kind": "select!",
				"requested_at": "text!", "scheduled_for": "text!", "channel": "select!",
				"status": "select!", "delete_org_ids": "json", "user_hash": "text!",
				"email_hash": "text", "storage_prefixes": "json", "purge_started_at": "text",
				"cancelled_at": "text", "completed_at": "text",
			},
			indexes: []string{
				"idx_deletion_requests_due||scheduled_for|`status` = 'bekliyor'",
				"idx_deletion_requests_email_hash||email_hash,requested_at|",
				"idx_deletion_requests_pending_user|unique|user_id|`status` = 'bekliyor' AND `user_id` != ''",
				"idx_deletion_requests_user_id||user_id,requested_at|",
			},
		},
		{
			name: "deletion_log",
			fields: fieldSpec{
				"id": "text!", "request_id": "text!", "user_hash": "text!", "kind": "select!",
				"channel": "select!", "requested_at": "text!", "created": "autodate",
			},
			indexes: []string{"idx_deletion_log_request_id|unique|request_id|"},
		},
		{
			name: "deletion_codes",
			fields: fieldSpec{
				"id": "text!", "user_id": "text!", "code_hash": "text!", "expires_at": "text!",
				"attempts": "number", "verified_at": "text", "sent_at": "text!",
				"window_started_at": "text!", "sent_in_window": "number",
			},
			indexes: []string{"idx_deletion_codes_user_id|unique|user_id|"},
		},
		{
			name:    "support_period_notifications",
			fields:  fieldSpec{"id": "text!", "period_id": "text!", "notified_at": "text!"},
			indexes: []string{"idx_support_period_notifications_period_id|unique|period_id|"},
		},
	}
	if len(cases) != len(unsyncedCollections) {
		t.Fatalf("%d cases for %d collections", len(cases), len(unsyncedCollections))
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
			// Server code only until P3.2.
			for rule, v := range map[string]*string{
				"list": c.ListRule, "view": c.ViewRule, "create": c.CreateRule,
				"update": c.UpdateRule, "delete": c.DeleteRule,
			} {
				if v != nil {
					t.Errorf("%s rule = %q, want nil", rule, *v)
				}
			}
			if c.Fields.GetByName(fieldServerSeq) != nil {
				t.Error("not synced, but has server_seq")
			}
			id := c.Fields.GetByName("id").(*core.TextField)
			if id.Min != 36 || id.Max != 36 || id.AutogeneratePattern != "" {
				t.Errorf("id is not the UUID primary key (K-4): %+v", id)
			}
		})
	}

	created := mustAutodate(t, app, "deletion_log", "created")
	if !created.OnCreate || created.OnUpdate {
		t.Errorf("deletion_log.created onCreate=%v onUpdate=%v, want set on create only", created.OnCreate, created.OnUpdate)
	}
}

func mustAutodate(t *testing.T, app core.App, collection, field string) *core.AutodateField {
	t.Helper()
	c, err := app.FindCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	f, ok := c.Fields.GetByName(field).(*core.AutodateField)
	if !ok {
		t.Fatalf("%s.%s is not an autodate field", collection, field)
	}
	return f
}

func TestUnsyncedSelectValues(t *testing.T) {
	app := newApp(t)
	want := map[string]map[string][]string{
		"invites":           {"role": {"partner", "worker", "viewer"}},
		"device_tokens":     {"platform": {"android", "ios"}},
		"feedback":          {"kind": {"bug", "suggestion", "missing_feature", "thanks"}},
		"analytics_events":  {"platform": {"android", "ios", "other"}},
		"deletion_requests": {"kind": {"hesap", "hesap_ve_isletme"}, "channel": {"uygulama", "web"}, "status": {"bekliyor", "iptal", "tamamlandi"}},
		"deletion_log":      {"kind": {"hesap", "hesap_ve_isletme"}, "channel": {"uygulama", "web"}},
	}
	for collection, fields := range want {
		c, err := app.FindCollectionByNameOrId(collection)
		if err != nil {
			t.Fatal(err)
		}
		for name, values := range fields {
			f, ok := c.Fields.GetByName(name).(*core.SelectField)
			if !ok {
				t.Errorf("%s.%s is not a select", collection, name)
				continue
			}
			if !slices.Equal(f.Values, values) || f.MaxSelect != 1 {
				t.Errorf("%s.%s = %v (max %d), want %v", collection, name, f.Values, f.MaxSelect, values)
			}
		}
	}
}

// plainRow is a record of collection with only its id set.
func plainRow(t *testing.T, app core.App, collection, id string) *core.Record {
	t.Helper()
	c, err := app.FindCollectionByNameOrId(collection)
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = id
	return r
}

func newInvite(t *testing.T, app core.App, id, code string) *core.Record {
	r := plainRow(t, app, "invites", id)
	r.Set("org_id", testOrg)
	r.Set("code", code)
	r.Set("role", "worker")
	r.Set("created_at", testTime)
	r.Set("created_by", testUser)
	r.Set("expires_at", testLater)
	return r
}

func newDeviceToken(t *testing.T, app core.App, id, token string) *core.Record {
	r := plainRow(t, app, "device_tokens", id)
	r.Set("user_id", testUser)
	r.Set("token", token)
	r.Set("platform", "android")
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	return r
}

func newWeather(t *testing.T, app core.App, id, cell string) *core.Record {
	r := plainRow(t, app, "weather_cache", id)
	r.Set("cell", cell)
	r.Set("forecast", map[string]any{"days": []any{}})
	r.Set("fetched_at", testTime)
	return r
}

func newDeletionRequest(t *testing.T, app core.App, id, status string) *core.Record {
	r := plainRow(t, app, "deletion_requests", id)
	r.Set("user_id", testUser)
	r.Set("kind", "hesap")
	r.Set("requested_at", testTime)
	r.Set("scheduled_for", testLater)
	r.Set("channel", "uygulama")
	r.Set("status", status)
	r.Set("delete_org_ids", []string{})
	r.Set("user_hash", testHash)
	return r
}

func newDeletionLog(t *testing.T, app core.App, id, requestID string) *core.Record {
	r := plainRow(t, app, "deletion_log", id)
	r.Set("request_id", requestID)
	r.Set("user_hash", testHash)
	r.Set("kind", "hesap")
	r.Set("channel", "web")
	r.Set("requested_at", testTime)
	return r
}

func newDeletionCode(t *testing.T, app core.App, id, userID string) *core.Record {
	r := plainRow(t, app, "deletion_codes", id)
	r.Set("user_id", userID)
	r.Set("code_hash", testHash)
	r.Set("expires_at", testLater)
	r.Set("sent_at", testTime)
	r.Set("window_started_at", testTime)
	r.Set("sent_in_window", 1)
	return r
}

func newNotification(t *testing.T, app core.App, id, periodID string) *core.Record {
	r := plainRow(t, app, "support_period_notifications", id)
	r.Set("period_id", periodID)
	r.Set("notified_at", testTime)
	return r
}

func TestUnsyncedFields(t *testing.T) {
	app := newApp(t)

	invite := func() *core.Record { return newInvite(t, app, testInvite, "ABC234") }
	token := func() *core.Record { return newDeviceToken(t, app, testDeviceToken, "fcm-token") }
	feedback := func() *core.Record {
		r := plainRow(t, app, "feedback", testFeedback)
		r.Set("org_id", testOrg)
		r.Set("kind", "bug")
		r.Set("message", "Okutma çalışmıyor")
		r.Set("created_at", testTime)
		r.Set("received_at", testTime)
		return r
	}
	event := func() *core.Record {
		r := plainRow(t, app, "analytics_events", testEvent)
		r.Set("install_id", testInstall)
		r.Set("name", "inspection_saved")
		r.Set("props", map[string]any{"seconds": 42})
		r.Set("occurred_at", testTime)
		r.Set("received_at", testTime)
		return r
	}
	weather := func() *core.Record { return newWeather(t, app, testWeather, "37.11,28.39") }
	request := func() *core.Record { return newDeletionRequest(t, app, testRequest, "bekliyor") }
	logRow := func() *core.Record { return newDeletionLog(t, app, testDeletionLog, testRequest) }
	code := func() *core.Record { return newDeletionCode(t, app, testDeletionCode, testUser) }
	notification := func() *core.Record { return newNotification(t, app, testNotification, testSupportPeriod) }

	for _, base := range []func() *core.Record{invite, token, feedback, event, weather, request, logRow, code, notification} {
		r := base()
		if err := app.Validate(r); err != nil {
			t.Fatalf("valid %s rejected: %v", r.Collection().Name, err)
		}
	}

	long := func(n int) string { return strings.Repeat("ş", n) }
	shot := testOrg + "/" + testFeedback + ".jpg"

	checkValues(t, app, invite,
		map[string][]any{
			"code":    {"ZZZZZZ", "234567", "HJKMNP"},
			"role":    {"partner", "viewer"},
			"used_at": {"", testLater},
			"used_by": {"", testUser},
		},
		map[string][]any{
			"id":         {"", "invite-1", strings.ToUpper(testInvite)},
			"org_id":     {""},
			"code":       {"", "abc234", "ABC23", "ABC2345", "ABC0EF", "ABCOEF", "ABC1EF", "ABCIEF", "ABCLEF"},
			"role":       {"", "owner", "admin"},
			"created_at": {"", "2026-11-10"},
			"created_by": {"", "user-1"},
			"expires_at": {"", "2026-11-12 10:15:30"},
			"used_at":    {"2026-11-11"},
		})
	checkValues(t, app, token,
		map[string][]any{
			"token":    {"x", strings.Repeat("a", 4096)},
			"platform": {"ios"},
			"locale":   {"", "tr", "fa", "hi"},
		},
		map[string][]any{
			"user_id":    {""},
			"token":      {"", strings.Repeat("a", 4097)},
			"platform":   {"", "web", "other"},
			"locale":     {"TR", "tr-TR", "xx"},
			"updated_at": {""},
		})
	checkValues(t, app, feedback,
		map[string][]any{
			"kind":            {"suggestion", "missing_feature", "thanks"},
			"message":         {long(4000)},
			"screenshot_path": {"", shot},
			"device_info":     {nil, map[string]any{"os": "android 15", "app": "1.0.0"}},
			"created_by":      {"", testUser},
		},
		map[string][]any{
			"kind":            {"", "praise"},
			"message":         {"", long(4001)},
			"screenshot_path": {"shot.jpg", testOrg + "/" + testFeedback + ".png", testOrg + "/x/" + testFeedback + ".jpg"},
			"device_info":     {strings.Repeat("a", 2*2048)},
			"received_at":     {""},
		})
	checkValues(t, app, event,
		map[string][]any{
			"name":        {"a", "scan_result", "a" + strings.Repeat("_", 39)},
			"props":       {map[string]any{}, map[string]any{"ok": 1, "ms": 1234}},
			"app_version": {"", "1.2.3+45", strings.Repeat("9", 32)},
			"platform":    {"", "android", "other"},
		},
		map[string][]any{
			"install_id":  {"", "install-1"},
			"name":        {"", "Scan", "1scan", "scan-result", "_scan", "a" + strings.Repeat("_", 40)},
			"app_version": {strings.Repeat("9", 33)},
			"platform":    {"web"},
			"occurred_at": {""},
		})
	checkValues(t, app, weather,
		map[string][]any{
			"cell": {"-9.00,-179.99", "90.00,180.00", "0.00,0.00"},
		},
		map[string][]any{
			"cell":       {"", "37.1,28.39", "37.111,28.39", "137.11,28.39", "37.11,1280.39", "37.11 28.39", "37,11,28,39"},
			"forecast":   {nil, map[string]any{}},
			"fetched_at": {""},
		})
	checkValues(t, app, request,
		map[string][]any{
			"user_id":          {""},
			"org_id":           {"", testOrg},
			"kind":             {"hesap_ve_isletme"},
			"channel":          {"web"},
			"status":           {"iptal", "tamamlandi"},
			"email_hash":       {"", testHash},
			"storage_prefixes": {nil, []any{map[string]any{"bucket": "media", "prefix": testOrg}}},
			"purge_started_at": {"", testLater},
		},
		map[string][]any{
			"kind":          {"", "account"},
			"channel":       {"", "email"},
			"status":        {"", "pending"},
			"user_hash":     {"", "abc", strings.ToUpper(testHash), testHash + "0"},
			"email_hash":    {"xyz"},
			"scheduled_for": {""},
			"cancelled_at":  {"yesterday"},
		})
	checkValues(t, app, logRow,
		map[string][]any{
			"kind":    {"hesap_ve_isletme"},
			"channel": {"uygulama"},
		},
		map[string][]any{
			"request_id":   {"", "request-1"},
			"user_hash":    {""},
			"kind":         {"", "user"},
			"channel":      {"", "api"},
			"requested_at": {""},
		})
	checkValues(t, app, code,
		map[string][]any{
			"attempts":       {0, 5},
			"verified_at":    {"", testTime},
			"sent_in_window": {0, 1, 5},
		},
		map[string][]any{
			"user_id":           {""},
			"code_hash":         {"", "123456"},
			"attempts":          {-1, 1.5},
			"sent_in_window":    {-1},
			"expires_at":        {""},
			"window_started_at": {""},
		})
	checkValues(t, app, notification,
		map[string][]any{},
		map[string][]any{
			"period_id":   {"", "period-1"},
			"notified_at": {""},
		})
}

// Saves r and expects a unique index to reject it when wantOK is false.
func saveExpect(t *testing.T, app core.App, r *core.Record, wantOK bool, what string) {
	t.Helper()
	err := app.Save(r)
	if wantOK && err != nil {
		t.Errorf("%s rejected: %v", what, err)
	}
	if !wantOK && err == nil {
		t.Errorf("%s accepted", what)
	}
}

func TestUnsyncedUniqueKeys(t *testing.T) {
	app := newApp(t)
	id := func(n string) string { return "0195f2a4-c0c0-7000-8000-0000000000" + n }
	otherUser := "0195f2a4-2222-7000-8000-000000000099"

	// invites_code_key: unique across organizations.
	saveExpect(t, app, newInvite(t, app, id("01"), "ABC234"), true, "first invite")
	other := newInvite(t, app, id("02"), "ABC234")
	other.Set("org_id", "0195f2a4-1111-7000-8000-000000000099")
	saveExpect(t, app, other, false, "same code in another organization")

	// device_tokens_token_key.
	saveExpect(t, app, newDeviceToken(t, app, id("03"), "fcm-1"), true, "first token")
	saveExpect(t, app, newDeviceToken(t, app, id("04"), "fcm-1"), false, "same token")

	// weather_cache_pkey (cell).
	saveExpect(t, app, newWeather(t, app, id("05"), "37.11,28.39"), true, "first cell")
	saveExpect(t, app, newWeather(t, app, id("06"), "37.11,28.39"), false, "same cell")

	// deletion_log_request_id_key.
	saveExpect(t, app, newDeletionLog(t, app, id("07"), testRequest), true, "first log")
	saveExpect(t, app, newDeletionLog(t, app, id("08"), testRequest), false, "same request logged twice")

	// deletion_codes_pkey (user_id).
	saveExpect(t, app, newDeletionCode(t, app, id("09"), testUser), true, "first code")
	saveExpect(t, app, newDeletionCode(t, app, id("10"), testUser), false, "second code of a user")

	// support_period_notifications_pkey (period_id).
	saveExpect(t, app, newNotification(t, app, id("11"), testSupportPeriod), true, "first notification")
	saveExpect(t, app, newNotification(t, app, id("12"), testSupportPeriod), false, "period notified twice")

	// deletion_requests_pending_user_key: one pending request per user;
	// cancelled and completed ones and other users are free.
	saveExpect(t, app, newDeletionRequest(t, app, id("13"), "bekliyor"), true, "pending request")
	saveExpect(t, app, newDeletionRequest(t, app, id("14"), "bekliyor"), false, "second pending request")
	saveExpect(t, app, newDeletionRequest(t, app, id("15"), "iptal"), true, "cancelled request")
	saveExpect(t, app, newDeletionRequest(t, app, id("16"), "tamamlandi"), true, "completed request")
	o := newDeletionRequest(t, app, id("17"), "bekliyor")
	o.Set("user_id", otherUser)
	saveExpect(t, app, o, true, "another user's pending request")
	// Like Postgres' null: pending requests of deleted users do not clash.
	for _, n := range []string{"18", "19"} {
		r := newDeletionRequest(t, app, id(n), "bekliyor")
		r.Set("user_id", "")
		saveExpect(t, app, r, true, "pending request without user "+n)
	}
}

func TestDownUnsyncedCollections(t *testing.T) {
	app := newApp(t)

	// A kept deletion record blocks down.
	logRow := newDeletionLog(t, app, testDeletionLog, testRequest)
	if err := app.Save(logRow); err != nil {
		t.Fatal(err)
	}
	if err := downUnsyncedCollections(app); err == nil {
		t.Fatal("down dropped deletion_log with a record in it")
	}
	if !app.HasTable("deletion_log") || !app.HasTable("invites") {
		t.Fatal("down removed collections before refusing")
	}
	if err := app.Delete(logRow); err != nil { // no guard hook in this app
		t.Fatal(err)
	}

	if err := downUnsyncedCollections(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range unsyncedCollections {
		if _, err := app.FindCollectionByNameOrId(name); err == nil {
			t.Errorf("%s still exists", name)
		}
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}
	for _, name := range financeCollections {
		if _, err := app.FindCollectionByNameOrId(name); err != nil {
			t.Errorf("%s removed: %v", name, err)
		}
	}
	if err := upUnsyncedCollections(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
