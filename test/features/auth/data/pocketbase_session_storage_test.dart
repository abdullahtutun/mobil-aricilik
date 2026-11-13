import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_session_storage.dart';
import 'package:pocketbase/pocketbase.dart';

/// Başka cihazdan aktarılmış, bu cihazın anahtarıyla çözülemeyen ve
/// yazılamayan depo.
class _BrokenStorage extends Fake implements FlutterSecureStorage {
  final deletedKeys = <String>[];

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw PlatformException(code: 'InvalidKeyException');

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw PlatformException(code: 'KeyStoreException');

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => deletedKeys.add(key);
}

const _url = 'https://arici-api-dev.tutunsoft.com';
const _session = '{"token":"a.b.c","model":{"id":"user-1"}}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const secure = FlutterSecureStorage();

  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  group('oturum', () {
    test('kayıt anahtarları sunucu adresine özel', () {
      final storage = PocketBaseSessionStorage('$_url/');

      expect(storage.sessionKey, 'pb-auth-$_url');
      expect(storage.otpKey, 'pb-otp-$_url');
      expect(
        PocketBaseSessionStorage('http://127.0.0.1:8090').sessionKey,
        'pb-auth-http://127.0.0.1:8090',
      );
    });

    test('auth store her değişikliği yazar, çıkışta siler', () async {
      final storage = PocketBaseSessionStorage(_url);
      final store = storage.authStore()
        ..save('a.b.c', RecordModel({'id': 'user-1'}));
      await pumpEventQueue();

      expect(jsonDecode((await secure.read(key: storage.sessionKey))!), {
        'token': 'a.b.c',
        'model': {'id': 'user-1'},
      });
      expect(await storage.readSession(), isNotNull);

      store.clear();
      await pumpEventQueue();
      expect(await secure.read(key: storage.sessionKey), isNull);
    });

    test("kayıtlı oturum auth store'a yüklenir", () async {
      final storage = PocketBaseSessionStorage(_url);
      await secure.write(key: storage.sessionKey, value: _session);

      final store = storage.authStore(initial: await storage.readSession());

      expect(store.token, 'a.b.c');
      expect(store.record?.id, 'user-1');
    });

    test('başka sunucunun oturumu yüklenmez', () async {
      PocketBaseSessionStorage('https://arici-api.tutunsoft.com')
          .authStore()
          .save('prod', RecordModel({'id': 'user-1'}));
      await pumpEventQueue();

      final storage = PocketBaseSessionStorage(_url);

      expect(await storage.readSession(), isNull);
      final store = storage.authStore(initial: await storage.readSession());
      expect(store.token, isEmpty);
      expect(
        await secure.read(
          key: PocketBaseSessionStorage('https://arici-api.tutunsoft.com')
              .sessionKey,
        ),
        isNotNull,
      );
    });

    test('bozuk kayıt yok sayılır ve silinir', () async {
      final storage = PocketBaseSessionStorage(_url);
      for (final broken in [
        'düz metin',
        '[]',
        '{"token":1}',
        '{"token":"a.b.c","model":"user-1"}',
      ]) {
        await secure.write(key: storage.sessionKey, value: broken);

        expect(await storage.readSession(), isNull, reason: broken);
        expect(await secure.read(key: storage.sessionKey), isNull);
        // Doğrudan verilse de auth store çökmez.
        expect(storage.authStore(initial: broken).token, '', reason: broken);
      }
    });

    test('çözülemeyen kayıt yok sayılır ve silinir; yazılamayan oturum '
        'çökertmez', () async {
      final broken = _BrokenStorage();
      final storage = PocketBaseSessionStorage(_url, storage: broken);

      expect(await storage.readSession(), isNull);
      expect(await storage.readPendingOtp(), isNull);
      expect(broken.deletedKeys, [storage.sessionKey, storage.otpKey]);

      final store = storage.authStore()
        ..save('a.b.c', RecordModel({'id': 'user-1'}));
      await pumpEventQueue();
      // Bellekteki oturum sürer; sonraki açılışta yeniden giriş istenir.
      expect(store.token, 'a.b.c');
      await storage.savePendingOtp((
        email: 'ari@example.com',
        otpId: 'otp-1',
        sentAt: DateTime.now(),
      ));
    });
  });

  group('bekleyen kod isteği', () {
    final sentAt = DateTime.utc(2026, 11, 11, 9);

    test('saklanır ve 10 dakika okunur, sonra silinir', () async {
      final storage = PocketBaseSessionStorage(_url);
      await storage.savePendingOtp((
        email: 'ari@example.com',
        otpId: 'otp-1',
        sentAt: sentAt,
      ));

      final justBefore = sentAt.add(
        PocketBaseSessionStorage.otpLifetime - const Duration(milliseconds: 1),
      );
      expect(await withClock(Clock.fixed(justBefore), storage.readPendingOtp), (
        email: 'ari@example.com',
        otpId: 'otp-1',
        sentAt: sentAt,
      ));

      final expired = sentAt.add(PocketBaseSessionStorage.otpLifetime);
      expect(
        await withClock(Clock.fixed(expired), storage.readPendingOtp),
        isNull,
      );
      expect(await secure.read(key: storage.otpKey), isNull);
    });

    test(
      'yeni istek eskisinin yerine geçer; başka sunucununki görünmez',
      () async {
        final storage = PocketBaseSessionStorage(_url);
        await storage.savePendingOtp((
          email: 'ari@example.com',
          otpId: 'otp-1',
          sentAt: sentAt,
        ));
        await storage.savePendingOtp((
          email: 'ari@example.com',
          otpId: 'otp-2',
          sentAt: sentAt,
        ));

        await withClock(Clock.fixed(sentAt), () async {
          expect((await storage.readPendingOtp())?.otpId, 'otp-2');
          expect(
            await PocketBaseSessionStorage('http://127.0.0.1:8090')
                .readPendingOtp(),
            isNull,
          );
        });
      },
    );

    test('bozuk kayıt yok sayılır ve silinir', () async {
      final storage = PocketBaseSessionStorage(_url);
      for (final broken in [
        'düz metin',
        '{"email":"ari@example.com","otp_id":"otp-1"}',
        '{"email":"ari@example.com","otp_id":"otp-1","sent_at":"dün"}',
      ]) {
        await secure.write(key: storage.otpKey, value: broken);

        expect(await storage.readPendingOtp(), isNull, reason: broken);
        expect(await secure.read(key: storage.otpKey), isNull, reason: broken);
      }
    });
  });
}
