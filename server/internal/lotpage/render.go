package lotpage

import (
	"bytes"
	"fmt"
	"html/template"
	"math"
	"strconv"
	"strings"
	"unicode"

	"github.com/abdullahtutun/mobil-aricilik/server/internal/auth"
)

// The page is page.ts's HTML (docs/design/Lot QR sayfası (müşteri)@1x.png)
// as an html/template: no outside resources, the CSS and the honeycomb
// inline, light and dark through prefers-color-scheme. The template escapes
// every value; the CSS and SVG are template text, not data.
var pageTemplate = template.Must(template.New("page").Parse(`<!doctype html>
<html lang="{{.Lang}}" dir="{{.Dir}}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex">
<title>{{.Title}}</title>
<style>
:root{--bg:#FFF6EA;--surface:#FFFFFF;--border:#EADFCB;--text:#1F1A14;
--muted:#6B5D4D;--hero:#6B4A1F;--accent:#F5C04A;--button:#9A5B00;
--button-text:#FFFFFF;--avatar:#2F5D4E}
@media (prefers-color-scheme:dark){:root{--bg:#17130E;--surface:#221C15;
--border:#3A3025;--text:#F3EBDD;--muted:#BDAE99;--hero:#4A3315;
--button:#C98A1E;--button-text:#1F1A14}}
*{box-sizing:border-box}
html{-webkit-text-size-adjust:100%}
body{margin:0;background:var(--bg);color:var(--text);
font:16px/1.4 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
main{max-width:560px;margin:0 auto;padding:0 16px 32px}
header{position:relative;overflow:hidden;background:var(--hero);color:#FFF;
padding:96px 16px 24px}
header svg{position:absolute;inset:0;width:100%;height:100%;opacity:.35}
header .wrap{position:relative;max-width:528px;margin:0 auto}
.lot{color:var(--accent);font-weight:700;letter-spacing:.12em;
text-transform:uppercase;font-size:14px;margin:0 0 4px}
h1{margin:0;font-size:34px;line-height:1.15;font-weight:800}
.sub{margin:6px 0 0;font-size:16px;opacity:.95}
.card{background:var(--surface);border:1px solid var(--border);
border-radius:16px;margin-top:16px}
.producer{display:flex;align-items:center;gap:14px;padding:14px 16px}
.avatar{flex:none;width:48px;height:48px;border-radius:50%;
background:var(--avatar);color:#FFF;display:grid;place-items:center;
font-weight:700;font-size:18px}
.producer b{display:block;font-size:18px}
.producer span{color:var(--muted);font-size:14px}
h2{margin:24px 0 8px;font-size:14px;letter-spacing:.08em;
text-transform:uppercase;color:var(--muted)}
.row{display:flex;justify-content:space-between;gap:12px;padding:16px;
border-top:1px solid var(--border)}
.row:first-child{border-top:0}
.row b{text-align:end}
.button{display:block;margin-top:16px;padding:16px;border-radius:12px;
background:var(--button);color:var(--button-text);text-align:center;
font-weight:700;font-size:17px;text-decoration:none;min-height:56px}
footer{margin-top:20px;text-align:center;color:var(--muted);font-size:13px}
.empty{padding:48px 0;text-align:center}
.empty p{color:var(--muted)}
</style>
</head>
<body>
{{- if .NotFound}}
<main class="empty"><h1>{{.Title}}</h1><p>{{.Hint}}</p></main>
{{- else}}
<header><svg viewBox="0 0 390 200" preserveAspectRatio="xMidYMid slice" aria-hidden="true"><g fill="none" stroke="#C9A25E" stroke-width="2">
{{- range .Honeycomb}}<polygon points="{{.}}"/>{{end -}}
</g></svg><div class="wrap">
<p class="lot">{{.LotLabel}}</p>
<h1>{{.Honey}}</h1>
{{- if .Subtitle}}
<p class="sub">{{.Subtitle}}</p>
{{- end}}
</div></header>
<main>
{{- with .Producer}}
<section class="card producer"><div class="avatar" aria-hidden="true">{{.Initials}}</div><div><b>{{.Name}}</b><span>{{.Hives}}</span></div></section>
{{- end}}
{{- if .LabTitle}}
<h2>{{.LabTitle}}</h2><section class="card">
{{- range .LabRows}}<div class="row"><span>{{.Label}}</span><b>{{.Value}}</b></div>{{end -}}
</section>
{{- end}}
{{- if .ReportHref}}
<a class="button" href="{{.ReportHref}}">{{.ReportLabel}}</a>
{{- end}}
<footer>{{.Footer}}</footer>
</main>
{{- end}}
</body>
</html>
`))

