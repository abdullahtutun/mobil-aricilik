import 'package:flutter/widgets.dart';

/// Arayüz dili. `system` cihaz dilini izler.
enum AppLanguage {
  system(null),
  turkish(Locale('tr')),
  english(Locale('en'));

  new(this.locale);

  /// Null ise dil cihazdan çözülür ([resolveAppLocale]).
  final Locale? locale;
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
