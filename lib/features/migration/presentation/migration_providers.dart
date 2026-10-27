import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'migration_providers.g.dart';

@Riverpod(keepAlive: true)
MigrationRepository migrationRepository(Ref ref) =>
    MigrationRepository(ref.watch(appDatabaseProvider));

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
