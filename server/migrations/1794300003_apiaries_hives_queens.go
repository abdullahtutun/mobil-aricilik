package migrations

import (
	"math"

	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// apiaries, queens, hives, hive_location_history and hive_status_events in
// their final Supabase shape. Each field names the Supabase migration that
// defined it (supabase/migrations/…); unless noted, that is
// 20261021201714_apiaries_hives_queens.
//
// Supabase's `unique (id, org_id)` and the composite foreign keys have no
// counterpart: id is the primary key, and same-organization links are checked
// on push (P5.3). The `<table>_org_id_idx` indexes are covered by the
// `(org_id, server_seq)` index every org collection has.
//
// Checks a field option cannot express are in internal/validate:
// ApiariesLocationCheck, ApiariesAltitudeMCheck,
// ApiariesVehicleDistanceMCheck, QueensYearCheck, QueensCheck,
// HivesFrameCountCheck, HivesQuarantineDiseaseCheck,
// HivesQuarantineConsistent, HiveStatusEventsCheck, HiveStatusEventsCheck1.
func init() {
	m.Register(upApiariesHivesQueens, downApiariesHivesQueens)
}

// Postgres enums, labels verbatim.
var (
	// public.apiary_land_tenure (20261021201714).
	apiaryLandTenures = []string{"owned", "rented", "permitted"}
	// public.hive_type (20261021201714).
	hiveTypes = []string{"langstroth", "dadant", "local", "other"}
	// public.hive_status (20261021201714).
	hiveStatuses = []string{"active", "dead", "merged", "sold", "lost"}
	// public.hive_source (20261021201714).
	hiveSources = []string{"swarm", "split", "purchase", "package"}
	// public.queen_mark_color (20261021201714).
	queenMarkColors = []string{"white", "yellow", "red", "green", "blue"}
	// public.queen_source (20261021201714).
	queenSources = []string{"own_rearing", "purchased", "certified_breeder"}
	// public.queen_mating_status (20261021201714).
	queenMatingStatuses = []string{"virgin", "mated"}
	// public.hive_loss_reason (20261108120000).
	hiveLossReasons = []string{
		"wintering", "queenless", "varroa", "disease", "starvation",
		"robbing", "predator", "poisoning", "other",
	}
)

// apiaryHiveCollections lists this migration's collections, in creation
// order; down removes them in reverse.
var apiaryHiveCollections = []string{
	"apiaries", "queens", "hives", "hive_location_history", "hive_status_events",
}

func upApiariesHivesQueens(app core.App) error {
	apiaries := syncedCollection("apiaries",
		// name text not null.
		&core.TextField{Name: "name", Required: true},
		// location geography(point, 4326), nullable → latitude + longitude.
		// Null-able numbers are JSON (nullableNumberField); "both set or both
		// null" and the ranges (−90…90, −180…180) are ApiariesLocationCheck,
		// the check sync_push did before building the point (20261023164500).
		nullableNumberField("latitude"),
		nullableNumberField("longitude"),
		// altitude_m integer, nullable (ApiariesAltitudeMCheck).
		nullableNumberField("altitude_m"),
		// land_tenure apiary_land_tenure, nullable.
		selectField("land_tenure", false, apiaryLandTenures...),
		// water_source text, nullable.
		&core.TextField{Name: "water_source"},
		// vehicle_distance_m integer check (>= 0), nullable
		// (apiaries_vehicle_distance_m_check → validate).
		nullableNumberField("vehicle_distance_m"),
		// road_notes text, nullable.
		&core.TextField{Name: "road_notes"},
		// notes text, nullable.
		&core.TextField{Name: "notes"},
		// landowner_name, landowner_phone: dropped in 20261116120000, not
		// mirrored.
	)
	if err := app.Save(apiaries); err != nil {
		return err
	}

	queens := syncedCollection("queens",
		// year smallint check (between 2000 and 2100), nullable
		// (queens_year_check → validate).
		nullableNumberField("year"),
		// mark_color queen_mark_color, nullable (unmarked).
		selectField("mark_color", false, queenMarkColors...),
		// breed text, nullable.
		&core.TextField{Name: "breed"},
		// breed_line text, nullable.
		&core.TextField{Name: "breed_line"},
		// source queen_source, nullable.
		selectField("source", false, queenSources...),
		// mating_status queen_mating_status, nullable (unknown).
		selectField("mating_status", false, queenMatingStatuses...),
		// wing_clipped boolean not null default false. A bool field is
		// false when absent.
		&core.BoolField{Name: "wing_clipped"},
		// mother_queen_id uuid, nullable; (mother_queen_id, org_id) FK to
		// queens. mother_queen_id <> id is queens_check → validate.
		uuidField("mother_queen_id", false),
	)
	// queens_mother_queen_id_idx.
	queens.AddIndex("idx_queens_mother_queen_id", false, "`mother_queen_id`", "")
	if err := app.Save(queens); err != nil {
		return err
	}

	hives := syncedCollection("hives",
		// number text not null ("101", "A-12"; may repeat).
		&core.TextField{Name: "number", Required: true},
		// tag_code text, nullable; unique per organization among live hives
		// (index below).
		&core.TextField{Name: "tag_code"},
		// type hive_type not null.
		selectField("type", true, hiveTypes...),
		// status hive_status not null default 'active'. No column default in
		// PocketBase; the client row always has it.
		selectField("status", true, hiveStatuses...),
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// queen_id uuid, nullable; (queen_id, org_id) FK to queens.
		uuidField("queen_id", false),
		// box_count smallint not null default 1 check (> 0)
		// (hives_box_count_check). The client row always has it.
		&core.NumberField{
			Name:     "box_count",
			Required: true,
			OnlyInt:  true,
			Min:      types.Pointer(1.0),
			Max:      types.Pointer(float64(math.MaxInt16)),
		},
		// frame_count smallint check (>= 0), nullable
		// (hives_frame_count_check → validate).
		nullableNumberField("frame_count"),
		// source hive_source, nullable.
		selectField("source", false, hiveSources...),
		// marking text, nullable.
		&core.TextField{Name: "marking"},
		// 20261107120000: quarantined boolean not null default false.
		// The keep_hive_quarantine trigger (old apps sending no value) is not
		// mirrored: there are no old apps (K-11).
		&core.BoolField{Name: "quarantined"},
		// 20261107120000: quarantined_at timestamptz, nullable.
		timeField("quarantined_at", false),
		// 20261107120000: quarantine_disease text, 1–100 chars after trim
		// (hives_quarantine_disease_check → validate). Together with the two
		// above: hives_quarantine_consistent → validate.
		&core.TextField{Name: "quarantine_disease"},
	)
	// hives_org_id_tag_code_key: scanning a tag opens one hive; a deleted
	// hive's tag can be reused. Postgres nulls never collide, PocketBase's
	// empty text would, so empty tags are left out.
	hives.AddIndex("idx_hives_org_id_tag_code", true, "`org_id`, `tag_code`", "`tag_code` != '' AND `deleted_at` = ''")
	// hives_apiary_id_idx, hives_queen_id_idx.
	hives.AddIndex("idx_hives_apiary_id", false, "`apiary_id`", "")
	hives.AddIndex("idx_hives_queen_id", false, "`queen_id`", "")
	if err := app.Save(hives); err != nil {
		return err
	}

	history := syncedCollection("hive_location_history",
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// moved_at timestamptz not null.
		timeField("moved_at", true),
	)
	// hive_location_history_hive_id_idx, hive_location_history_apiary_id_idx.
	history.AddIndex("idx_hive_location_history_hive_id", false, "`hive_id`", "")
	history.AddIndex("idx_hive_location_history_apiary_id", false, "`apiary_id`", "")
	if err := app.Save(history); err != nil {
		return err
	}

	// All of hive_status_events comes from 20261108120000.
	events := syncedCollection("hive_status_events",
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// from_status, to_status hive_status not null; from <> to is
		// hive_status_events_check → validate.
		selectField("from_status", true, hiveStatuses...),
		selectField("to_status", true, hiveStatuses...),
		// changed_at timestamptz not null.
		timeField("changed_at", true),
		// loss_reason hive_loss_reason, nullable; only with to_status
		// dead/lost: hive_status_events_check1 → validate.
		selectField("loss_reason", false, hiveLossReasons...),
	)
	// hive_status_events_hive_id_idx.
	events.AddIndex("idx_hive_status_events_hive_id", false, "`hive_id`", "")
	return app.Save(events)
}

func downApiariesHivesQueens(app core.App) error {
	for i := len(apiaryHiveCollections) - 1; i >= 0; i-- {
		c, err := app.FindCollectionByNameOrId(apiaryHiveCollections[i])
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
