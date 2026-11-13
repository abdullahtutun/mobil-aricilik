// Package deletion is account deletion (P5.8–P5.9): the user routes of
// supabase/functions/account-delete (code, request, cancel, status; see
// routes.go), the memberships mark of a pending request, the guard of the
// deletion log and (P5.9) the hourly permanent deletion with the users
// delete hook (purge.go, user.go).
package deletion

import (
	"errors"
	"time"

	"github.com/pocketbase/pocketbase/core"
)

// LogCollection keeps one record per completed account deletion: date, kind,
// channel and the user id's digest (KVKK).
const LogCollection = "deletion_log"

// LogRetentionYears is how long a deletion record must be kept.
const LogRetentionYears = 3

var (
	// ErrLogImmutable rejects any change to a deletion record.
	ErrLogImmutable = errors.New("silme kaydı değiştirilemez")
	// ErrLogRetained rejects deleting a record younger than
	// [LogRetentionYears].
	ErrLogRetained = errors.New("silme kaydı üç yıl saklanır")
)

// now is the package clock (the guard, codes and requests); tests replace
// it.
var now = time.Now

// RegisterLogGuard is Supabase's protect_deletion_log trigger
// (20261113120000): a record is never updated, and is deleted only once
// LogRetentionYears have passed since it was created. The hooks are
// model-level, so they hold for every caller: server code, CLI, migrations
// and superusers on the dashboard or the API (API rules do not apply to
// them).
func RegisterLogGuard(app core.App) {
	app.OnRecordUpdate(LogCollection).BindFunc(func(*core.RecordEvent) error {
		return ErrLogImmutable
	})
	app.OnRecordDelete(LogCollection).BindFunc(func(e *core.RecordEvent) error {
		// The stored creation time, not the caller's copy of the record.
		stored, err := e.App.FindRecordById(LogCollection, e.Record.Id)
		if err != nil {
			return err
		}
		created := stored.GetDateTime("created").Time()
		if created.IsZero() || created.After(yearsBefore(now(), LogRetentionYears)) {
			return ErrLogRetained
		}
		return e.Next()
	})
}

// yearsBefore is Postgres' `t - interval 'n years'`: the same day n years
// earlier, Feb 29 becoming Feb 28 (Go's AddDate would roll over to Mar 1).
func yearsBefore(t time.Time, n int) time.Time {
	t = t.UTC()
	year := t.Year() - n
	day := t.Day()
	if last := time.Date(year, t.Month()+1, 0, 0, 0, 0, 0, time.UTC).Day(); day > last {
		day = last
	}
	return time.Date(year, t.Month(), day, t.Hour(), t.Minute(), t.Second(), t.Nanosecond(), time.UTC)
}
