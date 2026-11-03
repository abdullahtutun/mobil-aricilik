import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/storage_file_sync.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Belge dosyalarını Storage'a yükler ve indirir. Satırlar `SyncService`
/// ile, dosyalar burada gider; ikisi birbirini beklemez. Tur kuralları
/// [StorageFileSync]'te.
///
/// Belgeler yol kontrolünde internetsiz açılmalı; bu yüzden başka telefonda
/// eklenen belgenin dosyası istenmeyi beklemeden, satır inince indirilir.
/// Belgeler azdır ve küçüktür; medyanın "sadece Wi‑Fi" ayarı burada
/// uygulanmaz.
///
/// Uygulamada tek örnek `documentSyncServiceProvider`'dan gelir.
class DocumentSyncService {
  new(this._db, this._client, this._files, {this.clock = DateTime.now});

  final AppDatabase _db;
  final SupabaseClient _client;
  final MediaFileStore _files;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'documents';

  late final _sync = StorageFileSync(
    _client,
    _files,
    bucket: bucket,
    clock: clock,
    nextUpload: _nextUpload,
    updateUpload: _updateUpload,
    downloadPaths: _downloadPaths,
    fileName: documentFileName,
    // Dosya değiştiyse yüklenecek olan eski yoldaki dosya; türü yoldan.
    contentType: (path) =>
        (path.endsWith('.${DocumentFileKind.pdf.extension}')
                ? DocumentFileKind.pdf
                : DocumentFileKind.photo)
            .contentType,
  );

  /// Bekleyen belge dosyalarını yükler ([StorageFileSync.uploadPending]).
  Future<FileSyncResult> uploadPending() => _sync.uploadPending();

  /// [orgId]'nin silinmemiş belgelerinden dosyası bu telefonda olmayanları
  /// indirir ([StorageFileSync.downloadMissing]).
  Future<FileSyncResult> downloadMissing(String orgId) =>
      _sync.downloadMissing(orgId);

  /// Zamanı gelmiş en eski bekleyen dosya; silinmiş belgeninki alınmaz.
  Future<PendingFileUpload?> _nextUpload(DateTime now) async {
    final uploads = _db.documentUploads;
    final documents = _db.documents;
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
    final upload = (await query.getSingleOrNull())?.readTable(uploads);
    if (upload == null) return null;
    return (storagePath: upload.storagePath, attempts: upload.attempts);
  }

  Future<void> _updateUpload(String storagePath, FileUploadChange change) =>
      (_db.update(
        _db.documentUploads,
      )..where((t) => t.storagePath.equals(storagePath))).write(
        DocumentUploadsCompanion(
          uploadStatus: change.uploadStatus,
          attempts: change.attempts,
          nextAttemptAt: change.nextAttemptAt,
          lastError: change.lastError,
        ),
      );

  Future<List<String>> _downloadPaths(String orgId) =>
      (_db.select(_db.documents)
            ..where((t) => t.orgId.equals(orgId) & t.deletedAt.isNull()))
          .map((document) => document.storagePath)
          .get();
}
