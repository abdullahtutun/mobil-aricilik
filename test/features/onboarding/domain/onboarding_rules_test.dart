import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/onboarding/domain/onboarding_rules.dart';

void main() {
  group('suggestCountryCode', () {
    test('ilk dildeki ülke önerilir', () {
      expect(
        suggestCountryCode(const [Locale('tr', 'TR'), Locale('en', 'US')]),
        'TR',
      );
      expect(suggestCountryCode(const [Locale('en', 'DE')]), 'DE');
    });

    test('ülkesiz dil atlanır, sıradaki dile bakılır', () {
      expect(
        suggestCountryCode(const [Locale('en'), Locale('de', 'AT')]),
        'AT',
      );
    });

    test('bölge kodu ülke değilse atlanır', () {
      // es_419: Latin Amerika İspanyolcası.
      expect(
        suggestCountryCode(const [Locale('es', '419'), Locale('es', 'MX')]),
        'MX',
      );
    });

    test('ülke yoksa öneri yok', () {
      expect(suggestCountryCode(const [Locale('en')]), isNull);
      expect(suggestCountryCode(const []), isNull);
    });
  });

  group('matchesCountryQuery', () {
    bool matches(String query, {String code = 'TR', String name = 'Türkiye'}) =>
        matchesCountryQuery(code: code, name: name, query: query);

    test('boş arama her ülkeyle eşleşir', () {
      expect(matches(''), isTrue);
      expect(matches('   '), isTrue);
    });

    test('ad içinde harf büyüklüğü gözetmeden aranır', () {
      expect(matches('TÜRK'), isTrue);
      expect(matches('kiye'), isTrue);
      expect(matches('alman'), isFalse);
    });

    test('Türkçe harfler ve aksanlar gözetilmez', () {
      expect(matches('turkiye'), isTrue);
      expect(matches('ingiltere', code: 'GB', name: 'İngiltere'), isTrue);
      expect(matches('İNGİLTERE', code: 'GB', name: 'İngiltere'), isTrue);
      expect(matches('irak', code: 'IQ', name: 'Irak'), isTrue);
      expect(matches('cote', code: 'CI', name: 'Côte d’Ivoire'), isTrue);
      expect(matches("d'ivoire", code: 'CI', name: 'Côte d’Ivoire'), isTrue);
      expect(matches('curacao', code: 'CW', name: 'Curaçao'), isTrue);
      expect(matches('aland', code: 'AX', name: 'Åland Adaları'), isTrue);
    });

    test('ISO kodu tam eşleşir', () {
      expect(matches('de', code: 'DE', name: 'Almanya'), isTrue);
      expect(matches(' DE ', code: 'DE', name: 'Almanya'), isTrue);
      expect(matches('d', code: 'DE', name: 'Kanada'), isTrue);
      expect(matches('dx', code: 'DE', name: 'Almanya'), isFalse);
    });
  });
}
