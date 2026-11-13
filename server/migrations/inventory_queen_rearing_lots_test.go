package migrations

import (
	"slices"
	"strings"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

const (
	testInventoryItem = "0195f2a4-f1f1-7000-8000-000000000001"
	testInventoryMove = "0195f2a4-f2f2-7000-8000-000000000001"
	testRearingBatch  = "0195f2a4-f3f3-7000-8000-000000000001"
	testMatingNuc     = "0195f2a4-f4f4-7000-8000-000000000001"
	testLot           = "0195f2a4-f5f5-7000-8000-000000000001"
	testLotHarvest    = "0195f2a4-f6f6-7000-8000-000000000001"
	testLotTreatment  = "0195f2a4-f7f7-7000-8000-000000000001"
	testLabResult     = "0195f2a4-f8f8-7000-8000-000000000001"
	testLotSale       = "0195f2a4-f9f9-7000-8000-000000000001"
	testFeeding       = "0195f2a4-fafa-7000-8000-000000000001"
)

func TestInventoryLotCollectionShapes(t *testing.T) {
	app := newApp(t)

	cases := []struct {
		name    string
		fields  fieldSpec
		indexes []string
	}{
		{
			name: "inventory_items",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":    "text!",
				"name":      "text!",
				"category":  "select!",
				"unit":      "select!",
				"place":     "text",
				"threshold": "json",
			}),
			indexes: []string{
				"idx_inventory_items_org_id_server_seq||org_id,server_seq|",
				"idx_inventory_items_server_seq|unique|server_seq|",
			},
		},
		{
			name: "inventory_moves",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":       "text!",
				"item_id":      "text!",
				"kind":         "select!",
				"quantity":     "number!",
				"moved_at":     "text!",
				"linked_table": "text",
				"linked_id":    "text",
			}),
			indexes: []string{
				"idx_inventory_moves_item_id||item_id|",
				"idx_inventory_moves_org_id_server_seq||org_id,server_seq|",
				"idx_inventory_moves_server_seq|unique|server_seq|",
			},
		},
		{
			name: "queen_rearing_batches",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":          "text!",
				"number":          "number!",
				"mother_queen_id": "text",
				"grafted_on":      "text!",
				"grafted_count":   "number!",
				"accepted_count":  "json",
			}),
			indexes: []string{
				"idx_queen_rearing_batches_mother_queen_id||mother_queen_id|",
				"idx_queen_rearing_batches_org_id_server_seq||org_id,server_seq|",
				"idx_queen_rearing_batches_server_seq|unique|server_seq|",
			},
		},
		{
			name: "mating_nucs",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":           "text!",
				"number":           "text!",
				"apiary_id":        "text!",
				"rearing_batch_id": "text",
				"status":           "select!",
				"queen_id":         "text",
			}),
			indexes: []string{
				"idx_mating_nucs_apiary_id||apiary_id|",
				"idx_mating_nucs_org_id_server_seq||org_id,server_seq|",
				"idx_mating_nucs_queen_id||queen_id|",
				"idx_mating_nucs_rearing_batch_id||rearing_batch_id|",
				"idx_mating_nucs_server_seq|unique|server_seq|",
			},
		},
		{
			name: "lots",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":          "text!",
				"year":            "number!",
				"seq":             "number!",
				"honey_kind":      "select!",
				"origin":          "text",
				"moisture":        "json",
				"status":          "select!",
				"published":       "bool",
				"public_producer": "bool",
				"public_origin":   "bool",
				"public_lab":      "bool",
				"public_report":   "bool",
			}),
			indexes: []string{
				"idx_lots_org_id_server_seq||org_id,server_seq|",
				"idx_lots_server_seq|unique|server_seq|",
			},
		},
		{
			name: "lot_harvests",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":     "text!",
				"lot_id":     "text!",
				"harvest_id": "text!",
			}),
			indexes: []string{
				"idx_lot_harvests_harvest_id|unique|harvest_id|`deleted_at` = ''",
				"idx_lot_harvests_lot_id||lot_id|",
				"idx_lot_harvests_org_id_server_seq||org_id,server_seq|",
				"idx_lot_harvests_server_seq|unique|server_seq|",
			},
		},
		{
			name: "lot_treatments",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":               "text!",
				"lot_id":               "text!",
				"harvest_id":           "text!",
				"hive_id":              "text!",
				"treatment_id":         "text!",
				"treated_at":           "text!",
				"withdrawal_ends_on":   "text!",
				"withdrawal_violation": "bool",
			}),
			indexes: []string{
				"idx_lot_treatments_harvest_id||harvest_id|",
				"idx_lot_treatments_hive_id||hive_id|",
				"idx_lot_treatments_lot_id||lot_id|",
				"idx_lot_treatments_org_id_server_seq||org_id,server_seq|",
				"idx_lot_treatments_server_seq|unique|server_seq|",
				"idx_lot_treatments_treatment_id||treatment_id|",
			},
		},
		{
			name: "lab_results",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":      "text!",
				"lot_id":      "text!",
				"tested_on":   "text!",
				"hmf":         "json",
				"diastase":    "json",
				"proline":     "json",
				"moisture":    "json",
				"residue":     "select",
				"document_id": "text",
			}),
			indexes: []string{
				"idx_lab_results_document_id||document_id|",
				"idx_lab_results_lot_id||lot_id|",
				"idx_lab_results_org_id_server_seq||org_id,server_seq|",
				"idx_lab_results_server_seq|unique|server_seq|",
			},
		},
		{
			name: "lot_sales",
			fields: with(commonSyncFields, fieldSpec{
				"org_id":  "text!",
				"lot_id":  "text!",
				"sold_on": "text!",
				"kg":      "number!",
			}),
			indexes: []string{
				"idx_lot_sales_lot_id||lot_id|",
				"idx_lot_sales_org_id_server_seq||org_id,server_seq|",
				"idx_lot_sales_server_seq|unique|server_seq|",
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

func TestInventoryLotSelectValues(t *testing.T) {
	app := newApp(t)
	want := map[string]map[string][]string{
		"inventory_items": {
			"category": {"consumable", "equipment", "comb"},
			"unit":     {"kg", "liter", "piece", "roll", "pack"},
		},
		"inventory_moves": {"kind": {"in", "out", "adjustment"}},
		"mating_nucs":     {"status": {"empty", "cell", "virgin", "laying", "failed", "given"}},
		"lots": {
			"honey_kind": {"pine", "flower", "chestnut", "citrus", "other"},
			"status":     {"open", "closed"},
		},
		"lab_results": {"residue": {"none", "detected"}},
	}
	for collection, fields := range want {
		c, err := app.FindCollectionByNameOrId(collection)
		if err != nil {
			t.Fatal(err)
		}
		for name, values := range fields {
			f, ok := c.Fields.GetByName(name).(*core.SelectField)
			if !ok {
				t.Fatalf("%s.%s is not a select", collection, name)
			}
			if !slices.Equal(f.Values, values) || f.MaxSelect != 1 {
				t.Errorf("%s.%s = %v (max %d), want %v (max 1)", collection, name, f.Values, f.MaxSelect, values)
			}
		}
	}
}

func TestInventoryLotFields(t *testing.T) {
	app := newApp(t)

	item := func() *core.Record {
		r := newRow(t, app, "inventory_items", testInventoryItem, 1)
		r.Set("name", "Şeker")
		r.Set("category", "consumable")
		r.Set("unit", "kg")
		return r
	}
	move := func() *core.Record {
		r := newRow(t, app, "inventory_moves", testInventoryMove, 1)
		r.Set("item_id", testInventoryItem)
		r.Set("kind", "in")
		r.Set("quantity", 50)
		r.Set("moved_at", testTime)
		return r
	}
	batch := func() *core.Record {
		r := newRow(t, app, "queen_rearing_batches", testRearingBatch, 1)
		r.Set("number", 3)
		r.Set("grafted_on", "2026-05-01")
		r.Set("grafted_count", 30)
		return r
	}
	nuc := func() *core.Record {
		r := newRow(t, app, "mating_nucs", testMatingNuc, 1)
		r.Set("number", "K-12")
		r.Set("apiary_id", testApiary)
		r.Set("status", "empty")
		return r
	}
	lot := func() *core.Record {
		r := newRow(t, app, "lots", testLot, 1)
		r.Set("year", 2026)
		r.Set("seq", 7)
		r.Set("honey_kind", "pine")
		r.Set("status", "open")
		return r
	}
	lotHarvest := func() *core.Record {
		r := newRow(t, app, "lot_harvests", testLotHarvest, 1)
		r.Set("lot_id", testLot)
		r.Set("harvest_id", testHarvest)
		return r
	}
	lotTreatment := func() *core.Record {
		r := newRow(t, app, "lot_treatments", testLotTreatment, 1)
		r.Set("lot_id", testLot)
		r.Set("harvest_id", testHarvest)
		r.Set("hive_id", testHive)
		r.Set("treatment_id", testTreatment)
		r.Set("treated_at", testTime)
		r.Set("withdrawal_ends_on", "2026-07-01")
		return r
	}
	labResult := func() *core.Record {
		r := newRow(t, app, "lab_results", testLabResult, 1)
		r.Set("lot_id", testLot)
		r.Set("tested_on", "2026-08-15")
		r.Set("hmf", 12.3)
		return r
	}
	lotSale := func() *core.Record {
		r := newRow(t, app, "lot_sales", testLotSale, 1)
		r.Set("lot_id", testLot)
		r.Set("sold_on", "2026-09-01")
		r.Set("kg", 12.5)
		return r
	}
	for _, base := range []func() *core.Record{item, move, batch, nuc, lot, lotHarvest, lotTreatment, labResult, lotSale} {
		r := base()
		if err := app.Validate(r); err != nil {
			t.Fatalf("valid %s rejected: %v", r.Collection().Name, err)
		}
	}

	long := func(n int) string { return strings.Repeat("ş", n) }

	checkValues(t, app, item,
		map[string][]any{
			"name":      {long(80)},
			"category":  {"equipment", "comb"},
			"unit":      {"liter", "piece", "roll", "pack"},
			"place":     {"", "Depo", long(60)},
			"threshold": {nil, 0.5, 20},
		},
		map[string][]any{
			"name":     {"", long(81)},
			"category": {"", "food"},
			"unit":     {"", "gram"},
			"place":    {long(61)},
			// The type is validate.InventoryItemsThresholdCheck's; the field
			// caps the size.
			"threshold": {strings.Repeat("9", 40)},
		})
	checkValues(t, app, move,
		map[string][]any{
			"kind":         {"out", "adjustment"},
			"quantity":     {-50, 0.001, 999999.999, -999999.999},
			"linked_table": {"", "feedings", "inventory_items"},
			"linked_id":    {"", testFeeding},
		},
		map[string][]any{
			"item_id":      {"", "item-1"},
			"kind":         {"", "move"},
			"quantity":     {0, 1000000.5, -1000000.5},
			"moved_at":     {"", "2026-11-10"},
			"linked_table": {"Feedings", "feedings;", "fee-dings", strings.Repeat("a", 64)},
			"linked_id":    {"x"},
		})
	checkValues(t, app, batch,
		map[string][]any{
			"number":          {1, 10000},
			"mother_queen_id": {"", testQueen},
			"grafted_count":   {1, 1000},
			"accepted_count":  {nil, 0, 25},
		},
		map[string][]any{
			"number":        {0, 10001, 1.5},
			"grafted_on":    {"", "2026-5-1", testTime},
			"grafted_count": {0, 1001, 2.5},
		})
	checkValues(t, app, nuc,
		map[string][]any{
			"number":           {"1", long(20)},
			"rearing_batch_id": {"", testRearingBatch},
			"status":           {"cell", "virgin", "laying", "failed", "given"},
			"queen_id":         {"", testQueen},
		},
		map[string][]any{
			"number":    {"", long(21)},
			"apiary_id": {"", "apiary-1"},
			"status":    {"", "sold"},
		})
	checkValues(t, app, lot,
		map[string][]any{
			"year":            {2000, 2100},
			"seq":             {1, 9999},
			"honey_kind":      {"flower", "chestnut", "citrus", "other"},
			"origin":          {"", "Marmaris", long(80)},
			"moisture":        {nil, 10, 17.5, 30},
			"status":          {"closed"},
			"published":       {true, false},
			"public_producer": {true, false},
			"public_report":   {false},
		},
		map[string][]any{
			"year":       {0, 1999, 2101, 2026.5},
			"seq":        {0, 10000, 1.5},
			"honey_kind": {"", "acacia"},
			"origin":     {long(81)},
			"status":     {"", "sold"},
		})
	checkValues(t, app, lotHarvest,
		map[string][]any{},
		map[string][]any{
			"lot_id":     {"", "lot-1"},
			"harvest_id": {""},
		})
	checkValues(t, app, lotTreatment,
		map[string][]any{
			"withdrawal_violation": {true, false},
		},
		map[string][]any{
			"lot_id":             {""},
			"harvest_id":         {""},
			"hive_id":            {""},
			"treatment_id":       {"", "treatment-1"},
			"treated_at":         {"", "2026-06-01"},
			"withdrawal_ends_on": {"", testTime, "01.07.2026"},
		})
	checkValues(t, app, labResult,
		map[string][]any{
			"hmf":         {nil, 0, 1000},
			"diastase":    {nil, 0, 8.5},
			"proline":     {nil, 250},
			"moisture":    {nil, 18.2},
			"residue":     {"", "none", "detected"},
			"document_id": {"", testDocument},
		},
		map[string][]any{
			"lot_id":    {""},
			"tested_on": {"", "2026-13-01"},
			"residue":   {"unknown"},
			"hmf":       {strings.Repeat("9", 40)},
		})
	checkValues(t, app, lotSale,
		map[string][]any{
			"kg": {0.001, 100000},
		},
		map[string][]any{
			"lot_id":  {""},
			"sold_on": {"", "2026-9-1"},
			"kg":      {0, -1, 100000.5},
		})
}

// Null and 0 stay apart for the nullable numbers; false stays false.
func TestInventoryLotNullables(t *testing.T) {
	app := newApp(t)

	batch := newRow(t, app, "queen_rearing_batches", testRearingBatch, 1)
	batch.Set("number", 1)
	batch.Set("grafted_on", "2026-05-01")
	batch.Set("grafted_count", 30)
	batch.Set("accepted_count", 0)
	if err := app.Save(batch); err != nil {
		t.Fatal(err)
	}

	result := newRow(t, app, "lab_results", testLabResult, 2)
	result.Set("lot_id", testLot)
	result.Set("tested_on", "2026-08-15")
	result.Set("hmf", 0)
	result.Set("diastase", nil)
	if err := app.Save(result); err != nil {
		t.Fatal(err)
	}

	gotBatch, err := app.FindRecordById("queen_rearing_batches", testRearingBatch)
	if err != nil {
		t.Fatal(err)
	}
	if raw := gotBatch.GetString("accepted_count"); raw != "0" {
		t.Errorf("accepted_count 0 stored as %q", raw)
	}
	gotResult, err := app.FindRecordById("lab_results", testLabResult)
	if err != nil {
		t.Fatal(err)
	}
	if raw := gotResult.GetString("hmf"); raw != "0" {
		t.Errorf("hmf 0 stored as %q", raw)
	}
	for _, f := range []string{"diastase", "proline", "moisture"} {
		if raw := gotResult.GetString(f); raw != "" && raw != "null" {
			t.Errorf("null %s stored as %q", f, raw)
		}
	}
}

// A harvest is in at most one lot among live rows; a deleted row frees it.
func TestLotHarvestsUniqueAmongLive(t *testing.T) {
	app := newApp(t)
	row := func(id string, seq int, lotID, harvestID string) *core.Record {
		r := newRow(t, app, "lot_harvests", id, seq)
		r.Set("lot_id", lotID)
		r.Set("harvest_id", harvestID)
		return r
	}
	const otherLot = "0195f2a4-f5f5-7000-8000-000000000002"
	const otherHarvest = "0195f2a4-d2d2-7000-8000-000000000002"

	first := row("0195f2a4-e2e2-7000-8000-000000000001", 1, testLot, testHarvest)
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}
	// The same harvest in another lot, or twice in one lot, is rejected.
	if err := app.Save(row("0195f2a4-e2e2-7000-8000-000000000002", 2, otherLot, testHarvest)); err == nil {
		t.Fatal("harvest saved in a second lot")
	}
	if err := app.Save(row("0195f2a4-e2e2-7000-8000-000000000003", 3, testLot, testHarvest)); err == nil {
		t.Fatal("harvest saved twice in one lot")
	}
	// Another harvest in the same lot is fine.
	if err := app.Save(row("0195f2a4-e2e2-7000-8000-000000000004", 4, testLot, otherHarvest)); err != nil {
		t.Fatalf("other harvest: %v", err)
	}
	// After the soft delete the harvest can go to another lot.
	first.Set("deleted_at", testTime)
	first.Set("server_seq", 5)
	if err := app.Save(first); err != nil {
		t.Fatal(err)
	}
	if err := app.Save(row("0195f2a4-e2e2-7000-8000-000000000005", 6, otherLot, testHarvest)); err != nil {
		t.Fatalf("move after delete: %v", err)
	}
}

func TestDownInventoryQueenRearingLots(t *testing.T) {
	app := newApp(t)
	if err := downInventoryQueenRearingLots(app); err != nil {
		t.Fatal(err)
	}
	for _, name := range inventoryLotCollections {
		if _, err := app.FindCollectionByNameOrId(name); err == nil {
			t.Errorf("%s still exists", name)
		}
		if app.HasTable(name) {
			t.Errorf("table %s still exists", name)
		}
	}
	for _, name := range taskHarvestDocumentCollections {
		if _, err := app.FindCollectionByNameOrId(name); err != nil {
			t.Errorf("%s removed: %v", name, err)
		}
	}
	if err := upInventoryQueenRearingLots(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
