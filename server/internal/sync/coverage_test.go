package sync_test

import (
	"slices"
	"testing"

	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
)

// TestSeqCoverage is the counterpart of Supabase's sync_seq.test.sql (every
// synced table has server_seq and the set_server_seq trigger) and the
// server_seq part of rls_enabled.test.sql: every collection in [Tables]
// has a server_seq field and the seq hook on create and update; no other
// collection, system ones included, has the field or gets a number.
func TestSeqCoverage(t *testing.T) {
	app := newApp(t)

	all, err := app.FindAllCollections()
	if err != nil {
		t.Fatal(err)
	}
	byName := map[string]*core.Collection{}
	for _, c := range all {
		byName[c.Name] = c
	}

	for _, name := range appsync.Names() {
		c, ok := byName[name]
		if !ok {
			t.Errorf("%s: in the registry but no such collection", name)
			continue
		}
		f, ok := c.Fields.GetByName(appsync.FieldServerSeq).(*core.NumberField)
		if !ok || !f.Required || !f.OnlyInt {
			t.Errorf("%s: server_seq = %#v, want a required integer number field", name, c.Fields.GetByName(appsync.FieldServerSeq))
		}
		if c.GetIndex("idx_"+name+"_server_seq") == "" {
			t.Errorf("%s: no unique server_seq index", name)
		}
	}

	for _, c := range all {
		if slices.Contains(appsync.Names(), c.Name) {
			continue
		}
		if c.Fields.GetByName(appsync.FieldServerSeq) != nil {
			t.Errorf("%s: has server_seq but is not in the registry", c.Name)
		}
	}

	// The hook: run each collection's create and update hook chains on an
	// empty record (no row is written; the final handler stands in for the
	// save) and see whether a number is handed out.
	hooks := map[string]func(*core.RecordEvent, func(*core.RecordEvent) error) error{
		"create": func(e *core.RecordEvent, fn func(*core.RecordEvent) error) error {
			return app.OnRecordCreate().Trigger(e, fn)
		},
		"update": func(e *core.RecordEvent, fn func(*core.RecordEvent) error) error {
			return app.OnRecordUpdate().Trigger(e, fn)
		},
	}
	for _, c := range all {
		synced := slices.Contains(appsync.Names(), c.Name)
		for op, trigger := range hooks {
			before := lastSeq(t, app)
			var got any
			e := &core.RecordEvent{Record: core.NewRecord(c)}
			e.App = app
			if err := trigger(e, func(e *core.RecordEvent) error {
				got = e.Record.Get(appsync.FieldServerSeq)
				return nil
			}); err != nil {
				t.Errorf("%s %s: %v", c.Name, op, err)
				continue
			}
			after := lastSeq(t, app)

			if synced {
				if after != before+1 || got == nil || int64(e.Record.GetInt(appsync.FieldServerSeq)) != after {
					t.Errorf("%s %s: server_seq = %v, counter %d → %d; want the next number", c.Name, op, got, before, after)
				}
			} else if after != before || got != nil {
				t.Errorf("%s %s: not synced but server_seq = %v, counter %d → %d", c.Name, op, got, before, after)
			}
		}
	}
}
