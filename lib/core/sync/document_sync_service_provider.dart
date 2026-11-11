import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/document_services_provider.dart';
import 'package:mobil_arici/core/sync/backend_providers.dart';
import 'package:mobil_arici/core/sync/document_sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_sync_service_provider.g.dart';

/// Uygulamadaki tek belge dosyası yükleyicisi; kilit bu örneğe bağlı
/// olduğu için canlı tutulur.
@Riverpod(keepAlive: true)
DocumentSyncService documentSyncService(Ref ref) => DocumentSyncService(
  ref.watch(appDatabaseProvider),
  ref.watch(fileStoreProvider),
  ref.watch(documentFileStoreProvider),
);
