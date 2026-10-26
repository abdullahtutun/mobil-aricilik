import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:mobil_arici/core/analytics/analytics_repository.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/services/app_info_service.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/features/feedback/data/feedback_repository.dart';
import 'package:mobil_arici/features/feedback/domain/feedback_rules.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Görüşleri ve kullanım olaylarını sunucuya gönderir. İkisi de yerel
/// kuyruktan gider ve gönderilince silinir; satırlar senkronlanmaz, geri
/// okunmaz.
///
/// Aynı anda tek tur çalışır; tur sürerken gelen çağrı süren turun
/// sonucunu bekler. Uygulamada tek örnek
/// `telemetryUploadServiceProvider`'dan gelir.
class TelemetryUploadService {
  new(
    this._db,
    this._client,
    this._files,
    this._appInfo, {
    this.clock = DateTime.now,
  });

  final AppDatabase _db;
  final SupabaseClient _client;
  final MediaFileStore _files;
  final AppInfoService _appInfo;

  /// Yeniden deneme zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'feedback';

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 60);

  late final _feedback = FeedbackRepository(_db, clock: clock);
  late final _analytics = AnalyticsRepository(_db, clock: clock);

  Future<TelemetryUploadResult>? _uploading;

  /// Önce zamanı gelmiş görüşleri, sonra (analitik açıksa) kullanım
  /// olaylarını gönderir.
  ///
  /// Görüşte ekran görüntüsü varsa önce o yüklenir, sonra satır yazılır;
  /// ikisinin de ikinci gönderimi (önceki denemenin yanıtı yolda kalmış)
  /// "zaten gönderildi" sayılır. Geçici hatada (ağ, sunucu) görüş
  /// [uploadBackoff] kadar ertelenir ve tur durur. Yeniden denemenin işe
  /// yaramayacağı hatada (yetki, geçersiz mesaj) görüş `failed` olur, tur
  /// sürer. Olaylar paket paket (200) gider; geçici
  /// hatada kuyrukta kalır, kalıcı hatada paket silinir (olay değerli
  /// değil, kuyruk tıkanmasın).
  Future<TelemetryUploadResult> uploadPending() =>
      _uploading ??= _upload().whenComplete(() => _uploading = null);

  Future<TelemetryUploadResult> _upload() async {
    var feedbackSent = 0;
    while (true) {
      final next = await _feedback.nextDue();
      if (next == null) break;
      switch (await _sendFeedback(next)) {
        case _Sent.ok:
          feedbackSent++;
        case _Sent.failed:
          break;
        case _Sent.retryLater:
          return TelemetryUploadResult(
            complete: false,
            feedbackSent: feedbackSent,
          );
      }
    }

    var eventsSent = 0;
    if (await LocalSettingsRepository(_db).analyticsEnabled()) {
      while (true) {
        final batch = await _analytics.pending();
        if (batch.isEmpty) break;
        final sent = await _sendEvents(batch);
        if (sent == null) {
          return TelemetryUploadResult(
            complete: false,
            feedbackSent: feedbackSent,
            eventsSent: eventsSent,
          );
        }
        eventsSent += sent;
      }
    }
    return TelemetryUploadResult(
      complete: true,
      feedbackSent: feedbackSent,
      eventsSent: eventsSent,
    );
  }

  Future<_Sent> _sendFeedback(QueuedFeedback feedback) async {
    final screenshotPath = feedback.screenshotFileName == null
        ? null
        : feedbackScreenshotPath(orgId: feedback.orgId, id: feedback.id);
    try {
      if (feedback.screenshotFileName case final fileName?) {
        final file = await _files.find(fileName);
        // Dosya silinmişse görüş ekran görüntüsüz gider.
        if (file != null) {
          await _uploadScreenshot(screenshotPath!, await file.readAsBytes());
        }
      }
      await _insertIgnoringDuplicate('feedback', {
        'id': feedback.id,
        'org_id': feedback.orgId,
        'kind': feedback.kind.value,
        'message': feedback.message,
        'screenshot_path': screenshotPath,
        'device_info': feedback.deviceInfo == null
            ? null
            : jsonDecode(feedback.deviceInfo!),
        'created_at': feedback.createdAt.toUtc().toIso8601String(),
      });
    } on _Rejected catch (error) {
      await _feedback.fail(feedback, error.message);
      return _Sent.failed;
    } on Exception catch (error) {
      // Bağlantı hatası, zaman aşımı, sunucu hatası, çevrimdışı token
      // yenileme.
      await _feedback.postpone(
        feedback,
        retryAt: clock().add(uploadBackoff(feedback.attempts + 1)),
        error: error.toString(),
      );
      return _Sent.retryLater;
    }
    await _feedback.remove(feedback.id);
    if (feedback.screenshotFileName case final fileName?) {
      await _files.delete(fileName);
    }
    return _Sent.ok;
  }

  Future<void> _uploadScreenshot(String path, Uint8List bytes) async {
    try {
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
            retryAttempts: 0,
          )
          .timeout(requestTimeout);
    } on StorageException catch (error) {
      // Aynı yola ikinci yükleme: önceki deneme sunucuya ulaşmış.
      if (error.statusCode == '409') return;
      if (_isTransient(error.statusCode)) rethrow;
      throw _Rejected('${error.statusCode}: ${error.message}');
    }
  }

  /// Olay paketini gönderir ve gönderilen sayısını döner; geçici hatada
  /// null.
  Future<int?> _sendEvents(List<QueuedAnalyticsEvent> batch) async {
    final AppInfo info;
    final String installId;
    try {
      info = await _appInfo.read();
      installId = await _analytics.installId();
    } on Exception {
      return null;
    }
    Map<String, Object?> row(QueuedAnalyticsEvent event) => {
      'id': event.id,
      'install_id': installId,
      'name': event.name,
      'props': jsonDecode(event.props),
      'occurred_at': event.occurredAt.toUtc().toIso8601String(),
      'app_version': info.appVersion,
      'platform': info.platform,
    };

    try {
      try {
        await _insert('analytics_events', [for (final e in batch) row(e)]);
      } on _Duplicate {
        // Paketin bir kısmı önceki turda gitmiş (yanıt yolda kalmış):
        // olaylar tek tek gönderilir, gitmiş olan atlanır.
        for (final event in batch) {
          await _insertIgnoringDuplicate('analytics_events', row(event));
        }
      }
    } on _Rejected {
      await _analytics.remove(batch.map((e) => e.id));
      return 0;
    } on Exception {
      return null;
    }
    await _analytics.remove(batch.map((e) => e.id));
    return batch.length;
  }

  Future<void> _insertIgnoringDuplicate(
    String table,
    Map<String, Object?> row,
  ) async {
    try {
      await _insert(table, row);
    } on _Duplicate {
      // Önceki deneme yazmış; okuma politikası olmadığı için
      // `on conflict do nothing` kullanılamıyor.
    }
  }

  Future<void> _insert(String table, Object rows) async {
    try {
      await _client
          .from(table)
          .insert(rows)
          .retry(enabled: false, requestTimeout: requestTimeout);
    } on PostgrestException catch (error) {
      if (error.code == '23505') throw const _Duplicate();
      if (_isTransient(error.code)) rethrow;
      throw _Rejected('${error.code}: ${error.message}');
    }
  }

  /// Kodu olmayan hata (bağlantı), süresi dolmuş oturum, zaman aşımı,
  /// istek sınırı ve sunucu hataları (HTTP durumu); Postgres'in geçici hata
  /// sınıfları (bağlantı, işlem çakışması, kaynak, operatör, sistem;
  /// SQLSTATE), PostgREST'in bağlantı hataları ve süresi dolmuş JWT.
  static bool _isTransient(String? code) {
    if (code == null) return true;
    final status = int.tryParse(code);
    if (code.length == 3 && status != null) {
      return status == 401 || status == 408 || status == 429 || status >= 500;
    }
    if (code.length == 5) {
      return const {
        '08',
        '40',
        '53',
        '57',
        '58',
      }.contains(code.substring(0, 2));
    }
    // PGRST0xx: PostgREST veritabanına bağlanamadı.
    return code.startsWith('PGRST0') ||
        code == 'PGRST301' ||
        code == 'PGRST303';
  }
}

/// Gönderim turunun sonucu.
class TelemetryUploadResult {
  const new({
    required this.complete,
    this.feedbackSent = 0,
    this.eventsSent = 0,
  });

  /// Gönderilmeyi bekleyen bir şey kalmadı (kalıcı hata alanlar dışında).
  final bool complete;
  final int feedbackSent;
  final int eventsSent;

  @override
  String toString() =>
      'TelemetryUploadResult(complete: $complete, feedback: $feedbackSent, '
      'events: $eventsSent)';
}

enum _Sent { ok, failed, retryLater }

/// Aynı kimlikli satır sunucuda zaten var.
class _Duplicate implements Exception {
  const new();
}

/// Yeniden denemenin işe yaramayacağı ret.
class _Rejected implements Exception {
  const new(this.message);

  final String message;
}
