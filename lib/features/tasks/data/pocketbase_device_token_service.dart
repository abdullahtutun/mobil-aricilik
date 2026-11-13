import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/features/tasks/data/device_token_service.dart';
import 'package:pocketbase/pocketbase.dart';

/// [DeviceTokenService]'in PocketBase uygulaması: `POST
/// /api/app/device-token` {action, token, platform, locale}
/// (`server/internal/notify`). Görev bildirimi bu telefonun dilinde gider;
/// dil verilmezse hesabın dilinde.
class PocketBaseDeviceTokenService implements DeviceTokenService {
  const new(this._client, {this.timeout = requestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  static const path = '/api/app/device-token';

  /// Varsayılan süre sınırı.
  static const requestTimeout = Duration(seconds: 8);

  @override
  Future<void> register({
    required String token,
    required String platform,
    String? locale,
  }) => _call({
    'action': 'register',
    'token': token,
    'platform': platform,
    'locale': ?locale,
  });

  @override
  Future<void> unregister(String token) =>
      _call({'action': 'unregister', 'token': token});

  Future<void> _call(Map<String, Object?> body) async {
    try {
      await sendPocketBaseAppRequest(
        _client,
        path,
        body: body,
        timeout: timeout,
      );
    } on PocketBaseApiException {
      throw const DeviceTokenException();
    }
  }
}
