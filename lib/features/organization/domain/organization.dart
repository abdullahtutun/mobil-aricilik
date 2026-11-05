import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

/// "Kaç kovanın var?" cevabı. Yalnız tercihtir, kovan oluşturmaz; takip
/// önerisi (kovan bazlı ya da grup bazlı) buna göre yapılır.
@JsonEnum(valueField: 'value')
enum HiveCountRange implements ServerEnum {
  none('none'),
  upTo10('up_to_10'),
  upTo50('up_to_50'),
  upTo200('up_to_200'),
  over200('over_200');

  new(this.value);

  /// `public.hive_count_range` enum değeri.
  @override
  final String value;
}

/// İşletmenin türü (`public.operation_type`). Tek kaynak: sabit işletmede
/// gezginci modülleri (göç planı, taşıma) gizlenir, kayıtları silinmez
/// (`BusinessConfig`).
@JsonEnum(valueField: 'value')
enum OperationType implements ServerEnum {
  migratory('migratory'),
  stationary('stationary');

  new(this.value);

  @override
  final String value;
}

/// Logo yokken işletmenin baş harflerinin zemini
/// (`public.org_avatar_color`). Renk tasarım sistemindeki `AppColors`'tan
/// gelir.
@JsonEnum(valueField: 'value')
enum OrgAvatarColor implements ServerEnum {
  pine('pine'),
  honey('honey'),
  sky('sky'),
  slate('slate');

  new(this.value);

  @override
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

    /// Eski önbellekte yok; o zaman gezginci (sunucunun varsayılanı).
    @Default(OperationType.migratory) OperationType operationType,
  }) = _Organization;

  factory fromJson(Map<String, Object?> json) => _$OrganizationFromJson(json);
}
