package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// customers, transactions, customer_payments and ref_support_periods in
// their final Supabase shape. Each field names the Supabase migration that
// defined it (supabase/migrations/…): 20261103120000_transactions,
// 20261104120000_customers (customers, customer_payments,
// transactions.customer_id), 20261105120000_support_periods and
// 20261117120000_raise_amount_limit (amount numeric(18, 2), at most 10¹²).
// Later migrations only change sync_push's kind map. Compared with the live
// project on 2026-11-10 (columns, CHECK names, indexes, triggers).
//
// As in 1794300003: no `unique (id, org_id)` and no composite foreign keys
// (same-organization links are checked on push, P5.3), and the
// `(org_id, server_seq)` index covers `<table>_org_id_idx`. Finance rows are
// owner/partner-only (Supabase RLS); that is the authz policy's (P3).
//
// ref_support_periods has no rows to carry over: the admin SQL
// (supabase/admin/ref_support_periods.sql) holds only a commented example,
// and the live table and the P0.2 backup are empty (2026-11-10). New periods
// come with the seed tool (P8.1).
//
// Checks a field option cannot express are in internal/validate:
// TransactionsAmountCheck, CustomerPaymentsAmountCheck (validate.Amount),
// TransactionsDescriptionCheck, TransactionsCheck, TransactionsCheck1,
// TransactionsCheck2, TransactionsCheck3, CustomersNameCheck,
// CustomersPhoneCheck, CustomersAddressCheck, CustomersNotesCheck,
// RefSupportPeriodsNameCheck, RefSupportPeriodsDescriptionCheck,
// RefSupportPeriodsCheck. The check_customer_payment trigger is
// validate.CheckCustomerPayment (push, P5.3).
func init() {
	m.Register(upFinanceCustomersSupportPeriods, downFinanceCustomersSupportPeriods)
}

// Postgres enums, labels verbatim.
var (
	// public.transaction_kind (20261103120000).
	transactionKinds = []string{"income", "expense"}
	// public.transaction_category (20261103120000): expense, income, both.
	transactionCategories = []string{
		"feeding", "treatment", "equipment", "fuel_transport", "land_rent",
		"labor", "lab_analysis",
		"honey", "pollen", "propolis", "wax", "nucs",
		"queens", "other",
	}
)

// financeCollections lists this migration's collections, in creation order;
// down removes them in reverse.
var financeCollections = []string{
	"customers", "transactions", "customer_payments", "ref_support_periods",
}

// amountField is a numeric(18, 2) money column: required (rejects 0),
// 0 < amount <= 10¹². The 2-decimal scale is validate.Amount.
func amountField() *core.NumberField {
	return &core.NumberField{
		Name:     "amount",
		Required: true,
		Min:      types.Pointer(0.0),
		Max:      types.Pointer(validate.MaxAmount),
	}
}

