import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

/// Kış kaybı karşılaştırmasında bundan az kovanlı grup "az veri" sayılır;
/// oranı yanıltıcı olabilir.
const minReliableWinterHives = 10;

/// Yerel saatle yarı açık aralık: `from` dahil, `to` hariç.
typedef Window = ({DateTime from, DateTime to});

bool _inWindow(DateTime at, Window window) {
  final local = at.toLocal();
  return !local.isBefore(window.from) && local.isBefore(window.to);
}

/// Sezon: takvim yılı (Finans ile aynı).
Window seasonWindow(int year) => (from: DateTime(year), to: DateTime(year + 1));

/// [seasonYear] sezonunun kışı. Kuzey'de önceki yılın 1 Kasım'ı ile bu
/// yılın 31 Mart'ı arası (2025-26 kışı 2026 sezonunda); Güney'de 6 ay
/// kayar: bu yılın 1 Mayıs'ı ile 30 Eylül'ü arası.
Window winterWindow(int seasonYear, Hemisphere hemisphere) =>
    switch (hemisphere) {
      Hemisphere.northern => (
        from: DateTime(seasonYear - 1, 11),
        to: DateTime(seasonYear, 4),
      ),
      Hemisphere.southern => (
        from: DateTime(seasonYear, 5),
        to: DateTime(seasonYear, 10),
      ),
    };

/// Kışa hazırlık mücadelesi: kıştan önceki üç ay (Kuzey'de 1 Ağustos –
/// 31 Ekim).
Window preWinterTreatmentWindow(Window winter) =>
    (from: DateTime(winter.from.year, winter.from.month - 3), to: winter.from);

/// Kovanın [at] anındaki durumu; kovan henüz yoksa null. [events]
/// kovanın olayları (sıra fark etmez). Olaylardan önceki durum ilk olayın
/// eski durumu; hiç olay yoksa bugünkü durum.
HiveStatus? statusAt(Hive hive, Iterable<HiveStatusEvent> events, DateTime at) {
  if (!hive.createdAt.isBefore(at)) return null;
  final sorted = _sortedBy(events, (event) => event.changedAt);
  final before = sorted.where((event) => event.changedAt.isBefore(at));
  return before.lastOrNull?.toStatus ??
      sorted.firstOrNull?.fromStatus ??
      hive.status;
}

/// Kovanın [at] anındaki arılığı: o andan önceki son taşıma kaydı, yoksa
/// bugünkü arılığı.
String apiaryAt(
  Hive hive,
  Iterable<HiveLocationEntry> locations,
  DateTime at,
) =>
    _sortedBy(
      locations.where((entry) => entry.movedAt.isBefore(at)),
      (entry) => entry.movedAt,
    ).lastOrNull?.apiaryId ??
    hive.apiaryId;

/// Kayıp olayı: aktif kovan söndü ya da kayboldu.
bool isLossEvent(HiveStatusEvent event) =>
    event.fromStatus == HiveStatus.active && event.toStatus.isLoss;

/// Sezon raporunun girdisi; hepsi işletmenin silinmemiş kayıtları.
typedef SeasonRecords = ({
  List<Hive> hives,
  List<HiveStatusEvent> events,
  List<HiveLocationEntry> locations,
  List<Queen> queens,
  List<Harvest> harvests,
  List<Treatment> treatments,
});

/// Bir kayıp nedeninin sayısı; neden boşsa belirtilmemiş.
typedef LossCount = ({HiveLossReason? reason, int count});

/// Kışa aktif giren kovanlar ve kışta kaybedilenler.
typedef WinterLoss = ({int hives, int lost});

extension WinterLossRate on WinterLoss {
  /// Kayıp oranı (0–1); kışa kovan girmediyse null.
  double? get rate => hives == 0 ? null : lost / hives;

  /// Kovan az; oran yanıltıcı olabilir.
  bool get isSmall => hives < minReliableWinterHives;
}

/// Kış kaybı karşılaştırmasının bir grubu.
typedef WinterLossGroup<K> = ({K key, WinterLoss loss});

/// Mücadele yöntemi: kışa hazırlıkta kullanılan etken maddeler; boşsa
/// ilaçlanmadı.
typedef TreatmentMethod = Set<DrugActiveIngredient>;

