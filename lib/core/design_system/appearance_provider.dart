import 'package:mobil_arici/core/design_system/appearance_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appearance_provider.g.dart';

/// Görünüm seçimi. Bellekte tutulur; açılışta yerel DB'den geri yüklenir ve
/// her değişiklik oraya yazılır (`app/device_preferences.dart`).
@Riverpod(keepAlive: true)
class Appearance extends _$Appearance {
  @override
  AppearanceSettings build() => const AppearanceSettings();

  void setColorMode(AppColorMode mode) {
    state = state.copyWith(colorMode: mode);
  }

  void setGloveMode({required bool enabled}) {
    state = state.copyWith(gloveMode: enabled);
  }
}
