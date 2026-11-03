import 'package:mobil_arici/core/sync/receipt_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/storage_file_triggers.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receipt_file_triggers.g.dart';

/// Yeni fişten bu kadar sonra yükleme başlar.
const receiptUploadDebounce = Duration(seconds: 2);

/// Uygulama açıkken fiş fotoğraflarını yükler ve eksikleri indirir; belge
/// dosyalarıyla aynı anlarda ([listenStorageFileSync]). Finansı göremeyen
/// rolde (worker, viewer) hiç çalışmaz. `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void receiptFileTriggers(Ref ref) {
  final service = ref.read(receiptSyncServiceProvider);
  listenStorageFileSync(
    ref,
    uploadPending: service.uploadPending,
    downloadMissing: service.downloadMissing,
    pendingCount: ref
        .read(transactionRepositoryProvider)
        .watchPendingReceiptCount(),
    debounce: receiptUploadDebounce,
    onDownloaded: () => ref.invalidate(receiptFileProvider),
    allowed: () => ref.read(canSeeFinanceProvider),
  );
}
