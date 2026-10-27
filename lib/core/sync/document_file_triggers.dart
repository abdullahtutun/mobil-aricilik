import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/document_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_file_triggers.g.dart';

/// Yeni belge dosyasından bu kadar sonra yükleme başlar.
const documentUploadDebounce = Duration(seconds: 2);

/// Uygulama açıkken belge dosyalarını yükler ve eksikleri indirir:
///
/// - açılış: oturum ve işletme hazır olunca,
/// - yeni dosyadan [documentUploadDebounce] sonra (yalnız yükleme),
/// - ağ geri gelince,
/// - her senkron turu bitince (başka telefonda eklenen belge inmiş olabilir).
///
/// İndirilen dosya olursa kasadaki "internetsiz açılır" durumu yenilenir.
/// Arka plan görevi yok; uygulama kapalıyken dosyalar bekler. `bootstrap`
/// uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void documentFileTriggers(Ref ref) {
  final service = ref.read(documentSyncServiceProvider);

  Future<void> upload() async {
    if (!ref.mounted || !ref.read(syncReadyProvider)) return;
    await service.uploadPending();
  }

  Future<void> download() async {
    if (!ref.mounted || !ref.read(syncReadyProvider)) return;
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    final result = await service.downloadMissing(orgId);
    if (result.done > 0 && ref.mounted) {
      ref.invalidate(documentLocalFilesProvider);
    }
  }

  void start() {
    unawaited(upload().catchError((Object _) {}));
    unawaited(download().catchError((Object _) {}));
  }

  Timer? debounce;
  var lastPending = 0;
  final pending = ref
      .read(documentRepositoryProvider)
      .watchPendingUploadCount()
      .listen((count) {
        // Yalnız yeni dosya; yüklenen dosya sayıyı düşürür.
        if (count > lastPending) {
          debounce?.cancel();
          debounce = Timer(
            documentUploadDebounce,
            () => unawaited(upload().catchError((Object _) {})),
          );
        }
        lastPending = count;
      });
  final network = ref
      .read(connectivityServiceProvider)
      .reconnected
      .listen((_) => start());
  ref
    ..onDispose(() {
      debounce?.cancel();
      unawaited(pending.cancel());
      unawaited(network.cancel());
    })
    ..listen(syncControllerProvider.select((activity) => activity.lastResult), (
      previous,
      result,
    ) {
      if (result != null && !identical(previous, result)) start();
    })
    ..listen(syncReadyProvider, (wasReady, ready) {
      if (ready && wasReady != true) scheduleMicrotask(start);
    }, fireImmediately: true);
}
