import 'package:flutter/material.dart';

/// Tipografi ölçeği: Inter, tüm stillerde tabular rakamlar.
///
/// Renk içermez; renk temadan (`textPrimary`) gelir.
class AppTypography extends ThemeExtension<AppTypography> {
  const new({
    required this.display,
    required this.numberLarge,
    required this.number,
    required this.headline,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.bodySmall,
    required this.caption,
    required this.label,
    required this.labelSmall,
    required this.button,
    required this.navLabel,
  });

  factory _scale({
    required double body,
    required double bodySmall,
    required double caption,
    required double label,
    required double button,
  }) {
    return AppTypography(
      display: _style(64, FontWeight.w700, 1),
      numberLarge: _style(36, FontWeight.w700, 1.1),
      number: _style(28, FontWeight.w700, 1.15),
      headline: _style(26, FontWeight.w700, 1.25),
      title: _style(20, FontWeight.w700, 1.3),
      subtitle: _style(16, FontWeight.w600, 1.35),
      body: _style(body, FontWeight.w400, 1.5),
      bodySmall: _style(bodySmall, FontWeight.w400, 1.45),
      caption: _style(caption, FontWeight.w400, 1.4),
      label: _style(label, FontWeight.w600, 1.25),
      labelSmall: _style(bodySmall, FontWeight.w600, 1.45),
      button: _style(button, FontWeight.w700, 1.25),
      navLabel: _style(12, FontWeight.w600, 1.3),
    );
  }

  static const fontFamily = 'Inter';

  /// Inter'de olmayan yazılar için gömülü yedek fontlar: Vazirmatn (Farsça,
  /// Arap yazısı) ve Noto Sans Devanagari (Hintçe). Yeni yazı sistemi
  /// buraya eklenir.
  static const fontFamilyFallback = ['Vazirmatn', 'NotoSansDevanagari'];

  /// Gövde 15.
  static final standard = AppTypography._scale(
    body: 15,
    bodySmall: 13,
    caption: 12,
    label: 15,
    button: 17,
  );

  /// Saha modları (güneş, eldiven): gövde 16.
  static final field = AppTypography._scale(
    body: 16,
    bodySmall: 14,
    caption: 13,
    label: 16,
    button: 18,
  );

  /// Kovan kartındaki dev numara; ekranın konusu olan tek sayı.
  final TextStyle display;

  /// Kovan no gibi ilk bakışta yakalanması gereken sayılar.
  final TextStyle numberLarge;

  /// kg, çerçeve sayısı gibi büyük sayılar.
  final TextStyle number;
  final TextStyle headline;
  final TextStyle title;
  final TextStyle subtitle;
  final TextStyle body;
  final TextStyle bodySmall;

  /// Yoğun tablo başlıkları ve hücreleri; [bodySmall]'dan bir punto küçük.
  final TextStyle caption;

  /// Buton ve chip etiketleri.
  final TextStyle label;

  /// Alt gezinme gibi dar yerlerdeki etiketler; [bodySmall] boyunda, kalın.
  final TextStyle labelSmall;

  /// Büyük buton etiketi; [label]'dan bir kademe büyük ve kalın.
  final TextStyle button;

  /// Alt gezinmedeki sekme adları; dört sekme ve Okut 360dp'ye sığsın diye
  /// iki ölçekte de 12.
  final TextStyle navLabel;

  static TextStyle _style(double size, FontWeight weight, double height) {
    return TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: 0,
    );
  }

  /// Material bileşenlerinin varsayılan stilleri bu ölçekten gelsin diye.
  TextTheme toTextTheme() {
    final materialLabelSmall = bodySmall.copyWith(fontWeight: FontWeight.w500);
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
      labelMedium: materialLabelSmall,
      labelSmall: materialLabelSmall,
    );
  }

  @override
  AppTypography copyWith({
    TextStyle? display,
    TextStyle? numberLarge,
    TextStyle? number,
    TextStyle? headline,
    TextStyle? title,
    TextStyle? subtitle,
    TextStyle? body,
    TextStyle? bodySmall,
    TextStyle? caption,
    TextStyle? label,
    TextStyle? labelSmall,
    TextStyle? button,
    TextStyle? navLabel,
  }) {
    return AppTypography(
      display: display ?? this.display,
      numberLarge: numberLarge ?? this.numberLarge,
      number: number ?? this.number,
      headline: headline ?? this.headline,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      body: body ?? this.body,
      bodySmall: bodySmall ?? this.bodySmall,
      caption: caption ?? this.caption,
      label: label ?? this.label,
      labelSmall: labelSmall ?? this.labelSmall,
      button: button ?? this.button,
      navLabel: navLabel ?? this.navLabel,
    );
  }

  @override
  AppTypography lerp(AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      display: TextStyle.lerp(display, other.display, t)!,
      numberLarge: TextStyle.lerp(numberLarge, other.numberLarge, t)!,
      number: TextStyle.lerp(number, other.number, t)!,
      headline: TextStyle.lerp(headline, other.headline, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      subtitle: TextStyle.lerp(subtitle, other.subtitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      labelSmall: TextStyle.lerp(labelSmall, other.labelSmall, t)!,
      button: TextStyle.lerp(button, other.button, t)!,
      navLabel: TextStyle.lerp(navLabel, other.navLabel, t)!,
    );
  }
}
