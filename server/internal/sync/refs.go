package sync

import (
	"database/sql"
	"errors"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// RefScope tells where a referenced row must be.
type RefScope string

const (
	// RefSameOrg is Supabase's composite foreign key `(x_id, org_id)
	// references t (id, org_id)`: the target is a row of the same
	// organization.
	RefSameOrg RefScope = "same_org"
	// RefGlobal is a plain `x_id references t (id)`: reference tables
	// (ref_drugs) and users (auth.users).
	RefGlobal RefScope = "global"
)

// Ref is one foreign key of a pushable table: Column of Table points at an
// id of Target.
type Ref struct {
	Table  string
	Column string
	Target string
	Scope  RefScope
}

// Refs lists the foreign keys push checks, the counterpart of the
// `references` clauses in supabase/migrations (refs_test.go parses them and
// compares). org_id (organizations) and created_by (always the caller) are
// left out. A missing target is `missing_reference` (23503); a target that is
// soft-deleted counts, as in Supabase, where rows are never removed.
var Refs = []Ref{
	{"queens", "mother_queen_id", "queens", RefSameOrg},

	{"hives", "apiary_id", "apiaries", RefSameOrg},
	{"hives", "queen_id", "queens", RefSameOrg},

	{"hive_location_history", "hive_id", "hives", RefSameOrg},
	{"hive_location_history", "apiary_id", "apiaries", RefSameOrg},

	{"hive_status_events", "hive_id", "hives", RefSameOrg},
	{"hive_status_events", "apiary_id", "apiaries", RefSameOrg},

	{"inspections", "hive_id", "hives", RefSameOrg},
	{"inspections", "apiary_id", "apiaries", RefSameOrg},

	{"media", "hive_id", "hives", RefSameOrg},
	{"media", "inspection_id", "inspections", RefSameOrg},
	{"media", "treatment_id", "treatments", RefSameOrg},

	{"mite_counts", "hive_id", "hives", RefSameOrg},
	{"mite_counts", "apiary_id", "apiaries", RefSameOrg},

	{"treatments", "hive_id", "hives", RefSameOrg},
	{"treatments", "apiary_id", "apiaries", RefSameOrg},
	{"treatments", "ref_drug_id", "ref_drugs", RefGlobal},
	{"treatments", "drug_id", "drugs", RefSameOrg},

	{"feedings", "hive_id", "hives", RefSameOrg},
	{"feedings", "apiary_id", "apiaries", RefSameOrg},

	{"tasks", "apiary_id", "apiaries", RefSameOrg},
	{"tasks", "hive_id", "hives", RefSameOrg},
	{"tasks", "assigned_to", "users", RefGlobal},
	{"tasks", "ref_drug_id", "ref_drugs", RefGlobal},
	{"tasks", "drug_id", "drugs", RefSameOrg},

	{"harvests", "apiary_id", "apiaries", RefSameOrg},

	{"harvest_hives", "harvest_id", "harvests", RefSameOrg},
	{"harvest_hives", "hive_id", "hives", RefSameOrg},
	{"harvest_hives", "withdrawal_treatment_id", "treatments", RefSameOrg},

	{"migration_stops", "migration_id", "migrations", RefSameOrg},
	{"migration_stops", "apiary_id", "apiaries", RefSameOrg},

	{"transports", "migration_stop_id", "migration_stops", RefSameOrg},
	{"transports", "source_apiary_id", "apiaries", RefSameOrg},
	{"transports", "destination_apiary_id", "apiaries", RefSameOrg},

	{"transport_items", "transport_id", "transports", RefSameOrg},
	{"transport_items", "hive_id", "hives", RefSameOrg},

	{"inventory_moves", "item_id", "inventory_items", RefSameOrg},

	{"queen_rearing_batches", "mother_queen_id", "queens", RefSameOrg},

	{"mating_nucs", "apiary_id", "apiaries", RefSameOrg},
	{"mating_nucs", "rearing_batch_id", "queen_rearing_batches", RefSameOrg},
	{"mating_nucs", "queen_id", "queens", RefSameOrg},

	{"lot_harvests", "lot_id", "lots", RefSameOrg},
	{"lot_harvests", "harvest_id", "harvests", RefSameOrg},

	{"lot_treatments", "lot_id", "lots", RefSameOrg},
	{"lot_treatments", "harvest_id", "harvests", RefSameOrg},
	{"lot_treatments", "hive_id", "hives", RefSameOrg},
	{"lot_treatments", "treatment_id", "treatments", RefSameOrg},

	{"lab_results", "lot_id", "lots", RefSameOrg},
	{"lab_results", "document_id", "documents", RefSameOrg},

	{"lot_sales", "lot_id", "lots", RefSameOrg},

	{"transactions", "apiary_id", "apiaries", RefSameOrg},
	{"transactions", "lot_id", "lots", RefSameOrg},
	{"transactions", "transport_id", "transports", RefSameOrg},
	{"transactions", "lot_sale_id", "lot_sales", RefSameOrg},
	{"transactions", "customer_id", "customers", RefSameOrg},

	{"customer_payments", "transaction_id", "transactions", RefSameOrg},
}

// refsOf returns the foreign keys of table.
func refsOf(table string) []Ref {
	var out []Ref
	for _, r := range Refs {
		if r.Table == table {
			out = append(out, r)
		}
	}
	return out
}

// checkRefs rejects record with missing_reference when a set foreign key
// points at no row (for [RefSameOrg]: no row of the record's organization).
// An empty column is null and is not checked (MATCH SIMPLE). With changed
// non-nil only the columns it reports are checked: Postgres re-checks a
// foreign key on update only when its columns change.
func checkRefs(txApp core.App, table string, record *core.Record, changed func(column string) bool) error {
	orgID := record.GetString("org_id")
	for _, ref := range refsOf(table) {
		value := record.GetString(ref.Column)
		if value == "" || (changed != nil && !changed(ref.Column)) {
			continue
		}
		where := dbx.HashExp{"id": value}
		if ref.Scope == RefSameOrg {
			where["org_id"] = orgID
		}
		var found struct {
			ID string `db:"id"`
		}
		err := txApp.DB().Select("id").From(ref.Target).Where(where).Limit(1).One(&found)
		if errors.Is(err, sql.ErrNoRows) {
			if ref.Scope == RefSameOrg {
				return reject(ReasonMissingReference, "%s.%s: no %s row %s in this organization.", table, ref.Column, ref.Target, value)
			}
			return reject(ReasonMissingReference, "%s.%s: no %s row %s.", table, ref.Column, ref.Target, value)
		}
		if err != nil {
			return err
		}
	}
	return nil
}
