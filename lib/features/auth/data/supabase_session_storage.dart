import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobil_arici/core/services/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase oturumunu (access + refresh token) Keychain/Keystore'da tutar;
/// varsayılan SharedPreferences düz metin saklardı.
class SecureSessionStorage extends LocalStorage {
  new({required String supabaseUrl, this.storage = appSecureStorage})
    : key = 'sb-${Uri.parse(supabaseUrl).host.split('.').first}-auth-token';

  final FlutterSecureStorage storage;

  /// Projeye özel kayıt anahtarı (`sb-<ref>-auth-token`, supabase_flutter'ın
  /// varsayılanıyla aynı biçim). Proje değişirse eski projenin oturumu
  /// yüklenmez.
  final String key;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => await accessToken() != null;

  @override
  Future<String?> accessToken() async {
    try {
      return await storage.read(key: key);
    } on PlatformException {
      // Anahtarı bu cihazda olmayan kayıt (ör. cihazdan cihaza aktarım)
      // çözülemez. Uygulama çökmesin; oturum yok sayılır, yeniden giriş
      // istenir.
      await removePersistedSession();
      return null;
    }
  }

  @override
  Future<void> persistSession(String persistSessionString) =>
      storage.write(key: key, value: persistSessionString);

  @override
  Future<void> removePersistedSession() async {
    try {
      await storage.delete(key: key);
    } on PlatformException {
      // Silinemeyen kayıt bir sonraki açılışta yine okunamaz, yine yok sayılır.
    }
  }
}
