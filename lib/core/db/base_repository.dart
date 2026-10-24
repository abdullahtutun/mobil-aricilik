import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show protected;
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';

/// Güncellemede değişmeyen kolonlar: kimlik, işletme ve sunucunun
/// doldurduğu alanlar. Silme yalnız [BaseRepository.delete] ile yapılır.
const _fixedOnUpdate = {
  'id',
  'org_id',
  'created_at',
  'created_by',
  'deleted_at',
  'server_seq',
};

/// Senkronlanan bir tablonun ortak repository'si; yalnız yerel DB ile
/// konuşur.
///
/// Her yazma tek transaction'da hem tabloya hem `outbox`'a gider; ikisinden
/// biri başarısız olursa hiçbiri yazılmaz. Outbox payload'u satırın yazma
/// sonrası tam hâlidir. Okumalar silinmiş satırları içermez ve Stream
/// döner; senkron yeni veri yazınca dinleyenler güncellenir. Silme
/// yumuşaktır: `deleted_at` dolar, satır yerinde kalır ve silme de diğer
/// cihazlara ulaşır.
///
/// Alt sınıflar tabloya uygun yazmaları açar: durum kayıtları
/// [updateRecord] ile güncellenir (son yazan kazanır), olay kayıtları
/// yalnız eklenir.
abstract class BaseRepository<T extends SyncColumns, R extends SyncedRecord> {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;

  /// Yazma zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  TableInfo<T, R> get table;

  /// Üretilen `toInsertable()` uzantısını çağırır.
  @protected
  Insertable<R> toInsertable(R record);

  /// Yazma zamanı, UTC.
  @protected
  DateTime now() => clock().toUtc();

  /// Kaydı izler; yoksa ya da silinmişse null yayar.
  Stream<R?> watchById(String id) => _select(id).watchSingleOrNull();

  /// Kayıt; yoksa ya da silinmişse null.
  Future<R?> findById(String id) => _select(id).getSingleOrNull();

  /// Kayıt; yoksa ya da silinmişse [StateError].
  @protected
  Future<R> requireById(String id) async =>
      await findById(id) ??
      (throw StateError('${table.actualTableName}/$id yok ya da silinmiş'));

  /// [filter]'a uyan silinmemiş kayıtların sorgusu.
  @protected
  SimpleSelectStatement<T, R> selectWhere(
    Expression<bool> Function(T t) filter,
  ) => db.select(table)..where((t) => t.deletedAt.isNull() & filter(t));

  /// [filter]'a uyan silinmemiş kayıtları [orderBy] sırasıyla izler.
  @protected
  Stream<List<R>> watchWhere(
    Expression<bool> Function(T t) filter, {
    List<OrderingTerm Function(T t)> orderBy = const [],
  }) => (selectWhere(filter)..orderBy(orderBy)).watch();

  /// Yeni kaydı tabloya ve outbox'a yazar. Kimlik ve zamanları alt sınıf
  /// verir ([now]).
  @protected
  Future<R> insertRecord(R record) => db.transaction(() async {
    await db.into(table).insert(toInsertable(record));
    return await _enqueue(record.id, OutboxOperation.upsert);
  });

  /// Kaydın alanlarını yazar ve `updated_at`'i şimdiye çeker. Kimlik,
  /// işletme ve sunucu alanları değişmez. Kayıt yoksa ya da silinmişse
  /// [StateError] atar ve bir şey yazmaz.
  @protected
  Future<R> updateRecord(R record) => db.transaction(() async {
    final values = toInsertable(record).toColumns(false)
      ..removeWhere((column, _) => _fixedOnUpdate.contains(column))
      ..['updated_at'] = Variable(now());
    final updated = await (db.update(
      table,
    )..where((t) => _live(t, record.id))).write(RawValuesInsertable(values));
    if (updated == 0) {
      throw StateError(
        '${table.actualTableName}/${record.id} yok ya da silinmiş',
      );
    }
    return await _enqueue(record.id, OutboxOperation.upsert);
  });

  /// Kaydı yumuşak siler. Kayıt yoksa ya da zaten silinmişse bir şey
  /// yazmaz.
  Future<void> delete(String id) => db.transaction(() async {
    final at = now();
    final updated = await (db.update(table)..where((t) => _live(t, id))).write(
      RawValuesInsertable({
        'deleted_at': Variable(at),
        'updated_at': Variable(at),
      }),
    );
    if (updated > 0) await _enqueue(id, OutboxOperation.delete);
  });

  Expression<bool> _live(T t, String id) =>
      t.id.equals(id) & t.deletedAt.isNull();

  SimpleSelectStatement<T, R> _select(String id) =>
      db.select(table)..where((t) => _live(t, id));

  /// Satırın yazma sonrası hâlini outbox'a ekler ve döner.
  Future<R> _enqueue(String id, OutboxOperation operation) async {
    final record = await (db.select(
      table,
    )..where((t) => t.id.equals(id))).getSingle();
    await db
        .into(db.outbox)
        .insert(
          OutboxCompanion.insert(
            recordTable: table.actualTableName,
            recordId: id,
            operation: operation,
            payload: record.toJson(),
            createdAt: now(),
          ),
        );
    return record;
  }
}
