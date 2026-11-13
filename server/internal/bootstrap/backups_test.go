package bootstrap

import (
	"bytes"
	"log/slog"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	"github.com/pocketbase/pocketbase/tests"
)

func backupsFrom(m map[string]string) config.Backups {
	return config.Load(func(k string) string { return m[k] }).Backups
}

func newApp(t *testing.T) *tests.TestApp {
	t.Helper()
	app, err := tests.NewTestApp(t.TempDir())
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(app.Cleanup)
	return app
}

func hasJob(app *tests.TestApp, id, expr string) bool {
	for _, j := range app.Cron().Jobs() {
		if j.Id() == id && j.Expression() == expr {
			return true
		}
	}
	return false
}

func TestApplyBackupsPersists(t *testing.T) {
	app := newApp(t)
	var buf bytes.Buffer
	applyBackups(app, backupsFrom(map[string]string{
		"BACKUPS_CRON":          "0 3 * * *",
		"BACKUPS_MAX_KEEP":      "7",
		"BACKUPS_S3_ENDPOINT":   "https://s3.example.com",
		"BACKUPS_S3_BUCKET":     "arici",
		"BACKUPS_S3_REGION":     "eu-central-1",
		"BACKUPS_S3_ACCESS_KEY": "access-value",
		"BACKUPS_S3_SECRET":     "secret-value",
	}), slog.New(slog.NewTextHandler(&buf, nil)))

	// Read back from the database, not the in-memory copy.
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	got := app.Settings().Backups
	if got.Cron != "0 3 * * *" || got.CronMaxKeep != 7 || !got.S3.Enabled || got.S3.Secret != "secret-value" {
		t.Fatalf("stored backups = %+v", got)
	}
	// The autobackup job is rescheduled on reload.
	if !hasJob(app, "__pbAutoBackup__", "0 3 * * *") {
		t.Fatal("autobackup cron job not scheduled")
	}

	out := buf.String()
	if !strings.Contains(out, "Backup settings applied") {
		t.Fatalf("no apply log:\n%s", out)
	}
	for _, secret := range []string{"secret-value", "access-value"} {
		if strings.Contains(out, secret) {
			t.Fatalf("log contains %q:\n%s", secret, out)
		}
	}
}

func TestApplyBackupsEmptyLeavesStored(t *testing.T) {
	app := newApp(t)
	s := app.Settings()
	s.Backups.Cron = "0 1 * * *"
	s.Backups.CronMaxKeep = 2
	if err := app.Save(s); err != nil {
		t.Fatal(err)
	}

	var buf bytes.Buffer
	applyBackups(app, backupsFrom(nil), slog.New(slog.NewTextHandler(&buf, nil)))

	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	got := app.Settings().Backups
	if got.Cron != "0 1 * * *" || got.CronMaxKeep != 2 || got.S3.Enabled {
		t.Fatalf("stored backups = %+v", got)
	}
	if buf.Len() != 0 {
		t.Fatalf("unexpected log:\n%s", buf.String())
	}
}

func TestApplyBackupsHalfS3NotEnabled(t *testing.T) {
	app := newApp(t)
	var buf bytes.Buffer
	applyBackups(app, backupsFrom(map[string]string{
		"BACKUPS_S3_ENDPOINT": "https://s3.example.com",
		"BACKUPS_S3_SECRET":   "secret-value",
	}), slog.New(slog.NewTextHandler(&buf, nil)))

	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	if app.Settings().Backups.S3.Enabled {
		t.Fatal("half-filled S3 enabled")
	}
	out := buf.String()
	if !strings.Contains(out, "BACKUPS_S3_BUCKET,BACKUPS_S3_REGION,BACKUPS_S3_ACCESS_KEY") {
		t.Fatalf("missing names not logged:\n%s", out)
	}
	if strings.Contains(out, "secret-value") || strings.Contains(out, "s3.example.com") {
		t.Fatalf("log contains a value:\n%s", out)
	}
}

func TestApplyBackupsInvalidCronKeepsStored(t *testing.T) {
	app := newApp(t)
	var buf bytes.Buffer
	applyBackups(app, backupsFrom(map[string]string{
		"BACKUPS_CRON":     "every night",
		"BACKUPS_MAX_KEEP": "7",
	}), slog.New(slog.NewTextHandler(&buf, nil)))

	got := app.Settings().Backups
	if got.Cron != "" || got.CronMaxKeep == 7 {
		t.Fatalf("live settings changed: %+v", got)
	}
	if err := app.ReloadSettings(); err != nil {
		t.Fatal(err)
	}
	if app.Settings().Backups.Cron != "" {
		t.Fatal("invalid cron stored")
	}
	out := buf.String()
	if !strings.Contains(out, "fields=backups.cron") || strings.Contains(out, "every night") {
		t.Fatalf("unexpected log:\n%s", out)
	}
}
