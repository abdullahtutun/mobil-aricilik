import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/features/tasks/data/device_token_service.dart';
import 'package:mobil_arici/features/tasks/data/pocketbase_device_token_service.dart';

import '../../../helpers/fake_pocketbase_api.dart';
import '../../../helpers/fake_pocketbase_files.dart';

void main() {
  late FakePocketBaseApi server;
  late PocketBaseDeviceTokenService service;

  setUp(() {
    server = FakePocketBaseApi()
      ..handler = (_) => fakePocketBaseJson({'ok': true});
    service = PocketBaseDeviceTokenService(
      server.client(token: 'a.b.c'),
      timeout: const Duration(milliseconds: 200),
    );
  });

  test('register token, platform ve dili gönderir', () async {
    await service.register(token: 'fcm-1', platform: 'android', locale: 'de');

    final request = server.requests.single;
    expect(request.method, 'POST');
    expect(request.url.path, '/api/app/device-token');
    expect(request.headers['Authorization'], 'a.b.c');
    expect(FakePocketBaseApi.body(request), {
      'action': 'register',
      'token': 'fcm-1',
      'platform': 'android',
      'locale': 'de',
    });
  });

  test('dil verilmezse gövdede yok (sunucu hesabın dilini kullanır)', () async {
    await service.register(token: 'fcm-1', platform: 'ios');

    expect(FakePocketBaseApi.body(server.requests.single), {
      'action': 'register',
      'token': 'fcm-1',
      'platform': 'ios',
    });
  });

  test('unregister yalnız token’ı gönderir', () async {
    await service.unregister('fcm-1');

    expect(FakePocketBaseApi.body(server.requests.single), {
      'action': 'unregister',
      'token': 'fcm-1',
    });
  });

  test('400, 401, 500, bağlantı hatası ve zaman aşımı '
      'DeviceTokenException', () async {
    final responses = <FutureOr<http.Response> Function()>[
      () => fakePocketBaseAppError(400, 'bad_request'),
      () => fakePocketBaseJson({'status': 401, 'message': 'x'}, 401),
      () => fakePocketBaseAppError(500, 'server'),
      () => throw const SocketException('çevrimdışı'),
      () => Completer<http.Response>().future,
    ];
    for (final response in responses) {
      server.handler = (_) => response();
      await expectLater(
        service.register(token: 'fcm-1', platform: 'android'),
        throwsA(isA<DeviceTokenException>()),
      );
      await expectLater(
        service.unregister('fcm-1'),
        throwsA(isA<DeviceTokenException>()),
      );
    }
  });
}
