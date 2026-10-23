import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';

/// Sunucunun kalıcı olarak reddettiği yerel yazma; outbox'ta kalır.
final class RejectedRecord {
  const new({
    required this.table,
    required this.recordId,
    required this.error,
    required this.createdAt,
  });

  /// Sunucudaki tablo adı (`hives`).
  final String table;
  final String recordId;

  /// `<reason>: <message>`; neden `syncRejectionOf` ile okunur.
  final String error;

  /// Yerel yazmanın zamanı, UTC.
  final DateTime createdAt;
}

/// Senkronun yerel durumu: gönderilmeyi bekleyen ve reddedilen outbox
/// kayıtları, ilk tam çekme. Yalnız yerel DB'yi okur; ağa giden
/// `SyncService`'tir.
class SyncRepository {
  new(this._db);

  final AppDatabase _db;

  /// Gönderilmeyi bekleyen kayıt sayısı; reddedilenler sayılmaz.
  Stream<int> watchPendingCount() {
    final count = _db.outbox.id.count();
    final query = _db.selectOnly(_db.outbox)
      ..addColumns([count])
      ..where(_db.outbox.lastError.isNull());
    return query.map((row) => row.read(count)!).watchSingle();
  }

  /// Sunucunun kalıcı olarak reddettiği kayıtlar, oluşturulma sırasıyla.
  Stream<List<RejectedRecord>> watchRejected() =>
      (_db.select(_db.outbox)
            ..where((t) => t.lastError.isNotNull())
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .map(
            (entry) => RejectedRecord(
              table: entry.recordTable,
              recordId: entry.recordId,
              error: entry.lastError!,
              createdAt: entry.createdAt,
            ),
          )
          .watch();

  /// Bu cihazda ilk tam çekme bitti mi.
  Stream<bool> watchFullPullDone() =>
      (_db.select(_db.syncState)
            ..where((t) => t.recordTable.equals(fullPullMarker)))
          .watchSingleOrNull()
          .map((marker) => marker != null);

  /// Her yerel yazmada bir olay: repository'ler outbox'a kayıt ekler.
  /// Senkronun kendi silme ve işaretlemeleri olay sayılmaz.
  Stream<void> watchLocalWrites() => _db.tableUpdates(
    TableUpdateQuery.onTable(_db.outbox, limitUpdateKind: UpdateKind.insert),
  );
}
