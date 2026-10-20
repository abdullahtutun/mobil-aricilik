import 'package:freezed_annotation/freezed_annotation.dart';

part 'appearance_settings.freezed.dart';

/// Renk modu. `system` standart açık/koyu temayı cihaza bırakır.
enum AppColorMode { system, light, dark, sun }

/// Görünüm seçimi: renk modu ve ondan bağımsız eldiven modu.
@freezed
abstract class AppearanceSettings with _$AppearanceSettings {
  const factory({
    @Default(AppColorMode.system) AppColorMode colorMode,
    @Default(false) bool gloveMode,
  }) = _AppearanceSettings;
}
