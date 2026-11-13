/// Görüş ve kullanım olayı satırlarını sunucuya yazar; satırlar geri
/// okunmaz. Kuyruk ve yeniden deneme `TelemetryUploadService`'te.
///
/// Aynı kimlikli satır zaten varsa [TelemetryDuplicateException], yeniden
/// denemenin işe yaramayacağı retde [TelemetryRejectedException] atar.
/// Başka her [Exception] (bağlantı, zaman aşımı, sunucu hatası) geçicidir.
abstract interface class TelemetryApi {
  /// `feedback` satırı (sunucunun kolon adlarıyla).
  Future<void> insertFeedback(Map<String, Object?> row);

  /// `analytics_events` satırları; hepsi birlikte yazılır ya da hiçbiri.
  Future<void> insertAnalytics(List<Map<String, Object?>> rows);

  /// Tek `analytics_events` satırı; paketin bir kısmı önceki denemede
  /// gitmişse olaylar tek tek yazılır.
  Future<void> insertAnalyticsEvent(Map<String, Object?> row);
}

/// Aynı kimlikli satır sunucuda zaten var (önceki denemenin yanıtı yolda
/// kalmış).
class TelemetryDuplicateException implements Exception {
  const new();

  @override
  String toString() => 'TelemetryDuplicateException';
}

/// Yeniden denemenin işe yaramayacağı ret (yetki, geçersiz satır).
class TelemetryRejectedException implements Exception {
  const new(this.message);

  final String message;

  @override
  String toString() => 'TelemetryRejectedException: $message';
}
