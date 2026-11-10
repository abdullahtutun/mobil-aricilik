package pattern

import (
	"testing"
	"time"
)

func TestPatterns(t *testing.T) {
	cases := []struct {
		name  string
		match func(string) bool
		yes   []string
		no    []string
	}{
		{
			name:  "UUID",
			match: IsUUID,
			yes:   []string{"0195f2a4-3333-7000-8000-000000000003", "00000000-0000-0000-0000-000000000000"},
			no:    []string{"", "0195F2A4-3333-7000-8000-000000000003", "0195f2a4333370008000000000000003", "0195f2a4-3333-7000-8000-00000000003"},
		},
		{
			name:  "Timestamp",
			match: IsTimestamp,
			yes:   []string{"2026-11-09T10:15:30.123456Z", "2026-02-29T23:59:59.000000Z"},
			no:    []string{"", "2026-11-09T10:15:30Z", "2026-11-09T10:15:30.123456", "2026-11-09T10:15:30.1234567Z", "2026-00-09T10:15:30.123456Z", "2026-11-32T10:15:30.123456Z", "2026-11-09T10:60:30.123456Z"},
		},
		{
			name:  "Date",
			match: IsDate,
			yes:   []string{"2026-11-09", "2026-12-31"},
			no:    []string{"", "2026-11-9", "2026/11/09", "2026-11-09T00:00:00.000000Z"},
		},
	}
	for _, c := range cases {
		for _, s := range c.yes {
			if !c.match(s) {
				t.Errorf("%s rejects %q", c.name, s)
			}
		}
		for _, s := range c.no {
			if c.match(s) {
				t.Errorf("%s accepts %q", c.name, s)
			}
		}
	}

	if len("2026-11-09T10:15:30.123456Z") != TimestampLength {
		t.Error("TimestampLength")
	}
	if len("0195f2a4-3333-7000-8000-000000000003") != UUIDLength {
		t.Error("UUIDLength")
	}
	if len("2026-11-09") != DateLength {
		t.Error("DateLength")
	}
}

func TestFormatTimestamp(t *testing.T) {
	ist := time.FixedZone("TRT", 3*60*60)
	got := FormatTimestamp(time.Date(2026, 11, 9, 13, 15, 30, 123456789, ist))
	if got != "2026-11-09T10:15:30.123456Z" {
		t.Errorf("FormatTimestamp = %q", got)
	}
	if !IsTimestamp(got) || len(got) != TimestampLength {
		t.Errorf("%q is not a K-5 time", got)
	}
	// Whole seconds keep the six digits (fixed width).
	if got := FormatTimestamp(time.Date(2026, 1, 2, 3, 4, 5, 0, time.UTC)); got != "2026-01-02T03:04:05.000000Z" {
		t.Errorf("FormatTimestamp = %q", got)
	}
}
