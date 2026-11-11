import 'package:mobil_arici/core/sync/telemetry_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [TelemetryApi]'nin Supabase uygulaması: `feedback` ve
/// `analytics_events` tablolarına doğrudan ekleme (RLS yalnız eklemeye
/// izin verir).
class SupabaseTelemetryApi implements TelemetryApi {
  const new(this._client);

  final SupabaseClient _client;

  /// Tek isteğin süre sınırı.
  static const requestTimeout = Duration(seconds: 60);

  @override
  Future<void> insertFeedback(Map<String, Object?> row) =>
      _insert('feedback', row);

  @override
  Future<void> insertAnalytics(List<Map<String, Object?>> rows) =>
      _insert('analytics_events', rows);

  @override
  Future<void> insertAnalyticsEvent(Map<String, Object?> row) =>
      _insert('analytics_events', row);

  Future<void> _insert(String table, Object rows) async {
    try {
      await _client
          .from(table)
          .insert(rows)
          .retry(enabled: false, requestTimeout: requestTimeout);
    } on PostgrestException catch (error) {
      if (error.code == '23505') throw const TelemetryDuplicateException();
      if (_isTransient(error.code)) rethrow;
      throw TelemetryRejectedException('${error.code}: ${error.message}');
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
