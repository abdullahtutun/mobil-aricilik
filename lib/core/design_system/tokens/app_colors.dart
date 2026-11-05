import 'package:flutter/material.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart'
    show HoneyKind;
import 'package:mobil_arici/features/organization/domain/organization.dart'
    show OrgAvatarColor;
import 'package:mobil_arici/features/queens/domain/queen.dart'
    show QueenMarkColor;

/// Renk tokenları (teknik.md §7).
///
/// Durum renkleri tek başına anlam taşımaz; her zaman ikon ve kelimeyle
/// birlikte kullanılır. Durum rengi zemin üzerinde ikon/kenarlık olarak
/// (en az 3:1) ya da kendi açık zemininde (`status…Container`) yazı olarak
/// gösterilir. Dolgu olarak kullanıldığında üstündeki yazı [onStatus]'tur.
class AppColors extends ThemeExtension<AppColors> {
  const new({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.honey,
    required this.surface,
    required this.surfaceContainer,
    required this.tile,
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
    required this.statusGoodContainer,
    required this.statusWarningContainer,
    required this.statusCriticalContainer,
    required this.statusInfoContainer,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.queenWhite,
    required this.queenYellow,
    required this.queenRed,
    required this.queenGreen,
    required this.queenBlue,
    required this.honeyPine,
    required this.honeyFlower,
    required this.honeyChestnut,
    required this.honeyCitrus,
    required this.honeyOther,
  });

