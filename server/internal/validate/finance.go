package validate

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"math/big"
	"regexp"
	"strconv"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// Checks of transactions (20261103120000), customers and customer_payments
// (20261104120000), the amount limit (20261117120000) and ref_support_periods
// (20261105120000).

// MaxAmount is the upper bound of transactions.amount and
// customer_payments.amount (20261117120000: numeric(18, 2), at most 10¹²).
const MaxAmount = 1e12

// ReceiptStoragePath is the shape of transactions.receipt_path:
// `<org_id>/<id>/<file_id>.jpg` in the receipts bucket (the object name
// private.receipt_object_org_id accepted, with the first two folders
// lower-case UUIDs as transactions_check2 produces them). The migration uses
// it as the field pattern; [TransactionsCheck2] ties the parts to the row.
var ReceiptStoragePath = "^" + uuidPart + "/" + uuidPart + "/" + documentFilePart + `\.jpg$`

// Amount is the money rule of transactions and customer_payments: a number,
// > 0, <= [MaxAmount], with at most 2 decimals. v is the decoded JSON value
// (float64 or json.Number) or a float64 field value.
//
// Supabase's numeric(18, 2) rounded a third decimal away; here it is
// rejected, because the stored value is a float64 and must be the cents the
// client meant. The client sends `(x * 100).round() / 100`, whose shortest
// decimal form has at most 2 decimals. float64 keeps 15 significant digits
// exactly (DBL_DIG), and 10¹² in cents is 15 digits, so every amount up to
// the limit survives the round trip cent for cent (finance_test.go).
func Amount(v any) error {
	var f float64
	switch n := v.(type) {
	case float64:
		f = n
	case json.Number:
		parsed, err := strconv.ParseFloat(n.String(), 64)
		if err != nil {
			return fmt.Errorf("must be a number, got %q", n.String())
		}
		f = parsed
	default:
		return fmt.Errorf("must be a number, got %T", v)
	}
	if math.IsNaN(f) || math.IsInf(f, 0) {
		return fmt.Errorf("must be a finite number, got %v", f)
	}
	if !(f > 0 && f <= MaxAmount) {
		return fmt.Errorf("must be > 0 and <= %.0f, got %v", MaxAmount, f)
	}
	// The shortest decimal form of f is what the client's JSON carried.
	exact, ok := new(big.Rat).SetString(strconv.FormatFloat(f, 'f', -1, 64))
	if !ok {
		return fmt.Errorf("must be a number, got %v", f)
	}
	if !exact.Mul(exact, big.NewRat(100, 1)).IsInt() {
		return fmt.Errorf("must have at most 2 decimals, got %s", strconv.FormatFloat(f, 'f', -1, 64))
	}
	return nil
}

// TransactionsAmountCheck is transactions_amount_check (20261117120000) plus
// the 2-decimal scale: see [Amount].
func TransactionsAmountCheck(amount any) error {
	return column("amount", Amount(amount))
}

// CustomerPaymentsAmountCheck is customer_payments_amount_check
// (20261117120000) plus the 2-decimal scale: see [Amount].
func CustomerPaymentsAmountCheck(amount any) error {
	return column("amount", Amount(amount))
}

// TransactionsDescriptionCheck is transactions_description_check: null, or
// 1–200 characters after trimming spaces.
func TransactionsDescriptionCheck(description string) error {
	return btrimLength("description", description, true, 1, 200)
}

// Categories of each transaction kind (transactions_check).
var (
	expenseCategories = map[string]bool{
		"feeding": true, "treatment": true, "queens": true, "equipment": true,
		"fuel_transport": true, "land_rent": true, "labor": true,
		"lab_analysis": true, "other": true,
	}
	incomeCategories = map[string]bool{
		"honey": true, "pollen": true, "propolis": true, "wax": true,
		"queens": true, "nucs": true, "other": true,
	}
)

// TransactionsCheck is transactions_check: the category belongs to the kind
// (queens and other belong to both).
func TransactionsCheck(kind, category string) error {
	ok := (kind == "expense" && expenseCategories[category]) ||
		(kind == "income" && incomeCategories[category])
	if !ok {
		return fmt.Errorf("category %q does not belong to kind %q", category, kind)
	}
	return nil
}

