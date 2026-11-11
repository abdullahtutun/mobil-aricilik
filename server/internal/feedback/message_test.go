package feedback

import "testing"

// The cases of supabase/functions/feedback-mail/message_test.ts.

func TestComposeFull(t *testing.T) {
	got := Compose(Record{
		ID:             "0195f2a4-f000-7000-8000-000000000001",
		OrgID:          "0195f2a4-0a0a-7000-8000-00000000000a",
		Kind:           "suggestion",
		Message:        "  Kovan kartına not alanı eklensin.\n  ",
		ScreenshotPath: "0195f2a4-0a0a-7000-8000-00000000000a/0195f2a4-f000-7000-8000-000000000001.jpg",
		DeviceInfo:     map[string]any{"platform": "android", "app_version": "1.2.0", "screen": map[string]any{"w": 360.0}},
		CreatedAt:      "2026-11-10T10:15:30.123Z",
	}, Context{
		OrgName:       "Çiçek Arıcılık",
		SenderEmail:   "arici@example.com",
		ScreenshotURL: "https://dev.example/api/app/feedback-shot/x?exp=1&sig=s",
	})
	if want := "[Mobil Arıcı] Öneri — Çiçek Arıcılık"; got.Subject != want {
		t.Errorf("subject = %q", got.Subject)
	}
	want := "Kovan kartına not alanı eklensin.\n" +
		"\n" +
		"—\n" +
		"Tür: Öneri\n" +
		"İşletme: Çiçek Arıcılık\n" +
		"Gönderen: arici@example.com\n" +
		"Yazıldığı an: 2026-11-10T10:15:30.123Z\n" +
		"Cihaz:\n" +
		"  app_version: 1.2.0\n" +
		"  platform: android\n" +
		"  screen: {\"w\":360}\n" +
		"Ekran görüntüsü (7 gün geçerli): https://dev.example/api/app/feedback-shot/x?exp=1&sig=s\n" +
		"Kayıt: feedback.id = 0195f2a4-f000-7000-8000-000000000001"
	if got.Text != want {
		t.Errorf("text =\n%s\nwant\n%s", got.Text, want)
	}
}

func TestComposeFallbacks(t *testing.T) {
	got := Compose(Record{
		ID:             "f1",
		OrgID:          "org-1",
		Kind:           "something_new",
		Message:        "x",
		ScreenshotPath: "org-1/f1.jpg",
		CreatedAt:      "t",
	}, Context{})
	if got.Subject != "[Mobil Arıcı] something_new — org-1" {
		t.Errorf("subject = %q", got.Subject)
	}
	want := "x\n\n—\nTür: something_new\nİşletme: org-1\nGönderen: bilinmiyor\nYazıldığı an: t\n" +
		"Ekran görüntüsü: feedback/org-1/f1.jpg\nKayıt: feedback.id = f1"
	if got.Text != want {
		t.Errorf("text =\n%s", got.Text)
	}
}

func TestComposeNoScreenshot(t *testing.T) {
	got := Compose(Record{ID: "f1", OrgID: "o", Kind: "thanks", Message: "Sağ olun", CreatedAt: "t"}, Context{OrgName: "A"})
	want := "Sağ olun\n\n—\nTür: Teşekkür\nİşletme: A\nGönderen: bilinmiyor\nYazıldığı an: t\nKayıt: feedback.id = f1"
	if got.Text != want {
		t.Errorf("text =\n%s", got.Text)
	}
}

func TestComposeKindLabels(t *testing.T) {
	for kind, label := range map[string]string{"bug": "Hata", "suggestion": "Öneri", "missing_feature": "Eksik özellik", "thanks": "Teşekkür"} {
		if got := Compose(Record{Kind: kind, OrgID: "o"}, Context{}).Subject; got != "[Mobil Arıcı] "+label+" — o" {
			t.Errorf("%s: %q", kind, got)
		}
	}
}

// An organization name never breaks the subject line.
func TestComposeSubjectOneLine(t *testing.T) {
	got := Compose(Record{Kind: "bug"}, Context{OrgName: "A\r\nBcc: evil@example.com\nB"}).Subject
	if got != "[Mobil Arıcı] Hata — A Bcc: evil@example.com B" {
		t.Errorf("subject = %q", got)
	}
}
