import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/pocketbase_setup.dart';
import 'package:mobil_arici/app/supabase_setup.dart';
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/sync_transport.dart';

/// Arka plan görevinin sunucuya gittiği arayüzler. `refreshSession`
/// senkron turunun başında token'ı yeniler (PocketBase, K-6); Supabase'de
/// null, istemci kendisi yeniler.
typedef BackgroundConnection = ({
  SyncTransport sync,
  FileStore files,
  Future<void> Function()? refreshSession,
});

/// Uygulama açılırken [backend]'in istemcisini başlatır; ağı beklemez.
/// Dönen override'lar uygulamanın provider kabına eklenir.
Future<List<Override>> initializeBackend(Flavor flavor, Backend backend) async {
  switch (backend) {
    case Backend.supabase:
      await initializeSupabase(flavor);
      return const [];
    case Backend.pocketbase:
      return await initializePocketBase(flavor);
  }
}

/// Senkronun bağlandığı sunucunun kimliği, `<backend>|<adres>`; değişirse
/// yerel imleçler sıfırlanır (`resetCursorsIfBackendChanged`).
String syncBackendIdentity(Flavor flavor, Backend backend) =>
    '${backend.name}|${switch (backend) {
      Backend.supabase => flavor.supabaseUrl,
      Backend.pocketbase => resolvePocketbaseUrl(flavor),
    }}';

/// Arka plan isolate'inde [backend]'in istemcisini açar; kayıtlı oturum
/// yoksa null (görev bir şey yapmaz).
Future<BackgroundConnection?> openBackgroundConnection(
  Flavor flavor,
  Backend backend,
) => switch (backend) {
  Backend.supabase => openSupabaseBackgroundConnection(flavor),
  Backend.pocketbase => openPocketBaseBackgroundConnection(flavor),
};
