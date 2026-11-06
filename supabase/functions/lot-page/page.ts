// Lot sayfasının HTML'i (docs/design/Lot QR sayfası (müşteri)@1x.png).
// Saf fonksiyonlar; veri `public.lot_public_page`'ten gelir ve yalnız
// owner'ın seçtiği alanları taşır. Dış kaynak yok: CSS ve desen satır içi.

import { type AppLocale, pickAcceptLanguage } from "../_shared/locale.ts";

export type Lang = AppLocale;

export interface LotPageData {
  number: string;
  honey_kind: string;
  producer?: { name: string; hive_count: number };
  origin?: string;
  // YYYY-MM
  harvest_month?: string;
  lab?: {
    tested_on: string;
    hmf?: number;
    diastase?: number;
    proline?: number;
    moisture?: number;
    residue?: "none" | "detected";
  };
  report?: { document_id: string; file_kind: "pdf" | "photo" };
}

// `satisfies`: her desteklenen dilin metni olmalı.
const text = {
  tr: {
    lot: "Lot",
    honey: {
      pine: "Çam balı",
      flower: "Çiçek balı",
      chestnut: "Kestane balı",
      citrus: "Narenciye balı",
      other: "Bal",
    } as Record<string, string>,
    hives: (count: string) => `${count} kovan`,
    lab: "Laboratuvar analizi",
    moisture: "Nem",
    hmf: "HMF",
    diastase: "Diastaz sayısı",
    proline: "Prolin",
    residue: "İlaç kalıntısı",
    residueNone: "Tespit edilmedi",
    residueDetected: "Tespit edildi",
    report: "Analiz raporunu aç",
    footer: "Bu sayfa üretici tarafından Mobil Arıcı ile yayımlandı.",
    notFound: "Bu lot yayımda değil",
    notFoundHint:
      "Sayfa kaldırılmış ya da adres hatalı olabilir. Ürünle ilgili sorular için üreticiye başvurun.",
  },
  en: {
    lot: "Lot",
    honey: {
      pine: "Pine honey",
      flower: "Flower honey",
      chestnut: "Chestnut honey",
      citrus: "Citrus honey",
      other: "Honey",
    } as Record<string, string>,
    hives: (count: string) => `${count} hives`,
    lab: "Laboratory analysis",
    moisture: "Moisture",
    hmf: "HMF",
    diastase: "Diastase number",
    proline: "Proline",
    residue: "Drug residue",
    residueNone: "Not detected",
    residueDetected: "Detected",
    report: "Open analysis report",
    footer: "This page was published by the producer with Mobil Arıcı.",
    notFound: "This lot is not published",
    notFoundHint:
      "The page may have been removed or the address may be wrong. Contact the producer about the product.",
  },
} satisfies Record<Lang, unknown>;

/// Accept-Language'da sırayla ilk desteklenen dil; yoksa İngilizce.
export const pickLang = pickAcceptLanguage;