/// Kovanın sezondaki satırı (CSV'nin satırı).
typedef SeasonHiveRow = ({
  Hive hive,

  /// Sezon başındaki durum; sezonda eklendiyse null.
  HiveStatus? startStatus,
  HiveStatus endStatus,

  /// Sezondaki son kayıp olayı; yoksa null.
  HiveStatusEvent? loss,

  /// Kışa aktif girdi mi; girdiyse kışta kaybedildi mi, mücadele yöntemi,
  /// kış başındaki arılığı ve anasının hattı.
  bool inWinter,
  bool lostInWinter,
  TreatmentMethod method,
  String winterApiaryId,
  String? queenLine,
});

/// Sezon raporu (docs/design "Sezon raporu").
typedef SeasonReport = ({
  int year,
  int hivesAtStart,
  int hivesAtEnd,

  /// Sezondaki kayıplar, çok olan önce; aynı sayıda nedeni olan sıra.
  List<LossCount> losses,
  double honeyKg,
  int newQueens,
  int ownRearedQueens,

  /// Bu sezonun kışı; kış henüz başlamadıysa null. Sürüyorsa bugüne
  /// kadarki kayıp.
  WinterLoss? winter,

  /// Önceki sezonun kışı.
  WinterLoss? previousWinter,
  List<WinterLossGroup<TreatmentMethod>> byTreatment,
  List<WinterLossGroup<String>> byApiary,

  /// Anahtar ana hattı; boşsa bilinmiyor.
  List<WinterLossGroup<String?>> byQueenLine,
  List<SeasonHiveRow> hiveRows,
});

extension SeasonReportTotals on SeasonReport {
  int get netChange => hivesAtEnd - hivesAtStart;
  int get lossTotal => losses.fold(0, (sum, loss) => sum + loss.count);

  /// Karşılaştırmada az kovanlı grup var; "yanıltıcı olabilir" notu.
  bool get hasSmallGroups => [
    ...byTreatment,
    ...byApiary,
    ...byQueenLine,
  ].any((group) => group.loss.isSmall);
}

