import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';

/// Turdaki bir kovanın durumu.
enum TourHiveState { done, skipped, pending }

/// Turda gösterilen kovan ve durumu.
typedef TourEntry = ({Hive hive, TourHiveState state});

/// [hives] (numara sırasıyla) arasından tura alınacak kovanlar: muayene
/// edilebilenler.
List<String> tourHiveIds(Iterable<Hive> hives) => [
  for (final hive in hives)
    if (canInspect(hive)) hive.id,
];

TourHiveState tourHiveState(ApiaryTour tour, String hiveId) {
  if (tour.inspections.containsKey(hiveId)) return TourHiveState.done;
  if (tour.skipped.contains(hiveId)) return TourHiveState.skipped;
  return TourHiveState.pending;
}

/// Turun kovanları, tur sırasıyla. [hives] arılığın şimdiki kovanları;
/// sonradan silinen ya da taşınan kovan düşer, muayene edilmeden aktif
/// olmaktan çıkan kovan da düşer.
List<TourEntry> tourEntries(ApiaryTour tour, Iterable<Hive> hives) {
  final byId = {for (final hive in hives) hive.id: hive};
  return [
    for (final id in tour.hiveIds)
      if (byId[id] case final hive?)
        if (tourHiveState(tour, id) == TourHiveState.done || canInspect(hive))
          (hive: hive, state: tourHiveState(tour, id)),
  ];
}

/// Sıradaki kovan: tur sırasıyla ilk bekleyen; bekleyen kalmadıysa ilk
/// atlanan (atlanma sırasıyla). Hepsi muayene edildiyse null.
Hive? nextTourHive(ApiaryTour tour, List<TourEntry> entries) {
  for (final entry in entries) {
    if (entry.state == TourHiveState.pending) return entry.hive;
  }
  final byId = {for (final entry in entries) entry.hive.id: entry};
  for (final id in tour.skipped) {
    if (byId[id] case (:final hive, state: TourHiveState.skipped)) return hive;
  }
  return null;
}

/// [hiveId]'yi atlar; zaten atlanmışsa atlananların sonuna geçer (sıradaki
/// bir sonraki atlanan olur). Muayene edilmiş kovan değişmez.
ApiaryTour skipTourHive(ApiaryTour tour, String hiveId) {
  if (tour.inspections.containsKey(hiveId) || !tour.hiveIds.contains(hiveId)) {
    return tour;
  }
  return tour.copyWith(
    skipped: [...tour.skipped.where((id) => id != hiveId), hiveId],
  );
}

/// [inspection]'ı tura yazar; kovan atlananlardan düşer. Turda olmayan
/// kovanın muayenesi turu değiştirmez.
ApiaryTour recordTourInspection(ApiaryTour tour, Inspection inspection) {
  final hiveId = inspection.hiveId;
  if (!tour.hiveIds.contains(hiveId)) return tour;
  return tour.copyWith(
    inspections: {...tour.inspections, hiveId: inspection.id},
    skipped: [...tour.skipped.where((id) => id != hiveId)],
  );
}

/// Muayenenin Geri al'ı: kovan yeniden bekleyen olur. Kovanın turdaki
/// muayenesi başkasıysa (ör. sonra yeniden muayene edildi) değişmez.
ApiaryTour undoTourInspection(ApiaryTour tour, Inspection inspection) {
  if (tour.inspections[inspection.hiveId] != inspection.id) return tour;
  return tour.copyWith(
    inspections: {...tour.inspections}..remove(inspection.hiveId),
  );
}

/// Turun özeti: muayene edilen kovanlar, Bugün panelinin kurallarıyla
/// ([isQueenless], [isWeak], [hasSwarmTendency]) gruplanır; bir kovan
/// birden çok grupta olabilir. Hiçbir grupta olmayan "güçlü / orta".
/// Muayene edilmeyen (atlanan ya da hiç gelinmeyen) kovanlar `skipped`.
/// Listeler tur sırasıyla.
typedef TourSummary = ({
  List<Hive> inspected,
  List<Hive> skipped,
  List<Hive> queenless,
  List<Hive> weak,
  List<Hive> swarming,
  List<Hive> healthy,
});

