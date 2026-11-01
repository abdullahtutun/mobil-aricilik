import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/receipt_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receipt_file_triggers.g.dart';

/// Yeni fişten bu kadar sonra yükleme başlar.
const receiptUploadDebounce = Duration(seconds: 2);

/// Uygulama açıkken fiş fotoğraflarını yükler ve eksikleri indirir; belge
/// dosyalarıyla aynı anlarda (`documentFileTriggers`): açılışta, yeni
/// fişten [receiptUploadDebounce] sonra, ağ geri gelince ve her senkron
/// turu bitince. Finansı göremeyen rolde (worker, viewer) hiç çalışmaz.
/// `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void receiptFileTriggers(Ref ref) {
  final service = ref.read(receiptSyncServiceProvider);

  bool ready() =>
      ref.mounted &&
      ref.read(syncReadyProvider) &&
      ref.read(canSeeFinanceProvider);

  Future<void> upload() async {
    if (!ready()) return;
    await service.uploadPending();
  }

  Future<void> download() async {
    if (!ready()) return;
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    final result = await service.downloadMissing(orgId);
    if (result.done > 0 && ref.mounted) ref.invalidate(receiptFileProvider);
  }

  void start() {
    unawaited(upload().catchError((Object _) {}));
    unawaited(download().catchError((Object _) {}));
  }

  Timer? debounce;
  var lastPending = 0;
  final pending = ref
      .read(transactionRepositoryProvider)
      .watchPendingReceiptCount()
      .listen((count) {
        // Yalnız yeni fiş; yüklenen fiş sayıyı düşürür.
        if (count > lastPending) {
          debounce?.cancel();
          debounce = Timer(
            receiptUploadDebounce,
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
