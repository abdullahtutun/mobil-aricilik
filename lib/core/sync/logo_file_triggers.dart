import 'package:mobil_arici/core/sync/logo_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/storage_file_triggers.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logo_file_triggers.g.dart';

/// Yeni logodan bu kadar sonra yükleme başlar.
const logoUploadDebounce = Duration(seconds: 2);

/// Uygulama açıkken işletme logosunu yükler ve eksikse indirir; belge ve
/// fiş dosyalarıyla aynı anlarda ([listenStorageFileSync]). `bootstrap`
/// uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void logoFileTriggers(Ref ref) {
  final service = ref.read(logoSyncServiceProvider);
  listenStorageFileSync(
    ref,
    uploadPending: service.uploadPending,
    downloadMissing: service.downloadMissing,
    pendingCount: service.watchPendingCount(),
    debounce: logoUploadDebounce,
    onDownloaded: () => ref.invalidate(organizationLogoFileProvider),
  );
}
