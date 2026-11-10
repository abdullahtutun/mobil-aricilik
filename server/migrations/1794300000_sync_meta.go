package migrations

import (
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
	"github.com/pocketbase/pocketbase/tools/types"
)

// sync_meta: the single counter row behind server_seq (K-7). Counterpart of
// Supabase's `private.sync_seq` sequence (20261021200110).
func init() {
	m.Register(upSyncMeta, downSyncMeta)
}

func upSyncMeta(app core.App) error {
	c := core.NewBaseCollection(appsync.MetaCollection)
	useUUIDPrimaryKey(c)
	c.Fields.Add(&core.NumberField{
		Name:    appsync.FieldLastSeq,
		OnlyInt: true,
		Min:     types.Pointer(0.0),
	})
	if err := app.Save(c); err != nil {
		return err
	}

	row := core.NewRecord(c)
	row.Id = appsync.MetaID
	row.Set(appsync.FieldLastSeq, 0)
	return app.Save(row)
}

func downSyncMeta(app core.App) error {
	c, err := app.FindCollectionByNameOrId(appsync.MetaCollection)
	if err != nil {
		return err
	}
	return app.Delete(c)
}
