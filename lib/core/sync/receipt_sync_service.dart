import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/document_sync_service.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Fiş fotoğraflarını `receipts` bucket'ına yükler ve indirir. Satırlar
/// `SyncService` ile, dosyalar burada gider; ikisi birbirini beklemez.
/// Kural belge dosyalarınınkiyle aynı ([DocumentSyncService]): başka
/// telefonda çekilen fiş satır inince indirilir, fiş internetsiz açılır.
/// Bucket'a yalnız owner ve partner erişir.
///
/// Aynı anda tek yükleme ve tek indirme turu çalışır; tur sürerken gelen
/// çağrı süren turun sonucunu bekler. Uygulamada tek örnek
/// `receiptSyncServiceProvider`'dan gelir.
class ReceiptSyncService {
  new(this._db, this._client, this._files, {this.clock = DateTime.now});

  final AppDatabase _db;
  final SupabaseClient _client;
  final MediaFileStore _files;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'receipts';

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 60);

  Future<DocumentSyncResult>? _uploading;
  Future<DocumentSyncResult>? _downloading;

  /// Zamanı gelmiş bekleyen fişleri sırayla yükler. Yüklenen ya da
  /// Storage'da zaten olan fiş `uploaded` olur. Geçici hatada (ağ, sunucu)
  /// fişin sonraki denemesi [uploadBackoff] kadar ertelenir ve tur durur.
  /// Yeniden denemenin işe yaramayacağı hatada (dosya yok, yetki yok) fiş
  /// `failed` olur, tur sürer.
  Future<DocumentSyncResult> uploadPending() =>
      _uploading ??= _upload().whenComplete(() => _uploading = null);

  /// [orgId]'nin silinmemiş fişli hareketlerinden fişi bu telefonda
  /// olmayanları indirir. Fiş Storage'da henüz yoksa atlanır, sonraki turda
  /// yeniden denenir. Geçici hatada tur durur.
  Future<DocumentSyncResult> downloadMissing(String orgId) =>
      _downloading ??= _download(orgId).whenComplete(() => _downloading = null);

  Future<DocumentSyncResult> _upload() async {
    var done = 0;
    var failed = 0;
    while (true) {
      final upload = await _nextUpload();
      if (upload == null) {
        return DocumentSyncResult(done: done, failed: failed);
      }
      switch (await _send(upload)) {
        case true:
          done++;
        case false:
          failed++;
        case null:
          return DocumentSyncResult(
            done: done,
            failed: failed,
            retryLater: true,
          );
      }
    }
  }

  /// Zamanı gelmiş en eski bekleyen fiş; silinmiş hareketinki alınmaz.
  Future<ReceiptUpload?> _nextUpload() async {
    final uploads = _db.receiptUploads;
    final transactions = _db.transactions;
    final now = clock().toUtc();
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
    final row = await query.getSingleOrNull();
    return row?.readTable<$ReceiptUploadsTable, ReceiptUpload>(uploads);
  }

  /// Yüklendiyse true, kalıcı hatada false, sonraya kaldıysa null.
  Future<bool?> _send(ReceiptUpload upload) async {
    final path = upload.storagePath;
    final file = await _files.find(receiptFileName(path));
    if (file == null) {
      await _fail(upload, 'missing_file: ${receiptFileName(path)}');
      return false;
    }
    try {
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            await file.readAsBytes(),
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
            retryAttempts: 0,
          )
          .timeout(requestTimeout);
    } on StorageException catch (error) {
      // Aynı yola ikinci yükleme: önceki deneme sunucuya ulaşmış, yanıtı
      // yolda kalmış.
      if (error.statusCode == '409') return await _markUploaded(upload);
      if (_isTransient(error.statusCode)) {
        await _postpone(upload, error.message);
        return null;
      }
      await _fail(upload, '${error.statusCode}: ${error.message}');
      return false;
    } on Exception catch (error) {
      // Bağlantı hatası, zaman aşımı, çevrimdışı token yenileme.
      await _postpone(upload, error.toString());
      return null;
    }
    return await _markUploaded(upload);
  }

  Future<bool> _markUploaded(ReceiptUpload upload) async {
    await _update(
      upload,
      ReceiptUploadsCompanion(
        uploadStatus: const Value(MediaUploadStatus.uploaded),
        attempts: Value(upload.attempts + 1),
        nextAttemptAt: const Value(null),
        lastError: const Value(null),
      ),
    );
    return true;
  }

  Future<void> _postpone(ReceiptUpload upload, String error) {
    final attempts = upload.attempts + 1;
    return _update(
      upload,
      ReceiptUploadsCompanion(
        attempts: Value(attempts),
        nextAttemptAt: Value(clock().toUtc().add(uploadBackoff(attempts))),
        lastError: Value(error),
      ),
    );
  }

  Future<void> _fail(ReceiptUpload upload, String error) => _update(
    upload,
    ReceiptUploadsCompanion(
      uploadStatus: const Value(MediaUploadStatus.failed),
      attempts: Value(upload.attempts + 1),
      lastError: Value(error),
    ),
  );

  Future<void> _update(ReceiptUpload upload, ReceiptUploadsCompanion values) =>
      (_db.update(
        _db.receiptUploads,
      )..where((t) => t.storagePath.equals(upload.storagePath))).write(values);

  Future<DocumentSyncResult> _download(String orgId) async {
    final transactions =
        await (_db.select(_db.transactions)..where(
              (t) =>
                  t.orgId.equals(orgId) &
                  t.deletedAt.isNull() &
                  t.receiptPath.isNotNull(),
            ))
            .get();
    var done = 0;
    var failed = 0;
    for (final transaction in transactions) {
      final path = transaction.receiptPath!;
      final fileName = receiptFileName(path);
      if (await _files.find(fileName) != null) continue;
      final Uint8List bytes;
      try {
        bytes = await _client.storage
            .from(bucket)
            .download(path)
            .timeout(requestTimeout);
      } on StorageException catch (error) {
        if (_isTransient(error.statusCode)) {
          return DocumentSyncResult(
            done: done,
            failed: failed,
            retryLater: true,
          );
        }
        // Henüz yüklenmemiş (400/404) ya da yetki yok.
        failed++;
        continue;
      } on Exception {
        return DocumentSyncResult(done: done, failed: failed, retryLater: true);
      }
      await _files.write(fileName, bytes);
      done++;
    }
    return DocumentSyncResult(done: done, failed: failed);
  }

  /// HTTP durumu olmayan hata (bağlantı), süresi dolmuş oturum, zaman
  /// aşımı, istek sınırı ve sunucu hataları.
  static bool _isTransient(String? statusCode) {
    final status = int.tryParse(statusCode ?? '');
    return status == null ||
        status == 401 ||
        status == 408 ||
        status == 429 ||
        status >= 500;
  }
}
