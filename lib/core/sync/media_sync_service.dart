import 'dart:io';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/services/connectivity_service.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Medya dosyalarını Storage'a yükler ve indirir (teknik.md §3 "Medya
/// kuyruğu"). Satırlar `SyncService` ile, dosyalar burada gider; ikisi
/// birbirini beklemez.
///
/// Aynı anda tek yükleme turu çalışır; tur sürerken gelen çağrı süren
/// turun sonucunu bekler. Kilit nesneye bağlıdır; uygulamada tek örnek
/// `mediaSyncServiceProvider`'dan gelir.
class MediaSyncService {
  new(
    this._db,
    this._client,
    this._files,
    this._network, {
    this.clock = DateTime.now,
  });

  final AppDatabase _db;
  final SupabaseClient _client;
  final MediaFileStore _files;
  final ConnectivityService _network;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'media';

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 60);

  Future<MediaUploadResult>? _uploading;

  /// Zamanı gelmiş bekleyen dosyaları sırayla yükler.
  ///
  /// "Sadece Wi‑Fi" açıksa ve telefon kotasız ağda değilse hiçbir şey
  /// göndermez. Yüklenen ya da Storage'da zaten olan dosya `uploaded` olur.
  /// Geçici hatada (ağ, sunucu) dosyanın deneme sayısı artar, sonraki
  /// denemesi [uploadBackoff] kadar ertelenir ve tur durur: ağ yoksa
  /// sıradakiler de yüklenemez. Yeniden denemenin işe yaramayacağı hatada
  /// (dosya yok, yetki yok, dosya çok büyük) dosya `failed` olur, tur
  /// sürer.
  Future<MediaUploadResult> uploadPending() =>
      _uploading ??= _upload().whenComplete(() => _uploading = null);

  Future<MediaUploadResult> _upload() async {
    if (await LocalSettingsRepository(_db).mediaWifiOnly() &&
        !await _network.isUnmetered()) {
      return const MediaUploadResult(MediaUploadOutcome.waitingForWifi);
    }

    var uploaded = 0;
    var failed = 0;
    while (true) {
      final job = await _nextJob();
      if (job == null) {
        return MediaUploadResult(
          MediaUploadOutcome.done,
          uploaded: uploaded,
          failed: failed,
        );
      }
      switch (await _send(job)) {
        case _Sent.uploaded:
          uploaded++;
        case _Sent.failed:
          failed++;
        case _Sent.retryLater:
          return MediaUploadResult(
            MediaUploadOutcome.retryLater,
            uploaded: uploaded,
            failed: failed,
          );
      }
    }
  }

  /// Zamanı gelmiş en eski bekleyen dosya; silinmiş medyanınki alınmaz.
  Future<_Job?> _nextJob() async {
    final uploads = _db.mediaUploads;
    final media = _db.media;
    final now = clock().toUtc();
    final query =
        _db.select(uploads).join([
            innerJoin(media, media.id.equalsExp(uploads.mediaId)),
          ])
          ..where(
            uploads.uploadStatus.equalsValue(MediaUploadStatus.pending) &
                media.deletedAt.isNull() &
                (uploads.nextAttemptAt.isNull() |
                    uploads.nextAttemptAt.isSmallerOrEqualValue(now)),
          )
          ..orderBy([
            OrderingTerm.asc(uploads.createdAt),
            OrderingTerm.asc(uploads.mediaId),
          ])
          ..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return _Job(row.readTable(uploads), row.readTable(media));
  }

  Future<_Sent> _send(_Job job) async {
    final file = await _files.find(job.upload.fileName);
    if (file == null) {
      await _fail(job, 'missing_file: ${job.upload.fileName}');
      return _Sent.failed;
    }
    try {
      await _client.storage
          .from(bucket)
          .uploadBinary(
            job.media.storagePath,
            await file.readAsBytes(),
            fileOptions: FileOptions(contentType: job.media.kind.contentType),
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
      MediaUploadsCompanion(
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
      MediaUploadsCompanion(
        attempts: Value(attempts),
        nextAttemptAt: Value(clock().toUtc().add(uploadBackoff(attempts))),
        lastError: Value(error),
      ),
    );
  }

  Future<void> _fail(_Job job, String error) => _update(
    job,
    MediaUploadsCompanion(
      uploadStatus: const Value(MediaUploadStatus.failed),
      attempts: Value(job.upload.attempts + 1),
      lastError: Value(error),
    ),
  );

  Future<void> _update(_Job job, MediaUploadsCompanion values) => (_db.update(
    _db.mediaUploads,
  )..where((t) => t.mediaId.equals(job.upload.mediaId))).write(values);

  /// Başka telefonda çekilen [media]'nın dosyasını indirir ve
  /// [downloadFileName] adıyla saklar. Dosya Storage'da henüz yoksa (çeken
  /// telefon yüklememiş) [MediaDownloadFailure.notUploaded], ağ yoksa
  /// [MediaDownloadFailure.offline] atar.
  Future<File> download(MediaItem media) async {
    final Uint8List bytes;
    try {
      bytes = await _client.storage
          .from(bucket)
          .download(media.storagePath)
          .timeout(requestTimeout);
    } on StorageException catch (error) {
      throw MediaDownloadException(
        error.statusCode == '400' || error.statusCode == '404'
            ? MediaDownloadFailure.notUploaded
            : _isTransient(error.statusCode)
            ? MediaDownloadFailure.offline
            : MediaDownloadFailure.failed,
      );
    } on Exception {
      throw const MediaDownloadException(MediaDownloadFailure.offline);
    }
    return await _files.write(downloadFileName(media), bytes);
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

enum MediaUploadOutcome {
  /// Zamanı gelmiş bekleyen dosya kalmadı.
  done,

  /// Geçici hata; kalanlar ertelendi.
  retryLater,

  /// "Sadece Wi‑Fi" açık ve telefon kotasız ağda değil.
  waitingForWifi,
}

/// Yükleme turunun sonucu.
class MediaUploadResult {
  const new(this.outcome, {this.uploaded = 0, this.failed = 0});

  final MediaUploadOutcome outcome;
  final int uploaded;

  /// Bu turda kalıcı hata alan dosyalar.
  final int failed;

  @override
  String toString() =>
      'MediaUploadResult(${outcome.name}, uploaded: $uploaded, '
      'failed: $failed)';
}

enum MediaDownloadFailure {
  /// Çeken telefon dosyayı henüz yüklemedi.
  notUploaded,

  /// Ağ yok ya da sunucuya ulaşılamadı.
  offline,

  /// Yetki yok ya da başka bir hata.
  failed,
}

class MediaDownloadException implements Exception {
  const new(this.failure);

  final MediaDownloadFailure failure;

  @override
  String toString() => 'MediaDownloadException(${failure.name})';
}

class _Job {
  const new(this.upload, this.media);

  final MediaUpload upload;
  final MediaItem media;
}

enum _Sent { uploaded, failed, retryLater }
