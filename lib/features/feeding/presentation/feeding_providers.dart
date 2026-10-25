import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/feeding/data/feeding_repository.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feeding_providers.g.dart';

@Riverpod(keepAlive: true)
FeedingRepository feedingRepository(Ref ref) =>
    FeedingRepository(ref.watch(appDatabaseProvider));

/// Arılıkta şu an bal katı olan kovanların kimlikleri; muayeneler ya da
/// kovanların arılığı değişince yeniden hesaplanır.
@riverpod
Stream<Set<String>> apiaryHoneySuperHiveIds(Ref ref, String apiaryId) => ref
    .watch(inspectionRepositoryProvider)
    .watchSuperChangesByApiary(apiaryId)
    .map(honeySuperHiveIds);

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.
@Riverpod(keepAlive: true)
class FeedingActions extends _$FeedingActions {
  @override
  void build() {}

  /// Geri al: beslemeler silinir.
  Future<void> undoAdd(List<Feeding> feedings) =>
      ref.read(feedingRepositoryProvider).deleteAll(feedings);
}
