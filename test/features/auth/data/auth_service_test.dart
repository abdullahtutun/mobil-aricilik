import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/features/auth/data/supabase_auth_service.dart';
import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _url = 'http://auth.test';
const _email = 'ari@example.com';

String _jwt(DateTime expiresAt) {
  String part(Map<String, Object?> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  return [
    part({'alg': 'HS256', 'typ': 'JWT'}),
    part({'sub': 'user-1', 'exp': expiresAt.millisecondsSinceEpoch ~/ 1000}),
    'signature',
  ].join('.');
}

Map<String, Object?> _userJson({Map<String, Object?> metadata = const {}}) => {
  'id': 'user-1',
  'aud': 'authenticated',
  'email': _email,
  'created_at': '2026-10-22T08:00:00Z',
  'app_metadata': <String, Object?>{},
  'user_metadata': metadata,
};

Map<String, Object?> _sessionJson({
  required DateTime expiresAt,
  String refreshToken = 'refresh-1',
  Map<String, Object?> metadata = const {},
}) => {
  'access_token': _jwt(expiresAt),
  'token_type': 'bearer',
  'expires_in': 3600,
  'refresh_token': refreshToken,
  'user': _userJson(metadata: metadata),
};

http.Response _json(Object body, [int status = 200]) =>
    http.Response(jsonEncode(body), status);

/// GoTrue'nun eski (`error_code`) hata biçimi.
http.Response _error(int status, String code) =>
    _json({'error_code': code, 'msg': code}, status);

/// PKCE akışı doğrulayıcıyı burada tutar (uygulamada SharedPreferences).
class _MemoryStorage extends GotrueAsyncStorage {
  final _items = <String, String>{};

  @override
  Future<String?> getItem({required String key}) async => _items[key];

  @override
  Future<void> setItem({required String key, required String value}) async =>
      _items[key] = value;

  @override
  Future<void> removeItem({required String key}) async => _items.remove(key);
}

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

void main() {
  final inAnHour = DateTime.now().add(const Duration(hours: 1));
  final anHourAgo = DateTime.now().subtract(const Duration(hours: 1));

  group('SupabaseAuthService', () {
    late List<http.Request> requests;
    late _Handler handler;
    late GoTrueClient client;
    late SupabaseAuthService service;

    setUp(() {
      requests = [];
      handler = (_) => _json(<String, Object?>{});
      client = GoTrueClient(
        url: _url,
        autoRefreshToken: false,
        asyncStorage: _MemoryStorage(),
        httpClient: MockClient((request) async {
          requests.add(request);
          return await handler(request);
        }),
      );
      service = SupabaseAuthService(client);
    });

    tearDown(() => client.dispose());

    Map<String, Object?> body(String path) =>
        jsonDecode(requests.singleWhere((r) => r.url.path == path).body)
            as Map<String, Object?>;

    test('kod isteği adresi ve e-posta dilini gönderir', () async {
      await service.sendCode(email: _email, locale: 'tr');

      final otp = body('/otp');
      expect(otp['email'], _email);
      expect(otp['data'], {'locale': 'tr'});
    });

    test('sunucu hataları giriş hatalarına çevrilir', () async {
      for (final (response, failure) in [
        (
          _error(429, 'over_email_send_rate_limit'),
          AuthFailure.tooManyRequests,
        ),
        (_error(429, 'over_request_rate_limit'), AuthFailure.tooManyRequests),
        (_error(400, 'email_address_invalid'), AuthFailure.invalidEmail),
        (_error(400, 'validation_failed'), AuthFailure.invalidEmail),
        (_error(422, 'signup_disabled'), AuthFailure.unknown),
        (http.Response('maintenance', 503), AuthFailure.network),
      ]) {
        handler = (_) => response;
        await expectLater(
          service.sendCode(email: _email, locale: 'tr'),
          throwsA(
            isA<AuthServiceException>().having(
              (e) => e.failure,
              'failure',
              failure,
            ),
          ),
          reason: response.body,
        );
      }
    });

    test('ağ yoksa bağlantı hatası verir', () async {
      handler = (_) => throw http.ClientException('çevrimdışı');

      await expectLater(
        service.sendCode(email: _email, locale: 'tr'),
        throwsA(
          isA<AuthServiceException>().having(
            (e) => e.failure,
            'failure',
            AuthFailure.network,
          ),
        ),
      );
    });

    test('yanlış ya da süresi dolmuş kod reddedilir', () async {
      handler = (_) => _error(403, 'otp_expired');

      await expectLater(
        service.verifyCode(email: _email, code: '000000', locale: 'tr'),
        throwsA(
          isA<AuthServiceException>().having(
            (e) => e.failure,
            'failure',
            AuthFailure.invalidCode,
          ),
        ),
      );
      expect(service.currentUser, isNull);
    });

    test('kod doğrulanınca oturum açılır, farklı e-posta dili '
        'güncellenir', () async {
      handler = (request) => switch (request.url.path) {
        '/verify' => _json(
          _sessionJson(expiresAt: inAnHour, metadata: {'locale': 'en'}),
        ),
        '/user' => _json(_userJson(metadata: {'locale': 'tr'})),
        _ => _error(404, 'not_found'),
      };
      final changes = <AppUser?>[];
      final subscription = service.userChanges.listen(changes.add);
      addTearDown(subscription.cancel);

      await service.verifyCode(email: _email, code: '482913', locale: 'tr');

      final verify = body('/verify');
      expect(verify['email'], _email);
      expect(verify['token'], '482913');
      expect(verify['type'], 'email');
      expect(body('/user')['data'], {'locale': 'tr'});
      expect(service.currentUser, const AppUser(id: 'user-1', email: _email));
      await pumpEventQueue();
      expect(changes, contains(const AppUser(id: 'user-1', email: _email)));
    });

    test('e-posta dili zaten aynıysa güncellenmez', () async {
      handler = (_) =>
          _json(_sessionJson(expiresAt: inAnHour, metadata: {'locale': 'tr'}));

      await service.verifyCode(email: _email, code: '482913', locale: 'tr');

      expect(requests.map((r) => r.url.path), ['/verify']);
    });

    test('e-posta dili güncellenemese de giriş geçerli', () async {
      handler = (request) => request.url.path == '/verify'
          ? _json(_sessionJson(expiresAt: inAnHour))
          : throw http.ClientException('bağlantı koptu');

      await service.verifyCode(email: _email, code: '482913', locale: 'tr');

      expect(service.currentUser, isNotNull);
    });

    test('demo hesaba kod gönderilmez', () async {
      await service.sendCode(email: reviewDemoEmail, locale: 'tr');

      expect(requests, isEmpty);
    });

    test('demo hesapta kod parola olarak denenir', () async {
      handler = (request) => request.url.path == '/token'
          ? _json(_sessionJson(expiresAt: inAnHour, metadata: {'locale': 'tr'}))
          : _error(404, 'not_found');

      await service.verifyCode(
        email: reviewDemoEmail,
        code: '482913',
        locale: 'tr',
      );

      final token = requests.single;
      expect(token.url.queryParameters['grant_type'], 'password');
      final sent = jsonDecode(token.body) as Map<String, Object?>;
      expect(sent['email'], reviewDemoEmail);
      expect(sent['password'], '482913');
      expect(service.currentUser, isNotNull);
    });

    test('demo hesapta yanlış kod reddedilir', () async {
      handler = (_) => _error(400, 'invalid_credentials');

      await expectLater(
        service.verifyCode(
          email: reviewDemoEmail,
          code: '000000',
          locale: 'tr',
        ),
        throwsA(
          isA<AuthServiceException>().having(
            (e) => e.failure,
            'failure',
            AuthFailure.invalidCode,
          ),
        ),
      );
      expect(service.currentUser, isNull);
    });

    test('çıkış çevrimdışıyken de yerel oturumu siler', () async {
      await client.setInitialSession(
        jsonEncode(_sessionJson(expiresAt: inAnHour)),
      );
      handler = (_) => throw http.ClientException('çevrimdışı');
      final changes = <AppUser?>[];
      final subscription = service.userChanges.listen(changes.add);
      addTearDown(subscription.cancel);

      await service.signOut();

      expect(requests.single.url.path, '/logout');
      expect(service.currentUser, isNull);
      await pumpEventQueue();
      expect(changes.last, isNull);
    });
  });

  // Uygulamadaki gibi otomatik yenileme açık; zamanlayıcı ve yeniden deneme
  // beklemeleri sahte zamanla ilerletilir.
  group('Oturum ömrü', () {
    testWidgets('çevrimdışıyken süresi dolan oturum açık kalır, ağ gelince '
        'yenilenir', (tester) async {
      var online = false;
      final refreshes = <String>[];
      final client = GoTrueClient(
        url: _url,
        asyncStorage: _MemoryStorage(),
        httpClient: MockClient((request) async {
          if (request.url.path != '/token') return _error(404, 'not_found');
          refreshes.add(request.url.queryParameters['grant_type']!);
          if (!online) throw http.ClientException('çevrimdışı');
          return _json(
            _sessionJson(expiresAt: inAnHour, refreshToken: 'refresh-2'),
          );
        }),
      );
      // Otomatik yenilemenin ilk turu sıfır süreli zamanlayıcıyla başlar.
      await tester.pump(Duration.zero);

      // supabase_flutter açılışta diskteki oturumu ağı beklemeden kurar...
      final stored = jsonEncode(_sessionJson(expiresAt: anHourAgo));
      await client.setInitialSession(stored);
      final container = ProviderContainer.test(
        overrides: [
          authServiceProvider.overrideWithValue(SupabaseAuthService(client)),
        ],
      );
      final users = <AppUser?>[];
      container.listen(currentUserProvider, (_, user) => users.add(user));
      expect(container.read(currentUserProvider)?.id, 'user-1');

      // ...sonra beklemeden yenilemeyi dener.
      Object? recoveryError;
      unawaited(
        client
            .recoverSession(stored)
            .then<void>((_) {}, onError: (Object e) => recoveryError = e),
      );
      await tester.pump(const Duration(minutes: 1));

      expect(recoveryError, isA<AuthRetryableFetchException>());
      expect(refreshes, isNotEmpty);
      expect(refreshes, everyElement('refresh_token'));
      expect(client.currentSession?.refreshToken, 'refresh-1');
      expect(container.read(currentUserProvider)?.id, 'user-1');
      expect(users, isNot(contains(null)));

      online = true;
      await tester.pump(const Duration(seconds: 30));

      expect(client.currentSession?.refreshToken, 'refresh-2');
      expect(client.currentSession?.isExpired, isFalse);
      expect(container.read(currentUserProvider)?.id, 'user-1');
      expect(users, isNot(contains(null)));

      client.dispose();
      await tester.pump(Duration.zero);
    });

    testWidgets("sunucu refresh token'ı reddederse oturum kapanır", (
      tester,
    ) async {
      final client = GoTrueClient(
        url: _url,
        asyncStorage: _MemoryStorage(),
        httpClient: MockClient(
          (_) async => _error(400, 'refresh_token_not_found'),
        ),
      );
      // Otomatik yenilemenin ilk turu sıfır süreli zamanlayıcıyla başlar.
      await tester.pump(Duration.zero);
      final stored = jsonEncode(_sessionJson(expiresAt: anHourAgo));
      await client.setInitialSession(stored);
      final container = ProviderContainer.test(
        overrides: [
          authServiceProvider.overrideWithValue(SupabaseAuthService(client)),
        ],
      );
      expect(container.read(currentUserProvider), isNotNull);

      await expectLater(
        client.recoverSession(stored),
        throwsA(isA<AuthApiException>()),
      );
      await tester.pump();

      expect(container.read(currentUserProvider), isNull);

      client.dispose();
      await tester.pump(Duration.zero);
    });
  });
}
