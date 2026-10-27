import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Belge dosyalarını Storage'a yükler ve indirir. Satırlar `SyncService`
/// ile, dosyalar burada gider; ikisi birbirini beklemez.
///
/// Belgeler yol kontrolünde internetsiz açılmalı; bu yüzden başka telefonda
/// eklenen belgenin dosyası istenmeyi beklemeden, satır inince indirilir.
/// Belgeler azdır ve küçüktür; medyanın "sadece Wi‑Fi" ayarı burada
/// uygulanmaz.
///
/// Aynı anda tek yükleme ve tek indirme turu çalışır; tur sürerken gelen
/// çağrı süren turun sonucunu bekler. Uygulamada tek örnek
/// `documentSyncServiceProvider`'dan gelir.
class DocumentSyncService {
  new(this._db, this._client, this._files, {this.clock = DateTime.now});

  final AppDatabase _db;
  final SupabaseClient _client;
  final MediaFileStore _files;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'documents';

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 60);

  Future<DocumentSyncResult>? _uploading;
  Future<DocumentSyncResult>? _downloading;

  /// Zamanı gelmiş bekleyen dosyaları sırayla yükler. Yüklenen ya da
  /// Storage'da zaten olan dosya `uploaded` olur. Geçici hatada (ağ,
  /// sunucu) dosyanın sonraki denemesi [uploadBackoff] kadar ertelenir ve
  /// tur durur. Yeniden denemenin işe yaramayacağı hatada (dosya yok, yetki
  /// yok, dosya çok büyük) dosya `failed` olur, tur sürer.
  Future<DocumentSyncResult> uploadPending() =>
      _uploading ??= _upload().whenComplete(() => _uploading = null);

  /// [orgId]'nin silinmemiş belgelerinden dosyası bu telefonda olmayanları
  /// indirir. Dosya Storage'da henüz yoksa (ekleyen telefon yüklemedi) o
  /// belge atlanır, sonraki turda yeniden denenir. Geçici hatada tur durur.
  Future<DocumentSyncResult> downloadMissing(String orgId) =>
      _downloading ??= _download(orgId).whenComplete(() => _downloading = null);

  Future<DocumentSyncResult> _upload() async {
    var done = 0;
    var failed = 0;
    while (true) {
      final job = await _nextJob();
      if (job == null) {
        return DocumentSyncResult(done: done, failed: failed);
      }
      switch (await _send(job)) {
        case _Sent.uploaded:
          done++;
        case _Sent.failed:
          failed++;
        case _Sent.retryLater:
          return DocumentSyncResult(
            done: done,
            failed: failed,
            retryLater: true,
          );
      }
    }
  }

  /// Zamanı gelmiş en eski bekleyen dosya; silinmiş belgeninki alınmaz.
  Future<_Job?> _nextJob() async {
    final uploads = _db.documentUploads;
    final documents = _db.documents;
    final now = clock().toUtc();
    final query =
        _db.select(uploads).join([
            innerJoin(documents, documents.id.equalsExp(uploads.documentId)),
          ])
          ..where(
            uploads.uploadStatus.equalsValue(MediaUploadStatus.pending) &
                documents.deletedAt.isNull() &
                (uploads.nextAttemptAt.isNull() |
                    uploads.nextAttemptAt.isSmallerOrEqualValue(now)),
          )
          ..orderBy([
            OrderingTerm.asc(uploads.createdAt),
            OrderingTerm.asc(uploads.storagePath),
          ])
          ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return _Job(row.readTable(uploads));
  }

  Future<_Sent> _send(_Job job) async {
    final path = job.upload.storagePath;
    // Dosya değiştiyse yüklenecek olan eski yoldaki dosya; türü yoldan.
    final kind = path.endsWith('.${DocumentFileKind.pdf.extension}')
        ? DocumentFileKind.pdf
        : DocumentFileKind.photo;
    final file = await _files.find(documentFileName(path));
    if (file == null) {
      await _fail(job, 'missing_file: ${documentFileName(path)}');
      return _Sent.failed;
    }
    try {
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            await file.readAsBytes(),
            fileOptions: FileOptions(contentType: kind.contentType),
            retryAttempts: 0,
          )
          .timeout(requestTimeout);
    } on StorageException catch (error) {
      // Aynı yola ikinci yükleme: önceki deneme sunucuya ulaşmış, yanıtı
      // yolda kalmış.
      if (error.statusCode == '409') return await _markUploaded(job);
      if (_isTransient(error.statusCode)) {
        await _postpone(job, error.message);
        return _Sent.retryLater;
      }
      await _fail(job, '${error.statusCode}: ${error.message}');
      return _Sent.failed;
    } on Exception catch (error) {
      // Bağlantı hatası, zaman aşımı, çevrimdışı token yenileme.
      await _postpone(job, error.toString());
      return _Sent.retryLater;
    }
    return await _markUploaded(job);
  }

  Future<_Sent> _markUploaded(_Job job) async {
    await _update(
      job,
      DocumentUploadsCompanion(
        uploadStatus: const Value(MediaUploadStatus.uploaded),
        attempts: Value(job.upload.attempts + 1),
        nextAttemptAt: const Value(null),
        lastError: const Value(null),
      ),
    );
    return _Sent.uploaded;
  }

  Future<void> _postpone(_Job job, String error) {
    final attempts = job.upload.attempts + 1;
    return _update(
      job,
      DocumentUploadsCompanion(
        attempts: Value(attempts),
        nextAttemptAt: Value(clock().toUtc().add(uploadBackoff(attempts))),
        lastError: Value(error),
      ),
    );
  }

  Future<void> _fail(_Job job, String error) => _update(
    job,
    DocumentUploadsCompanion(
      uploadStatus: const Value(MediaUploadStatus.failed),
      attempts: Value(job.upload.attempts + 1),
      lastError: Value(error),
    ),
  );

  Future<void> _update(_Job job, DocumentUploadsCompanion values) =>
      (_db.update(_db.documentUploads)
            ..where((t) => t.storagePath.equals(job.upload.storagePath)))
          .write(values);

  Future<DocumentSyncResult> _download(String orgId) async {
    final documents = await (_db.select(
      _db.documents,
    )..where((t) => t.orgId.equals(orgId) & t.deletedAt.isNull())).get();
    var done = 0;
    var failed = 0;
    for (final document in documents) {
      final fileName = documentFileName(document.storagePath);
      if (await _files.find(fileName) != null) continue;
      final Uint8List bytes;
      try {
        bytes = await _client.storage
            .from(bucket)
            .download(document.storagePath)
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

  /// HTTP durumu olmayan hata (bağlantı; storage_client türün adını yazar),
  /// süresi dolmuş oturum, zaman aşımı, istek sınırı ve sunucu hataları.
  static bool _isTransient(String? statusCode) {
    final status = int.tryParse(statusCode ?? '');
    return status == null ||
        status == 401 ||
        status == 408 ||
        status == 429 ||
        status >= 500;
  }
}

/// Yükleme ya da indirme turunun sonucu.
class DocumentSyncResult {
  const new({this.done = 0, this.failed = 0, this.retryLater = false});

  /// Yüklenen ya da indirilen dosyalar.
  final int done;

  /// Bu turda kalıcı hata alan (yüklemede) ya da henüz indirilemeyen
  /// dosyalar.
  final int failed;

  /// Geçici hata; kalanlar sonraki tura kaldı.
  final bool retryLater;

  @override
  String toString() =>
      'DocumentSyncResult(done: $done, failed: $failed, '
      'retryLater: $retryLater)';
}

class _Job {
  const new(this.upload);

  final DocumentUpload upload;
}

enum _Sent { uploaded, failed, retryLater }
