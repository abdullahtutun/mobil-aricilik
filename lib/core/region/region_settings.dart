import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/region/region_config.dart';

part 'region_settings.freezed.dart';

/// İşletme yokken (onboarding sırasında) kullanılan ülke.
const String defaultCountryCode = turkeyCountryCode;

/// Bölgenin işletmeden gelmeyen kısmı. Ülke `organizations.country_code`'dan
/// gelir; enlem ileride arılığın konumundan gelecek.
@freezed
abstract class RegionSettings with _$RegionSettings {
  const factory({
    /// Yarımküre için enlem; bilinmiyorsa null ve Kuzey sayılır.
    double? latitude,
  }) = _RegionSettings;
}
