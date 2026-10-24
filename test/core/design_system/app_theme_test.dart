import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';

void main() {
  group('AppTheme', () {
    const standard = AppearanceSettings();
    const sun = AppearanceSettings(colorMode: AppColorMode.sun);
    const glove = AppearanceSettings(gloveMode: true);

    test('her mod birleşiminde tüm token uzantıları temada', () {
      for (final mode in AppColorMode.values) {
        for (final gloveMode in [false, true]) {
          final settings = AppearanceSettings(
            colorMode: mode,
            gloveMode: gloveMode,
          );
          for (final theme in [
            AppTheme.light(settings),
            AppTheme.dark(settings),
          ]) {
            expect(theme.extension<AppColors>(), isNotNull);
            expect(theme.extension<AppTypography>(), isNotNull);
            expect(theme.extension<AppSpacing>(), isNotNull);
            expect(theme.extension<AppRadii>(), isNotNull);
            expect(theme.extension<AppTouchTargets>(), isNotNull);
            expect(theme.extension<AppStrokes>(), isNotNull);
            expect(theme.extension<AppSizes>(), isNotNull);
          }
        }
      }
    });

    test('standart açık ve koyu kendi paletlerini kullanır', () {
      final light = AppTheme.light(standard);
      final dark = AppTheme.dark(standard);

      expect(light.extension<AppColors>(), same(AppColors.light));
      expect(light.brightness, Brightness.light);
      expect(dark.extension<AppColors>(), same(AppColors.dark));
      expect(dark.brightness, Brightness.dark);
    });

    test('ColorScheme tokenlardan gelir', () {
      final scheme = AppTheme.light(standard).colorScheme;
      const c = AppColors.light;

      expect(scheme.primary, c.primary);
      expect(scheme.onPrimary, c.onPrimary);
      expect(scheme.secondary, c.secondary);
      expect(scheme.surface, c.surface);
      expect(scheme.surfaceContainerLow, c.surfaceContainer);
      expect(scheme.onSurface, c.textPrimary);
      expect(scheme.onSurfaceVariant, c.textSecondary);
      expect(scheme.error, c.statusCritical);
      expect(scheme.outline, c.outline);
    });

    test('metin teması Inter, tabular ve token rengiyle', () {
      final textTheme = AppTheme.light(standard).textTheme;

      expect(textTheme.bodyMedium!.fontFamily, 'Inter');
      expect(textTheme.bodyMedium!.fontSize, 16);
      expect(textTheme.bodyMedium!.color, AppColors.light.textPrimary);
      expect(
        textTheme.displayLarge!.fontFeatures,
        contains(const FontFeature.tabularFigures()),
      );
    });

    test('güneş modu cihaz koyu olsa da beyaz zemin, gölgesiz', () {
      for (final theme in [AppTheme.light(sun), AppTheme.dark(sun)]) {
        expect(theme.extension<AppColors>(), same(AppColors.sun));
        expect(theme.brightness, Brightness.light);
        expect(theme.scaffoldBackgroundColor, const Color(0xFFFFFFFF));
        expect(theme.colorScheme.shadow.a, 0);
        expect(theme.shadowColor.a, 0);
        expect(theme.extension<AppStrokes>(), same(AppStrokes.sun));
      }
    });

    test('eldiven modu hedefleri ve Material yoğunluğunu büyütür', () {
      final theme = AppTheme.light(glove);

      expect(theme.extension<AppTouchTargets>(), same(AppTouchTargets.glove));
      expect(
        theme.visualDensity,
        const VisualDensity(horizontal: 2, vertical: 2),
      );
      expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
      // Renkler standart kalır.
      expect(theme.extension<AppColors>(), same(AppColors.light));
    });

    test('standart modda yoğunluk Material varsayılanı', () {
      final theme = AppTheme.light(standard);

      expect(theme.visualDensity, VisualDensity.standard);
      expect(
        theme.extension<AppTouchTargets>(),
        same(AppTouchTargets.standard),
      );
    });

    test('saha modlarında gövde 18, standartta 16', () {
      double? body(AppearanceSettings s) =>
          AppTheme.light(s).extension<AppTypography>()!.body.fontSize;

      expect(body(standard), 16);
      expect(body(sun), 18);
      expect(body(glove), 18);
    });

    test('güneş ve eldiven birlikte açılabilir', () {
      const both = AppearanceSettings(
        colorMode: AppColorMode.sun,
        gloveMode: true,
      );
      final theme = AppTheme.light(both);

      expect(theme.extension<AppColors>(), same(AppColors.sun));
      expect(theme.extension<AppTouchTargets>(), same(AppTouchTargets.glove));
    });

    test('metin alanları çerçeveli; köşe buton yarıçapında', () {
      final border = AppTheme.light(standard).inputDecorationTheme.border;

      expect(
        border,
        isA<OutlineInputBorder>().having(
          (b) => b.borderRadius,
          'borderRadius',
          BorderRadius.circular(AppRadii.standard.button),
        ),
      );
    });

    test('themeMode renk moduna göre seçilir', () {
      ThemeMode modeOf(AppColorMode m) =>
          AppTheme.themeMode(AppearanceSettings(colorMode: m));

      expect(modeOf(AppColorMode.system), ThemeMode.system);
      expect(modeOf(AppColorMode.light), ThemeMode.light);
      expect(modeOf(AppColorMode.dark), ThemeMode.dark);
      expect(modeOf(AppColorMode.sun), ThemeMode.light);
    });
  });
}
