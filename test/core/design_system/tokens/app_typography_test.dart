import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/design_system/tokens/app_typography.dart';

List<TextStyle> _styles(AppTypography t) => [
  t.numberLarge,
  t.number,
  t.headline,
  t.title,
  t.subtitle,
  t.body,
  t.bodySmall,
  t.label,
];

void main() {
  group('AppTypography', () {
    for (final (name, typography) in [
      ('standart', AppTypography.standard),
      ('saha', AppTypography.field),
    ]) {
      group(name, () {
        test('tüm stiller Inter ve tabular rakamlı', () {
          for (final style in _styles(typography)) {
            expect(style.fontFamily, 'Inter');
            expect(
              style.fontFeatures,
              contains(const FontFeature.tabularFigures()),
            );
          }
        });

        test('başlık 22/28, büyük sayılar 32–40 kalın', () {
          expect(typography.title.fontSize, 22);
          expect(typography.headline.fontSize, 28);
          expect(typography.number.fontSize, 32);
          expect(typography.numberLarge.fontSize, 40);
          expect(typography.number.fontWeight, FontWeight.w700);
          expect(typography.numberLarge.fontWeight, FontWeight.w700);
        });

        test('Material metin teması aynı ölçekten gelir', () {
          final textTheme = typography.toTextTheme();

          expect(textTheme.bodyMedium, typography.body);
          expect(textTheme.bodyLarge, typography.body);
          expect(textTheme.labelLarge, typography.label);
          expect(textTheme.titleLarge, typography.title);
          expect(textTheme.headlineMedium, typography.headline);
          expect(textTheme.displayLarge, typography.numberLarge);
        });
      });
    }

    test('gövde standartta 16, sahada 18', () {
      expect(AppTypography.standard.body.fontSize, 16);
      expect(AppTypography.field.body.fontSize, 18);
    });

    test('saha ölçeğinde hiçbir stil küçülmez', () {
      final standard = _styles(AppTypography.standard);
      final field = _styles(AppTypography.field);
      for (var i = 0; i < standard.length; i++) {
        expect(field[i].fontSize, greaterThanOrEqualTo(standard[i].fontSize!));
      }
    });

    test('lerp uçlarda kaynak ölçekleri verir', () {
      final start = AppTypography.standard.lerp(AppTypography.field, 0);
      final end = AppTypography.standard.lerp(AppTypography.field, 1);

      expect(start.body.fontSize, 16);
      expect(end.body.fontSize, 18);
    });

    test('lerp null ile kendini döndürür', () {
      expect(
        AppTypography.standard.lerp(null, 0.5),
        same(AppTypography.standard),
      );
    });

    test('copyWith yalnızca verilen alanı değiştirir', () {
      const body = TextStyle(fontSize: 20);
      final copy = AppTypography.standard.copyWith(body: body);

      expect(copy.body, body);
      expect(copy.title, AppTypography.standard.title);
    });
  });
}
