import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/health/data/mite_count_repository.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'varroa_providers.g.dart';

@Riverpod(keepAlive: true)
MiteCountRepository miteCountRepository(Ref ref) =>
    MiteCountRepository(ref.watch(appDatabaseProvider));

/// Kovanın varroa ölçümleri, en yeni önce.
@riverpod
Stream<List<MiteCount>> hiveMiteCounts(Ref ref, String hiveId) =>
    ref.watch(miteCountRepositoryProvider).watchByHive(hiveId);

/// Arılık grafiğinin çubukları ([apiaryVarroaBars]); arılıkta yapılan
/// ölçümlerle güncellenir.
@riverpod
Stream<List<VarroaBar>> apiaryVarroaBarsOf(Ref ref, String apiaryId) => ref
    .watch(miteCountRepositoryProvider)
    .watchByApiary(apiaryId)
    .map(apiaryVarroaBars);

/// Kaydettikten sonraki Geri al. Bildirim, form kapandıktan sonra da
/// çalışsın diye sürekli yaşar.
@Riverpod(keepAlive: true)
class VarroaActions extends _$VarroaActions {
  @override
  void build() {}

  Future<void> undoAdd(MiteCount count) =>
      ref.read(miteCountRepositoryProvider).delete(count.id);
}
