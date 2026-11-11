import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/storage_file_sync.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';

/// Fiş fotoğraflarını `receipts` bucket'ına yükler ve indirir. Satırlar
/// `SyncService` ile, dosyalar burada gider; ikisi birbirini beklemez.
/// Kural belge dosyalarınınkiyle aynı ([StorageFileSync]): başka telefonda
/// çekilen fiş satır inince indirilir, fiş internetsiz açılır. Bucket'a
/// yalnız owner ve partner erişir.
///
/// Uygulamada tek örnek `receiptSyncServiceProvider`'dan gelir.
class ReceiptSyncService {
  new(this._db, this._store, this._files, {this.clock = DateTime.now});

  final AppDatabase _db;
  final FileStore _store;
  final MediaFileStore _files;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'receipts';

  late final _sync = StorageFileSync(
    _store,
    _files,
    bucket: bucket,
    clock: clock,
    nextUpload: _nextUpload,
    updateUpload: _updateUpload,
    downloadPaths: _downloadPaths,
    fileName: receiptFileName,
    contentType: (_) => 'image/jpeg',
  );

  /// Bekleyen fişleri yükler ([StorageFileSync.uploadPending]).
  Future<FileSyncResult> uploadPending() => _sync.uploadPending();

  /// [orgId]'nin silinmemiş fişli hareketlerinden fişi bu telefonda
  /// olmayanları indirir ([StorageFileSync.downloadMissing]).
  Future<FileSyncResult> downloadMissing(String orgId) =>
      _sync.downloadMissing(orgId);

  /// Zamanı gelmiş en eski bekleyen fiş; silinmiş hareketinki alınmaz.
  Future<PendingFileUpload?> _nextUpload(DateTime now) async {
    final uploads = _db.receiptUploads;
    final transactions = _db.transactions;
    final query =
        _db.select(uploads).join([
            innerJoin(
              transactions,
              transactions.id.equalsExp(uploads.transactionId),
            ),
          ])
          ..where(
            uploads.uploadStatus.equalsValue(MediaUploadStatus.pending) &
                transactions.deletedAt.isNull() &
                (uploads.nextAttemptAt.isNull() |
                    uploads.nextAttemptAt.isSmallerOrEqualValue(now)),
          )
          ..orderBy([
            OrderingTerm.asc(uploads.createdAt),
            OrderingTerm.asc(uploads.storagePath),
          ])
          ..limit(1);
    final upload = (await query.getSingleOrNull())?.readTable(uploads);
    if (upload == null) return null;
    return (storagePath: upload.storagePath, attempts: upload.attempts);
  }

  Future<void> _updateUpload(String storagePath, FileUploadChange change) =>
      (_db.update(
        _db.receiptUploads,
      )..where((t) => t.storagePath.equals(storagePath))).write(
        ReceiptUploadsCompanion(
          uploadStatus: change.uploadStatus,
          attempts: change.attempts,
          nextAttemptAt: change.nextAttemptAt,
          lastError: change.lastError,
        ),
      );

  Future<List<String>> _downloadPaths(String orgId) =>
      (_db.select(_db.transactions)..where(
            (t) =>
                t.orgId.equals(orgId) &
                t.deletedAt.isNull() &
                t.receiptPath.isNotNull(),
          ))
          .map((transaction) => transaction.receiptPath!)
          .get();
}
