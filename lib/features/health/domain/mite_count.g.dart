// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mite_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MiteCount _$MiteCountFromJson(Map<String, dynamic> json) => _MiteCount(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  hiveId: json['hive_id'] as String,
  apiaryId: json['apiary_id'] as String,
  countedAt: DateTime.parse(json['counted_at'] as String),
  method: $enumDecode(_$MiteCountMethodEnumMap, json['method']),
  mites: (json['mites'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  sampleBees: (json['sample_bees'] as num?)?.toInt(),
  days: (json['days'] as num?)?.toInt(),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$MiteCountToJson(_MiteCount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'hive_id': instance.hiveId,
      'apiary_id': instance.apiaryId,
      'counted_at': instance.countedAt.toIso8601String(),
      'method': _$MiteCountMethodEnumMap[instance.method]!,
      'mites': instance.mites,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'sample_bees': instance.sampleBees,
      'days': instance.days,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$MiteCountMethodEnumMap = {
  MiteCountMethod.sugarRoll: 'sugar_roll',
  MiteCountMethod.alcoholWash: 'alcohol_wash',
  MiteCountMethod.stickyBoard: 'sticky_board',
};
