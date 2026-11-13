package seed

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/actor"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	"github.com/pocketbase/pocketbase/core"
)

// DemoOptions are the flags of `seed demo`.
type DemoOptions struct {
	// DryRun counts the rows and writes nothing.
	DryRun bool
	// Date is the reference day (YYYY-MM-DD); empty is now.
	Date string
	// ForceReset deletes the demo organization (and only it) first.
	ForceReset bool
	// Now is the clock; nil is time.Now.
	Now func() time.Time
}

// TableCount is how many rows one table gets.
type TableCount struct {
	Table string
	Rows  int
}

// DemoReport is what `seed demo` did, or would do with DryRun.
type DemoReport struct {
	DryRun bool
	// OrgExisted: the demo organization was there before the run.
	OrgExisted bool
	// Reset: the existing organization was (or would be) deleted first.
	Reset bool
	// Counts are the rows written per table, in writing order; all 0 when
	// the organization existed and was not reset.
	Counts []TableCount
}

// Total is the number of rows written.
func (r DemoReport) Total() int {
	total := 0
	for _, c := range r.Counts {
		total += c.Rows
	}
	return total
}

// String is the report the command prints.
func (r DemoReport) String() string {
	var b strings.Builder
	switch {
	case r.DryRun && r.Reset:
		b.WriteString("Dry run: the demo organization exists and would be deleted, then written again.\n")
	case r.DryRun && r.OrgExisted:
		b.WriteString("Dry run: the demo organization exists; nothing would be written.\n")
	case r.DryRun:
		b.WriteString("Dry run: nothing written.\n")
	case r.Reset:
		b.WriteString("The demo organization was deleted and written again.\n")
	case r.OrgExisted:
		b.WriteString("The demo organization exists; nothing written.\n")
	default:
		b.WriteString("The demo organization was written.\n")
	}
	for _, c := range r.Counts {
		fmt.Fprintf(&b, "  %-22s %4d\n", c.Table, c.Rows)
	}
	fmt.Fprintf(&b, "  %-22s %4d\n", "total", r.Total())
	return b.String()
}

// FindDemoUser returns the demo account, [ErrNoDemoUser] when it is not
// there.
func FindDemoUser(app core.App) (*core.Record, error) {
	u, err := app.FindAuthRecordByEmail(auth.UsersCollection, auth.DemoEmail)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, ErrNoDemoUser
	}
	return u, err
}

// Demo is `seed demo`: demo_account.sql on PocketBase. It writes the demo
// organization of the demo account with fixed ids, through the record hooks
// (UUID, server_seq, field validation) and push's CHECKs and reference
// checks, all in one transaction. When the organization exists it writes
// nothing (the SQL's "Demo işletme zaten var"), unless ForceReset deletes it
// first.
func Demo(app core.App, opts DemoOptions) (DemoReport, error) {
	report := DemoReport{DryRun: opts.DryRun}
	user, err := FindDemoUser(app)
	if err != nil {
		return report, err
	}
	clock := opts.Now
	if clock == nil {
		clock = time.Now
	}
	now := clock()
	nowTS, err := demoClock(now, opts.Date)
	if err != nil {
		return report, err
	}
	drug, err := loadRefDrug(app, bayvarolID)
	if err != nil {
		return report, err
	}
	rows := demoRows(user.Id, nowTS, pattern.FormatTimestamp(now), drug)

	_, err = app.FindRecordById("organizations", DemoOrgID)
	switch {
	case err == nil:
		report.OrgExisted = true
	case !errors.Is(err, sql.ErrNoRows):
		return report, err
	}
	report.Reset = report.OrgExisted && opts.ForceReset
	if report.OrgExisted && !opts.ForceReset {
		report.Counts = countRows(rows, true)
		return report, nil
	}
	report.Counts = countRows(rows, false)
	if opts.DryRun {
		return report, nil
	}

	if report.Reset {
		if err := deletion.DeleteOrganization(app, DemoOrgID); err != nil {
			return report, fmt.Errorf("delete the demo organization: %w", err)
		}
	}
	err = app.RunInTransaction(func(txApp core.App) error {
		return writeRows(txApp, user.Id, rows)
	})
	if err != nil {
		return report, err
	}
	return report, nil
}

// writeRows saves the rows in order. The demo user is the actor, as if it
// had pushed them (no task notification to oneself).
func writeRows(txApp core.App, userID string, rows []row) error {
	ctx := actor.With(context.Background(), userID)
	for _, r := range rows {
		c, err := txApp.FindCachedCollectionByNameOrId(r.table)
		if err != nil {
			return err
		}
		rec := core.NewRecord(c)
		rec.Id = r.id
		for name, v := range r.values {
			if c.Fields.GetByName(name) == nil {
				return fmt.Errorf("%s has no field %q", r.table, name)
			}
			rec.Set(name, v)
		}
		if err := appsync.CheckNewRow(txApp, r.table, rec); err != nil {
			return fmt.Errorf("%s %s: %w", r.table, r.id, err)
		}
		if err := txApp.SaveWithContext(ctx, rec); err != nil {
			return fmt.Errorf("%s %s: %w", r.table, r.id, err)
		}
	}
	return nil
}

// countRows counts rows per table, in the order the tables first appear;
// zero leaves every count at 0.
func countRows(rows []row, zero bool) []TableCount {
	var out []TableCount
	index := map[string]int{}
	for _, r := range rows {
		i, ok := index[r.table]
		if !ok {
			i = len(out)
			index[r.table] = i
			out = append(out, TableCount{Table: r.table})
		}
		if !zero {
			out[i].Rows++
		}
	}
	return out
}
