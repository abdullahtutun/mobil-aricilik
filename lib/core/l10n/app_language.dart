import 'package:flutter/widgets.dart';

/// Arayüz dili. `system` cihaz dilini izler. Her dilin bir ARB dosyası
/// vardır; yeni dil önce `app_<kod>.arb` ile, sonra burada eklenir.
enum AppLanguage {
  system(null, ''),
  turkish(Locale('tr'), 'Türkçe'),
  english(Locale('en'), 'English'),
  german(Locale('de'), 'Deutsch'),
  spanish(Locale('es'), 'Español'),
  portuguese(Locale('pt'), 'Português'),
  russian(Locale('ru'), 'Русский'),
  ukrainian(Locale('uk'), 'Українська'),
  persian(Locale('fa'), 'فارسی'),
  hindi(Locale('hi'), 'हिन्दी');

  new(this.locale, this.nativeName);

  /// Null ise dil cihazdan çözülür ([resolveAppLocale]).
  final Locale? locale;

  /// Dilin kendi dilindeki adı (endonim). Dil seçicide her dil, arayüz
  /// hangi dilde olursa olsun böyle yazılır; bu yüzden ARB'de değil.
  /// [system] için boş, onun etiketi ARB'den gelir.
  final String nativeName;

  /// Seçilebilen diller: [system] dışındakiler.
  static List<AppLanguage> get selectable => [
    for (final language in values)
      if (language != system) language,
  ];

  /// Bu dilde PDF basılabilir mi. `pdf` paketi Devanagari harf
  /// birleşimlerini dizemez; Hintçe arayüzde raporlar İngilizce basılır.
  bool get supportsPdf => this != hindi;

  /// PDF dili seçicisindeki diller.
  static List<AppLanguage> get pdfSelectable => [
    for (final language in selectable)
      if (language.supportsPdf) language,
  ];

  /// [languageCode] arayüzünde varsayılan PDF dili: o dil, PDF'i
  /// basılamıyorsa İngilizce.
  static AppLanguage pdfLanguageFor(String languageCode) =>
      switch (fromLanguageCode(languageCode)) {
        final language when language.supportsPdf => language,
        _ => english,
      };

  /// [languageCode]'un dili; desteklenmiyorsa İngilizce.
  static AppLanguage fromLanguageCode(String languageCode) {
    for (final language in selectable) {
      if (language.locale!.languageCode == languageCode) return language;
    }
    return english;
  }
}

/// Cihaz dili desteklenmiyorsa kullanılan dil.
const fallbackLocale = Locale('en');

/// Cihazın tercih ettiği dillerden, sırayla ilk desteklenen dili seçer;
/// hiçbiri desteklenmiyorsa İngilizce. Yalnızca dil koduna bakar: `tr_TR`
/// da `tr_CY` de Türkçe açılır.
Locale resolveAppLocale(
  List<Locale>? preferredLocales,
  Iterable<Locale> supportedLocales,
) {
  for (final preferred in preferredLocales ?? const <Locale>[]) {
    for (final supported in supportedLocales) {
      if (supported.languageCode == preferred.languageCode) return supported;
    }
  }
  return fallbackLocale;
}
