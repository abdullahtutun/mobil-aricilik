package validate

import (
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"regexp"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of inspections, media and mite_counts (20261024142500,
// 20261024190000, 20261025120000, 20261025220000).

// uuidPart is [pattern.UUID] without its anchors.
var uuidPart = strings.TrimSuffix(strings.TrimPrefix(pattern.UUID, "^"), "$")

// MediaStoragePath is the shape of media.storage_path:
// `<org_id>/<hive_id>/<id>.jpg|m4a`, the object name Supabase's
// private.media_object_org_id accepted (20261024190000), with each folder a
// lower-case UUID as media_check produces it. The migration uses it as the
// field pattern; [MediaCheck] ties the parts to the row.
var MediaStoragePath = "^" + uuidPart + "/" + uuidPart + "/" + uuidPart + `\.(jpg|m4a)$`

var mediaStoragePathRe = regexp.MustCompile(MediaStoragePath)

// MaxInspectionData is the size limit of inspections.data in bytes. Supabase
// has none; the client stores `actions` and `withdrawal_override` there, a few
// hundred bytes.
const MaxInspectionData = 64 << 10

// NullableBool checks a nullable boolean column stored as JSON (see
// nullableBoolField in migrations): null, true or false.
func NullableBool(raw types.JSONRaw) error {
	if len(raw) == 0 {
		return nil
	}
	var decoded any
	if err := json.Unmarshal(raw, &decoded); err != nil {
		return fmt.Errorf("not JSON: %w", err)
	}
	switch decoded.(type) {
	case nil, bool:
		return nil
	default:
		return fmt.Errorf("must be true, false or null, got %T", decoded)
	}
}

// InspectionsBeeFramesCheck is inspections_bee_frames_check: null, or 0…100.
func InspectionsBeeFramesCheck(raw types.JSONRaw) error {
	return column("bee_frames", NullableInt(raw, 0, 100))
}

// InspectionsBroodFramesCheck is inspections_brood_frames_check: null, or
// 0…100.
func InspectionsBroodFramesCheck(raw types.JSONRaw) error {
	return column("brood_frames", NullableInt(raw, 0, 100))
}

// InspectionsHoneyFramesCheck is inspections_honey_frames_check: null, or
// 0…100.
func InspectionsHoneyFramesCheck(raw types.JSONRaw) error {
	return column("honey_frames", NullableInt(raw, 0, 100))
}

// InspectionsBooleans: swarm_signs and disease_suspected are nullable
// booleans (no CHECK in Supabase; the column type).
func InspectionsBooleans(swarmSigns, diseaseSuspected types.JSONRaw) error {
	if err := NullableBool(swarmSigns); err != nil {
		return column("swarm_signs", err)
	}
	return column("disease_suspected", NullableBool(diseaseSuspected))
}

// InspectionsDataCheck is inspections_data_check: data is a JSON object. The
// column is `not null default '{}'`; push sends the client's value, so an
// empty or null value is rejected like Postgres' not-null would.
func InspectionsDataCheck(raw types.JSONRaw) error {
	if len(raw) > MaxInspectionData {
		return fmt.Errorf("data: larger than %d bytes", MaxInspectionData)
	}
	var decoded any
	if err := json.Unmarshal(raw, &decoded); err != nil {
		return fmt.Errorf("data: not JSON: %w", err)
	}
	if _, ok := decoded.(map[string]any); !ok {
		return fmt.Errorf("data: must be an object, got %T", decoded)
	}
	return nil
}

// MediaCheck is media_check: storage_path is exactly
// `<org_id>/<hive_id>/<id>.<ext>`, jpg for a photo and m4a for audio, so a
// row cannot point at another organization's, hive's or row's file.
func MediaCheck(id, orgID, hiveID, kind, storagePath string) error {
	if !mediaStoragePathRe.MatchString(storagePath) {
		return errors.New("storage_path must be <org_id>/<hive_id>/<id>.jpg|m4a")
	}
	ext := "m4a"
	if kind == "photo" {
		ext = "jpg"
	}
	want := fmt.Sprintf("%s/%s/%s.%s", orgID, hiveID, id, ext)
	if storagePath != want {
		return fmt.Errorf("storage_path must be %s, got %s", want, storagePath)
	}
	return nil
}

// MediaDurationMsCheck is media_duration_ms_check: null, or an integer >= 0.
func MediaDurationMsCheck(raw types.JSONRaw) error {
	return column("duration_ms", NullableInt(raw, 0, math.MaxInt32))
}

// MediaCheck1 is media_check1: only audio has a duration.
func MediaCheck1(kind string, durationMs types.JSONRaw) error {
	_, isNull, err := nullableNumber(durationMs)
	if err != nil {
		return column("duration_ms", err)
	}
	if kind != "audio" && !isNull {
		return fmt.Errorf("duration_ms is only set for audio, kind is %q", kind)
	}
	return nil
}

// MediaSingleOwnerCheck is media_single_owner_check (20261025220000): a file
// belongs to an inspection or a treatment, not both.
func MediaSingleOwnerCheck(inspectionID, treatmentID string) error {
	if inspectionID != "" && treatmentID != "" {
		return errors.New("inspection_id and treatment_id cannot both be set")
	}
	return nil
}

// MiteCountsSampleBeesCheck is mite_counts_sample_bees_check: null, or
// 1…5000.
func MiteCountsSampleBeesCheck(raw types.JSONRaw) error {
	return column("sample_bees", NullableInt(raw, 1, 5000))
}

// MiteCountsDaysCheck is mite_counts_days_check: null, or 1…60.
func MiteCountsDaysCheck(raw types.JSONRaw) error {
	return column("days", NullableInt(raw, 1, 60))
}

// MiteCountsCheck is mite_counts_check: a sticky board count has days, the
// other methods do not.
func MiteCountsCheck(method string, days types.JSONRaw) error {
	_, isNull, err := nullableNumber(days)
	if err != nil {
		return column("days", err)
	}
	if (method == "sticky_board") != !isNull {
		return fmt.Errorf("days must be set exactly for sticky_board, method is %q", method)
	}
	return nil
}

// MiteCountsCheck1 is mite_counts_check1: a sticky board count has no bee
// sample, the other methods do.
func MiteCountsCheck1(method string, sampleBees types.JSONRaw) error {
	_, isNull, err := nullableNumber(sampleBees)
	if err != nil {
		return column("sample_bees", err)
	}
	if (method == "sticky_board") != isNull {
		return fmt.Errorf("sample_bees must be set exactly when not sticky_board, method is %q", method)
	}
	return nil
}
