package validate

import (
	"errors"
	"fmt"
	"math"
	"math/big"
	"strconv"

	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of ref_drugs, drugs, treatments (20261025200000, 20261025220000) and
// feedings (20261026120000).

// RefDrugsWithdrawalDaysCheck is ref_drugs_withdrawal_days_check: null, or
// 0…365.
func RefDrugsWithdrawalDaysCheck(raw types.JSONRaw) error {
	return column("withdrawal_days", NullableInt(raw, 0, 365))
}

// DrugsWithdrawalDaysCheck is drugs_withdrawal_days_check: null, or 0…365.
func DrugsWithdrawalDaysCheck(raw types.JSONRaw) error {
	return column("withdrawal_days", NullableInt(raw, 0, 365))
}

// TreatmentsCheck is treatments_check: the planned removal is not before the
// start. Both are K-5 times, so text order is time order.
func TreatmentsCheck(startedAt, plannedRemovalAt string) error {
	if plannedRemovalAt != "" && plannedRemovalAt < startedAt {
		return errors.New("planned_removal_at must not be before started_at")
	}
	return nil
}

// TreatmentsCheck1 is treatments_check1: exactly one of ref_drug_id (the
// reference list) and drug_id (the organization's own drug).
func TreatmentsCheck1(refDrugID, drugID string) error {
	if (refDrugID == "") == (drugID == "") {
		return errors.New("exactly one of ref_drug_id and drug_id must be set")
	}
	return nil
}

// TreatmentsDoseCheck is treatments_dose_check on a numeric(8, 2) column:
// 0 < dose <= 10000 after Postgres rounds the value to 2 decimals. Push
// stores [RoundNumeric](dose, 2).
func TreatmentsDoseCheck(dose float64) error {
	v := RoundNumeric(dose, 2)
	if !(v > 0 && v <= 10000) {
		return fmt.Errorf("dose must be > 0 and <= 10000, got %v", dose)
	}
	return nil
}

// FeedingsAmountCheck is feedings_amount_check on a numeric(7, 3) column:
// 0 < amount <= 100 after Postgres rounds the value to 3 decimals. Push
// stores [RoundNumeric](amount, 3).
func FeedingsAmountCheck(amount float64) error {
	v := RoundNumeric(amount, 3)
	if !(v > 0 && v <= 100) {
		return fmt.Errorf("amount must be > 0 and <= 100, got %v", amount)
	}
	return nil
}

// RoundNumeric rounds v to scale decimals, half away from zero, the way
// Postgres stores a value in a numeric(p, scale) column. It rounds the
// shortest decimal form of v (what the client's JSON carried), not its binary
// value: 10000.005 becomes 10000.01 as in Postgres, not 10000.
func RoundNumeric(v float64, scale int) float64 {
	if math.IsNaN(v) || math.IsInf(v, 0) {
		return v
	}
	exact, ok := new(big.Rat).SetString(strconv.FormatFloat(v, 'f', -1, 64))
	if !ok {
		return v
	}
	// Scale up, move half a unit away from zero, truncate toward zero.
	pow := new(big.Int).Exp(big.NewInt(10), big.NewInt(int64(scale)), nil)
	exact.Mul(exact, new(big.Rat).SetInt(pow))
	half := big.NewRat(1, 2)
	if exact.Sign() < 0 {
		exact.Sub(exact, half)
	} else {
		exact.Add(exact, half)
	}
	units := new(big.Int).Quo(exact.Num(), exact.Denom())
	out, _ := new(big.Rat).SetFrac(units, pow).Float64()
	return out
}
