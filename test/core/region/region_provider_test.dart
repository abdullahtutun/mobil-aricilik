import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/region/region_settings.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_organization_service.dart';

/// [countryCode] ülkesinde işletmesi olan kullanıcıyla container açar ve
/// işletmenin yüklenmesini bekler.
Future<ProviderContainer> _containerWith({
  required String countryCode,
  FakeAuthService? auth,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      authServiceProvider.overrideWithValue(
        auth ?? FakeAuthService(user: testUser),
      ),
      ...organizationOverrides(
        service: FakeOrganizationService(
          serverOrganization: testOrganization.copyWith(
            countryCode: countryCode,
          ),
        ),
      ),
    ],
  );
  await container.read(currentOrganizationProvider.future);
  return container;
}

void main() {
  group('regionSelectionProvider', () {
    test('varsayılan: enlem bilinmiyor', () {
      final container = ProviderContainer.test();

      expect(container.read(regionSelectionProvider), const RegionSettings());
      expect(container.read(regionSelectionProvider).latitude, isNull);
    });

    test('enlem bilinmiyor yapılabilir', () {
      final container = ProviderContainer.test();
      container.read(regionSelectionProvider.notifier)
        ..setLatitude(41.01)
        ..setLatitude(null);

      expect(container.read(regionSelectionProvider).latitude, isNull);
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
    test('ülke işletmeden gelir', () async {
      final container = await _containerWith(countryCode: 'US');

      final config = container.read(regionConfigProvider);
      expect(config, resolveRegionConfig('US'));
      expect(config.profile, RegionProfile.other);
      expect(config.features, const RegionFeatures());
      expect(config.currencyCode, 'USD');
    });

    test('TR işletmesinde TR modülleri açık', () async {
      final container = await _containerWith(countryCode: 'TR');

      final config = container.read(regionConfigProvider);
      expect(config.profile, RegionProfile.tr);
      expect(config.features.aks, isTrue);
      expect(config.currencyCode, 'TRY');
    });

    test('işletme yokken varsayılan ülke kullanılır', () async {
      final container = ProviderContainer.test(
        overrides: [
          authServiceProvider.overrideWithValue(FakeAuthService()),
          ...organizationOverrides(),
        ],
      );
      await container.read(currentOrganizationProvider.future);

      expect(
        container.read(regionConfigProvider),
        resolveRegionConfig(defaultCountryCode),
      );
    });

    test('çıkış yapılınca varsayılan ülkeye dönülür', () async {
      final auth = FakeAuthService(user: testUser);
      final container = await _containerWith(countryCode: 'DE', auth: auth);
      final configs = <RegionConfig>[];
      container.listen(regionConfigProvider, (_, next) => configs.add(next));

      // Oturum olayı akıştan bir sonraki turda gelir.
      auth.emit(null);
      await Future<void>.delayed(Duration.zero);
      expect(await container.read(currentOrganizationProvider.future), isNull);
      await container.pump();

      expect(configs, [resolveRegionConfig(defaultCountryCode)]);
    });

    test('enlem seçimini izler', () async {
      final container = await _containerWith(countryCode: 'NZ');
      container.read(regionSelectionProvider.notifier).setLatitude(-41.29);

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

    test('yapılandırma değişmezse dinleyenler uyarılmaz', () async {
      final container = await _containerWith(countryCode: 'TR');
      final configs = <RegionConfig>[];
      container.listen(regionConfigProvider, (_, next) => configs.add(next));
      final notifier = container.read(regionSelectionProvider.notifier);

      // Bağımlı provider bir sonraki pump'ta yeniden kurulur; her seçimi ayrı
      // uygula ki ara durumlar birleşmesin.
      Future<void> select(void Function() change) {
        change();
        return container.pump();
      }

      // TR'de enlem yarımküreyi değiştirmez.
      await select(() => notifier.setLatitude(-33.87));
      // İşletmenin adı değişse de ülke aynı.
      await select(
        () => container.read(currentOrganizationProvider.notifier).state =
            AsyncData(testOrganization.copyWith(name: 'Yeni ad')),
      );

      expect(configs, isEmpty);
    });
  });
}
