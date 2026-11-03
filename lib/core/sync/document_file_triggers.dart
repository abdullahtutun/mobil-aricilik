import 'package:mobil_arici/core/sync/document_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/storage_file_triggers.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_file_triggers.g.dart';

/// Yeni belge dosyasından bu kadar sonra yükleme başlar.
const documentUploadDebounce = Duration(seconds: 2);

/// Uygulama açıkken belge dosyalarını yükler ve eksikleri indirir; anlar
/// [listenStorageFileSync]'te. İndirilen dosya olursa kasadaki "internetsiz
/// açılır" durumu yenilenir. `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void documentFileTriggers(Ref ref) {
  final service = ref.read(documentSyncServiceProvider);
  listenStorageFileSync(
    ref,
    uploadPending: service.uploadPending,
    downloadMissing: service.downloadMissing,
    pendingCount: ref
        .read(documentRepositoryProvider)
        .watchPendingUploadCount(),
    debounce: documentUploadDebounce,
    onDownloaded: () => ref.invalidate(documentLocalFilesProvider),
  );
}
