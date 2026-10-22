import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/tokens/app_colors.dart';
import 'package:mobil_arici/core/design_system/tokens/app_radii.dart';
import 'package:mobil_arici/core/design_system/tokens/app_sizes.dart';
import 'package:mobil_arici/core/design_system/tokens/app_spacing.dart';
import 'package:mobil_arici/core/design_system/tokens/app_strokes.dart';
import 'package:mobil_arici/core/design_system/tokens/app_touch_targets.dart';
import 'package:mobil_arici/core/design_system/tokens/app_typography.dart';

/// Tokenlara kısa erişim: `context.colors.primary`, `context.spacing.md`.
extension AppThemeTokens on BuildContext {
  AppColors get colors => _token<AppColors>();
  AppTypography get typography => _token<AppTypography>();
  AppSpacing get spacing => _token<AppSpacing>();
  AppRadii get radii => _token<AppRadii>();
  AppTouchTargets get touchTargets => _token<AppTouchTargets>();
  AppStrokes get strokes => _token<AppStrokes>();
  AppSizes get sizes => _token<AppSizes>();

  T _token<T extends ThemeExtension<T>>() {
    final token = Theme.of(this).extension<T>();
    assert(token != null, '$T temada yok; tema AppTheme ile kurulmalı.');
    return token!;
  }
}
