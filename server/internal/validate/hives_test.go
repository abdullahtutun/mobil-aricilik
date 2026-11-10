package validate

import (
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

func raw(s string) types.JSONRaw { return types.JSONRaw(s) }

func TestApiariesLocationCheck(t *testing.T) {
	ok := [][2]string{
		{"", ""}, {"null", "null"}, {"", "null"},
		{"39.92", "32.85"}, {"0", "0"},
		{"90", "180"}, {"-90", "-180"}, {"-12.5", "130.25"},
	}
	bad := [][2]string{
		{"39.92", ""}, {"", "32.85"}, {"39.92", "null"}, {"null", "0"}, // half set
		{"90.000001", "0"}, {"-90.1", "0"}, {"0", "180.5"}, {"0", "-181"}, // range
		{`"39.92"`, "32.85"}, {"39.92", `"32.85"`}, {"[1]", "2"}, {"1", "{}"},
		{"true", "1"}, {"x", "1"},
	}
	for _, c := range ok {
		if err := ApiariesLocationCheck(raw(c[0]), raw(c[1])); err != nil {
			t.Errorf("(%q, %q) rejected: %v", c[0], c[1], err)
		}
	}
	for _, c := range bad {
		if err := ApiariesLocationCheck(raw(c[0]), raw(c[1])); err == nil {
			t.Errorf("(%q, %q) accepted", c[0], c[1])
		}
	}
	if err := ApiariesLocationCheck(nil, nil); err != nil {
		t.Errorf("nil, nil rejected: %v", err)
	}
}

func TestNullableIntChecks(t *testing.T) {
	cases := []struct {
		name  string
		check func(types.JSONRaw) error
		ok    []string
		bad   []string
	}{
		{
			"altitude_m", ApiariesAltitudeMCheck,
			[]string{"", "null", "0", "-30", "1250", "2147483647", "-2147483648"},
			[]string{"12.5", "2147483648", "-2147483649", `"1"`, "[]"},
		},
		{
			"vehicle_distance_m", ApiariesVehicleDistanceMCheck,
			[]string{"", "null", "0", "300", "2147483647"},
			[]string{"-1", "0.5", "2147483648", `"300"`},
		},
		{
			"year", QueensYearCheck,
			[]string{"", "null", "2000", "2026", "2100"},
			[]string{"1999", "2101", "2026.5", "0", `"2026"`},
		},
		{
			"frame_count", HivesFrameCountCheck,
			[]string{"", "null", "0", "10", "32767"},
			[]string{"-1", "32768", "9.5", `"10"`},
		},
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

func TestQueensCheck(t *testing.T) {
	const id = "0195f2a4-7777-7000-8000-000000000001"
	if err := QueensCheck(id, ""); err != nil {
		t.Errorf("no mother rejected: %v", err)
	}
	if err := QueensCheck(id, "0195f2a4-7777-7000-8000-000000000002"); err != nil {
		t.Errorf("other mother rejected: %v", err)
	}
	if err := QueensCheck(id, id); err == nil {
		t.Error("own mother accepted")
	}
}

func TestHivesQuarantineDiseaseCheck(t *testing.T) {
	ok := []string{"", "afb", " efb ", "a", string(make100('ş'))}
	bad := []string{" ", "   ", string(make100('ş')) + "x"}
	for _, v := range ok {
		if err := HivesQuarantineDiseaseCheck(v); err != nil {
			t.Errorf("%q rejected: %v", v, err)
		}
	}
	for _, v := range bad {
		if err := HivesQuarantineDiseaseCheck(v); err == nil {
			t.Errorf("%q accepted", v)
		}
	}
	// btrim trims spaces only: 100 characters plus padding is fine.
	if err := HivesQuarantineDiseaseCheck("  " + string(make100('a')) + "  "); err != nil {
		t.Errorf("padded 100 characters rejected: %v", err)
	}
}

func make100(r rune) []rune {
	out := make([]rune, 100)
	for i := range out {
		out[i] = r
	}
	return out
}

func TestHivesQuarantineConsistent(t *testing.T) {
	const at = "2026-11-10T10:15:30.123456Z"
	cases := []struct {
		quarantined bool
		at, disease string
		ok          bool
	}{
		{false, "", "", true},
		{true, at, "", true},
		{true, at, "afb", true},
		{true, "", "", false},     // quarantined without a time
		{false, at, "", false},    // time without quarantine
		{false, "", "afb", false}, // disease without quarantine
		{false, at, "afb", false},
	}
	for _, c := range cases {
		err := HivesQuarantineConsistent(c.quarantined, c.at, c.disease)
		if c.ok && err != nil {
			t.Errorf("%+v rejected: %v", c, err)
		}
		if !c.ok && err == nil {
			t.Errorf("%+v accepted", c)
		}
	}
}

func TestHiveStatusEventsChecks(t *testing.T) {
	if err := HiveStatusEventsCheck("active", "dead"); err != nil {
		t.Errorf("active→dead rejected: %v", err)
	}
	if err := HiveStatusEventsCheck("active", "active"); err == nil {
		t.Error("active→active accepted")
	}

	ok := [][2]string{{"dead", "varroa"}, {"lost", "other"}, {"dead", ""}, {"sold", ""}, {"active", ""}}
	bad := [][2]string{{"sold", "varroa"}, {"merged", "other"}, {"active", "wintering"}}
	for _, c := range ok {
		if err := HiveStatusEventsCheck1(c[0], c[1]); err != nil {
			t.Errorf("to=%s reason=%s rejected: %v", c[0], c[1], err)
		}
	}
	for _, c := range bad {
		if err := HiveStatusEventsCheck1(c[0], c[1]); err == nil {
			t.Errorf("to=%s reason=%s accepted", c[0], c[1])
		}
	}
}
