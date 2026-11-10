package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// inspections, media, mite_counts, ref_drugs, drugs, treatments and feedings
// in their final Supabase shape. Each field names the Supabase migration that
// defined it (supabase/migrations/…): 20261024142500_inspections,
// 20261024190000_media, 20261025120000_mite_counts,
// 20261025200000_treatments (ref_drugs, drugs, treatments),
// 20261025220000_treatment_groups and 20261026120000_feedings. No later
// migration changes these columns; the reference rows are migration
// 1794300005.
//
// As in 1794300003: no `unique (id, org_id)` and no composite foreign keys
// (same-organization links are checked on push, P5.3), and the
// `(org_id, server_seq)` index covers `<table>_org_id_idx`.
//
// A PocketBase number field is NOT NULL DEFAULT 0 and `Required` rejects 0,
// so a not-null column whose CHECK allows 0 (mites, withdrawal_days of
// treatments) is a non-required number: push always sends the client's value.
//
// Checks a field option cannot express are in internal/validate:
// InspectionsBeeFramesCheck, InspectionsBroodFramesCheck,
// InspectionsHoneyFramesCheck, InspectionsBooleans, InspectionsDataCheck,
// MediaCheck, MediaCheck1, MediaDurationMsCheck, MediaSingleOwnerCheck,
// MiteCountsCheck, MiteCountsCheck1, MiteCountsSampleBeesCheck,
// MiteCountsDaysCheck, RefDrugsWithdrawalDaysCheck, DrugsWithdrawalDaysCheck,
// TreatmentsCheck, TreatmentsCheck1, TreatmentsDoseCheck,
// FeedingsAmountCheck.
func init() {
	m.Register(upInspectionsTreatmentsFeedings, downInspectionsTreatmentsFeedings)
}

// Postgres enums, labels verbatim.
var (
	// public.inspection_queen_state (20261024142500).
	inspectionQueenStates = []string{"seen", "eggs", "none"}
	// public.inspection_temperament (20261024142500).
	inspectionTemperaments = []string{"calm", "nervous"}
	// public.inspection_queen_cells (20261024142500).
	inspectionQueenCells = []string{"none", "swarm", "supersedure", "emergency"}
	// public.media_kind (20261024190000).
	mediaKinds = []string{"photo", "audio"}
	// public.mite_count_method (20261025120000).
	miteCountMethods = []string{"sugar_roll", "alcohol_wash", "sticky_board"}
	// public.drug_active_ingredient (20261025200000).
	drugActiveIngredients = []string{
		"amitraz", "oxalic_acid", "formic_acid", "thymol", "flumethrin",
		"tau_fluvalinate", "coumaphos", "lactic_acid", "other",
	}
	// public.drug_dose_unit (20261025200000).
	drugDoseUnits = []string{"strip", "ml", "g", "dose"}
	// public.feeding_kind (20261026120000).
	feedingKinds = []string{"syrup_1_1", "syrup_2_1", "bee_cake", "pollen_substitute"}
)

// inspectionTreatmentCollections lists this migration's collections, in
// creation order; down removes them in reverse.
var inspectionTreatmentCollections = []string{
	"inspections", "media", "mite_counts", "ref_drugs", "drugs", "treatments", "feedings",
}

// intField is a not-null integer column whose range is [min, max].
func intField(name string, required bool, min, max float64) *core.NumberField {
	return &core.NumberField{
		Name:     name,
		Required: required,
		OnlyInt:  true,
		Min:      types.Pointer(min),
		Max:      types.Pointer(max),
	}
}

