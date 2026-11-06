import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/region/country_currencies.dart';
import 'package:mobil_arici/core/region/country_names.dart';

void main() {
  group('Ülke adları', () {
    test('para birimi tablosundaki her kodun her arayüz dilinde adı var', () {
      final codes = countryCurrencyCodes.keys.toSet();

      for (final language in AppLanguage.selectable) {
        final code = language.locale!.languageCode;
        final names = countryNamesFor(code);
        expect(names.keys.toSet(), codes, reason: code);
        expect(names.values, everyElement(isNotEmpty), reason: code);
        if (code != 'en') {
          expect(names, isNot(same(countryNamesEn)), reason: code);
        }
      }
    });

    test('bilinen adlar', () {
      expect(countryNamesTr['TR'], 'Türkiye');
      expect(countryNamesTr['DE'], 'Almanya');
      expect(countryNamesTr['XK'], 'Kosova');
      expect(countryNamesEn['TR'], 'Türkiye');
      expect(countryNamesEn['DE'], 'Germany');
      expect(countryNamesEn['GB'], 'United Kingdom');
      expect(countryNamesDe['DE'], 'Deutschland');
      expect(countryNamesEs['ES'], 'España');
    });

    test('Türkçe liste Türk alfabesi sırasında', () {
      final names = countryNamesTr.values.toList();
      int indexOf(String name) => names.indexOf(name);

      // C < Ç < D, I < İ, O < Ö < P, S < Ş < T, U < Ü < V
      expect(indexOf('Curaçao'), lessThan(indexOf('Çad')));
      expect(indexOf('Çin'), lessThan(indexOf('Danimarka')));
      expect(indexOf('Irak'), lessThan(indexOf('İran')));
      expect(indexOf('Özbekistan'), lessThan(indexOf('Pakistan')));
      expect(indexOf('Suriye'), lessThan(indexOf('Şili')));
      expect(indexOf('Şili'), lessThan(indexOf('Tayland')));
      expect(indexOf('Uganda'), lessThan(indexOf('Ürdün')));
    });

    test('İngilizce liste alfabe sırasında', () {
      final names = countryNamesEn.values.toList();

      expect(names.first, 'Afghanistan');
      expect(names.indexOf('Germany'), lessThan(names.indexOf('Ghana')));
    });

    test('tablosu olmayan dilde İngilizce adlar döner', () {
      expect(countryNamesFor('tr'), same(countryNamesTr));
      expect(countryNamesFor('en'), same(countryNamesEn));
      expect(countryNamesFor('de'), same(countryNamesDe));
      expect(countryNamesFor('ja'), same(countryNamesEn));
    });
  });
}
