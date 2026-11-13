package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// tasks, harvests, harvest_hives, documents, migrations, migration_stops,
// transports and transport_items in their final Supabase shape. Each field
// names the Supabase migration that defined it (supabase/migrations/…):
// 20261026180000_tasks, 20261026235000_harvests, 20261027180000_documents,
// 20261028120000_migrations, 20261031120000_transports,
// 20261101200000_planned_treatment_tasks (tasks.ref_drug_id, drug_id, dose),
// 20261101230000_queen_rearing (task_source queen_rearing, tasks.source_step)
// and 20261105120000_support_periods (task_source aks_update). No later
// migration changes these columns. Compared with the live project on
// 2026-11-10 (columns, CHECK names, enum labels, indexes).
//
// As in 1794300003: no `unique (id, org_id)` and no composite foreign keys
// (same-organization links are checked on push, P5.3), and the
// `(org_id, server_seq)` index covers `<table>_org_id_idx`. Column defaults
// (tasks.source 'manual', migration_stops.status 'planned',
// transports.status 'loading', transports.vehicles '[]') have no counterpart:
// push writes the client's full row.
//
// A `char_length(btrim(x)) between 1 and n` CHECK is a field Min/Max (like
// drugs.name in 1794300004) plus a validate function that counts after
// trimming spaces, since the field counts the untrimmed text.
//
// Checks a field option cannot express are in internal/validate:
// TasksTitleCheck, TasksCheck, TasksCheck1, TasksCheck2, TasksDoseCheck,
// TasksOneDrugCheck, TasksDrugDoseCheck, TasksDrugManualApiaryCheck,
// TasksSourceStepCheck, TasksQueenRearingStepCheck, HarvestsNetKgCheck,
// HarvestHivesCheck, DocumentsCheck, DocumentsCheck1,
// DocumentsCustomTypeNameCheck, DocumentsNameCheck, MigrationsNameCheck,
// MigrationStopsCheck, MigrationStopsHiveCountCheck, MigrationStopsNameCheck,
// MigrationStopsPlaceCheck, TransportsCheck, TransportsVehiclesCheck,
// TransportItemsVehicleCheck.
func init() {
	m.Register(upTasksHarvestsDocumentsMigrations, downTasksHarvestsDocumentsMigrations)
}

// Postgres enums, labels verbatim.
var (
	// public.task_source: 20261026180000 (manual, inspection, treatment),
	// 20261101230000 (queen_rearing), 20261105120000 (aks_update).
	taskSources = []string{"manual", "inspection", "treatment", "queen_rearing", "aks_update"}
	// public.honey_kind (20261026235000).
	honeyKinds = []string{"pine", "flower", "chestnut", "citrus", "other"}
	// public.harvest_unit (20261026235000).
	harvestUnits = []string{"super", "frame"}
	// public.withdrawal_override_reason (20261026235000).
	withdrawalOverrideReasons = []string{"removed_early", "not_for_sale"}
	// public.document_type (20261027180000).
	documentTypes = []string{
		"health_report", "transport_permit", "migratory_certificate",
		"business_registration", "land_permit", "analysis_report", "custom",
	}
	// public.document_file_kind (20261027180000).
	documentFileKinds = []string{"photo", "pdf"}
	// public.migration_stop_status (20261028120000).
	migrationStopStatuses = []string{"past", "current", "planned"}
	// public.transport_status (20261031120000).
	transportStatuses = []string{"loading", "unloading", "completed"}
)

// taskHarvestDocumentCollections lists this migration's collections, in
// creation order; down removes them in reverse.
var taskHarvestDocumentCollections = []string{
	"tasks", "harvests", "harvest_hives", "documents",
	"migrations", "migration_stops", "transports", "transport_items",
}

