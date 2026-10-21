import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/region/country_currencies.dart';

void main() {
  group('countryCurrencyCodes', () {
    test('Antarktika dışındaki 248 ISO 3166-1 ülkesi ve Kosova var', () {
      expect(countryCurrencyCodes, hasLength(249));
      expect(countryCurrencyCodes, isNot(contains('AQ')));
      expect(countryCurrencyCodes, contains('XK'));
    });

    test('anahtarlar iki, değerler üç büyük harf', () {
      final countryCode = RegExp(r'^[A-Z]{2}$');
      final currencyCode = RegExp(r'^[A-Z]{3}$');
      for (final MapEntry(key: country, value: currency)
          in countryCurrencyCodes.entries) {
        expect(country, matches(countryCode));
        expect(currency, matches(currencyCode), reason: country);
      }
    });

    test('euro bölgesi ülkelerinde EUR', () {
      const euroArea = [
        'AT', 'BE', 'BG', 'CY', 'DE', 'EE', 'ES', 'FI', 'FR', 'GR', 'HR', //
        'IE', 'IT', 'LT', 'LU', 'LV', 'MT', 'NL', 'PT', 'SI', 'SK',
      ];
      for (final code in euroArea) {
        expect(countryCurrencyCodes[code], 'EUR', reason: code);
      }
    });

    test(
      'kendi para birimi olmayan ülkeler bağlı oldukları birimi kullanır',
      () {
        expect(countryCurrencyCodes['EC'], 'USD');
        expect(countryCurrencyCodes['PR'], 'USD');
        expect(countryCurrencyCodes['LI'], 'CHF');
        expect(countryCurrencyCodes['GL'], 'DKK');
        expect(countryCurrencyCodes['ME'], 'EUR');
      },
    );

    test('yakın zamanda değişen para birimleri güncel', () {
      expect(countryCurrencyCodes['BG'], 'EUR');
      expect(countryCurrencyCodes['HR'], 'EUR');
      expect(countryCurrencyCodes['SL'], 'SLE');
      expect(countryCurrencyCodes['ZW'], 'ZWG');
      expect(countryCurrencyCodes['CW'], 'XCG');
      expect(countryCurrencyCodes['SX'], 'XCG');
    });
  });

  group('currencyCodeFor', () {
    test('tablodaki ülkenin para birimi', () {
      expect(currencyCodeFor('TR'), 'TRY');
      expect(currencyCodeFor('US'), 'USD');
      expect(currencyCodeFor('GB'), 'GBP');
    });

    test('tabloda olmayan kodda yedek para birimi', () {
      expect(fallbackCurrencyCode, 'USD');
      expect(currencyCodeFor('AQ'), fallbackCurrencyCode);
      expect(currencyCodeFor('ZZ'), fallbackCurrencyCode);
    });
  });
}
