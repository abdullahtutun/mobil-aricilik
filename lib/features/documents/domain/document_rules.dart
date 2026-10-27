import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';

/// `documents` bucket'ındaki yol: `org_id/belge_id/dosya_id.jpg|pdf`.
/// Sunucu aynı kuralı CHECK ile denetler. Dosya değişince yeni [fileId]
/// verilir; bucket'ta aynı yola ikinci yükleme olmaz.
String documentStoragePath({
  required String orgId,
  required String documentId,
  required String fileId,
  required DocumentFileKind kind,
}) => '$orgId/$documentId/$fileId.${kind.extension}';

/// Belge dosyasının bu telefondaki adı: yolun son parçası.
String documentFileName(String storagePath) => storagePath.split('/').last;

/// Belgenin geçerlilik durumu.
enum DocumentExpiryLevel {
  /// Geçerlilik tarihi yok.
  none,

  /// [soonDays] günden uzak.
  valid,

  /// [soonDays] gün ya da daha az kaldı.
  soon,

  /// [urgentDays] gün ya da daha az kaldı (bugün dahil).
  urgent,

  /// Süresi doldu.
  expired;

  static const urgentDays = 30;
  static const soonDays = 90;
}

typedef DocumentExpiry = ({
  DocumentExpiryLevel level,

  /// Son güne kalan takvim günü; bugün sonsa 0, geçtiyse eksi. Tarih
  /// yoksa null.
  int? daysLeft,
});

/// [from] ile [to] arasındaki takvim günü (yerel); yaz saati geçişinde
/// kaymaz.
int calendarDaysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

/// [expiresOn]'un [now]'a (yerel) göre durumu. Son gün dahil geçerlidir.
DocumentExpiry documentExpiry(DateTime? expiresOn, DateTime now) {
  if (expiresOn == null) {
    return (level: DocumentExpiryLevel.none, daysLeft: null);
  }
  final days = calendarDaysBetween(now, expiresOn);
  return (
    level: switch (days) {
      < 0 => DocumentExpiryLevel.expired,
      <= DocumentExpiryLevel.urgentDays => DocumentExpiryLevel.urgent,
      <= DocumentExpiryLevel.soonDays => DocumentExpiryLevel.soon,
      _ => DocumentExpiryLevel.valid,
    },
    daysLeft: days,
  );
}

/// "2 ay" rozetinin ay sayısı: tam 30 günlükler, en az 1.
int monthsLeft(int days) => days < 30 ? 1 : days ~/ 30;

/// Kasa sırası: süresi önce dolan önce, süresizler sonda; aynı günde ada
/// göre (doğal sıra).
List<VaultDocument> sortDocuments(Iterable<VaultDocument> documents) =>
    [...documents]..sort((a, b) {
      final byExpiry = switch ((a.expiresOn, b.expiresOn)) {
        (null, null) => 0,
        (null, _) => 1,
        (_, null) => -1,
        (final x?, final y?) => x.compareTo(y),
      };
      if (byExpiry != 0) return byExpiry;
      final byName = compareNatural(a.name, b.name);
      return byName != 0 ? byName : a.id.compareTo(b.id);
    });

/// Daha önce yazılmış kullanıcı tanımlı türler; formda öneri olarak
/// çıkar. Büyük/küçük harf ve boşluk farkı aynı tür sayılır, ilk yazılış
/// kalır. Doğal sırada.
List<String> customDocumentTypes(Iterable<VaultDocument> documents) {
  final seen = <String, String>{};
  for (final document in documents) {
    final name = document.customTypeName?.trim();
    if (name == null || name.isEmpty) continue;
    seen.putIfAbsent(name.toLowerCase(), () => name);
  }
  return seen.values.toList()..sort(compareNatural);
}

/// Süre dolumundan kaç gün önce hatırlatılır.
const List<int> expiryReminderDays = [30, 7, 1];

/// Hatırlatmanın saati (yerel).
const expiryReminderHour = 9;

/// Kurulacak bir süre dolumu hatırlatması.
typedef DocumentReminder = ({
  VaultDocument document,

  /// Son güne kalan gün ([expiryReminderDays]'den biri).
  int daysLeft,

  /// Çalacağı an (yerel).
  DateTime at,
});

/// Geçerlilik tarihi olan belgelerin süre dolumu hatırlatmaları: son
/// günden [expiryReminderDays] gün önce saat [expiryReminderHour]'da.
/// Zamanı geçmiş olanlar kurulmaz. Belge, gün ve sıraya göre.
List<DocumentReminder> documentReminderPlan(
  Iterable<VaultDocument> documents, {
  required DateTime now,
}) => [
  for (final document in sortDocuments(documents))
    if (document.expiresOn case final expiresOn?)
      for (final days in expiryReminderDays)
        if (DateTime(
              expiresOn.year,
              expiresOn.month,
              expiresOn.day - days,
              expiryReminderHour,
            )
            case final at when at.isAfter(now))
          (document: document, daysLeft: days, at: at),
];

/// Hatırlatmanın bildirim kimliği: belge ve günden türeyen 31 bitlik
/// FNV-1a; aynı hatırlatma her eşitlemede aynı kimliği alır.
int documentReminderId(String documentId, int daysLeft) {
  var hash = 0x811c9dc5;
  for (final unit in 'document:$documentId:$daysLeft'.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}
