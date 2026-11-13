package migrations

import (
	"slices"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

const (
	testCustomer        = "0195f2a4-adad-7000-8000-000000000001"
	testTransaction     = "0195f2a4-abab-7000-8000-000000000001"
	testCustomerPayment = "0195f2a4-aeae-7000-8000-000000000001"
	testSupportPeriod   = "01900000-0000-7000-8000-000000000301"
	testReceiptFile     = "0195f2a4-acac-7000-8000-000000000001"
)

func TestFinanceCollectionShapes(t *testing.T) {
	app := newApp(t)

	cases := []struct {
		name    string
		fields  fieldSpec
		indexes []string
	}{
		{
			name: "customers",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":  "text!",
				"name":    "text!",
				"phone":   "text",
				"address": "text",
				"notes":   "text",
			}),
			indexes: []string{
				"idx_customers_org_id_server_seq||org_id,server_seq|",
				"idx_customers_server_seq|unique|server_seq|",
			},
		},
		{
			name: "transactions",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":       "text!",
				"kind":         "select!",
				"category":     "select!",
				"amount":       "number!",
				"currency":     "text!",
				"occurred_on":  "text!",
				"description":  "text",
				"receipt_path": "text",
				"apiary_id":    "text",
				"lot_id":       "text",
				"transport_id": "text",
				"lot_sale_id":  "text",
				"customer_id":  "text",
			}),
			indexes: []string{
				"idx_transactions_apiary_id||apiary_id|",
				"idx_transactions_customer_id||customer_id|",
				"idx_transactions_lot_id||lot_id|",
				"idx_transactions_lot_sale_id||lot_sale_id|",
				"idx_transactions_org_id_server_seq||org_id,server_seq|",
				"idx_transactions_server_seq|unique|server_seq|",
				"idx_transactions_transport_id||transport_id|",
			},
		},
		{
			name: "customer_payments",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":         "text!",
				"transaction_id": "text!",
				"amount":         "number!",
				"paid_on":        "text!",
			}),
			indexes: []string{
				"idx_customer_payments_org_id_server_seq||org_id,server_seq|",
				"idx_customer_payments_server_seq|unique|server_seq|",
				"idx_customer_payments_transaction_id||transaction_id|",
			},
		},
		{
			// No org_id: a reference collection.
			name: "ref_support_periods",
			fields: with(commonSyncFields, fieldSpec{
				"name":                  "text!",
				"application_starts_on": "text!",
				"application_ends_on":   "text!",
				"description":           "text",
				"source_url":            "text",
			}),
			indexes: []string{
				"idx_ref_support_periods_server_seq|unique|server_seq|",
			},
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			c, err := app.FindCollectionByNameOrId(tc.name)
			if err != nil {
				t.Fatal(err)
			}
			if c.Type != core.CollectionTypeBase {
				t.Errorf("type = %s, want base", c.Type)
			}
			if got := describeFields(c); !mapsEqual(got, tc.fields) {
				t.Errorf("fields\n got  %v\n want %v", got, tc.fields)
			}
			if got := describeIndexes(c); !slices.Equal(got, tc.indexes) {
				t.Errorf("indexes\n got  %q\n want %q", got, tc.indexes)
			}
			for rule, v := range map[string]*string{
				"list": c.ListRule, "view": c.ViewRule, "create": c.CreateRule,
				"update": c.UpdateRule, "delete": c.DeleteRule,
			} {
				if v != nil {
					t.Errorf("%s rule = %q, want nil", rule, *v)
				}
			}
			for _, f := range c.Fields {
				if f.Type() == core.FieldTypeAutodate {
					t.Errorf("autodate field %q", f.GetName())
				}
			}
		})
	}
}

func TestFinanceSelectValues(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId("transactions")
	if err != nil {
		t.Fatal(err)
	}
	want := map[string][]string{
		"kind": {"income", "expense"},
		"category": {
			"feeding", "treatment", "equipment", "fuel_transport", "land_rent",
			"labor", "lab_analysis", "honey", "pollen", "propolis", "wax", "nucs",
			"queens", "other",
		},
	}
	for name, values := range want {
		f, ok := c.Fields.GetByName(name).(*core.SelectField)
		if !ok {
			t.Fatalf("transactions.%s is not a select", name)
		}
		if !slices.Equal(f.Values, values) || f.MaxSelect != 1 {
			t.Errorf("transactions.%s = %v (max %d), want %v (max 1)", name, f.Values, f.MaxSelect, values)
		}
	}
}

