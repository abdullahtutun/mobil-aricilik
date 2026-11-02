import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'knowledge_update_triggers.g.dart';

/// Bilgi bankası güncellemesine arka planda bakar: açılışta oturum hazır
/// olunca ve her senkron turu bitince (servis en çok saatte bir bakar).
/// Bilgi bankası ekranı açılınca da zorlanmış bir kontrol yapılır.
/// `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void knowledgeUpdateTriggers(Ref ref) {
  void check() {
    if (!ref.mounted || !ref.read(syncReadyProvider)) return;
    unawaited(ref.read(knowledgeUpdatesProvider.notifier).check());
  }

  ref
    ..listen(syncControllerProvider.select((activity) => activity.lastResult), (
      previous,
      result,
    ) {
      if (result != null && !identical(previous, result)) check();
    })
    ..listen(syncReadyProvider, (wasReady, ready) {
      if (ready && wasReady != true) scheduleMicrotask(check);
    }, fireImmediately: true);
}
