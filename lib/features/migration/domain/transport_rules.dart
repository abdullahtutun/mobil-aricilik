import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';

/// Yüklemeden önceki kontrol listesi (ozellikler.md §7 "Yükleme listesi").
/// Hepsi işaretlenmeden yüklemeye geçilmez.
enum TransportCheck { entrancesClosed, ventilation, straps, water }

/// Okutulan kovanın yüklemedeki sonucu.
enum LoadResult {
  loaded,

  /// Yüklendi ama kovan kaynak arılıkta değildi; ekran uyarır.
  loadedFromOtherApiary,

  /// Kovan bu taşımada zaten yüklü; bir şey yazılmadı.
  alreadyLoaded,
}

/// Okutulan kovanın indirmedeki sonucu.
enum UnloadResult {
  unloaded,

  /// Zaten indirildi; bir şey yazılmadı.
  alreadyUnloaded,

  /// Bu taşımada yüklenmemiş; bir şey yazılmadı.
  notLoaded,
}

/// Araçların yüklü kovan sayısı, [Transport.vehicles] sırasıyla; boş araç
/// 0. Listede olmayan araç adıyla yüklenen kovan (başka telefondan) sona
/// eklenir.
Map<String, int> loadedPerVehicle(
  Transport transport,
  List<TransportItem> items,
) {
  final counts = {for (final vehicle in transport.vehicles) vehicle: 0};
  for (final item in items) {
    counts[item.vehicle] = (counts[item.vehicle] ?? 0) + 1;
  }
  return counts;
}

/// Yüklenmesi beklenip henüz okutulmamış kovanlar: kaynak arılığın aktif
/// kovanlarından taşımada olmayanlar, numara sırasıyla.
List<Hive> hivesNotLoaded(List<Hive> sourceHives, List<TransportItem> items) {
  final loaded = {for (final item in items) item.hiveId};
  return [
    for (final hive in sourceHives)
      if (hive.status.isCounted && !loaded.contains(hive.id)) hive,
  ]..sort((a, b) => compareNatural(a.number, b.number));
}

/// Yüklenmesi beklenen kovan sayısı: kaynak arılığın aktif kovanları ile
/// başka yerden yüklenenler. Kovanlar indirilip taşındıktan sonra da
/// yüklenenlerden az olmaz.
int expectedLoadCount(List<Hive> sourceHives, List<TransportItem> items) =>
    items.length + hivesNotLoaded(sourceHives, items).length;

/// Yüklenip hedefte henüz okutulmamış kovanlar, yüklenme sırasıyla.
List<TransportItem> itemsNotUnloaded(List<TransportItem> items) => [
  for (final item in items)
    if (item.unloadedAt == null) item,
]..sort((a, b) => a.loadedAt.compareTo(b.loadedAt));

/// Son okutulan kovan: yüklemede en son yüklenen, indirmede en son
/// indirilen; yoksa null.
TransportItem? lastScanned(
  List<TransportItem> items, {
  required bool unloading,
}) {
  TransportItem? last;
  for (final item in items) {
    final at = unloading ? item.unloadedAt : item.loadedAt;
    if (at == null) continue;
    final lastAt = last == null
        ? null
        : (unloading ? last.unloadedAt : last.loadedAt);
    if (lastAt == null || at.isAfter(lastAt)) last = item;
  }
  return last;
}

/// [hives] içinde numarası [number] olan kovan; yazımdaki boşluk ve
/// büyük-küçük harf gözetilmez. Aktif kovan öne geçer; yoksa null.
Hive? hiveByNumber(List<Hive> hives, String number) {
  final wanted = number.trim().toLowerCase();
  if (wanted.isEmpty) return null;
  final matches = [
    for (final hive in hives)
      if (hive.number.trim().toLowerCase() == wanted) hive,
  ];
  if (matches.isEmpty) return null;
  return matches.firstWhere(
    (hive) => hive.status.isCounted,
    orElse: () => matches.first,
  );
}
