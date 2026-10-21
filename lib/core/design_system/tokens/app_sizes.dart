import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Bileşen içi ölçüler (dp): ikon, gösterge noktası, illüstrasyon.
class AppSizes extends ThemeExtension<AppSizes> {
  const new({
    required this.iconSmall,
    required this.icon,
    required this.strengthDot,
    required this.queenDot,
    required this.illustration,
    required this.illustrationIcon,
  });

  static const standard = AppSizes(
    iconSmall: 20,
    icon: 24,
    strengthDot: 12,
    queenDot: 20,
    illustration: 96,
    illustrationIcon: 48,
  );

  /// Rozet ve chip içindeki ikonlar.
  final double iconSmall;

  /// Buton ve uyarı ikonları.
  final double icon;

  /// Güç puanı noktası (1–5).
  final double strengthDot;

  /// Ana arı renk noktası.
  final double queenDot;

  /// Boş durum altıgeni.
  final double illustration;

  /// Boş durum altıgenindeki ikon.
  final double illustrationIcon;

  @override
  AppSizes copyWith({
    double? iconSmall,
    double? icon,
    double? strengthDot,
    double? queenDot,
    double? illustration,
    double? illustrationIcon,
  }) {
    return AppSizes(
      iconSmall: iconSmall ?? this.iconSmall,
      icon: icon ?? this.icon,
      strengthDot: strengthDot ?? this.strengthDot,
      queenDot: queenDot ?? this.queenDot,
      illustration: illustration ?? this.illustration,
      illustrationIcon: illustrationIcon ?? this.illustrationIcon,
    );
  }

  @override
  AppSizes lerp(AppSizes? other, double t) {
    if (other == null) return this;
    return AppSizes(
      iconSmall: lerpDouble(iconSmall, other.iconSmall, t)!,
      icon: lerpDouble(icon, other.icon, t)!,
      strengthDot: lerpDouble(strengthDot, other.strengthDot, t)!,
      queenDot: lerpDouble(queenDot, other.queenDot, t)!,
      illustration: lerpDouble(illustration, other.illustration, t)!,
      illustrationIcon: lerpDouble(
        illustrationIcon,
        other.illustrationIcon,
        t,
      )!,
    );
  }
}