// TransactionsCheck1 is transactions_check1: a transaction linked to a lot
// sale is income and carries the lot.
func TransactionsCheck1(kind, lotID, lotSaleID string) error {
	if lotSaleID != "" && (kind != "income" || lotID == "") {
		return errors.New("lot_sale_id needs kind income and lot_id")
	}
	return nil
}

// TransactionsCheck2 is transactions_check2: receipt_path is null or
// `<org_id>/<id>/<file_id>.jpg`, so a row cannot point at another
// organization's or transaction's folder.
func TransactionsCheck2(id, orgID, receiptPath string) error {
	if receiptPath == "" {
		return nil
	}
	re := regexp.MustCompile("^" + regexp.QuoteMeta(orgID+"/"+id+"/") + documentFilePart + `\.jpg$`)
	if !re.MatchString(receiptPath) {
		return fmt.Errorf("receipt_path must be %s/%s/<file_id>.jpg, got %s", orgID, id, receiptPath)
	}
	return nil
}

// TransactionsCheck3 is transactions_check3 (20261104120000): only income
// has a customer.
func TransactionsCheck3(kind, customerID string) error {
	if customerID != "" && kind != "income" {
		return fmt.Errorf("customer_id needs kind income, got %q", kind)
	}
	return nil
}

// CustomersNameCheck is customers_name_check: 1–100 characters after
// trimming spaces.
func CustomersNameCheck(name string) error {
	return btrimLength("name", name, false, 1, 100)
}

// CustomersPhoneCheck is customers_phone_check: null, or 1–30 characters
// after trimming spaces.
func CustomersPhoneCheck(phone string) error {
	return btrimLength("phone", phone, true, 1, 30)
}

// CustomersAddressCheck is customers_address_check: null, or 1–300
// characters after trimming spaces.
func CustomersAddressCheck(address string) error {
	return btrimLength("address", address, true, 1, 300)
}

// CustomersNotesCheck is customers_notes_check: null, or 1–500 characters
// after trimming spaces.
func CustomersNotesCheck(notes string) error {
	return btrimLength("notes", notes, true, 1, 500)
}

// ErrPaymentNeedsCustomerSale is [CheckCustomerPayment]'s rejection.
var ErrPaymentNeedsCustomerSale = errors.New("a payment is taken only for a sale linked to a customer")

// CheckCustomerPayment is Supabase's check_customer_payment trigger (before
// insert on customer_payments; errcode 23514, push answers `invalid`): a
// payment goes only to a sale that has a customer. The sale's customer does
// not change later (transactions are events), so the rule runs on insert
// only. A sale that does not exist in the payment's organization passes
// here, as in the trigger: missing and cross-organization links are the
// same-organization check's (P5.3, `missing_reference`). Deleted sales count
// like live ones, as in the trigger.
//
// Wired into push in P5.3.
func CheckCustomerPayment(app core.App, orgID, transactionID string) error {
	var sale struct {
		CustomerID string `db:"customer_id"`
	}
	err := app.RecordQuery("transactions").
		Select("customer_id").
		AndWhere(dbx.HashExp{"id": transactionID, "org_id": orgID}).
		Limit(1).
		One(&sale)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil
		}
		return err
	}
	if sale.CustomerID == "" {
		return ErrPaymentNeedsCustomerSale
	}
	return nil
}

// RefSupportPeriodsNameCheck is ref_support_periods_name_check: 1–200
// characters after trimming spaces.
func RefSupportPeriodsNameCheck(name string) error {
	return btrimLength("name", name, false, 1, 200)
}

// RefSupportPeriodsDescriptionCheck is
// ref_support_periods_description_check: null, or 1–2000 characters after
// trimming spaces.
func RefSupportPeriodsDescriptionCheck(description string) error {
	return btrimLength("description", description, true, 1, 2000)
}

// RefSupportPeriodsCheck is ref_support_periods_check: the application
// period ends on or after its start. Both are YYYY-MM-DD, so text order is
// date order.
func RefSupportPeriodsCheck(startsOn, endsOn string) error {
	if endsOn < startsOn {
		return fmt.Errorf("application_ends_on %s is before application_starts_on %s", endsOn, startsOn)
	}
	return nil
}
