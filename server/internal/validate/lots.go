package validate

import (
	"errors"
	"fmt"

	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of lots, lab_results and lot_sales (20261102120000).

// nullableNumericBetween is a `check (x between min and max)` on a nullable
// numeric(p, scale) column stored as JSON: null, or min <= x <= max after
// rounding to scale decimals. Push stores [RoundNumeric](x, scale).
func nullableNumericBetween(name string, raw types.JSONRaw, scale int, min, max float64) error {
	v, isNull, err := nullableNumeric(raw, scale)
	if err != nil || isNull {
		return column(name, err)
	}
	if v < min || v > max {
		return fmt.Errorf("%s must be between %v and %v, got %s", name, min, max, raw)
	}
	return nil
}

// LotsOriginCheck is lots_origin_check: null, or 1–80 characters after
// trimming spaces.
func LotsOriginCheck(origin string) error {
	return btrimLength("origin", origin, true, 1, 80)
}

// LotsMoistureCheck is lots_moisture_check on a nullable numeric(3, 1)
// column: null, or 10…30 after rounding to 1 decimal.
func LotsMoistureCheck(raw types.JSONRaw) error {
	return nullableNumericBetween("moisture", raw, 1, 10, 30)
}

// LabResultsHmfCheck is lab_results_hmf_check on a nullable numeric(5, 1)
// column: null, or 0…1000.
func LabResultsHmfCheck(raw types.JSONRaw) error {
	return nullableNumericBetween("hmf", raw, 1, 0, 1000)
}

// LabResultsDiastaseCheck is lab_results_diastase_check on a nullable
// numeric(4, 1) column: null, or 0…100.
func LabResultsDiastaseCheck(raw types.JSONRaw) error {
	return nullableNumericBetween("diastase", raw, 1, 0, 100)
}

// LabResultsProlineCheck is lab_results_proline_check on a nullable
// numeric(6, 1) column: null, or 0…10000.
func LabResultsProlineCheck(raw types.JSONRaw) error {
	return nullableNumericBetween("proline", raw, 1, 0, 10000)
}

// LabResultsMoistureCheck is lab_results_moisture_check on a nullable
// numeric(3, 1) column: null, or 10…30.
func LabResultsMoistureCheck(raw types.JSONRaw) error {
	return nullableNumericBetween("moisture", raw, 1, 10, 30)
}

// LabResultsCheck is lab_results_check:
// num_nonnulls(hmf, diastase, proline, moisture, residue) > 0. A result
// carries at least one value; residue "" is null (PocketBase stores a null
// select as "").
func LabResultsCheck(hmf, diastase, proline, moisture types.JSONRaw, residue string) error {
	if residue != "" {
		return nil
	}
	for _, f := range []struct {
		name string
		raw  types.JSONRaw
	}{
		{"hmf", hmf}, {"diastase", diastase}, {"proline", proline}, {"moisture", moisture},
	} {
		_, isNull, err := nullableNumber(f.raw)
		if err != nil {
			return column(f.name, err)
		}
		if !isNull {
			return nil
		}
	}
	return errors.New("a lab result needs at least one of hmf, diastase, proline, moisture and residue")
}

// LotSalesKgCheck is lot_sales_kg_check on a numeric(9, 3) column:
// 0 < kg <= 100000 after rounding to 3 decimals. Push stores
// [RoundNumeric](kg, 3).
func LotSalesKgCheck(kg float64) error {
	if v := RoundNumeric(kg, 3); !(v > 0 && v <= 100000) {
		return fmt.Errorf("kg must be > 0 and <= 100000, got %v", kg)
	}
	return nil
}
