import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_timeline.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';

/// Raporun önerilen dönemi: bu yılın 1 Ocak'ından bugüne.
ReportPeriod defaultReportPeriod(DateTime now) {
  final local = now.toLocal();
  return (
    from: DateTime(local.year),
    to: DateTime(local.year, local.month, local.day),
  );
}

/// [at] (UTC ya da yerel) yerel takvimde [period]'un günlerinden birinde
/// mi; dönemin iki ucu da dahil.
bool isInPeriod(DateTime at, ReportPeriod period) {
  final local = at.toLocal();
  final day = DateTime(local.year, local.month, local.day);
  return !day.isBefore(_day(period.from)) && !day.isAfter(_day(period.to));
}

/// İlaç kayıt defterinin satırları: dönemde başlayan, silinmemiş
/// uygulamalar; [apiaryId] verilirse yalnız o arılıkta yapılanlar. Aynı
/// anda yazılan uygulamalar (grup) tek satır olur. En son başlayan önce;
/// aynı anda başlayanlardan kimliği büyük olan önce. [hiveNumbers] kovan
/// kimliğinden numarası.
List<TreatmentRegisterEntry> treatmentRegisterEntries(
  Iterable<Treatment> treatments, {
  required ReportPeriod period,
  required Map<String, String> hiveNumbers,
  String? apiaryId,
}) {
  final groups = <String, List<Treatment>>{};
  for (final treatment in treatments) {
    if (treatment.deletedAt != null) continue;
    if (apiaryId != null && treatment.apiaryId != apiaryId) continue;
    if (!isInPeriod(treatment.startedAt, period)) continue;
    (groups[treatment.groupId] ??= []).add(treatment);
  }
  final entries = [
    for (final group in groups.values)
      TreatmentRegisterEntry(
        treatment: group.reduce((a, b) => a.id.compareTo(b.id) <= 0 ? a : b),
        hiveCount: group.length,
        hiveNumbers: [
          for (final treatment in group) ?hiveNumbers[treatment.hiveId],
        ]..sort(compareNatural),
      ),
  ];
  return entries..sort(
    (a, b) => _newestFirst(
      a.treatment.startedAt,
      a.treatment.id,
      b.treatment.startedAt,
      b.treatment.id,
    ),
  );
}

/// Kovan geçmişine girecek kovanlar: [hiveId] verilirse yalnız o (silinmiş
/// değilse), değilse [apiaryId] arılığındaki (boşsa bütün) silinmemiş
/// kovanlar; numara sırasıyla.
List<Hive> reportHives(
  Iterable<Hive> hives, {
  String? apiaryId,
  String? hiveId,
}) => [
  for (final hive in hives)
    if (hive.deletedAt == null &&
        (hiveId == null || hive.id == hiveId) &&
        (hiveId != null || apiaryId == null || hive.apiaryId == apiaryId))
      hive,
]..sort((a, b) => compareNatural(a.number, b.number));

/// Kovanın dönemdeki kayıtları, en yeni önce; silinmiş kayıtlar yazılmaz.
/// Taşımanın geldiği arılık dönemden önceki kayıttan da bulunur.
List<HiveHistoryItem> hiveHistoryItems(
  HiveRecords records, {
  required ReportPeriod period,
}) {
  final items = <HiveHistoryItem>[
    for (final inspection in records.inspections)
      if (inspection.deletedAt == null) InspectionItem(inspection),
    for (final treatment in records.treatments)
      if (treatment.deletedAt == null) TreatmentItem(treatment),
    for (final feeding in records.feedings)
      if (feeding.deletedAt == null) FeedingItem(feeding),
    for (final count in records.miteCounts)
      if (count.deletedAt == null) MiteCountItem(count),
    for (final harvest in records.harvests)
      if (harvest.deletedAt == null) HarvestItem(harvest),
    for (final event in locationEvents([
      for (final entry in records.locations)
        if (entry.deletedAt == null) entry,
    ]))
      LocationItem(event.entry, fromApiaryId: event.fromApiaryId),
  ];
  return [
    for (final item in items)
      if (isInPeriod(item.at, period)) item,
  ]..sort((a, b) => _newestFirst(a.at, a.id, b.at, b.id));
}

DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

int _newestFirst(DateTime a, String aId, DateTime b, String bId) {
  final byTime = b.compareTo(a);
  return byTime != 0 ? byTime : bId.compareTo(aId);
}