export function escapeHtml(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

/// İşletme adının en çok iki baş harfi ("Yılmaz Arıcılık" → "YA").
export function initials(name: string, lang: Lang): string {
  return name
    .split(/\s+/)
    .map((word) => word.match(/\p{L}|\p{N}/u)?.[0] ?? "")
    .filter((letter) => letter)
    .slice(0, 2)
    .join("")
    .toLocaleUpperCase(lang);
}

function locale(lang: Lang): string {
  return lang === "tr" ? "tr-TR" : "en-GB";
}

function number(value: number, lang: Lang): string {
  return new Intl.NumberFormat(locale(lang), { maximumFractionDigits: 1 })
    .format(value);
}

/// "2026-09" → "Eylül 2026".
export function monthLabel(month: string, lang: Lang): string {
  const [year, monthIndex] = month.split("-").map(Number);
  return new Intl.DateTimeFormat(locale(lang), {
    month: "long",
    year: "numeric",
    timeZone: "UTC",
  }).format(new Date(Date.UTC(year, monthIndex - 1, 1)));
}

const styles = `
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
.row b{text-align:right}
.button{display:block;margin-top:16px;padding:16px;border-radius:12px;
background:var(--button);color:var(--button-text);text-align:center;
font-weight:700;font-size:17px;text-decoration:none;min-height:56px}
footer{margin-top:20px;text-align:center;color:var(--muted);font-size:13px}
.empty{padding:48px 0;text-align:center}
.empty p{color:var(--muted)}
`;

// Başlıktaki petek deseni.
const honeycomb =
  `<svg viewBox="0 0 390 200" preserveAspectRatio="xMidYMid slice" aria-hidden="true">` +
  `<g fill="none" stroke="#C9A25E" stroke-width="2">` +
  [[40, 30], [100, 30], [70, 82], [330, 140], [300, 192]]
    .map(([x, y]) =>
      `<polygon points="${x},${y - 30} ${x + 26},${y - 15} ${x + 26},${y + 15} ${x},${y + 30} ${x - 26},${y + 15} ${x - 26},${y - 15}"/>`
    )
    .join("") +
  `</g></svg>`;

function document(lang: Lang, title: string, body: string): string {
  return `<!doctype html>
<html lang="${lang}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex">
<title>${escapeHtml(title)}</title>
<style>${styles}</style>
</head>
<body>
${body}
</body>
</html>`;
}

/// Yayımdaki lotun sayfası. [reportHref] raporun adresi (sayfaya göre).
export function renderLotPage(
  data: LotPageData,
  lang: Lang,
  reportHref: string,
): string {
  const t = text[lang];
  const honey = t.honey[data.honey_kind] ?? t.honey.other;
  const subtitle = [
    data.origin,
    data.harvest_month ? monthLabel(data.harvest_month, lang) : undefined,
  ].filter((part): part is string => !!part);

  const parts: string[] = [];
  if (data.producer) {
    const { name, hive_count } = data.producer;
    parts.push(
      `<section class="card producer">` +
        `<div class="avatar" aria-hidden="true">${escapeHtml(initials(name, lang))}</div>` +
        `<div><b>${escapeHtml(name)}</b>` +
        `<span>${escapeHtml(t.hives(number(hive_count, lang)))}</span></div>` +
        `</section>`,
    );
  }
  if (data.lab) {
    const lab = data.lab;
    const rows: [string, string][] = [];
    if (lab.moisture != null) {
      rows.push([t.moisture, `%${number(lab.moisture, lang)}`]);
    }
    if (lab.hmf != null) rows.push([t.hmf, `${number(lab.hmf, lang)} mg/kg`]);
    if (lab.diastase != null) {
      rows.push([t.diastase, number(lab.diastase, lang)]);
    }
    if (lab.proline != null) {
      rows.push([t.proline, `${number(lab.proline, lang)} mg/kg`]);
    }
    if (lab.residue != null) {
      rows.push([
        t.residue,
        lab.residue === "none" ? t.residueNone : t.residueDetected,
      ]);
    }
    parts.push(
      `<h2>${escapeHtml(t.lab)}</h2><section class="card">` +
        rows
          .map(([label, value]) =>
            `<div class="row"><span>${escapeHtml(label)}</span><b>${escapeHtml(value)}</b></div>`
          )
          .join("") +
        `</section>`,
    );
  }
  if (data.report) {
    const suffix = data.report.file_kind === "pdf" ? " (PDF)" : "";
    parts.push(
      `<a class="button" href="${escapeHtml(reportHref)}">${escapeHtml(t.report + suffix)}</a>`,
    );
  }

  return document(
    lang,
    `${t.lot} ${data.number} · ${honey}`,
    `<header>${honeycomb}<div class="wrap">` +
      `<p class="lot">${escapeHtml(`${t.lot} ${data.number}`)}</p>` +
      `<h1>${escapeHtml(honey)}</h1>` +
      (subtitle.length
        ? `<p class="sub">${escapeHtml(subtitle.join(" · "))}</p>`
        : "") +
      `</div></header>` +
      `<main>${parts.join("")}<footer>${escapeHtml(t.footer)}</footer></main>`,
  );
}

/// Yayımda olmayan, silinmiş ya da olmayan lot.
export function renderNotFound(lang: Lang): string {
  const t = text[lang];
  return document(
    lang,
    t.notFound,
    `<main class="empty"><h1>${escapeHtml(t.notFound)}</h1>` +
      `<p>${escapeHtml(t.notFoundHint)}</p></main>`,
  );
}
