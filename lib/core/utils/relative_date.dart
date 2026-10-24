import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';

/// Yakın günü kelimeyle, uzağı tarihle yazar: `bugün`, `dün`, `3 gün önce`,
/// bir haftadan eskiyse `21 Eki 2026`. Gün sınırı yerel saate göre; gelecek
/// bir an (saati ileri cihazdan gelen kayıt) `bugün` sayılır.
String relativeDay(
  AppLocalizations l10n,
  AppFormat format,
  DateTime at, {
  required DateTime now,
}) {
  final local = at.toLocal();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  // Yaz saati geçişinde gün 23 ya da 25 saat sürer; yuvarlamak yeter.
  final days = (today.difference(day).inHours / 24).round();
  return switch (days) {
    <= 0 => l10n.relativeToday,
    1 => l10n.relativeYesterday,
    < 7 => l10n.relativeDaysAgo(days),
    _ => format.date(local),
  };
}
