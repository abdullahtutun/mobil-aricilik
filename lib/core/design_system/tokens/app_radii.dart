import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Köşe yarıçapı tokenları.
class AppRadii extends ThemeExtension<AppRadii> {
  const new({
    required this.small,
    required this.button,
    required this.card,
    required this.pill,
  });

  static const standard = AppRadii(small: 8, button: 12, card: 16, pill: 999);

  /// Chip, girdi alanı gibi küçük öğeler.
  final double small;
  final double button;
  final double card;

  /// Chip ve durum rozeti: kenarları tam yuvarlak.
  final double pill;

  @override
  AppRadii copyWith({
    double? small,
    double? button,
    double? card,
    double? pill,
  }) {
    return AppRadii(
      small: small ?? this.small,
      button: button ?? this.button,
      card: card ?? this.card,
      pill: pill ?? this.pill,
    );
  }

  @override
  AppRadii lerp(AppRadii? other, double t) {
    if (other == null) return this;
    return AppRadii(
      small: lerpDouble(small, other.small, t)!,
      button: lerpDouble(button, other.button, t)!,
      card: lerpDouble(card, other.card, t)!,
      pill: lerpDouble(pill, other.pill, t)!,
    );
  }
}
