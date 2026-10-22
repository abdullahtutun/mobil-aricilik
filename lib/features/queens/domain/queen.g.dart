// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Queen _$QueenFromJson(Map<String, dynamic> json) => _Queen(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  year: (json['year'] as num?)?.toInt(),
  markColor: $enumDecodeNullable(_$QueenMarkColorEnumMap, json['mark_color']),
  breed: json['breed'] as String?,
  breedLine: json['breed_line'] as String?,
  source: $enumDecodeNullable(_$QueenSourceEnumMap, json['source']),
  matingStatus: $enumDecodeNullable(
    _$QueenMatingStatusEnumMap,
    json['mating_status'],
  ),
  wingClipped: json['wing_clipped'] as bool? ?? false,
  motherQueenId: json['mother_queen_id'] as String?,
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$QueenToJson(_Queen instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'year': instance.year,
  'mark_color': _$QueenMarkColorEnumMap[instance.markColor],
  'breed': instance.breed,
  'breed_line': instance.breedLine,
  'source': _$QueenSourceEnumMap[instance.source],
  'mating_status': _$QueenMatingStatusEnumMap[instance.matingStatus],
  'wing_clipped': instance.wingClipped,
  'mother_queen_id': instance.motherQueenId,
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$QueenMarkColorEnumMap = {
  QueenMarkColor.white: 'white',
  QueenMarkColor.yellow: 'yellow',
  QueenMarkColor.red: 'red',
  QueenMarkColor.green: 'green',
  QueenMarkColor.blue: 'blue',
};

const _$QueenSourceEnumMap = {
  QueenSource.ownRearing: 'own_rearing',
  QueenSource.purchased: 'purchased',
  QueenSource.certifiedBreeder: 'certified_breeder',
};

const _$QueenMatingStatusEnumMap = {
  QueenMatingStatus.virgin: 'virgin',
  QueenMatingStatus.mated: 'mated',
};
