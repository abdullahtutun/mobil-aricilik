package validate

import "testing"

func TestTreatmentsCheck(t *testing.T) {
	start := "2026-11-10T10:15:30.123456Z"
	for _, removal := range []string{"", start, "2026-11-24T10:15:30.000000Z"} {
		if err := TreatmentsCheck(start, removal); err != nil {
			t.Errorf("removal %q rejected: %v", removal, err)
		}
	}
	for _, removal := range []string{"2026-11-10T10:15:30.123455Z", "2026-10-01T00:00:00.000000Z"} {
		if err := TreatmentsCheck(start, removal); err == nil {
			t.Errorf("removal %q before start accepted", removal)
		}
	}
}

func TestTreatmentsCheck1(t *testing.T) {
	const a, b = "01900000-0000-7000-8000-000000000201", "0195f2a4-5656-7000-8000-000000000001"
	if err := TreatmentsCheck1(a, ""); err != nil {
		t.Error(err)
	}
	if err := TreatmentsCheck1("", b); err != nil {
		t.Error(err)
	}
	if err := TreatmentsCheck1("", ""); err == nil {
		t.Error("no drug accepted")
	}
	if err := TreatmentsCheck1(a, b); err == nil {
		t.Error("two drugs accepted")
	}
}

func TestNumericChecks(t *testing.T) {
	for _, v := range []float64{0.01, 0.005, 2, 10000, 10000.004} {
		if err := TreatmentsDoseCheck(v); err != nil {
			t.Errorf("dose %v rejected: %v", v, err)
		}
	}
	// 0.004 rounds to 0.00, 10000.005 to 10000.01.
	for _, v := range []float64{0, 0.004, -1, 10000.005, 10001} {
		if err := TreatmentsDoseCheck(v); err == nil {
			t.Errorf("dose %v accepted", v)
		}
	}
	for _, v := range []float64{0.001, 0.0005, 1.5, 100, 100.0004} {
		if err := FeedingsAmountCheck(v); err != nil {
			t.Errorf("amount %v rejected: %v", v, err)
		}
	}
	for _, v := range []float64{0, 0.0004, -0.5, 100.0005, 101} {
		if err := FeedingsAmountCheck(v); err == nil {
			t.Errorf("amount %v accepted", v)
		}
	}
	if got := RoundNumeric(1.235, 2); got != 1.24 {
		t.Errorf("RoundNumeric(1.235, 2) = %v", got)
	}
	if got := RoundNumeric(0.3333333, 3); got != 0.333 {
		t.Errorf("RoundNumeric(0.3333333, 3) = %v", got)
	}
	if got := RoundNumeric(-1.5, 0); got != -2 {
		t.Errorf("RoundNumeric(-1.5, 0) = %v", got)
	}
}
