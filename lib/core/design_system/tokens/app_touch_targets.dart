import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Dokunma hedefi ölçüleri (dp).
class AppTouchTargets extends ThemeExtension<AppTouchTargets> {
  const new({
    required this.minimum,
    required this.field,
    required this.button,
    required this.fieldLarge,
    required this.gap,
  });

  /// Material asgarisi 48; saha eylemleri 56–64.
  static const standard = AppTouchTargets(
    minimum: 48,
    field: 56,
    button: 60,
    fieldLarge: 64,
    gap: 8,
  );

  /// Eldiven modu: tüm hedefler bir kademe (8dp) büyük.
  static const glove = AppTouchTargets(
    minimum: 56,
    field: 64,
    button: 68,
    fieldLarge: 72,
    gap: 12,
  );

  /// Her dokunulabilir öğenin asgari boyu/eni.
  final double minimum;

  /// Sahada sık kullanılan eylemler (chip, stepper +/−).
  final double field;

  /// Büyük buton (`BigButton`): Kaydet, Muayene başlat.
  final double button;

  /// Ekranın en büyük saha hedefi (Okut, kovan karosu).
  final double fieldLarge;

  /// Yan yana iki hedef arasındaki asgari boşluk.
  final double gap;

  @override
  AppTouchTargets copyWith({
    double? minimum,
    double? field,
    double? button,
    double? fieldLarge,
    double? gap,
  }) {
    return AppTouchTargets(
      minimum: minimum ?? this.minimum,
      field: field ?? this.field,
      button: button ?? this.button,
      fieldLarge: fieldLarge ?? this.fieldLarge,
      gap: gap ?? this.gap,
    );
  }

  @override
  AppTouchTargets lerp(AppTouchTargets? other, double t) {
    if (other == null) return this;
    return AppTouchTargets(
      minimum: lerpDouble(minimum, other.minimum, t)!,
      field: lerpDouble(field, other.field, t)!,
      button: lerpDouble(button, other.button, t)!,
      fieldLarge: lerpDouble(fieldLarge, other.fieldLarge, t)!,
      gap: lerpDouble(gap, other.gap, t)!,
    );
  }
}
