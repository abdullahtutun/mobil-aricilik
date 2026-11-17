import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/device_preferences.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/design_system/appearance_provider.dart';
import 'package:mobil_arici/core/design_system/appearance_settings.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  /// Uygulamanın açılışı gibi: önce geri yükler, sonra dinler.
  Future<ProviderContainer> launch() async {
    final container = ProviderContainer.test(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    await restoreDevicePreferences(container);
    persistDevicePreferences(container);
    return container;
  }

  test('ayar yokken varsayılanlarla açılır', () async {
    final container = await launch();

    expect(container.read(languageProvider), AppLanguage.system);
    expect(container.read(appearanceProvider), const AppearanceSettings());
    expect(container.read(hiveLayoutPreferenceProvider), HiveLayout.grid);
    expect(container.read(hiveSortPreferenceProvider), HiveSort.number);
  });

  test('seçimler yeniden açılışta geri gelir', () async {
    final first = await launch();
    first.read(languageProvider.notifier).language = AppLanguage.turkish;
    first.read(appearanceProvider.notifier)
      ..setColorMode(AppColorMode.sun)
      ..setGloveMode(enabled: true);
    first.read(hiveLayoutPreferenceProvider.notifier).layout = HiveLayout.list;
    first.read(hiveSortPreferenceProvider.notifier).sort =
        HiveSort.weakestFirst;
    await pumpEventQueue();
    first.dispose();

    final second = await launch();

    expect(second.read(languageProvider), AppLanguage.turkish);
    expect(
      second.read(appearanceProvider),
      const AppearanceSettings(colorMode: AppColorMode.sun, gloveMode: true),
    );
    expect(second.read(hiveLayoutPreferenceProvider), HiveLayout.list);
    expect(second.read(hiveSortPreferenceProvider), HiveSort.weakestFirst);
  });

  test('yalnız değişen görünüm alanı yazılır', () async {
    final container = await launch();
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await pumpEventQueue();

    expect(await LocalSettingsRepository(db).readAll(), {
      LocalSettingsRepository.gloveModeKey: 'true',
    });
  });

  test('tanınmayan değer atlanır, o tercih varsayılanda kalır', () {
    final prefs = decodeDevicePreferences({
      LocalSettingsRepository.languageKey: 'klingon',
      LocalSettingsRepository.colorModeKey: 'dark',
      LocalSettingsRepository.gloveModeKey: 'evet',
      LocalSettingsRepository.hiveSortKey: 'weakestFirst',
    });

    expect(prefs.language, isNull);
    expect(prefs.colorMode, AppColorMode.dark);
    expect(prefs.gloveMode, isNull);
    expect(prefs.hiveLayout, isNull);
    expect(prefs.hiveSort, HiveSort.weakestFirst);
  });

  test('tercih anahtarları çıkışta korunanlar arasında', () {
    expect(
      LocalSettingsRepository.devicePreferenceKeys,
      containsAll([
        LocalSettingsRepository.languageKey,
        LocalSettingsRepository.colorModeKey,
        LocalSettingsRepository.gloveModeKey,
        LocalSettingsRepository.hiveLayoutKey,
        LocalSettingsRepository.hiveSortKey,
      ]),
    );
    expect(
      LocalSettingsRepository.devicePreferenceKeys,
      isNot(contains(LocalSettingsRepository.lastSyncedAtKey)),
    );
  });
}
