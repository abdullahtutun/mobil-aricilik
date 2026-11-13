package validate

import (
	"errors"
	"fmt"
	"math"
	"strings"
	"unicode/utf8"

	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of apiaries, queens, hives and hive_status_events
// (20261021201714, 20261107120000, 20261108120000). Integer columns without a
// CHECK still need one here: a JSON number may be fractional or out of the
// Postgres type's range.

// ApiariesLocationCheck is the location rule Supabase's sync_push applied
// before building the PostGIS point (20261023164500): latitude and longitude
// are both null or both numbers, latitude in −90…90, longitude in −180…180.
func ApiariesLocationCheck(latitude, longitude types.JSONRaw) error {
	lat, latNull, err := nullableNumber(latitude)
	if err != nil {
		return fmt.Errorf("latitude: %w", err)
	}
	lon, lonNull, err := nullableNumber(longitude)
	if err != nil {
		return fmt.Errorf("longitude: %w", err)
	}
	if latNull != lonNull {
		return errors.New("latitude and longitude must both be set or both be null")
	}
	if latNull {
		return nil
	}
	if lat < -90 || lat > 90 {
		return fmt.Errorf("latitude must be between -90 and 90, got %v", lat)
	}
	if lon < -180 || lon > 180 {
		return fmt.Errorf("longitude must be between -180 and 180, got %v", lon)
	}
	return nil
}

// ApiariesAltitudeMCheck: apiaries.altitude_m integer, nullable (no CHECK in
// Supabase; the integer type's range).
func ApiariesAltitudeMCheck(raw types.JSONRaw) error {
	return column("altitude_m", NullableInt(raw, math.MinInt32, math.MaxInt32))
}

// ApiariesVehicleDistanceMCheck is apiaries_vehicle_distance_m_check:
// null, or an integer >= 0 (integer column).
func ApiariesVehicleDistanceMCheck(raw types.JSONRaw) error {
	return column("vehicle_distance_m", NullableInt(raw, 0, math.MaxInt32))
}

// QueensYearCheck is queens_year_check: null, or 2000…2100.
func QueensYearCheck(raw types.JSONRaw) error {
	return column("year", NullableInt(raw, 2000, 2100))
}

// QueensCheck is queens_check: a queen is not her own mother.
func QueensCheck(id, motherQueenID string) error {
	if motherQueenID != "" && motherQueenID == id {
		return errors.New("mother_queen_id must differ from id")
	}
	return nil
}

// HivesFrameCountCheck is hives_frame_count_check: null, or a smallint >= 0.
func HivesFrameCountCheck(raw types.JSONRaw) error {
	return column("frame_count", NullableInt(raw, 0, math.MaxInt16))
}

// HivesQuarantineDiseaseCheck is hives_quarantine_disease_check: empty
// (null), or 1–100 characters after trimming spaces (Postgres btrim).
func HivesQuarantineDiseaseCheck(disease string) error {
	if disease == "" {
		return nil
	}
	n := utf8.RuneCountInString(strings.Trim(disease, " "))
	if n < 1 || n > 100 {
		return fmt.Errorf("quarantine_disease must be 1 to 100 characters, got %d", n)
	}
	return nil
}

// HivesQuarantineConsistent is hives_quarantine_consistent: quarantined_at is
// set exactly when the hive is quarantined, and a disease only while it is.
func HivesQuarantineConsistent(quarantined bool, quarantinedAt, disease string) error {
	if quarantined != (quarantinedAt != "") {
		return errors.New("quarantined_at must be set exactly when quarantined")
	}
	if !quarantined && disease != "" {
		return errors.New("quarantine_disease is only set while quarantined")
	}
	return nil
}

// HiveStatusEventsCheck is hive_status_events_check: the status changes.
func HiveStatusEventsCheck(fromStatus, toStatus string) error {
	if fromStatus == toStatus {
		return fmt.Errorf("from_status and to_status are both %q", fromStatus)
	}
	return nil
}

// HiveStatusEventsCheck1 is hive_status_events_check1: a loss reason only
// when the hive died or was lost.
func HiveStatusEventsCheck1(toStatus, lossReason string) error {
	if lossReason != "" && toStatus != "dead" && toStatus != "lost" {
		return fmt.Errorf("loss_reason needs to_status dead or lost, got %q", toStatus)
	}
	return nil
}

func column(name string, err error) error {
	if err != nil {
		return fmt.Errorf("%s: %w", name, err)
	}
	return nil
}
