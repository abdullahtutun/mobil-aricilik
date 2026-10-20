import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Köşe yarıçapı tokenları.
class AppRadii extends ThemeExtension<AppRadii> {
  const new({required this.small, required this.button, required this.card});

  static const standard = AppRadii(small: 8, button: 12, card: 16);

  /// Chip, girdi alanı gibi küçük öğeler.
  final double small;
  final double button;
  final double card;

  @override
  AppRadii copyWith({double? small, double? button, double? card}) {
    return AppRadii(
      small: small ?? this.small,
      button: button ?? this.button,
      card: card ?? this.card,
    );
  }

  @override
  AppRadii lerp(AppRadii? other, double t) {
    if (other == null) return this;
    return AppRadii(
      small: lerpDouble(small, other.small, t)!,
      button: lerpDouble(button, other.button, t)!,
      card: lerpDouble(card, other.card, t)!,
    );
  }
}
