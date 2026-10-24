import 'dart:async';
import 'dart:isolate';
import 'dart:ui' show IsolateNameServer;

import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/media_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/media_upload_scheduler.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/media/presentation/media_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_upload_triggers.g.dart';

/// Yeni medya kaydından bu kadar sonra yükleme başlar; art arda çekilen
/// fotoğraflar tek turda gider.
const mediaUploadDebounce = Duration(seconds: 2);

/// Uygulama açıkken arka plan görevinin medya yüklemesini devrettiği port.
const foregroundMediaPortName = 'mobil_arici.media';

/// Uygulama açıkken medya yüklemesini başlatır:
///
/// - açılış: oturum ve işletme hazır olunca,
/// - yeni foto ya da sesli nottan [mediaUploadDebounce] sonra,
/// - ağ geri gelince ve Wi‑Fi'a geçince,
/// - "sadece Wi‑Fi" ayarı değişince,
/// - workmanager görevi uygulama açıkken çalışırsa
///   ([foregroundMediaPortName] üzerinden).
///
/// Tur bittiğinde yüklenmeyi bekleyen dosya kalırsa arka plan görevi
/// planlanır; uygulama kapansa da ağ gelince yüklenir. `bootstrap`
/// uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void mediaUploadTriggers(Ref ref) {
  final service = ref.read(mediaSyncServiceProvider);
  final settings = ref.read(localSettingsRepositoryProvider);
  final media = ref.read(mediaRepositoryProvider);
  final connectivity = ref.read(connectivityServiceProvider);

  Future<void> schedule({bool replace = false}) async {
    if (await media.pendingUploadCount() == 0) return;
    await ref
        .read(mediaUploadSchedulerProvider)
        .schedule(wifiOnly: await settings.mediaWifiOnly(), replace: replace);
  }

  Future<void> upload() async {
    if (!ref.mounted || !ref.read(syncReadyProvider)) return;
    await service.uploadPending();
    if (ref.mounted) await schedule();
  }

  void start() => unawaited(upload());

  Timer? debounce;
  var lastPending = 0;
  final pending = media.watchPendingUploadCount().listen((count) {
    // Yalnız yeni kayıt; yüklenen dosya sayıyı düşürür.
    if (count > lastPending) {
      debounce?.cancel();
      debounce = Timer(mediaUploadDebounce, start);
    }
    lastPending = count;
  });
  final network = connectivity.reconnected.listen((_) => start());
  final wifi = connectivity.unmeteredConnected.listen((_) => start());
  final wifiOnly = settings.watchMediaWifiOnly().skip(1).listen((_) {
    unawaited(schedule(replace: true));
    start();
  });
  final background = ReceivePort()..listen((_) => start());
  IsolateNameServer.removePortNameMapping(foregroundMediaPortName);
  IsolateNameServer.registerPortWithName(
    background.sendPort,
    foregroundMediaPortName,
  );
  ref
    ..onDispose(() {
      debounce?.cancel();
      unawaited(pending.cancel());
      unawaited(network.cancel());
      unawaited(wifi.cancel());
      unawaited(wifiOnly.cancel());
      background.close();
      IsolateNameServer.removePortNameMapping(foregroundMediaPortName);
    })
    ..listen(syncReadyProvider, (wasReady, ready) {
      if (ready && wasReady != true) scheduleMicrotask(start);
    }, fireImmediately: true);
}
