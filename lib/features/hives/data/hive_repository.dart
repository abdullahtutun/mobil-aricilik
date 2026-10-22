import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

/// Kovanlar; durum kaydı, son yazan kazanır. Arılık geçmişi
/// [HiveLocationRepository]'de.
///
/// [HiveLocationRepository]: package:mobil_arici/features/hives/data/hive_location_repository.dart
class HiveRepository extends BaseRepository<$HivesTable, Hive> {
  new(super.db, {super.clock});

  @override
  $HivesTable get table => db.hives;

  @override
  Insertable<Hive> toInsertable(Hive record) => record.toInsertable();

  /// İşletmenin kovanları, numaraya göre (metin sırası).
  Stream<List<Hive>> watchAll(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [(t) => OrderingTerm.asc(t.number)],
  );

  /// Arılıktaki kovanlar, numaraya göre (metin sırası).
  Stream<List<Hive>> watchByApiary(String apiaryId) => watchWhere(
    (t) => t.apiaryId.equals(apiaryId),
    orderBy: [(t) => OrderingTerm.asc(t.number)],
  );

  Future<Hive> create({
    required String orgId,
    required String number,
    required HiveType type,
    required String apiaryId,
    HiveStatus status = HiveStatus.active,
    String? tagCode,
    String? queenId,
    int boxCount = 1,
    int? frameCount,
    HiveSource? source,
    String? marking,
  }) {
    final at = now();
    return insertRecord(
      Hive(
        id: generateId(),
        orgId: orgId,
        number: number,
        type: type,
        apiaryId: apiaryId,
        status: status,
        tagCode: tagCode,
        queenId: queenId,
        boxCount: boxCount,
        frameCount: frameCount,
        source: source,
        marking: marking,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }

  /// Kovanın alanlarını yazar.
  Future<Hive> update(Hive hive) => updateRecord(hive);
}
