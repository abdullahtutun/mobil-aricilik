import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/logo_file_store_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/logo_sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logo_sync_service_provider.g.dart';

/// Uygulamadaki tek logo yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.
@Riverpod(keepAlive: true)
LogoSyncService logoSyncService(Ref ref) => LogoSyncService(
  ref.watch(appDatabaseProvider),
  ref.watch(supabaseClientProvider),
  ref.watch(logoFileStoreProvider),
);
