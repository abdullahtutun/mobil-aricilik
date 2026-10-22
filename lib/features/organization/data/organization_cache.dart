import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';

/// İşletmenin cihazdaki kopyası; uygulama çevrimdışı açılınca işletme
/// buradan gelir. Yerel DB gelince oraya taşınacak.
abstract interface class OrganizationCache {
  /// [userId]'nin kayıtlı işletmesi; yoksa ya da başka kullanıcınınsa null.
  Future<Organization?> read(String userId);

  Future<void> write(String userId, Organization organization);

  Future<void> clear();
}

/// Kopyayı oturumla aynı yerde, Keychain/Keystore'da tutar. Okuma ve yazma
/// hataları yutulur; en kötü durumda işletme yeniden sunucudan alınır.
class SecureOrganizationCache implements OrganizationCache {
  const new({
    this.storage = const FlutterSecureStorage(
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  });

  final FlutterSecureStorage storage;

  static const key = 'active-organization';

  @override
  Future<Organization?> read(String userId) async {
    try {
      final raw = await storage.read(key: key);
      if (raw == null) return null;
      final json = jsonDecode(raw) as Map<String, dynamic>;
      if (json['user_id'] != userId) return null;
      return Organization.fromJson(
        json['organization'] as Map<String, dynamic>,
      );
    } on PlatformException {
      return null;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> write(String userId, Organization organization) async {
    try {
      await storage.write(
        key: key,
        value: jsonEncode({
          'user_id': userId,
          'organization': organization.toJson(),
        }),
      );
    } on PlatformException {
      // Kopya yazılamazsa sonraki açılışta işletme sunucudan alınır.
    }
  }

  @override
  Future<void> clear() async {
    try {
      await storage.delete(key: key);
    } on PlatformException {
      // Kalan kopya başka kullanıcıya gösterilmez; okurken kullanıcısı
      // denetlenir.
    }
  }
}