/// [tour]'un özeti; [inspections] turda kaydedilen muayeneler.
TourSummary tourSummary(
  ApiaryTour tour,
  List<TourEntry> entries,
  Iterable<Inspection> inspections,
) {
  final byId = {
    for (final inspection in inspections) inspection.id: inspection,
  };
  final inspected = <Hive>[];
  final skipped = <Hive>[];
  final queenless = <Hive>[];
  final weak = <Hive>[];
  final swarming = <Hive>[];
  final healthy = <Hive>[];
  for (final (:hive, :state) in entries) {
    final inspection = byId[tour.inspections[hive.id]];
    if (state != TourHiveState.done || inspection == null) {
      skipped.add(hive);
      continue;
    }
    inspected.add(hive);
    final values = inspection.values;
    var flagged = false;
    if (isQueenless(values)) {
      queenless.add(hive);
      flagged = true;
    }
    if (isWeak(values)) {
      weak.add(hive);
      flagged = true;
    }
    if (hasSwarmTendency(values)) {
      swarming.add(hive);
      flagged = true;
    }
    if (!flagged) healthy.add(hive);
  }
  return (
    inspected: inspected,
    skipped: skipped,
    queenless: queenless,
    weak: weak,
    swarming: swarming,
    healthy: healthy,
  );
}

/// Tur sonunda önerilen görev türü ve kaç gün sonraya.
enum TourTaskKind {
  /// Anasız kovanlara ana ver; yarın.
  requeen(1),

  /// Zayıf kovanlara 1:1 şurup; 3 gün sonra.
  feedWeak(3),

  /// Oğul eğilimli kovanlarda oğul kontrolü; 7 gün sonra.
  swarmCheck(7),

  /// Atlanan kovanlara bak; yarın.
  revisitSkipped(1);

  new(this.days);

  final int days;
}

/// Tur sonunda önerilen görev: türü, kovanları (tur sırasıyla) ve son
/// tarihi. Başlık ekranın dilinde üretilir.
typedef TourTaskSuggestion = ({
  TourTaskKind kind,
  List<Hive> hives,
  DateTime dueAt,
});

/// [summary]'den önerilen görevler, [TourTaskKind] sırasıyla; kovanı
/// olmayan tür önerilmez. Son tarih [now]'dan [TourTaskKind.days] gün
/// sonra [defaultTaskHour]'da (yerel).
List<TourTaskSuggestion> tourTaskSuggestions(
  TourSummary summary, {
  required DateTime now,
}) {
  final today = localDay(now);
  return [
    for (final (kind, hives) in [
      (TourTaskKind.requeen, summary.queenless),
      (TourTaskKind.feedWeak, summary.weak),
      (TourTaskKind.swarmCheck, summary.swarming),
      (TourTaskKind.revisitSkipped, summary.skipped),
    ])
      if (hives.isNotEmpty)
        (
          kind: kind,
          hives: hives,
          dueAt: DateTime(
            today.year,
            today.month,
            today.day + kind.days,
            defaultTaskHour,
          ),
        ),
  ];
}

/// [at]'in yerel takvimde [now]'dan kaç gün sonra olduğu; geçmişse 0.
int daysUntil(DateTime at, {required DateTime now}) {
  final day = localDay(at);
  final today = localDay(now);
  final days = DateTime.utc(
    day.year,
    day.month,
    day.day,
  ).difference(DateTime.utc(today.year, today.month, today.day)).inDays;
  return days < 0 ? 0 : days;
}

/// Görev başlığında en çok bu kadar kovan numarası yazılır; gerisi "+N".
const maxTourTaskNumbers = 10;

/// Başlıktaki numaralar: ilk [maxTourTaskNumbers] tanesi ve kalan sayı.
({List<String> shown, int more}) tourTaskNumbers(List<Hive> hives) {
  final numbers = [for (final hive in hives) hive.number];
  if (numbers.length <= maxTourTaskNumbers) return (shown: numbers, more: 0);
  return (
    shown: numbers.take(maxTourTaskNumbers).toList(),
    more: numbers.length - maxTourTaskNumbers,
  );
}
