// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Organization _$OrganizationFromJson(Map<String, dynamic> json) =>
    _Organization(
      id: json['id'] as String,
      name: json['name'] as String,
      countryCode: json['country_code'] as String,
      currency: json['currency'] as String,
      hiveCountRange: $enumDecodeNullable(
        _$HiveCountRangeEnumMap,
        json['hive_count_range'],
      ),
    );

Map<String, dynamic> _$OrganizationToJson(_Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country_code': instance.countryCode,
      'currency': instance.currency,
      'hive_count_range': _$HiveCountRangeEnumMap[instance.hiveCountRange],
    };

const _$HiveCountRangeEnumMap = {
  HiveCountRange.none: 'none',
  HiveCountRange.upTo10: 'up_to_10',
  HiveCountRange.upTo50: 'up_to_50',
  HiveCountRange.upTo200: 'up_to_200',
  HiveCountRange.over200: 'over_200',
};
