// Package recordapi holds the server side of the collections the app writes
// through PocketBase's record API (P3.2): feedback and analytics_events. The
// API rules themselves are in migrations/1794300010_api_rules.go.
package recordapi

import (
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/pocketbase/core"
)

// ReceivedAtCollections get received_at from the server clock on a create
// request. Supabase: `received_at timestamptz not null default now()`
// (20261027120000); PocketBase text fields have no column default (K-5).
var ReceivedAtCollections = []string{"feedback", "analytics_events"}

// Register sets received_at on every record API create of
// [ReceivedAtCollections], replacing whatever the client sent. The hook runs
// after the create rule and before validation.
func Register(app core.App) {
	app.OnRecordCreateRequest(ReceivedAtCollections...).BindFunc(func(e *core.RecordRequestEvent) error {
		e.Record.Set("received_at", pattern.FormatTimestamp(time.Now()))
		return e.Next()
	})
}
