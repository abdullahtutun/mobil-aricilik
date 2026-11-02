import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/hives/domain/hive_timeline.dart';
import 'package:mobil_arici/features/hives/domain/strength_rules.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_providers.dart';
import 'package:mobil_arici/features/media/presentation/media_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hive_providers.g.dart';

@Riverpod(keepAlive: true)
HiveRepository hiveRepository(Ref ref) => HiveRepository(
  ref.watch(appDatabaseProvider),
  aksReminders: ref.watch(
    regionConfigProvider.select((region) => region.features.aks),
  ),
);

@Riverpod(keepAlive: true)
HiveLocationRepository hiveLocationRepository(Ref ref) =>
    HiveLocationRepository(ref.watch(appDatabaseProvider));

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").
@riverpod
Stream<List<Hive>> apiaryHives(Ref ref, String apiaryId) => ref
    .watch(hiveRepositoryProvider)
    .watchByApiary(apiaryId)
    .map(_sortedByNumber);

/// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
/// yoksa boş.
@riverpod
Stream<List<Hive>> organizationHives(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(hiveRepositoryProvider).watchAll(orgId).map(_sortedByNumber);
}

List<Hive> _sortedByNumber(List<Hive> hives) =>
    hives..sort((a, b) => compareNatural(a.number, b.number));

/// Kovan kartı; kovan yoksa ya da silindiyse null.
@riverpod
Stream<Hive?> hive(Ref ref, String hiveId) =>
    ref.watch(hiveRepositoryProvider).watchById(hiveId);

/// Arılıktaki kovanların güç puanları, her birinin son muayenesinden
/// ([strengthScore]); puanı olmayan kovan haritada yok.
@riverpod
Stream<Map<String, int>> apiaryHiveStrengths(Ref ref, String apiaryId) => ref
    .watch(inspectionRepositoryProvider)
    .watchLatestByApiary(apiaryId)
    .map(
      (latest) => {
        for (final MapEntry(key: hiveId, value: inspection) in latest.entries)
          hiveId: ?strengthScore(inspection.values),
      },
    );

/// Kovanın muayeneleri, en yeni önce.
@riverpod
Stream<List<Inspection>> hiveInspections(Ref ref, String hiveId) =>
    ref.watch(inspectionRepositoryProvider).watchByHive(hiveId);

/// Kovanın güç puanı, son muayenesinden ([strengthScore]); muayene ya da
/// arılı çerçeve yoksa null. Zaman tüneliyle aynı akışı okur.
@riverpod
Future<int?> hiveStrength(Ref ref, String hiveId) async {
  final inspections = await ref.watch(hiveInspectionsProvider(hiveId).future);
  return switch (inspections) {
    [final latest, ...] => strengthScore(latest.values),
    [] => null,
  };
}

@riverpod
Stream<List<HiveLocationEntry>> hiveLocationHistory(Ref ref, String hiveId) =>
    ref.watch(hiveLocationRepositoryProvider).watchByHive(hiveId);

/// Kovanın zaman tüneli: bütün kayıt türlerinin olayları tek listede, en
/// yeni önce. Yeni bir tür kendi akışını izleyen bir provider yazar ve
/// olaylarını buradaki listeye ekler; kaynaklardan biri değişince tünel
/// yeniden kurulur.
@riverpod
Future<List<HiveTimelineEvent>> hiveTimeline(Ref ref, String hiveId) async {
  final (inspections, media, locations, treatments, prescriptions) = await (
    ref.watch(hiveInspectionsProvider(hiveId).future),
    ref.watch(hiveMediaProvider(hiveId).future),
    ref.watch(hiveLocationHistoryProvider(hiveId).future),
    ref.watch(hiveTreatmentsProvider(hiveId).future),
    ref.watch(hivePrescriptionsProvider(hiveId).future),
  ).wait;
  return sortTimeline([
    ...inspectionEvents(inspections, media: media),
    ...treatmentEvents(treatments, prescriptions: prescriptions),
    ...mediaEvents(
      media,
      inspectionIds: {for (final inspection in inspections) inspection.id},
      treatmentIds: {for (final treatment in treatments) treatment.id},
    ),
    ...locationEvents(locations),
  ]);
}

enum HiveLayout { grid, list }

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.
@Riverpod(keepAlive: true)
class HiveLayoutPreference extends _$HiveLayoutPreference {
  @override
  HiveLayout build() => HiveLayout.grid;

  HiveLayout get layout => state;

  set layout(HiveLayout layout) => state = layout;
}

enum HiveSort { number, weakestFirst }

/// Arılık detayındaki aktif kovanların sırası: numara ya da zayıflar önce
/// ([sortWeakestFirst]). Izgaraya ve listeye birlikte uygulanır. Yalnız
/// bellekte; uygulama yeniden açılınca numara sırasına döner.
@Riverpod(keepAlive: true)
class HiveSortPreference extends _$HiveSortPreference {
  @override
  HiveSort build() => HiveSort.number;

  HiveSort get sort => state;

  set sort(HiveSort sort) => state = sort;
}

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma, karantina. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.
@Riverpod(keepAlive: true)
class HiveActions extends _$HiveActions {
  @override
  void build() {}

  HiveRepository get _repository => ref.read(hiveRepositoryProvider);

  Future<void> setStatus(
    String hiveId,
    HiveStatus status, {
    HiveLossReason? lossReason,
  }) => _repository.setStatus(hiveId, status, lossReason: lossReason);

  /// Durum değişikliğinin Geri al'ı; değişikliğin olayı da silinir.
  Future<void> undoStatus(String hiveId, {required HiveStatus previous}) =>
      _repository.undoStatus(hiveId, previous: previous);

  /// Kovan zaten o arılıktaysa null.
  Future<HiveMove?> move(String hiveId, {required String apiaryId}) =>
      _repository.move(hiveId, apiaryId: apiaryId);

  Future<void> undoMove(HiveMove move) => _repository.undoMove(move);

  Future<void> quarantine(String hiveId, {required String disease}) =>
      _repository.quarantine(hiveId, disease: disease);

  Future<void> endQuarantine(String hiveId) =>
      _repository.endQuarantine(hiveId);

  /// Karantina eylemlerinin Geri al'ı: [previous] hâline döner.
  Future<void> restoreQuarantine(Hive previous) =>
      _repository.restoreQuarantine(previous.id, previous: previous);
}
