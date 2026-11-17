import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/design_system/appearance_provider.dart';
import 'package:mobil_arici/core/design_system/appearance_settings.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';

// Arayüz tercihlerinin (dil, renk modu, eldiven modu, kovan görünümü ve
// sırası) bu telefondaki kalıcı kaydı. Tercih provider'ları bellekte
// çalışır; açılışta restoreDevicePreferences yerel DB'deki değerleri onlara
// yazar, persistDevicePreferences sonraki her değişikliği `local_settings`'e
// yazar. Böylece provider'lar ve testleri DB'ye bağlı kalmaz, kayıt tek
// yerde.

/// Kayıtlı tercihleri provider'lara yazar. İlk kareden önce çağrılır ki
/// uygulama doğru dil ve temayla açılsın. Okunamayan ya da tanınmayan
/// değer (eski sürüm, bozuk yazma) atlanır, o tercih varsayılanda kalır.
Future<void> restoreDevicePreferences(ProviderContainer container) async {
  final Map<String, String> stored;
  try {
    stored = await container.read(localSettingsRepositoryProvider).readAll();
  } on Object {
    return;
  }
  final prefs = decodeDevicePreferences(stored);
  if (prefs.language case final language?) {
    container.read(languageProvider.notifier).language = language;
  }
  final appearance = container.read(appearanceProvider.notifier);
  if (prefs.colorMode case final mode?) appearance.setColorMode(mode);
  if (prefs.gloveMode case final enabled?) {
    appearance.setGloveMode(enabled: enabled);
  }
  if (prefs.hiveLayout case final layout?) {
    container.read(hiveLayoutPreferenceProvider.notifier).layout = layout;
  }
  if (prefs.hiveSort case final sort?) {
    container.read(hiveSortPreferenceProvider.notifier).sort = sort;
  }
}

/// Tercihler değişince yerel DB'ye yazar; uygulama açık kaldıkça dinler.
/// Yazma hatası (disk dolu) arayüzü bozmaz, tercih bu oturumda geçerli
/// kalır.
void persistDevicePreferences(ProviderContainer container) {
  final settings = container.read(localSettingsRepositoryProvider);
  void save(String key, String value) {
    settings.writeValue(key, value).ignore();
  }

  container
    ..listen(languageProvider, (_, language) {
      save(LocalSettingsRepository.languageKey, language.name);
    })
    ..listen(appearanceProvider, (previous, next) {
      if (previous?.colorMode != next.colorMode) {
        save(LocalSettingsRepository.colorModeKey, next.colorMode.name);
      }
      if (previous?.gloveMode != next.gloveMode) {
        save(LocalSettingsRepository.gloveModeKey, '${next.gloveMode}');
      }
    })
    ..listen(hiveLayoutPreferenceProvider, (_, layout) {
      save(LocalSettingsRepository.hiveLayoutKey, layout.name);
    })
    ..listen(hiveSortPreferenceProvider, (_, sort) {
      save(LocalSettingsRepository.hiveSortKey, sort.name);
    });
}

/// `local_settings`'ten okunan tercihler; null olan kayıtlı değil ya da
/// tanınmıyor.
typedef DevicePreferences = ({
  AppLanguage? language,
  AppColorMode? colorMode,
  bool? gloveMode,
  HiveLayout? hiveLayout,
  HiveSort? hiveSort,
});

/// [stored] (`local_settings` anahtar → değer) içinden tercihler.
DevicePreferences decodeDevicePreferences(Map<String, String> stored) => (
  language: _byName(
    AppLanguage.values,
    stored[LocalSettingsRepository.languageKey],
  ),
  colorMode: _byName(
    AppColorMode.values,
    stored[LocalSettingsRepository.colorModeKey],
  ),
  gloveMode: switch (stored[LocalSettingsRepository.gloveModeKey]) {
    'true' => true,
    'false' => false,
    _ => null,
  },
  hiveLayout: _byName(
    HiveLayout.values,
    stored[LocalSettingsRepository.hiveLayoutKey],
  ),
  hiveSort: _byName(
    HiveSort.values,
    stored[LocalSettingsRepository.hiveSortKey],
  ),
);

T? _byName<T extends Enum>(List<T> values, String? name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
