import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/uuid.dart';

void main() {
  group('generateId', () {
    test('UUIDv7 üretir', () {
      expect(
        generateId(),
        matches(
          RegExp(
            '^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-'
            r'[0-9a-f]{12}$',
          ),
        ),
      );
    });

    test('her çağrıda farklı; zaman damgası geriye gitmez', () async {
      final ids = <String>[];
      for (var i = 0; i < 20; i++) {
        ids.add(generateId());
        await Future<void>.delayed(const Duration(milliseconds: 2));
      }

      expect(ids.toSet(), hasLength(20));
      // İlk 48 bit milisaniye cinsinden zaman; aynı milisaniyede sıra yok.
      expect([...ids]..sort(), ids);
    });
  });
}
