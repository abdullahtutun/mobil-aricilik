import 'dart:async';

import 'package:mobil_arici/core/sync/telemetry_api.dart';
import 'package:pocketbase/pocketbase.dart';

/// [TelemetryApi]'nin PocketBase uygulaması: `feedback` ve
/// `analytics_events` koleksiyonlarına kayıt API'siyle ekleme (yalnız
/// create kuralı açık, P3.2). Sunucu `received_at`'i kendisi yazar.
///
/// Zaman alanları K-5 metnidir (mikrosaniyeli, sabit genişlikli UTC), bu
/// yüzden `created_at` / `occurred_at` o biçime çevrilir; görüşün
/// `created_by`'ı kuralın istediği gibi oturumdaki kullanıcıdır. Batch API
/// kapalı olduğundan olay paketi tek tek yazılır: paket yarıda kalırsa
/// yazılanlar sunucuda kalır, sonraki denemede "zaten var" olur ve
/// `TelemetryUploadService` olayları tek tek gönderir.
///
/// Oturum yoksa ya da token'ın süresi dolmuşsa istek atılmaz ve hata
/// geçicidir: SDK süresi dolmuş token'ı göndermez, sunucu girişsiz isteği
/// kural reddi (kalıcı) sayardı. Token senkron turunun başında yenilenir.
class PocketBaseTelemetryApi implements TelemetryApi {
  const new(this._client, {this.timeout = requestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  /// Varsayılan süre sınırı.
  static const requestTimeout = Duration(seconds: 60);

  static const feedbackCollection = 'feedback';
  static const analyticsCollection = 'analytics_events';

  /// Aynı id ile ikinci eklemede `data.id.code` (P6.1'deki dosya
  /// kayıtlarıyla aynı yanıt).
  static const duplicateCode = 'validation_pk_invalid';

  @override
  Future<void> insertFeedback(Map<String, Object?> row) async {
    final userId = _requireSession();
    await _create(feedbackCollection, {
      ...row,
      'created_at': _timestamp(row['created_at']),
      'created_by': userId,
    });
  }

  @override
  Future<void> insertAnalytics(List<Map<String, Object?>> rows) async {
    for (final row in rows) {
      await insertAnalyticsEvent(row);
    }
  }

  @override
  Future<void> insertAnalyticsEvent(Map<String, Object?> row) async {
    _requireSession();
    await _create(analyticsCollection, {
      ...row,
      'occurred_at': _timestamp(row['occurred_at']),
    });
  }

  Future<void> _create(String collection, Map<String, Object?> body) async {
    try {
      await _client.collection(collection).create(body: body).timeout(timeout);
    } on ClientException catch (error) {
      if (_isDuplicate(error)) throw const TelemetryDuplicateException();
      // Bağlantı hatası (durum 0), süresi dolmuş ya da kapatılmış oturum,
      // istek sınırı ve sunucu hataları geçici: hata olduğu gibi gider.
      if (isTransientStatus(error.statusCode)) rethrow;
      throw TelemetryRejectedException(_describe(error));
    }
  }

  /// Yeniden denemenin işe yarayabileceği durumlar.
  static bool isTransientStatus(int status) =>
      status == 0 ||
      status == 401 ||
      status == 408 ||
      status == 429 ||
      status >= 500;

  /// Oturumdaki kullanıcının kimliği; oturum yoksa ya da süresi dolmuşsa
  /// geçici hata.
  String _requireSession() {
    final store = _client.authStore;
    final userId = store.record?.id ?? '';
    if (!store.isValid || userId.isEmpty) {
      throw const TelemetrySessionUnavailableException();
    }
    return userId;
  }

  /// ISO-8601 zamanı K-5 metnine çevirir: `2026-11-09T10:15:30.123456Z`.
  /// Okunamayan değer olduğu gibi gider; sunucu deseni reddeder.
  static Object? _timestamp(Object? value) {
    if (value is! String) return value;
    final time = DateTime.tryParse(value)?.toUtc();
    if (time == null) return value;
    String two(int n) => n.toString().padLeft(2, '0');
    final fraction = (time.millisecond * 1000 + time.microsecond)
        .toString()
        .padLeft(6, '0');
    return '${time.year.toString().padLeft(4, '0')}-${two(time.month)}-'
        '${two(time.day)}T${two(time.hour)}:${two(time.minute)}:'
        '${two(time.second)}.${fraction}Z';
  }

  static bool _isDuplicate(ClientException error) =>
      error.statusCode == 400 &&
      switch (error.response['data']) {
        {'id': {'code': duplicateCode}} => true,
        _ => false,
      };

  /// `durum: ileti alan=kod`; kuyruktaki `last_error`'da nedeni görünsün.
  static String _describe(ClientException error) {
    final codes = switch (error.response['data']) {
      final Map<String, dynamic> data => [
        for (final MapEntry(:key, :value) in data.entries)
          if (value case {'code': final String code}) '$key=$code',
      ].join(' '),
      _ => '',
    };
    final message = switch (error.response['message']) {
      final String text => text,
      _ => '',
    };
    return '${error.statusCode}: $message $codes'.trimRight();
  }
}

/// Oturum yok ya da token'ın süresi dolmuş; görüş ve olaylar bekler.
class TelemetrySessionUnavailableException implements Exception {
  const new();

  @override
  String toString() => 'TelemetrySessionUnavailableException';
}
