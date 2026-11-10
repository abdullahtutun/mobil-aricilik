// Package ids fills missing record ids with UUIDv7 (K-4).
package ids

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/google/uuid"
	"github.com/pocketbase/pocketbase/core"
)

// New returns a new lower-case UUIDv7.
func New() string {
	return uuid.Must(uuid.NewV7()).String()
}

// Register gives a new record of any collection whose id field uses the UUID
// pattern a UUIDv7 id when it has none. Runs before validation; a client
// supplied id is kept. PocketBase's own collections (_superusers, ...) keep
// their default ids.
func Register(app core.App) {
	app.OnRecordCreate().BindFunc(func(e *core.RecordEvent) error {
		if e.Record.Id == "" && usesUUID(e.Record.Collection()) {
			e.Record.Id = New()
		}
		return e.Next()
	})
}

func usesUUID(c *core.Collection) bool {
	id, ok := c.Fields.GetByName("id").(*core.TextField)
	return ok && id.Pattern == pattern.UUID
}
