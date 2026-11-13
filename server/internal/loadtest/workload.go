package loadtest

import (
	"crypto/rand"
	"errors"
	"fmt"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
)

// SchemaVersion is the newest schema version the server takes: the one
// the current app sends.
var SchemaVersion = appsync.SupportedSchemaVersions[len(appsync.SupportedSchemaVersions)-1]

// change is one element of a push packet, as the app's outbox sends it.
type change struct {
	ID        string         `json:"id"`
	Table     string         `json:"table"`
	Operation string         `json:"operation"`
	Payload   map[string]any `json:"payload"`
}

// hivesPerAccount is how many hives an account's records are spread over;
// fewer when the account has fewer records.
const hivesPerAccount = 100

// workload is an account's records in outbox order: one apiary, then each
// hive with its first location entry, then inspections over the hives
// until total. Every row references only rows before it, so packets in
// order are never missing_reference.
func workload(orgID, userID string, total int, now time.Time) []change {
	if total < 1 {
		return nil
	}
	out := make([]change, 0, total)
	add := func(table string, payload map[string]any) bool {
		if len(out) == total {
			return false
		}
		out = append(out, change{ID: ids.New(), Table: table, Operation: "upsert", Payload: payload})
		return true
	}
	stamp := func(i int) string {
		return pattern.FormatTimestamp(now.Add(time.Duration(i) * time.Millisecond))
	}
	row := func(id string, i int, fields map[string]any) map[string]any {
		fields["id"] = id
		fields["org_id"] = orgID
		fields["created_by"] = userID
		fields["created_at"] = stamp(i)
		fields["updated_at"] = stamp(i)
		fields["deleted_at"] = nil
		return fields
	}

	apiaryID := ids.New()
	add("apiaries", row(apiaryID, 0, map[string]any{
		"name": "Yük testi arılığı", "latitude": 38.42, "longitude": 27.14,
		"altitude_m": 120, "land_tenure": "owned", "notes": "loadtest",
	}))

	hives := min(hivesPerAccount, (total-1)/2)
	hiveIDs := make([]string, 0, hives)
	for h := range hives {
		id := ids.New()
		hiveIDs = append(hiveIDs, id)
		add("hives", row(id, len(out), map[string]any{
			"number": fmt.Sprint(h + 1), "type": "langstroth", "status": "active",
			"apiary_id": apiaryID, "box_count": 2, "frame_count": 10, "source": "split",
		}))
		add("hive_location_history", row(ids.New(), len(out), map[string]any{
			"hive_id": id, "apiary_id": apiaryID, "moved_at": stamp(len(out)),
		}))
	}

	for i := 0; len(hiveIDs) > 0 && len(out) < total; i++ {
		at := stamp(len(out))
		add("inspections", row(ids.New(), len(out), map[string]any{
			"hive_id": hiveIDs[i%len(hiveIDs)], "apiary_id": apiaryID, "inspected_at": at,
			"queen_state": "eggs", "bee_frames": 8, "brood_frames": 5, "honey_frames": 2,
			"temperament": "calm", "swarm_signs": false, "queen_cells": "none",
			"disease_suspected": false,
			"data":              map[string]any{"note": "loadtest", "weight_kg": 32.5},
		}))
	}
	return out
}

// packets cuts changes into pushes of at most size.
func packets(changes []change, size int) [][]change {
	var out [][]change
	for len(changes) > 0 {
		n := min(size, len(changes))
		out = append(out, changes[:n])
		changes = changes[n:]
	}
	return out
}

// fakeJPEG is size bytes that PocketBase detects as image/jpeg: the JPEG
// start of image and a JFIF header, then random bytes (incompressible, like
// a photo). The server never decodes it: thumbnails are off.
func fakeJPEG(size int) ([]byte, error) {
	header := []byte{0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 'J', 'F', 'I', 'F', 0x00, 0x01, 0x01, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00}
	if size < len(header)+2 {
		return nil, errors.New("file size too small for a JPEG header")
	}
	b := make([]byte, size)
	copy(b, header)
	if _, err := rand.Read(b[len(header) : size-2]); err != nil {
		return nil, err
	}
	b[size-2], b[size-1] = 0xFF, 0xD9 // end of image
	return b, nil
}
