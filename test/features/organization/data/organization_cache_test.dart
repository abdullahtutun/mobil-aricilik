import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/organization/data/organization_cache.dart';

import '../../../helpers/fake_organization_service.dart';

/// Keychain/Keystore'a erişilemeyen cihaz.
class _BrokenStorage extends Fake implements FlutterSecureStorage {
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
  }) async => throw PlatformException(code: 'InvalidKeyException');

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw PlatformException(code: 'InvalidKeyException');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureOrganizationCache', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('işletmeyi yazar, okur ve siler', () async {
      const cache = SecureOrganizationCache();

      expect(await cache.read('user-1'), isNull);

      await cache.write('user-1', testOrganization);
      expect(await cache.read('user-1'), testOrganization);

      await cache.clear();
      expect(await cache.read('user-1'), isNull);
    });

    test('kovan sayısı boş işletme de saklanır', () async {
      const cache = SecureOrganizationCache();
      final organization = testOrganization.copyWith(hiveCountRange: null);

      await cache.write('user-1', organization);

      expect(await cache.read('user-1'), organization);
    });

    test('başka kullanıcının kopyası okunmaz', () async {
      const cache = SecureOrganizationCache();
      await cache.write('user-1', testOrganization);

      expect(await cache.read('user-2'), isNull);
    });

    test('bozuk kayıt yok sayılır', () async {
      FlutterSecureStorage.setMockInitialValues({
        SecureOrganizationCache.key: '{bozuk',
      });

      expect(await const SecureOrganizationCache().read('user-1'), isNull);
    });

    test('depolama hataları yutulur', () async {
      final cache = SecureOrganizationCache(storage: _BrokenStorage());

      await cache.write('user-1', testOrganization);
      await cache.clear();
      expect(await cache.read('user-1'), isNull);
    });
  });
}
