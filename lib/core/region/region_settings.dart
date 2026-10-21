import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_aricilik/core/region/region_config.dart';

part 'region_settings.freezed.dart';

/// Ülke seçilmemişken kullanılan ülke.
const String defaultCountryCode = turkeyCountryCode;

/// Bölge seçimi. Şimdilik ayarlardan elle seçilir; ileride ülke
/// `organizations.country_code`'dan, enlem arılığın konumundan gelecek.
@freezed
abstract class RegionSettings with _$RegionSettings {
  const factory({
    /// ISO 3166-1 alpha-2, büyük harf.
    @Default(defaultCountryCode) String countryCode,

    /// Yarımküre için enlem; bilinmiyorsa null ve Kuzey sayılır.
    double? latitude,
  }) = _RegionSettings;
}
