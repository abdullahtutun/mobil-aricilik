import 'package:json_annotation/json_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';

/// Üyenin işletmedeki rolü (`public.membership_role`). Owner, partner ve
/// worker yazar; viewer yalnız okur.
@JsonEnum(valueField: 'value')
enum MembershipRole implements ServerEnum {
  owner('owner'),
  partner('partner'),
  worker('worker'),
  viewer('viewer');

  new(this.value);

  @override
  final String value;
}
