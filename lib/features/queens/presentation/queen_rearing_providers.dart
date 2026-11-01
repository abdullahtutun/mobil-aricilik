import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/queens/data/queen_rearing_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'queen_rearing_providers.g.dart';

@Riverpod(keepAlive: true)
QueenRearingRepository queenRearingRepository(Ref ref) =>
    QueenRearingRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin serileri, son aktarılan önce; işletme yoksa boş.
@riverpod
Stream<List<QueenRearingBatch>> rearingBatches(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(queenRearingRepositoryProvider).watchByOrg(orgId);
}

/// Seri; yoksa ya da silinmişse null.
@riverpod
Stream<QueenRearingBatch?> rearingBatch(Ref ref, String id) =>
    ref.watch(queenRearingRepositoryProvider).watchById(id);

/// Serinin kutuları, numara sırasıyla.
@riverpod
Stream<List<MatingNuc>> rearingBatchNucs(Ref ref, String batchId) => ref
    .watch(queenRearingRepositoryProvider)
    .nucs
    .watchByBatch(batchId)
    .map(
      (nucs) => [...nucs]..sort((a, b) => compareNatural(a.number, b.number)),
    );

/// Arılığın kutuları; dağıtmada yeniden kullanılacak boş kutular buradan.
@riverpod
Stream<List<MatingNuc>> apiaryNucs(Ref ref, String apiaryId) =>
    ref.watch(queenRearingRepositoryProvider).nucs.watchByApiary(apiaryId);

/// Serinin takvim görevleri (tamamlananlar dahil).
@riverpod
Stream<List<Task>> rearingBatchTasks(Ref ref, String batchId) => ref
    .watch(taskRepositoryProvider)
    .watchBySources(TaskSource.queenRearing, [batchId]);

/// Ana yetiştirmenin yazmaları; hepsi yerel DB'de. Geri al snackbar'ı
/// ekran kapandıktan sonra da çalışsın diye sürekli yaşar.
@Riverpod(keepAlive: true)
class RearingActions extends _$RearingActions {
  @override
  void build() {}

  QueenRearingRepository get _repository =>
      ref.read(queenRearingRepositoryProvider);

  /// Seriyi ve takvim görevlerini siler.
  Future<void> deleteBatch(String id) => _repository.remove(id);

  /// Memeleri arılığın kutularına dağıtır.
  Future<List<MatingNuc>> distribute(
    QueenRearingBatch batch, {
    required String apiaryId,
    required int count,
  }) => _repository.nucs.distribute(
    batch: batch,
    apiaryId: apiaryId,
    count: count,
  );

  Future<MatingNuc> setNucStatus(MatingNuc nuc, MatingNucStatus status) =>
      _repository.nucs.setStatus(nuc, status);

  /// Kutudaki anayı kovana verir; yeni ana kaydı oluşur.
  Future<NucQueenGiven> giveQueen(String nucId, String hiveId) =>
      _repository.nucs.giveQueen(nucId, hiveId);

  Future<bool> undoGiveQueen(NucQueenGiven given) =>
      _repository.nucs.undoGiveQueen(given);
}
