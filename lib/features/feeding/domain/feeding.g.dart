// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Feeding _$FeedingFromJson(Map<String, dynamic> json) => _Feeding(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  hiveId: json['hive_id'] as String,
  apiaryId: json['apiary_id'] as String,
  feedingGroupId: json['feeding_group_id'] as String,
  fedAt: DateTime.parse(json['fed_at'] as String),
  kind: $enumDecode(_$FeedingKindEnumMap, json['kind']),
  amount: (json['amount'] as num).toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$FeedingToJson(_Feeding instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'hive_id': instance.hiveId,
  'apiary_id': instance.apiaryId,
  'feeding_group_id': instance.feedingGroupId,
  'fed_at': instance.fedAt.toIso8601String(),
  'kind': _$FeedingKindEnumMap[instance.kind]!,
  'amount': instance.amount,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$FeedingKindEnumMap = {
  FeedingKind.syrup1to1: 'syrup_1_1',
  FeedingKind.syrup2to1: 'syrup_2_1',
  FeedingKind.beeCake: 'bee_cake',
  FeedingKind.pollenSubstitute: 'pollen_substitute',
};
