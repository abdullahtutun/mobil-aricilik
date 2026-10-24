import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/appearance_settings.dart';
import 'package:mobil_arici/core/design_system/tokens/app_colors.dart';
import 'package:mobil_arici/core/design_system/tokens/app_radii.dart';
import 'package:mobil_arici/core/design_system/tokens/app_sizes.dart';
import 'package:mobil_arici/core/design_system/tokens/app_spacing.dart';
import 'package:mobil_arici/core/design_system/tokens/app_strokes.dart';
import 'package:mobil_arici/core/design_system/tokens/app_touch_targets.dart';
import 'package:mobil_arici/core/design_system/tokens/app_typography.dart';

/// Tokenlardan Material 3 temaları üretir.
///
/// `MaterialApp` için: `theme: AppTheme.light(s)`,
/// `darkTheme: AppTheme.dark(s)`, `themeMode: AppTheme.themeMode(s)`.
abstract final class AppTheme {
  static ThemeData light(AppearanceSettings settings) =>
      _fromSettings(settings, Brightness.light);

  /// Güneş modunda bu da güneş temasıdır; cihaz koyu olsa bile.
  static ThemeData dark(AppearanceSettings settings) =>
      _fromSettings(settings, Brightness.dark);

  static ThemeMode themeMode(AppearanceSettings settings) {
    return switch (settings.colorMode) {
      AppColorMode.system => ThemeMode.system,
      AppColorMode.light || AppColorMode.sun => ThemeMode.light,
      AppColorMode.dark => ThemeMode.dark,
    };
  }

  static ThemeData _fromSettings(
    AppearanceSettings settings,
    Brightness brightness,
  ) {
    final sun = settings.colorMode == AppColorMode.sun;
    final field = sun || settings.gloveMode;
    return build(
      brightness: sun ? Brightness.light : brightness,
      colors: sun
          ? AppColors.sun
          : brightness == Brightness.dark
          ? AppColors.dark
          : AppColors.light,
      typography: field ? AppTypography.field : AppTypography.standard,
      touchTargets: settings.gloveMode
          ? AppTouchTargets.glove
          : AppTouchTargets.standard,
      strokes: sun ? AppStrokes.sun : AppStrokes.standard,
    );
  }

  static ThemeData build({
    required Brightness brightness,
    required AppColors colors,
    required AppTypography typography,
    required AppTouchTargets touchTargets,
    required AppStrokes strokes,
    AppSpacing spacing = AppSpacing.standard,
    AppRadii radii = AppRadii.standard,
    AppSizes sizes = AppSizes.standard,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      tertiary: colors.honey,
      onTertiary: colors.textPrimary,
      error: colors.statusCritical,
      onError: colors.onStatus,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      surfaceContainerLowest: colors.tile,
      surfaceContainerLow: colors.surfaceContainer,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainer,
      surfaceContainerHighest: colors.surfaceContainer,
      outline: colors.outline,
      outlineVariant: colors.divider,
      shadow: colors.shadow,
      inverseSurface: colors.inverseSurface,
      onInverseSurface: colors.onInverseSurface,
      inversePrimary: colors.inversePrimary,
      // Yükseltide primary tonu bindirilmesin; kart zemini tokendan gelir.
      surfaceTint: const Color(0x00000000),
    );

    // Material bileşenleri yoğunlukla büyür: her kademe 4dp.
    final density = ((touchTargets.minimum - kMinInteractiveDimension) / 4)
        .clamp(VisualDensity.minimumDensity, VisualDensity.maximumDensity);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: typography.toTextTheme().apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      scaffoldBackgroundColor: colors.surface,
      shadowColor: colors.shadow,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity(horizontal: density, vertical: density),
      // Metin alanları çerçeveli; eldivenle dokunulacak yer belli olsun.
      inputDecorationTheme: InputDecorationThemeData(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radii.button),
        ),
      ),
      // Bildirim: koyu mürekkep zemin, bal sarısı eylem; altta yüzer.
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.inverseSurface,
        contentTextStyle: typography.body.copyWith(
          color: colors.onInverseSurface,
        ),
        actionTextColor: colors.inversePrimary,
        behavior: SnackBarBehavior.floating,
        // Koyu zemin içerikten zaten ayrılıyor; gölge kalın kenar gibi çizilir.
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.button),
        ),
      ),
      extensions: [
        colors,
        typography,
        spacing,
        radii,
        touchTargets,
        strokes,
        sizes,
      ],
    );
  }
}
