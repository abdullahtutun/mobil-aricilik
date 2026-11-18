package migrations

import (
	"slices"

	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

// documents.type gains `insurance` (2026-11-18): a preset document type
// offered in every region, next to the other region-independent presets
// (business registration, land permit, analysis report, health report).
const documentTypeInsurance = "insurance"

func init() {
	m.Register(upDocumentTypeInsurance, downDocumentTypeInsurance)
}

func upDocumentTypeInsurance(app core.App) error {
	c, f, err := documentTypeField(app)
	if err != nil || f == nil {
		return err
	}
	if slices.Contains(f.Values, documentTypeInsurance) {
		return nil
	}
	// Before custom, in the Dart enum's order (schema_mirror_test.dart).
	at := slices.Index(f.Values, "custom")
	if at < 0 {
		at = len(f.Values)
	}
	f.Values = slices.Insert(f.Values, at, documentTypeInsurance)
	return app.Save(c)
}

// downDocumentTypeInsurance turns insurance documents into custom ones
// named "Insurance" before removing the value, so no row is left with a
// value the field no longer allows.
func downDocumentTypeInsurance(app core.App) error {
	c, f, err := documentTypeField(app)
	if err != nil || f == nil {
		return err
	}
	if _, err := app.DB().NewQuery(
		"UPDATE documents SET type = 'custom', custom_type_name = 'Insurance' WHERE type = {:type}",
	).Bind(dbx.Params{"type": documentTypeInsurance}).Execute(); err != nil {
		return err
	}
	f.Values = slices.DeleteFunc(f.Values, func(v string) bool { return v == documentTypeInsurance })
	return app.Save(c)
}

func documentTypeField(app core.App) (*core.Collection, *core.SelectField, error) {
	c, err := app.FindCollectionByNameOrId("documents")
	if err != nil {
		return nil, nil, err
	}
	f, _ := c.Fields.GetByName("type").(*core.SelectField)
	return c, f, nil
}
