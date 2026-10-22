import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setup_in_progress.g.dart';

/// İşletme bu oturumda onboarding'de kuruluyor ya da kuruldu ve kurulumun
/// yerel adımı (ilk arılık) henüz bitmedi. Bu sürede router onboarding'de
/// tutar; işletme kurulunca Bugün yerine ilk arılık adımı açılır.
///
/// Yalnız bellekte: uygulama bu adımda kapanırsa yeniden açılışta Bugün
/// gelir, arılık Arılıklar sekmesinden eklenir. Çıkışta sıfırlanır.
@Riverpod(keepAlive: true)
class SetupInProgress extends _$SetupInProgress {
  @override
  bool build() {
    ref.watch(currentUserProvider.select((user) => user?.id));
    return false;
  }

  void start() => state = true;

  void finish() => state = false;
}
