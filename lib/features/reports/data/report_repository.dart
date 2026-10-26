import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';

/// Raporların okuduğu kayıtlar; yalnız yerel DB ile konuşur, yazmaz.
///
/// Rapor bir anın dökümü olduğu için okumalar Stream değil tek seferlik.
/// Silinmiş kovan ve arılıklar da okunur: eski kaydın numarası ve adı
/// raporda yazsın. Kayıtların silinmişleri kurallarda süzülür.
class ReportRepository {
  new(this.db);

  final AppDatabase db;

  /// İşletmenin tescil ve AKS numaraları. Satırı senkron yazar; ilk
  /// çekmeden önce yoksa boş numaralar.
  Stream<OrganizationRegistration> watchRegistration(String orgId) =>
      (db.select(db.organizations)
            ..where((t) => t.id.equals(orgId) & t.deletedAt.isNull()))
          .watchSingleOrNull()
          .map(
            (row) => OrganizationRegistration(
              registrationNo: row?.trRegistrationNo,
              aksNo: row?.trAksNo,
            ),
          );

  /// İşletmenin bütün uygulamaları.
  Future<List<Treatment>> findTreatments(String orgId) =>
      (db.select(db.treatments)..where((t) => t.orgId.equals(orgId))).get();

  /// İşletmenin bütün kovanları, silinmişler de.
  Future<List<Hive>> findHives(String orgId) =>
      (db.select(db.hives)..where((t) => t.orgId.equals(orgId))).get();

  /// Arılık kimliğinden adı, silinmişler de.
  Future<Map<String, String>> findApiaryNames(String orgId) async {
    final apiaries = await (db.select(
      db.apiaries,
    )..where((t) => t.orgId.equals(orgId))).get();
    return {for (final apiary in apiaries) apiary.id: apiary.name};
  }

  /// [hiveId] kovanının bütün kayıtları. Hasatlar, kovanın alındığı
  /// hasatlardır.
  Future<HiveRecords> findHiveRecords(String hiveId) async {
    final (
      inspections,
      treatments,
      feedings,
      miteCounts,
      harvests,
      locations,
    ) = await (
      (db.select(db.inspections)..where((t) => t.hiveId.equals(hiveId))).get(),
      (db.select(db.treatments)..where((t) => t.hiveId.equals(hiveId))).get(),
      (db.select(db.feedings)..where((t) => t.hiveId.equals(hiveId))).get(),
      (db.select(db.miteCounts)..where((t) => t.hiveId.equals(hiveId))).get(),
      _findHarvests(hiveId),
      (db.select(
        db.hiveLocationHistory,
      )..where((t) => t.hiveId.equals(hiveId))).get(),
    ).wait;
    return (
      inspections: inspections,
      treatments: treatments,
      feedings: feedings,
      miteCounts: miteCounts,
      harvests: harvests,
      locations: locations,
    );
  }

  /// Kovanın silinmemiş hasat kaydıyla alındığı hasatlar.
  Future<List<Harvest>> _findHarvests(String hiveId) {
    final query =
        db.select(db.harvests).join([
          innerJoin(
            db.harvestHives,
            db.harvestHives.harvestId.equalsExp(db.harvests.id),
          ),
        ])..where(
          db.harvestHives.hiveId.equals(hiveId) &
              db.harvestHives.deletedAt.isNull(),
        );
    return query.map((row) => row.readTable(db.harvests)).get();
  }
}
