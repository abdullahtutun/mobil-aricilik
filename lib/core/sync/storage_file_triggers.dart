import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/storage_file_sync.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Uygulama açıkken [StorageFileSync] dosyalarını yükler ve eksikleri
/// indirir (belge, fiş):
///
/// - açılış: oturum ve işletme hazır olunca,
/// - [pendingCount] artınca [debounce] sonra (yalnız yükleme),
/// - ağ geri gelince,
/// - her senkron turu bitince (başka telefonda eklenen dosya inmiş olabilir).
///
/// [allowed] false iken (ör. rol dosyayı göremez) hiçbir şey yapmaz. Dosya
/// indirilirse [onDownloaded] çağrılır. Arka plan görevi yok; uygulama
/// kapalıyken dosyalar bekler. Dinleyiciler [ref] ile birlikte kapanır.
void listenStorageFileSync(
  Ref ref, {
  required Future<FileSyncResult> Function() uploadPending,
  required Future<FileSyncResult> Function(String orgId) downloadMissing,
  required Stream<int> pendingCount,
  required Duration debounce,
  required void Function() onDownloaded,
  bool Function() allowed = _always,
}) {
  bool ready() => ref.mounted && ref.read(syncReadyProvider) && allowed();

  Future<void> upload() async {
    if (!ready()) return;
    await uploadPending();
  }

  Future<void> download() async {
    if (!ready()) return;
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    final result = await downloadMissing(orgId);
    if (result.done > 0 && ref.mounted) onDownloaded();
  }

  void start() {
    unawaited(upload().catchError((Object _) {}));
    unawaited(download().catchError((Object _) {}));
  }

  Timer? timer;
  var lastPending = 0;
  final pending = pendingCount.listen((count) {
    // Yalnız yeni dosya; yüklenen dosya sayıyı düşürür.
    if (count > lastPending) {
      timer?.cancel();
      timer = Timer(
        debounce,
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
      timer?.cancel();
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

bool _always() => true;
