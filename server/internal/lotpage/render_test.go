package lotpage

import (
	"fmt"
	"strings"
	"testing"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
)

// Expected values are Node's Intl output (ICU) in page.ts's locales.
func TestFormatNumber(t *testing.T) {
	in := []float64{17.25, 17.2, 1000, 12345.67, 1234567, 0.05, 0.04, 2.45, 9.95, 99.95, 14}
	want := map[string][]string{
		"tr": {"17,3", "17,2", "1.000", "12.345,7", "1.234.567", "0,1", "0", "2,5", "10", "100", "14"},
		"en": {"17.3", "17.2", "1,000", "12,345.7", "1,234,567", "0.1", "0", "2.5", "10", "100", "14"},
		"de": {"17,3", "17,2", "1.000", "12.345,7", "1.234.567", "0,1", "0", "2,5", "10", "100", "14"},
		"es": {"17,3", "17,2", "1000", "12.345,7", "1.234.567", "0,1", "0", "2,5", "10", "100", "14"},
		"pt": {"17,3", "17,2", "1.000", "12.345,7", "1.234.567", "0,1", "0", "2,5", "10", "100", "14"},
		"ru": {"17,3", "17,2", "1 000", "12 345,7", "1 234 567", "0,1", "0", "2,5", "10", "100", "14"},
		"uk": {"17,3", "17,2", "1 000", "12 345,7", "1 234 567", "0,1", "0", "2,5", "10", "100", "14"},
		"fa": {"17.3", "17.2", "1,000", "12,345.7", "1,234,567", "0.1", "0", "2.5", "10", "100", "14"},
		"hi": {"17.3", "17.2", "1,000", "12,345.7", "12,34,567", "0.1", "0", "2.5", "10", "100", "14"},
	}
	for lang, outs := range want {
		for i, v := range in {
			if got := FormatNumber(v, lang); got != outs[i] {
				t.Errorf("%s %v: %q, want %q", lang, v, got, outs[i])
			}
		}
	}
	if got := FormatNumber(-1.5, "fa"); got != "‎−1.5" {
		t.Errorf("fa -1.5: %q", got)
	}
}

func TestMonthLabel(t *testing.T) {
	want := map[string]string{
		"tr": "Eylül 2026", "en": "September 2026", "de": "September 2026",
		"es": "septiembre de 2026", "pt": "setembro de 2026", "ru": "сентябрь 2026 г.",
		"uk": "вересень 2026 р.", "fa": "سپتامبر 2026", "hi": "सितंबर 2026",
	}
	for lang, w := range want {
		if got := MonthLabel("2026-09", lang); got != w {
			t.Errorf("%s: %q, want %q", lang, got, w)
		}
	}
	for _, bad := range []string{"", "2026", "2026-13", "2026-00", "abcd-01"} {
		if got := MonthLabel(bad, "tr"); got != bad {
			t.Errorf("%q: %q", bad, got)
		}
	}
}

func TestInitials(t *testing.T) {
	cases := []struct{ name, lang, want string }{
		{"Yılmaz Arıcılık", "tr", "YA"},
		{"  ilhan   ışık arı ", "tr", "İI"},
		{"ilhan beekeeping", "en", "IB"},
		{"(Bal) 2. Kuşak", "tr", "B2"},
		{"Ali", "tr", "A"},
		{"", "tr", ""},
	}
	for _, c := range cases {
		if got := Initials(c.name, c.lang); got != c.want {
			t.Errorf("%q %s: %q, want %q", c.name, c.lang, got, c.want)
		}
	}
}

func TestPickAcceptLanguage(t *testing.T) {
	cases := map[string]string{
		"":                      "en",
		"tr-TR,tr;q=0.9":        "tr",
		"ja, de-DE;q=0.8":       "de",
		"pt_BR":                 "pt",
		"en-US,tr;q=0.5":        "en",
		"english,tr":            "en",
		"zh,ja":                 "en",
		" , ;q=1, fa-IR;q=0.3 ": "fa",
	}
	for header, want := range cases {
		if got := auth.PickAcceptLanguage(header); got != want {
			t.Errorf("%q: %q, want %q", header, got, want)
		}
	}
}

// Every app language has the page's wording, month names and number
// symbols, and renders both pages.
func TestEveryLanguage(t *testing.T) {
	for _, lang := range auth.Locales {
		tx, ok := textTable[lang]
		if !ok {
			t.Errorf("%s: no texts", lang)
			continue
		}
		for _, kind := range []string{"pine", "flower", "chestnut", "citrus", "other"} {
			if tx.Honey[kind] == "" {
				t.Errorf("%s: no honey kind %s", lang, kind)
			}
		}
		if strings.Count(tx.Hives, "%s") != 1 {
			t.Errorf("%s: hives format %q", lang, tx.Hives)
		}
		if _, ok := monthLabels[lang]; !ok {
			t.Errorf("%s: no month names", lang)
		}
		if _, ok := numberFormats[lang]; !ok {
			t.Errorf("%s: no number format", lang)
		}
		p := &Page{
			Number: "2026-07", HoneyKind: "pine", Origin: "Ula", HarvestMonth: "2026-09",
			Producer: &Producer{Name: "Yılmaz Arıcılık", HiveCount: 1200},
			Lab:      &Lab{Moisture: new(17.2), Residue: "detected"},
			Report:   &Report{FileKind: "photo"},
		}
		page := string(RenderPage(p, lang, "/l/x/report"))
		if !strings.Contains(page, fmt.Sprintf(`<html lang="%s"`, lang)) {
			t.Errorf("%s: html lang", lang)
		}
		for _, want := range []string{
			tx.Honey["pine"], tx.ResidueDetected, tx.Footer,
			fmt.Sprintf(tx.Hives, FormatNumber(1200, lang)), MonthLabel("2026-09", lang),
		} {
			if !strings.Contains(page, escape(want)) {
				t.Errorf("%s: page lacks %q", lang, want)
			}
		}
		if strings.Contains(page, "(PDF)") {
			t.Errorf("%s: a photo report is marked PDF", lang)
		}
		if nf := string(RenderNotFound(lang)); !strings.Contains(nf, escape(tx.NotFound)) || !strings.Contains(nf, escape(tx.NotFoundHint)) {
			t.Errorf("%s: not-found page", lang)
		}
	}
}

// escape is html/template's escaping of the few characters the texts use.
func escape(s string) string {
	return strings.NewReplacer("&", "&amp;", "<", "&lt;", ">", "&gt;", `"`, "&#34;", "'", "&#39;").Replace(s)
}

// Values are escaped: a name cannot open a tag.
func TestEscaping(t *testing.T) {
	p := &Page{Number: "2026-01", HoneyKind: "<b>", Origin: `"><script>alert(1)</script>`,
		Producer: &Producer{Name: "<img src=x>"}}
	page := string(RenderPage(p, "en", "/l/x/report"))
	for _, bad := range []string{"<script>", "<img"} {
		if strings.Contains(page, bad) {
			t.Errorf("unescaped %q", bad)
		}
	}
	if !strings.Contains(page, "&lt;img src=x&gt;") {
		t.Error("the name is not shown escaped")
	}
}
