import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/tables/media_tables.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Bekleyen yüklemenin Storage yolu ve şimdiye kadarki deneme sayısı.
typedef PendingFileUpload = ({String storagePath, int attempts});

/// Yükleme satırına yazılacak değişiklik; `Value.absent()` kolon değişmez.
typedef FileUploadChange = ({
  Value<MediaUploadStatus> uploadStatus,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String?> lastError,
});

/// Storage yolu ve yerel adı aynı olan dosyaları (belge, fiş) bir bucket'a
/// yükler ve indirir. Kuyruk tablosunu ve indirilecek yolları çağıran verir
/// (`DocumentSyncService`, `ReceiptSyncService`); tur kuralları burada.
///
/// Aynı anda tek yükleme ve tek indirme turu çalışır; tur sürerken gelen
/// çağrı süren turun sonucunu bekler.
class StorageFileSync {
  new(
    this._client,
    this._files, {
    required this.bucket,
    required this.clock,
    required this.nextUpload,
    required this.updateUpload,
    required this.downloadPaths,
    required this.fileName,
    required this.contentType,
  });

  final SupabaseClient _client;
  final MediaFileStore _files;
  final String bucket;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  /// Zamanı gelmiş en eski bekleyen yükleme; sahibi silinmişse alınmaz.
  final Future<PendingFileUpload?> Function(DateTime now) nextUpload;

  /// Yükleme satırını [FileUploadChange] ile günceller.
  final Future<void> Function(String storagePath, FileUploadChange change)
  updateUpload;

  /// Org'un bu telefonda olması gereken dosyaların Storage yolları.
  final Future<List<String>> Function(String orgId) downloadPaths;

  /// Storage yolundan yerel dosya adı.
  final String Function(String storagePath) fileName;
  final String Function(String storagePath) contentType;

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 60);

  Future<FileSyncResult>? _uploading;
  Future<FileSyncResult>? _downloading;

  /// Zamanı gelmiş bekleyen dosyaları sırayla yükler. Yüklenen ya da
  /// Storage'da zaten olan dosya `uploaded` olur. Geçici hatada (ağ,
  /// sunucu) dosyanın sonraki denemesi [uploadBackoff] kadar ertelenir ve
  /// tur durur. Yeniden denemenin işe yaramayacağı hatada (dosya yok, yetki
  /// yok, dosya çok büyük) dosya `failed` olur, tur sürer.
  Future<FileSyncResult> uploadPending() =>
      _uploading ??= _upload().whenComplete(() => _uploading = null);

  /// [orgId]'nin dosyalarından bu telefonda olmayanları indirir. Dosya
  /// Storage'da henüz yoksa (ekleyen telefon yüklemedi) atlanır, sonraki
  /// turda yeniden denenir. Geçici hatada tur durur.
  Future<FileSyncResult> downloadMissing(String orgId) =>
      _downloading ??= _download(orgId).whenComplete(() => _downloading = null);

  Future<FileSyncResult> _upload() async {
    var done = 0;
    var failed = 0;
    while (true) {
      final upload = await nextUpload(clock().toUtc());
      if (upload == null) return FileSyncResult(done: done, failed: failed);
      switch (await _send(upload)) {
        case _Sent.uploaded:
          done++;
        case _Sent.failed:
          failed++;
        case _Sent.retryLater:
          return FileSyncResult(done: done, failed: failed, retryLater: true);
      }
    }
  }

  Future<_Sent> _send(PendingFileUpload upload) async {
    final path = upload.storagePath;
    final file = await _files.find(fileName(path));
    if (file == null) {
      await _fail(upload, 'missing_file: ${fileName(path)}');
      return _Sent.failed;
    }
    try {
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            await file.readAsBytes(),
            fileOptions: FileOptions(contentType: contentType(path)),
            retryAttempts: 0,
          )
          .timeout(requestTimeout);
    } on StorageException catch (error) {
      // Aynı yola ikinci yükleme: önceki deneme sunucuya ulaşmış, yanıtı
      // yolda kalmış.
      if (error.statusCode == '409') return await _markUploaded(upload);
      if (_isTransient(error.statusCode)) {
        await _postpone(upload, error.message);
        return _Sent.retryLater;
      }
      await _fail(upload, '${error.statusCode}: ${error.message}');
      return _Sent.failed;
    } on Exception catch (error) {
      // Bağlantı hatası, zaman aşımı, çevrimdışı token yenileme.
      await _postpone(upload, error.toString());
      return _Sent.retryLater;
    }
    return await _markUploaded(upload);
  }

  Future<_Sent> _markUploaded(PendingFileUpload upload) async {
    await updateUpload(upload.storagePath, (
      uploadStatus: const Value(MediaUploadStatus.uploaded),
      attempts: Value(upload.attempts + 1),
      nextAttemptAt: const Value(null),
      lastError: const Value(null),
    ));
    return _Sent.uploaded;
  }

  Future<void> _postpone(PendingFileUpload upload, String error) {
    final attempts = upload.attempts + 1;
    return updateUpload(upload.storagePath, (
      uploadStatus: const Value.absent(),
      attempts: Value(attempts),
      nextAttemptAt: Value(clock().toUtc().add(uploadBackoff(attempts))),
      lastError: Value(error),
    ));
  }

  Future<void> _fail(PendingFileUpload upload, String error) =>
      updateUpload(upload.storagePath, (
        uploadStatus: const Value(MediaUploadStatus.failed),
        attempts: Value(upload.attempts + 1),
        nextAttemptAt: const Value.absent(),
        lastError: Value(error),
      ));

  Future<FileSyncResult> _download(String orgId) async {
    var done = 0;
    var failed = 0;
    for (final path in await downloadPaths(orgId)) {
      final name = fileName(path);
      if (await _files.find(name) != null) continue;
      final Uint8List bytes;
      try {
        bytes = await _client.storage
            .from(bucket)
            .download(path)
            .timeout(requestTimeout);
      } on StorageException catch (error) {
        if (_isTransient(error.statusCode)) {
          return FileSyncResult(done: done, failed: failed, retryLater: true);
        }
        // Henüz yüklenmemiş (400/404) ya da yetki yok.
        failed++;
        continue;
      } on Exception {
        return FileSyncResult(done: done, failed: failed, retryLater: true);
      }
      await _files.write(name, bytes);
      done++;
    }
    return FileSyncResult(done: done, failed: failed);
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
class FileSyncResult {
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
      'FileSyncResult(done: $done, failed: $failed, retryLater: $retryLater)';
}

enum _Sent { uploaded, failed, retryLater }
