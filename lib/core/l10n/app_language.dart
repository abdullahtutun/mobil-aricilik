import 'package:flutter/widgets.dart';

/// Arayüz dili. `system` cihaz dilini izler. Her dilin bir ARB dosyası
/// vardır; yeni dil önce `app_<kod>.arb` ile, sonra burada eklenir.
enum AppLanguage {
  system(null, ''),
  turkish(Locale('tr'), 'Türkçe'),
  english(Locale('en'), 'English');

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
