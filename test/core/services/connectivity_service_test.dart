import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/connectivity_service.dart';

/// [online] değerlerinden kaç kez yeniden bağlanıldığı.
Future<int> _reconnections(List<bool> online) async =>
    (await reconnections(Stream.fromIterable(online)).toList()).length;

void main() {
  group('reconnections', () {
    test('ilk değer geçiş sayılmaz', () async {
      expect(await _reconnections([true]), 0);
      expect(await _reconnections([false]), 0);
    });

    test('çevrimdışından çevrimiçine her geçişte bir olay', () async {
      expect(await _reconnections([false, true]), 1);
      expect(await _reconnections([true, false, true, false, true]), 2);
    });

    test('aynı durumun tekrarı olay sayılmaz', () async {
      expect(await _reconnections([true, true, true]), 0);
      expect(await _reconnections([false, false, true, true]), 1);
    });
  });
}
