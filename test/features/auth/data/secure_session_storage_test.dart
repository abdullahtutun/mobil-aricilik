import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/auth/data/supabase_session_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Başka cihazdan aktarılmış, bu cihazın anahtarıyla çözülemeyen kayıt.
class _UndecryptableStorage extends Fake implements FlutterSecureStorage {
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

const _url = 'https://abcdef.supabase.co';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureSessionStorage', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    test('oturumu yazar, okur ve siler', () async {
      final storage = SecureSessionStorage(supabaseUrl: _url);
      await storage.initialize();

      expect(await storage.hasAccessToken(), isFalse);
      expect(await storage.accessToken(), isNull);

      await storage.persistSession('{"access_token":"a"}');
      expect(await storage.hasAccessToken(), isTrue);
      expect(await storage.accessToken(), '{"access_token":"a"}');

      await storage.removePersistedSession();
      expect(await storage.hasAccessToken(), isFalse);
    });

    test('kayıt anahtarı projeye özel', () async {
      await SecureSessionStorage(supabaseUrl: _url).persistSession('oturum');

      expect(
        await const FlutterSecureStorage().read(key: 'sb-abcdef-auth-token'),
        'oturum',
      );
    });

    test('başka projenin oturumu yüklenmez', () async {
      // Proje değişmeden önce yazılmış oturumlar: eski sabit anahtar ve
      // başka bir projenin anahtarı.
      FlutterSecureStorage.setMockInitialValues({
        supabasePersistSessionKey: 'eski oturum',
        'sb-other-auth-token': 'başka proje',
      });

      final storage = SecureSessionStorage(supabaseUrl: _url);

      expect(await storage.hasAccessToken(), isFalse);
      expect(await storage.accessToken(), isNull);
    });

    test('çözülemeyen kayıt yok sayılır ve silinir', () async {
      final broken = _UndecryptableStorage();
      final storage = SecureSessionStorage(supabaseUrl: _url, storage: broken);

      expect(await storage.hasAccessToken(), isFalse);
      expect(await storage.accessToken(), isNull);
      expect(broken.deletedKeys, everyElement('sb-abcdef-auth-token'));
      expect(broken.deletedKeys, isNotEmpty);
    });
  });
}
