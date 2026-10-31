import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/data/transport_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/migration/domain/transport_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'migration_providers.g.dart';

@Riverpod(keepAlive: true)
MigrationRepository migrationRepository(Ref ref) =>
    MigrationRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
TransportRepository transportRepository(Ref ref) =>
    TransportRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin göç planları, yeni yıl önce; işletme yoksa boş.
@riverpod
Stream<List<Migration>> migrations(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(migrationRepositoryProvider).watchByOrg(orgId);
}

/// Göç planı; yoksa ya da silinmişse null.
@riverpod
Stream<Migration?> migration(Ref ref, String id) =>
    ref.watch(migrationRepositoryProvider).watchById(id);

/// Planın durakları rota sırasıyla.
@riverpod
Stream<List<MigrationStop>> migrationStops(Ref ref, String migrationId) =>
    ref.watch(migrationRepositoryProvider).stops.watchByMigration(migrationId);

/// Durak; yoksa ya da silinmişse null.
@riverpod
Stream<MigrationStop?> migrationStop(Ref ref, String id) =>
    ref.watch(migrationRepositoryProvider).stops.watchById(id);

/// Planın duraklarındaki hedef arılıkların plan yılından önceki verimi,
/// arılık kimliğine göre. Durak, hasat ya da plan yılı değişince yeniden
/// hesaplanır.
@riverpod
Stream<Map<String, List<YearlyYield>>> migrationYields(
  Ref ref,
  String migrationId,
) async* {
  final migration = await ref.watch(migrationProvider(migrationId).future);
  final stops = await ref.watch(migrationStopsProvider(migrationId).future);
  if (migration == null) {
    yield const {};
    return;
  }
  final apiaryIds = {for (final stop in stops) ?stop.apiaryId};
  yield* ref
      .watch(migrationRepositoryProvider)
      .watchApiaryHarvests(apiaryIds)
      .map((entries) => yieldsByApiary(entries, beforeYear: migration.year));
}

/// Göç planındaki silme eylemleri.
@Riverpod(keepAlive: true)
class MigrationActions extends _$MigrationActions {
  @override
  void build() {}

  /// Planı ve duraklarını siler.
  Future<void> deleteMigration(String id) =>
      ref.read(migrationRepositoryProvider).remove(id);

  Future<void> deleteStop(String id) =>
      ref.read(migrationRepositoryProvider).stops.delete(id);
}

/// Göç durağına giden en son taşıma; yoksa null.
@riverpod
Stream<Transport?> stopTransport(Ref ref, String migrationStopId) =>
    ref.watch(transportRepositoryProvider).watchLatestForStop(migrationStopId);

/// Taşımanın kovanları, yüklenme sırasıyla.
@riverpod
Stream<List<TransportItem>> transportItems(Ref ref, String transportId) =>
    ref.watch(transportRepositoryProvider).items.watchByTransport(transportId);

/// Taşımanın yazmaları; hepsi yerel DB'de, ağ beklemez.
@Riverpod(keepAlive: true)
class TransportActions extends _$TransportActions {
  @override
  void build() {}

  TransportRepository get _repository => ref.read(transportRepositoryProvider);

  /// Kontrol listesi bitince taşımayı yükleme adımında başlatır. İşletme
  /// yoksa [StateError].
  Future<Transport> start({
    required String migrationStopId,
    required String sourceApiaryId,
    required String destinationApiaryId,
    required List<String> vehicles,
  }) => _repository.start(
    orgId: ref.read(currentOrgIdProvider) ?? (throw StateError('İşletme yok')),
    migrationStopId: migrationStopId,
    sourceApiaryId: sourceApiaryId,
    destinationApiaryId: destinationApiaryId,
    vehicles: vehicles,
  );

  Future<Transport> addVehicle(String transportId, String name) =>
      _repository.addVehicle(transportId, name);

  Future<LoadResult> load(
    String transportId, {
    required String hiveId,
    required String vehicle,
  }) => _repository.load(transportId, hiveId: hiveId, vehicle: vehicle);

  Future<Transport> startUnloading(String transportId) =>
      _repository.startUnloading(transportId);

  Future<UnloadResult> unload(String transportId, {required String hiveId}) =>
      _repository.unload(transportId, hiveId: hiveId);

  /// İndirmeyi bitirir; indirilen kovanlar hedef arılığa taşınır.
  Future<int> complete(String transportId) => _repository.complete(transportId);
}

/// Yüklemede seçili araç; taşıma ekranı açıkken yaşar. Boşsa ilk araç.
@riverpod
class TransportVehicle extends _$TransportVehicle {
  @override
  String? build(String transportId) => null;

  String? get vehicle => state;

  set vehicle(String? vehicle) => state = vehicle;
}

/// Taşıma; yoksa ya da silinmişse null.
@riverpod
Stream<Transport?> transport(Ref ref, String id) =>
    ref.watch(transportRepositoryProvider).watchById(id);
