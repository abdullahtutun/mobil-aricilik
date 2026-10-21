import 'package:mobil_aricilik/core/region/region_config.dart';
import 'package:mobil_aricilik/core/region/region_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'region_provider.g.dart';

/// Ülke ve enlem seçimi. Şimdilik bellekte; kalıcı kayıt ve seçici arayüz
/// ayarlar adımında gelecek. Ekranlar bunu değil [regionConfigProvider]'ı
/// dinler.
@Riverpod(keepAlive: true)
class RegionSelection extends _$RegionSelection {
  @override
  RegionSettings build() => const RegionSettings();

  /// Kod büyük harfe çevrilerek saklanır. Geçersizse [ArgumentError] atar ve
  /// seçim değişmez.
  void setCountry(String countryCode) {
    state = state.copyWith(countryCode: normalizeCountryCode(countryCode));
  }

  /// Null, enlemi bilinmiyor yapar. Enlem -90 ile 90 arasında değilse
  /// [ArgumentError] atar ve seçim değişmez.
  void setLatitude(double? latitude) {
    if (latitude != null) checkLatitude(latitude);
    state = state.copyWith(latitude: latitude);
  }
}

/// Ekranların dinlediği bölge yapılandırması. Türkiye'ye özel modüller
/// [RegionConfig.features] ile açılıp kapanır.
@Riverpod(keepAlive: true)
RegionConfig regionConfig(Ref ref) {
  final selection = ref.watch(regionSelectionProvider);
  return resolveRegionConfig(
    selection.countryCode,
    latitude: selection.latitude,
  );
}
