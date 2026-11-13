import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_auth_service.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_session_storage.dart';
import 'package:pocketbase/pocketbase.dart';

/// [flavor]'ın PocketBase sunucusunun kayıtlı oturumunu okur ve istemcinin
/// onunla kurulması için override döner. Ağı beklemez: süresi dolmuş token
/// da kurulur; yenileme açılıştan sonra arka planda denenir (K-6).
Future<List<Override>> initializePocketBase(Flavor flavor) async {
  final url = resolvePocketbaseUrl(flavor);
  final data = await PocketBaseSessionStorage(url).readSession();
  return [
    storedPocketBaseSessionProvider.overrideWithValue((
      serverUrl: url,
      data: data,
    )),
  ];
}

/// Arka plan isolate'i için [flavor]'ın PocketBase istemcisini uygulamayla
/// aynı oturum anahtarıyla açar; kayıtlı oturum yoksa null. Yenilenen ya da
/// 401'de kapanan oturum aynı kayda yazılır, uygulama sonraki açılışta onu
/// okur.
Future<BackgroundConnection?> openPocketBaseBackgroundConnection(
  Flavor flavor,
) async {
  final url = resolvePocketbaseUrl(flavor);
  final storage = PocketBaseSessionStorage(url);
  final data = await storage.readSession();
  if (data == null) return null;
  final client = PocketBase(url, authStore: storage.authStore(initial: data));
  return (
    sync: PocketBaseSyncTransport(client),
    files: PocketBaseFileStore(client),
    refreshSession: PocketBaseAuthService(client, storage).refreshSession,
  );
}
