package sync_test

import (
	"errors"
	"fmt"
	stdsync "sync"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/ids"
	appsync "github.com/abdullahtutun/mobil-aricilik/server/internal/sync"
	_ "github.com/abdullahtutun/mobil-aricilik/server/migrations"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/tests"
)

const (
	testOrg  = "0195f2a4-1111-7000-8000-000000000001"
	testTime = "2026-11-10T10:15:30.123456Z"
)

func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	ids.Register(app)
	appsync.RegisterSeq(app)
	return app
}

// membership is a valid memberships row without id and server_seq; userN
// keeps the (org_id, user_id) pair unique.
func membership(t *testing.T, app core.App, userN int) *core.Record {
	t.Helper()
	c, err := app.FindCachedCollectionByNameOrId("memberships")
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Set("org_id", testOrg)
	r.Set("user_id", fmt.Sprintf("0195f2a4-2222-7000-8000-%012d", userN))
	r.Set("role", "worker")
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	return r
}

func organization(t *testing.T, app core.App) *core.Record {
	t.Helper()
	c, err := app.FindCachedCollectionByNameOrId("organizations")
	if err != nil {
		t.Fatal(err)
	}
	r := core.NewRecord(c)
	r.Id = testOrg
	r.Set("name", "Tutun Arıcılık")
	r.Set("country_code", "TR")
	r.Set("currency", "TRY")
	r.Set("operation_type", "migratory")
	r.Set("created_at", testTime)
	r.Set("updated_at", testTime)
	return r
}

func storedSeq(t *testing.T, app core.App, collection, id string) int64 {
	t.Helper()
	r, err := app.FindRecordById(collection, id)
	if err != nil {
		t.Fatal(err)
	}
	return int64(r.GetInt(appsync.FieldServerSeq))
}

func lastSeq(t *testing.T, app core.App) int64 {
	t.Helper()
	n, err := appsync.LastSeq(app)
	if err != nil {
		t.Fatal(err)
	}
	return n
}

func TestSeqIncreasesAcrossCollections(t *testing.T) {
	app := newApp(t)

	org := organization(t, app)
	if err := app.Save(org); err != nil {
		t.Fatal(err)
	}
	var saved []*core.Record
	for i := range 3 {
		r := membership(t, app, i)
		if err := app.Save(r); err != nil {
			t.Fatal(err)
		}
		saved = append(saved, r)
	}

	if got := storedSeq(t, app, "organizations", org.Id); got != 1 {
		t.Errorf("organization seq = %d, want 1", got)
	}
	for i, r := range saved {
		if got, want := storedSeq(t, app, "memberships", r.Id), int64(i+2); got != want {
			t.Errorf("membership %d seq = %d, want %d", i, got, want)
		}
	}
	if got := lastSeq(t, app); got != 4 {
		t.Errorf("last_seq = %d, want 4", got)
	}
}

func TestUpdateTakesNewSeq(t *testing.T) {
	app := newApp(t)
	r := membership(t, app, 1)
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	other := membership(t, app, 2)
	if err := app.Save(other); err != nil {
		t.Fatal(err)
	}

	r.Set("role", "viewer")
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	if got := storedSeq(t, app, "memberships", r.Id); got != 3 {
		t.Errorf("seq after update = %d, want 3", got)
	}

	// Soft delete is an update too: the row travels to other devices.
	r.Set("deleted_at", testTime)
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	if got := storedSeq(t, app, "memberships", r.Id); got != 4 {
		t.Errorf("seq after soft delete = %d, want 4", got)
	}
}

func TestClientSeqIgnored(t *testing.T) {
	app := newApp(t)
	r := membership(t, app, 1)
	r.Set(appsync.FieldServerSeq, 999)
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	if got := storedSeq(t, app, "memberships", r.Id); got != 1 {
		t.Errorf("seq = %d, want 1 (client value ignored)", got)
	}

	r.Set("role", "partner")
	r.Set(appsync.FieldServerSeq, 1) // tries to keep the old number
	if err := app.Save(r); err != nil {
		t.Fatal(err)
	}
	if got := storedSeq(t, app, "memberships", r.Id); got != 2 {
		t.Errorf("seq after update = %d, want 2", got)
	}
	if got := lastSeq(t, app); got != 2 {
		t.Errorf("last_seq = %d, want 2", got)
	}
}

