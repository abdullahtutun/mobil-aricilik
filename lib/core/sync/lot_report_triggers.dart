import 'package:mobil_arici/core/services/document_services_provider.dart';
import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/core/sync/lot_report_service.dart';
import 'package:mobil_arici/core/sync/storage_file_sync.dart';
import 'package:mobil_arici/core/sync/storage_file_triggers.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/harvest/data/lot_report_api.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lot_report_triggers.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
LotReportApi lotReportApi(Ref ref) =>
    PocketBaseLotReportApi(ref.watch(pocketbaseClientProvider));

/// Uygulamadaki tek rapor yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.
@Riverpod(keepAlive: true)
LotReportService lotReportService(Ref ref) => LotReportService(
  ref.watch(lotRepositoryProvider),
  ref.watch(documentRepositoryProvider),
  ref.watch(documentFileStoreProvider),
  ref.watch(lotReportApiProvider),
);

/// Uygulama açıkken yayımdaki lotların raporlarını yükler; anlar
/// [listenStorageFileSync]'te (açılış, ağ gelince, her senkron turu
/// sonunda). Lot yayımlanınca satır önce gönderilmeli, bu yüzden yazmanın
/// kendisi tetiklemez; ardından gelen senkron turu tetikler. Yazamayan
/// rolde (viewer) çalışmaz. `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void lotReportTriggers(Ref ref) {
  final service = ref.read(lotReportServiceProvider);
  listenStorageFileSync(
    ref,
    uploadPending: () async {
      final orgId = ref.read(currentOrgIdProvider);
      if (orgId == null) return const FileSyncResult();
      return await service.uploadReports(orgId);
    },
    downloadMissing: (_) async => const FileSyncResult(),
    pendingCount: const Stream.empty(),
    debounce: Duration.zero,
    onDownloaded: () {},
    allowed: () => ref.read(canWriteRecordsProvider),
  );
}
