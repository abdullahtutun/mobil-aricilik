import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';

/// Kovanın durum değişiklikleri; olay kaydı. Yalnız eklenir; yanlış kayıt
/// [delete] ile silinir. Kovan deposu durum değişince aynı transaction'da
/// yazar.
class HiveStatusEventRepository
    extends BaseRepository<$HiveStatusEventsTable, HiveStatusEvent> {
  new(super.db, {super.clock});

  @override
  $HiveStatusEventsTable get table => db.hiveStatusEvents;

  @override
  Insertable<HiveStatusEvent> toInsertable(HiveStatusEvent record) =>
      record.toInsertable();

  /// İşletmenin bütün durum olayları, eskiden yeniye.
  Stream<List<HiveStatusEvent>> watchByOrg(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [(t) => OrderingTerm.asc(t.changedAt)],
  );

  /// Kovanın olayları, eskiden yeniye; okuma anında.
  Future<List<HiveStatusEvent>> findByHive(String hiveId) => (selectWhere(
    (t) => t.hiveId.equals(hiveId),
  )..orderBy([(t) => OrderingTerm.asc(t.changedAt)])).get();

  /// [before] kovanı [to] durumuna geçti. Kayıp nedeni yalnız söndü ya da
  /// kayboldu'da yazılır.
  Future<HiveStatusEvent> add(
    Hive before, {
    required HiveStatus to,
    required DateTime changedAt,
    HiveLossReason? lossReason,
  }) {
    final at = now();
    return insertRecord(
      HiveStatusEvent(
        id: generateId(),
        orgId: before.orgId,
        hiveId: before.id,
        apiaryId: before.apiaryId,
        fromStatus: before.status,
        toStatus: to,
        changedAt: changedAt.toUtc(),
        lossReason: to.isLoss ? lossReason : null,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}
