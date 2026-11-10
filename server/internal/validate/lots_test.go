package validate

import (
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

func TestLotsChecks(t *testing.T) {
	for _, v := range []string{"", "Muğla", strings.Repeat("ş", 80)} {
		if err := LotsOriginCheck(v); err != nil {
			t.Errorf("origin %q rejected: %v", v, err)
		}
	}
	for _, v := range []string{"  ", strings.Repeat("a", 81)} {
		if err := LotsOriginCheck(v); err == nil {
			t.Errorf("origin %q accepted", v)
		}
	}

	// numeric(3, 1): 9.95 is stored as 10.0, 30.04 as 30.0.
	for _, raw := range append(raws("null", "10", "17.5", "30", "9.95", "30.04"), nil) {
		if err := LotsMoistureCheck(raw); err != nil {
			t.Errorf("moisture %s rejected: %v", raw, err)
		}
	}
	for _, raw := range raws("0", "9.94", "30.05", "31", `"17"`) {
		if err := LotsMoistureCheck(raw); err == nil {
			t.Errorf("moisture %s accepted", raw)
		}
	}
}

func TestLabResultsValueChecks(t *testing.T) {
	cases := []struct {
		name     string
		check    func(types.JSONRaw) error
		accepted []string
		rejected []string
	}{
		{"hmf", LabResultsHmfCheck, []string{"null", "0", "12.3", "1000", "1000.04", "-0.04"}, []string{"-0.05", "-1", "1000.05", `"5"`}},
		{"diastase", LabResultsDiastaseCheck, []string{"null", "0", "8.5", "100"}, []string{"-1", "100.05", "101"}},
		{"proline", LabResultsProlineCheck, []string{"null", "0", "250", "10000"}, []string{"-1", "10000.05"}},
		{"moisture", LabResultsMoistureCheck, []string{"null", "10", "18.2", "30"}, []string{"0", "9.9", "30.1"}},
	}
	for _, c := range cases {
		for _, raw := range append(raws(c.accepted...), nil) {
			if err := c.check(raw); err != nil {
				t.Errorf("%s %s rejected: %v", c.name, raw, err)
			}
		}
		for _, raw := range raws(c.rejected...) {
			if err := c.check(raw); err == nil {
				t.Errorf("%s %s accepted", c.name, raw)
			}
		}
	}
}

// lab_results_check: at least one value; 0 counts, null and absent do not.
func TestLabResultsCheck(t *testing.T) {
	null := types.JSONRaw("null")
	zero := types.JSONRaw("0")

	if err := LabResultsCheck(nil, nil, nil, nil, ""); err == nil {
		t.Error("empty result accepted")
	}
	if err := LabResultsCheck(null, null, null, null, ""); err == nil {
		t.Error("all-null result accepted")
	}
	for i := range 4 {
		values := []types.JSONRaw{null, null, null, null}
		values[i] = zero
		if err := LabResultsCheck(values[0], values[1], values[2], values[3], ""); err != nil {
			t.Errorf("value %d alone rejected: %v", i, err)
		}
	}
	for _, residue := range []string{"none", "detected"} {
		if err := LabResultsCheck(nil, null, nil, null, residue); err != nil {
			t.Errorf("residue %s alone rejected: %v", residue, err)
		}
	}
	if err := LabResultsCheck(types.JSONRaw(`"x"`), nil, nil, nil, ""); err == nil {
		t.Error("non-number value accepted")
	}
}

func TestLotSalesKgCheck(t *testing.T) {
	for _, v := range []float64{0.001, 0.0005, 12.5, 100000, 100000.0004} {
		if err := LotSalesKgCheck(v); err != nil {
			t.Errorf("kg %v rejected: %v", v, err)
		}
	}
	for _, v := range []float64{0, 0.0004, -1, 100000.0005, 100001} {
		if err := LotSalesKgCheck(v); err == nil {
			t.Errorf("kg %v accepted", v)
		}
	}
}
