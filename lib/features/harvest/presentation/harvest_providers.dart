import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'harvest_providers.g.dart';

@Riverpod(keepAlive: true)
HarvestRepository harvestRepository(Ref ref) =>
    HarvestRepository(ref.watch(appDatabaseProvider));

/// Şu an arılıkta duran kovanların uygulamaları (nerede yapılmış olursa
/// olsun); uygulamalar ya da kovanların arılığı değişince yeniden yayar.
@riverpod
Stream<List<Treatment>> apiaryHiveTreatments(Ref ref, String apiaryId) =>
    ref.watch(treatmentRepositoryProvider).watchByHivesInApiary(apiaryId);

/// Arılıktaki kovanlardan [day] günü bekleme süresinde olanların kilidi,
/// kovan kimliğine göre ([withdrawalLocksByHive]).
@riverpod
Future<Map<String, WithdrawalLock>> harvestLocks(
  Ref ref,
  String apiaryId,
  DateTime day,
) async => withdrawalLocksByHive(
  await ref.watch(apiaryHiveTreatmentsProvider(apiaryId).future),
  now: day,
);

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.
@Riverpod(keepAlive: true)
class HarvestActions extends _$HarvestActions {
  @override
  void build() {}

  /// Geri al: hasat ve kovanları silinir.
  Future<void> undoAdd(HarvestRecord record) =>
      ref.read(harvestRepositoryProvider).deleteHarvest(record.harvest.id);
}
