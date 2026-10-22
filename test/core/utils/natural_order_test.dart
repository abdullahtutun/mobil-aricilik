import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';

List<String> _sorted(List<String> names) => [...names]..sort(compareNatural);

void main() {
  group('compareNatural', () {
    test('Türkçe harfler kendi harflerinin ardından gelir', () {
      expect(
        _sorted(['Yayla', 'Çamlık', 'Cevizli', 'Dere', 'Ova', 'Ören', 'Pınar']),
        ['Cevizli', 'Çamlık', 'Dere', 'Ova', 'Ören', 'Pınar', 'Yayla'],
      );
      expect(_sorted(['Şile', 'Sarı', 'Tepe']), ['Sarı', 'Şile', 'Tepe']);
      expect(_sorted(['Ulus', 'Üzüm', 'Vadi']), ['Ulus', 'Üzüm', 'Vadi']);
      expect(_sorted(['Gürgen', 'Ğ', 'Hisar']), ['Gürgen', 'Ğ', 'Hisar']);
    });

    test('ı, i’den önce; İ ve I, i sayılır', () {
      expect(_sorted(['ilica', 'ılıca', 'hisar']), ['hisar', 'ılıca', 'ilica']);
      expect(compareNatural('İnce', 'ince'), isNot(0));
      expect(_sorted(['Irmak', 'İnce', 'ılgın', 'ince']), [
        'ılgın',
        'ince',
        'İnce',
        'Irmak',
      ]);
    });

    test('büyük-küçük harf sırayı değiştirmez', () {
      expect(_sorted(['yayla', 'Ova', 'çamlık']), ['çamlık', 'Ova', 'yayla']);
    });

    test('sayılar değerine göre', () {
      expect(_sorted(['Arılık 10', 'Arılık 2', 'Arılık 1', 'Arılık']), [
        'Arılık',
        'Arılık 1',
        'Arılık 2',
        'Arılık 10',
      ]);
      expect(_sorted(['A-100', 'A-20', 'A-3']), ['A-3', 'A-20', 'A-100']);
      expect(_sorted(['007', '7', '08']), ['007', '7', '08']);
    });

    test('çok uzun sayılar taşmadan karşılaştırılır', () {
      expect(
        compareNatural(
          'Arılık 99999999999999999999',
          'Arılık 100000000000000000000',
        ),
        lessThan(0),
      );
    });

    test('eşit sayılan adlar metin sırasıyla ayrılır; sıra kararlı', () {
      expect(compareNatural('Yayla', 'yayla'), 'Yayla'.compareTo('yayla'));
      expect(compareNatural('Yayla', 'Yayla'), 0);
      expect(compareNatural('', 'Yayla'), lessThan(0));
      expect(compareNatural('Yayla', ''), greaterThan(0));
    });
  });
}
