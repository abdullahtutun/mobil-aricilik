package deletion_test

// supabase/functions/account-delete/mail_test.ts. testdata/mails.json is the
// output of mail.ts itself, produced with Deno (the Edge Function's
// runtime): every e-mail in nine languages and the deletion date of 18
// moments, so the Go texts and date patterns are compared byte for byte.

import (
	"encoding/json"
	"os"
	"regexp"
	"strings"
	"testing"
	"time"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
	"github.com/abdullahtutun/mobil-aricilik/server/internal/deletion"
)

type goldenMail struct {
	Subject string `json:"subject"`
	Text    string `json:"text"`
}

type goldenLocale struct {
	RequestedOrg     goldenMail  `json:"requested_org"`
	RequestedAccount goldenMail  `json:"requested_account"`
	Code             goldenMail  `json:"code"`
	Completed        goldenMail  `json:"completed"`
	Dates            [][2]string `json:"dates"`
}

func loadGolden(t *testing.T) map[string]goldenLocale {
	t.Helper()
	raw, err := os.ReadFile("testdata/mails.json")
	if err != nil {
		t.Fatal(err)
	}
	var g map[string]goldenLocale
	if err := json.Unmarshal(raw, &g); err != nil {
		t.Fatal(err)
	}
	return g
}

func at(t *testing.T, iso string) time.Time {
	t.Helper()
	v, err := time.Parse(time.RFC3339, iso)
	if err != nil {
		t.Fatal(err)
	}
	return v
}

func TestMailTS(t *testing.T) {
	g := loadGolden(t)

	t.Run("mail_test.ts/dil user_metadata.locale'den gelir, varsayılan İngilizce", func(t *testing.T) {
		for in, want := range map[string]string{
			"en": "en", "en-GB": "en", "tr": "tr", "tr-TR": "tr", "xx": "en", "": "en",
		} {
			if got := deletion.MailLocale(in); got != want {
				t.Errorf("MailLocale(%q) = %q, want %q", in, got, want)
			}
		}
	})

	t.Run("mail_test.ts/tarih Türkçede Türkiye saatiyle, İngilizcede UTC ile yazılır", func(t *testing.T) {
		v := at(t, "2026-11-12T21:30:00Z")
		if got := deletion.FormatDeletionDate(v, "tr"); got != "13 Kasım 2026 00:30 (TSİ)" {
			t.Errorf("tr = %q", got)
		}
		if got := deletion.FormatDeletionDate(v, "en"); got != "12 November 2026 at 21:30 UTC" {
			t.Errorf("en = %q", got)
		}
	})

	t.Run("mail_test.ts/talep e-postası tarihi ve giriş yapıp onaylayarak vazgeçmeyi söyler", func(t *testing.T) {
		v := at(t, "2026-11-12T09:30:00Z")
		tr := deletion.RequestedMail(v, false, "tr").Text
		for _, want := range []string{
			"12 Kasım 2026 12:30 (TSİ) tarihinde kalıcı olarak silinecek",
			"giriş yap ve hesabını korumak istediğini onayla",
			"işletmede kalır",
		} {
			if !strings.Contains(tr, want) {
				t.Errorf("tr mail lacks %q:\n%s", want, tr)
			}
		}
		if !strings.Contains(deletion.RequestedMail(v, true, "tr").Text, "işletmen ve işletmenin tüm kayıtları") {
			t.Error("tr mail with organization does not say so")
		}
		en := deletion.RequestedMail(v, true, "en").Text
		if !strings.Contains(en, "permanently deleted on 12 November 2026 at 09:30 UTC") || !strings.Contains(en, "sign in") {
			t.Errorf("en mail:\n%s", en)
		}
	})

	t.Run("mail_test.ts/tamamlanma e-postası kısa onaydır", func(t *testing.T) {
		if got := deletion.CompletedMail("tr").Subject; got != "Mobil Arıcı hesabın silindi" {
			t.Errorf("tr = %q", got)
		}
		if got := deletion.CompletedMail("en").Subject; got != "Your Mobil Arıcı account has been deleted" {
			t.Errorf("en = %q", got)
		}
	})

	t.Run("mail_test.ts/silme kodu e-postası giriş kodundan ayrı", func(t *testing.T) {
		tr := deletion.CodeMail("482913", "tr")
		if tr.Subject != "Mobil Arıcı hesap silme kodun" || !strings.Contains(tr.Text, "482913") ||
			!strings.Contains(tr.Text, "hesabın silinmez") {
			t.Errorf("tr = %+v", tr)
		}
		en := deletion.CodeMail("482913", "en")
		if en.Subject != "Your Mobil Arıcı account deletion code" || !strings.Contains(en.Text, "482913") {
			t.Errorf("en = %+v", en)
		}
	})

	t.Run("mail_test.ts/her dilde üç e-posta da kodu ve tarihi taşır (mail.ts çıktısıyla birebir)", func(t *testing.T) {
		if len(g) != len(auth.Locales) {
			t.Fatalf("golden has %d languages, auth.Locales %d", len(g), len(auth.Locales))
		}
		for _, l := range auth.Locales {
			want, ok := g[l]
			if !ok {
				t.Errorf("%s: no golden e-mails", l)
				continue
			}
			check := func(name string, got deletion.Mail, w goldenMail) {
				if got.Subject != w.Subject || got.Text != w.Text {
					t.Errorf("%s %s:\n got %q\n%q\nwant %q\n%q", l, name, got.Subject, got.Text, w.Subject, w.Text)
				}
			}
			check("requested_org", deletion.RequestedMail(at(t, "2026-11-12T09:30:00Z"), true, l), want.RequestedOrg)
			check("requested_account", deletion.RequestedMail(at(t, "2026-11-12T21:30:00Z"), false, l), want.RequestedAccount)
			check("code", deletion.CodeMail("482913", l), want.Code)
			check("completed", deletion.CompletedMail(l), want.Completed)
			for _, d := range want.Dates {
				if got := deletion.FormatDeletionDate(at(t, d[0]), l); got != d[1] {
					t.Errorf("%s %s: %q, want %q", l, d[0], got, d[1])
				}
			}
		}
		if got := deletion.FormatDeletionDate(at(t, "2026-11-12T21:30:00Z"), "de"); got != "12. November 2026 um 21:30 UTC" {
			t.Errorf("de = %q", got)
		}
		if got := deletion.FormatDeletionDate(at(t, "2026-11-12T21:30:00Z"), "es"); got != "12 de noviembre de 2026, 21:30 UTC" {
			t.Errorf("es = %q", got)
		}
	})

	t.Run("mail_test.ts/Farsçada tarih Miladi takvim ve Latin rakamla", func(t *testing.T) {
		got := deletion.FormatDeletionDate(at(t, "2026-11-12T21:30:00Z"), "fa")
		if !strings.Contains(got, "2026") || !strings.Contains(got, "نوامبر") || regexp.MustCompile(`[۰-۹]`).MatchString(got) {
			t.Errorf("fa = %q", got)
		}
	})

	t.Run("bilinmeyen dil İngilizce", func(t *testing.T) {
		v := at(t, "2026-11-12T09:30:00Z")
		if got, want := deletion.RequestedMail(v, true, "xx"), deletion.RequestedMail(v, true, "en"); got != want {
			t.Errorf("xx = %+v", got)
		}
	})
}
