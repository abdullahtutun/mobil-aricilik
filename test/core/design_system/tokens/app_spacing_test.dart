import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/design_system/tokens/app_spacing.dart';

List<double> _values(AppSpacing s) => [
  s.xs,
  s.sm,
  s.md,
  s.lg,
  s.xl,
  s.xxl,
  s.xxxl,
];

void main() {
  group('AppSpacing', () {
    test("tüm değerler 4'ün katı ve artan sırada", () {
      final values = _values(AppSpacing.standard);
      for (final v in values) {
        expect(v % 4, 0, reason: '$v');
      }
      for (var i = 1; i < values.length; i++) {
        expect(values[i], greaterThan(values[i - 1]));
      }
    });

    test('temel adımlar 4 ve 8', () {
      expect(AppSpacing.standard.xs, 4);
      expect(AppSpacing.standard.sm, 8);
    });

    test('lerp ara değer üretir, null ile kendini döndürür', () {
      final half = AppSpacing.standard.lerp(
        AppSpacing.standard.copyWith(lg: 24),
        0.5,
      );

      expect(half.lg, 20);
      expect(half.sm, 8);
      expect(AppSpacing.standard.lerp(null, 0.5), same(AppSpacing.standard));
    });
  });
}
