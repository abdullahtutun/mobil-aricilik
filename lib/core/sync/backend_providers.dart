import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/core/sync/pocketbase_telemetry_api.dart';
import 'package:mobil_arici/core/sync/sync_transport.dart';
import 'package:mobil_arici/core/sync/telemetry_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend_providers.g.dart';

/// Senkronun sunucuyla konuştuğu taşıyıcı.
@Riverpod(keepAlive: true)
SyncTransport syncTransport(Ref ref) =>
    PocketBaseSyncTransport(ref.watch(pocketbaseClientProvider));

/// Sunucudaki dosya deposu.
@Riverpod(keepAlive: true)
FileStore fileStore(Ref ref) =>
    PocketBaseFileStore(ref.watch(pocketbaseClientProvider));

/// Görüş ve kullanım olayı satırlarının yazıldığı yer.
@Riverpod(keepAlive: true)
TelemetryApi telemetryApi(Ref ref) =>
    PocketBaseTelemetryApi(ref.watch(pocketbaseClientProvider));