func TestFinanceFields(t *testing.T) {
	app := newApp(t)

	customer := func() *core.Record {
		r := newRow(t, app, "customers", testCustomer, 1)
		r.Set("name", "Ayşe Hanım")
		return r
	}
	transaction := func() *core.Record {
		r := newRow(t, app, "transactions", testTransaction, 1)
		r.Set("kind", "income")
		r.Set("category", "honey")
		r.Set("amount", 1500)
		r.Set("currency", "TRY")
		r.Set("occurred_on", "2026-09-01")
		return r
	}
	payment := func() *core.Record {
		r := newRow(t, app, "customer_payments", testCustomerPayment, 1)
		r.Set("transaction_id", testTransaction)
		r.Set("amount", 500)
		r.Set("paid_on", "2026-09-15")
		return r
	}
	period := func() *core.Record {
		r := newRow(t, app, "ref_support_periods", testSupportPeriod, 1)
		r.Set("org_id", nil)
		r.Set("name", "Arıcılık desteği")
		r.Set("application_starts_on", "2027-01-15")
		r.Set("application_ends_on", "2027-02-15")
		return r
	}
	for _, base := range []func() *core.Record{customer, transaction, payment, period} {
		r := base()
		if err := app.Validate(r); err != nil {
			t.Fatalf("valid %s rejected: %v", r.Collection().Name, err)
		}
	}

	long := func(n int) string { return strings.Repeat("ş", n) }
	receipt := testOrg + "/" + testTransaction + "/" + testReceiptFile + ".jpg"

	checkValues(t, app, customer,
		map[string][]any{
			"name":    {long(100)},
			"phone":   {"", "+90 555 123 45 67", long(30)},
			"address": {"", long(300)},
			"notes":   {"", long(500)},
		},
		map[string][]any{
			"name":    {"", long(101)},
			"phone":   {long(31)},
			"address": {long(301)},
			"notes":   {long(501)},
		})
	checkValues(t, app, transaction,
		map[string][]any{
			"kind":         {"expense"},
			"category":     {"feeding", "lab_analysis", "nucs", "queens", "other"},
			"amount":       {0.01, 12.34, 999999999999.99, 1e12},
			"currency":     {"EUR", "IRR"},
			"description":  {"", long(200)},
			"receipt_path": {"", receipt},
			"apiary_id":    {"", testApiary},
			"lot_id":       {"", testLot},
			"transport_id": {""},
			"lot_sale_id":  {"", testLotSale},
			"customer_id":  {"", testCustomer},
		},
		map[string][]any{
			"kind":         {"", "refund"},
			"category":     {"", "rent"},
			"amount":       {0, -1, 1000000000000.01, 1e13},
			"currency":     {"", "try", "TL", "TRYY", "TR1"},
			"occurred_on":  {"", "2026-9-1", testTime},
			"description":  {long(201)},
			"receipt_path": {"receipt.jpg", testOrg + "/" + testTransaction + "/" + testReceiptFile + ".png", testOrg + "/" + testReceiptFile + ".jpg"},
			"apiary_id":    {"apiary-1"},
			"customer_id":  {"x"},
		})
	checkValues(t, app, payment,
		map[string][]any{
			"amount": {0.01, 999999999999.99, 1e12},
		},
		map[string][]any{
			"transaction_id": {"", "sale-1"},
			"amount":         {0, -0.01, 1000000000000.01},
			"paid_on":        {"", "15.09.2026"},
		})
	checkValues(t, app, period,
		map[string][]any{
			"name":        {long(200)},
			"description": {"", long(2000)},
			"source_url":  {"", "https://www.tarimorman.gov.tr/", "http://example.org/" + strings.Repeat("a", 1000-len("http://example.org/"))},
		},
		map[string][]any{
			"name":                  {"", long(201)},
			"application_starts_on": {"", "2027-1-15"},
			"application_ends_on":   {"", testTime},
			"description":           {long(2001)},
			"source_url":            {"www.tarimorman.gov.tr", "ftp://x", "javascript:alert(1)", "https://" + strings.Repeat("a", 1000)},
		})
}

// Supabase has no support periods to carry over: the admin SQL holds only a
// commented example and the live table and the P0.2 backup are empty
// (2026-11-10).
func TestRefSupportPeriodsEmpty(t *testing.T) {
	app := newApp(t)
	n, err := app.CountRecords("ref_support_periods")
	if err != nil {
		t.Fatal(err)
	}
	if n != 0 {
		t.Errorf("ref_support_periods rows = %d, want 0", n)
	}
}

func TestDownFinanceCustomersSupportPeriods(t *testing.T) {
	app := newApp(t)
	if err := downFinanceCustomersSupportPeriods(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range financeCollections {
		if _, err := app.FindCollectionByNameOrId(name); err == nil {
			t.Errorf("%s still exists", name)
		}
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}
	for _, name := range inventoryLotCollections {
		if _, err := app.FindCollectionByNameOrId(name); err != nil {
			t.Errorf("%s removed: %v", name, err)
		}
	}
	if err := upFinanceCustomersSupportPeriods(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
