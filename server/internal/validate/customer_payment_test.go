package validate_test

import (
	"errors"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const (
	testOrg      = "0195f2a4-1111-7000-8000-000000000001"
	otherOrg     = "0195f2a4-1111-7000-8000-000000000002"
	testCustomer = "0195f2a4-adad-7000-8000-000000000001"
	testTime     = "2026-11-10T10:15:30.123456Z"
	saleWithCust = "0195f2a4-abab-7000-8000-000000000001"
	saleNoCust   = "0195f2a4-abab-7000-8000-000000000002"
	deletedSale  = "0195f2a4-abab-7000-8000-000000000003"
	missingSale  = "0195f2a4-abab-7000-8000-000000000009"
)

// The scenarios of Supabase's check_customer_payment trigger
// (customers.test.sql): a payment needs a sale with a customer; a missing or
// other-organization sale is left to the reference check.
func TestCheckCustomerPayment(t *testing.T) {
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)

	c, err := app.FindCollectionByNameOrId("transactions")
	if err != nil {
		t.Fatal(err)
	}
	sale := func(id, customerID, deletedAt string, seq int) {
		r := core.NewRecord(c)
		r.Id = id
		r.Set("org_id", testOrg)
		r.Set("kind", "income")
		r.Set("category", "honey")
		r.Set("amount", 1500)
		r.Set("currency", "TRY")
		r.Set("occurred_on", "2026-09-01")
		r.Set("customer_id", customerID)
		r.Set("created_at", testTime)
		r.Set("updated_at", testTime)
		r.Set("deleted_at", deletedAt)
		r.Set("server_seq", seq)
		if err := app.Save(r); err != nil {
			t.Fatal(err)
		}
	}
	sale(saleWithCust, testCustomer, "", 1)
	sale(saleNoCust, "", "", 2)
	sale(deletedSale, "", testTime, 3)

	cases := []struct {
		org, sale string
		want      error
	}{
		{testOrg, saleWithCust, nil},
		{testOrg, saleNoCust, validate.ErrPaymentNeedsCustomerSale},
		// The trigger does not look at deleted_at.
		{testOrg, deletedSale, validate.ErrPaymentNeedsCustomerSale},
		// Missing, or in another organization: the reference check decides.
		{testOrg, missingSale, nil},
		{otherOrg, saleNoCust, nil},
	}
	for _, tc := range cases {
		if err := validate.CheckCustomerPayment(app, tc.org, tc.sale); !errors.Is(err, tc.want) {
			t.Errorf("CheckCustomerPayment(%s, %s) = %v, want %v", tc.org, tc.sale, err, tc.want)
		}
	}
}
