// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Hive _$HiveFromJson(Map<String, dynamic> json) => _Hive(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  number: json['number'] as String,
  type: $enumDecode(_$HiveTypeEnumMap, json['type']),
  apiaryId: json['apiary_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  status:
      $enumDecodeNullable(_$HiveStatusEnumMap, json['status']) ??
      HiveStatus.active,
  tagCode: json['tag_code'] as String?,
  queenId: json['queen_id'] as String?,
  boxCount: (json['box_count'] as num?)?.toInt() ?? 1,
  frameCount: (json['frame_count'] as num?)?.toInt(),
  source: $enumDecodeNullable(_$HiveSourceEnumMap, json['source']),
  marking: json['marking'] as String?,
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$HiveToJson(_Hive instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'number': instance.number,
  'type': _$HiveTypeEnumMap[instance.type]!,
  'apiary_id': instance.apiaryId,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'status': _$HiveStatusEnumMap[instance.status]!,
  'tag_code': instance.tagCode,
  'queen_id': instance.queenId,
  'box_count': instance.boxCount,
  'frame_count': instance.frameCount,
  'source': _$HiveSourceEnumMap[instance.source],
  'marking': instance.marking,
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$HiveTypeEnumMap = {
  HiveType.langstroth: 'langstroth',
  HiveType.dadant: 'dadant',
  HiveType.local: 'local',
  HiveType.other: 'other',
};

const _$HiveStatusEnumMap = {
  HiveStatus.active: 'active',
  HiveStatus.dead: 'dead',
  HiveStatus.merged: 'merged',
  HiveStatus.sold: 'sold',
  HiveStatus.lost: 'lost',
};

const _$HiveSourceEnumMap = {
  HiveSource.swarm: 'swarm',
  HiveSource.split: 'split',
  HiveSource.purchase: 'purchase',
  HiveSource.package: 'package',
};
