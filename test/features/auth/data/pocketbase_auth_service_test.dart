import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/core/sync/sync_transport.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_auth_service.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_session_storage.dart';
import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../helpers/test_database.dart';

const _url = 'http://pb.test';
const _email = 'ari@example.com';
const _otpPath = '/api/app/auth/otp';
const _withOtpPath = '/api/collections/users/auth-with-otp';
const _withPasswordPath = '/api/collections/users/auth-with-password';
const _refreshPath = '/api/collections/users/auth-refresh';
const _localePath = '/api/app/auth/locale';
const _user = AppUser(id: 'user-1', email: _email);

String _jwt(DateTime expiresAt, {String id = 'token'}) {
  String part(Map<String, Object?> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  return [
    part({'alg': 'HS256', 'typ': 'JWT'}),
    part({
      'id': 'user-1',
      'type': 'auth',
      'jti': id,
      'exp': expiresAt.millisecondsSinceEpoch ~/ 1000,
    }),
    'signature',
  ].join('.');
}

Map<String, Object?> _record({String locale = 'tr', String email = _email}) => {
  'id': 'user-1',
  'collectionId': '_pb_users_auth_',
  'collectionName': 'users',
  'email': email,
  'emailVisibility': false,
  'verified': true,
  'locale': locale,
};

Map<String, Object?> _auth(String token, {String locale = 'tr'}) => {
  'token': token,
  'record': _record(locale: locale),
};

/// AsyncAuthStore'un diske yazdığı biçim.
String _stored(String token, {String locale = 'tr'}) =>
    jsonEncode({'token': token, 'model': _record(locale: locale)});

http.Response _json(Object body, [int status = 200]) =>
    http.Response(jsonEncode(body), status);

/// `server/internal/auth`'un ve PocketBase'in hata gövdesi.
http.Response _error(int status, {String? code, String message = 'hata'}) =>
    _json({
      'status': status,
      'message': message,
      'data': code == null ? <String, Object?>{} : {'code': code},
    }, status);

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

Matcher _failsWith(AuthFailure failure) => throwsA(
  isA<AuthServiceException>().having((e) => e.failure, 'failure', failure),
);

/// Gönderecek ve çekecek bir şeyi olmayan taşıyıcı; turun yalnız oturum
/// yenilemesini görmek için.
class _IdleTransport implements SyncTransport {
  @override
  Future<SyncPushResponse> push(
    List<SyncChange> batch, {
    required DateTime clientTime,
    required int schemaVersion,
  }) async => const SyncPushResponse({});

  @override
  Future<SyncPullPage> pull(
    String table, {
    required int sinceSeq,
    required int pageSize,
  }) async => SyncPullPage(rows: const [], nextSeq: sinceSeq, hasMore: false);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final inThirtyDays = DateTime.now().add(const Duration(days: 30));
  final inNinetyDays = DateTime.now().add(const Duration(days: 90));
  final anHourAgo = DateTime.now().subtract(const Duration(hours: 1));

  late List<http.Request> requests;
  late _Handler handler;
  late PocketBaseSessionStorage storage;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    requests = [];
    handler = (_) => _error(404);
    storage = PocketBaseSessionStorage(_url);
  });

  /// Uygulamanın açılışı gibi: oturum diskten okunur, istemci onunla kurulur.
  Future<(PocketBase, PocketBaseAuthService)> open() async {
    final client = PocketBase(
      _url,
      authStore: storage.authStore(initial: await storage.readSession()),
      httpClientFactory: () => MockClient((request) async {
        requests.add(request);
        return await handler(request);
      }),
    );
    return (client, PocketBaseAuthService(client, storage));
  }

  Future<void> storeSession(String token) async {
    await const FlutterSecureStorage().write(
      key: storage.sessionKey,
      value: _stored(token),
    );
  }

  Map<String, Object?> body(String path) =>
      jsonDecode(requests.singleWhere((r) => r.url.path == path).body)
          as Map<String, Object?>;

  group('kod isteği', () {
    test('adresi ve dili gönderir, otpId adresle birlikte saklanır', () async {
      handler = (_) => _json({'otpId': 'otp-1'});
      final (_, service) = await open();
      final sentAt = DateTime.utc(2026, 11, 11, 9);

      await withClock(
        Clock.fixed(sentAt),
        () => service.sendCode(email: _email, locale: 'tr'),
      );

      expect(requests.single.method, 'POST');
      expect(body(_otpPath), {'email': _email, 'locale': 'tr'});
      final pending = await withClock(
        Clock.fixed(sentAt),
        storage.readPendingOtp,
      );
      expect(pending, (email: _email, otpId: 'otp-1', sentAt: sentAt));
    });

    test('sunucu hataları giriş hatalarına çevrilir', () async {
      final (_, service) = await open();
      for (final (response, failure) in [
        (_error(429, code: 'too_many_requests'), AuthFailure.tooManyRequests),
        // PocketBase'in IP başına hız sınırı kodsuz 429 döner.
        (_error(429), AuthFailure.tooManyRequests),
        (_error(400, code: 'invalid_email'), AuthFailure.invalidEmail),
        (_error(503, code: 'mail_unavailable'), AuthFailure.network),
        (_error(503, code: 'mail_failed'), AuthFailure.network),
        (_error(500), AuthFailure.network),
        (http.Response('bad gateway', 502), AuthFailure.network),
        (_error(404), AuthFailure.unknown),
        (_error(400), AuthFailure.unknown),
      ]) {
        handler = (_) => response;
        await expectLater(
          service.sendCode(email: _email, locale: 'tr'),
          _failsWith(failure),
          reason: '${response.statusCode} ${response.body}',
        );
      }
      expect(await storage.readPendingOtp(), isNull);
    });

    test('ağ yoksa bağlantı hatası verir', () async {
      handler = (_) => throw http.ClientException('çevrimdışı');
      final (_, service) = await open();

      await expectLater(
        service.sendCode(email: _email, locale: 'tr'),
        _failsWith(AuthFailure.network),
      );
    });

    test('çok sık istek önceki kodu silmez', () async {
      handler = (_) => _json({'otpId': 'otp-1'});
      final (_, service) = await open();
      await service.sendCode(email: _email, locale: 'tr');

      handler = (_) => _error(429, code: 'too_many_requests');
      await expectLater(
        service.sendCode(email: _email, locale: 'tr'),
        _failsWith(AuthFailure.tooManyRequests),
      );

      expect((await storage.readPendingOtp())?.otpId, 'otp-1');
    });

    test('yanıtta otpId yoksa bilinmeyen hata', () async {
      handler = (_) => _json(<String, Object?>{});
      final (_, service) = await open();

      await expectLater(
        service.sendCode(email: _email, locale: 'tr'),
        _failsWith(AuthFailure.unknown),
      );
    });

    test('demo hesaba kod gönderilmez', () async {
      final (_, service) = await open();

      await service.sendCode(email: reviewDemoEmail, locale: 'tr');

      expect(requests, isEmpty);
      expect(await storage.readPendingOtp(), isNull);
    });
  });

  group('kod doğrulama', () {
    test('otpId ve kodla girer, oturum saklanır, bekleyen istek '
        'silinir', () async {
      final token = _jwt(inNinetyDays);
      handler = (request) => switch (request.url.path) {
        _otpPath => _json({'otpId': 'otp-1'}),
        _withOtpPath => _json(_auth(token)),
        _ => _error(404),
      };
      final (_, service) = await open();
      final changes = <AppUser?>[];
      final subscription = service.userChanges.listen(changes.add);
      addTearDown(subscription.cancel);

      await service.sendCode(email: _email, locale: 'tr');
      await service.verifyCode(email: _email, code: '482913', locale: 'tr');

      expect(body(_withOtpPath), {'otpId': 'otp-1', 'password': '482913'});
      expect(service.currentUser, _user);
      expect(changes, [_user]);
      expect(await storage.readPendingOtp(), isNull);
      // E-posta dili zaten aynı; locale isteği yok.
      expect(requests.map((r) => r.url.path), [_otpPath, _withOtpPath]);

      // Yeniden açılışta oturum diskten gelir.
      await pumpEventQueue();
      final (reopened, again) = await open();
      expect(reopened.authStore.token, token);
      expect(again.currentUser, _user);
    });

    test('uygulama kapatılıp açılsa da gönderilen kod girilebilir', () async {
      handler = (request) => switch (request.url.path) {
        _otpPath => _json({'otpId': 'otp-1'}),
        _withOtpPath => _json(_auth(_jwt(inNinetyDays))),
        _ => _error(404),
      };
      final (_, first) = await open();
      await first.sendCode(email: _email, locale: 'tr');

      final (_, second) = await open();
      await second.verifyCode(email: _email, code: '482913', locale: 'tr');

      expect(body(_withOtpPath)['otpId'], 'otp-1');
      expect(second.currentUser, _user);
    });

    test('10 dakikadan eski kod isteği silinir; sunucuya gidilmez', () async {
      handler = (_) => _json({'otpId': 'otp-1'});
      final (_, service) = await open();
      final sentAt = DateTime.utc(2026, 11, 11, 9);
      await withClock(
        Clock.fixed(sentAt),
        () => service.sendCode(email: _email, locale: 'tr'),
      );

      final almost = sentAt.add(
        PocketBaseSessionStorage.otpLifetime - const Duration(seconds: 1),
      );
      expect(
        await withClock(Clock.fixed(almost), storage.readPendingOtp),
        isNotNull,
      );

      await withClock(
        Clock.fixed(sentAt.add(PocketBaseSessionStorage.otpLifetime)),
        () => expectLater(
          service.verifyCode(email: _email, code: '482913', locale: 'tr'),
          _failsWith(AuthFailure.invalidCode),
        ),
      );
      expect(requests.map((r) => r.url.path), [_otpPath]);
      expect(
        await const FlutterSecureStorage().read(key: storage.otpKey),
        isNull,
      );
    });

    test('kod isteği yoksa ya da başka adrese aitse kod geçersiz', () async {
      final (_, service) = await open();
      await expectLater(
        service.verifyCode(email: _email, code: '482913', locale: 'tr'),
        _failsWith(AuthFailure.invalidCode),
      );

      handler = (_) => _json({'otpId': 'otp-1'});
      await service.sendCode(email: 'baska@example.com', locale: 'tr');
      await expectLater(
        service.verifyCode(email: _email, code: '482913', locale: 'tr'),
        _failsWith(AuthFailure.invalidCode),
      );
      expect(requests.map((r) => r.url.path), [_otpPath]);
    });

    test('yanlış, süresi dolmuş ya da kullanılmış kod reddedilir; yeniden '
        'denenebilir', () async {
      handler = (request) => switch (request.url.path) {
        _otpPath => _json({'otpId': 'otp-1'}),
        _ => _error(400, message: 'Failed to authenticate.'),
      };
      final (_, service) = await open();
      await service.sendCode(email: _email, locale: 'tr');

      await expectLater(
        service.verifyCode(email: _email, code: '000000', locale: 'tr'),
        _failsWith(AuthFailure.invalidCode),
      );

      expect(service.currentUser, isNull);
      expect((await storage.readPendingOtp())?.otpId, 'otp-1');
    });

    test('doğrulamada hız sınırı ve ağ hatası ayrı gösterilir', () async {
      handler = (_) => _json({'otpId': 'otp-1'});
      final (_, service) = await open();
      await service.sendCode(email: _email, locale: 'tr');

      handler = (_) => _error(429);
      await expectLater(
        service.verifyCode(email: _email, code: '482913', locale: 'tr'),
        _failsWith(AuthFailure.tooManyRequests),
      );
      handler = (_) => throw http.ClientException('çevrimdışı');
      await expectLater(
        service.verifyCode(email: _email, code: '482913', locale: 'tr'),
        _failsWith(AuthFailure.network),
      );
    });

    test('demo hesapta kod parola olarak denenir', () async {
      handler = (request) => request.url.path == _withPasswordPath
          ? _json(_auth(_jwt(inNinetyDays)))
          : _error(404);
      final (_, service) = await open();

      await service.verifyCode(
        email: reviewDemoEmail,
        code: '482913',
        locale: 'tr',
      );

      expect(body(_withPasswordPath), {
        'identity': reviewDemoEmail,
        'password': '482913',
      });
      expect(service.currentUser?.id, 'user-1');
    });

    test('demo hesapta yanlış kod reddedilir', () async {
      handler = (_) => _error(400, message: 'Failed to authenticate.');
      final (_, service) = await open();

      await expectLater(
        service.verifyCode(
          email: reviewDemoEmail,
          code: '000000',
          locale: 'tr',
        ),
        _failsWith(AuthFailure.invalidCode),
      );
      expect(service.currentUser, isNull);
    });
  });

  group('e-posta dili', () {
    test('giriş dili hesabınkinden farklıysa yazılır', () async {
      final token = _jwt(inNinetyDays);
      handler = (request) => switch (request.url.path) {
        _otpPath => _json({'otpId': 'otp-1'}),
        _withOtpPath => _json(_auth(token, locale: 'en')),
        _localePath => _json({'locale': 'tr'}),
        _ => _error(404),
      };
      final (client, service) = await open();
      await service.sendCode(email: _email, locale: 'tr');

      await service.verifyCode(email: _email, code: '482913', locale: 'tr');

      final locale = requests.singleWhere((r) => r.url.path == _localePath);
      expect(jsonDecode(locale.body), {'locale': 'tr'});
      expect(locale.headers['Authorization'], token);
      expect(client.authStore.record?.get<String>('locale'), 'tr');

      // Kayıt güncellendiği için aynı dil yeniden gönderilmez; yeni dil
      // gönderilir.
      await service.updateLocale('tr');
      handler = (_) => _json({'locale': 'de'});
      await service.updateLocale('de');
      expect(requests.where((r) => r.url.path == _localePath), hasLength(2));
      expect(client.authStore.record?.get<String>('locale'), 'de');

      // Yeni dil diske de yazıldı.
      await pumpEventQueue();
      final (reopened, _) = await open();
      expect(reopened.authStore.record?.get<String>('locale'), 'de');
    });

    test('dil yazılamasa da giriş geçerli', () async {
      handler = (request) => switch (request.url.path) {
        _otpPath => _json({'otpId': 'otp-1'}),
        _withOtpPath => _json(_auth(_jwt(inNinetyDays), locale: 'en')),
        _ => throw http.ClientException('bağlantı koptu'),
      };
      final (client, service) = await open();
      await service.sendCode(email: _email, locale: 'tr');

      await service.verifyCode(email: _email, code: '482913', locale: 'tr');

      expect(service.currentUser, _user);
      expect(client.authStore.record?.get<String>('locale'), 'en');
    });

    test('oturum yokken ağa gidilmez', () async {
      final (_, service) = await open();

      await service.updateLocale('tr');

      expect(requests, isEmpty);
    });
  });

  group('çıkış', () {
    test('çevrimdışıyken de yerel oturumu ve bekleyen kodu siler', () async {
      await storeSession(_jwt(inThirtyDays));
      await storage.savePendingOtp((
        email: _email,
        otpId: 'otp-1',
        sentAt: DateTime.now(),
      ));
      handler = (_) => throw http.ClientException('çevrimdışı');
      final (_, service) = await open();
      expect(service.currentUser, _user);
      final changes = <AppUser?>[];
      final subscription = service.userChanges.listen(changes.add);
      addTearDown(subscription.cancel);

      await service.signOut();

      expect(requests, isEmpty);
      expect(service.currentUser, isNull);
      expect(changes, [null]);
      expect(await storage.readSession(), isNull);
      expect(await storage.readPendingOtp(), isNull);
      final (_, reopened) = await open();
      expect(reopened.currentUser, isNull);
    });
  });

  group('yenileme (K-6)', () {
    test('yeni token yazılır ve diske gider', () async {
      final old = _jwt(inThirtyDays, id: 'old');
      final fresh = _jwt(inNinetyDays, id: 'fresh');
      await storeSession(old);
      handler = (_) => _json(_auth(fresh));
      final (client, service) = await open();

      await service.refreshSession();

      final refresh = requests.single;
      expect(refresh.url.path, _refreshPath);
      expect(refresh.method, 'POST');
      expect(refresh.headers['Authorization'], old);
      expect(client.authStore.token, fresh);
      await pumpEventQueue();
      expect(jsonDecode((await storage.readSession())!), {
        'token': fresh,
        'model': _record(),
      });
    });

    test('oturum yoksa ağa gidilmez', () async {
      final (_, service) = await open();

      await service.refreshSession();

      expect(requests, isEmpty);
    });

    test('aynı anda gelen çağrılar tek istek atar', () async {
      await storeSession(_jwt(inThirtyDays));
      final response = Completer<http.Response>();
      handler = (_) => response.future;
      final (_, service) = await open();

      final first = service.refreshSession();
      final second = service.refreshSession();
      await pumpEventQueue();
      response.complete(_json(_auth(_jwt(inNinetyDays))));
      await Future.wait([first, second]);

      expect(requests, hasLength(1));
    });

    test('yenileme sürerken çıkış yapılırsa oturum geri gelmez', () async {
      await storeSession(_jwt(inThirtyDays));
      final response = Completer<http.Response>();
      handler = (_) => response.future;
      final (client, service) = await open();

      final refresh = service.refreshSession();
      await pumpEventQueue();
      await service.signOut();
      response.complete(_json(_auth(_jwt(inNinetyDays))));
      await refresh;

      expect(service.currentUser, isNull);
      expect(client.authStore.token, isEmpty);
      await pumpEventQueue();
      expect(await storage.readSession(), isNull);
    });

    test('sunucu hatası ve beklenmeyen yanıt oturumu kapatmaz', () async {
      await storeSession(_jwt(inThirtyDays));
      final (_, service) = await open();
      for (final response in [
        _error(500),
        _error(403),
        http.Response('<html>', 200),
      ]) {
        handler = (_) => response;
        await service.refreshSession();
        expect(service.currentUser, _user, reason: response.body);
      }
    });
  });

  // Yenileme isteğinin zaman aşımı sahte zamanla ilerletilir.
  group('Oturum ömrü', () {
    testWidgets('çevrimdışı oturum açık kalır, ağ gelince yenilenir', (
      tester,
    ) async {
      final old = _jwt(inThirtyDays, id: 'old');
      final fresh = _jwt(inNinetyDays, id: 'fresh');
      await tester.runAsync(() => storeSession(old));
      var online = false;
      // Çevrimdışı: kimi zaman bağlantı hemen düşer, kimi zaman istek
      // yanıtsız asılı kalır (zayıf sinyal).
      var hang = false;
      handler = (_) {
        if (hang) return Completer<http.Response>().future;
        if (!online) throw http.ClientException('çevrimdışı');
        return _json(_auth(fresh));
      };
      final (client, service) = (await tester.runAsync(open))!;
      final container = ProviderContainer.test(
        overrides: [authServiceProvider.overrideWithValue(service)],
      );
      final users = <AppUser?>[];
      container.listen(currentUserProvider, (_, user) => users.add(user));
      expect(container.read(currentUserProvider), _user);

      // Açılıştaki yenileme bağlantı hatasıyla biter.
      await service.refreshSession();
      // Senkron turunun yenilemesi asılı kalır; tur 15 sn'de devam eder.
      hang = true;
      final db = openTestDatabase();
      final sync = SyncService(
        db,
        _IdleTransport(),
        delay: (_) async {},
        refreshSession: service.refreshSession,
      );
      var synced = false;
      unawaited(sync.sync().then((_) => synced = true));
      await tester.pump(const Duration(seconds: 14));
      expect(synced, isFalse);
      await tester.pump(const Duration(seconds: 1));
      // Zaman aşımı yoksa tur asılı kalır; test beklemek yerine kırılsın.
      await tester.runAsync(
        () => sync.whenIdle().timeout(const Duration(seconds: 5)),
      );
      expect(synced, isTrue);

      expect(client.authStore.token, old);
      expect(container.read(currentUserProvider), _user);
      expect(users, isNot(contains(null)));

      hang = false;
      online = true;
      await service.refreshSession();

      expect(client.authStore.token, fresh);
      expect(container.read(currentUserProvider), _user);
      expect(users, isNot(contains(null)));
      await tester.runAsync(db.close);
    });

    testWidgets('süresi dolmuş token çevrimdışı açılışta kurulur, sunucu '
        'reddedince senkron turunda oturum kapanır', (tester) async {
      final expired = _jwt(anHourAgo);
      await tester.runAsync(() => storeSession(expired));
      var online = false;
      handler = (request) {
        if (!online) throw http.ClientException('çevrimdışı');
        return _error(
          401,
          message: 'The request requires valid record authorization token.',
        );
      };
      final (client, service) = (await tester.runAsync(open))!;
      final container = ProviderContainer.test(
        overrides: [authServiceProvider.overrideWithValue(service)],
      );
      final db = openTestDatabase();
      final sync = SyncService(
        db,
        _IdleTransport(),
        delay: (_) async {},
        refreshSession: service.refreshSession,
      );

      // Çevrimdışı açılış: arayüz oturumu görür, yenileme kapatmaz.
      expect(client.authStore.isValid, isFalse);
      expect(container.read(currentUserProvider), _user);
      await service.refreshSession();
      expect(container.read(currentUserProvider), _user);

      online = true;
      await tester.runAsync(sync.sync);

      expect(requests.last.headers['Authorization'], expired);
      expect(container.read(currentUserProvider), isNull);
      await tester.runAsync(pumpEventQueue);
      expect(await tester.runAsync(storage.readSession), isNull);
      await tester.runAsync(db.close);
    });
  });
}
