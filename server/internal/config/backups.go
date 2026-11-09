package config

import (
	"strconv"
	"strings"

	"github.com/pocketbase/pocketbase/core"
)

// s3Vars are the BACKUPS_S3_* names, in the order they are reported.
var s3Vars = []string{
	"BACKUPS_S3_ENDPOINT",
	"BACKUPS_S3_BUCKET",
	"BACKUPS_S3_REGION",
	"BACKUPS_S3_ACCESS_KEY",
	"BACKUPS_S3_SECRET",
}

// S3 is a complete S3 target for backups. It holds a secret; never log it.
type S3 struct {
	Endpoint  string
	Bucket    string
	Region    string
	AccessKey string
	Secret    string
}

// Backups is the backup part of the environment (K-10, K-15).
//
// Only what is set is applied: an unset variable leaves the stored
// PocketBase setting as it is.
type Backups struct {
	// Cron is BACKUPS_CRON; empty when unset.
	Cron string
	// MaxKeep is BACKUPS_MAX_KEEP; 0 when unset or invalid.
	MaxKeep int
	// InvalidMaxKeep is true when BACKUPS_MAX_KEEP is set but not an
	// integer >= 1.
	InvalidMaxKeep bool
	// S3 is non-nil only when every BACKUPS_S3_* variable is set.
	S3 *S3
	// S3Missing names the unset BACKUPS_S3_* variables when some, but not
	// all, of them are set. A half-filled S3 target is never enabled.
	S3Missing []string
}

func loadBackups(getenv func(string) string) Backups {
	var b Backups
	b.Cron = strings.TrimSpace(getenv("BACKUPS_CRON"))

	if raw := strings.TrimSpace(getenv("BACKUPS_MAX_KEEP")); raw != "" {
		n, err := strconv.Atoi(raw)
		if err != nil || n < 1 {
			b.InvalidMaxKeep = true
		} else {
			b.MaxKeep = n
		}
	}

	values := make([]string, len(s3Vars))
	var missing []string
	for i, name := range s3Vars {
		values[i] = strings.TrimSpace(getenv(name))
		if values[i] == "" {
			missing = append(missing, name)
		}
	}
	switch len(missing) {
	case 0:
		b.S3 = &S3{
			Endpoint:  values[0],
			Bucket:    values[1],
			Region:    values[2],
			AccessKey: values[3],
			Secret:    values[4],
		}
	case len(s3Vars):
		// Nothing set: S3 stays as stored (off unless enabled before).
	default:
		b.S3Missing = missing
	}

	return b
}

// Apply writes the set values into c and reports whether anything changed.
// Unset values leave c untouched; a half-filled S3 target is not applied.
func (b Backups) Apply(c *core.BackupsConfig) bool {
	changed := false

	if b.Cron != "" && c.Cron != b.Cron {
		c.Cron = b.Cron
		changed = true
	}
	if b.MaxKeep > 0 && c.CronMaxKeep != b.MaxKeep {
		c.CronMaxKeep = b.MaxKeep
		changed = true
	}
	if b.S3 != nil {
		want := core.S3Config{
			Enabled:        true,
			Endpoint:       b.S3.Endpoint,
			Bucket:         b.S3.Bucket,
			Region:         b.S3.Region,
			AccessKey:      b.S3.AccessKey,
			Secret:         b.S3.Secret,
			ForcePathStyle: c.S3.ForcePathStyle,
		}
		if c.S3 != want {
			c.S3 = want
			changed = true
		}
	}

	return changed
}
