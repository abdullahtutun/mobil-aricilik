package bootstrap

import (
	"errors"
	"log/slog"
	"slices"
	"strings"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/config"
	validation "github.com/pocketbase/ozzo-validation/v4"
	"github.com/pocketbase/pocketbase/core"
)

// applyBackups writes the backup variables into the stored PocketBase
// settings (K-10, K-15). Unset variables leave the stored values alone. A
// bad value is logged by variable name and skipped; the server still starts.
//
// Saving the settings reloads them, which reschedules PocketBase's own
// backup cron job.
func applyBackups(app core.App, b config.Backups, log *slog.Logger) {
	if b.InvalidMaxKeep {
		log.Error("BACKUPS_MAX_KEEP must be an integer >= 1; keeping the stored value")
	}
	if len(b.S3Missing) > 0 {
		log.Warn("S3 backups stay as stored: some BACKUPS_S3_* variables are empty",
			"names", strings.Join(b.S3Missing, ","))
	}

	// Change a copy: if validation fails, the live settings stay as loaded.
	s, err := app.Settings().Clone()
	if err != nil {
		log.Error("Backup settings not applied", "error", err.Error())
		return
	}
	if !b.Apply(&s.Backups) {
		return
	}

	if err := app.Save(s); err != nil {
		// The validation error may echo field values; log only field names.
		log.Error("Backup settings from BACKUPS_* rejected; keeping the stored ones",
			"fields", invalidFields(err))
		return
	}

	got := app.Settings().Backups
	log.Info("Backup settings applied from environment",
		"cron", got.Cron, "maxKeep", got.CronMaxKeep, "s3", got.S3.Enabled)
}

// invalidFields returns the dotted names of the invalid settings fields,
// e.g. "backups.cron", without their values or messages.
func invalidFields(err error) string {
	var names []string
	var walk func(prefix string, e error)
	walk = func(prefix string, e error) {
		var errs validation.Errors
		if errors.As(e, &errs) {
			for k, v := range errs {
				walk(prefix+k+".", v)
			}
			return
		}
		names = append(names, strings.TrimSuffix(prefix, "."))
	}
	walk("", err)
	slices.Sort(names)
	return strings.Join(names, ",")
}
