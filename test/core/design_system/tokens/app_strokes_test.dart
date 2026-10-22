import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/design_system/tokens/app_strokes.dart';

void main() {
  group('AppStrokes', () {
    test('güneş modunda kenarlıklar daha kalın', () {
      expect(AppStrokes.sun.border, greaterThan(AppStrokes.standard.border));
      expect(AppStrokes.sun.focus, greaterThan(AppStrokes.standard.focus));
    });

    test('odak kenarlığı normal kenarlıktan kalın', () {
      for (final s in [AppStrokes.standard, AppStrokes.sun]) {
        expect(s.focus, greaterThan(s.border));
      }
    });

    test('lerp uçlarda kaynak değerleri verir, null ile kendini döndürür', () {
      expect(AppStrokes.standard.lerp(AppStrokes.sun, 0).border, 1);
      expect(AppStrokes.standard.lerp(AppStrokes.sun, 1).border, 2);
      expect(AppStrokes.standard.lerp(null, 0.5), same(AppStrokes.standard));
    });
  });
}
