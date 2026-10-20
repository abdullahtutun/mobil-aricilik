import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Kenarlık kalınlıkları.
class AppStrokes extends ThemeExtension<AppStrokes> {
  const new({required this.border, required this.focus});

  static const standard = AppStrokes(border: 1, focus: 2);

  /// Güneş modu: kalın kenarlıklar.
  static const sun = AppStrokes(border: 2, focus: 3);

  /// Kart, buton, girdi kenarlığı.
  final double border;

  /// Odaklanmış/seçili öğe kenarlığı.
  final double focus;

  @override
  AppStrokes copyWith({double? border, double? focus}) {
    return AppStrokes(
      border: border ?? this.border,
      focus: focus ?? this.focus,
    );
  }

  @override
  AppStrokes lerp(AppStrokes? other, double t) {
    if (other == null) return this;
    return AppStrokes(
      border: lerpDouble(border, other.border, t)!,
      focus: lerpDouble(focus, other.focus, t)!,
    );
  }
}
