import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';

/// Rota sırası: sıra numarası, aynı sırada planlanan başlangıç, sonra
/// kimlik.
List<MigrationStop> sortStops(Iterable<MigrationStop> stops) =>
    [...stops]..sort((a, b) {
      final byPosition = a.position.compareTo(b.position);
      if (byPosition != 0) return byPosition;
      final byStart = a.plannedStartOn.compareTo(b.plannedStartOn);
      return byStart != 0 ? byStart : a.id.compareTo(b.id);
    });

/// Sıradaki taşıma: nereden (`from`; ilk taşımada boş) nereye (`to`).
typedef NextMove = ({MigrationStop? from, MigrationStop to});

/// Rota sırasındaki [stops]'ta sıradaki taşıma. Şu anki durak varsa ondan
/// sonraki ilk planlı durağa; yoksa ilk planlı durağa, ondan önceki son
/// geçmiş duraktan. Planlı durak kalmadıysa null.
NextMove? nextMove(List<MigrationStop> stops) {
  final currentIndex = stops.indexWhere(
    (stop) => stop.status == MigrationStopStatus.current,
  );
  final toIndex = stops.indexWhere(
    (stop) => stop.status == MigrationStopStatus.planned,
    currentIndex < 0 ? 0 : currentIndex + 1,
  );
  if (toIndex < 0) return null;
  final from = currentIndex >= 0
      ? stops[currentIndex]
      : stops
            .take(toIndex)
            .where((stop) => stop.status == MigrationStopStatus.past)
            .lastOrNull;
  return (from: from, to: stops[toIndex]);
}

/// Taşımada yanda olması gereken belge türleri (TR profili), kartta bu
/// sırayla. Arı nakil belgesi her taşımada, veteriner sağlık raporu iller
/// arası taşımada, gezginci arıcı belgesi yol kontrolünde istenir. Liste
/// kullanıcının verdiği bilgiye dayanır; il/ilçe tarım müdürlüğünden teyit
/// edilmedi (docs/progress.md).
const List<DocumentType> migrationDocumentTypes = [
  DocumentType.transportPermit,
  DocumentType.healthReport,
  DocumentType.migratoryCertificate,
];

/// Sağlık raporu gibi kısa süreli belgede kalan gün bundan azsa uyarılır.
const migrationDocumentUrgentDays = 7;

/// Belgenin taşımaya göre durumu.
enum MigrationDocumentLevel {
  /// Taşıma günü geçerli.
  ready,

  /// [migrationDocumentUrgentDays] günden az kaldı.
  expiringSoon,

  /// Taşıma gününden önce süresi doluyor.
  expiresBeforeMove,

  /// Süresi doldu.
  expired,

  /// Kasada bu türde belge yok.
  missing,
}

typedef MigrationDocumentStatus = ({
  DocumentType type,
  MigrationDocumentLevel level,

  /// Son güne kalan gün; süresiz ya da eksik belgede null.
  int? daysLeft,
});

/// [migrationDocumentTypes]'ın her biri için kasadaki en uzun geçerli
/// belgenin (süresiz en iyisi) [moveOn] taşıma gününe ve [now]'a göre
/// durumu. Kalan gün azsa taşımadan önce dolsa da kalan gün gösterilir.
List<MigrationDocumentStatus> migrationDocumentStatuses(
  Iterable<VaultDocument> documents, {
  required DateTime moveOn,
  required DateTime now,
}) => [
  for (final type in migrationDocumentTypes)
    _documentStatus(
      type,
      _longestValid(documents.where((d) => d.type == type)),
      moveOn: moveOn,
      now: now,
    ),
];

VaultDocument? _longestValid(Iterable<VaultDocument> documents) {
  VaultDocument? best;
  for (final document in documents) {
    final expires = document.expiresOn;
    final bestExpires = best?.expiresOn;
    if (best == null ||
        (bestExpires != null &&
            (expires == null || expires.isAfter(bestExpires)))) {
      best = document;
    }
  }
  return best;
}

MigrationDocumentStatus _documentStatus(
  DocumentType type,
  VaultDocument? document, {
  required DateTime moveOn,
  required DateTime now,
}) {
  if (document == null) {
    return (type: type, level: MigrationDocumentLevel.missing, daysLeft: null);
  }
  final expiresOn = document.expiresOn;
  if (expiresOn == null) {
    return (type: type, level: MigrationDocumentLevel.ready, daysLeft: null);
  }
  final days = calendarDaysBetween(now, expiresOn);
  return (
    type: type,
    level: switch (days) {
      < 0 => MigrationDocumentLevel.expired,
      < migrationDocumentUrgentDays => MigrationDocumentLevel.expiringSoon,
      _ when calendarDaysBetween(moveOn, expiresOn) < 0 =>
        MigrationDocumentLevel.expiresBeforeMove,
      _ => MigrationDocumentLevel.ready,
    },
    daysLeft: days,
  );
}

/// Arılıkta bir hasat: süzülen bal ve hasada alınan kovan sayısı.
typedef ApiaryHarvestEntry = ({
  String apiaryId,
  DateTime harvestedAt,
  double netKg,
  int hiveCount,
});

/// Arılığın bir yıldaki verimi: süzülen balın hasada alınan kovan başına
/// düşeni.
typedef YearlyYield = ({int year, double kgPerHive});

/// Kartta durak başına gösterilen en çok yıl sayısı.
const maxYieldYears = 3;

/// [entries]'in arılık başına, [beforeYear]'dan önceki yıllardaki verimi;
/// yeni yıl önce, en çok [maxYieldYears] yıl. Yıl hasadın yerel tarihinden.
/// Yıl içindeki bütün hasatların balı, o hasatlara alınan kovanların
/// toplamına bölünür.
Map<String, List<YearlyYield>> yieldsByApiary(
  Iterable<ApiaryHarvestEntry> entries, {
  required int beforeYear,
}) {
  final totals = <String, Map<int, ({double kg, int hives})>>{};
  for (final entry in entries) {
    final year = entry.harvestedAt.toLocal().year;
    if (year >= beforeYear || entry.hiveCount <= 0) continue;
    final years = totals.putIfAbsent(entry.apiaryId, () => {});
    final total = years[year] ?? (kg: 0.0, hives: 0);
    years[year] = (
      kg: total.kg + entry.netKg,
      hives: total.hives + entry.hiveCount,
    );
  }
  return {
    for (final MapEntry(key: apiaryId, value: years) in totals.entries)
      apiaryId: [
        for (final year in (years.keys.toList()..sort((a, b) => b - a)).take(
          maxYieldYears,
        ))
          (year: year, kgPerHive: years[year]!.kg / years[year]!.hives),
      ],
  };
}

/// Yerin ilk parçası: "Ula, Muğla" → "Ula".
String shortPlace(String place) => place.split(',').first.trim();