func upInspectionsTreatmentsFeedings(app core.App) error {
	// All of inspections comes from 20261024142500.
	inspections := syncedCollection("inspections",
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// inspected_at timestamptz not null.
		timeField("inspected_at", true),
		// queen_state inspection_queen_state, nullable.
		selectField("queen_state", false, inspectionQueenStates...),
		// bee_frames, brood_frames, honey_frames smallint check (between 0
		// and 100), nullable (inspections_*_frames_check → validate).
		nullableNumberField("bee_frames"),
		nullableNumberField("brood_frames"),
		nullableNumberField("honey_frames"),
		// temperament inspection_temperament, nullable.
		selectField("temperament", false, inspectionTemperaments...),
		// swarm_signs boolean, nullable ("not checked" ≠ "no").
		nullableBoolField("swarm_signs"),
		// queen_cells inspection_queen_cells, nullable.
		selectField("queen_cells", false, inspectionQueenCells...),
		// disease_suspected boolean, nullable.
		nullableBoolField("disease_suspected"),
		// data jsonb not null default '{}' check (jsonb_typeof(data) =
		// 'object') (inspections_data_check → validate). Not Required: a
		// required JSON field rejects `{}`.
		&core.JSONField{Name: "data", MaxSize: validate.MaxInspectionData},
	)
	// inspections_hive_id_idx, inspections_apiary_id_idx.
	inspections.AddIndex("idx_inspections_hive_id", false, "`hive_id`", "")
	inspections.AddIndex("idx_inspections_apiary_id", false, "`apiary_id`", "")
	if err := app.Save(inspections); err != nil {
		return err
	}

	media := syncedCollection("media",
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// inspection_id uuid, nullable; (inspection_id, org_id) FK to
		// inspections.
		uuidField("inspection_id", false),
		// kind media_kind not null.
		selectField("kind", true, mediaKinds...),
		// storage_path text not null; media_check ties it to org_id, hive_id,
		// id and kind (→ validate.MediaCheck). The field pattern is the
		// object name shape of private.media_object_org_id.
		&core.TextField{Name: "storage_path", Required: true, Pattern: validate.MediaStoragePath},
		// captured_at timestamptz not null.
		timeField("captured_at", true),
		// byte_size integer not null check (between 1 and 10485760)
		// (media_byte_size_check; the media bucket's 10 MB limit).
		intField("byte_size", true, 1, 10485760),
		// duration_ms integer check (>= 0), nullable
		// (media_duration_ms_check → validate); only for audio
		// (media_check1 → validate).
		nullableNumberField("duration_ms"),
		// 20261025220000: treatment_id uuid, nullable; (treatment_id, org_id)
		// FK to treatments. Not with inspection_id:
		// media_single_owner_check → validate.
		uuidField("treatment_id", false),
	)
	// media_hive_id_idx, media_inspection_id_idx, media_treatment_id_idx
	// (20261025220000).
	media.AddIndex("idx_media_hive_id", false, "`hive_id`", "")
	media.AddIndex("idx_media_inspection_id", false, "`inspection_id`", "")
	media.AddIndex("idx_media_treatment_id", false, "`treatment_id`", "")
	if err := app.Save(media); err != nil {
		return err
	}

	// All of mite_counts comes from 20261025120000.
	miteCounts := syncedCollection("mite_counts",
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// counted_at timestamptz not null.
		timeField("counted_at", true),
		// method mite_count_method not null.
		selectField("method", true, miteCountMethods...),
		// mites integer not null check (between 0 and 100000)
		// (mite_counts_mites_check). 0 is valid, so not Required.
		intField("mites", false, 0, 100000),
		// sample_bees smallint check (between 1 and 5000), nullable
		// (mite_counts_sample_bees_check → validate); null exactly for
		// sticky_board (mite_counts_check1 → validate).
		nullableNumberField("sample_bees"),
		// days smallint check (between 1 and 60), nullable
		// (mite_counts_days_check → validate); set exactly for sticky_board
		// (mite_counts_check → validate).
		nullableNumberField("days"),
	)
	// mite_counts_hive_id_idx, mite_counts_apiary_id_idx.
	miteCounts.AddIndex("idx_mite_counts_hive_id", false, "`hive_id`", "")
	miteCounts.AddIndex("idx_mite_counts_apiary_id", false, "`apiary_id`", "")
	if err := app.Save(miteCounts); err != nil {
		return err
	}

	// ref_drugs (20261025200000): the reference drug list, no org_id; every
	// signed-in user reads it, nobody writes it from the client.
	refDrugs := syncedCollectionWithoutOrg("ref_drugs",
		// country_code text not null check (= 'GLOBAL' or ~ '^[A-Z]{2}$')
		// (ref_drugs_country_code_check).
		&core.TextField{Name: "country_code", Required: true, Max: 6, Pattern: `^(GLOBAL|[A-Z]{2})$`},
		// name_tr, name_en text not null check (length between 1 and 120)
		// (ref_drugs_name_tr_check, ref_drugs_name_en_check).
		&core.TextField{Name: "name_tr", Required: true, Min: 1, Max: 120},
		&core.TextField{Name: "name_en", Required: true, Min: 1, Max: 120},
		// active_ingredient drug_active_ingredient not null.
		selectField("active_ingredient", true, drugActiveIngredients...),
		// dose_unit drug_dose_unit not null.
		selectField("dose_unit", true, drugDoseUnits...),
		// withdrawal_days smallint check (between 0 and 365), nullable
		// (ref_drugs_withdrawal_days_check → validate).
		nullableNumberField("withdrawal_days"),
		// license_no text check (length between 1 and 60), nullable
		// (ref_drugs_license_no_check; empty is null).
		&core.TextField{Name: "license_no", Max: 60},
	)
	if err := app.Save(refDrugs); err != nil {
		return err
	}

	// drugs (20261025200000): the organization's own drugs.
	drugs := syncedCollection("drugs",
		// name text not null check (length between 1 and 120)
		// (drugs_name_check).
		&core.TextField{Name: "name", Required: true, Min: 1, Max: 120},
		// active_ingredient drug_active_ingredient not null.
		selectField("active_ingredient", true, drugActiveIngredients...),
		// dose_unit drug_dose_unit not null.
		selectField("dose_unit", true, drugDoseUnits...),
		// withdrawal_days smallint check (between 0 and 365), nullable
		// (drugs_withdrawal_days_check → validate).
		nullableNumberField("withdrawal_days"),
		// license_no text check (length between 1 and 60), nullable
		// (drugs_license_no_check).
		&core.TextField{Name: "license_no", Max: 60},
	)
	if err := app.Save(drugs); err != nil {
		return err
	}

	// treatments (20261025200000).
	treatments := syncedCollection("treatments",
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// ref_drug_id uuid, nullable; FK to ref_drugs.
		uuidField("ref_drug_id", false),
		// drug_id uuid, nullable; (drug_id, org_id) FK to drugs. Exactly one
		// of the two: treatments_check1 → validate.
		uuidField("drug_id", false),
		// product_name text not null check (length between 1 and 120)
		// (treatments_product_name_check).
		&core.TextField{Name: "product_name", Required: true, Min: 1, Max: 120},
		// active_ingredient drug_active_ingredient not null.
		selectField("active_ingredient", true, drugActiveIngredients...),
		// batch_no text check (length between 1 and 60), nullable
		// (treatments_batch_no_check).
		&core.TextField{Name: "batch_no", Max: 60},
		// dose numeric(8, 2) not null check (> 0 and <= 10000)
		// (treatments_dose_check; Required rejects 0, the 2-decimal rounding
		// is validate.TreatmentsDoseCheck).
		&core.NumberField{
			Name:     "dose",
			Required: true,
			Min:      types.Pointer(0.0),
			Max:      types.Pointer(10000.0),
		},
		// dose_unit drug_dose_unit not null.
		selectField("dose_unit", true, drugDoseUnits...),
		// started_at timestamptz not null.
		timeField("started_at", true),
		// planned_removal_at timestamptz check (>= started_at), nullable
		// (treatments_check → validate).
		timeField("planned_removal_at", false),
		// withdrawal_days smallint not null check (between 0 and 365)
		// (treatments_withdrawal_days_check). 0 is valid, so not Required.
		intField("withdrawal_days", false, 0, 365),
		// 20261025220000: application_id uuid, nullable (one application
		// over many hives).
		uuidField("application_id", false),
	)
	// treatments_hive_id_idx, treatments_apiary_id_idx,
	// treatments_ref_drug_id_idx, treatments_drug_id_idx,
	// treatments_application_id_idx (20261025220000).
	treatments.AddIndex("idx_treatments_hive_id", false, "`hive_id`", "")
	treatments.AddIndex("idx_treatments_apiary_id", false, "`apiary_id`", "")
	treatments.AddIndex("idx_treatments_ref_drug_id", false, "`ref_drug_id`", "")
	treatments.AddIndex("idx_treatments_drug_id", false, "`drug_id`", "")
	treatments.AddIndex("idx_treatments_application_id", false, "`application_id`", "")
	if err := app.Save(treatments); err != nil {
		return err
	}

	// All of feedings comes from 20261026120000.
	feedings := syncedCollection("feedings",
		// hive_id uuid not null; (hive_id, org_id) FK to hives.
		uuidField("hive_id", true),
		// apiary_id uuid not null; (apiary_id, org_id) FK to apiaries.
		uuidField("apiary_id", true),
		// feeding_group_id uuid not null (one feeding over many hives).
		uuidField("feeding_group_id", true),
		// fed_at timestamptz not null.
		timeField("fed_at", true),
		// kind feeding_kind not null.
		selectField("kind", true, feedingKinds...),
		// amount numeric(7, 3) not null check (> 0 and <= 100)
		// (feedings_amount_check; Required rejects 0, the 3-decimal rounding
		// is validate.FeedingsAmountCheck).
		&core.NumberField{
			Name:     "amount",
			Required: true,
			Min:      types.Pointer(0.0),
			Max:      types.Pointer(100.0),
		},
	)
	// feedings_hive_id_idx, feedings_apiary_id_idx,
	// feedings_feeding_group_id_idx.
	feedings.AddIndex("idx_feedings_hive_id", false, "`hive_id`", "")
	feedings.AddIndex("idx_feedings_apiary_id", false, "`apiary_id`", "")
	feedings.AddIndex("idx_feedings_feeding_group_id", false, "`feeding_group_id`", "")
	return app.Save(feedings)
}

func downInspectionsTreatmentsFeedings(app core.App) error {
	for i := len(inspectionTreatmentCollections) - 1; i >= 0; i-- {
		c, err := app.FindCollectionByNameOrId(inspectionTreatmentCollections[i])
		if err != nil {
			return err
		}
		if err := app.Delete(c); err != nil {
			return err
		}
	}
	return nil
}
