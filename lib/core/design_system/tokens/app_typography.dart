import 'package:flutter/material.dart';

/// Tipografi ölçeği: Inter, tüm stillerde tabular rakamlar.
///
/// Renk içermez; renk temadan (`textPrimary`) gelir.
class AppTypography extends ThemeExtension<AppTypography> {
  const new({
    required this.numberLarge,
    required this.number,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bodySmall,
    required this.label,
  });

  factory _scale({
    required double body,
    required double bodySmall,
    required double label,
  }) {
    return AppTypography(
      numberLarge: _style(40, FontWeight.w700, 1.1),
      number: _style(32, FontWeight.w700, 1.15),
      headline: _style(28, FontWeight.w700, 1.25),
      title: _style(22, FontWeight.w600, 1.3),
      subtitle: _style(18, FontWeight.w600, 1.35),
      body: _style(body, FontWeight.w400, 1.5),
      bodySmall: _style(bodySmall, FontWeight.w400, 1.45),
      label: _style(label, FontWeight.w600, 1.25),
    );
  }

  static const fontFamily = 'Inter';

  /// Gövde 16.
  static final standard = AppTypography._scale(
    body: 16,
    bodySmall: 14,
    label: 16,
  );

  /// Saha modları (güneş, eldiven): gövde 18.
  static final field = AppTypography._scale(body: 18, bodySmall: 16, label: 18);

  /// Kovan no gibi ilk bakışta yakalanması gereken sayılar.
  final TextStyle numberLarge;

  /// kg, çerçeve sayısı gibi büyük sayılar.
  final TextStyle number;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle bodySmall;

  /// Buton ve chip etiketleri.
  final TextStyle label;

  static TextStyle _style(double size, FontWeight weight, double height) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: 0,
    );
  }

  /// Material bileşenlerinin varsayılan stilleri bu ölçekten gelsin diye.
  TextTheme toTextTheme() {
    final labelSmall = bodySmall.copyWith(fontWeight: FontWeight.w500);
    return TextTheme(
      displayLarge: numberLarge,
      displayMedium: number,
      displaySmall: number,
      headlineLarge: headline,
      headlineMedium: headline,
      headlineSmall: title,
      titleLarge: title,
      titleMedium: subtitle,
      titleSmall: label,
      bodyLarge: body,
      bodyMedium: body,
      bodySmall: bodySmall,
      labelLarge: label,
      labelMedium: labelSmall,
      labelSmall: labelSmall,
    );
  }

  @override
  AppTypography copyWith({
    TextStyle? numberLarge,
    TextStyle? number,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? label,
  }) {
    return AppTypography(
      numberLarge: numberLarge ?? this.numberLarge,
      number: number ?? this.number,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      bodySmall: bodySmall ?? this.bodySmall,
      label: label ?? this.label,
    );
  }

  @override
  AppTypography lerp(AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      numberLarge: TextStyle.lerp(numberLarge, other.numberLarge, t)!,
      number: TextStyle.lerp(number, other.number, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
    );
  }
}
