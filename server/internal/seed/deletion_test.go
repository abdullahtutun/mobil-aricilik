package seed_test

import (
	"bytes"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/pattern"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/seed"
	"github.com/pocketbase/dbx"
	"github.com/pocketbase/pocketbase/core"
)

const testerEmail = "tester@example.com"

// newTester opens a user with a pending deletion request (as the app's
// request does) and returns its id.
func newTester(t *testing.T, app core.App, email string, request bool) string {
	t.Helper()
	c, err := app.FindCollectionByNameOrId("users")
	if err != nil {
		t.Fatal(err)
	}
	u := core.NewRecord(c)
	u.SetEmail(email)
	u.SetPassword("1234567890")
	u.Set("locale", "tr")
	if err := app.Save(u); err != nil {
		t.Fatal(err)
	}
	if request {
		_, err = deletion.Request(app, deletion.RequestInput{
			UserID: u.Id, Email: email, Channel: deletion.ChannelApp,
		})
		if err != nil {
			t.Fatal(err)
		}
	}
	return u.Id
}

func pendingScheduledFor(t *testing.T, app core.App, userID string) string {
	t.Helper()
	r, err := app.FindFirstRecordByFilter(deletion.RequestsCollection,
		"user_id = {:u} && status = {:s}", dbx.Params{"u": userID, "s": deletion.StatusPending})
	if err != nil {
		t.Fatal(err)
	}
	return r.GetString("scheduled_for")
}

func runExpire(app core.App, env string, args ...string) (string, error) {
	cmd := seed.NewCommand(app, nil, env)
	var out bytes.Buffer
	cmd.SetOut(&out)
	cmd.SetErr(&out)
	cmd.SetArgs(append([]string{"deletion", "expire"}, args...))
	err := cmd.Execute()
	return out.String(), err
}

// Outside dev the command refuses and the request keeps its date: on prod
// it cannot shorten anyone's seven days.
func TestExpireDeletionOnlyOnDev(t *testing.T) {
	app := newApp(t)
	userID := newTester(t, app, testerEmail, true)
	before := pendingScheduledFor(t, app, userID)

	for _, env := range []string{config.EnvProd, "", "staging"} {
		out, err := runExpire(app, env, "--user", testerEmail)
		if !errors.Is(err, seed.ErrNotDev) {
			t.Errorf("env %q: err = %v, want ErrNotDev\n%s", env, err, out)
		}
	}
	if got := pendingScheduledFor(t, app, userID); got != before {
		t.Errorf("scheduled_for changed outside dev: %s → %s", before, got)
	}
	res, err := deletion.PurgeDue(app)
	if err != nil || res.Completed != 0 {
		t.Errorf("purge after refused expire = %+v, %v; want nothing", res, err)
	}
}

// On dev the request becomes due, and the hourly purge (run by hand) deletes
// the account and writes deletion_log — the P9.2 item 10 flow.
func TestExpireDeletionThenPurge(t *testing.T) {
	app := newApp(t)
	userID := newTester(t, app, testerEmail, true)

	res, err := deletion.PurgeDue(app)
	if err != nil || res.Completed != 0 {
		t.Fatalf("purge before expire = %+v, %v; want nothing", res, err)
	}

	out, err := runExpire(app, config.EnvDev, "--user", testerEmail)
	if err != nil || !strings.Contains(out, deletion.PurgeCronJob) {
		t.Fatalf("expire: %v\n%s", err, out)
	}
	r, err := app.FindFirstRecordByFilter(deletion.RequestsCollection, "user_id = {:u}", dbx.Params{"u": userID})
	if err != nil {
		t.Fatal(err)
	}
	requested, _ := time.Parse(pattern.TimestampLayout, r.GetString("requested_at"))
	scheduled, _ := time.Parse(pattern.TimestampLayout, r.GetString("scheduled_for"))
	if !scheduled.Before(time.Now()) || scheduled.Sub(requested) != deletion.GracePeriod {
		t.Errorf("requested_at %s, scheduled_for %s: want due, 7 days apart",
			r.GetString("requested_at"), r.GetString("scheduled_for"))
	}

	res, err = deletion.PurgeDue(app)
	if err != nil || res.Completed != 1 || res.Failed != 0 {
		t.Fatalf("purge = %+v, %v; want 1 completed", res, err)
	}
	if _, err := app.FindRecordById("users", userID); err == nil {
		t.Error("the user is still there")
	}
	if n, _ := app.CountRecords("deletion_log", dbx.HashExp{"user_hash": deletion.Hash(userID)}); n != 1 {
		t.Errorf("deletion_log rows = %d, want 1", n)
	}

	// Nothing pending any more.
	if _, err := runExpire(app, config.EnvDev, "--user", testerEmail); err == nil {
		t.Error("second expire after the purge succeeded")
	}
}

func TestExpireDeletionNeedsAPendingRequest(t *testing.T) {
	app := newApp(t)
	newTester(t, app, testerEmail, false)

	if _, err := runExpire(app, config.EnvDev, "--user", testerEmail); !errors.Is(err, seed.ErrNoPendingDeletion) {
		t.Errorf("no request: err = %v, want ErrNoPendingDeletion", err)
	}
	if _, err := runExpire(app, config.EnvDev, "--user", "nobody@example.com"); err == nil || !strings.Contains(err.Error(), "no user") {
		t.Errorf("unknown user: err = %v", err)
	}
	if _, err := runExpire(app, config.EnvDev); err == nil {
		t.Error("missing --user accepted")
	}
}
