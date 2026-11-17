import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/sync/sync_service_provider.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_actions.g.dart';

/// Çıkış. Ekranın dinlemesi silme sürerken bitebilir; `keepAlive` olmazsa
/// `ref` ilk `await`'ten sonra geçersiz olur.
@Riverpod(keepAlive: true)
SignOutActions signOutActions(Ref ref) => SignOutActions(ref);

class SignOutActions {
  const new(this._ref);

  final Ref _ref;

  /// Bu telefonun bildirim kaydını siler, oturumu kapatır, süren senkron
  /// turunun bitmesini bekler ve hesabın bu telefondaki her izini siler:
  /// kayıtlar, outbox'ta bekleyenler, imleçler, foto, ses, belge ve fiş
  /// dosyaları, harita paketleri, hatırlatmalar, işletme kopyası. Aynı
  /// telefona giren sonraki kullanıcı öncekinin verisini görmez ve ilk
  /// eşitlemeyi baştan yapar. Telefonun tercihleri
  /// ([LocalSettingsRepository.devicePreferenceKeys]: dil, görünüm,
  /// Wi‑Fi, eşikler) kalır.
  ///
  /// Gönderilmemiş kayıtlar da silinir; ekran bunu önceden sorar.
  /// Temizlik elden geldiğince yapılır: bir adım başarısız olsa da
  /// diğerleri silinir ve çıkış yine olur.
  Future<void> signOut() async {
    try {
      // Oturum kapanınca sunucu çağrısı yetkisiz kalır; önce token silinir.
      await _ref
          .read(pushRegistrationProvider.notifier)
          .unregister(deleteDeviceToken: true);
    } on Object {
      // Çevrimdışı ya da push yok; çıkış yine olur.
    }
    await _ref.read(currentUserProvider.notifier).signOut();
    try {
      await _ref.read(syncServiceProvider).whenIdle();
      await _ref
          .read(deviceDataWiperProvider)
          .wipe(keepSettings: LocalSettingsRepository.devicePreferenceKeys);
    } on Object {
      // Kalan adımlar wipe içinde ayrı ayrı denendi.
    } finally {
      _ref.invalidate(installedMapAreasProvider);
    }
  }
}
