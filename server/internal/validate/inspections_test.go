package validate

import (
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

const (
	testOrgID   = "0195f2a4-1111-7000-8000-000000000001"
	testHiveID  = "0195f2a4-cccc-7000-8000-000000000001"
	testMediaID = "0195f2a4-9999-7000-8000-000000000001"
)

func TestNullableIntChecksP23(t *testing.T) {
	cases := []struct {
		name  string
		check func(types.JSONRaw) error
		ok    []string
		bad   []string
	}{
		{"bee_frames", InspectionsBeeFramesCheck, []string{"", "null", "0", "100"}, []string{"-1", "101", "2.5", `"3"`}},
		{"brood_frames", InspectionsBroodFramesCheck, []string{"", "0", "100"}, []string{"-1", "101"}},
		{"honey_frames", InspectionsHoneyFramesCheck, []string{"", "0", "100"}, []string{"-1", "101"}},
		{"duration_ms", MediaDurationMsCheck, []string{"", "null", "0", "2147483647"}, []string{"-1", "1.5", "2147483648"}},
		{"sample_bees", MiteCountsSampleBeesCheck, []string{"", "null", "1", "5000"}, []string{"0", "5001", "300.5"}},
		{"days", MiteCountsDaysCheck, []string{"", "null", "1", "60"}, []string{"0", "61", "true"}},
		{"ref_drugs.withdrawal_days", RefDrugsWithdrawalDaysCheck, []string{"", "null", "0", "365"}, []string{"-1", "366", "1.5"}},
		{"drugs.withdrawal_days", DrugsWithdrawalDaysCheck, []string{"", "null", "0", "365"}, []string{"-1", "366"}},
	}
	for _, tc := range cases {
		for _, v := range tc.ok {
			if err := tc.check(raw(v)); err != nil {
				t.Errorf("%s=%q rejected: %v", tc.name, v, err)
			}
		}
		for _, v := range tc.bad {
			if err := tc.check(raw(v)); err == nil {
				t.Errorf("%s=%q accepted", tc.name, v)
			}
		}
	}
}

func TestNullableBool(t *testing.T) {
	for _, v := range []string{"", "null", "true", "false"} {
		if err := NullableBool(raw(v)); err != nil {
			t.Errorf("%q rejected: %v", v, err)
		}
	}
	for _, v := range []string{"0", "1", `"true"`, "[]", "{}", "x"} {
		if err := NullableBool(raw(v)); err == nil {
			t.Errorf("%q accepted", v)
		}
	}
	if err := InspectionsBooleans(raw("true"), raw("null")); err != nil {
		t.Errorf("valid booleans rejected: %v", err)
	}
	if err := InspectionsBooleans(raw("1"), raw("null")); err == nil || !strings.Contains(err.Error(), "swarm_signs") {
		t.Errorf("swarm_signs=1: %v", err)
	}
	if err := InspectionsBooleans(raw("false"), raw(`"no"`)); err == nil || !strings.Contains(err.Error(), "disease_suspected") {
		t.Errorf("disease_suspected=\"no\": %v", err)
	}
}

func TestInspectionsDataCheck(t *testing.T) {
	for _, v := range []string{`{}`, `{"actions":["added_super"]}`, `{"withdrawal_override":{"days":3}}`} {
		if err := InspectionsDataCheck(raw(v)); err != nil {
			t.Errorf("%s rejected: %v", v, err)
		}
	}
	big := `{"x":"` + strings.Repeat("a", MaxInspectionData) + `"}`
	for _, v := range []string{"", "null", "[]", `"{}"`, "1", "{", big} {
		if err := InspectionsDataCheck(raw(v)); err == nil {
			t.Errorf("%.20q accepted", v)
		}
	}
}

func TestMediaCheck(t *testing.T) {
	photo := testOrgID + "/" + testHiveID + "/" + testMediaID + ".jpg"
	audio := testOrgID + "/" + testHiveID + "/" + testMediaID + ".m4a"
	if err := MediaCheck(testMediaID, testOrgID, testHiveID, "photo", photo); err != nil {
		t.Errorf("photo rejected: %v", err)
	}
	if err := MediaCheck(testMediaID, testOrgID, testHiveID, "audio", audio); err != nil {
		t.Errorf("audio rejected: %v", err)
	}
	other := "0195f2a4-0000-7000-8000-000000000099"
	bad := []struct{ why, kind, path string }{
		{"photo as m4a", "photo", audio},
		{"audio as jpg", "audio", photo},
		{"other organization", "photo", other + "/" + testHiveID + "/" + testMediaID + ".jpg"},
		{"other testHiveID", "photo", testOrgID + "/" + other + "/" + testMediaID + ".jpg"},
		{"other row", "photo", testOrgID + "/" + testHiveID + "/" + other + ".jpg"},
		{"parts swapped", "photo", testHiveID + "/" + testOrgID + "/" + testMediaID + ".jpg"},
		{"upper case", "photo", strings.ToUpper(photo)},
		{"png", "photo", testOrgID + "/" + testHiveID + "/" + testMediaID + ".png"},
		{"two folders", "photo", testOrgID + "/" + testMediaID + ".jpg"},
		{"prefix", "photo", "testMediaID/" + photo},
		{"empty", "photo", ""},
	}
	for _, c := range bad {
		if err := MediaCheck(testMediaID, testOrgID, testHiveID, c.kind, c.path); err == nil {
			t.Errorf("%s accepted: %s", c.why, c.path)
		}
	}
}

func TestMediaStoragePathPattern(t *testing.T) {
	for _, p := range []string{
		testOrgID + "/" + testHiveID + "/" + testMediaID + ".jpg",
		testOrgID + "/" + testHiveID + "/" + testMediaID + ".m4a",
	} {
		if !mediaStoragePathRe.MatchString(p) {
			t.Errorf("%s rejected", p)
		}
	}
	for _, p := range []string{
		testOrgID + "/" + testHiveID + "/" + testMediaID + ".jpeg",
		testOrgID + "/" + testHiveID + "/" + testMediaID,
		"------------------------------------/" + testHiveID + "/" + testMediaID + ".jpg",
		testOrgID + "/" + testHiveID + "/" + testMediaID + ".jpg\n",
	} {
		if mediaStoragePathRe.MatchString(p) {
			t.Errorf("%q accepted", p)
		}
	}
}

func TestMediaCheck1AndSingleOwner(t *testing.T) {
	ok := []struct {
		kind, duration string
	}{{"audio", "1500"}, {"audio", ""}, {"audio", "null"}, {"photo", ""}, {"photo", "null"}}
	for _, c := range ok {
		if err := MediaCheck1(c.kind, raw(c.duration)); err != nil {
			t.Errorf("%s with %q rejected: %v", c.kind, c.duration, err)
		}
	}
	for _, d := range []string{"0", "1500"} {
		if err := MediaCheck1("photo", raw(d)); err == nil {
			t.Errorf("photo with duration %s accepted", d)
		}
	}
	if err := MediaCheck1("audio", raw(`"x"`)); err == nil {
		t.Error("string duration accepted")
	}

	if err := MediaSingleOwnerCheck("", ""); err != nil {
		t.Error(err)
	}
	if err := MediaSingleOwnerCheck(testMediaID, ""); err != nil {
		t.Error(err)
	}
	if err := MediaSingleOwnerCheck("", testMediaID); err != nil {
		t.Error(err)
	}
	if err := MediaSingleOwnerCheck(testMediaID, testHiveID); err == nil {
		t.Error("inspection and treatment both accepted")
	}
}

func TestMiteCountsChecks(t *testing.T) {
	cases := []struct {
		method, days, sampleBees string
		ok                       bool
	}{
		{"sticky_board", "3", "", true},
		{"sticky_board", "3", "null", true},
		{"sugar_roll", "", "300", true},
		{"alcohol_wash", "null", "300", true},
		{"sticky_board", "", "", false},     // days missing
		{"sticky_board", "3", "300", false}, // sample on a board
		{"sugar_roll", "3", "300", false},   // days on a roll
		{"sugar_roll", "", "", false},       // sample missing
		{"alcohol_wash", "", "null", false},
	}
	for _, c := range cases {
		err := MiteCountsCheck(c.method, raw(c.days))
		if err == nil {
			err = MiteCountsCheck1(c.method, raw(c.sampleBees))
		}
		if c.ok && err != nil {
			t.Errorf("%+v rejected: %v", c, err)
		}
		if !c.ok && err == nil {
			t.Errorf("%+v accepted", c)
		}
	}
	if err := MiteCountsCheck("sticky_board", raw("[]")); err == nil {
		t.Error("days [] accepted")
	}
}