func TestFailedSaveRollsCounterBack(t *testing.T) {
	app := newApp(t)
	bad := membership(t, app, 1)
	bad.Set("role", "admin")
	if err := app.Save(bad); err == nil {
		t.Fatal("invalid row saved")
	}
	// Duplicate live membership: fails at the unique index, after
	// validation, inside the same transaction.
	if err := app.Save(membership(t, app, 2)); err != nil {
		t.Fatal(err)
	}
	if err := app.Save(membership(t, app, 2)); err == nil {
		t.Fatal("duplicate membership saved")
	}
	if got := lastSeq(t, app); got != 1 {
		t.Errorf("last_seq = %d, want 1 (failed saves leave no gap)", got)
	}
}

func TestSeqJoinsCallerTransaction(t *testing.T) {
	app := newApp(t)
	errStop := errors.New("stop")

	err := app.RunInTransaction(func(txApp core.App) error {
		for i := range 2 {
			if err := txApp.Save(membership(t, txApp, i)); err != nil {
				return err
			}
		}
		return errStop
	})
	if !errors.Is(err, errStop) {
		t.Fatalf("err = %v", err)
	}
	n, err := app.CountRecords("memberships")
	if err != nil {
		t.Fatal(err)
	}
	if n != 0 || lastSeq(t, app) != 0 {
		t.Errorf("rolled back transaction left rows=%d last_seq=%d", n, lastSeq(t, app))
	}

	err = app.RunInTransaction(func(txApp core.App) error {
		for i := range 2 {
			if err := txApp.Save(membership(t, txApp, i)); err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}
	if got := lastSeq(t, app); got != 2 {
		t.Errorf("last_seq = %d, want 2", got)
	}
}

func TestConcurrentWritesGetDistinctSeq(t *testing.T) {
	app := newApp(t)
	const writers, perWriter = 4, 50

	var wg stdsync.WaitGroup
	errs := make(chan error, writers*perWriter)
	for w := range writers {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for i := range perWriter {
				r := membership(t, app, w*perWriter+i)
				if err := app.Save(r); err != nil {
					errs <- err
					return
				}
				// Every other row is updated right away: updates race
				// with inserts for numbers too.
				if i%2 == 0 {
					r.Set("role", "viewer")
					if err := app.Save(r); err != nil {
						errs <- err
						return
					}
				}
			}
		}()
	}
	wg.Wait()
	close(errs)
	for err := range errs {
		t.Fatal(err)
	}

	var rows []struct {
		Seq int64 `db:"server_seq"`
	}
	if err := app.DB().NewQuery("SELECT server_seq FROM memberships").All(&rows); err != nil {
		t.Fatal(err)
	}
	if len(rows) != writers*perWriter {
		t.Fatalf("rows = %d, want %d", len(rows), writers*perWriter)
	}
	seen := map[int64]bool{}
	for _, r := range rows {
		if seen[r.Seq] {
			t.Errorf("server_seq %d repeated", r.Seq)
		}
		seen[r.Seq] = true
	}

	// Inserts plus updates, no gaps: the counter equals the write count.
	wantLast := int64(writers*perWriter + writers*perWriter/2)
	if got := lastSeq(t, app); got != wantLast {
		t.Errorf("last_seq = %d, want %d", got, wantLast)
	}
	for seq := range seen {
		if seq < 1 || seq > wantLast {
			t.Errorf("server_seq %d outside 1..%d", seq, wantLast)
		}
	}
}

func TestNonSyncCollectionUntouched(t *testing.T) {
	app := newApp(t)
	users, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	u := core.NewRecord(users)
	u.SetEmail("u@example.com")
	u.SetPassword("12345678901234")
	u.Set("locale", "tr")
	if err := app.Save(u); err != nil {
		t.Fatal(err)
	}
	if got := lastSeq(t, app); got != 0 {
		t.Errorf("last_seq = %d after a users write, want 0", got)
	}
}
