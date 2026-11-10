package orgs

import "time"

// SetNow replaces the clock until the returned function restores it.
func SetNow(f func() time.Time) (restore func()) {
	old := now
	now = f
	return func() { now = old }
}
