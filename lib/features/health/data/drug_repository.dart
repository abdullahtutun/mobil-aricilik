import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';

/// Referans ilaç listesi; salt okunur. Satırlar yalnız senkronla iner,
/// telefondan yazılmaz (outbox'a da gitmez).
class RefDrugRepository {
  new(this.db);

  final AppDatabase db;

  /// Silinmemiş referans ilaçlar, her ülke kodundan.
  Stream<List<RefDrug>> watchAll() =>
      (db.select(db.refDrugs)..where((t) => t.deletedAt.isNull())).watch();
}

/// İşletmenin eklediği ilaçlar; durum kaydı.
class DrugRepository extends BaseRepository<$DrugsTable, Drug> {
  new(super.db, {super.clock});

  @override
  $DrugsTable get table => db.drugs;

  @override
  Insertable<Drug> toInsertable(Drug record) => record.toInsertable();

  /// İşletmenin ilaçları.
  Stream<List<Drug>> watchAll(String orgId) =>
      watchWhere((t) => t.orgId.equals(orgId));

  /// Yeni ilacı yazar. Ad boşsa ya da bekleme süresi 0–[maxWithdrawalDays]
  /// dışındaysa [ArgumentError] atar ve bir şey yazmaz.
  Future<Drug> add({
    required String orgId,
    required String name,
    required DrugActiveIngredient activeIngredient,
    required DrugDoseUnit doseUnit,
    int? withdrawalDays,
  }) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError.value(name, 'name');
    if (withdrawalDays != null &&
        (withdrawalDays < 0 || withdrawalDays > maxWithdrawalDays)) {
      throw ArgumentError.value(withdrawalDays, 'withdrawalDays');
    }
    final at = now();
    return insertRecord(
      Drug(
        id: generateId(),
        orgId: orgId,
        name: trimmed,
        activeIngredient: activeIngredient,
        doseUnit: doseUnit,
        withdrawalDays: withdrawalDays,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}
