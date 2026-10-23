import 'dart:async';
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;

import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_triggers.g.dart';

/// Son yerel yazmadan bu kadar sonra tur başlar; art arda yazmalar tek
/// turda gider.
const syncDebounce = Duration(seconds: 5);

/// Uygulama açıkken arka plan görevinin senkronu devrettiği port.
const foregroundSyncPortName = 'mobil_arici.sync';

/// Senkronu tetikler (teknik.md §3, "Ne zaman çalışır"):
///
/// - açılış: oturum ve işletme hazır olunca (girişten sonra da),
/// - yerel yazmadan [syncDebounce] sonra,
/// - ağ geri gelince,
/// - workmanager'ın periyodik görevi uygulama açıkken çalışırsa
///   ([foregroundSyncPortName] üzerinden).
///
/// Oturum ya da işletme yokken tetikler tur başlatmaz
/// ([SyncController.sync]). `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void syncTriggers(Ref ref) {
  final controller = ref.read(syncControllerProvider.notifier);
  void sync() => unawaited(controller.sync());

  Timer? debounce;
  void restartDebounce() {
    debounce?.cancel();
    debounce = Timer(syncDebounce, sync);
  }

  final writes = ref
      .read(syncRepositoryProvider)
      .watchLocalWrites()
      .listen((_) => restartDebounce());
  final network = ref
      .read(connectivityServiceProvider)
      .reconnected
      .listen((_) => sync());
  final background = ReceivePort()..listen((_) => sync());
  IsolateNameServer.removePortNameMapping(foregroundSyncPortName);
  IsolateNameServer.registerPortWithName(
    background.sendPort,
    foregroundSyncPortName,
  );
  ref
    ..onDispose(() {
      debounce?.cancel();
      unawaited(writes.cancel());
      unawaited(network.cancel());
      background.close();
      IsolateNameServer.removePortNameMapping(foregroundSyncPortName);
    })
    // Build sırasında başka bir provider'ın durumu değişemez; tur bir
    // mikro görev sonra başlar.
    ..listen(syncReadyProvider, (wasReady, ready) {
      if (ready && wasReady != true) scheduleMicrotask(sync);
    }, fireImmediately: true);
}
