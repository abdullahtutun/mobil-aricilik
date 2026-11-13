package validate

import (
	"encoding/json"
	"fmt"
	"math"
	"math/rand/v2"
	"strconv"
	"strings"
	"testing"
)

func TestAmount(t *testing.T) {
	// A variable, so 0.1 + 0.2 is float64 arithmetic (0.30000000000000004),
	// not an exact constant.
	tenth := 0.1
	for _, v := range []any{
		0.01, 1.0, 12.5, 12.34, 1500.0, 999999999999.99, 1e12,
		json.Number("0.01"), json.Number("12.50"), json.Number("1000000000000"),
		json.Number("1e3"), json.Number("1000000000000.00"),
	} {
		if err := Amount(v); err != nil {
			t.Errorf("Amount(%v) rejected: %v", v, err)
		}
	}
	for _, v := range []any{
		// Not a number.
		nil, "12.5", true, map[string]any{}, json.Number("abc"), json.Number("1e400"),
		math.NaN(), math.Inf(1), math.Inf(-1),
		// Not > 0.
		0.0, -0.01, -5.0, json.Number("0"), json.Number("-1"),
		// Above 10¹².
		1000000000000.01, 1e13, json.Number("1000000000000.01"),
		// More than 2 decimals.
		0.001, 12.345, tenth + 2*tenth, 999999999999.999, json.Number("12.345"),
	} {
		if err := Amount(v); err == nil {
			t.Errorf("Amount(%#v) accepted", v)
		}
	}
	if err := TransactionsAmountCheck(0.0); err == nil || !strings.HasPrefix(err.Error(), "amount: ") {
		t.Errorf("TransactionsAmountCheck(0) = %v", err)
	}
	if err := CustomerPaymentsAmountCheck(12.345); err == nil || !strings.HasPrefix(err.Error(), "amount: ") {
		t.Errorf("CustomerPaymentsAmountCheck(12.345) = %v", err)
	}
}

// formatCents is cents as the shortest decimal (no trailing zeros), the way
// Dart's jsonEncode and Go's strconv print a float64 amount.
func formatCents(cents int64) string {
	s := fmt.Sprintf("%d.%02d", cents/100, cents%100)
	return strings.TrimSuffix(strings.TrimRight(s, "0"), ".")
}

// float64 carries every 2-decimal amount up to 10¹² exactly enough: the
// client's value cents/100 prints back as the same decimal, survives JSON,
// stays apart from its neighbours and passes Amount.
func TestAmountFloat64Precision(t *testing.T) {
	const maxCents = int64(MaxAmount) * 100 // 10¹⁴, 15 digits
	check := func(cents int64) {
		t.Helper()
		v := float64(cents) / 100
		want := formatCents(cents)
		if got := strconv.FormatFloat(v, 'f', -1, 64); got != want {
			t.Fatalf("%d cents prints as %s, want %s", cents, got, want)
		}
		raw, err := json.Marshal(v)
		if err != nil {
			t.Fatal(err)
		}
		var back float64
		if err := json.Unmarshal(raw, &back); err != nil || back != v {
			t.Fatalf("%d cents: JSON %s decodes to %v (%v)", cents, raw, back, err)
		}
		if err := Amount(v); err != nil {
			t.Fatalf("%d cents rejected: %v", cents, err)
		}
		if err := Amount(json.Number(want)); err != nil {
			t.Fatalf("%s rejected: %v", want, err)
		}
		if cents > 1 && float64(cents-1)/100 == v {
			t.Fatalf("%d and %d cents are the same float64", cents-1, cents)
		}
	}

	// The top of the range, where float64 has the fewest bits for cents.
	for c := maxCents - 200000; c <= maxCents; c++ {
		check(c)
	}
	// The bottom and a fixed random sample of the rest.
	for c := int64(1); c <= 100000; c++ {
		check(c)
	}
	rng := rand.New(rand.NewPCG(1, 2))
	for range 200000 {
		check(1 + rng.Int64N(maxCents))
	}

	// The client rounds to cents with `(x * 100).round() / 100`; that value
	// always passes.
	for range 100000 {
		x := rng.Float64() * MaxAmount
		v := math.Round(x*100) / 100
		if v <= 0 {
			continue
		}
		if err := Amount(v); err != nil {
			t.Fatalf("client-rounded %v rejected: %v", v, err)
		}
	}
	// One cent above the limit is a different float64 and is rejected.
	if over := float64(maxCents+1) / 100; over == MaxAmount || Amount(over) == nil {
		t.Errorf("10¹² + 0.01 = %v accepted", over)
	}
}

