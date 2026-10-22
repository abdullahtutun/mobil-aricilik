import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/country_currencies.dart';
import 'package:mobil_arici/core/region/country_names.dart';

void main() {
  group('Ülke adları', () {
    test('para birimi tablosundaki her kodun iki dilde de adı var', () {
      final codes = countryCurrencyCodes.keys.toSet();

      expect(countryNamesTr.keys.toSet(), codes);
      expect(countryNamesEn.keys.toSet(), codes);
      expect(countryNamesTr.values, everyElement(isNotEmpty));
      expect(countryNamesEn.values, everyElement(isNotEmpty));
    });

    test('bilinen adlar', () {
      expect(countryNamesTr['TR'], 'Türkiye');
      expect(countryNamesTr['DE'], 'Almanya');
      expect(countryNamesTr['XK'], 'Kosova');
      expect(countryNamesEn['TR'], 'Türkiye');
      expect(countryNamesEn['DE'], 'Germany');
      expect(countryNamesEn['GB'], 'United Kingdom');
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

    test('Türkçe dışındaki dillerde İngilizce adlar döner', () {
      expect(countryNamesFor('tr'), same(countryNamesTr));
      expect(countryNamesFor('en'), same(countryNamesEn));
      expect(countryNamesFor('de'), same(countryNamesEn));
    });
  });
}
