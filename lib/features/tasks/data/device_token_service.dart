import 'package:supabase_flutter/supabase_flutter.dart';

/// Bu telefonun push token'ının sunucudaki kaydı (`device_tokens`). Kayıt
/// Edge Function üzerinden yapılır; çevrimdışıyken ya da hata olunca
/// [DeviceTokenException] atar, çağıran sonra yeniden dener.
abstract interface class DeviceTokenService {
  Future<void> register({required String token, required String platform});

  Future<void> unregister(String token);
}

class DeviceTokenException implements Exception {
  const new();
}

class SupabaseDeviceTokenService implements DeviceTokenService {
  const new(this._client);

  final SupabaseClient _client;

  @override
  Future<void> register({required String token, required String platform}) =>
      _call({'action': 'register', 'token': token, 'platform': platform});

  @override
  Future<void> unregister(String token) =>
      _call({'action': 'unregister', 'token': token});

  Future<void> _call(Map<String, Object?> body) async {
    try {
      await _client.functions
          .invoke('device-token', body: body)
          .timeout(const Duration(seconds: 8));
    } on Object {
      throw const DeviceTokenException();
    }
  }
}