func TestTransactionsChecks(t *testing.T) {
	const (
		org  = "0195f2a4-1111-7000-8000-000000000001"
		id   = "0195f2a4-abab-7000-8000-000000000001"
		file = "0195f2a4-acac-7000-8000-000000000001"
		lot  = "0195f2a4-f5f5-7000-8000-000000000001"
		sale = "0195f2a4-f9f9-7000-8000-000000000001"
		cust = "0195f2a4-adad-7000-8000-000000000001"
	)

	for _, kc := range [][2]string{
		{"expense", "feeding"}, {"expense", "treatment"}, {"expense", "queens"},
		{"expense", "equipment"}, {"expense", "fuel_transport"}, {"expense", "land_rent"},
		{"expense", "labor"}, {"expense", "lab_analysis"}, {"expense", "other"},
		{"income", "honey"}, {"income", "pollen"}, {"income", "propolis"},
		{"income", "wax"}, {"income", "queens"}, {"income", "nucs"}, {"income", "other"},
	} {
		if err := TransactionsCheck(kc[0], kc[1]); err != nil {
			t.Errorf("%v rejected: %v", kc, err)
		}
	}
	for _, kc := range [][2]string{
		{"expense", "honey"}, {"expense", "nucs"}, {"income", "feeding"},
		{"income", "labor"}, {"", "other"}, {"income", ""},
	} {
		if err := TransactionsCheck(kc[0], kc[1]); err == nil {
			t.Errorf("%v accepted", kc)
		}
	}

	if err := TransactionsCheck1("expense", "", ""); err != nil {
		t.Error(err)
	}
	if err := TransactionsCheck1("expense", lot, ""); err != nil {
		t.Error(err)
	}
	if err := TransactionsCheck1("income", lot, sale); err != nil {
		t.Error(err)
	}
	if TransactionsCheck1("income", "", sale) == nil || TransactionsCheck1("expense", lot, sale) == nil {
		t.Error("lot sale without income and lot accepted")
	}

	for _, p := range []string{"", org + "/" + id + "/" + file + ".jpg"} {
		if err := TransactionsCheck2(id, org, p); err != nil {
			t.Errorf("receipt_path %q rejected: %v", p, err)
		}
	}
	for _, p := range []string{
		id + "/" + org + "/" + file + ".jpg",                               // swapped
		org + "/" + file + "/" + file + ".jpg",                             // another row
		"0195f2a4-1111-7000-8000-000000000009/" + id + "/" + file + ".jpg", // another org
		org + "/" + id + "/" + file + ".png",
		org + "/" + id + "/" + file + ".jpg.jpg",
		org + "/" + id + "/x.jpg",
	} {
		if err := TransactionsCheck2(id, org, p); err == nil {
			t.Errorf("receipt_path %q accepted", p)
		}
	}

	if TransactionsCheck3("income", cust) != nil || TransactionsCheck3("expense", "") != nil {
		t.Error("valid customer link rejected")
	}
	if TransactionsCheck3("expense", cust) == nil {
		t.Error("expense with a customer accepted")
	}

	for _, v := range []string{"", "Şeker", strings.Repeat("ş", 200), " a "} {
		if err := TransactionsDescriptionCheck(v); err != nil {
			t.Errorf("description %q rejected: %v", v, err)
		}
	}
	for _, v := range []string{"   ", strings.Repeat("a", 201)} {
		if err := TransactionsDescriptionCheck(v); err == nil {
			t.Errorf("description %q accepted", v)
		}
	}
}

func TestCustomersChecks(t *testing.T) {
	cases := []struct {
		check    func(string) error
		nullable bool
		max      int
	}{
		{CustomersNameCheck, false, 100},
		{CustomersPhoneCheck, true, 30},
		{CustomersAddressCheck, true, 300},
		{CustomersNotesCheck, true, 500},
		{RefSupportPeriodsNameCheck, false, 200},
		{RefSupportPeriodsDescriptionCheck, true, 2000},
	}
	for i, c := range cases {
		for _, v := range []string{"a", " ş ", strings.Repeat("ş", c.max), " " + strings.Repeat("a", c.max) + " "} {
			if err := c.check(v); err != nil {
				t.Errorf("case %d: %q rejected: %v", i, v, err)
			}
		}
		for _, v := range []string{"  ", strings.Repeat("a", c.max+1)} {
			if err := c.check(v); err == nil {
				t.Errorf("case %d: %q accepted", i, v)
			}
		}
		if err := c.check(""); (err == nil) != c.nullable {
			t.Errorf("case %d: empty → %v, nullable %v", i, err, c.nullable)
		}
	}
}

func TestRefSupportPeriodsCheck(t *testing.T) {
	if err := RefSupportPeriodsCheck("2027-01-15", "2027-02-15"); err != nil {
		t.Error(err)
	}
	if err := RefSupportPeriodsCheck("2027-01-15", "2027-01-15"); err != nil {
		t.Error("one-day period rejected:", err)
	}
	if err := RefSupportPeriodsCheck("2027-01-15", "2027-01-14"); err == nil {
		t.Error("end before start accepted")
	}
}
