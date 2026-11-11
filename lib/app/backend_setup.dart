import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/supabase_setup.dart';
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/sync_transport.dart';

/// Arka plan görevinin sunucuya gittiği arayüzler.
typedef BackgroundConnection = ({SyncTransport sync, FileStore files});

/// Uygulama açılırken [backend]'in istemcisini başlatır; ağı beklemez.
Future<void> initializeBackend(Flavor flavor, Backend backend) =>
    switch (backend) {
      Backend.supabase => initializeSupabase(flavor),
      Backend.pocketbase => throw UnimplementedError(
        'PocketBase istemcisi: P7.2',
      ),
    };

/// Arka plan isolate'inde [backend]'in istemcisini açar; kayıtlı oturum
/// yoksa null (görev bir şey yapmaz).
Future<BackgroundConnection?> openBackgroundConnection(
  Flavor flavor,
  Backend backend,
) => switch (backend) {
  Backend.supabase => openSupabaseBackgroundConnection(flavor),
  Backend.pocketbase => throw UnimplementedError(
    'PocketBase arka plan senkronu: P7.3',
  ),
};
