import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

/// İlaç uygulamaları; olay kaydı: yalnız eklenir, güncelleme yok, yanlış
/// kayıt silinir (Geri al da silmedir). Toplu uygulama hepsini ya da
/// hiçbirini yazar.
class TreatmentRepository extends BaseRepository<$TreatmentsTable, Treatment> {
  new(super.db, {super.clock});

  @override
  $TreatmentsTable get table => db.treatments;

  @override
  Insertable<Treatment> toInsertable(Treatment record) => record.toInsertable();

  /// Kovanın uygulamaları, en son başlayan önce. Aynı anda başlayanlardan
  /// kimliği (UUIDv7) büyük olan önce.
  Stream<List<Treatment>> watchByHive(String hiveId) => watchWhere(
    (t) => t.hiveId.equals(hiveId),
    orderBy: [
      (t) => OrderingTerm.desc(t.startedAt),
      (t) => OrderingTerm.desc(t.id),
    ],
  );

  /// Kovanın uygulamaları; okuma anında (ör. kilit denetimi).
  Future<List<Treatment>> findByHive(String hiveId) =>
      selectWhere((t) => t.hiveId.equals(hiveId)).get();

  /// [plan]'ı [hive]'a, kovanın şimdiki arılığında yazar.
  Future<Treatment> addToHive(Hive hive, TreatmentPlan plan) async =>
      (await _addAll([hive], plan)).single;

  /// [plan]'ı [apiaryId] arılığındaki her aktif kovana tek transaction'da
  /// yazar ve kovan numarası sırasıyla döner. Aktif kovan yoksa bir şey
  /// yazmaz, boş döner.
  Future<List<Treatment>> addToApiary(String apiaryId, TreatmentPlan plan) =>
      db.transaction(() async {
        final hives =
            await (db.select(db.hives)
                  ..where(
                    (t) =>
                        t.apiaryId.equals(apiaryId) &
                        t.deletedAt.isNull() &
                        t.status.equalsValue(HiveStatus.active),
                  )
                  ..orderBy([(t) => OrderingTerm.asc(t.number)]))
                .get();
        return await _addAll(hives, plan);
      });

  /// Geri al: [treatments]'ı tek transaction'da siler.
  Future<void> deleteAll(Iterable<Treatment> treatments) =>
      db.transaction(() async {
        for (final treatment in treatments) {
          await delete(treatment.id);
        }
      });

  /// Değerler sunucunun kısıtlarına uymazsa [ArgumentError] atar ve bir
  /// şey yazmaz.
  Future<List<Treatment>> _addAll(List<Hive> hives, TreatmentPlan plan) {
    _check(plan);
    final drug = plan.drug;
    final batchNo = plan.batchNo?.trim();
    return db.transaction(() async {
      final at = now();
      return [
        for (final hive in hives)
          await insertRecord(
            Treatment(
              id: generateId(),
              orgId: hive.orgId,
              hiveId: hive.id,
              apiaryId: hive.apiaryId,
              refDrugId: drug.refDrugId,
              drugId: drug.drugId,
              productName: drug.name,
              activeIngredient: drug.activeIngredient,
              batchNo: batchNo == null || batchNo.isEmpty ? null : batchNo,
              dose: plan.dose,
              doseUnit: drug.doseUnit,
              startedAt: plan.startedAt.toUtc(),
              plannedRemovalAt: plan.plannedRemovalAt?.toUtc(),
              withdrawalDays: plan.withdrawalDays,
              createdAt: at,
              updatedAt: at,
            ),
          ),
      ];
    });
  }

  static void _check(TreatmentPlan plan) {
    final drug = plan.drug;
    if ((drug.refDrugId == null) == (drug.drugId == null)) {
      throw ArgumentError.value(drug, 'drug', 'Tek bir listeden olmalı');
    }
    if (drug.name.trim().isEmpty) {
      throw ArgumentError.value(drug.name, 'drug.name');
    }
    if (!(plan.dose > 0)) throw ArgumentError.value(plan.dose, 'dose');
    if (plan.withdrawalDays < 0 || plan.withdrawalDays > maxWithdrawalDays) {
      throw ArgumentError.value(plan.withdrawalDays, 'withdrawalDays');
    }
    if (plan.plannedRemovalAt case final removal?
        when removal.isBefore(plan.startedAt)) {
      throw ArgumentError.value(removal, 'plannedRemovalAt');
    }
  }
}
