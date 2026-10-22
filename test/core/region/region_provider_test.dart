import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/region/region_settings.dart';

void main() {
  group('regionSelectionProvider', () {
    test('varsayılan: TR, enlem bilinmiyor', () {
      final container = ProviderContainer.test();

      expect(container.read(regionSelectionProvider), const RegionSettings());
      expect(container.read(regionSelectionProvider).countryCode, 'TR');
      expect(container.read(regionSelectionProvider).latitude, isNull);
    });

    test('ülke kodu büyük harfle saklanır', () {
      final container = ProviderContainer.test();
      container.read(regionSelectionProvider.notifier).setCountry(' de ');

      expect(container.read(regionSelectionProvider).countryCode, 'DE');
    });

    test('ülke değişince enlem korunur', () {
      final container = ProviderContainer.test();
      container.read(regionSelectionProvider.notifier)
        ..setLatitude(-33.87)
        ..setCountry('AU');

      expect(
        container.read(regionSelectionProvider),
        const RegionSettings(countryCode: 'AU', latitude: -33.87),
      );
    });

    test('enlem bilinmiyor yapılabilir', () {
      final container = ProviderContainer.test();
      container.read(regionSelectionProvider.notifier)
        ..setLatitude(41.01)
        ..setLatitude(null);

      expect(container.read(regionSelectionProvider).latitude, isNull);
    });

    test('geçersiz ülke kodu ArgumentError atar, seçim değişmez', () {
      final container = ProviderContainer.test();
      final notifier = container.read(regionSelectionProvider.notifier)
        ..setCountry('US');

      expect(() => notifier.setCountry('USA'), throwsArgumentError);
      expect(container.read(regionSelectionProvider).countryCode, 'US');
    });

    test('geçersiz enlem ArgumentError atar, seçim değişmez', () {
      final container = ProviderContainer.test();
      final notifier = container.read(regionSelectionProvider.notifier)
        ..setLatitude(10);

      expect(() => notifier.setLatitude(95), throwsArgumentError);
      expect(() => notifier.setLatitude(double.nan), throwsArgumentError);
      expect(container.read(regionSelectionProvider).latitude, 10);
    });
  });

  group('regionConfigProvider', () {
    test('varsayılan: TR profili', () {
      final container = ProviderContainer.test();

      expect(container.read(regionConfigProvider), resolveRegionConfig('TR'));
      expect(container.read(regionConfigProvider).profile, RegionProfile.tr);
    });

    test('ülke seçimini izler', () {
      final container = ProviderContainer.test();
      container.read(regionSelectionProvider.notifier).setCountry('US');

      final config = container.read(regionConfigProvider);
      expect(config, resolveRegionConfig('US'));
      expect(config.profile, RegionProfile.other);
      expect(config.features, const RegionFeatures());
      expect(config.currencyCode, 'USD');
    });

    test('enlem seçimini izler', () {
      final container = ProviderContainer.test();
      container.read(regionSelectionProvider.notifier)
        ..setCountry('NZ')
        ..setLatitude(-41.29);

      expect(
        container.read(regionConfigProvider).hemisphere,
        Hemisphere.southern,
      );

      container.read(regionSelectionProvider.notifier).setLatitude(null);

      expect(
        container.read(regionConfigProvider).hemisphere,
        Hemisphere.northern,
      );
    });

    test("TR'ye dönülünce TR modülleri yeniden açılır", () {
      final container = ProviderContainer.test();
      final notifier = container.read(regionSelectionProvider.notifier)
        ..setCountry('GB');

      expect(container.read(regionConfigProvider).features.aks, isFalse);

      notifier.setCountry('TR');

      expect(container.read(regionConfigProvider).features.aks, isTrue);
      expect(container.read(regionConfigProvider).currencyCode, 'TRY');
    });

    test('yapılandırma değişmezse dinleyenler uyarılmaz', () async {
      final container = ProviderContainer.test();
      final configs = <RegionConfig>[];
      container.listen(regionConfigProvider, (_, next) => configs.add(next));
      final notifier = container.read(regionSelectionProvider.notifier);

      // Bağımlı provider bir sonraki pump'ta yeniden kurulur; her seçimi ayrı
      // uygula ki ara durumlar birleşmesin.
      Future<void> select(void Function() change) {
        change();
        return container.pump();
      }

      // Aynı ülke, farklı yazım.
      await select(() => notifier.setCountry('tr'));
      // TR'de enlem yarımküreyi değiştirmez.
      await select(() => notifier.setLatitude(39.93));

      expect(configs, isEmpty);

      await select(() => notifier.setCountry('AU'));
      await select(() => notifier.setLatitude(-33.87));
      // Aynı yarımkürede başka bir arılık.
      await select(() => notifier.setLatitude(-37.81));

      expect(configs, [
        resolveRegionConfig('AU', latitude: 39.93),
        resolveRegionConfig('AU', latitude: -33.87),
      ]);
    });
  });
}
