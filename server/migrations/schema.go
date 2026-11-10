package migrations

import (
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tools/types"
)

// Common column names of the sync collections ("P2 Şema" ortak kalıbı).
const (
	fieldOrgID     = "org_id"
	fieldCreatedAt = "created_at"
	fieldUpdatedAt = "updated_at"
	fieldCreatedBy = "created_by"
	fieldDeletedAt = "deleted_at"
	fieldServerSeq = "server_seq"
)

// syncedCollection is a sync collection whose rows belong to one
// organization: [syncedCollectionWithoutOrg] plus a required `org_id` and the
// `(org_id, server_seq)` index the pull query reads.
func syncedCollection(name string, fields ...core.Field) *core.Collection {
	all := append([]core.Field{uuidField(fieldOrgID, true)}, fields...)
	c := syncedCollectionWithoutOrg(name, all...)
	c.AddIndex("idx_"+name+"_org_id_server_seq", false, "`org_id`, `server_seq`", "")
	return c
}

// syncedCollectionWithoutOrg is a sync collection without `org_id`:
// organizations (the row is the organization) and reference tables.
//
// Fields: UUID id (K-4), created_at/updated_at (required, K-5), created_by
// (optional UUID), deleted_at (optional, K-5), server_seq (required integer,
// set by internal/sync, never by the client), then the given fields. Index on
// server_seq. All API rules are nil: only server code reads and writes (K-7).
// No PocketBase `created`/`updated` autodate fields (K-5).
func syncedCollectionWithoutOrg(name string, fields ...core.Field) *core.Collection {
	c := core.NewBaseCollection(name)
	useUUIDPrimaryKey(c)

	common := []core.Field{
		timeField(fieldCreatedAt, true),
		timeField(fieldUpdatedAt, true),
		uuidField(fieldCreatedBy, false),
		timeField(fieldDeletedAt, false),
		&core.NumberField{
			Name:     fieldServerSeq,
			Required: true,
			OnlyInt:  true,
			Min:      types.Pointer(1.0),
		},
	}
	// Collection-specific fields first, like the Supabase column order.
	c.Fields.Add(fields...)
	c.Fields.Add(common...)

	// Unique: every write takes a new number from one counter.
	c.AddIndex("idx_"+name+"_server_seq", true, "`server_seq`", "")
	return c
}

// useUUIDPrimaryKey makes the id field accept the client's UUIDs (K-4).
// The autogenerate pattern stays empty: internal/ids fills a missing id with
// a UUIDv7 before validation, so a record saved without that hook fails
// loudly instead of getting a random non-v7 id.
func useUUIDPrimaryKey(c *core.Collection) {
	id := c.Fields.GetByName("id").(*core.TextField)
	id.Pattern = pattern.UUID
	id.Min = pattern.UUIDLength
	id.Max = pattern.UUIDLength
	id.AutogeneratePattern = ""
}

// uuidField is a text column holding another record's id. Not a relation:
// rows arrive out of order and a relation rejects a link to a deleted row;
// same-organization checks happen on push (P5.3).
func uuidField(name string, required bool) *core.TextField {
	return &core.TextField{
		Name:     name,
		Required: required,
		Min:      pattern.UUIDLength,
		Max:      pattern.UUIDLength,
		Pattern:  pattern.UUID,
	}
}

// timeField is a sync time stored as fixed-width UTC text (K-5).
func timeField(name string, required bool) *core.TextField {
	return &core.TextField{
		Name:     name,
		Required: required,
		Min:      pattern.TimestampLength,
		Max:      pattern.TimestampLength,
		Pattern:  pattern.Timestamp,
	}
}

// selectField mirrors a Postgres enum: one value out of values, which must be
// the enum's labels verbatim. An optional enum is required == false.
func selectField(name string, required bool, values ...string) *core.SelectField {
	return &core.SelectField{
		Name:      name,
		Required:  required,
		MaxSelect: 1,
		Values:    values,
	}
}

// nullableNumberField holds a number column that may be null in Supabase.
// A PocketBase number field is NOT NULL DEFAULT 0 and cannot tell "not
// entered" from 0, so the value is JSON: null or a number (decision
// 2026-11-10). Range and integer checks live in internal/validate.
func nullableNumberField(name string) *core.JSONField {
	return &core.JSONField{
		Name: name,
		// Room for any float64 literal; rejects arrays and objects early.
		MaxSize: 32,
	}
}
