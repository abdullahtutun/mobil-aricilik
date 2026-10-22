import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/design_system/tokens/app_touch_targets.dart';

void main() {
  group('AppTouchTargets', () {
    const standard = AppTouchTargets.standard;
    const glove = AppTouchTargets.glove;

    test('standart: en az 48, saha eylemleri 56–64, aralık en az 8', () {
      expect(standard.minimum, 48);
      expect(standard.field, inInclusiveRange(56, 64));
      expect(standard.fieldLarge, inInclusiveRange(56, 64));
      expect(standard.gap, greaterThanOrEqualTo(8));
    });

    test('eldiven: her hedef bir kademe (8dp) büyük', () {
      expect(glove.minimum, standard.minimum + 8);
      expect(glove.field, standard.field + 8);
      expect(glove.fieldLarge, standard.fieldLarge + 8);
      expect(glove.gap, greaterThan(standard.gap));
    });

    test("her modda hedefler küçükten büyüğe sıralı ve 4'ün katı", () {
      for (final t in [standard, glove]) {
        expect(t.minimum, lessThan(t.field));
        expect(t.field, lessThan(t.fieldLarge));
        for (final v in [t.minimum, t.field, t.fieldLarge, t.gap]) {
          expect(v % 4, 0, reason: '$v');
        }
      }
    });

    test('lerp uçlarda kaynak ölçüleri verir, null ile kendini döndürür', () {
      expect(standard.lerp(glove, 0).minimum, standard.minimum);
      expect(standard.lerp(glove, 1).minimum, glove.minimum);
      expect(standard.lerp(null, 0.5), same(standard));
    });

    test('copyWith yalnızca verilen alanı değiştirir', () {
      final copy = standard.copyWith(gap: 16);

      expect(copy.gap, 16);
      expect(copy.minimum, standard.minimum);
    });
  });
}
