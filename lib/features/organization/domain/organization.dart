import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

/// "Kaç kovanın var?" cevabı. Yalnız tercihtir, kovan oluşturmaz; takip
/// önerisi (kovan bazlı ya da grup bazlı) buna göre yapılır.
@JsonEnum(valueField: 'value')
enum HiveCountRange {
  none('none'),
  upTo10('up_to_10'),
  upTo50('up_to_50'),
  upTo200('up_to_200'),
  over200('over_200');

  new(this.value);

  /// `public.hive_count_range` enum değeri.
  final String value;
}

/// Kullanıcının işletmesi (`organizations`). Bölge profili ülkeyi buradan
/// alır.
@freezed
abstract class Organization with _$Organization {
  const factory({
    /// İstemcide üretilen UUIDv7.
    required String id,
    required String name,

    /// ISO 3166-1 alpha-2, büyük harf.
    required String countryCode,

    /// ISO 4217.
    required String currency,
    HiveCountRange? hiveCountRange,
  }) = _Organization;

  factory fromJson(Map<String, Object?> json) => _$OrganizationFromJson(json);
}