// honeycomb is the header's hexagons (page.ts honeycomb): centers, each
// with a 30 px radius.
var honeycomb = func() []string {
	out := []string{}
	for _, c := range [][2]int{{40, 30}, {100, 30}, {70, 82}, {330, 140}, {300, 192}} {
		x, y := c[0], c[1]
		out = append(out, fmt.Sprintf("%d,%d %d,%d %d,%d %d,%d %d,%d %d,%d",
			x, y-30, x+26, y-15, x+26, y+15, x, y+30, x-26, y+15, x-26, y-15))
	}
	return out
}()

type labRow struct{ Label, Value string }

type producerView struct{ Initials, Name, Hives string }

type view struct {
	Lang, Dir, Title string
	NotFound         bool
	Hint             string
	Honeycomb        []string
	LotLabel, Honey  string
	Subtitle         string
	Producer         *producerView
	LabTitle         string
	LabRows          []labRow
	ReportHref       string
	ReportLabel      string
	Footer           string
}

func textsFor(lang string) texts {
	if t, ok := textTable[lang]; ok {
		return t
	}
	return textTable["en"]
}

func baseView(lang string) view {
	dir := "ltr"
	if auth.IsRTL(lang) {
		dir = "rtl"
	}
	return view{Lang: lang, Dir: dir}
}

// RenderPage is the page of a published lot; reportHref is the report's
// address.
func RenderPage(p *Page, lang, reportHref string) []byte {
	t := textsFor(lang)
	honey, ok := t.Honey[p.HoneyKind]
	if !ok {
		honey = t.Honey["other"]
	}
	v := baseView(lang)
	v.Title = t.Lot + " " + p.Number + " · " + honey
	v.Honeycomb = honeycomb
	v.LotLabel = t.Lot + " " + p.Number
	v.Honey = honey
	v.Footer = t.Footer

	var sub []string
	if p.Origin != "" {
		sub = append(sub, p.Origin)
	}
	if p.HarvestMonth != "" {
		sub = append(sub, MonthLabel(p.HarvestMonth, lang))
	}
	v.Subtitle = strings.Join(sub, " · ")

	if pr := p.Producer; pr != nil {
		v.Producer = &producerView{
			Initials: Initials(pr.Name, lang),
			Name:     pr.Name,
			Hives:    fmt.Sprintf(t.Hives, FormatNumber(float64(pr.HiveCount), lang)),
		}
	}
	if lab := p.Lab; lab != nil {
		v.LabTitle = t.Lab
		if lab.Moisture != nil {
			v.LabRows = append(v.LabRows, labRow{t.Moisture, "%" + FormatNumber(*lab.Moisture, lang)})
		}
		if lab.HMF != nil {
			v.LabRows = append(v.LabRows, labRow{t.HMF, FormatNumber(*lab.HMF, lang) + " mg/kg"})
		}
		if lab.Diastase != nil {
			v.LabRows = append(v.LabRows, labRow{t.Diastase, FormatNumber(*lab.Diastase, lang)})
		}
		if lab.Proline != nil {
			v.LabRows = append(v.LabRows, labRow{t.Proline, FormatNumber(*lab.Proline, lang) + " mg/kg"})
		}
		switch lab.Residue {
		case "none":
			v.LabRows = append(v.LabRows, labRow{t.Residue, t.ResidueNone})
		case "detected":
			v.LabRows = append(v.LabRows, labRow{t.Residue, t.ResidueDetected})
		}
	}
	if p.Report != nil {
		v.ReportHref = reportHref
		v.ReportLabel = t.Report
		if p.Report.FileKind == "pdf" {
			v.ReportLabel += " (PDF)"
		}
	}
	return execute(v)
}

