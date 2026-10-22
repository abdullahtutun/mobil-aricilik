import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_settings.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'region_provider.g.dart';

/// Enlem seçimi. Şimdilik bellekte; ileride arılığın konumundan gelecek.
/// Ekranlar bunu değil [regionConfigProvider]'ı dinler.
@Riverpod(keepAlive: true)
class RegionSelection extends _$RegionSelection {
  @override
  RegionSettings build() => const RegionSettings();

  /// Null, enlemi bilinmiyor yapar. Enlem -90 ile 90 arasında değilse
  /// [ArgumentError] atar ve seçim değişmez.
  void setLatitude(double? latitude) {
    if (latitude != null) checkLatitude(latitude);
    state = state.copyWith(latitude: latitude);
  }
}

/// Ekranların dinlediği bölge yapılandırması. Ülke işletmeden gelir; işletme
/// yokken [defaultCountryCode] kullanılır. Türkiye'ye özel modüller
/// [RegionConfig.features] ile açılıp kapanır.
@Riverpod(keepAlive: true)
RegionConfig regionConfig(Ref ref) {
  final countryCode = ref.watch(
    currentOrganizationProvider.select(
      (organization) => organization.value?.countryCode,
    ),
  );
  final selection = ref.watch(regionSelectionProvider);
  return resolveRegionConfig(
    countryCode ?? defaultCountryCode,
    latitude: selection.latitude,
  );
}
