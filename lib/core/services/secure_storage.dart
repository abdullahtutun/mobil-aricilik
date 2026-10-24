import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keychain/Keystore; oturum ve işletme kopyası burada. Arka plan senkronu
/// kilit ekranındayken de okuyabilsin; kayıt yedekle başka cihaza
/// taşınmasın.
const appSecureStorage = FlutterSecureStorage(
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  ),
);
