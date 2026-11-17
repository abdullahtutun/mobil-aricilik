import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';

/// Sunucunun kalıcı olarak reddettiği kayıt; yazmaları outbox'ta kalır.
/// Aynı kaydın birden çok reddedilen yazması (oluşturma, sonra düzenleme)
/// tek kayıt olarak gelir.
final class RejectedRecord {
  const new({
    required this.table,
    required this.recordId,
    required this.error,
    required this.createdAt,
    this.label,
  });

  /// Sunucudaki tablo adı (`hives`).
  final String table;
  final String recordId;

  /// Son reddin `<reason>: <message>`'ı; neden `syncRejectionOf` ile okunur.
  final String error;

  /// Kaydın reddedilen ilk yerel yazmasının zamanı, UTC.
  final DateTime createdAt;

  /// Kaydı tanıtan kısa ad (kovan numarası, arılık ya da görev adı); son
  /// yazmanın payload'undan. Yoksa null.
  final String? label;
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

  /// [records] (sunucudaki tablo adı, kayıt kimliği) içinden en az biri
  /// gönderilmeyi bekliyor mu ("eşitlenecek" rozeti); reddedilenler
  /// sayılmaz.
  Stream<bool> watchAnyPending(List<(String table, String id)> records) {
    if (records.isEmpty) return Stream.value(false);
    final outbox = _db.outbox;
    final count = outbox.id.count();
    final query = _db.selectOnly(outbox)
      ..addColumns([count])
      ..where(
        outbox.lastError.isNull() &
            Expression.or([
              for (final (table, id) in records)
                outbox.recordTable.equals(table) & outbox.recordId.equals(id),
            ]),
      );
    return query.map((row) => row.read(count)! > 0).watchSingle();
  }

  /// Gönderilmeyi bekleyen kayıtların tabloya göre sayısı (sunucudaki
  /// tablo adı → sayı); reddedilenler sayılmaz.
  Stream<Map<String, int>> watchPendingByTable() {
    final count = _db.outbox.id.count();
    final query = _db.selectOnly(_db.outbox)
      ..addColumns([_db.outbox.recordTable, count])
      ..where(_db.outbox.lastError.isNull())
      ..groupBy([_db.outbox.recordTable]);
    return query.watch().map(
      (rows) => {
        for (final row in rows)
          row.read(_db.outbox.recordTable)!: row.read(count)!,
      },
    );
  }

  /// Gönderilmeyi bekleyen en eski kaydın yazıldığı an (UTC); bekleyen
  /// yoksa null. Reddedilenler sayılmaz.
  Stream<DateTime?> watchOldestPendingAt() {
    final oldest = _db.outbox.createdAt.min();
    final query = _db.selectOnly(_db.outbox)
      ..addColumns([oldest])
      ..where(_db.outbox.lastError.isNull());
    return query.map((row) => row.read(oldest)).watchSingle();
  }

  /// Sunucunun kalıcı olarak reddettiği kayıtlar, ilk reddedilen
  /// yazmalarının sırasıyla; kayıt başına bir tane.
  Stream<List<RejectedRecord>> watchRejected() =>
      (_db.select(_db.outbox)
            ..where((t) => t.lastError.isNotNull())
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .watch()
          .map((entries) {
            final byRecord = <(String, String), List<OutboxEntry>>{};
            for (final entry in entries) {
              (byRecord[(entry.recordTable, entry.recordId)] ??= []).add(
                entry,
              );
            }
            return [
              for (final group in byRecord.values)
                RejectedRecord(
                  table: group.first.recordTable,
                  recordId: group.first.recordId,
                  error: group.last.lastError!,
                  createdAt: group.first.createdAt,
                  label: recordLabelOf(group.last.payload),
                ),
            ];
          });

  /// Reddedilen kaydın yazmalarını yeniden gönderilecek sıraya alır (ör.
  /// bağlı olduğu kayıt sonradan gönderildi ya da yetki verildi). Sunucu
  /// yine reddederse kayıt listeye döner.
  Future<void> retryRejected(String table, String recordId) =>
      (_db.update(_db.outbox)..where(
            (t) =>
                t.recordTable.equals(table) &
                t.recordId.equals(recordId) &
                t.lastError.isNotNull(),
          ))
          .write(const OutboxCompanion(lastError: Value(null)));

  /// Kaydın bu telefondaki değişikliklerinden vazgeçer: outbox'taki bütün
  /// yazmaları (reddedilen ve bekleyen) silinir. Kayıt sunucuya hiç
  /// ulaşmadıysa (`server_seq` boş) yerelden de silinir; ulaştıysa tablonun
  /// imleci kaydın numarasının gerisine çekilir, sonraki çekme kaydı
  /// sunucudaki hâliyle yeniden indirir ve yerel hâlin üstüne yazar. Hepsi
  /// tek transaction'da.
  Future<void> discardRejected(String table, String recordId) =>
      _db.transaction(() async {
        await (_db.delete(_db.outbox)..where(
              (t) =>
                  t.recordTable.equals(table) & t.recordId.equals(recordId),
            ))
            .go();
        final info = _db.allTables
            .where((info) => info.actualTableName == table)
            .firstOrNull;
        if (info == null ||
            !info.$columns.any((column) => column.name == 'server_seq')) {
          return;
        }
        // Tablo adı istemcinin kendi şemasından; kullanıcı girdisi değil.
        final row = await _db
            .customSelect(
              'SELECT server_seq FROM "$table" WHERE id = ?',
              variables: [Variable.withString(recordId)],
              readsFrom: {info},
            )
            .getSingleOrNull();
        if (row == null) return;
        final serverSeq = row.readNullable<int>('server_seq');
        if (serverSeq == null) {
          await _db.customUpdate(
            'DELETE FROM "$table" WHERE id = ?',
            variables: [Variable.withString(recordId)],
            updates: {info},
            updateKind: UpdateKind.delete,
          );
          return;
        }
        final cursor = await (_db.select(
          _db.syncState,
        )..where((t) => t.recordTable.equals(table))).getSingleOrNull();
        if (cursor != null && cursor.lastPulledSeq >= serverSeq) {
          await _db
              .into(_db.syncState)
              .insertOnConflictUpdate(
                SyncStateCompanion.insert(
                  recordTable: table,
                  lastPulledSeq: Value(serverSeq - 1),
                ),
              );
        }
      });

  /// Bu cihazda ilk tam çekme bitti mi.
  Stream<bool> watchFullPullDone() =>
      (_db.select(_db.syncState)
            ..where((t) => t.recordTable.equals(fullPullMarker)))
          .watchSingleOrNull()
          .map((marker) => marker != null);

  /// Payload'dan kaydı tanıtan kısa ad: ad, başlık, numara ya da kod.
  static String? recordLabelOf(Map<String, Object?> payload) {
    for (final key in const ['name', 'title', 'number', 'code']) {
      if (payload[key] case final String value when value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  /// Her yerel yazmada bir olay: repository'ler outbox'a kayıt ekler.
  /// Senkronun kendi silme ve işaretlemeleri olay sayılmaz.
  Stream<void> watchLocalWrites() => _db.tableUpdates(
    TableUpdateQuery.onTable(_db.outbox, limitUpdateKind: UpdateKind.insert),
  );
}
