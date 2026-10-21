import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/app/deep_link.dart';

void main() {
  group('deepLinkLocation', () {
    String? location(String link) => deepLinkLocation(Uri.parse(link));

    test('host ilk yol parçası olur', () {
      expect(location('mobilaricilik://hives/42'), '/hives/42');
      expect(location('mobilaricilik://more/settings'), '/more/settings');
      expect(location('mobilaricilik://tasks'), '/tasks');
    });

    test('sorgu ve parça korunur', () {
      expect(
        location('mobilaricilik://hives/42?tab=history#top'),
        '/hives/42?tab=history#top',
      );
    });

    test('kodlanmış yol parçaları olduğu gibi kalır', () {
      expect(
        location('mobilaricilik://apiaries/%C3%87am%20Tepe'),
        '/apiaries/%C3%87am%20Tepe',
      );
    });

    test('hostsuz biçimler de çalışır', () {
      expect(location('mobilaricilik:///hives/42'), '/hives/42');
      expect(location('mobilaricilik:hives/42'), '/hives/42');
    });

    test('boş link Bugün olur', () {
      expect(location('mobilaricilik://'), '/');
      expect(location('mobilaricilik:'), '/');
    });

    test('başka şema ya da uygulama içi konum çevrilmez', () {
      expect(location('/more/settings'), isNull);
      expect(location('https://mobilaricilik.app/hives/42'), isNull);
      expect(location('mobilaricilik-dev://hives/42'), isNull);
    });
  });
}