// RenderNotFound is the page of a lot that is not published, deleted or
// does not exist.
func RenderNotFound(lang string) []byte {
	t := textsFor(lang)
	v := baseView(lang)
	v.NotFound = true
	v.Title = t.NotFound
	v.Hint = t.NotFoundHint
	return execute(v)
}

func execute(v view) []byte {
	var b bytes.Buffer
	if err := pageTemplate.Execute(&b, v); err != nil {
		// The template and the view are fixed; only a programming error
		// gets here, and the tests render every language.
		panic(err)
	}
	return b.Bytes()
}

// Initials are the first letter or digit of the name's first two words,
// upper-cased in the language ("Yılmaz arıcılık" → "YA", Turkish "i" → "İ").
func Initials(name, lang string) string {
	var out []rune
	for _, word := range strings.Fields(name) {
		for _, r := range word {
			if unicode.IsLetter(r) || unicode.IsNumber(r) {
				if lang == "tr" {
					r = unicode.TurkishCase.ToUpper(r)
				} else {
					r = unicode.ToUpper(r)
				}
				out = append(out, r)
				break
			}
		}
		if len(out) == 2 {
			break
		}
	}
	return string(out)
}

// MonthLabel writes "2026-09" as the language's month and year ("Eylül
// 2026"); an unreadable value is returned as it is.
func MonthLabel(month, lang string) string {
	year, err1 := strconv.Atoi(month[:min(4, len(month))])
	m := 0
	if len(month) == 7 && month[4] == '-' {
		m, _ = strconv.Atoi(month[5:])
	}
	if err1 != nil || m < 1 || m > 12 {
		return month
	}
	l, ok := monthLabels[lang]
	if !ok {
		l = monthLabels["en"]
	}
	return fmt.Sprintf(l.Layout, l.Names[m-1], year)
}

// FormatNumber is Intl.NumberFormat(locale, {maximumFractionDigits: 1}):
// at most one decimal, halves rounded away from zero on the shortest
// decimal form of the number (2.45 → 2.5, as ICU does), grouped.
func FormatNumber(v float64, lang string) string {
	f, ok := numberFormats[lang]
	if !ok {
		f = numberFormats["en"]
	}
	if math.IsNaN(v) || math.IsInf(v, 0) {
		return strconv.FormatFloat(v, 'f', -1, 64)
	}
	neg := v < 0
	s := strconv.FormatFloat(math.Abs(v), 'f', -1, 64)
	intPart, frac, _ := strings.Cut(s, ".")
	digit := byte('0')
	if len(frac) > 0 {
		digit = frac[0]
	}
	if len(frac) > 1 && frac[1] >= '5' {
		// Carry through "…9.9".
		if digit < '9' {
			digit++
		} else {
			digit = '0'
			intPart = increment(intPart)
		}
	}
	out := group(intPart, f)
	if digit != '0' {
		out += f.Decimal + string(digit)
	}
	if neg && out != "0" {
		out = f.Minus + out
	}
	return out
}

// increment adds one to a decimal digit string.
func increment(s string) string {
	b := []byte(s)
	for i := len(b) - 1; i >= 0; i-- {
		if b[i] < '9' {
			b[i]++
			return string(b)
		}
		b[i] = '0'
	}
	return "1" + string(b)
}

func group(digits string, f numberFormat) string {
	if len(digits) <= 3 || (f.MinGroup && len(digits) == 4) {
		return digits
	}
	head, tail := digits[:len(digits)-3], digits[len(digits)-3:]
	size := 3
	if f.Indian {
		size = 2
	}
	var parts []string
	for len(head) > size {
		parts = append([]string{head[len(head)-size:]}, parts...)
		head = head[:len(head)-size]
	}
	parts = append([]string{head}, parts...)
	return strings.Join(append(parts, tail), f.Group)
}
