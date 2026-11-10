package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// inventory_items, inventory_moves, queen_rearing_batches, mating_nucs, lots,
// lot_harvests, lot_treatments, lab_results and lot_sales in their final
// Supabase shape. Each field names the Supabase migration that defined it
// (supabase/migrations/…): 20261101180000_inventory,
// 20261101230000_queen_rearing, 20261102120000_lots and
// 20261102180000_lot_publish (lots.published, public_*). Later migrations
// only read these tables (transactions' FKs, account deletion counts).
// Compared with the live project on 2026-11-10 (columns, CHECK names, enum
// labels, indexes).
//
// As in 1794300003: no `unique (id, org_id)` and no composite foreign keys
// (same-organization links are checked on push, P5.3), and the
// `(org_id, server_seq)` index covers `<table>_org_id_idx`. Column defaults
// (mating_nucs.status 'empty', lots.status 'open', lots.published false,
// lots.public_* true) have no counterpart: push writes the client's full row.
// guard_lot_publication (owner-only publication columns, kept when absent)
// is a push rule (P5.3).
//
// Checks a field option cannot express are in internal/validate:
// InventoryItemsNameCheck, InventoryItemsPlaceCheck,
// InventoryItemsThresholdCheck, InventoryMovesQuantityCheck,
// InventoryMovesQuantityCheck1, InventoryMovesCheck, InventoryMovesCheck1,
// InventoryMovesCheck2, QueenRearingBatchesAcceptedCountCheck,
// QueenRearingBatchesCheck, MatingNucsNumberCheck, MatingNucsCheck,
// MatingNucsCheck1, LotsOriginCheck, LotsMoistureCheck, LabResultsHmfCheck,
// LabResultsDiastaseCheck, LabResultsProlineCheck, LabResultsMoistureCheck,
// LabResultsCheck, LotSalesKgCheck.
func init() {
	m.Register(upInventoryQueenRearingLots, downInventoryQueenRearingLots)
}

// Postgres enums, labels verbatim.
var (
	// public.inventory_category (20261101180000).
	inventoryCategories = []string{"consumable", "equipment", "comb"}
	// public.inventory_unit (20261101180000).
	inventoryUnits = []string{"kg", "liter", "piece", "roll", "pack"}
	// public.inventory_move_kind (20261101180000).
	inventoryMoveKinds = []string{"in", "out", "adjustment"}
	// public.mating_nuc_status (20261101230000).
	matingNucStatuses = []string{"empty", "cell", "virgin", "laying", "failed", "given"}
	// public.lot_status (20261102120000).
	lotStatuses = []string{"open", "closed"}
	// public.residue_result (20261102120000).
	residueResults = []string{"none", "detected"}
)

// inventoryLotCollections lists this migration's collections, in creation
// order; down removes them in reverse.
var inventoryLotCollections = []string{
	"inventory_items", "inventory_moves", "queen_rearing_batches", "mating_nucs",
	"lots", "lot_harvests", "lot_treatments", "lab_results", "lot_sales",
}

