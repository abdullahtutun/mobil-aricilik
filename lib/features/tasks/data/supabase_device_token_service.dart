import 'package:mobil_arici/features/tasks/data/device_token_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [DeviceTokenService]'in Supabase uygulaması: `device-token` Edge
/// Function'ı.
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
