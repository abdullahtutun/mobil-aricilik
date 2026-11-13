package deletion

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/validate"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// registerRequestHooks binds, for every writer of deletion_requests:
//   - the table's CHECKs (deletion_requests_check … _check3 and the uuid[]
//     type of delete_org_ids), which PocketBase fields cannot express;
//   - sync_member_deletion_schedule (20261115120000): when a request is
//     written or its status changes, the user's live memberships get
//     deletion_scheduled_for (the date while pending, empty otherwise) and a
//     later updated_at, so the mark reaches the devices by sync (the seq
//     hook numbers the membership). It runs in the request's transaction.
func registerRequestHooks(app core.App) {
	app.OnRecordCreate(RequestsCollection).BindFunc(func(e *core.RecordEvent) error {
		if err := checkRequest(e.Record); err != nil {
			return err
		}
		if err := e.Next(); err != nil {
			return err
		}
		return markMemberships(e.App, e.Record)
	})
	app.OnRecordUpdate(RequestsCollection).BindFunc(func(e *core.RecordEvent) error {
		if err := checkRequest(e.Record); err != nil {
			return err
		}
		changed := e.Record.Original().GetString("status") != e.Record.GetString("status")
		if err := e.Next(); err != nil {
			return err
		}
		if !changed {
			return nil
		}
		return markMemberships(e.App, e.Record)
	})
}

func checkRequest(r *core.Record) error {
	for _, err := range []error{
		validate.DeletionRequestsCheck(r.GetString("requested_at"), r.GetString("scheduled_for")),
		validate.DeletionRequestsCheck1(r.GetString("status"), r.GetString("cancelled_at")),
		validate.DeletionRequestsCheck2(r.GetString("status"), r.GetString("completed_at")),
		validate.DeletionRequestsDeleteOrgIdsCheck(jsonRaw(r, "delete_org_ids")),
		validate.DeletionRequestsCheck3(r.GetString("kind"), jsonRaw(r, "delete_org_ids")),
	} {
		if err != nil {
			return err
		}
	}
	return nil
}

// jsonRaw is a JSON field's stored value.
func jsonRaw(r *core.Record, field string) types.JSONRaw {
	raw, _ := r.Get(field).(types.JSONRaw)
	return raw
}

// markMemberships writes the request's date on the user's live memberships
// that do not have it yet.
func markMemberships(txApp core.App, r *core.Record) error {
	userID := r.GetString("user_id")
	if userID == "" {
		return nil
	}
	scheduled := ""
	if r.GetString("status") == StatusPending {
		scheduled = r.GetString("scheduled_for")
	}
	members, err := txApp.FindAllRecords("memberships",
		dbx.HashExp{"user_id": userID, "deleted_at": ""},
		dbx.Not(dbx.HashExp{"deletion_scheduled_for": scheduled}),
	)
	if err != nil {
		return err
	}
	stamp := pattern.FormatTimestamp(now())
	for _, m := range members {
		m.Set("deletion_scheduled_for", scheduled)
		m.Set("updated_at", later(m.GetString("updated_at"), stamp))
		if err := txApp.Save(m); err != nil {
			return err
		}
	}
	return nil
}