func upTasksHarvestsDocumentsMigrations(app core.App) error {
	tasks := syncedCollection("tasks",
		// title text check (char_length(btrim(title)) between 1 and 200),
		// nullable (tasks_title_check → validate); automatic tasks have none.
		&core.TextField{Name: "title", Max: 200},
		// due_at timestamptz not null.
		timeField("due_at", true),
		// apiary_id uuid, nullable; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", false),
		// hive_id uuid, nullable; (hive_id, org_id) FK to hives. A hive task
		// carries its apiary: tasks_check → validate.
		uuidField("hive_id", false),
		// assigned_to uuid, nullable; FK to auth.users on delete set null.
		// Not a relation: the account-deletion purge empties it (P5.9).
		uuidField("assigned_to", false),
		// completed_at timestamptz, nullable.
		timeField("completed_at", false),
		// source task_source not null default 'manual'.
		selectField("source", true, taskSources...),
		// source_id uuid, nullable; null exactly for manual tasks
		// (tasks_check1 → validate).
		uuidField("source_id", false),
		// 20261101200000: ref_drug_id uuid, nullable; FK to ref_drugs.
		uuidField("ref_drug_id", false),
		// 20261101200000: drug_id uuid, nullable; (drug_id, org_id) FK to
		// drugs. At most one of the two: tasks_one_drug_check → validate.
		uuidField("drug_id", false),
		// 20261101200000: dose numeric(8, 2) check (> 0 and <= 10000),
		// nullable (tasks_dose_check → validate); set exactly with a drug
		// (tasks_drug_dose_check), only on manual apiary tasks
		// (tasks_drug_manual_apiary_check).
		nullableNumberField("dose"),
		// 20261101230000: source_step smallint check (between 1 and 60),
		// nullable (tasks_source_step_check → validate); set exactly for
		// queen_rearing (tasks_queen_rearing_step_check → validate).
		nullableNumberField("source_step"),
	)
	// tasks_apiary_id_idx, tasks_hive_id_idx, tasks_assigned_to_idx,
	// tasks_source_id_idx, tasks_ref_drug_id_idx, tasks_drug_id_idx.
	tasks.AddIndex("idx_tasks_apiary_id", false, "`apiary_id`", "")
	tasks.AddIndex("idx_tasks_hive_id", false, "`hive_id`", "")
	tasks.AddIndex("idx_tasks_assigned_to", false, "`assigned_to`", "")
	tasks.AddIndex("idx_tasks_source_id", false, "`source_id`", "")
	tasks.AddIndex("idx_tasks_ref_drug_id", false, "`ref_drug_id`", "")
	tasks.AddIndex("idx_tasks_drug_id", false, "`drug_id`", "")
	if err := app.Save(tasks); err != nil {
		return err
	}

	// All of harvests comes from 20261026235000.
	harvests := syncedCollection("harvests",
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// harvested_at timestamptz not null.
		timeField("harvested_at", true),
		// honey_kind honey_kind not null.
		selectField("honey_kind", true, honeyKinds...),
		// unit harvest_unit not null.
		selectField("unit", true, harvestUnits...),
		// unit_count integer not null check (between 1 and 1000)
		// (harvests_unit_count_check).
		intField("unit_count", true, 1, 1000),
		// net_kg numeric(9, 3) not null check (> 0 and <= 100000)
		// (harvests_net_kg_check; Required rejects 0, the 3-decimal rounding
		// is validate.HarvestsNetKgCheck).
		&core.NumberField{
			Name:     "net_kg",
			Required: true,
			Min:      types.Pointer(0.0),
			Max:      types.Pointer(100000.0),
		},
	)
	// harvests_apiary_id_idx.
	harvests.AddIndex("idx_harvests_apiary_id", false, "`apiary_id`", "")
	if err := app.Save(harvests); err != nil {
		return err
	}

	// All of harvest_hives comes from 20261026235000.
	harvestHives := syncedCollection("harvest_hives",
		// harvest_id uuid not null; (harvest_id, org_id) FK to harvests.
		uuidField("harvest_id", true),
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// withdrawal_treatment_id uuid, nullable; (withdrawal_treatment_id,
		// org_id) FK to treatments. Set exactly with the reason:
		// harvest_hives_check → validate.
		uuidField("withdrawal_treatment_id", false),
		// withdrawal_override_reason withdrawal_override_reason, nullable.
		selectField("withdrawal_override_reason", false, withdrawalOverrideReasons...),
	)
	// harvest_hives_hive_id_idx, harvest_hives_withdrawal_treatment_id_idx.
	harvestHives.AddIndex("idx_harvest_hives_hive_id", false, "`hive_id`", "")
	harvestHives.AddIndex("idx_harvest_hives_withdrawal_treatment_id", false, "`withdrawal_treatment_id`", "")
	// harvest_hives_harvest_id_hive_id_key: a hive once per harvest among
	// live rows (`where deleted_at is null`).
	harvestHives.AddIndex("idx_harvest_hives_harvest_id_hive_id", true, "`harvest_id`, `hive_id`", "`deleted_at` = ''")
	if err := app.Save(harvestHives); err != nil {
		return err
	}

	// All of documents comes from 20261027180000.
	documents := syncedCollection("documents",
		// type document_type not null.
		selectField("type", true, documentTypes...),
		// custom_type_name text check (char_length(btrim(custom_type_name))
		// between 1 and 60), nullable (documents_custom_type_name_check →
		// validate); set exactly for type custom (documents_check →
		// validate).
		&core.TextField{Name: "custom_type_name", Max: 60},
		// name text not null check (char_length(btrim(name)) between 1 and
		// 120) (documents_name_check → validate).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 120},
		// description text check (char_length(description) <= 500), nullable
		// (documents_description_check).
		&core.TextField{Name: "description", Max: 500},
		// expires_on date, nullable (no end date); the last valid day.
		dateField("expires_on", false),
		// file_kind document_file_kind not null.
		selectField("file_kind", true, documentFileKinds...),
		// storage_path text not null; documents_check1 ties it to org_id, id
		// and file_kind (→ validate.DocumentsCheck1). The field pattern is the
		// object name shape of private.document_object_org_id.
		&core.TextField{Name: "storage_path", Required: true, Pattern: validate.DocumentStoragePath},
		// byte_size integer not null check (between 1 and 20971520)
		// (documents_byte_size_check; the documents bucket's 20 MB limit).
		intField("byte_size", true, 1, 20971520),
	)
	if err := app.Save(documents); err != nil {
		return err
	}

	// All of migrations comes from 20261028120000.
	migrationPlans := syncedCollection("migrations",
		// year integer not null check (between 2000 and 2100)
		// (migrations_year_check).
		intField("year", true, 2000, 2100),
		// name text not null check (char_length(btrim(name)) between 1 and
		// 120) (migrations_name_check → validate).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 120},
	)
	if err := app.Save(migrationPlans); err != nil {
		return err
	}

	// All of migration_stops comes from 20261028120000.
	migrationStops := syncedCollection("migration_stops",
		// migration_id uuid not null; (migration_id, org_id) FK to migrations.
		uuidField("migration_id", true),
		// position integer not null check (between 1 and 1000)
		// (migration_stops_position_check).
		intField("position", true, 1, 1000),
		// name text not null check (char_length(btrim(name)) between 1 and
		// 120) (migration_stops_name_check → validate).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 120},
		// place text check (char_length(btrim(place)) between 1 and 120),
		// nullable (migration_stops_place_check → validate).
		&core.TextField{Name: "place", Max: 120},
		// planned_start_on, planned_end_on date not null; end not before
		// start (migration_stops_check → validate).
		dateField("planned_start_on", true),
		dateField("planned_end_on", true),
		// apiary_id uuid, nullable; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", false),
		// hive_count integer check (between 0 and 100000), nullable
		// (migration_stops_hive_count_check → validate).
		nullableNumberField("hive_count"),
		// status migration_stop_status not null default 'planned'.
		selectField("status", true, migrationStopStatuses...),
	)
	// migration_stops_migration_id_idx, migration_stops_apiary_id_idx.
	migrationStops.AddIndex("idx_migration_stops_migration_id", false, "`migration_id`", "")
	migrationStops.AddIndex("idx_migration_stops_apiary_id", false, "`apiary_id`", "")
	if err := app.Save(migrationStops); err != nil {
		return err
	}

	// All of transports comes from 20261031120000.
	transports := syncedCollection("transports",
		// migration_stop_id uuid, nullable; (migration_stop_id, org_id) FK to
		// migration_stops.
		uuidField("migration_stop_id", false),
		// source_apiary_id, destination_apiary_id uuid not null;
		// (x, org_id) FKs to apiaries; they differ (transports_check →
		// validate).
		uuidField("source_apiary_id", true),
		uuidField("destination_apiary_id", true),
		// vehicles jsonb not null default '[]' check (jsonb_typeof(vehicles)
		// = 'array') (transports_vehicles_check → validate). Not Required: a
		// required JSON field rejects `[]`.
		&core.JSONField{Name: "vehicles", MaxSize: validate.MaxTransportVehicles},
		// status transport_status not null default 'loading'.
		selectField("status", true, transportStatuses...),
		// completed_at timestamptz, nullable.
		timeField("completed_at", false),
	)
	// transports_migration_stop_id_idx, transports_source_apiary_id_idx,
	// transports_destination_apiary_id_idx.
	transports.AddIndex("idx_transports_migration_stop_id", false, "`migration_stop_id`", "")
	transports.AddIndex("idx_transports_source_apiary_id", false, "`source_apiary_id`", "")
	transports.AddIndex("idx_transports_destination_apiary_id", false, "`destination_apiary_id`", "")
	if err := app.Save(transports); err != nil {
		return err
	}

	// All of transport_items comes from 20261031120000.
	transportItems := syncedCollection("transport_items",
		// transport_id uuid not null; (transport_id, org_id) FK to transports.
		uuidField("transport_id", true),
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// vehicle text not null check (char_length(btrim(vehicle)) between 1
		// and 60) (transport_items_vehicle_check → validate).
		&core.TextField{Name: "vehicle", Required: true, Min: 1, Max: 60},
		// loaded_at timestamptz not null.
		timeField("loaded_at", true),
		// unloaded_at timestamptz, nullable.
		timeField("unloaded_at", false),
	)
	// transport_items_transport_id_idx, transport_items_hive_id_idx.
	transportItems.AddIndex("idx_transport_items_transport_id", false, "`transport_id`", "")
	transportItems.AddIndex("idx_transport_items_hive_id", false, "`hive_id`", "")
	return app.Save(transportItems)
}

func downTasksHarvestsDocumentsMigrations(app core.App) error {
	for i := len(taskHarvestDocumentCollections) - 1; i >= 0; i-- {
		c, err := app.FindCollectionByNameOrId(taskHarvestDocumentCollections[i])
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
