package deletion

import (
	"database/sql"
	"errors"
	"fmt"
	gosync "sync"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/files"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

const (
	// PurgeCronJob is the permanent deletion's job id (Settings → Crons),
	// the name of Supabase's pg_cron job.
	PurgeCronJob = "account-deletion-purge"
	// PurgeCronSchedule is Supabase's '17 * * * *': every hour at :17.
	// PocketBase v0.40.6's app cron ticks in UTC (tools/cron.New() sets
	// time.UTC, nothing calls SetTimezone; see P5.6). Turkey is a whole
	// number of hours off UTC, so :17 is :17 there too.
	PurgeCronSchedule = "17 * * * *"
	// PurgeBatch is how many due requests one run takes (handler.ts
	// purgeBatch); the rest wait for the next hour.
	PurgeBatch = 20
)

// The steps of the permanent deletion. deletion_requests.purge_step holds
// the last one completed; each step commits together with its number, so a
// run that stops halfway resumes after the last committed step. Every step
// is also safe to repeat on its own (it finds nothing left to do).
const (
	// StepOrganizations: the organizations of a hesap_ve_isletme request
	// are gone with every synced row and file record (with its file).
	StepOrganizations = 1
	// StepUserRecords: the user's memberships are soft-deleted and the
	// user is blanked out of created_by and tasks.assigned_to, each row
	// with a new server_seq (the devices pull "deleted user").
	StepUserRecords = 2
	// StepUserFiles: the user's own files (feedback screenshots with the
	// feedback rows), device tokens and deletion code are gone.
	StepUserFiles = 3
	// StepAccount: the users record is deleted.
	StepAccount = 4
	// StepLog: the deletion_log record is written (kept three years).
	StepLog = 5
	// StepCompleted: the request is tamamlandi. The confirmation e-mail
	// follows the commit and is not a step: the address is gone with the
	// account, so an e-mail that fails is not retried.
	StepCompleted = 6
)

// FieldPurgeStep is the request field holding the last completed step.
const FieldPurgeStep = "purge_step"

// errNotDue refuses to purge a request that is cancelled or not yet due.
var errNotDue = errors.New("silme talebi iptal edilmiş ya da silme zamanı gelmemiş")

// PurgeResult is what a run did (handler.ts purge_due's answer).
type PurgeResult struct {
	Completed int `json:"completed"`
	Failed    int `json:"failed"`
}

// purgeMu keeps runs from overlapping: a run that outlasts the hour lets
// the next tick pass instead of working on the same requests.
var purgeMu gosync.Mutex

// registerPurge binds the hourly job and the users delete hook.
func registerPurge(app core.App) {
	registerUserDeleteHook(app)
	app.Cron().MustAdd(PurgeCronJob, PurgeCronSchedule, func() {
		res, err := PurgeDue(app)
		switch {
		case err != nil:
			app.Logger().Error("account-deletion-purge failed", "error", err)
		case res.Completed > 0 || res.Failed > 0:
			app.Logger().Info("account-deletion-purge", "completed", res.Completed, "failed", res.Failed)
		}
	})
}

// PurgeDue is handler.ts purgeDue: the pending requests whose date has
// passed (account_deletion_due: oldest first, at most [PurgeBatch]) are
// deleted one by one. A request that fails stays pending and is taken
// again, from its last completed step, by the next run.
func PurgeDue(app core.App) (PurgeResult, error) {
	var res PurgeResult
	if !purgeMu.TryLock() {
		app.Logger().Warn("account-deletion-purge is still running; skipping this run")
		return res, nil
	}
	defer purgeMu.Unlock()

	var due []string
	err := app.DB().Select("id").From(RequestsCollection).
		Where(dbx.HashExp{"status": StatusPending}).
		AndWhere(dbx.NewExp("[[scheduled_for]] <= {:now}", dbx.Params{"now": pattern.FormatTimestamp(now())})).
		OrderBy("scheduled_for ASC", "id ASC").
		Limit(PurgeBatch).
		Column(&due)
	if err != nil {
		return res, err
	}
	for _, id := range due {
		completed, err := PurgeRequest(app, id)
		switch {
		case err != nil:
			// The request stays pending; the next run resumes it.
			app.Logger().Error("account deletion purge failed", "requestId", id, "error", err)
			res.Failed++
		case completed:
			res.Completed++
		}
	}
	return res, nil
}

// PurgeRequest is handler.ts purgeRequest: the permanent deletion of one
// request, from the step after its purge_step. It reports false for a
// request already completed, and refuses one that is cancelled or not due.
func PurgeRequest(app core.App, requestID string) (bool, error) {
	r, err := start(app, requestID)
	if err != nil || r == nil {
		return false, err
	}
	userID := r.GetString("user_id")

	if err := runStep(app, requestID, StepOrganizations, func(txApp core.App) error {
		return deleteOrganizationRows(txApp, deleteOrgIDs(r))
	}, func() error {
		return deleteOrganizationFiles(app, deleteOrgIDs(r))
	}); err != nil {
		return false, fmt.Errorf("organizations: %w", err)
	}

	if err := runStep(app, requestID, StepUserRecords, func(txApp core.App) error {
		return retireUser(txApp, userID)
	}, nil); err != nil {
		return false, fmt.Errorf("user records: %w", err)
	}

	if err := runStep(app, requestID, StepUserFiles, func(txApp core.App) error {
		return deleteUserRows(txApp, userID)
	}, func() error {
		return deleteUserFiles(app, userID)
	}); err != nil {
		return false, fmt.Errorf("user files: %w", err)
	}

	// The address of the confirmation is read before the account goes. A
	// run resumed after this step has none (handler.ts: the same).
	var recipient *core.Record
	if err := runStep(app, requestID, StepAccount, func(txApp core.App) error {
		if userID == "" {
			return nil
		}
		u, err := txApp.FindRecordById(auth.UsersCollection, userID)
		if errors.Is(err, sql.ErrNoRows) {
			return nil
		}
		if err != nil {
			return err
		}
		if err := txApp.Delete(u); err != nil {
			return err
		}
		recipient = u
		return nil
	}, nil); err != nil {
		return false, fmt.Errorf("account: %w", err)
	}

	if err := runStep(app, requestID, StepLog, func(txApp core.App) error {
		return writeLog(txApp, requestID)
	}, nil); err != nil {
		return false, fmt.Errorf("log: %w", err)
	}

	completed := false
	if err := runStep(app, requestID, StepCompleted, func(txApp core.App) error {
		completed = true
		return nil
	}, nil); err != nil {
		return false, fmt.Errorf("complete: %w", err)
	}

	if recipient != nil && recipient.Email() != "" {
		m := CompletedMail(MailLocale(recipient.GetString("locale")))
		if err := sendMail(app, recipient.Email(), m); err != nil {
			app.Logger().Error("account deletion completion e-mail not sent", "error", err, "requestId", requestID)
		}
	}
	return completed, nil
}

// start checks the request and marks the deletion as started
// (purge_started_at): from then on it cannot be cancelled. nil, nil for a
// completed request.
func start(app core.App, requestID string) (*core.Record, error) {
	var out *core.Record
	err := app.RunInTransaction(func(txApp core.App) error {
		r, err := txApp.FindRecordById(RequestsCollection, requestID)
		if err != nil {
			return err
		}
		if r.GetString("status") == StatusCompleted {
			return nil
		}
		if r.GetString("status") != StatusPending || r.GetString("scheduled_for") > pattern.FormatTimestamp(now()) {
			return errNotDue
		}
		if r.GetString("purge_started_at") == "" {
			r.Set("purge_started_at", pattern.FormatTimestamp(now()))
			if err := txApp.Save(r); err != nil {
				return err
			}
		}
		out = r
		return nil
	})
	return out, err
}

// runStep runs one step unless the request has passed it: first outside
// (files, which no transaction can roll back; it must be safe to repeat),
// then inside a transaction that also records the step. The request is read
// again inside, so the step sees what the earlier steps wrote (the users
// hook empties user_id).
func runStep(app core.App, requestID string, step int, inTx func(txApp core.App) error, outside func() error) error {
	r, err := app.FindRecordById(RequestsCollection, requestID)
	if err != nil {
		return err
	}
	if r.GetInt(FieldPurgeStep) >= step {
		return nil
	}
	if outside != nil {
		if err := outside(); err != nil {
			return err
		}
	}
	return app.RunInTransaction(func(txApp core.App) error {
		if err := inTx(txApp); err != nil {
			return err
		}
		r, err := txApp.FindRecordById(RequestsCollection, requestID)
		if err != nil {
			return err
		}
		r.Set(FieldPurgeStep, step)
		if step == StepCompleted {
			r.Set("status", StatusCompleted)
			r.Set("completed_at", pattern.FormatTimestamp(now()))
		}
		return txApp.Save(r)
	})
}

// orgRowCollections are the collections outside sync that hang on an
// organization (Supabase: org_id … references organizations on delete
// cascade). deletion_requests.org_id has no such reference and stays.
var orgRowCollections = []string{"invites", "feedback"}

// deleteOrganizationRows is the cascade of `delete from organizations`
// (account_deletion_purge_records): every synced row of the organizations,
// the organizations themselves and their invites and feedback, for good.
// No server_seq: the rows are gone, as in Supabase. Plain SQL, no record
// hooks: none of these collections has a delete hook or a file field.
func deleteOrganizationRows(txApp core.App, orgIDs []string) error {
	if len(orgIDs) == 0 {
		return nil
	}
	in := anys(orgIDs)
	for _, name := range append(appsync.Names(), orgRowCollections...) {
		c, err := txApp.FindCachedCollectionByNameOrId(name)
		if err != nil {
			return err
		}
		var where dbx.Expression
		switch {
		case name == "organizations":
			where = dbx.In("id", in...)
		case c.Fields.GetByName("org_id") != nil:
			where = dbx.In("org_id", in...)
		default:
			continue // reference tables belong to no organization
		}
		if _, err := txApp.DB().Delete(name, where).Execute(); err != nil {
			return fmt.Errorf("%s: %w", name, err)
		}
	}
	return nil
}

// deleteOrganizationFiles removes the file records of the organizations in
// every file collection (public_lot_files carries the lot's organization),
// each file before its record.
func deleteOrganizationFiles(app core.App, orgIDs []string) error {
	if len(orgIDs) == 0 {
		return nil
	}
	for _, name := range files.Names() {
		if err := deleteFileRecords(app, name, dbx.In(files.FieldOrgID, anys(orgIDs)...)); err != nil {
			return err
		}
	}
	return nil
}

// deleteUserFiles removes the screenshots of the user's feedback, which may
// be in organizations that stay (the feedback file's id is the feedback's).
// Supabase listed them as storage prefixes on the first run because the
// feedback rows went in the same step; here the rows go only after their
// files (step 3's transaction), so they can be found again on a retry.
func deleteUserFiles(app core.App, userID string) error {
	if userID == "" {
		return nil
	}
	var feedbackIDs []string
	err := app.DB().Select("id").From("feedback").
		Where(dbx.HashExp{"created_by": userID}).
		Column(&feedbackIDs)
	if err != nil || len(feedbackIDs) == 0 {
		return err
	}
	return deleteFileRecords(app, "feedback_files", dbx.In("id", anys(feedbackIDs)...))
}

// fileBatch is how many file records are read at a time.
const fileBatch = 200

// deleteFileRecords deletes the matching records of a file collection.
// Each record's file goes first and synchronously: PocketBase removes a
// deleted record's files only afterwards, in the background, logging a
// failure. A file that cannot be removed fails the step (handler.ts:
// "storage: objects not removed"), and the record stays to find it again.
func deleteFileRecords(app core.App, collection string, where dbx.Expression) error {
	fsys, err := app.NewFilesystem()
	if err != nil {
		return err
	}
	defer fsys.Close()
	for {
		batch := []*core.Record{}
		err := app.RecordQuery(collection).AndWhere(where).Limit(fileBatch).All(&batch)
		if err != nil {
			return err
		}
		if len(batch) == 0 {
			return nil
		}
		for _, r := range batch {
			if failed := fsys.DeletePrefix(r.BaseFilesPath() + "/"); len(failed) > 0 {
				return fmt.Errorf("%s %s: file not removed: %w", collection, r.Id, errors.Join(failed...))
			}
			if err := app.Delete(r); err != nil {
				return fmt.Errorf("%s %s: %w", collection, r.Id, err)
			}
		}
	}
}

// deleteUserRows is the rest of account_deletion_purge_records for the
// user: the feedback rows (their screenshots went first), the device tokens
// and the deletion code.
func deleteUserRows(txApp core.App, userID string) error {
	if userID == "" {
		return nil
	}
	for _, del := range []struct {
		collection, field string
	}{
		{"feedback", "created_by"},
		{"device_tokens", "user_id"},
		{"deletion_codes", "user_id"},
	} {
		if _, err := txApp.DB().Delete(del.collection, dbx.HashExp{del.field: userID}).Execute(); err != nil {
			return fmt.Errorf("%s: %w", del.collection, err)
		}
	}
	return nil
}

// writeLog writes the deletion_log record once (on conflict do nothing):
// date (created), kind, channel and the user id's digest; no name, no
// e-mail.
func writeLog(txApp core.App, requestID string) error {
	var n int
	err := txApp.DB().Select("count(*)").From(LogCollection).
		Where(dbx.HashExp{"request_id": requestID}).
		Row(&n)
	if err != nil || n > 0 {
		return err
	}
	r, err := txApp.FindRecordById(RequestsCollection, requestID)
	if err != nil {
		return err
	}
	logs, err := txApp.FindCachedCollectionByNameOrId(LogCollection)
	if err != nil {
		return err
	}
	l := core.NewRecord(logs)
	l.Id = ids.New()
	l.Set("request_id", r.Id)
	l.Set("user_hash", r.GetString("user_hash"))
	l.Set("kind", r.GetString("kind"))
	l.Set("channel", r.GetString("channel"))
	l.Set("requested_at", r.GetString("requested_at"))
	return txApp.Save(l)
}
