/// Bu telefonun push token'ının sunucudaki kaydı (`device_tokens`).
/// Çevrimdışıyken ya da hata olunca [DeviceTokenException] atar, çağıran
/// sonra yeniden dener.
abstract interface class DeviceTokenService {
  /// [locale] bu telefonun arayüz dili (`tr`, `en`, …); görev bildirimi bu
  /// dilde gider. Supabase uygulaması göndermez (hesabın dili kullanılır).
  Future<void> register({
    required String token,
    required String platform,
    String? locale,
  });

  Future<void> unregister(String token);
}

class DeviceTokenException implements Exception {
  const new();
}
