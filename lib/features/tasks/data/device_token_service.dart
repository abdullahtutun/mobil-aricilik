/// Bu telefonun push token'ının sunucudaki kaydı (`device_tokens`).
/// Çevrimdışıyken ya da hata olunca [DeviceTokenException] atar, çağıran
/// sonra yeniden dener.
abstract interface class DeviceTokenService {
  Future<void> register({required String token, required String platform});

  Future<void> unregister(String token);
}

class DeviceTokenException implements Exception {
  const new();
}
