package validate

import (
	"errors"
	"fmt"
	"strings"
	"unicode/utf8"

	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of tasks (20261026180000, 20261101200000, 20261101230000), and
// btrimLength for the `char_length(btrim(x))` CHECKs of 1794300006.

// btrimLength is a `char_length(btrim(value)) between min and max` CHECK:
// Postgres' btrim drops spaces only. An empty value is null when nullable
// (PocketBase stores null text as ""), otherwise it fails like an all-space
// value does.
func btrimLength(name, value string, nullable bool, min, max int) error {
	if value == "" && nullable {
		return nil
	}
	n := utf8.RuneCountInString(strings.Trim(value, " "))
	if n < min || n > max {
		return fmt.Errorf("%s must be %d to %d characters after trimming spaces, got %d", name, min, max, n)
	}
	return nil
}

// TasksTitleCheck is tasks_title_check: null, or 1–200 characters after
// trimming spaces.
func TasksTitleCheck(title string) error {
	return btrimLength("title", title, true, 1, 200)
}

// TasksCheck is tasks_check: a hive task carries its apiary.
func TasksCheck(hiveID, apiaryID string) error {
	if hiveID != "" && apiaryID == "" {
		return errors.New("a task with hive_id needs apiary_id")
	}
	return nil
}

// TasksCheck1 is tasks_check1: source_id is null exactly for manual tasks.
func TasksCheck1(source, sourceID string) error {
	if (source == "manual") != (sourceID == "") {
		return fmt.Errorf("source_id must be empty exactly for manual tasks, source is %q", source)
	}
	return nil
}

// TasksCheck2 is tasks_check2: a manual task has a title.
func TasksCheck2(source, title string) error {
	if source == "manual" && title == "" {
		return errors.New("a manual task needs a title")
	}
	return nil
}

// TasksDoseCheck is tasks_dose_check on a nullable numeric(8, 2) column:
// null, or 0 < dose <= 10000 after Postgres rounds it to 2 decimals. Push
// stores [RoundNumeric](dose, 2).
func TasksDoseCheck(raw types.JSONRaw) error {
	v, isNull, err := nullableNumber(raw)
	if err != nil {
		return column("dose", err)
	}
	if isNull {
		return nil
	}
	if r := RoundNumeric(v, 2); !(r > 0 && r <= 10000) {
		return fmt.Errorf("dose must be > 0 and <= 10000, got %v", v)
	}
	return nil
}

// TasksOneDrugCheck is tasks_one_drug_check: at most one of ref_drug_id and
// drug_id.
func TasksOneDrugCheck(refDrugID, drugID string) error {
	if refDrugID != "" && drugID != "" {
		return errors.New("ref_drug_id and drug_id cannot both be set")
	}
	return nil
}

// TasksDrugDoseCheck is tasks_drug_dose_check: the dose is set exactly when
// a drug is.
func TasksDrugDoseCheck(dose types.JSONRaw, refDrugID, drugID string) error {
	_, isNull, err := nullableNumber(dose)
	if err != nil {
		return column("dose", err)
	}
	if isNull != (refDrugID == "" && drugID == "") {
		return errors.New("dose must be set exactly when a drug is")
	}
	return nil
}

// TasksDrugManualApiaryCheck is tasks_drug_manual_apiary_check: a task with
// a dose is manual and tied to an apiary.
func TasksDrugManualApiaryCheck(dose types.JSONRaw, source, apiaryID string) error {
	_, isNull, err := nullableNumber(dose)
	if err != nil {
		return column("dose", err)
	}
	if !isNull && (source != "manual" || apiaryID == "") {
		return errors.New("a task with a dose must be manual and have apiary_id")
	}
	return nil
}

// TasksSourceStepCheck is tasks_source_step_check: null, or 1…60.
func TasksSourceStepCheck(raw types.JSONRaw) error {
	return column("source_step", NullableInt(raw, 1, 60))
}

// TasksQueenRearingStepCheck is tasks_queen_rearing_step_check: source_step
// is set exactly for queen_rearing tasks.
func TasksQueenRearingStepCheck(source string, sourceStep types.JSONRaw) error {
	_, isNull, err := nullableNumber(sourceStep)
	if err != nil {
		return column("source_step", err)
	}
	if (source == "queen_rearing") != !isNull {
		return fmt.Errorf("source_step must be set exactly for queen_rearing, source is %q", source)
	}
	return nil
}
