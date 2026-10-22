import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';

/// Kovanın arılık geçmişi; olay kaydı. Yalnız eklenir, güncelleme yok;
/// yanlış kayıt [delete] ile silinir.
class HiveLocationRepository
    extends BaseRepository<$HiveLocationHistoryTable, HiveLocationEntry> {
  new(super.db, {super.clock});

  @override
  $HiveLocationHistoryTable get table => db.hiveLocationHistory;

  @override
  Insertable<HiveLocationEntry> toInsertable(HiveLocationEntry record) =>
      record.toInsertable();

  /// Kovanın geçmişi, en yeni önce.
  Stream<List<HiveLocationEntry>> watchByHive(String hiveId) => watchWhere(
    (t) => t.hiveId.equals(hiveId),
    orderBy: [(t) => OrderingTerm.desc(t.movedAt)],
  );

  /// Kovan [movedAt] zamanında [apiaryId] arılığına geldi.
  Future<HiveLocationEntry> add({
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required DateTime movedAt,
  }) {
    final at = now();
    return insertRecord(
      HiveLocationEntry(
        id: generateId(),
        orgId: orgId,
        hiveId: hiveId,
        apiaryId: apiaryId,
        movedAt: movedAt.toUtc(),
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}
