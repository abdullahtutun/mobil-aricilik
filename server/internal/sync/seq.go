package sync

import (
	"fmt"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

const (
	// MetaCollection holds the single counter row (migration 1794300000).
	MetaCollection = "sync_meta"
	// MetaID is the id of that row.
	MetaID = "00000000-0000-0000-0000-000000000001"
	// FieldLastSeq is the last number handed out.
	FieldLastSeq = "last_seq"
	// FieldServerSeq is the pull cursor column of every synced collection.
	FieldServerSeq = "server_seq"
)

// RegisterSeq gives every insert and update of a synced collection ([Tables])
// a new server_seq, the counterpart of Supabase's set_server_seq trigger.
//
// The hook runs at model level (app.Save, not only API requests) and opens a
// transaction around the counter bump, validation and the row write, or joins
// the caller's. SQLite has one writer, so numbers are taken in commit order
// and a pull cursor never skips a row that commits later (K-7). A failed save
// rolls the counter back with it. The client's server_seq is overwritten.
func RegisterSeq(app core.App) {
	names := Names()
	if len(names) == 0 {
		// Binding without tags would match every collection.
		return
	}
	app.OnRecordCreate(names...).BindFunc(assignSeq)
	app.OnRecordUpdate(names...).BindFunc(assignSeq)
}

func assignSeq(e *core.RecordEvent) error {
	original := e.App
	defer func() { e.App = original }()

	return original.RunInTransaction(func(txApp core.App) error {
		seq, err := NextSeq(txApp)
		if err != nil {
			return err
		}
		e.Record.Set(FieldServerSeq, seq)
		// The rest of the chain (validation, insert/update) uses txApp.
		e.App = txApp
		return e.Next()
	})
}

// NextSeq increments the counter and returns the new value. Call it inside
// the transaction that writes the row.
func NextSeq(txApp core.App) (int64, error) {
	var seq int64
	err := txApp.NonconcurrentDB().
		NewQuery("UPDATE {{" + MetaCollection + "}} SET [[" + FieldLastSeq + "]] = [[" + FieldLastSeq + "]] + 1 WHERE [[id]] = {:id} RETURNING [[" + FieldLastSeq + "]]").
		Bind(dbx.Params{"id": MetaID}).
		Row(&seq)
	if err != nil {
		return 0, fmt.Errorf("sync: next server_seq: %w", err)
	}
	return seq, nil
}

// LastSeq returns the last number handed out.
func LastSeq(app core.App) (int64, error) {
	var seq int64
	err := app.DB().
		NewQuery("SELECT [[" + FieldLastSeq + "]] FROM {{" + MetaCollection + "}} WHERE [[id]] = {:id}").
		Bind(dbx.Params{"id": MetaID}).
		Row(&seq)
	return seq, err
}
