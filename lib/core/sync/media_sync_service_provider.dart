import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/sync/backend_providers.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_sync_service_provider.g.dart';

/// Uygulamadaki tek medya yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.
@Riverpod(keepAlive: true)
MediaSyncService mediaSyncService(Ref ref) => MediaSyncService(
  ref.watch(appDatabaseProvider),
  ref.watch(fileStoreProvider),
  ref.watch(mediaFileStoreProvider),
  ref.watch(connectivityServiceProvider),
);
