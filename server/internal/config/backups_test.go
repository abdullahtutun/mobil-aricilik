package config

import (
	"slices"
	"testing"

	"github.com/pocketbase/pocketbase/core"
)

var fullS3 = map[string]string{
	"BACKUPS_S3_ENDPOINT":   "https://s3.example.com",
	"BACKUPS_S3_BUCKET":     "arici",
	"BACKUPS_S3_REGION":     "eu-central-1",
	"BACKUPS_S3_ACCESS_KEY": "access",
	"BACKUPS_S3_SECRET":     "secret-value",
}

// stored returns settings as if they had been saved earlier (panel or a
// previous start), so "untouched" is distinguishable from defaults.
func stored() *core.BackupsConfig {
	s := &core.BackupsConfig{Cron: "0 1 * * *", CronMaxKeep: 2}
	s.S3 = core.S3Config{
		Enabled:   true,
		Endpoint:  "https://old.example.com",
		Bucket:    "old",
		Region:    "old",
		AccessKey: "old",
		Secret:    "old",
	}
	return s
}

func TestBackupsEnvWritesSettings(t *testing.T) {
	m := map[string]string{"BACKUPS_CRON": " 0 3 * * * ", "BACKUPS_MAX_KEEP": "7"}
	for k, v := range fullS3 {
		m[k] = v
	}
	b := Load(env(m)).Backups

	s := &core.BackupsConfig{CronMaxKeep: 3}
	if !b.Apply(s) {
		t.Fatal("Apply reported no change")
	}
	if s.Cron != "0 3 * * *" || s.CronMaxKeep != 7 {
		t.Fatalf("cron = %q, maxKeep = %d", s.Cron, s.CronMaxKeep)
	}
	want := core.S3Config{
		Enabled:   true,
		Endpoint:  "https://s3.example.com",
		Bucket:    "arici",
		Region:    "eu-central-1",
		AccessKey: "access",
		Secret:    "secret-value",
	}
	if s.S3 != want {
		t.Fatalf("S3 = %+v", s.S3)
	}
	if b.Apply(s) {
		t.Fatal("second Apply reported a change")
	}
}

func TestBackupsEnvEmptyLeavesSettings(t *testing.T) {
	b := Load(env(nil)).Backups
	if b.Cron != "" || b.MaxKeep != 0 || b.InvalidMaxKeep || b.S3 != nil || b.S3Missing != nil {
		t.Fatalf("Backups = %+v", b)
	}

	s := stored()
	if b.Apply(s) {
		t.Fatal("Apply reported a change")
	}
	if *s != *stored() {
		t.Fatalf("settings changed: %+v", s)
	}
}

func TestBackupsOnlyCronKeepsMaxKeep(t *testing.T) {
	s := stored()
	if !Load(env(map[string]string{"BACKUPS_CRON": "0 3 * * *"})).Backups.Apply(s) {
		t.Fatal("Apply reported no change")
	}
	if s.Cron != "0 3 * * *" || s.CronMaxKeep != 2 {
		t.Fatalf("cron = %q, maxKeep = %d", s.Cron, s.CronMaxKeep)
	}
}

func TestBackupsInvalidMaxKeepIgnored(t *testing.T) {
	for _, raw := range []string{"0", "-1", "seven", "7.5"} {
		b := Load(env(map[string]string{"BACKUPS_MAX_KEEP": raw})).Backups
		if !b.InvalidMaxKeep || b.MaxKeep != 0 {
			t.Fatalf("%q: %+v", raw, b)
		}
		s := stored()
		if b.Apply(s) || s.CronMaxKeep != 2 {
			t.Fatalf("%q changed maxKeep to %d", raw, s.CronMaxKeep)
		}
	}
}

func TestBackupsHalfS3NotEnabled(t *testing.T) {
	m := map[string]string{}
	for k, v := range fullS3 {
		m[k] = v
	}
	delete(m, "BACKUPS_S3_SECRET")
	m["BACKUPS_S3_REGION"] = "  "

	b := Load(env(m)).Backups
	if b.S3 != nil {
		t.Fatal("half-filled S3 accepted")
	}
	if !slices.Equal(b.S3Missing, []string{"BACKUPS_S3_REGION", "BACKUPS_S3_SECRET"}) {
		t.Fatalf("S3Missing = %v", b.S3Missing)
	}

	s := &core.BackupsConfig{CronMaxKeep: 3}
	if b.Apply(s) || s.S3.Enabled {
		t.Fatalf("S3 = %+v", s.S3)
	}
	// A target enabled earlier is not switched off either.
	s = stored()
	if b.Apply(s) || *s != *stored() {
		t.Fatalf("stored S3 changed: %+v", s.S3)
	}
}
