import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/subsidies/domain/subsidy_rules.dart';

/// İşletmenin yerel satırı (`organizations`, senkronla iner). İşletme
/// `create_organization` ile kurulur; buradan yalnız alan güncellenir.
/// `sync_push` işletmeyi satırın tamamıyla günceller (eksik kolon boşalır),
/// bu yüzden outbox payload'u satırın bütün kolonlarını taşır. Sunucu
/// yalnız owner'ın güncellemesini kabul eder.
class OrganizationRepository {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;

  /// Yazma zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  /// İşletmenin AKS'de beyan ettiği kovan sayısı; girilmemişse null.
  /// İşletme satırı henüz inmemişse de null yayar.
  Stream<int?> watchAksHiveCount(String orgId) =>
      (db.select(db.organizations)
            ..where((t) => t.id.equals(orgId) & t.deletedAt.isNull()))
          .map((row) => row.trAksHiveCount)
          .watchSingleOrNull();

  /// AKS'de beyan edilen kovan sayısını yazar ([count] null ise siler);
  /// satır ve outbox tek transaction'da. İşletme satırı bu telefonda yoksa
  /// (senkronla inmedi) ya da silinmişse bir şey yazmaz ve false döner;
  /// sayı 0..[maxAksHiveCount] dışındaysa [ArgumentError].
  Future<bool> setAksHiveCount(String orgId, int? count) {
    if (count != null && (count < 0 || count > maxAksHiveCount)) {
      throw ArgumentError.value(count, 'count');
    }
    return db.transaction(() async {
      final at = clock().toUtc();
      final updated =
          await (db.update(
            db.organizations,
          )..where((t) => t.id.equals(orgId) & t.deletedAt.isNull())).write(
            OrganizationsCompanion(
              trAksHiveCount: Value(count),
              updatedAt: Value(at),
            ),
          );
      if (updated == 0) return false;
      final row = await (db.select(
        db.organizations,
      )..where((t) => t.id.equals(orgId))).getSingle();
      await db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              recordTable: db.organizations.actualTableName,
              recordId: orgId,
              operation: OutboxOperation.upsert,
              payload: _payload(row),
              createdAt: at,
            ),
          );
      return true;
    });
  }

  /// Satırın sunucu kolon adlarıyla tam hâli; `server_seq` hariç.
  static Map<String, Object?> _payload(OrganizationRow row) => {
    'id': row.id,
    'name': row.name,
    'country_code': row.countryCode,
    'currency': row.currency,
    'tr_registration_no': row.trRegistrationNo,
    'tr_aks_no': row.trAksNo,
    'hive_count_range': row.hiveCountRange?.value,
    'tr_aks_hive_count': row.trAksHiveCount,
    'created_at': row.createdAt.toUtc().toIso8601String(),
    'updated_at': row.updatedAt.toUtc().toIso8601String(),
    'created_by': row.createdBy,
    'deleted_at': row.deletedAt?.toUtc().toIso8601String(),
  };
}
