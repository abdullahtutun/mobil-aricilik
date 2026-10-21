import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/l10n/app_language.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

void main() {
  group('resolveAppLocale', () {
    Locale resolve(List<Locale>? preferred) =>
        resolveAppLocale(preferred, AppLocalizations.supportedLocales);

    test('desteklenen cihaz dili seçilir; ülke kodu fark etmez', () {
      expect(resolve(const [Locale('tr', 'TR')]), const Locale('tr'));
      expect(resolve(const [Locale('en', 'GB')]), const Locale('en'));
    });

    test('desteklenmeyen dilde İngilizce', () {
      expect(resolve(const [Locale('de', 'DE')]), const Locale('en'));
      // Ülke Türkiye olsa da dil Almanca; Türkçe seçilmez.
      expect(resolve(const [Locale('de', 'TR')]), const Locale('en'));
    });

    test('cihaz dili bilinmiyorsa İngilizce', () {
      expect(resolve(null), const Locale('en'));
      expect(resolve(const []), const Locale('en'));
    });

    test('ilk dil desteklenmiyorsa sıradaki desteklenen dil seçilir', () {
      expect(resolve(const [Locale('de'), Locale('tr')]), const Locale('tr'));
    });
  });

  group('AppLanguage', () {
    test('system dili cihaza bırakır, diğerleri sabitler', () {
      expect(AppLanguage.system.locale, isNull);
      expect(AppLanguage.turkish.locale, const Locale('tr'));
      expect(AppLanguage.english.locale, const Locale('en'));
    });

    test('seçilebilen her dil ve yedek dil destekleniyor', () {
      for (final language in AppLanguage.values) {
        if (language.locale case final locale?) {
          expect(AppLocalizations.supportedLocales, contains(locale));
        }
      }
      expect(AppLocalizations.supportedLocales, contains(fallbackLocale));
    });
  });
}
