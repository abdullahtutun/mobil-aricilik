package migrations

import (
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
	m "github.com/pocketbase/pocketbase/migrations"
)

// purgeStepField is deletion_requests.purge_step (P5.9): the last step of
// the permanent deletion that has completed, 0 before the first. Supabase
// had no such column: its steps found their own progress (storage objects
// left, auth user present). Here each step is committed together with this
// number, so an interrupted deletion resumes after the last committed step
// (internal/deletion, purge.go). Not Required: 0 is valid.
const purgeStepField = "purge_step"

func init() {
	m.Register(upDeletionPurgeStep, downDeletionPurgeStep)
}

func upDeletionPurgeStep(app core.App) error {
	c, err := app.FindCollectionByNameOrId("deletion_requests")
	if err != nil {
		return err
	}
	c.Fields.Add(&core.NumberField{
		Name:    purgeStepField,
		OnlyInt: true,
		Min:     types.Pointer(0.0),
		Max:     types.Pointer(6.0),
	})
	return app.Save(c)
}

func downDeletionPurgeStep(app core.App) error {
	c, err := app.FindCollectionByNameOrId("deletion_requests")
	if err != nil {
		return err
	}
	c.Fields.RemoveByName(purgeStepField)
	return app.Save(c)
}