/// [year] sezonunun raporu; [now] anına kadarki kayıtlardan.
SeasonReport seasonReport(
  SeasonRecords records, {
  required int year,
  required Hemisphere hemisphere,
  required DateTime now,
}) {
  final season = seasonWindow(year);
  final seasonEnd = now.isBefore(season.to) ? now : season.to;
  final eventsByHive = _groupBy(records.events, (event) => event.hiveId);
  final locationsByHive = _groupBy(records.locations, (entry) => entry.hiveId);
  final treatmentsByHive = _groupBy(
    records.treatments,
    (treatment) => treatment.hiveId,
  );
  final queens = {for (final queen in records.queens) queen.id: queen};

  List<HiveStatusEvent> eventsOf(Hive hive) => eventsByHive[hive.id] ?? [];

  int activeAt(DateTime at) => records.hives
      .where((hive) => statusAt(hive, eventsOf(hive), at) == HiveStatus.active)
      .length;

  final seasonLosses = [
    for (final event in records.events)
      if (isLossEvent(event) && _inWindow(event.changedAt, season)) event,
  ];
  int reasonOrder(HiveLossReason? reason) =>
      reason?.index ?? HiveLossReason.values.length;
  final reasonCounts =
      [
        for (final MapEntry(:key, :value) in _groupBy(
          seasonLosses,
          (event) => event.lossReason,
        ).entries)
          (reason: key, count: value.length),
      ]..sort((a, b) {
        final byCount = b.count.compareTo(a.count);
        return byCount != 0
            ? byCount
            : reasonOrder(a.reason).compareTo(reasonOrder(b.reason));
      });

  final winter = winterWindow(year, hemisphere);
  final treatmentWindow = preWinterTreatmentWindow(winter);

  /// Kışa aktif giren kovanın kışta kayıp olayı var mı.
  bool lostIn(Hive hive, Window window) => eventsOf(hive)
      .any((event) => isLossEvent(event) && _inWindow(event.changedAt, window));

  WinterLoss? winterLoss(Window window) {
    if (!window.from.isBefore(now)) return null;
    final entered = records.hives.where(
      (hive) =>
          statusAt(hive, eventsOf(hive), window.from) == HiveStatus.active,
    );
    return (
      hives: entered.length,
      lost: entered.where((hive) => lostIn(hive, window)).length,
    );
  }

  String? queenLineOf(Hive hive) =>
      switch (queens[hive.queenId]?.breedLine?.trim()) {
        final line? when line.isNotEmpty => line,
        _ => null,
      };

  final rows = <SeasonHiveRow>[];
  for (final hive in records.hives) {
    final events = eventsOf(hive);
    final endStatus = statusAt(hive, events, seasonEnd);
    if (endStatus == null) continue;
    final inWinter = statusAt(hive, events, winter.from) == HiveStatus.active;
    rows.add((
      hive: hive,
      startStatus: statusAt(hive, events, season.from),
      endStatus: endStatus,
      loss: _sortedBy(
        events.where(
          (event) => isLossEvent(event) && _inWindow(event.changedAt, season),
        ),
        (event) => event.changedAt,
      ).lastOrNull,
      inWinter: inWinter,
      lostInWinter: inWinter && lostIn(hive, winter),
      method: {
        for (final treatment in treatmentsByHive[hive.id] ?? <Treatment>[])
          if (_inWindow(treatment.startedAt, treatmentWindow))
            treatment.activeIngredient,
      },
      winterApiaryId: apiaryAt(
        hive,
        locationsByHive[hive.id] ?? const [],
        winter.from,
      ),
      queenLine: queenLineOf(hive),
    ));
  }

  final winterRows = winter.from.isBefore(now)
      ? rows.where((row) => row.inWinter).toList()
      : <SeasonHiveRow>[];

  final seasonQueens = records.queens.where(
    (queen) => (queen.year ?? queen.createdAt.toLocal().year) == year,
  );

  return (
    year: year,
    hivesAtStart: activeAt(season.from),
    hivesAtEnd: activeAt(seasonEnd),
    losses: reasonCounts,
    honeyKg: records.harvests
        .where((harvest) => _inWindow(harvest.harvestedAt, season))
        .fold(0, (sum, harvest) => sum + harvest.netKg),
    newQueens: seasonQueens.length,
    ownRearedQueens: seasonQueens
        .where((queen) => queen.source == QueenSource.ownRearing)
        .length,
    winter: winterLoss(winter),
    previousWinter: winterLoss(winterWindow(year - 1, hemisphere)),
    byTreatment: _groupWinter(
      winterRows,
      (row) => row.method,
      equals: (a, b) => a.length == b.length && a.containsAll(b),
    ),
    byApiary: _groupWinter(winterRows, (row) => row.winterApiaryId),
    byQueenLine: _groupWinter(winterRows, (row) => row.queenLine),
    hiveRows: rows,
  );
}

/// Kışa giren kovanları [keyOf]'a göre gruplar; düşük kayıp önce, eşitse
/// çok kovanlı önce.
List<WinterLossGroup<K>> _groupWinter<K>(
  List<SeasonHiveRow> rows,
  K Function(SeasonHiveRow row) keyOf, {
  bool Function(K a, K b)? equals,
}) {
  final same = equals ?? (K a, K b) => a == b;
  final groups = <(K, List<SeasonHiveRow>)>[];
  for (final row in rows) {
    final key = keyOf(row);
    final group = groups.where((group) => same(group.$1, key)).firstOrNull;
    if (group == null) {
      groups.add((key, [row]));
    } else {
      group.$2.add(row);
    }
  }
  return [
    for (final (key, members) in groups)
      (
        key: key,
        loss: (
          hives: members.length,
          lost: members.where((row) => row.lostInWinter).length,
        ),
      ),
  ]..sort((a, b) {
    final byRate = a.loss.rate!.compareTo(b.loss.rate!);
    return byRate != 0 ? byRate : b.loss.hives.compareTo(a.loss.hives);
  });
}

List<T> _sortedBy<T>(Iterable<T> items, DateTime Function(T item) at) =>
    items.toList()..sort((a, b) => at(a).compareTo(at(b)));

Map<K, List<T>> _groupBy<T, K>(Iterable<T> items, K Function(T item) keyOf) {
  final groups = <K, List<T>>{};
  for (final item in items) {
    (groups[keyOf(item)] ??= []).add(item);
  }
  return groups;
}
