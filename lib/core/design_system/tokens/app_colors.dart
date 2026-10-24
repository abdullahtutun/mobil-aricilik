import 'package:flutter/material.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart'
    show QueenMarkColor;

/// Renk tokenları (teknik.md §7).
///
/// Durum renkleri tek başına anlam taşımaz; her zaman ikon ve kelimeyle
/// birlikte kullanılır. Durum rengi zemin üzerinde ikon/kenarlık olarak
/// (en az 3:1), dolgu olarak kullanıldığında üstündeki yazı [onStatus] ile
/// (en az 4.5:1) gösterilir.
class AppColors extends ThemeExtension<AppColors> {
  const new({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.surfaceContainer,
    required this.textPrimary,
    required this.textSecondary,
    required this.outline,
    required this.divider,
    required this.shadow,
    required this.statusGood,
    required this.statusWarning,
    required this.statusCritical,
    required this.statusInfo,
    required this.onStatus,
    required this.queenWhite,
    required this.queenYellow,
    required this.queenRed,
    required this.queenGreen,
    required this.queenBlue,
  });

  /// Standart açık tema. Primary ve warning, teknik.md önerisinden bir ton
  /// koyu: beyaz yazıyla 4.5:1 sağlansın diye.
  static const light = AppColors(
    primary: Color(0xFF995A00),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF2F5D50),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFF8EE),
    surfaceContainer: Color(0xFFF6EBDA),
    textPrimary: Color(0xFF1F1A14),
    textSecondary: Color(0xFF5E554A),
    outline: Color(0xFF857868),
    divider: Color(0xFFE2D4BF),
    shadow: Color(0xFF000000),
    statusGood: Color(0xFF2E7D32),
    statusWarning: Color(0xFFB33F00),
    statusCritical: Color(0xFFC62828),
    statusInfo: Color(0xFF1565C0),
    onStatus: Color(0xFFFFFFFF),
    queenWhite: Color(0xFFFFFFFF),
    queenYellow: Color(0xFFFDD835),
    queenRed: Color(0xFFE53935),
    queenGreen: Color(0xFF43A047),
    queenBlue: Color(0xFF1E88E5),
  );

  /// Standart koyu tema.
  static const dark = AppColors(
    primary: Color(0xFFFFB74D),
    onPrimary: Color(0xFF2B1700),
    secondary: Color(0xFF8CC7B4),
    onSecondary: Color(0xFF0B261E),
    surface: Color(0xFF17140F),
    surfaceContainer: Color(0xFF231F18),
    textPrimary: Color(0xFFF3ECE2),
    textSecondary: Color(0xFFBDB2A4),
    outline: Color(0xFF8F8476),
    divider: Color(0xFF3B342A),
    shadow: Color(0xFF000000),
    statusGood: Color(0xFF81C784),
    statusWarning: Color(0xFFFFAB40),
    statusCritical: Color(0xFFEF9A9A),
    statusInfo: Color(0xFF90CAF9),
    onStatus: Color(0xFF17140F),
    queenWhite: Color(0xFFFFFFFF),
    queenYellow: Color(0xFFFDD835),
    queenRed: Color(0xFFE53935),
    queenGreen: Color(0xFF43A047),
    queenBlue: Color(0xFF1E88E5),
  );

  /// Güneş modu: saf beyaz zemin, siyah metin, her çift 7:1 üzeri, gölge yok.
  static const sun = AppColors(
    primary: Color(0xFF7A4700),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1F4238),
    onSecondary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF3D352B),
    outline: Color(0xFF000000),
    divider: Color(0xFF000000),
    shadow: Color(0x00000000),
    statusGood: Color(0xFF1B5E20),
    statusWarning: Color(0xFF8A3000),
    statusCritical: Color(0xFF8E1616),
    statusInfo: Color(0xFF0D47A1),
    onStatus: Color(0xFFFFFFFF),
    queenWhite: Color(0xFFFFFFFF),
    queenYellow: Color(0xFFFDD835),
    queenRed: Color(0xFFE53935),
    queenGreen: Color(0xFF43A047),
    queenBlue: Color(0xFF1E88E5),
  );

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;

  /// Ekran zemini (petek kreması).
  final Color surface;

  /// Kart zemini.
  final Color surfaceContainer;
  final Color textPrimary;
  final Color textSecondary;

  /// Kenarlıklar, girdi çerçeveleri; zemine karşı en az 3:1.
  final Color outline;

  /// Ayraçlar; dekoratif, kontrast şartı yok.
  final Color divider;
  final Color shadow;
  final Color statusGood;
  final Color statusWarning;
  final Color statusCritical;
  final Color statusInfo;

  /// Dolgu olarak kullanılan durum renklerinin üstündeki yazı/ikon.
  final Color onStatus;

  /// Ana arı işaret renkleri. Boya renkleri olduğundan her palette aynı;
  /// beyaz zeminde de seçilsin diye her zaman [outline] halkasıyla çizilir.
  final Color queenWhite;
  final Color queenYellow;
  final Color queenRed;
  final Color queenGreen;
  final Color queenBlue;

  Color queenMark(QueenMarkColor mark) {
    return switch (mark) {
      QueenMarkColor.white => queenWhite,
      QueenMarkColor.yellow => queenYellow,
      QueenMarkColor.red => queenRed,
      QueenMarkColor.green => queenGreen,
      QueenMarkColor.blue => queenBlue,
    };
  }

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? surface,
    Color? surfaceContainer,
    Color? textPrimary,
    Color? textSecondary,
    Color? outline,
    Color? divider,
    Color? shadow,
    Color? statusGood,
    Color? statusWarning,
    Color? statusCritical,
    Color? statusInfo,
    Color? onStatus,
    Color? queenWhite,
    Color? queenYellow,
    Color? queenRed,
    Color? queenGreen,
    Color? queenBlue,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      outline: outline ?? this.outline,
      divider: divider ?? this.divider,
      shadow: shadow ?? this.shadow,
      statusGood: statusGood ?? this.statusGood,
      statusWarning: statusWarning ?? this.statusWarning,
      statusCritical: statusCritical ?? this.statusCritical,
      statusInfo: statusInfo ?? this.statusInfo,
      onStatus: onStatus ?? this.onStatus,
      queenWhite: queenWhite ?? this.queenWhite,
      queenYellow: queenYellow ?? this.queenYellow,
      queenRed: queenRed ?? this.queenRed,
      queenGreen: queenGreen ?? this.queenGreen,
      queenBlue: queenBlue ?? this.queenBlue,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      statusGood: Color.lerp(statusGood, other.statusGood, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusCritical: Color.lerp(statusCritical, other.statusCritical, t)!,
      statusInfo: Color.lerp(statusInfo, other.statusInfo, t)!,
      onStatus: Color.lerp(onStatus, other.onStatus, t)!,
      queenWhite: Color.lerp(queenWhite, other.queenWhite, t)!,
      queenYellow: Color.lerp(queenYellow, other.queenYellow, t)!,
      queenRed: Color.lerp(queenRed, other.queenRed, t)!,
      queenGreen: Color.lerp(queenGreen, other.queenGreen, t)!,
      queenBlue: Color.lerp(queenBlue, other.queenBlue, t)!,
    );
  }
}
