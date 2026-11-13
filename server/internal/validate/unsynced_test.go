package validate

import (
	"regexp"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

const (
	unsyncedOrg = "0195f2a4-1111-7000-8000-000000000001"
	unsyncedID  = "0195f2a4-b3b3-7000-8000-000000000001"
	t1          = "2026-11-10T10:15:30.123456Z"
	t2          = "2026-11-17T10:15:30.123456Z"
)

func TestInvitesCheck(t *testing.T) {
	for _, c := range []struct {
		usedAt, usedBy string
		ok             bool
	}{
		{"", "", true},
		{t1, unsyncedOrg, true},
		{t1, "", false},
		{"", unsyncedOrg, false},
	} {
		if err := InvitesCheck(c.usedAt, c.usedBy); (err == nil) != c.ok {
			t.Errorf("InvitesCheck(%q, %q) = %v, want ok=%v", c.usedAt, c.usedBy, err, c.ok)
		}
	}
}

func TestFeedbackCheck(t *testing.T) {
	re := regexp.MustCompile(FeedbackScreenshotPath)
	good := unsyncedOrg + "/" + unsyncedID + ".jpg"
	if !re.MatchString(good) {
		t.Errorf("pattern rejects %s", good)
	}
	if err := FeedbackCheck(unsyncedID, unsyncedOrg, ""); err != nil {
		t.Errorf("null path: %v", err)
	}
	if err := FeedbackCheck(unsyncedID, unsyncedOrg, good); err != nil {
		t.Errorf("own path: %v", err)
	}
	other := "0195f2a4-1111-7000-8000-000000000099"
	for _, p := range []string{
		other + "/" + unsyncedID + ".jpg",       // another organization
		unsyncedOrg + "/" + other + ".jpg",      // another row
		unsyncedOrg + "/" + unsyncedID + ".png", // wrong type
	} {
		if err := FeedbackCheck(unsyncedID, unsyncedOrg, p); err == nil {
			t.Errorf("FeedbackCheck accepted %s", p)
		}
	}
}

func TestFeedbackMessageCheck(t *testing.T) {
	for msg, ok := range map[string]bool{
		"a":                             true,
		" hata ":                        true,
		strings.Repeat("ş", 4000):       true,
		" " + strings.Repeat("ş", 4000): true,
		"":                              false,
		"   ":                           false,
		strings.Repeat("ş", 4001):       false,
	} {
		if err := FeedbackMessageCheck(msg); (err == nil) != ok {
			t.Errorf("FeedbackMessageCheck(len %d) = %v, want ok=%v", len(msg), err, ok)
		}
	}
}

// objectOfJsonbLength returns {"k": "aaa…"} whose jsonb text is n bytes:
// `{"k": "` + a… + `"}` = 9 + len(a…).
func objectOfJsonbLength(n int) types.JSONRaw {
	return types.JSONRaw(`{"k":"` + strings.Repeat("a", n-9) + `"}`)
}

func TestFeedbackDeviceInfoCheck(t *testing.T) {
	ok := []types.JSONRaw{
		nil, types.JSONRaw("null"), types.JSONRaw(`{}`),
		types.JSONRaw(`{"os":"android 15","app":"1.0.0+3","model":"Pixel 8","locale":"tr"}`),
		objectOfJsonbLength(MaxFeedbackDeviceInfo),
	}
	bad := []types.JSONRaw{
		types.JSONRaw(`[]`), types.JSONRaw(`"x"`), types.JSONRaw(`1`), types.JSONRaw(`{`),
		objectOfJsonbLength(MaxFeedbackDeviceInfo + 1),
	}
	for _, raw := range ok {
		if err := FeedbackDeviceInfoCheck(raw); err != nil {
			t.Errorf("FeedbackDeviceInfoCheck(%.40s) = %v", raw, err)
		}
	}
	for _, raw := range bad {
		if err := FeedbackDeviceInfoCheck(raw); err == nil {
			t.Errorf("FeedbackDeviceInfoCheck(%.40s) accepted", raw)
		}
	}
}

func TestAnalyticsEventsPropsCheck(t *testing.T) {
	for _, raw := range []types.JSONRaw{
		types.JSONRaw(`{}`), types.JSONRaw(`{"ms":1234,"ok":1}`),
		objectOfJsonbLength(MaxAnalyticsProps),
	} {
		if err := AnalyticsEventsPropsCheck(raw); err != nil {
			t.Errorf("AnalyticsEventsPropsCheck(%.40s) = %v", raw, err)
		}
	}
	for _, raw := range []types.JSONRaw{
		nil, types.JSONRaw(`null`), types.JSONRaw(`[]`), types.JSONRaw(`3`),
		objectOfJsonbLength(MaxAnalyticsProps + 1),
	} {
		if err := AnalyticsEventsPropsCheck(raw); err == nil {
			t.Errorf("AnalyticsEventsPropsCheck(%.40s) accepted", raw)
		}
	}
}

// Lengths of `select octet_length('<json>'::jsonb::text)`, measured on the
// live Supabase project (Postgres 17) on 2026-11-10.
func TestJsonbTextLength(t *testing.T) {
	for raw, want := range map[string]int{
		`{}`:                            2,  // {}
		`{"a":1}`:                       8,  // {"a": 1}
		`{"a":1,"b":[1,2]}`:             21, // {"a": 1, "b": [1, 2]}
		`{"a" : 1 , "b" : [ ] }`:        17, // {"a": 1, "b": []}
		`{"ad":"Arıcı","n":null}`:       28, // {"n": null, "ad": "Arıcı"}
		`{"x":true,"y":false}`:          23, // {"x": true, "y": false}
		`{"a":{"b":{"c":"<&>"}}}`:       26, // {"a": {"b": {"c": "<&>"}}}
		`{"q":"say \"hi\"","t":"a\tb"}`: 32, // {"q": "say \"hi\"", "t": "a\tb"}
	} {
		if err := jsonbObject(types.JSONRaw(raw), want); err != nil {
			t.Errorf("%s: %v, want %d bytes", raw, err, want)
		}
		if err := jsonbObject(types.JSONRaw(raw), want-1); err == nil {
			t.Errorf("%s: fits in %d bytes, want %d", raw, want-1, want)
		}
	}
}

func TestDeletionRequestsChecks(t *testing.T) {
	if err := DeletionRequestsCheck(t1, t2); err != nil {
		t.Errorf("later scheduled_for rejected: %v", err)
	}
	for _, s := range []string{t1, "2026-11-10T10:15:30.123455Z"} {
		if err := DeletionRequestsCheck(t1, s); err == nil {
			t.Errorf("scheduled_for %s accepted", s)
		}
	}

	for _, c := range []struct {
		status, at string
		ok1, ok2   bool
	}{
		{"bekliyor", "", true, true},
		{"iptal", t2, true, false},
		{"tamamlandi", t2, false, true},
		{"iptal", "", false, true},
		{"tamamlandi", "", true, false},
		{"bekliyor", t2, false, false},
	} {
		if err := DeletionRequestsCheck1(c.status, c.at); (err == nil) != c.ok1 {
			t.Errorf("Check1(%q, %q) = %v, want ok=%v", c.status, c.at, err, c.ok1)
		}
		if err := DeletionRequestsCheck2(c.status, c.at); (err == nil) != c.ok2 {
			t.Errorf("Check2(%q, %q) = %v, want ok=%v", c.status, c.at, err, c.ok2)
		}
	}

	one := types.JSONRaw(`["` + unsyncedOrg + `"]`)
	for _, c := range []struct {
		kind string
		raw  types.JSONRaw
		ok   bool
	}{
		{"hesap", types.JSONRaw(`[]`), true},
		{"hesap_ve_isletme", one, true},
		{"hesap", one, false},
		{"hesap_ve_isletme", types.JSONRaw(`[]`), false},
		{"hesap", nil, false},
		{"hesap", types.JSONRaw(`null`), false},
		{"hesap_ve_isletme", types.JSONRaw(`["org-1"]`), false},
		{"hesap_ve_isletme", types.JSONRaw(`[1]`), false},
		{"hesap_ve_isletme", types.JSONRaw(`{"a":"` + unsyncedOrg + `"}`), false},
	} {
		if err := DeletionRequestsCheck3(c.kind, c.raw); (err == nil) != c.ok {
			t.Errorf("Check3(%q, %s) = %v, want ok=%v", c.kind, c.raw, err, c.ok)
		}
	}
	if err := DeletionRequestsDeleteOrgIdsCheck(one); err != nil {
		t.Errorf("DeleteOrgIdsCheck: %v", err)
	}
	if err := DeletionRequestsDeleteOrgIdsCheck(nil); err == nil {
		t.Error("DeleteOrgIdsCheck accepted null")
	}
}
