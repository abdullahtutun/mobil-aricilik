package notify_test

import (
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/notify"
)

// message_test.ts's cases, plus every app language.
func TestTaskText(t *testing.T) {
	if title, body := notify.TaskText(" Kontrol ", "de"); title != "Neue Aufgabe für dich" || body != "Kontrol" {
		t.Errorf("titled: %q %q", title, body)
	}
	if title, body := notify.TaskText("", "de"); title != "Neue Aufgabe für dich" || body != "Dir wurde eine Aufgabe zugewiesen." {
		t.Errorf("untitled: %q %q", title, body)
	}
	if title, body := notify.TaskText("  ", "xx"); title != "New task for you" || body != "A task was assigned to you." {
		t.Errorf("unknown language: %q %q", title, body)
	}
	en1, en2 := notify.TaskText("", "en")
	for _, l := range auth.Locales {
		title, body := notify.TaskText("", l)
		st, sb := notify.SupportPeriodText("D", "2026-12-31", l)
		if title == "" || body == "" || st == "" || sb == "" {
			t.Errorf("%s: a text is missing", l)
		}
		if l != "en" && (title == en1 || body == en2) {
			t.Errorf("%s: falls back to English", l)
		}
	}
}

func TestFormatDay(t *testing.T) {
	// Node's Intl.DateTimeFormat with message.ts's dayLocales.
	want := map[string]string{
		"tr": "31.12.2026", "de": "31.12.2026", "ru": "31.12.2026", "uk": "31.12.2026",
		"en": "31/12/2026", "es": "31/12/2026", "pt": "31/12/2026", "hi": "31/12/2026",
		"fa": "2026/12/31",
	}
	for _, l := range auth.Locales {
		if got := notify.FormatDay("2026-12-31", l); got != want[l] {
			t.Errorf("%s: %q, want %q", l, got, want[l])
		}
	}
	if got := notify.FormatDay("2027-01-05", "tr"); got != "05.01.2027" {
		t.Errorf("leading zeros: %q", got)
	}
	if got := notify.FormatDay("bozuk", "tr"); got != "bozuk" {
		t.Errorf("unreadable: %q", got)
	}
	if _, body := notify.SupportPeriodText("Destek", "2026-12-31", "es"); body != "Destek · último día 31/12/2026" {
		t.Errorf("body %q", body)
	}
}
