import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/design_system/tokens/app_radii.dart';

void main() {
  group('AppRadii', () {
    test('kart 16, buton 12, küçük öğe 8', () {
      expect(AppRadii.standard.card, 16);
      expect(AppRadii.standard.button, 12);
      expect(AppRadii.standard.small, 8);
    });

    test('lerp ara değer üretir, null ile kendini döndürür', () {
      final half = AppRadii.standard.lerp(
        AppRadii.standard.copyWith(card: 24),
        0.5,
      );

      expect(half.card, 20);
      expect(half.button, 12);
      expect(AppRadii.standard.lerp(null, 0.5), same(AppRadii.standard));
    });
  });
}
