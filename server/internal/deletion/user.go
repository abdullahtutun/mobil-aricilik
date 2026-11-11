package deletion

import (
	"fmt"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

// userBatch is how many rows are read at a time when blanking a user out.
const userBatch = 500

// registerUserDeleteHook makes deleting a users record, by any path (the
// purge, the dashboard, the API of a superuser), do what Supabase's
// foreign keys to auth.users and the retire_deleted_user_memberships
// trigger did, in the delete's transaction:
//   - step 2 of the purge ([retireUser]);
//   - on delete cascade: device_tokens, deletion_codes and the invites the
//     user made;
//   - on delete set null: feedback.created_by and deletion_requests.user_id
//     (the request keeps only the digest).
//
// invites.used_by stays: Supabase's set null there would have broken
// invites_check (used_at and used_by together), and an invite once used is
// never used again.
func registerUserDeleteHook(app core.App) {
	app.OnRecordDelete(auth.UsersCollection).BindFunc(func(e *core.RecordEvent) error {
		original := e.App
		defer func() { e.App = original }()
		return original.RunInTransaction(func(txApp core.App) error {
			if err := forgetUser(txApp, e.Record.Id); err != nil {
				return err
			}
			e.App = txApp
			return e.Next()
		})
	})
}

func forgetUser(txApp core.App, userID string) error {
	if err := retireUser(txApp, userID); err != nil {
		return err
	}
	for _, del := range []struct{ collection, field string }{
		{"device_tokens", "user_id"},
		{"deletion_codes", "user_id"},
		{"invites", "created_by"},
	} {
		if _, err := txApp.DB().Delete(del.collection, dbx.HashExp{del.field: userID}).Execute(); err != nil {
			return fmt.Errorf("%s: %w", del.collection, err)
		}
	}
	for _, set := range []struct{ collection, field string }{
		{"feedback", "created_by"},
		{RequestsCollection, "user_id"},
	} {
		_, err := txApp.DB().Update(set.collection, dbx.Params{set.field: ""}, dbx.HashExp{set.field: userID}).Execute()
		if err != nil {
			return fmt.Errorf("%s: %w", set.collection, err)
		}
	}
	return nil
}

// retireUser is step 2 of the purge and retire_deleted_user_memberships
// (20261116120000) with the set null of created_by and tasks.assigned_to:
//   - the user's live memberships get deleted_at and a later updated_at;
//   - every synced row the user created loses created_by ("deleted
//     user"), every task assigned to the user loses assigned_to.
//
// Each row is saved as a record, so the seq hook gives it a new server_seq
// and the devices pull it. updated_at stays, as with Supabase's foreign
// key: the devices take a pulled row as it is. Saved without validation:
// an old row must not block the deletion of an account.
func retireUser(txApp core.App, userID string) error {
	if userID == "" {
		return nil
	}
	stamp := pattern.FormatTimestamp(now())
	err := eachBatch(txApp, "memberships", dbx.HashExp{"user_id": userID, "deleted_at": ""}, func(m *core.Record) {
		m.Set("deleted_at", stamp)
		m.Set("updated_at", later(m.GetString("updated_at"), stamp))
	})
	if err != nil {
		return err
	}
	for _, name := range appsync.Names() {
		c, err := txApp.FindCachedCollectionByNameOrId(name)
		if err != nil {
			return err
		}
		if c.Fields.GetByName("created_by") == nil {
			continue
		}
		err = eachBatch(txApp, name, dbx.HashExp{"created_by": userID}, func(r *core.Record) {
			r.Set("created_by", "")
		})
		if err != nil {
			return err
		}
	}
	return eachBatch(txApp, "tasks", dbx.HashExp{"assigned_to": userID}, func(r *core.Record) {
		r.Set("assigned_to", "")
	})
}

// eachBatch changes and saves every record matching where; the change must
// make the record stop matching, or the loop would not end.
func eachBatch(txApp core.App, collection string, where dbx.Expression, change func(*core.Record)) error {
	for {
		batch := []*core.Record{}
		if err := txApp.RecordQuery(collection).AndWhere(where).Limit(userBatch).All(&batch); err != nil {
			return fmt.Errorf("%s: %w", collection, err)
		}
		if len(batch) == 0 {
			return nil
		}
		for _, r := range batch {
			change(r)
			if err := txApp.SaveNoValidate(r); err != nil {
				return fmt.Errorf("%s %s: %w", collection, r.Id, err)
			}
		}
	}
}
