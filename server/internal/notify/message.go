package notify

import (
	"strings"
	"time"
)

// texts are supabase/functions/notify/message.ts's strings, per language
// of auth.Locales. A new language is added there and here; the test fails
// when one is missing.
type texts struct {
	taskTitle    string
	taskBody     string
	supportTitle string
	// lastDay is the word before the period's last day in the body
	// "<name> · <lastDay> <day>".
	lastDay string
}

var messages = map[string]texts{
	"tr": {"Sana yeni görev atandı", "Bir görev sana atandı.", "Destek başvurusu açıldı", "son gün"},
	"en": {"New task for you", "A task was assigned to you.", "Support application is open", "last day"},
	"de": {"Neue Aufgabe für dich", "Dir wurde eine Aufgabe zugewiesen.", "Förderantrag ist geöffnet", "letzter Tag"},
	"es": {"Tienes una tarea nueva", "Se te ha asignado una tarea.", "La solicitud de ayudas está abierta", "último día"},
	"pt": {"Você tem uma nova tarefa", "Uma tarefa foi atribuída a você.", "A solicitação de subsídio está aberta", "último dia"},
	"ru": {"Вам назначена задача", "Вам назначили задачу.", "Открыт приём заявок на субсидии", "последний день"},
	"uk": {"Вам призначено завдання", "Вам призначили завдання.", "Відкрито прийом заявок на субсидії", "останній день"},
	"fa": {"کار جدیدی به شما واگذار شد", "کاری به شما واگذار شد.", "درخواست حمایت باز شد", "آخرین روز"},
	"hi": {"आपको नया काम सौंपा गया", "आपको एक काम सौंपा गया है।", "सब्सिडी आवेदन खुल गया है", "आख़िरी दिन"},
}

func textsFor(locale string) texts {
	if t, ok := messages[locale]; ok {
		return t
	}
	return messages["en"]
}

// TaskText is notificationText: the title says a task was assigned; the
// body is the task's title, or the general text for an untitled
// (automatic) task.
func TaskText(title, locale string) (string, string) {
	t := textsFor(locale)
	if s := strings.TrimSpace(title); s != "" {
		return t.taskTitle, s
	}
	return t.taskTitle, t.taskBody
}

// SupportPeriodText is supportPeriodText: "<name> · last day <day>".
func SupportPeriodText(name, endsOn, locale string) (string, string) {
	t := textsFor(locale)
	return t.supportTitle, name + " · " + t.lastDay + " " + FormatDay(endsOn, locale)
}

// dayLayouts are the short dates message.ts's Intl.DateTimeFormat gives
// with day, month and year 2-digit/numeric (checked with Node's ICU):
// tr-TR, de-DE, ru-RU, uk-UA "31.12.2026"; en-GB, es-ES, pt-BR, hi-IN
// "31/12/2026"; fa-IR with the Gregorian calendar and Latin digits
// "2026/12/31".
var dayLayouts = map[string]string{
	"tr": "02.01.2006", "de": "02.01.2006", "ru": "02.01.2006", "uk": "02.01.2006",
	"en": "02/01/2006", "es": "02/01/2006", "pt": "02/01/2006", "hi": "02/01/2006",
	"fa": "2006/01/02",
}

// FormatDay writes a YYYY-MM-DD day in the language's short form; an
// unreadable day is returned as it is.
func FormatDay(day, locale string) string {
	d, err := time.Parse(time.DateOnly, day)
	if err != nil {
		return day
	}
	layout, ok := dayLayouts[locale]
	if !ok {
		layout = dayLayouts["en"]
	}
	return d.Format(layout)
}
