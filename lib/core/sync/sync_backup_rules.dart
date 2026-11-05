/// Bekleyen kayıt bu kadar süre gönderilemezse kullanıcı uyarılır: telefon
/// kaybolursa ya da bozulursa bu kayıtlar sunucuda yok.
const syncOverdueAfter = Duration(days: 3);

/// Hatırlatma bildirimi gece çalmaz: bu saatten önceye düşerse aynı gün,
/// [_reminderLatestHour]'dan sonraya düşerse ertesi gün bu saatte çalar.
const _reminderEarliestHour = 9;
const _reminderLatestHour = 21;

/// Senkron hatırlatmasının bildirim kimliği; tek bildirim, hep yenilenir.
const syncReminderId = 0x5EC0;

/// En eski bekleyen kayıt ([oldestPendingAt]) [syncOverdueAfter]'dan uzun
/// süredir gönderilemedi mi. Bekleyen yoksa hayır.
bool isSyncOverdue({
  required DateTime? oldestPendingAt,
  required DateTime now,
}) =>
    oldestPendingAt != null &&
    now.difference(oldestPendingAt) >= syncOverdueAfter;

/// Bekleyen kayıt gönderilmezse hatırlatma bildiriminin yerel saatle
/// çalacağı an: en eski bekleyen kayıttan [syncOverdueAfter] sonra, gece
/// düşerse 09:00'a kayar. Bekleyen yoksa ya da an geçtiyse (uygulama açık;
/// uyarı ekranda) null.
DateTime? syncReminderAt({
  required DateTime? oldestPendingAt,
  required DateTime now,
}) {
  if (oldestPendingAt == null) return null;
  final due = oldestPendingAt.toLocal().add(syncOverdueAfter);
  final at = switch (due.hour) {
    < _reminderEarliestHour => DateTime(
      due.year,
      due.month,
      due.day,
      _reminderEarliestHour,
    ),
    >= _reminderLatestHour => DateTime(
      due.year,
      due.month,
      due.day + 1,
      _reminderEarliestHour,
    ),
    _ => due,
  };
  return at.isAfter(now) ? at : null;
}

/// Son başarılı eşitlemeden bu yana geçen takvim günü (bugün 0, dün 1);
/// ikisi de yerel saatle.
int daysSince(DateTime at, DateTime now) {
  final local = at.toLocal();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(local.year, local.month, local.day);
  // Yaz saati geçişinde gün 23 ya da 25 saat sürer; yuvarlanır.
  return (today.difference(day).inHours / 24).round().clamp(0, 1 << 30);
}
