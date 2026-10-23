import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/design_system/tokens/app_sizes.dart';

void main() {
  group('AppSizes', () {
    const standard = AppSizes.standard;

    test("tüm değerler 4'ün katı", () {
      for (final v in [
        standard.iconSmall,
        standard.icon,
        standard.strengthDot,
        standard.queenDot,
        standard.illustration,
        standard.illustrationIcon,
        standard.hiveTile,
      ]) {
        expect(v % 4, 0, reason: '$v');
      }
    });

    test('küçük ikon < ikon, güç noktası < ana noktası, ikon < altıgen', () {
      expect(standard.iconSmall, lessThan(standard.icon));
      expect(standard.strengthDot, lessThan(standard.queenDot));
      expect(standard.illustrationIcon, lessThan(standard.illustration));
    });

    test('lerp ara değer üretir, null ile kendini döndürür', () {
      final half = standard.lerp(standard.copyWith(icon: 32), 0.5);

      expect(half.icon, 28);
      expect(half.queenDot, standard.queenDot);
      expect(standard.lerp(null, 0.5), same(standard));
    });

    test('copyWith yalnızca verilen alanı değiştirir', () {
      final copy = standard.copyWith(strengthDot: 16);

      expect(copy.strengthDot, 16);
      expect(copy.icon, standard.icon);
    });
  });
}
