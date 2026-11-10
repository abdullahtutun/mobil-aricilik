package sync

import (
	"encoding/json"
	"fmt"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/authz"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// Table rules of push (P5.3): the Supabase CHECK constraints and triggers
// that a PocketBase field option cannot express. The CHECKs live in
// internal/validate, named after the constraint; this file says which ones
// run on which table.

// numericScales are the numeric(p, s) columns: push stores the value
// rounded to s decimals, as Postgres did (validate.RoundNumeric). Money
// (transactions.amount, customer_payments.amount) is not here: a third
// decimal is rejected (validate.Amount).
var numericScales = map[string]map[string]int{
	"treatments":      {"dose": 2},
	"feedings":        {"amount": 3},
	"tasks":           {"dose": 2},
	"harvests":        {"net_kg": 3},
	"inventory_items": {"threshold": 3},
	"inventory_moves": {"quantity": 3},
	"lots":            {"moisture": 1},
	"lab_results":     {"hmf": 1, "diastase": 1, "proline": 1, "moisture": 1},
	"lot_sales":       {"kg": 3},
}

// roundNumerics rounds the numeric columns of values in place. A nullable
// one is JSON (null or a number); anything else is left for the CHECK to
// refuse.
func roundNumerics(table string, values map[string]any) {
	for name, scale := range numericScales[table] {
		switch v := values[name].(type) {
		case float64:
			values[name] = validate.RoundNumeric(v, scale)
		case types.JSONRaw:
			var f float64
			if len(v) == 0 || json.Unmarshal(v, &f) != nil {
				continue
			}
			if b, err := json.Marshal(validate.RoundNumeric(f, scale)); err == nil {
				values[name] = types.JSONRaw(b)
			}
		}
	}
}

// Publication columns of lots (20261102180000).
var lotPublication = []string{"published", "public_producer", "public_origin", "public_lab", "public_report"}

// Quarantine columns of hives (20261107120000).
var hiveQuarantine = []string{"quarantined", "quarantined_at", "quarantine_disease"}

// guardRow applies Supabase's BEFORE INSERT/UPDATE triggers that rewrite the
// row instead of refusing it, on the row about to be written. prior is the
// stored row (nil for a new one); payload tells which keys the client sent:
// an older app does not send columns added after it, and their stored
// values must survive. orgID is the organization the row is written in.
func guardRow(txApp core.App, userID, table, orgID string, row, prior *core.Record, payload map[string]json.RawMessage) error {
	switch table {
	case "lots":
		return guardLotPublication(txApp, userID, orgID, row, prior, payload)
	case "hives":
		keepHiveQuarantine(row, prior, payload)
	}
	return nil
}

// guardLotPublication is private.guard_lot_publication: only an owner sets
// the publication columns. Someone else's write keeps the stored values (a
// new lot is not published, its public_* are as sent or true); the write
// itself is not refused, because a worker's ordinary lot edit carries them
// too. Columns an older app did not send keep their stored values, or the
// defaults on a new lot, for an owner as well.
func guardLotPublication(txApp core.App, userID, orgID string, row, prior *core.Record, payload map[string]json.RawMessage) error {
	isOwner, err := authz.HasRole(txApp, userID, orgID, authz.Owner)
	if err != nil {
		return err
	}
	for _, name := range lotPublication {
		sent := !isNull(payload[name])
		switch {
		case prior == nil && name == "published":
			row.Set(name, isOwner && sent && row.GetBool(name))
		case prior == nil:
			if !sent {
				row.Set(name, true)
			}
		case !isOwner || !sent:
			row.Set(name, prior.GetBool(name))
		}
	}
	return nil
}

// keepHiveQuarantine is private.keep_hive_quarantine: a write without
// `quarantined` (an app older than schema 22) keeps the three quarantine
// columns as stored; a new hive is not quarantined. A write that sends
// `quarantined` takes all three as sent.
func keepHiveQuarantine(row, prior *core.Record, payload map[string]json.RawMessage) {
	if !isNull(payload["quarantined"]) {
		return
	}
	for _, name := range hiveQuarantine {
		if prior == nil {
			row.Set(name, nil)
		} else {
			row.Set(name, prior.Get(name))
		}
	}
}

// checkRow runs the table's CHECK constraints on row and answers a failure
// with invalid. onInsert adds the BEFORE INSERT checks
// (check_customer_payment), which Supabase ran on the proposed row of every
// upsert, before the conflict with a stored row was known.
func checkRow(txApp core.App, table string, row *core.Record, onInsert bool) error {
	err := tableChecks(row, table)
	if err == nil && onInsert && table == "customer_payments" {
		err = validate.CheckCustomerPayment(txApp, row.GetString("org_id"), row.GetString("transaction_id"))
		if err != nil && err != validate.ErrPaymentNeedsCustomerSale {
			return err
		}
	}
	if err != nil {
		return reject(ReasonInvalid, "%s: %s", table, err.Error())
	}
	return nil
}

// tableChecks returns the first failing CHECK of the table, nil when all
// pass. Every validate function that guards a pushable table is called here
// (rules_test.go checks the list against the validate package).
func tableChecks(r *core.Record, table string) error {
	s := r.GetString
	j := func(name string) types.JSONRaw { return jsonOf(r, name) }
	f := r.GetFloat
	switch table {
	case "organizations":
		return first(
			validate.OrganizationsTrAksHiveCountCheck(j("tr_aks_hive_count")),
			validate.OrganizationsLogoPathCheck(r.Id, s("logo_path")),
		)
	case "apiaries":
		return first(
			validate.ApiariesLocationCheck(j("latitude"), j("longitude")),
			validate.ApiariesAltitudeMCheck(j("altitude_m")),
			validate.ApiariesVehicleDistanceMCheck(j("vehicle_distance_m")),
		)
	case "queens":
		return first(
			validate.QueensYearCheck(j("year")),
			validate.QueensCheck(r.Id, s("mother_queen_id")),
		)
	case "hives":
		return first(
			validate.HivesFrameCountCheck(j("frame_count")),
			validate.HivesQuarantineDiseaseCheck(s("quarantine_disease")),
			validate.HivesQuarantineConsistent(r.GetBool("quarantined"), s("quarantined_at"), s("quarantine_disease")),
		)
	case "hive_status_events":
		return first(
			validate.HiveStatusEventsCheck(s("from_status"), s("to_status")),
			validate.HiveStatusEventsCheck1(s("to_status"), s("loss_reason")),
		)
	case "inspections":
		return first(
			validate.InspectionsBeeFramesCheck(j("bee_frames")),
			validate.InspectionsBroodFramesCheck(j("brood_frames")),
			validate.InspectionsHoneyFramesCheck(j("honey_frames")),
			validate.InspectionsBooleans(j("swarm_signs"), j("disease_suspected")),
			validate.InspectionsDataCheck(j("data")),
		)
	case "media":
		return first(
			validate.MediaCheck(r.Id, s("org_id"), s("hive_id"), s("kind"), s("storage_path")),
			validate.MediaDurationMsCheck(j("duration_ms")),
			validate.MediaCheck1(s("kind"), j("duration_ms")),
			validate.MediaSingleOwnerCheck(s("inspection_id"), s("treatment_id")),
		)
	case "mite_counts":
		return first(
			validate.MiteCountsSampleBeesCheck(j("sample_bees")),
			validate.MiteCountsDaysCheck(j("days")),
			validate.MiteCountsCheck(s("method"), j("days")),
			validate.MiteCountsCheck1(s("method"), j("sample_bees")),
		)
	case "drugs":
		return validate.DrugsWithdrawalDaysCheck(j("withdrawal_days"))
	case "treatments":
		return first(
			validate.TreatmentsCheck(s("started_at"), s("planned_removal_at")),
			validate.TreatmentsCheck1(s("ref_drug_id"), s("drug_id")),
			validate.TreatmentsDoseCheck(f("dose")),
		)
	case "feedings":
		return validate.FeedingsAmountCheck(f("amount"))
	case "tasks":
		return first(
			validate.TasksTitleCheck(s("title")),
			validate.TasksCheck(s("hive_id"), s("apiary_id")),
			validate.TasksCheck1(s("source"), s("source_id")),
			validate.TasksCheck2(s("source"), s("title")),
			validate.TasksDoseCheck(j("dose")),
			validate.TasksOneDrugCheck(s("ref_drug_id"), s("drug_id")),
			validate.TasksDrugDoseCheck(j("dose"), s("ref_drug_id"), s("drug_id")),
			validate.TasksDrugManualApiaryCheck(j("dose"), s("source"), s("apiary_id")),
			validate.TasksSourceStepCheck(j("source_step")),
			validate.TasksQueenRearingStepCheck(s("source"), j("source_step")),
		)
	case "harvests":
		return validate.HarvestsNetKgCheck(f("net_kg"))
	case "harvest_hives":
		return validate.HarvestHivesCheck(s("withdrawal_treatment_id"), s("withdrawal_override_reason"))
	case "documents":
		return first(
			validate.DocumentsCheck(s("type"), s("custom_type_name")),
			validate.DocumentsCheck1(r.Id, s("org_id"), s("file_kind"), s("storage_path")),
			validate.DocumentsCustomTypeNameCheck(s("custom_type_name")),
			validate.DocumentsNameCheck(s("name")),
		)
	case "migrations":
		return validate.MigrationsNameCheck(s("name"))
	case "migration_stops":
		return first(
			validate.MigrationStopsNameCheck(s("name")),
			validate.MigrationStopsPlaceCheck(s("place")),
			validate.MigrationStopsCheck(s("planned_start_on"), s("planned_end_on")),
			validate.MigrationStopsHiveCountCheck(j("hive_count")),
		)
	case "transports":
		return first(
			validate.TransportsVehiclesCheck(j("vehicles")),
			validate.TransportsCheck(s("source_apiary_id"), s("destination_apiary_id")),
		)
	case "transport_items":
		return validate.TransportItemsVehicleCheck(s("vehicle"))
	case "inventory_items":
		return first(
			validate.InventoryItemsNameCheck(s("name")),
			validate.InventoryItemsPlaceCheck(s("place")),
			validate.InventoryItemsThresholdCheck(j("threshold")),
		)
	case "inventory_moves":
		return first(
			validate.InventoryMovesQuantityCheck(f("quantity")),
			validate.InventoryMovesQuantityCheck1(f("quantity")),
			validate.InventoryMovesCheck(s("kind"), f("quantity")),
			validate.InventoryMovesCheck1(s("kind"), f("quantity")),
			validate.InventoryMovesCheck2(s("linked_table"), s("linked_id")),
		)
	case "queen_rearing_batches":
		return first(
			validate.QueenRearingBatchesAcceptedCountCheck(j("accepted_count")),
			validate.QueenRearingBatchesCheck(j("accepted_count"), f("grafted_count")),
		)
	case "mating_nucs":
		return first(
			validate.MatingNucsNumberCheck(s("number")),
			validate.MatingNucsCheck(s("status"), s("rearing_batch_id")),
			validate.MatingNucsCheck1(s("status"), s("queen_id")),
		)
	case "lots":
		return first(
			validate.LotsOriginCheck(s("origin")),
			validate.LotsMoistureCheck(j("moisture")),
		)
	case "lab_results":
		return first(
			validate.LabResultsHmfCheck(j("hmf")),
			validate.LabResultsDiastaseCheck(j("diastase")),
			validate.LabResultsProlineCheck(j("proline")),
			validate.LabResultsMoistureCheck(j("moisture")),
			validate.LabResultsCheck(j("hmf"), j("diastase"), j("proline"), j("moisture"), s("residue")),
		)
	case "lot_sales":
		return validate.LotSalesKgCheck(f("kg"))
	case "transactions":
		return first(
			validate.TransactionsAmountCheck(f("amount")),
			validate.TransactionsDescriptionCheck(s("description")),
			validate.TransactionsCheck(s("kind"), s("category")),
			validate.TransactionsCheck1(s("kind"), s("lot_id"), s("lot_sale_id")),
			validate.TransactionsCheck2(r.Id, s("org_id"), s("receipt_path")),
			validate.TransactionsCheck3(s("kind"), s("customer_id")),
		)
	case "customers":
		return first(
			validate.CustomersNameCheck(s("name")),
			validate.CustomersPhoneCheck(s("phone")),
			validate.CustomersAddressCheck(s("address")),
			validate.CustomersNotesCheck(s("notes")),
		)
	case "customer_payments":
		return validate.CustomerPaymentsAmountCheck(f("amount"))
	}
	// hive_location_history, lot_harvests, lot_treatments: no CHECK beyond
	// the field options.
	return nil
}

// first returns the first non-nil error. All checks are evaluated; they are
// pure and cheap.
func first(errs ...error) error {
	for _, err := range errs {
		if err != nil {
			return err
		}
	}
	return nil
}

// jsonOf is a JSON field's value as raw JSON; nil for an unset one.
func jsonOf(r *core.Record, name string) types.JSONRaw {
	switch v := r.GetRaw(name).(type) {
	case nil:
		return nil
	case types.JSONRaw:
		return v
	default:
		b, err := json.Marshal(v)
		if err != nil {
			return types.JSONRaw(fmt.Sprint(v))
		}
		return b
	}
}
