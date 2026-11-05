import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/subsidies/domain/subsidy_rules.dart';

/// İşletmenin yerel satırı (`organizations`, senkronla iner). İşletme
/// `create_organization` ile kurulur; buradan yalnız alan güncellenir.
/// `sync_push` işletmeyi satırın tamamıyla günceller (eksik kolon boşalır),
/// bu yüzden outbox payload'u satırın bütün kolonlarını taşır. Sunucu
/// yalnız owner ve partner'ın güncellemesini kabul eder.
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
      await _enqueue(orgId, at);
      return true;
    });
  }

  /// İşletmenin yerel satırındaki profil alanları; inmemişse ya da
  /// silinmişse null.
  Stream<OrganizationProfile?> watchProfile(String orgId) =>
      (db.select(db.organizations)
            ..where((t) => t.id.equals(orgId) & t.deletedAt.isNull()))
          .map(
            (row) => (
              id: row.id,
              name: row.name,
              countryCode: row.countryCode,
              currency: row.currency,
              operationType: row.operationType,
              avatarColor: row.avatarColor,
              logoPath: row.logoPath,
              createdAt: row.createdAt as DateTime?,
            ),
          )
          .watchSingleOrNull();

  /// Profil formunun alanlarını yazar (son yazan kazanır); satır ve outbox
  /// tek transaction'da. Logo yeni bir yola geçtiyse dosya aynı
  /// transaction'da yükleme kuyruğuna girer. Para birimi yalnız bundan
  /// sonraki kayıtlara uygulanır; geçmiş hareketler kendi `currency`'sini
  /// taşır, dokunulmaz. Satır yoksa ya da silinmişse false; ad boşsa
  /// [ArgumentError].
  Future<bool> updateProfile(String orgId, BusinessProfileChange change) {
    final name = change.name.trim();
    if (name.isEmpty) throw ArgumentError.value(change.name, 'name');
    return db.transaction(() async {
      final before =
          await (db.select(db.organizations)
                ..where((t) => t.id.equals(orgId) & t.deletedAt.isNull()))
              .getSingleOrNull();
      if (before == null) return false;
      final at = clock().toUtc();
      await (db.update(
        db.organizations,
      )..where((t) => t.id.equals(orgId))).write(
        OrganizationsCompanion(
          name: Value(name),
          avatarColor: Value(change.avatarColor),
          logoPath: Value(change.logoPath),
          operationType: Value(change.operationType),
          currency: Value(change.currency),
          updatedAt: Value(at),
        ),
      );
      final logoPath = change.logoPath;
      if (logoPath != null && logoPath != before.logoPath) {
        await db
            .into(db.logoUploads)
            .insertOnConflictUpdate(
              LogoUploadsCompanion.insert(
                storagePath: logoPath,
                orgId: orgId,
                uploadStatus: MediaUploadStatus.pending,
                createdAt: at,
              ),
            );
      }
      await _enqueue(orgId, at);
      return true;
    });
  }

  /// İşletme türünü yazar; kurulumdaki gezginci seçimi de profildeki tür
  /// de bu alandır. Satır yoksa false.
  Future<bool> setOperationType(String orgId, OperationType type) =>
      db.transaction(() async {
        final at = clock().toUtc();
        final updated =
            await (db.update(
              db.organizations,
            )..where((t) => t.id.equals(orgId) & t.deletedAt.isNull())).write(
              OrganizationsCompanion(
                operationType: Value(type),
                updatedAt: Value(at),
              ),
            );
        if (updated == 0) return false;
        await _enqueue(orgId, at);
        return true;
      });

  /// Profil ekranının üç sayısı, kayıtlardan canlı: aktif kovan, arılık ve
  /// muayene (silinmişler sayılmaz). Herhangi bir tablo değişince yeniden
  /// yayar.
  Stream<BusinessCounts> watchCounts(String orgId) {
    final hiveCount = db.hives.id.count();
    final hives = db.selectOnly(db.hives)
      ..addColumns([hiveCount])
      ..where(
        db.hives.orgId.equals(orgId) &
            db.hives.deletedAt.isNull() &
            db.hives.status.equalsValue(HiveStatus.active),
      );
    final apiaryCount = db.apiaries.id.count();
    final apiaries = db.selectOnly(db.apiaries)
      ..addColumns([apiaryCount])
      ..where(db.apiaries.orgId.equals(orgId) & db.apiaries.deletedAt.isNull());
    final inspectionCount = db.inspections.id.count();
    final inspections = db.selectOnly(db.inspections)
      ..addColumns([inspectionCount])
      ..where(
        db.inspections.orgId.equals(orgId) & db.inspections.deletedAt.isNull(),
      );
    return db
        .customSelect(
          'SELECT 1',
          readsFrom: {db.hives, db.apiaries, db.inspections},
        )
        .watch()
        .asyncMap(
          (_) async => (
            hives: (await hives.getSingle()).read(hiveCount)!,
            apiaries: (await apiaries.getSingle()).read(apiaryCount)!,
            inspections: (await inspections.getSingle()).read(inspectionCount)!,
          ),
        );
  }

  /// Sabite geçerken gizlenecek gezginci kayıtları: silinmemiş göç planları
  /// ve onların silinmemiş durakları. Kayıtlar silinmez, yalnız sayılır.
  Future<MigratoryRecordCounts> countMigratoryRecords(String orgId) async {
    final migrations = db.migrations;
    final stops = db.migrationStops;
    final planCount = migrations.id.count();
    final plans =
        await (db.selectOnly(migrations)
              ..addColumns([planCount])
              ..where(
                migrations.orgId.equals(orgId) & migrations.deletedAt.isNull(),
              ))
            .getSingle();
    final stopCount = stops.id.count();
    final stopRows =
        await (db.selectOnly(stops).join([
                innerJoin(
                  migrations,
                  migrations.id.equalsExp(stops.migrationId),
                ),
              ])
              ..addColumns([stopCount])
              ..where(
                stops.orgId.equals(orgId) &
                    stops.deletedAt.isNull() &
                    migrations.deletedAt.isNull(),
              ))
            .getSingle();
    return (plans: plans.read(planCount)!, stops: stopRows.read(stopCount)!);
  }

  Future<void> _enqueue(String orgId, DateTime at) async {
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
    'operation_type': row.operationType.value,
    'avatar_color': row.avatarColor?.value,
    'logo_path': row.logoPath,
    'created_at': row.createdAt.toUtc().toIso8601String(),
    'updated_at': row.updatedAt.toUtc().toIso8601String(),
    'created_by': row.createdBy,
    'deleted_at': row.deletedAt?.toUtc().toIso8601String(),
  };
}
