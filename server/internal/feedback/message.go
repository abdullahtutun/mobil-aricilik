package feedback

import (
	"encoding/json"
	"slices"
	"strings"
)

// Record is the part of a feedback record the mail shows.
type Record struct {
	ID             string
	OrgID          string
	Kind           string
	Message        string
	ScreenshotPath string
	// DeviceInfo is the device_info object; nil when empty.
	DeviceInfo map[string]any
	// CreatedAt is the phone's timestamp, as text.
	CreatedAt string
}

// Context is what the mail adds from other records; each may be empty.
type Context struct {
	OrgName       string
	SenderEmail   string
	ScreenshotURL string
}

// Mail is the subject and plain text body.
type Mail struct {
	Subject string
	Text    string
}

// kindLabels are the Turkish names of feedback.kind; the mail goes to the
// team, so it is always Turkish.
var kindLabels = map[string]string{
	"bug":             "Hata",
	"suggestion":      "Öneri",
	"missing_feature": "Eksik özellik",
	"thanks":          "Teşekkür",
}

// Compose is supabase/functions/feedback-mail/message.ts feedbackMail: the
// subject and the plain text body. The user's text goes out as plain text;
// no HTML is made. Two differences: device_info keys are sorted (a Go map
// has no insertion order) and non-text values are written as JSON (the
// Edge Function wrote "[object Object]").
func Compose(r Record, c Context) Mail {
	kind := kindLabels[r.Kind]
	if kind == "" {
		kind = r.Kind
	}
	org := c.OrgName
	if org == "" {
		org = r.OrgID
	}
	// No line break may enter the subject line.
	subject := oneLine("[Mobil Arıcı] " + kind + " — " + org)

	sender := c.SenderEmail
	if sender == "" {
		sender = "bilinmiyor"
	}
	lines := []string{
		strings.TrimSpace(r.Message),
		"",
		"—",
		"Tür: " + kind,
		"İşletme: " + org,
		"Gönderen: " + sender,
		"Yazıldığı an: " + r.CreatedAt,
	}
	if len(r.DeviceInfo) > 0 {
		lines = append(lines, "Cihaz:")
		keys := make([]string, 0, len(r.DeviceInfo))
		for k := range r.DeviceInfo {
			keys = append(keys, k)
		}
		slices.Sort(keys)
		for _, k := range keys {
			lines = append(lines, "  "+k+": "+valueText(r.DeviceInfo[k]))
		}
	}
	switch {
	case c.ScreenshotURL != "":
		lines = append(lines, "Ekran görüntüsü (7 gün geçerli): "+c.ScreenshotURL)
	case r.ScreenshotPath != "":
		lines = append(lines, "Ekran görüntüsü: feedback/"+r.ScreenshotPath)
	}
	lines = append(lines, "Kayıt: feedback.id = "+r.ID)
	return Mail{Subject: subject, Text: strings.Join(lines, "\n")}
}

func oneLine(s string) string {
	return strings.Join(strings.FieldsFunc(s, func(r rune) bool { return r == '\r' || r == '\n' }), " ")
}

func valueText(v any) string {
	if s, ok := v.(string); ok {
		return s
	}
	b, err := json.Marshal(v)
	if err != nil {
		return ""
	}
	return string(b)
}
