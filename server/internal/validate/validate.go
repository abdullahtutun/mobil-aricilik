// Package validate holds the Supabase CHECK constraints that a PocketBase
// field option cannot express. Each check is a function named after the
// constraint; push calls them (P5.3) and answers a failure with `invalid`.
package validate

import (
	"encoding/json"
	"fmt"
	"math"

	"github.com/pocketbase/pocketbase/tools/types"
)

// NullableInt checks a nullable integer column stored as JSON (see
// nullableNumberField in migrations): null, or an integer in [min, max].
func NullableInt(raw types.JSONRaw, min, max int64) error {
	v, isNull, err := nullableNumber(raw)
	if err != nil || isNull {
		return err
	}
	if v != math.Trunc(v) {
		return fmt.Errorf("must be an integer, got %v", v)
	}
	if v < float64(min) || v > float64(max) {
		return fmt.Errorf("must be between %d and %d, got %v", min, max, v)
	}
	return nil
}

// nullableNumber decodes a JSON value that must be null or a number.
func nullableNumber(raw types.JSONRaw) (v float64, isNull bool, err error) {
	if len(raw) == 0 {
		return 0, true, nil
	}
	var decoded any
	if err := json.Unmarshal(raw, &decoded); err != nil {
		return 0, false, fmt.Errorf("not JSON: %w", err)
	}
	switch d := decoded.(type) {
	case nil:
		return 0, true, nil
	case float64:
		return d, false, nil
	default:
		return 0, false, fmt.Errorf("must be a number or null, got %T", decoded)
	}
}
