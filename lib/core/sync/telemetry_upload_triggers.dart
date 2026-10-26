import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/analytics/analytics_providers.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_service_provider.dart';
import 'package:mobil_arici/features/feedback/presentation/feedback_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'telemetry_upload_triggers.g.dart';

/// Yeni görüşten bu kadar sonra gönderim başlar.
const feedbackUploadDebounce = Duration(seconds: 2);

/// Uygulama açıkken görüş ve kullanım olayı gönderimini başlatır:
///
/// - açılış: oturum ve işletme hazır olunca,
/// - yeni görüşten [feedbackUploadDebounce] sonra,
/// - ağ geri gelince,
/// - her senkron turu bitince (olaylar senkronla aynı sıklıkta gider),
/// - analitik yeniden açılınca.
///
/// Arka plan görevi yok; uygulama kapalıyken kuyrukta bekler. `bootstrap`
/// uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void telemetryUploadTriggers(Ref ref) {
  final service = ref.read(telemetryUploadServiceProvider);

  void upload() {
    if (!ref.mounted || !ref.read(syncReadyProvider)) return;
    unawaited(service.uploadPending());
  }

  Timer? debounce;
  var lastPending = 0;
  final pending = ref
      .read(feedbackRepositoryProvider)
      .watchPendingCount()
      .listen((count) {
        // Yalnız yeni görüş; gönderilen görüş sayıyı düşürür.
        if (count > lastPending) {
          debounce?.cancel();
          debounce = Timer(feedbackUploadDebounce, upload);
        }
        lastPending = count;
      });
  final network = ref
      .read(connectivityServiceProvider)
      .reconnected
      .listen((_) => upload());
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
      if (result != null && !identical(previous, result)) upload();
    })
    ..listen(analyticsEnabledProvider.select((enabled) => enabled.value), (
      wasEnabled,
      enabled,
    ) {
      if (wasEnabled == false && enabled == true) upload();
    })
    ..listen(syncReadyProvider, (wasReady, ready) {
      if (ready && wasReady != true) scheduleMicrotask(upload);
    }, fireImmediately: true);
}
