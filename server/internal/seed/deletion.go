package seed

import (
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// ErrNotDev refuses the dev-only tools outside APP_ENV=dev.
var ErrNotDev = errors.New("this command runs only with APP_ENV=dev")

// ErrNoPendingDeletion: the user has no pending deletion request, or its
// permanent deletion has already started.
var ErrNoPendingDeletion = errors.New("no pending deletion request (or its purge has started)")

// ExpireDeletion is `seed deletion expire` (P9.2): it moves the user's
// pending deletion request into the past, so that the next run of
// account-deletion-purge (Settings → Crons, run by hand) deletes the account
// without waiting seven days. requested_at moves too, keeping
// scheduled_for > requested_at and the 7-day gap. Only on dev ([ErrNotDev]
// otherwise, before anything is read). The memberships keep the old date in
// deletion_scheduled_for; the purge removes them anyway. It returns the new
// scheduled_for.
func ExpireDeletion(app core.App, env, email string, now time.Time) (string, error) {
	if env != config.EnvDev {
		return "", ErrNotDev
	}
	email = strings.TrimSpace(email)
	if email == "" {
		return "", errors.New("--user is required")
	}
	user, err := app.FindAuthRecordByEmail(auth.UsersCollection, email)
	if errors.Is(err, sql.ErrNoRows) {
		return "", fmt.Errorf("no user %s", email)
	}
	if err != nil {
		return "", err
	}

	scheduled := ""
	err = app.RunInTransaction(func(txApp core.App) error {
		r := &core.Record{}
		err := txApp.RecordQuery(deletion.RequestsCollection).
			AndWhere(dbx.HashExp{"user_id": user.Id, "status": deletion.StatusPending}).
			Limit(1).
			One(r)
		if errors.Is(err, sql.ErrNoRows) {
			return ErrNoPendingDeletion
		}
		if err != nil {
			return err
		}
		if r.GetString("purge_started_at") != "" {
			return ErrNoPendingDeletion
		}
		due := now.Add(-time.Minute)
		scheduled = pattern.FormatTimestamp(due)
		r.Set("requested_at", pattern.FormatTimestamp(due.Add(-deletion.GracePeriod)))
		r.Set("scheduled_for", scheduled)
		return txApp.Save(r)
	})
	if err != nil {
		return "", err
	}
	return scheduled, nil
}
