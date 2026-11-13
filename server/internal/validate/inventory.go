package validate

import (
	"errors"
	"fmt"
	"math"

	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of inventory_items, inventory_moves (20261101180000),
// queen_rearing_batches and mating_nucs (20261101230000).

// nullableNumeric decodes a nullable numeric(p, scale) column stored as JSON
// and rounds it the way Postgres stores it ([RoundNumeric]).
func nullableNumeric(raw types.JSONRaw, scale int) (v float64, isNull bool, err error) {
	v, isNull, err = nullableNumber(raw)
	if err != nil || isNull {
		return 0, isNull, err
	}
	return RoundNumeric(v, scale), false, nil
}

// InventoryItemsNameCheck is inventory_items_name_check: 1–80 characters
// after trimming spaces.
func InventoryItemsNameCheck(name string) error {
	return btrimLength("name", name, false, 1, 80)
}

// InventoryItemsPlaceCheck is inventory_items_place_check: null, or 1–60
// characters after trimming spaces.
func InventoryItemsPlaceCheck(place string) error {
	return btrimLength("place", place, true, 1, 60)
}

// InventoryItemsThresholdCheck is inventory_items_threshold_check on a
// nullable numeric(12, 3) column: null, or 0 < threshold < 1000000 after
// rounding to 3 decimals. Push stores [RoundNumeric](threshold, 3).
func InventoryItemsThresholdCheck(raw types.JSONRaw) error {
	v, isNull, err := nullableNumeric(raw, 3)
	if err != nil || isNull {
		return column("threshold", err)
	}
	if !(v > 0 && v < 1000000) {
		return fmt.Errorf("threshold must be > 0 and < 1000000, got %s", raw)
	}
	return nil
}

// InventoryMovesQuantityCheck is inventory_moves_quantity_check on a
// numeric(12, 3) column: |quantity| < 1000000 after rounding to 3 decimals.
// Push stores [RoundNumeric](quantity, 3).
func InventoryMovesQuantityCheck(quantity float64) error {
	if v := RoundNumeric(quantity, 3); !(math.Abs(v) < 1000000) {
		return fmt.Errorf("quantity must be between -1000000 and 1000000 (exclusive), got %v", quantity)
	}
	return nil
}

// InventoryMovesQuantityCheck1 is inventory_moves_quantity_check1: the
// quantity is not 0 after rounding to 3 decimals (0.0004 is stored as 0).
func InventoryMovesQuantityCheck1(quantity float64) error {
	if RoundNumeric(quantity, 3) == 0 {
		return fmt.Errorf("quantity must not be 0, got %v", quantity)
	}
	return nil
}

// InventoryMovesCheck is inventory_moves_check: an incoming move is
// positive after rounding to 3 decimals.
func InventoryMovesCheck(kind string, quantity float64) error {
	if kind == "in" && !(RoundNumeric(quantity, 3) > 0) {
		return fmt.Errorf("an in move needs a positive quantity, got %v", quantity)
	}
	return nil
}

// InventoryMovesCheck1 is inventory_moves_check1: an outgoing move is
// negative.
func InventoryMovesCheck1(kind string, quantity float64) error {
	if kind == "out" && !(RoundNumeric(quantity, 3) < 0) {
		return fmt.Errorf("an out move needs a negative quantity, got %v", quantity)
	}
	return nil
}

// InventoryMovesCheck2 is inventory_moves_check2: linked_table and
// linked_id are both set or both empty.
func InventoryMovesCheck2(linkedTable, linkedID string) error {
	if (linkedTable == "") != (linkedID == "") {
		return errors.New("linked_table and linked_id must both be set or both be empty")
	}
	return nil
}

// QueenRearingBatchesAcceptedCountCheck is
// queen_rearing_batches_accepted_count_check: null, or a smallint >= 0.
func QueenRearingBatchesAcceptedCountCheck(raw types.JSONRaw) error {
	return column("accepted_count", NullableInt(raw, 0, math.MaxInt16))
}

// QueenRearingBatchesCheck is queen_rearing_batches_check: the accepted
// cells are not more than the grafted larvae. Null passes, like in Postgres.
func QueenRearingBatchesCheck(acceptedCount types.JSONRaw, graftedCount float64) error {
	v, isNull, err := nullableNumber(acceptedCount)
	if err != nil {
		return column("accepted_count", err)
	}
	if !isNull && v > graftedCount {
		return fmt.Errorf("accepted_count (%v) must not be more than grafted_count (%v)", v, graftedCount)
	}
	return nil
}

// MatingNucsNumberCheck is mating_nucs_number_check: 1–20 characters after
// trimming spaces.
func MatingNucsNumberCheck(number string) error {
	return btrimLength("number", number, false, 1, 20)
}

// MatingNucsCheck is mating_nucs_check: a nuc that is not empty carries a
// rearing batch's cell.
func MatingNucsCheck(status, rearingBatchID string) error {
	if status != "empty" && rearingBatchID == "" {
		return fmt.Errorf("a %s mating nuc needs rearing_batch_id", status)
	}
	return nil
}

// MatingNucsCheck1 is mating_nucs_check1: queen_id is set exactly for
// status given.
func MatingNucsCheck1(status, queenID string) error {
	if (status == "given") != (queenID != "") {
		return fmt.Errorf("queen_id must be set exactly for status given, status is %q", status)
	}
	return nil
}
