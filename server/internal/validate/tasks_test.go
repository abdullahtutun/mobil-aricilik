package validate

import (
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/tools/types"
)

const (
	taskApiary  = "0195f2a4-aaaa-7000-8000-000000000001"
	taskHive    = "0195f2a4-cccc-7000-8000-000000000001"
	taskSource  = "0195f2a4-1234-7000-8000-000000000001"
	taskRefDrug = "01900000-0000-7000-8000-000000000201"
	taskDrug    = "0195f2a4-5656-7000-8000-000000000001"
)

func TestBtrimChecks(t *testing.T) {
	cases := []struct {
		name string
		fn   func(string) error
		max  int
		null bool
	}{
		{"TasksTitleCheck", TasksTitleCheck, 200, true},
		{"DocumentsCustomTypeNameCheck", DocumentsCustomTypeNameCheck, 60, true},
		{"DocumentsNameCheck", DocumentsNameCheck, 120, false},
		{"MigrationsNameCheck", MigrationsNameCheck, 120, false},
		{"MigrationStopsNameCheck", MigrationStopsNameCheck, 120, false},
		{"MigrationStopsPlaceCheck", MigrationStopsPlaceCheck, 120, true},
		{"TransportItemsVehicleCheck", TransportItemsVehicleCheck, 60, false},
	}
	for _, c := range cases {
		max := strings.Repeat("ş", c.max)
		// btrim drops spaces only: padding around max characters is fine.
		for _, v := range []string{"a", max, "  " + max + "  ", "\ta"} {
			if err := c.fn(v); err != nil {
				t.Errorf("%s(%q) rejected: %v", c.name, v, err)
			}
		}
		for _, v := range []string{" ", "   ", max + "ş"} {
			if err := c.fn(v); err == nil {
				t.Errorf("%s(%q) accepted", c.name, v)
			}
		}
		// Empty is null for nullable columns, a failure for not-null ones.
		if err := c.fn(""); (err == nil) != c.null {
			t.Errorf("%s(\"\") err = %v, nullable %v", c.name, err, c.null)
		}
	}
}

func TestTasksChecks(t *testing.T) {
	if err := TasksCheck(taskHive, taskApiary); err != nil {
		t.Error(err)
	}
	if err := TasksCheck("", ""); err != nil {
		t.Error(err)
	}
	if err := TasksCheck("", taskApiary); err != nil {
		t.Error(err)
	}
	if err := TasksCheck(taskHive, ""); err == nil {
		t.Error("hive task without apiary accepted")
	}

	if err := TasksCheck1("manual", ""); err != nil {
		t.Error(err)
	}
	for _, source := range []string{"inspection", "treatment", "queen_rearing", "aks_update"} {
		if err := TasksCheck1(source, taskSource); err != nil {
			t.Errorf("%s: %v", source, err)
		}
		if err := TasksCheck1(source, ""); err == nil {
			t.Errorf("%s without source_id accepted", source)
		}
	}
	if err := TasksCheck1("manual", taskSource); err == nil {
		t.Error("manual with source_id accepted")
	}

	if err := TasksCheck2("manual", "Kat ver"); err != nil {
		t.Error(err)
	}
	if err := TasksCheck2("inspection", ""); err != nil {
		t.Error(err)
	}
	if err := TasksCheck2("manual", ""); err == nil {
		t.Error("manual task without title accepted")
	}
}

func TestTasksDrugChecks(t *testing.T) {
	null := types.JSONRaw("null")
	dose := types.JSONRaw("4")

	for _, raw := range []types.JSONRaw{nil, null, types.JSONRaw("0.01"), types.JSONRaw("0.005"), types.JSONRaw("10000"), types.JSONRaw("10000.004")} {
		if err := TasksDoseCheck(raw); err != nil {
			t.Errorf("dose %s rejected: %v", raw, err)
		}
	}
	for _, raw := range []types.JSONRaw{types.JSONRaw("0"), types.JSONRaw("0.004"), types.JSONRaw("-1"), types.JSONRaw("10000.005"), types.JSONRaw(`"4"`), types.JSONRaw("[4]")} {
		if err := TasksDoseCheck(raw); err == nil {
			t.Errorf("dose %s accepted", raw)
		}
	}

	if err := TasksOneDrugCheck(taskRefDrug, ""); err != nil {
		t.Error(err)
	}
	if err := TasksOneDrugCheck("", ""); err != nil {
		t.Error(err)
	}
	if err := TasksOneDrugCheck(taskRefDrug, taskDrug); err == nil {
		t.Error("two drugs accepted")
	}

	if err := TasksDrugDoseCheck(dose, taskRefDrug, ""); err != nil {
		t.Error(err)
	}
	if err := TasksDrugDoseCheck(dose, "", taskDrug); err != nil {
		t.Error(err)
	}
	if err := TasksDrugDoseCheck(null, "", ""); err != nil {
		t.Error(err)
	}
	if err := TasksDrugDoseCheck(nil, "", ""); err != nil {
		t.Error(err)
	}
	if err := TasksDrugDoseCheck(null, taskRefDrug, ""); err == nil {
		t.Error("drug without dose accepted")
	}
	if err := TasksDrugDoseCheck(dose, "", ""); err == nil {
		t.Error("dose without drug accepted")
	}
	if err := TasksDrugDoseCheck(types.JSONRaw(`"x"`), "", ""); err == nil {
		t.Error("string dose accepted")
	}

	if err := TasksDrugManualApiaryCheck(dose, "manual", taskApiary); err != nil {
		t.Error(err)
	}
	if err := TasksDrugManualApiaryCheck(null, "inspection", ""); err != nil {
		t.Error(err)
	}
	if err := TasksDrugManualApiaryCheck(dose, "manual", ""); err == nil {
		t.Error("dose without apiary accepted")
	}
	if err := TasksDrugManualApiaryCheck(dose, "treatment", taskApiary); err == nil {
		t.Error("dose on automatic task accepted")
	}
}

func TestTasksSourceStepChecks(t *testing.T) {
	for _, raw := range []types.JSONRaw{nil, types.JSONRaw("null"), types.JSONRaw("1"), types.JSONRaw("60")} {
		if err := TasksSourceStepCheck(raw); err != nil {
			t.Errorf("source_step %s rejected: %v", raw, err)
		}
	}
	for _, raw := range []types.JSONRaw{types.JSONRaw("0"), types.JSONRaw("61"), types.JSONRaw("1.5"), types.JSONRaw("true")} {
		if err := TasksSourceStepCheck(raw); err == nil {
			t.Errorf("source_step %s accepted", raw)
		}
	}

	if err := TasksQueenRearingStepCheck("queen_rearing", types.JSONRaw("5")); err != nil {
		t.Error(err)
	}
	if err := TasksQueenRearingStepCheck("manual", nil); err != nil {
		t.Error(err)
	}
	if err := TasksQueenRearingStepCheck("queen_rearing", types.JSONRaw("null")); err == nil {
		t.Error("queen_rearing without step accepted")
	}
	if err := TasksQueenRearingStepCheck("inspection", types.JSONRaw("5")); err == nil {
		t.Error("step on inspection task accepted")
	}
}
