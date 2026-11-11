import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/sync/supabase_file_store.dart';
import 'package:mobil_arici/core/sync/supabase_sync_transport.dart';
import 'package:mobil_arici/features/auth/data/supabase_session_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase'i [flavor]'ın projesiyle başlatır; uygulama ve arka plan
/// senkronu aynı ayarları kullanır.
///
/// Ağı beklemez: kayıtlı oturum diskten okunur, süresi dolmuşsa yenileme
/// arka planda denenir. Çevrimdışı yenileme hatası oturumu kapatmaz;
/// otomatik yenileme ağ gelince token'ı tazeler.
Future<void> initializeSupabase(Flavor flavor) => Supabase.initialize(
  url: flavor.supabaseUrl,
  publishableKey: flavor.supabaseAnonKey,
  authOptions: FlutterAuthClientOptions(
    localStorage: SecureSessionStorage(supabaseUrl: flavor.supabaseUrl),
    // Giriş yalnızca e-postadaki kodla; linkle oturum açılmaz, derin
    // linkler router'a kalır.
    detectSessionInUri: false,
  ),
);

/// Arka plan isolate'i için Supabase'i başlatır; kayıtlı oturum yoksa null.
Future<BackgroundConnection?> openSupabaseBackgroundConnection(
  Flavor flavor,
) async {
  await initializeSupabase(flavor);
  final client = Supabase.instance.client;
  if (client.auth.currentSession == null) return null;
  return (
    sync: SupabaseSyncTransport(client),
    files: SupabaseFileStore(client),
    refreshSession: null,
  );
}
