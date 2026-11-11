import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/storage_file_sync.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';

/// İşletme logosunu `org-logos` bucket'ına yükler ve indirir; kural belge
/// ve fiş dosyalarınınkiyle aynı ([StorageFileSync]). İşletme satırı
/// `SyncService` ile, dosya burada gider; ikisi birbirini beklemez. Başka
/// telefonda seçilen logo satır inince indirilir, internetsiz görünür.
/// Bucket'ı üyeler okur, owner ve partner yazar.
///
/// Uygulamada tek örnek `logoSyncServiceProvider`'dan gelir.
class LogoSyncService {
  new(this._db, this._store, this._files, {this.clock = DateTime.now});

  final AppDatabase _db;
  final FileStore _store;
  final MediaFileStore _files;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'org-logos';

  late final _sync = StorageFileSync(
    _store,
    _files,
    bucket: bucket,
    clock: clock,
    nextUpload: _nextUpload,
    updateUpload: _updateUpload,
    downloadPaths: _downloadPaths,
    fileName: logoFileName,
    contentType: (_) => 'image/jpeg',
  );

  /// Bekleyen logoları yükler ([StorageFileSync.uploadPending]).
  Future<FileSyncResult> uploadPending() => _sync.uploadPending();

  /// [orgId]'nin logosu bu telefonda yoksa indirir
  /// ([StorageFileSync.downloadMissing]).
  Future<FileSyncResult> downloadMissing(String orgId) =>
      _sync.downloadMissing(orgId);

  /// Bekleyen logo sayısı; artınca yükleme başlar.
  Stream<int> watchPendingCount() {
    final uploads = _db.logoUploads;
    final count = uploads.storagePath.count();
    return (_db.selectOnly(uploads)
          ..addColumns([count])
          ..where(uploads.uploadStatus.equalsValue(MediaUploadStatus.pending)))
        .map((row) => row.read(count)!)
        .watchSingle();
  }

  /// Zamanı gelmiş en eski bekleyen logo.
  Future<PendingFileUpload?> _nextUpload(DateTime now) async {
    final upload =
        await (_db.select(_db.logoUploads)
              ..where(
                (t) =>
                    t.uploadStatus.equalsValue(MediaUploadStatus.pending) &
                    (t.nextAttemptAt.isNull() |
                        t.nextAttemptAt.isSmallerOrEqualValue(now)),
              )
              ..orderBy([
                (t) => OrderingTerm.asc(t.createdAt),
                (t) => OrderingTerm.asc(t.storagePath),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (upload == null) return null;
    return (storagePath: upload.storagePath, attempts: upload.attempts);
  }

  Future<void> _updateUpload(String storagePath, FileUploadChange change) =>
      (_db.update(
        _db.logoUploads,
      )..where((t) => t.storagePath.equals(storagePath))).write(
        LogoUploadsCompanion(
          uploadStatus: change.uploadStatus,
          attempts: change.attempts,
          nextAttemptAt: change.nextAttemptAt,
          lastError: change.lastError,
        ),
      );

  Future<List<String>> _downloadPaths(String orgId) =>
      (_db.select(_db.organizations)..where(
            (t) =>
                t.id.equals(orgId) &
                t.deletedAt.isNull() &
                t.logoPath.isNotNull(),
          ))
          .map((organization) => organization.logoPath!)
          .get();
}
