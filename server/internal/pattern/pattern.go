// Package pattern holds the regular expressions every collection shares, so
// that migrations, validation and tests use one definition (K-4, K-5).
package pattern

import "regexp"

const (
	// UUID is the id pattern of every collection we own (K-4) and of the
	// columns that point to another record (`org_id`, `created_by`, ...).
	// Lower-case only, like Postgres prints a uuid and the client sends it.
	UUID = `^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`

	// UUIDLength is the min and max length of a UUID text field.
	UUIDLength = 36

	// Timestamp is a sync time (K-5): UTC, microseconds, fixed width, so
	// that string order equals time order (last-writer-wins compares text).
	// Example: 2026-11-09T10:15:30.123456Z.
	Timestamp = `^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]\.[0-9]{6}Z$`

	// TimestampLength is the fixed width of a Timestamp.
	TimestampLength = 27

	// Date is a day column (`expires_on` and the like): YYYY-MM-DD.
	Date = `^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$`

	// DateLength is the fixed width of a Date.
	DateLength = 10
)

var (
	uuidRe      = regexp.MustCompile(UUID)
	timestampRe = regexp.MustCompile(Timestamp)
	dateRe      = regexp.MustCompile(Date)
)

// IsUUID reports whether s matches [UUID].
func IsUUID(s string) bool { return uuidRe.MatchString(s) }

// IsTimestamp reports whether s matches [Timestamp].
func IsTimestamp(s string) bool { return timestampRe.MatchString(s) }

// IsDate reports whether s matches [Date].
func IsDate(s string) bool { return dateRe.MatchString(s) }
