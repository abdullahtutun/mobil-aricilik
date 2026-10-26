import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

/// Arılıklar; durum kaydı, son yazan kazanır.
class ApiaryRepository extends BaseRepository<$ApiariesTable, Apiary> {
  new(super.db, {super.clock});

  @override
  $ApiariesTable get table => db.apiaries;

  @override
  Insertable<Apiary> toInsertable(Apiary record) => record.toInsertable();

  /// İşletmenin arılıkları, ada göre.
  Stream<List<Apiary>> watchAll(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [(t) => OrderingTerm.asc(t.name)],
  );

  /// İşletmenin konumu olan, silinmemiş arılıklarının kimlikleri.
  Future<Set<String>> locatedIds(String orgId) async {
    final query = db.selectOnly(table)
      ..addColumns([table.id])
      ..where(
        table.orgId.equals(orgId) &
            table.deletedAt.isNull() &
            table.latitude.isNotNull(),
      );
    return {for (final row in await query.get()) row.read(table.id)!};
  }

  /// İşletmenin arılıkları aktif kovan sayılarıyla, ada göre (SQLite
  /// sırası). Kovan eklenince, taşınınca ya da durumu değişince de yayar.
  Stream<List<ApiarySummary>> watchSummaries(String orgId) =>
      _watchSummaries(db.apiaries.orgId.equals(orgId));

  /// Arılık ve aktif kovan sayısı; yoksa ya da silinmişse null.
  Stream<ApiarySummary?> watchSummary(String id) =>
      _watchSummaries(db.apiaries.id.equals(id))
          .map((summaries) => summaries.singleOrNull);

  Stream<List<ApiarySummary>> _watchSummaries(Expression<bool> filter) {
    final apiaries = db.apiaries;
    final hives = db.hives;
    final activeHiveCount = hives.id.count();
    final query =
        db.select(apiaries).join([
            leftOuterJoin(
              hives,
              hives.apiaryId.equalsExp(apiaries.id) &
                  hives.deletedAt.isNull() &
                  hives.status.equalsValue(HiveStatus.active),
              useColumns: false,
            ),
          ])
          ..addColumns([activeHiveCount])
          ..where(apiaries.deletedAt.isNull() & filter)
          ..groupBy([apiaries.id])
          ..orderBy([OrderingTerm.asc(apiaries.name)]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          ApiarySummary(
            apiary: row.readTable(apiaries),
            activeHiveCount: row.read(activeHiveCount) ?? 0,
          ),
      ],
    );
  }

  /// [latitude] ve [longitude] birlikte verilir ya da ikisi de boş kalır.
  Future<Apiary> create({
    required String orgId,
    required String name,
    double? latitude,
    double? longitude,
    int? altitudeM,
    String? landownerName,
    String? landownerPhone,
    LandTenure? landTenure,
    String? waterSource,
    int? vehicleDistanceM,
    String? roadNotes,
    String? notes,
  }) {
    final at = now();
    return insertRecord(
      Apiary(
        id: generateId(),
        orgId: orgId,
        name: name,
        latitude: latitude,
        longitude: longitude,
        altitudeM: altitudeM,
        landownerName: landownerName,
        landownerPhone: landownerPhone,
        landTenure: landTenure,
        waterSource: waterSource,
        vehicleDistanceM: vehicleDistanceM,
        roadNotes: roadNotes,
        notes: notes,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }

  /// Arılığın alanlarını yazar.
  Future<Apiary> update(Apiary apiary) => updateRecord(apiary);
}
