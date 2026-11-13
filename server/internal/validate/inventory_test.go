package validate

import (
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

func raws(values ...string) []types.JSONRaw {
	out := make([]types.JSONRaw, len(values))
	for i, v := range values {
		out[i] = types.JSONRaw(v)
	}
	return out
}

func TestInventoryItemsChecks(t *testing.T) {
	for _, v := range []string{"Şeker", " x ", strings.Repeat("ş", 80), " " + strings.Repeat("a", 80) + " "} {
		if err := InventoryItemsNameCheck(v); err != nil {
			t.Errorf("name %q rejected: %v", v, err)
		}
	}
	for _, v := range []string{"", "   ", strings.Repeat("a", 81)} {
		if err := InventoryItemsNameCheck(v); err == nil {
			t.Errorf("name %q accepted", v)
		}
	}
	for _, v := range []string{"", "Depo", strings.Repeat("ş", 60)} {
		if err := InventoryItemsPlaceCheck(v); err != nil {
			t.Errorf("place %q rejected: %v", v, err)
		}
	}
	for _, v := range []string{"  ", strings.Repeat("a", 61)} {
		if err := InventoryItemsPlaceCheck(v); err == nil {
			t.Errorf("place %q accepted", v)
		}
	}

	for _, raw := range append(raws("null", "0.001", "0.0005", "5", "999999.999", "999999.9994"), nil) {
		if err := InventoryItemsThresholdCheck(raw); err != nil {
			t.Errorf("threshold %s rejected: %v", raw, err)
		}
	}
	// 0.0004 is stored as 0; 999999.9995 as 1000000.
	for _, raw := range raws("0", "0.0004", "-1", "1000000", "999999.9995", `"5"`, "[]") {
		if err := InventoryItemsThresholdCheck(raw); err == nil {
			t.Errorf("threshold %s accepted", raw)
		}
	}
}

func TestInventoryMovesChecks(t *testing.T) {
	for _, v := range []float64{-999999.999, -0.001, 0.0005, 12.5, 999999.9994} {
		if err := InventoryMovesQuantityCheck(v); err != nil {
			t.Errorf("quantity %v rejected: %v", v, err)
		}
	}
	for _, v := range []float64{1000000, -1000000, 999999.9995, -999999.9995} {
		if err := InventoryMovesQuantityCheck(v); err == nil {
			t.Errorf("quantity %v accepted", v)
		}
	}
	for _, v := range []float64{0.001, -0.001, 0.0005, -0.0005} {
		if err := InventoryMovesQuantityCheck1(v); err != nil {
			t.Errorf("quantity %v rejected: %v", v, err)
		}
	}
	for _, v := range []float64{0, 0.0004, -0.0004} {
		if err := InventoryMovesQuantityCheck1(v); err == nil {
			t.Errorf("quantity %v accepted", v)
		}
	}

	cases := []struct {
		kind     string
		quantity float64
		in, out  bool // InventoryMovesCheck, InventoryMovesCheck1 pass
	}{
		{"in", 5, true, true},
		{"in", -5, false, true},
		{"in", 0.0004, false, true},
		{"out", -5, true, true},
		{"out", 5, true, false},
		{"out", -0.0004, true, false},
		{"adjustment", 5, true, true},
		{"adjustment", -5, true, true},
	}
	for _, c := range cases {
		if err := InventoryMovesCheck(c.kind, c.quantity); (err == nil) != c.in {
			t.Errorf("InventoryMovesCheck(%s, %v) = %v", c.kind, c.quantity, err)
		}
		if err := InventoryMovesCheck1(c.kind, c.quantity); (err == nil) != c.out {
			t.Errorf("InventoryMovesCheck1(%s, %v) = %v", c.kind, c.quantity, err)
		}
	}

	const feeding = "0195f2a4-5678-7000-8000-000000000001"
	if err := InventoryMovesCheck2("", ""); err != nil {
		t.Error(err)
	}
	if err := InventoryMovesCheck2("feedings", feeding); err != nil {
		t.Error(err)
	}
	if err := InventoryMovesCheck2("feedings", ""); err == nil {
		t.Error("table without id accepted")
	}
	if err := InventoryMovesCheck2("", feeding); err == nil {
		t.Error("id without table accepted")
	}
}

func TestQueenRearingBatchesChecks(t *testing.T) {
	for _, raw := range append(raws("null", "0", "32767"), nil) {
		if err := QueenRearingBatchesAcceptedCountCheck(raw); err != nil {
			t.Errorf("accepted_count %s rejected: %v", raw, err)
		}
	}
	for _, raw := range raws("-1", "32768", "2.5", `"3"`) {
		if err := QueenRearingBatchesAcceptedCountCheck(raw); err == nil {
			t.Errorf("accepted_count %s accepted", raw)
		}
	}

	for _, raw := range append(raws("null", "0", "20", "30"), nil) {
		if err := QueenRearingBatchesCheck(raw, 30); err != nil {
			t.Errorf("accepted_count %s of 30 rejected: %v", raw, err)
		}
	}
	for _, raw := range raws("31", "true") {
		if err := QueenRearingBatchesCheck(raw, 30); err == nil {
			t.Errorf("accepted_count %s of 30 accepted", raw)
		}
	}
}

func TestMatingNucsChecks(t *testing.T) {
	const batch = "0195f2a4-5678-7000-8000-000000000001"
	const queen = "0195f2a4-5678-7000-8000-000000000002"

	for _, v := range []string{"1", "K-12", strings.Repeat("ş", 20)} {
		if err := MatingNucsNumberCheck(v); err != nil {
			t.Errorf("number %q rejected: %v", v, err)
		}
	}
	for _, v := range []string{"", " ", strings.Repeat("a", 21)} {
		if err := MatingNucsNumberCheck(v); err == nil {
			t.Errorf("number %q accepted", v)
		}
	}

	if err := MatingNucsCheck("empty", ""); err != nil {
		t.Error(err)
	}
	if err := MatingNucsCheck("empty", batch); err != nil {
		t.Error(err)
	}
	for _, status := range []string{"cell", "virgin", "laying", "failed", "given"} {
		if err := MatingNucsCheck(status, batch); err != nil {
			t.Errorf("%s with batch: %v", status, err)
		}
		if err := MatingNucsCheck(status, ""); err == nil {
			t.Errorf("%s without batch accepted", status)
		}
	}

	if err := MatingNucsCheck1("given", queen); err != nil {
		t.Error(err)
	}
	if err := MatingNucsCheck1("given", ""); err == nil {
		t.Error("given without queen accepted")
	}
	for _, status := range []string{"empty", "cell", "virgin", "laying", "failed"} {
		if err := MatingNucsCheck1(status, ""); err != nil {
			t.Errorf("%s without queen: %v", status, err)
		}
		if err := MatingNucsCheck1(status, queen); err == nil {
			t.Errorf("%s with queen accepted", status)
		}
	}
}
