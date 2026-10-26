import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/harvest_rules.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';

/// Yazılan hasat ve hasada alınan kovanları (yazılma sırasıyla).
typedef HarvestRecord = ({Harvest harvest, List<HarvestHive> hives});

/// Bekleme süresindeki kovan gerekçesiz hasada alınmak istendi; hiçbir şey
/// yazılmadı.
class HarvestLockedException implements Exception {
  const new(this.hiveIds);

  final Set<String> hiveIds;

  @override
  String toString() => 'HarvestLockedException($hiveIds)';
}

/// Hasada alınan kovanlar; olay kaydı. Yalnız [HarvestRepository] yazar.
class HarvestHiveRepository
    extends BaseRepository<$HarvestHivesTable, HarvestHive> {
  new(super.db, {super.clock});

  @override
  $HarvestHivesTable get table => db.harvestHives;

  @override
  Insertable<HarvestHive> toInsertable(HarvestHive record) =>
      record.toInsertable();

  /// Hasadın kovanları, yazılma sırasıyla.
  Future<List<HarvestHive>> findByHarvest(String harvestId) => (selectWhere(
    (t) => t.harvestId.equals(harvestId),
  )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

  /// [harvest]'a [hiveId] kovanını yazar; bekleme süresine rağmen
  /// alındıysa [withdrawalOverride] ile.
  Future<HarvestHive> add(
    Harvest harvest,
    String hiveId, {
    WithdrawalOverride? withdrawalOverride,
  }) {
    final at = now();
    return insertRecord(
      HarvestHive(
        id: generateId(),
        orgId: harvest.orgId,
        harvestId: harvest.id,
        hiveId: hiveId,
        withdrawalTreatmentId: withdrawalOverride?.treatmentId,
        withdrawalOverrideReason: withdrawalOverride?.reason,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}

/// Hasatlar; olay kaydı: yalnız eklenir, güncelleme yok, yanlış kayıt
/// silinir (Geri al da silmedir). Hasat ve kovanları tek transaction'da,
/// hepsi ya da hiçbiri yazılır.
///
/// Bekleme süresi kilidi (teknik.md §10) burada da denetlenir: hasat
/// gününde bekleme süresindeki kovan ancak gerekçesiyle
/// ([WithdrawalOverride]) hasada alınır; gerekçesiz kilitli kovan varsa
/// [HarvestLockedException] atılır.
class HarvestRepository extends BaseRepository<$HarvestsTable, Harvest> {
  new(super.db, {super.clock});

  late final _hives = HarvestHiveRepository(db, clock: clock);
  late final _treatments = TreatmentRepository(db, clock: clock);

  @override
  $HarvestsTable get table => db.harvests;

  @override
  Insertable<Harvest> toInsertable(Harvest record) => record.toInsertable();

  /// [plan]'ı [orgId] işletmesine ve [hiveIds] kovanlarını hasada yazar.
  /// Bekleme süresindeki kovanın gerekçesi [overrides]'ta (kovan kimliğine
  /// göre); kilitli olmayan kovanın gerekçesi yazılmaz.
  ///
  /// Kovan yoksa ya da tekrar ediyorsa, miktarlar sunucunun kısıtlarına
  /// uymazsa [ArgumentError] atar ve bir şey yazmaz.
  Future<HarvestRecord> add({
    required String orgId,
    required HarvestPlan plan,
    required List<String> hiveIds,
    Map<String, WithdrawalOverride> overrides = const {},
  }) {
    if (hiveIds.isEmpty || hiveIds.toSet().length != hiveIds.length) {
      throw ArgumentError.value(hiveIds, 'hiveIds');
    }
    if (!isValidHarvestAmount(unitCount: plan.unitCount, netKg: plan.netKg)) {
      throw ArgumentError.value(plan, 'plan');
    }
    return db.transaction(() async {
      final locks = withdrawalLocksByHive(
        await _treatments.findByHives(hiveIds),
        now: plan.harvestedAt,
      );
      final unexcused = {
        for (final hiveId in hiveIds)
          if (locks.containsKey(hiveId) && !overrides.containsKey(hiveId))
            hiveId,
      };
      if (unexcused.isNotEmpty) throw HarvestLockedException(unexcused);

      final at = now();
      final harvest = await insertRecord(
        Harvest(
          id: generateId(),
          orgId: orgId,
          apiaryId: plan.apiaryId,
          harvestedAt: plan.harvestedAt.toUtc(),
          honeyKind: plan.honeyKind,
          unit: plan.unit,
          unitCount: plan.unitCount,
          netKg: plan.netKg,
          createdAt: at,
          updatedAt: at,
        ),
      );
      final hives = [
        for (final hiveId in hiveIds)
          await _hives.add(
            harvest,
            hiveId,
            withdrawalOverride: locks.containsKey(hiveId)
                ? overrides[hiveId]
                : null,
          ),
      ];
      return (harvest: harvest, hives: hives);
    });
  }

  /// Hasadın kovanları, yazılma sırasıyla.
  Future<List<HarvestHive>> findHives(String harvestId) =>
      _hives.findByHarvest(harvestId);

  /// Geri al: hasadı ve kovanlarını tek transaction'da siler.
  Future<void> deleteHarvest(String harvestId) => db.transaction(() async {
    for (final hive in await _hives.findByHarvest(harvestId)) {
      await _hives.delete(hive.id);
    }
    await delete(harvestId);
  });
}
