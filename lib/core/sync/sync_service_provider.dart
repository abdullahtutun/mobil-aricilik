import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;

part 'sync_service_provider.g.dart';

/// Uygulamadaki tek senkron servisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur. `bootstrap` Supabase'i başlattıktan sonra okunur.
@Riverpod(keepAlive: true)
SyncService syncService(Ref ref) =>
    SyncService(ref.watch(appDatabaseProvider), Supabase.instance.client);
