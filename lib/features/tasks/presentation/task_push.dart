import 'dart:async';

import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/services/push_service_provider.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/features/tasks/data/device_token_service.dart';
import 'package:mobil_arici/features/tasks/data/supabase_device_token_service.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_push.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
DeviceTokenService deviceTokenService(Ref ref) => switch (ref.watch(
  backendProvider,
)) {
  Backend.supabase => SupabaseDeviceTokenService(
    ref.watch(supabaseClientProvider),
  ),
  Backend.pocketbase => throw UnimplementedError('PocketBase push token: P7.5'),
};

/// Bu telefonun push token'ını sunucuya kaydeder: görev atanınca bildirim
/// buraya gelir. Oturum açıkken ve "Görev bildirimleri" açıkken çalışır;
/// bildirim izni telefonda bir kez sorulur. Token yenilenince yeniden
/// kaydedilir. Çevrimdışı ya da başarısız kayıt sessizce geçilir, sonraki
/// açılışta yeniden denenir. `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
class PushRegistration extends _$PushRegistration {
  /// Her kurulumda artar; kapatma ya da çıkıştan sonra biten eski
  /// kayıt denemesi token'ı yeniden yazmasın.
  var _generation = 0;

  @override
  void build() {
    final generation = ++_generation;
    final userId = ref.watch(currentUserIdProvider);
    final enabled = ref.watch(pushEnabledProvider).value ?? false;
    if (userId == null || !enabled) return;

    final subscription = ref
        .read(pushServiceProvider)
        .tokenRefreshes
        .listen((token) => unawaited(_register(token, generation)));
    ref.onDispose(() => unawaited(subscription.cancel()));
    unawaited(_start(generation));
  }

  Future<void> _start(int generation) async {
    final push = ref.read(pushServiceProvider);
    final settings = ref.read(localSettingsRepositoryProvider);
    final asked = await settings.pushPermissionAsked();
    final granted = await push.permission(request: !asked);
    if (!asked) await settings.setPushPermissionAsked();
    if (!granted || !ref.mounted || generation != _generation) return;
    if (await push.token() case final token?) {
      await _register(token, generation);
    }
  }

  Future<void> _register(String token, int generation) async {
    if (generation != _generation) return;
    final platform = ref.read(pushServiceProvider).platform;
    if (platform == null) return;
    try {
      await ref
          .read(deviceTokenServiceProvider)
          .register(token: token, platform: platform);
    } on DeviceTokenException {
      // Sonraki açılışta ya da token yenilenince yeniden denenir.
    }
  }

  /// "Görev bildirimleri"ni açar ya da kapatır. Kapatınca bu telefonun
  /// token'ı sunucudan silinir; açarken izin gerekirse sorulur.
  Future<void> setEnabled({required bool enabled}) async {
    final settings = ref.read(localSettingsRepositoryProvider);
    if (enabled) {
      await ref.read(pushServiceProvider).permission(request: true);
      await settings.setPushPermissionAsked();
      await settings.setPushEnabled(enabled: true);
      return;
    }
    // Kapanırken yarım kalan kayıt denemeleri geçersiz olsun.
    _generation++;
    await settings.setPushEnabled(enabled: false);
    await unregister();
  }

  /// Bu telefonun token'ını sunucudan siler (kapatınca, çıkıştan önce).
  /// Hata olursa sunucu token'ı ilk başarısız gönderimde atar.
  Future<void> unregister({bool deleteDeviceToken = false}) async {
    final push = ref.read(pushServiceProvider);
    try {
      if (await push.token() case final token?) {
        await ref.read(deviceTokenServiceProvider).unregister(token);
      }
    } on DeviceTokenException {
      // Çevrimdışı; yukarıdaki gibi.
    }
    // Çıkışta token da yenilenir: sonraki kullanıcı eskisinin token'ıyla
    // bildirim almasın.
    if (deleteDeviceToken) await push.deleteToken();
  }
}

/// Bildirime dokununca görevi açar: uygulama kapalıyken ya da arka
/// plandayken. `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
void pushTaskLinks(Ref ref) {
  final push = ref.read(pushServiceProvider);
  void open(String taskId) =>
      ref.read(routerProvider).go(AppRoutes.taskEdit(taskId));

  final subscription = push.taskOpens.listen(open);
  ref.onDispose(() => unawaited(subscription.cancel()));
  unawaited(
    push.launchTaskId().then((taskId) {
      if (taskId != null && ref.mounted) open(taskId);
    }),
  );
}
