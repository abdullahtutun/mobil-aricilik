import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/design_system/tokens/app_colors.dart';

import '../contrast.dart';

Map<String, Color> _statuses(AppColors c) => {
  'statusGood': c.statusGood,
  'statusWarning': c.statusWarning,
  'statusCritical': c.statusCritical,
  'statusInfo': c.statusInfo,
};

Map<String, Color> _texts(AppColors c) => {
  'textPrimary': c.textPrimary,
  'textSecondary': c.textSecondary,
  'primary': c.primary,
  'secondary': c.secondary,
};

Map<String, Color> _backgrounds(AppColors c) => {
  'surface': c.surface,
  'surfaceContainer': c.surfaceContainer,
};

void main() {
  group('contrastRatio', () {
    test('siyah/beyaz 21, aynı renk 1', () {
      const black = Color(0xFF000000);
      const white = Color(0xFFFFFFFF);
      expect(contrastRatio(black, white), closeTo(21, 0.01));
      expect(contrastRatio(white, black), closeTo(21, 0.01));
      expect(contrastRatio(white, white), 1);
    });
  });

  group('AppColors', () {
    for (final (name, colors) in [
      ('açık', AppColors.light),
      ('koyu', AppColors.dark),
    ]) {
      group('standart $name', () {
        test('metin ve vurgu renkleri zeminlerde en az 4.5:1', () {
          for (final bg in _backgrounds(colors).entries) {
            for (final fg in _texts(colors).entries) {
              expectContrast(
                fg.value,
                bg.value,
                atLeast: 4.5,
                reason: '${fg.key} / ${bg.key}',
              );
            }
          }
        });

        test('dolgu üstündeki on- renkleri en az 4.5:1', () {
          expectContrast(
            colors.onPrimary,
            colors.primary,
            atLeast: 4.5,
            reason: 'onPrimary / primary',
          );
          expectContrast(
            colors.onSecondary,
            colors.secondary,
            atLeast: 4.5,
            reason: 'onSecondary / secondary',
          );
          for (final status in _statuses(colors).entries) {
            expectContrast(
              colors.onStatus,
              status.value,
              atLeast: 4.5,
              reason: 'onStatus / ${status.key}',
            );
          }
        });

        test('durum renkleri ve kenarlık zeminlerde en az 3:1', () {
          final ui = {..._statuses(colors), 'outline': colors.outline};
          for (final bg in _backgrounds(colors).entries) {
            for (final fg in ui.entries) {
              expectContrast(
                fg.value,
                bg.value,
                atLeast: 3,
                reason: '${fg.key} / ${bg.key}',
              );
            }
          }
        });
      });
    }

    group('güneş modu', () {
      const sun = AppColors.sun;

      test('zemin saf beyaz, metin siyah, gölge yok', () {
        expect(sun.surface, const Color(0xFFFFFFFF));
        expect(sun.surfaceContainer, const Color(0xFFFFFFFF));
        expect(sun.textPrimary, const Color(0xFF000000));
        expect(sun.shadow.a, 0);
      });

      test('her metin, durum ve kenarlık zeminde en az 7:1', () {
        final all = {..._texts(sun), ..._statuses(sun), 'outline': sun.outline};
        for (final fg in all.entries) {
          expectContrast(
            fg.value,
            sun.surface,
            atLeast: 7,
            reason: '${fg.key} / surface',
          );
        }
      });

      test('dolgu üstündeki on- renkleri en az 7:1', () {
        expectContrast(
          sun.onPrimary,
          sun.primary,
          atLeast: 7,
          reason: 'onPrimary / primary',
        );
        expectContrast(
          sun.onSecondary,
          sun.secondary,
          atLeast: 7,
          reason: 'onSecondary / secondary',
        );
        for (final status in _statuses(sun).entries) {
          expectContrast(
            sun.onStatus,
            status.value,
            atLeast: 7,
            reason: 'onStatus / ${status.key}',
          );
        }
      });
    });

    test('lerp uçlarda kaynak paletleri verir', () {
      final start = AppColors.light.lerp(AppColors.dark, 0);
      final end = AppColors.light.lerp(AppColors.dark, 1);

      expect(start.primary, AppColors.light.primary);
      expect(start.surface, AppColors.light.surface);
      expect(end.primary, AppColors.dark.primary);
      expect(end.surface, AppColors.dark.surface);
    });

    test('lerp null ile kendini döndürür', () {
      expect(AppColors.light.lerp(null, 0.5), same(AppColors.light));
    });

    test('copyWith yalnızca verilen alanı değiştirir', () {
      const red = Color(0xFFFF0000);
      final copy = AppColors.light.copyWith(primary: red);

      expect(copy.primary, red);
      expect(copy.surface, AppColors.light.surface);
      expect(copy.onStatus, AppColors.light.onStatus);
    });
  });
}