  /// Standart açık tema (tasarım sistemi v1). Durum yazısı kendi zemininde
  /// en az 4.3:1 (iyi #2E7D32/#E3F0E3 4.36), diğerleri 5:1 üzeri.
  static const light = AppColors(
    primary: Color(0xFF9A5B00),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF2F5D50),
    onSecondary: Color(0xFFFFFFFF),
    honey: Color(0xFFF2B544),
    surface: Color(0xFFFFF8EE),
    surfaceContainer: Color(0xFFF6EBDA),
    tile: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1F1A14),
    textSecondary: Color(0xFF5E554A),
    outline: Color(0xFF857868),
    divider: Color(0xFFE8DCC8),
    shadow: Color(0xFF000000),
    statusGood: Color(0xFF2E7D32),
    statusWarning: Color(0xFFA23B00),
    statusCritical: Color(0xFFB3261E),
    statusInfo: Color(0xFF1557A8),
    onStatus: Color(0xFFFFFFFF),
    statusGoodContainer: Color(0xFFE3F0E3),
    statusWarningContainer: Color(0xFFFCE9DA),
    statusCriticalContainer: Color(0xFFFBE3E3),
    statusInfoContainer: Color(0xFFE1ECF8),
    inverseSurface: Color(0xFF1F1A14),
    onInverseSurface: Color(0xFFFFF8EE),
    inversePrimary: Color(0xFFF2B544),
    queenWhite: Color(0xFFFFFFFF),
    queenYellow: Color(0xFFFDD835),
    queenRed: Color(0xFFE53935),
    queenGreen: Color(0xFF43A047),
    queenBlue: Color(0xFF1E88E5),
    honeyPine: Color(0xFF6E4A1E),
    honeyFlower: Color(0xFFC98A1E),
    honeyChestnut: Color(0xFF4A2F14),
    honeyCitrus: Color(0xFFE8B84A),
    honeyOther: Color(0xFFA8803F),
  );

  /// Standart koyu tema.
  static const dark = AppColors(
    primary: Color(0xFFFFB74D),
    onPrimary: Color(0xFF2B1700),
    secondary: Color(0xFF8CC7B4),
    onSecondary: Color(0xFF0B261E),
    honey: Color(0xFFF2B544),
    surface: Color(0xFF17140F),
    surfaceContainer: Color(0xFF231F18),
    tile: Color(0xFF2A251D),
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
    statusGoodContainer: Color(0xFF1E3320),
    statusWarningContainer: Color(0xFF3D2414),
    statusCriticalContainer: Color(0xFF3D1C1C),
    statusInfoContainer: Color(0xFF1A2A3D),
    inverseSurface: Color(0xFFF3ECE2),
    onInverseSurface: Color(0xFF17140F),
    inversePrimary: Color(0xFF7A4700),
    queenWhite: Color(0xFFFFFFFF),
    queenYellow: Color(0xFFFDD835),
    queenRed: Color(0xFFE53935),
    queenGreen: Color(0xFF43A047),
    queenBlue: Color(0xFF1E88E5),
    honeyPine: Color(0xFF6E4A1E),
    honeyFlower: Color(0xFFC98A1E),
    honeyChestnut: Color(0xFF4A2F14),
    honeyCitrus: Color(0xFFE8B84A),
    honeyOther: Color(0xFFA8803F),
  );

  /// Güneş modu: saf beyaz zemin, siyah metin ve siyah birincil eylem
  /// (Muayene · güneş modu tasarımı), her çift 7:1 üzeri, gölge yok.
  /// Durum zeminleri beyaza çok yakın; durum yazısı üstlerinde de 7:1.
  static const sun = AppColors(
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF1F4238),
    onSecondary: Color(0xFFFFFFFF),
    honey: Color(0xFFF2B544),
    surface: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFFFFFFF),
    tile: Color(0xFFFFFFFF),
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
    statusGoodContainer: Color(0xFFF0F7F0),
    statusWarningContainer: Color(0xFFFDF1E8),
    statusCriticalContainer: Color(0xFFFDEFEF),
    statusInfoContainer: Color(0xFFEEF4FB),
    inverseSurface: Color(0xFF000000),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFFF2B544),
    queenWhite: Color(0xFFFFFFFF),
    queenYellow: Color(0xFFFDD835),
    queenRed: Color(0xFFE53935),
    queenGreen: Color(0xFF43A047),
    queenBlue: Color(0xFF1E88E5),
    honeyPine: Color(0xFF6E4A1E),
    honeyFlower: Color(0xFFC98A1E),
    honeyChestnut: Color(0xFF4A2F14),
    honeyCitrus: Color(0xFFE8B84A),
    honeyOther: Color(0xFFA8803F),
  );

  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;

  /// Bal sarısı vurgu dolgusu; üstüne yazı gelecekse [textPrimary].
  final Color honey;

  /// Ekran zemini (petek kreması).
  final Color surface;

  /// Kart zemini; sayaç gibi gruplanmış alanlar.
  final Color surfaceContainer;

  /// Karo ve kart yüzeyi (kovan karosu, bölüm kartı, seçilmemiş chip).
  final Color tile;

  final Color textPrimary;
  final Color textSecondary;

  /// Girdi çerçeveleri; zemine karşı en az 3:1.
  final Color outline;

  /// Çizgi: kart ve chip kenarlığı, ayraç; dekoratif, kontrast şartı yok.
  final Color divider;

  final Color shadow;
  final Color statusGood;
  final Color statusWarning;
  final Color statusCritical;
  final Color statusInfo;

  /// Dolgu olarak kullanılan durum renklerinin üstündeki yazı/ikon.
  final Color onStatus;

  /// Durum rozeti ve uyarı kartının zemini; üstündeki yazı durum rengiyle.
  final Color statusGoodContainer;
  final Color statusWarningContainer;
  final Color statusCriticalContainer;
  final Color statusInfoContainer;

  /// Ters zemin (bildirim); yazısı [onInverseSurface], eylemi
  /// [inversePrimary].
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;

  /// Ana arı işaret renkleri. Boya renkleri olduğundan her palette aynı;
  /// beyaz zeminde de seçilsin diye her zaman [outline] halkasıyla çizilir.
  final Color queenWhite;
  final Color queenYellow;
  final Color queenRed;
  final Color queenGreen;
  final Color queenBlue;

  /// Bal türünün kavanoz rengi (lot kartı). Balın kendi rengi olduğundan
  /// her palette aynı; anlamı yanındaki bal türü adı taşır.
  final Color honeyPine;
  final Color honeyFlower;
  final Color honeyChestnut;
  final Color honeyCitrus;
  final Color honeyOther;

  Color honeySwatch(HoneyKind kind) => switch (kind) {
    HoneyKind.pine => honeyPine,
    HoneyKind.flower => honeyFlower,
    HoneyKind.chestnut => honeyChestnut,
    HoneyKind.citrus => honeyCitrus,
    HoneyKind.other => honeyOther,
  };

  /// İşletme ve üye avatarının zemini ve üstündeki baş harflerin rengi.
  /// Yeni renk açılmaz; kontrastı zaten test edilen çiftler kullanılır.
  (Color, Color) orgAvatar(OrgAvatarColor color) => switch (color) {
    OrgAvatarColor.pine => (secondary, onSecondary),
    OrgAvatarColor.honey => (primary, onPrimary),
    OrgAvatarColor.sky => (statusInfo, onStatus),
    OrgAvatarColor.slate => (inverseSurface, onInverseSurface),
  };

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
    Color? honey,
    Color? surface,
    Color? surfaceContainer,
    Color? tile,
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
    Color? statusGoodContainer,
    Color? statusWarningContainer,
    Color? statusCriticalContainer,
    Color? statusInfoContainer,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? queenWhite,
    Color? queenYellow,
    Color? queenRed,
    Color? queenGreen,
    Color? queenBlue,
    Color? honeyPine,
    Color? honeyFlower,
    Color? honeyChestnut,
    Color? honeyCitrus,
    Color? honeyOther,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      honey: honey ?? this.honey,
      surface: surface ?? this.surface,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      tile: tile ?? this.tile,
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
      statusGoodContainer: statusGoodContainer ?? this.statusGoodContainer,
      statusWarningContainer:
          statusWarningContainer ?? this.statusWarningContainer,
      statusCriticalContainer:
          statusCriticalContainer ?? this.statusCriticalContainer,
      statusInfoContainer: statusInfoContainer ?? this.statusInfoContainer,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      queenWhite: queenWhite ?? this.queenWhite,
      queenYellow: queenYellow ?? this.queenYellow,
      queenRed: queenRed ?? this.queenRed,
      queenGreen: queenGreen ?? this.queenGreen,
      queenBlue: queenBlue ?? this.queenBlue,
      honeyPine: honeyPine ?? this.honeyPine,
      honeyFlower: honeyFlower ?? this.honeyFlower,
      honeyChestnut: honeyChestnut ?? this.honeyChestnut,
      honeyCitrus: honeyCitrus ?? this.honeyCitrus,
      honeyOther: honeyOther ?? this.honeyOther,
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
      honey: Color.lerp(honey, other.honey, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      tile: Color.lerp(tile, other.tile, t)!,
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
      statusGoodContainer: Color.lerp(
        statusGoodContainer,
        other.statusGoodContainer,
        t,
      )!,
      statusWarningContainer: Color.lerp(
        statusWarningContainer,
        other.statusWarningContainer,
        t,
      )!,
      statusCriticalContainer: Color.lerp(
        statusCriticalContainer,
        other.statusCriticalContainer,
        t,
      )!,
      statusInfoContainer: Color.lerp(
        statusInfoContainer,
        other.statusInfoContainer,
        t,
      )!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      onInverseSurface: Color.lerp(
        onInverseSurface,
        other.onInverseSurface,
        t,
      )!,
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t)!,
      queenWhite: Color.lerp(queenWhite, other.queenWhite, t)!,
      queenYellow: Color.lerp(queenYellow, other.queenYellow, t)!,
      queenRed: Color.lerp(queenRed, other.queenRed, t)!,
      queenGreen: Color.lerp(queenGreen, other.queenGreen, t)!,
      queenBlue: Color.lerp(queenBlue, other.queenBlue, t)!,
      honeyPine: Color.lerp(honeyPine, other.honeyPine, t)!,
      honeyFlower: Color.lerp(honeyFlower, other.honeyFlower, t)!,
      honeyChestnut: Color.lerp(honeyChestnut, other.honeyChestnut, t)!,
      honeyCitrus: Color.lerp(honeyCitrus, other.honeyCitrus, t)!,
      honeyOther: Color.lerp(honeyOther, other.honeyOther, t)!,
    );
  }
}
