import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_service_provider.g.dart';

/// Uygulamadaki tek senkron servisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.
@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) => SyncService(
  ref.watch(appDatabaseProvider),
  ref.watch(supabaseClientProvider),
);
