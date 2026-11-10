package validate

import (
	"encoding/json"
	"errors"
	"fmt"

	"github.com/pocketbase/pocketbase/tools/types"
)

// Checks of harvests, harvest_hives (20261026235000), migrations,
// migration_stops (20261028120000), transports and transport_items
// (20261031120000).

// HarvestsNetKgCheck is harvests_net_kg_check on a numeric(9, 3) column:
// 0 < net_kg <= 100000 after Postgres rounds it to 3 decimals. Push stores
// [RoundNumeric](net_kg, 3).
func HarvestsNetKgCheck(netKg float64) error {
	if v := RoundNumeric(netKg, 3); !(v > 0 && v <= 100000) {
		return fmt.Errorf("net_kg must be > 0 and <= 100000, got %v", netKg)
	}
	return nil
}

// HarvestHivesCheck is harvest_hives_check: the locking treatment and the
// override reason are both set or both empty.
func HarvestHivesCheck(withdrawalTreatmentID, withdrawalOverrideReason string) error {
	if (withdrawalTreatmentID == "") != (withdrawalOverrideReason == "") {
		return errors.New("withdrawal_treatment_id and withdrawal_override_reason must both be set or both be empty")
	}
	return nil
}

// MigrationsNameCheck is migrations_name_check: 1–120 characters after
// trimming spaces.
func MigrationsNameCheck(name string) error {
	return btrimLength("name", name, false, 1, 120)
}

// MigrationStopsNameCheck is migration_stops_name_check: 1–120 characters
// after trimming spaces.
func MigrationStopsNameCheck(name string) error {
	return btrimLength("name", name, false, 1, 120)
}

// MigrationStopsPlaceCheck is migration_stops_place_check: null, or 1–120
// characters after trimming spaces.
func MigrationStopsPlaceCheck(place string) error {
	return btrimLength("place", place, true, 1, 120)
}

// MigrationStopsCheck is migration_stops_check: the planned end is not before
// the start. Both are YYYY-MM-DD, so text order is day order.
func MigrationStopsCheck(plannedStartOn, plannedEndOn string) error {
	if plannedEndOn < plannedStartOn {
		return errors.New("planned_end_on must not be before planned_start_on")
	}
	return nil
}

// MigrationStopsHiveCountCheck is migration_stops_hive_count_check: null, or
// 0…100000.
func MigrationStopsHiveCountCheck(raw types.JSONRaw) error {
	return column("hive_count", NullableInt(raw, 0, 100000))
}

// MaxTransportVehicles is the size limit of transports.vehicles in bytes.
// Supabase has none; the client stores a few vehicle names.
const MaxTransportVehicles = 16 << 10

// TransportsVehiclesCheck is transports_vehicles_check: vehicles is a JSON
// array. The column is `not null default '[]'`; push sends the client's
// value, so an empty or null value is rejected like Postgres' not-null would.
func TransportsVehiclesCheck(raw types.JSONRaw) error {
	if len(raw) > MaxTransportVehicles {
		return fmt.Errorf("vehicles: larger than %d bytes", MaxTransportVehicles)
	}
	var decoded any
	if err := json.Unmarshal(raw, &decoded); err != nil {
		return fmt.Errorf("vehicles: not JSON: %w", err)
	}
	if _, ok := decoded.([]any); !ok {
		return fmt.Errorf("vehicles: must be an array, got %T", decoded)
	}
	return nil
}

// TransportsCheck is transports_check: source and destination apiaries
// differ.
func TransportsCheck(sourceApiaryID, destinationApiaryID string) error {
	if sourceApiaryID == destinationApiaryID {
		return errors.New("source_apiary_id and destination_apiary_id must differ")
	}
	return nil
}

// TransportItemsVehicleCheck is transport_items_vehicle_check: 1–60
// characters after trimming spaces.
func TransportItemsVehicleCheck(vehicle string) error {
	return btrimLength("vehicle", vehicle, false, 1, 60)
}
