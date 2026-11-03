import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/analytics/analytics_providers.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_controller.freezed.dart';
part 'sync_controller.g.dart';

/// Senkronun bu oturumdaki durumu. Bekleyen ve reddedilen kayıtlar
/// outbox'tan, yani `sync_providers` akışlarından okunur.
@freezed
abstract class SyncActivity with _$SyncActivity {
  const factory({
    @Default(false) bool running,

    /// Süren turun çekme ilerleyişi; gönderme sürerken ya da tur yokken
    /// boş.
    SyncProgress? progress,

    /// Son biten turun sonucu.
    SyncResult? lastResult,

    /// Son başarılı turun bittiği an.
    DateTime? lastSyncedAt,
  }) = _SyncActivity;
}

/// Senkron turlarını başlatır ve durumunu ekranlara verir. Tetikleyiciler
/// (`syncTriggersProvider`) ve ekranlar turu buradan başlatır. Kullanıcı
/// değişince sıfırlanır.
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  @override
  SyncActivity build() {
    ref.watch(currentUserProvider.select((user) => user?.id));
    return const SyncActivity();
  }

  /// Bir tur çalıştırır; tur sürüyorsa yenisini başlatmaz, onun sonucunu
  /// bekler. Oturum ya da işletme yoksa bir şey yapmaz ve null döner.
  Future<SyncResult?> sync() async {
    if (!ref.read(syncReadyProvider)) return null;
    final service = ref.read(syncServiceProvider);
    if (state.running) return await service.sync();

    state = state.copyWith(running: true, progress: null);
    final startedAt = clock.now();
    SyncResult? result;
    try {
      result = await service.sync(
        onProgress: (progress) {
          if (ref.mounted) state = state.copyWith(progress: progress);
        },
      );
      if (service.lastPushDelay case final delay?
          when result.pushed > 0 && ref.mounted) {
        unawaited(
          ref.read(analyticsRepositoryProvider).record(
            AnalyticsEvent.syncPushed,
            {
              'records': result.pushed,
              'rejected': result.rejected,
              'max_delay_s': durationSeconds(delay),
              'turn_s': durationSeconds(clock.now().difference(startedAt)),
            },
          ),
        );
      }
      return result;
    } finally {
      // Beklenmeyen hata (ör. yerel DB) da turu bitirir; ikon dönüp kalmaz.
      final finished = result ?? const SyncResult(status: SyncStatus.failed);
      if (ref.mounted) {
        state = SyncActivity(
          lastResult: finished,
          lastSyncedAt: finished.status == SyncStatus.done
              ? clock.now()
              : state.lastSyncedAt,
        );
      }
    }
  }
}