func upInventoryQueenRearingLots(app core.App) error {
	// All of inventory_items comes from 20261101180000.
	inventoryItems := syncedCollection("inventory_items",
		// name text not null check (char_length(btrim(name)) between 1 and
		// 80) (inventory_items_name_check → validate).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 80},
		// category inventory_category not null.
		selectField("category", true, inventoryCategories...),
		// unit inventory_unit not null.
		selectField("unit", true, inventoryUnits...),
		// place text check (char_length(btrim(place)) between 1 and 60),
		// nullable (inventory_items_place_check → validate).
		&core.TextField{Name: "place", Max: 60},
		// threshold numeric(12, 3) check (> 0 and < 1000000), nullable
		// (inventory_items_threshold_check → validate).
		nullableNumberField("threshold"),
	)
	if err := app.Save(inventoryItems); err != nil {
		return err
	}

	// All of inventory_moves comes from 20261101180000.
	inventoryMoves := syncedCollection("inventory_moves",
		// item_id uuid not null; (item_id, org_id) FK to inventory_items.
		uuidField("item_id", true),
		// kind inventory_move_kind not null; the sign follows the kind
		// (inventory_moves_check, inventory_moves_check1 → validate).
		selectField("kind", true, inventoryMoveKinds...),
		// quantity numeric(12, 3) not null check (abs(quantity) < 1000000)
		// (inventory_moves_quantity_check) and check (quantity <> 0)
		// (inventory_moves_quantity_check1). Required rejects 0; the strict
		// bound after 3-decimal rounding is validate.
		&core.NumberField{
			Name:     "quantity",
			Required: true,
			Min:      types.Pointer(-1000000.0),
			Max:      types.Pointer(1000000.0),
		},
		// moved_at timestamptz not null.
		timeField("moved_at", true),
		// linked_table text check (linked_table ~ '^[a-z_]{1,63}$'), nullable
		// (inventory_moves_linked_table_check). Set exactly with linked_id:
		// inventory_moves_check2 → validate.
		&core.TextField{Name: "linked_table", Max: 63, Pattern: `^[a-z_]{1,63}$`},
		// linked_id uuid, nullable; no FK (the link may go to any table).
		uuidField("linked_id", false),
	)
	// inventory_moves_item_id_idx.
	inventoryMoves.AddIndex("idx_inventory_moves_item_id", false, "`item_id`", "")
	if err := app.Save(inventoryMoves); err != nil {
		return err
	}

	// All of queen_rearing_batches comes from 20261101230000.
	batches := syncedCollection("queen_rearing_batches",
		// number smallint not null check (between 1 and 10000)
		// (queen_rearing_batches_number_check). Not unique: two offline
		// phones may pick the same number.
		intField("number", true, 1, 10000),
		// mother_queen_id uuid, nullable; (mother_queen_id, org_id) FK to
		// queens.
		uuidField("mother_queen_id", false),
		// grafted_on date not null.
		dateField("grafted_on", true),
		// grafted_count smallint not null check (between 1 and 1000)
		// (queen_rearing_batches_grafted_count_check).
		intField("grafted_count", true, 1, 1000),
		// accepted_count smallint check (>= 0), nullable (not counted yet)
		// (queen_rearing_batches_accepted_count_check → validate); at most
		// grafted_count (queen_rearing_batches_check → validate).
		nullableNumberField("accepted_count"),
	)
	// queen_rearing_batches_mother_queen_id_idx.
	batches.AddIndex("idx_queen_rearing_batches_mother_queen_id", false, "`mother_queen_id`", "")
	if err := app.Save(batches); err != nil {
		return err
	}

	// All of mating_nucs comes from 20261101230000.
	matingNucs := syncedCollection("mating_nucs",
		// number text not null check (char_length(btrim(number)) between 1
		// and 20) (mating_nucs_number_check → validate).
		&core.TextField{Name: "number", Required: true, Min: 1, Max: 20},
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// rearing_batch_id uuid, nullable; (rearing_batch_id, org_id) FK to
		// queen_rearing_batches. Set unless the nuc is empty: mating_nucs_check
		// → validate.
		uuidField("rearing_batch_id", false),
		// status mating_nuc_status not null default 'empty'.
		selectField("status", true, matingNucStatuses...),
		// queen_id uuid, nullable; (queen_id, org_id) FK to queens. Set
		// exactly for status given: mating_nucs_check1 → validate.
		uuidField("queen_id", false),
	)
	// mating_nucs_apiary_id_idx, mating_nucs_rearing_batch_id_idx,
	// mating_nucs_queen_id_idx.
	matingNucs.AddIndex("idx_mating_nucs_apiary_id", false, "`apiary_id`", "")
	matingNucs.AddIndex("idx_mating_nucs_rearing_batch_id", false, "`rearing_batch_id`", "")
	matingNucs.AddIndex("idx_mating_nucs_queen_id", false, "`queen_id`", "")
	if err := app.Save(matingNucs); err != nil {
		return err
	}

	lots := syncedCollection("lots",
		// year smallint not null check (between 2000 and 2100)
		// (lots_year_check).
		intField("year", true, 2000, 2100),
		// seq smallint not null check (between 1 and 9999) (lots_seq_check).
		// Not unique with year: two offline phones may pick the same number.
		intField("seq", true, 1, 9999),
		// honey_kind honey_kind not null (enum of 20261026235000).
		selectField("honey_kind", true, honeyKinds...),
		// origin text check (char_length(btrim(origin)) between 1 and 80),
		// nullable (lots_origin_check → validate).
		&core.TextField{Name: "origin", Max: 80},
		// moisture numeric(3, 1) check (between 10 and 30), nullable
		// (lots_moisture_check → validate).
		nullableNumberField("moisture"),
		// status lot_status not null default 'open'.
		selectField("status", true, lotStatuses...),
		// 20261102180000: published boolean not null default false;
		// public_producer, public_origin, public_lab, public_report boolean
		// not null default true. A bool field is false when absent; the
		// owner-only rule and the defaults are guard_lot_publication (P5.3).
		&core.BoolField{Name: "published"},
		&core.BoolField{Name: "public_producer"},
		&core.BoolField{Name: "public_origin"},
		&core.BoolField{Name: "public_lab"},
		&core.BoolField{Name: "public_report"},
	)
	if err := app.Save(lots); err != nil {
		return err
	}

	// All of lot_harvests comes from 20261102120000.
	lotHarvests := syncedCollection("lot_harvests",
		// lot_id uuid not null; (lot_id, org_id) FK to lots.
		uuidField("lot_id", true),
		// harvest_id uuid not null; (harvest_id, org_id) FK to harvests.
		uuidField("harvest_id", true),
	)
	// lot_harvests_lot_id_idx.
	lotHarvests.AddIndex("idx_lot_harvests_lot_id", false, "`lot_id`", "")
	// lot_harvests_harvest_id_key: a harvest is in at most one lot among
	// live rows (`where deleted_at is null`).
	lotHarvests.AddIndex("idx_lot_harvests_harvest_id", true, "`harvest_id`", "`deleted_at` = ''")
	if err := app.Save(lotHarvests); err != nil {
		return err
	}

	// All of lot_treatments comes from 20261102120000.
	lotTreatments := syncedCollection("lot_treatments",
		// lot_id, harvest_id, hive_id, treatment_id uuid not null; (x, org_id)
		// FKs to lots, harvests, hives and treatments.
		uuidField("lot_id", true),
		uuidField("harvest_id", true),
		uuidField("hive_id", true),
		uuidField("treatment_id", true),
		// treated_at timestamptz not null.
		timeField("treated_at", true),
		// withdrawal_ends_on date not null.
		dateField("withdrawal_ends_on", true),
		// withdrawal_violation boolean not null. A bool field is false when
		// absent.
		&core.BoolField{Name: "withdrawal_violation"},
	)
	// lot_treatments_lot_id_idx, lot_treatments_harvest_id_idx,
	// lot_treatments_hive_id_idx, lot_treatments_treatment_id_idx.
	lotTreatments.AddIndex("idx_lot_treatments_lot_id", false, "`lot_id`", "")
	lotTreatments.AddIndex("idx_lot_treatments_harvest_id", false, "`harvest_id`", "")
	lotTreatments.AddIndex("idx_lot_treatments_hive_id", false, "`hive_id`", "")
	lotTreatments.AddIndex("idx_lot_treatments_treatment_id", false, "`treatment_id`", "")
	if err := app.Save(lotTreatments); err != nil {
		return err
	}

	// All of lab_results comes from 20261102120000. At least one of the five
	// values is set: lab_results_check → validate.
	labResults := syncedCollection("lab_results",
		// lot_id uuid not null; (lot_id, org_id) FK to lots.
		uuidField("lot_id", true),
		// tested_on date not null.
		dateField("tested_on", true),
		// hmf numeric(5, 1) check (between 0 and 1000), nullable
		// (lab_results_hmf_check → validate).
		nullableNumberField("hmf"),
		// diastase numeric(4, 1) check (between 0 and 100), nullable
		// (lab_results_diastase_check → validate).
		nullableNumberField("diastase"),
		// proline numeric(6, 1) check (between 0 and 10000), nullable
		// (lab_results_proline_check → validate).
		nullableNumberField("proline"),
		// moisture numeric(3, 1) check (between 10 and 30), nullable
		// (lab_results_moisture_check → validate).
		nullableNumberField("moisture"),
		// residue residue_result, nullable.
		selectField("residue", false, residueResults...),
		// document_id uuid, nullable; (document_id, org_id) FK to documents
		// (the report, type analysis_report).
		uuidField("document_id", false),
	)
	// lab_results_lot_id_idx, lab_results_document_id_idx.
	labResults.AddIndex("idx_lab_results_lot_id", false, "`lot_id`", "")
	labResults.AddIndex("idx_lab_results_document_id", false, "`document_id`", "")
	if err := app.Save(labResults); err != nil {
		return err
	}

	// All of lot_sales comes from 20261102120000.
	lotSales := syncedCollection("lot_sales",
		// lot_id uuid not null; (lot_id, org_id) FK to lots.
		uuidField("lot_id", true),
		// sold_on date not null.
		dateField("sold_on", true),
		// kg numeric(9, 3) not null check (> 0 and <= 100000)
		// (lot_sales_kg_check; Required rejects 0, the 3-decimal rounding is
		// validate.LotSalesKgCheck).
		&core.NumberField{
			Name:     "kg",
			Required: true,
			Min:      types.Pointer(0.0),
			Max:      types.Pointer(100000.0),
		},
	)
	// lot_sales_lot_id_idx.
	lotSales.AddIndex("idx_lot_sales_lot_id", false, "`lot_id`", "")
	return app.Save(lotSales)
}

func downInventoryQueenRearingLots(app core.App) error {
	for i := len(inventoryLotCollections) - 1; i >= 0; i-- {
		c, err := app.FindCollectionByNameOrId(inventoryLotCollections[i])
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
