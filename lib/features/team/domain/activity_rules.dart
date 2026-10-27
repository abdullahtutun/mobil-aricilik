/// Ekip ekranındaki "Son işlemler"in kayıt türleri.
enum ActivityKind { inspection, treatment, feeding, harvest, miteCount, task }

/// Bir kaydı kimin ne zaman, hangi arılıkta yazdığı.
typedef ActivityRecord = ({
  ActivityKind kind,
  String userId,
  DateTime at,
  String? apiaryId,
  String? apiaryName,
});

/// Akışın bir satırı: aynı kişinin aynı arılıkta art arda yazdığı aynı
/// türdeki kayıtlar tek satırda toplanır ("12 muayene girdi"). `at`
/// grubun en son kaydıdır.
typedef ActivityEntry = ({
  ActivityKind kind,
  String userId,
  DateTime at,
  String? apiaryName,
  int count,
});

/// Aynı satırda toplanan kayıtlar arasındaki en uzun ara.
const activityGroupWindow = Duration(minutes: 10);

/// [records]'tan en yeni [limit] satırı üretir; sıra yeniden eskiye.
/// Kayıtlar [activityGroupWindow]'dan sık yazılmışsa (toplu ilaçlama,
/// arılık turu) kişi, tür ve arılık aynıysa tek satır olur.
List<ActivityEntry> groupActivity(
  Iterable<ActivityRecord> records, {
  int limit = 5,
}) {
  final sorted = records.toList()..sort((a, b) => b.at.compareTo(a.at));
  final entries = <ActivityEntry>[];
  ActivityRecord? previous;
  for (final record in sorted) {
    final last = entries.lastOrNull;
    final joins =
        last != null &&
        previous != null &&
        record.kind == last.kind &&
        record.userId == last.userId &&
        record.apiaryId == previous.apiaryId &&
        previous.at.difference(record.at) <= activityGroupWindow;
    if (joins) {
      entries[entries.length - 1] = (
        kind: last.kind,
        userId: last.userId,
        at: last.at,
        apiaryName: last.apiaryName,
        count: last.count + 1,
      );
    } else {
      if (entries.length == limit) break;
      entries.add((
        kind: record.kind,
        userId: record.userId,
        at: record.at,
        apiaryName: record.apiaryName,
        count: 1,
      ));
    }
    previous = record;
  }
  return entries;
}

/// Kayıttan bu yana geçen süre, gösterim birimiyle.
enum ActivityAgeUnit { justNow, minutes, hours, yesterday, days, date }

typedef ActivityAge = ({ActivityAgeUnit unit, int value});

/// [at]'in [now]'a göre yaşı: 1 dk altı "şimdi", sonra dakika, saat, dün,
/// gün; haftadan eskisi tarih. Gün farkı yerel takvim gününe göre.
ActivityAge activityAge(DateTime at, DateTime now) {
  final difference = now.difference(at);
  if (difference < const Duration(minutes: 1)) {
    return (unit: ActivityAgeUnit.justNow, value: 0);
  }
  if (difference < const Duration(hours: 1)) {
    return (unit: ActivityAgeUnit.minutes, value: difference.inMinutes);
  }
  final localAt = at.toLocal();
  final localNow = now.toLocal();
  final days = DateTime(
    localNow.year,
    localNow.month,
    localNow.day,
  ).difference(DateTime(localAt.year, localAt.month, localAt.day)).inDays;
  if (days == 0) {
    return (unit: ActivityAgeUnit.hours, value: difference.inHours);
  }
  if (days == 1) return (unit: ActivityAgeUnit.yesterday, value: 1);
  if (days < 7) return (unit: ActivityAgeUnit.days, value: days);
  return (unit: ActivityAgeUnit.date, value: days);
}
