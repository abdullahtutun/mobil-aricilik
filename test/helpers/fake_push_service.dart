import 'dart:async';

import 'package:mobil_arici/core/services/push_service.dart';
import 'package:mobil_arici/features/tasks/data/device_token_service.dart';

/// Cihazsız push: izin, token ve bildirime dokunmayı testler yönetir.
class FakePushService implements PushService {
  bool permitted = false;
  bool grantOnRequest = true;
  int permissionRequests = 0;
  String? currentToken = 'token-1';
  bool tokenDeleted = false;
  String? launchTask;

  final refreshes = StreamController<String>.broadcast();
  final opens = StreamController<String>.broadcast();

  @override
  String? platform = 'android';

  @override
  Future<bool> permission({required bool request}) async {
    if (request) {
      permissionRequests++;
      if (!permitted) permitted = grantOnRequest;
    }
    return permitted;
  }

  @override
  Future<String?> token() async => currentToken;

  @override
  Stream<String> get tokenRefreshes => refreshes.stream;

  @override
  Future<void> deleteToken() async => tokenDeleted = true;

  @override
  Future<String?> launchTaskId() async => launchTask;

  @override
  Stream<String> get taskOpens => opens.stream;
}

/// Sunucudaki token kaydı: kayıtlı token'lar ve gelen çağrılar.
class FakeDeviceTokenService implements DeviceTokenService {
  /// Doluysa her çağrı çevrimdışı gibi hata atar.
  bool offline = false;
  final registered = <String, String>{};
  final calls = <String>[];

  /// Kayıtlarda gönderilen diller, sırayla.
  final locales = <String?>[];

  @override
  Future<void> register({
    required String token,
    required String platform,
    String? locale,
  }) async {
    calls.add('register:$token');
    locales.add(locale);
    if (offline) throw const DeviceTokenException();
    registered[token] = platform;
  }

  @override
  Future<void> unregister(String token) async {
    calls.add('unregister:$token');
    if (offline) throw const DeviceTokenException();
    registered.remove(token);
  }
}