func upFinanceCustomersSupportPeriods(app core.App) error {
	// All of customers comes from 20261104120000. Personal data (teknik.md
	// §9).
	customers := syncedCollection("customers",
		// name text not null check (char_length(btrim(name)) between 1 and
		// 100) (customers_name_check → validate).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 100},
		// phone text check (… between 1 and 30), nullable
		// (customers_phone_check → validate).
		&core.TextField{Name: "phone", Max: 30},
		// address text check (… between 1 and 300), nullable
		// (customers_address_check → validate).
		&core.TextField{Name: "address", Max: 300},
		// notes text check (… between 1 and 500), nullable
		// (customers_notes_check → validate).
		&core.TextField{Name: "notes", Max: 500},
	)
	if err := app.Save(customers); err != nil {
		return err
	}

	transactions := syncedCollection("transactions",
		// 20261103120000: kind transaction_kind not null.
		selectField("kind", true, transactionKinds...),
		// category transaction_category not null; belongs to the kind
		// (transactions_check → validate).
		selectField("category", true, transactionCategories...),
		// amount numeric(18, 2) not null check (amount > 0 and amount <=
		// 1000000000000) (transactions_amount_check, 20261117120000).
		amountField(),
		// currency text not null check (currency ~ '^[A-Z]{3}$')
		// (transactions_currency_check).
		&core.TextField{Name: "currency", Required: true, Min: 3, Max: 3, Pattern: `^[A-Z]{3}$`},
		// occurred_on date not null.
		dateField("occurred_on", true),
		// description text check (… between 1 and 200), nullable
		// (transactions_description_check → validate).
		&core.TextField{Name: "description", Max: 200},
		// receipt_path text, nullable; `<org_id>/<id>/<file_id>.jpg`
		// (transactions_check2 → validate.TransactionsCheck2).
		&core.TextField{Name: "receipt_path", Max: 3*36 + 2 + len(".jpg"), Pattern: validate.ReceiptStoragePath},
		// apiary_id, lot_id, transport_id, lot_sale_id uuid, nullable;
		// (x, org_id) FKs to apiaries, lots, transports and lot_sales. A lot
		// sale needs income and the lot (transactions_check1 → validate).
		uuidField("apiary_id", false),
		uuidField("lot_id", false),
		uuidField("transport_id", false),
		uuidField("lot_sale_id", false),
		// 20261104120000: customer_id uuid, nullable (added after
		// server_seq in Postgres); (customer_id, org_id) FK to customers.
		// Only income (transactions_check3 → validate).
		uuidField("customer_id", false),
	)
	// transactions_apiary_id_idx, transactions_lot_id_idx,
	// transactions_transport_id_idx, transactions_lot_sale_id_idx,
	// transactions_customer_id_idx.
	transactions.AddIndex("idx_transactions_apiary_id", false, "`apiary_id`", "")
	transactions.AddIndex("idx_transactions_lot_id", false, "`lot_id`", "")
	transactions.AddIndex("idx_transactions_transport_id", false, "`transport_id`", "")
	transactions.AddIndex("idx_transactions_lot_sale_id", false, "`lot_sale_id`", "")
	transactions.AddIndex("idx_transactions_customer_id", false, "`customer_id`", "")
	if err := app.Save(transactions); err != nil {
		return err
	}

	// All of customer_payments comes from 20261104120000; amount from
	// 20261117120000.
	payments := syncedCollection("customer_payments",
		// transaction_id uuid not null; (transaction_id, org_id) FK to
		// transactions. The sale has a customer: check_customer_payment →
		// validate.CheckCustomerPayment.
		uuidField("transaction_id", true),
		// amount numeric(18, 2) not null check (amount > 0 and amount <=
		// 1000000000000) (customer_payments_amount_check).
		amountField(),
		// paid_on date not null.
		dateField("paid_on", true),
	)
	// customer_payments_transaction_id_idx.
	payments.AddIndex("idx_customer_payments_transaction_id", false, "`transaction_id`", "")
	if err := app.Save(payments); err != nil {
		return err
	}

	// All of ref_support_periods comes from 20261105120000: a read-only
	// reference list (TR), no org_id; every signed-in user reads it, nobody
	// writes it from the client.
	periods := syncedCollectionWithoutOrg("ref_support_periods",
		// name text not null check (char_length(btrim(name)) between 1 and
		// 200) (ref_support_periods_name_check → validate).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 200},
		// application_starts_on, application_ends_on date not null; both
		// days included, end not before start (ref_support_periods_check →
		// validate).
		dateField("application_starts_on", true),
		dateField("application_ends_on", true),
		// description text check (… between 1 and 2000), nullable
		// (ref_support_periods_description_check → validate).
		&core.TextField{Name: "description", Max: 2000},
		// source_url text check (source_url ~ '^https?://' and
		// char_length(source_url) <= 1000), nullable
		// (ref_support_periods_source_url_check).
		&core.TextField{Name: "source_url", Max: 1000, Pattern: `^https?://`},
	)
	return app.Save(periods)
}

func downFinanceCustomersSupportPeriods(app core.App) error {
	for i := len(financeCollections) - 1; i >= 0; i-- {
		c, err := app.FindCollectionByNameOrId(financeCollections[i])
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
