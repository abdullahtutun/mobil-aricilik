import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/receipt_file_store_provider.dart';
import 'package:mobil_arici/core/sync/backend_providers.dart';
import 'package:mobil_arici/core/sync/receipt_sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receipt_sync_service_provider.g.dart';

/// Uygulamadaki tek fiş yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.
@Riverpod(keepAlive: true)
ReceiptSyncService receiptSyncService(Ref ref) => ReceiptSyncService(
  ref.watch(appDatabaseProvider),
  ref.watch(fileStoreProvider),
  ref.watch(receiptFileStoreProvider),
);
