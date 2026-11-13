package migrations

import (
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

func TestDeletionPurgeStepField(t *testing.T) {
	app := newApp(t)
	c, err := app.FindCollectionByNameOrId("deletion_requests")
	if err != nil {
		t.Fatal(err)
	}
	f, ok := c.Fields.GetByName(purgeStepField).(*core.NumberField)
	if !ok {
		t.Fatalf("%s is not a number field", purgeStepField)
	}
	if !f.OnlyInt || f.Required || f.Min == nil || *f.Min != 0 || f.Max == nil || *f.Max != 6 {
		t.Fatalf("%s = %+v, want an optional integer 0..6", purgeStepField, f)
	}

	if err := downDeletionPurgeStep(app); err != nil {
		t.Fatal(err)
	}
	c, err = app.FindCollectionByNameOrId("deletion_requests")
	if err != nil {
		t.Fatal(err)
	}
	if c.Fields.GetByName(purgeStepField) != nil {
		t.Fatal("down kept the field")
	}
	if c.Fields.GetByName("purge_started_at") == nil {
		t.Fatal("down removed another field")
	}
	if err := upDeletionPurgeStep(app); err != nil {
		t.Fatalf("up after down: %v", err)
	}
}
