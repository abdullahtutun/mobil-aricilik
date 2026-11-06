// Fonksiyonların ortak dil kuralı: uygulamanın desteklediği diller ve
// gelen değerden (user_metadata.locale, Accept-Language) dil seçimi.
// Yeni dil uygulamaya eklenince buraya da eklenir; metin tabloları
// `Record<AppLocale, …>` olduğundan eksik çeviri tür hatası verir.

export const supportedLocales = ["tr", "en"] as const;

export type AppLocale = typeof supportedLocales[number];

/// Desteklenmeyen ya da bilinmeyen dilde kullanılan dil.
export const fallbackLocale: AppLocale = "en";

/// "de", "de-DE", "pt_BR" gibi bir değerin dili; desteklenmiyorsa
/// [fallbackLocale].
export function pickLocale(value: unknown): AppLocale {
  if (typeof value !== "string") return fallbackLocale;
  const code = value.trim().toLowerCase().split(/[-_]/)[0];
  return (supportedLocales as readonly string[]).includes(code)
    ? code as AppLocale
    : fallbackLocale;
}

/// Accept-Language başlığındaki dillerden, tarayıcının sırasıyla ilk
/// desteklenen; hiçbiri değilse [fallbackLocale]. Ağırlıklar (q)
/// gözetilmez, tarayıcılar listeyi zaten ağırlık sırasıyla yollar.
export function pickAcceptLanguage(header: string | null): AppLocale {
  for (const part of (header ?? "").split(",")) {
    const tag = part.split(";")[0].trim();
    if (!tag) continue;
    const locale = pickLocale(tag);
    if (locale !== fallbackLocale || tag.toLowerCase().startsWith(fallbackLocale)) {
      return locale;
    }
  }
  return fallbackLocale;
}
