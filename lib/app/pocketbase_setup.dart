import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_session_storage.dart';

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
