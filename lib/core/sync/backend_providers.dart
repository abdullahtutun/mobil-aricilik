import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/core/sync/supabase_file_store.dart';
import 'package:mobil_arici/core/sync/supabase_sync_transport.dart';
import 'package:mobil_arici/core/sync/supabase_telemetry_api.dart';
import 'package:mobil_arici/core/sync/sync_transport.dart';
import 'package:mobil_arici/core/sync/telemetry_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend_providers.g.dart';

/// Senkronun sunucuyla konuştuğu taşıyıcı; [backendProvider]'a göre.
@Riverpod(keepAlive: true)
SyncTransport syncTransport(Ref ref) => switch (ref.watch(backendProvider)) {
  Backend.supabase => SupabaseSyncTransport(ref.watch(supabaseClientProvider)),
  Backend.pocketbase => PocketBaseSyncTransport(
    ref.watch(pocketbaseClientProvider),
  ),
};

/// Sunucudaki dosya deposu; [backendProvider]'a göre.
@Riverpod(keepAlive: true)
FileStore fileStore(Ref ref) => switch (ref.watch(backendProvider)) {
  Backend.supabase => SupabaseFileStore(ref.watch(supabaseClientProvider)),
  Backend.pocketbase => throw UnimplementedError('PocketBase dosyaları: P7.4'),
};

/// Görüş ve kullanım olayı satırlarının yazıldığı yer; [backendProvider]'a
/// göre.
@Riverpod(keepAlive: true)
TelemetryApi telemetryApi(Ref ref) => switch (ref.watch(backendProvider)) {
  Backend.supabase => SupabaseTelemetryApi(ref.watch(supabaseClientProvider)),
  Backend.pocketbase => throw UnimplementedError('PocketBase görüş: P7.5'),
};
