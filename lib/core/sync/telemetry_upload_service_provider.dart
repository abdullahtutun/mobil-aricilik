import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/app_info_service_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'telemetry_upload_service_provider.g.dart';

/// Uygulamadaki tek görüş ve kullanım olayı göndericisi; kilit bu örneğe
/// bağlı olduğu için canlı tutulur.
@Riverpod(keepAlive: true)
TelemetryUploadService telemetryUploadService(Ref ref) =>
    TelemetryUploadService(
      ref.watch(appDatabaseProvider),
      ref.watch(supabaseClientProvider),
      ref.watch(mediaFileStoreProvider),
      ref.watch(appInfoServiceProvider),
    );
