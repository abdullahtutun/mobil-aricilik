import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/design_system/appearance_provider.dart';
import 'package:mobil_arici/core/design_system/appearance_settings.dart';

void main() {
  group('appearanceProvider', () {
    test('varsayılan: sisteme uyan standart tema, eldiven kapalı', () {
      final container = ProviderContainer.test();

      expect(container.read(appearanceProvider), const AppearanceSettings());
      expect(container.read(appearanceProvider).colorMode, AppColorMode.system);
      expect(container.read(appearanceProvider).gloveMode, isFalse);
    });

    test('renk modu değişince eldiven seçimi korunur', () {
      final container = ProviderContainer.test();
      container.read(appearanceProvider.notifier)
        ..setGloveMode(enabled: true)
        ..setColorMode(AppColorMode.sun);

      expect(
        container.read(appearanceProvider),
        const AppearanceSettings(colorMode: AppColorMode.sun, gloveMode: true),
      );
    });

    test('eldiven modu kapatılabilir', () {
      final container = ProviderContainer.test();
      container.read(appearanceProvider.notifier)
        ..setGloveMode(enabled: true)
        ..setGloveMode(enabled: false);

      expect(container.read(appearanceProvider).gloveMode, isFalse);
    });
  });
}
