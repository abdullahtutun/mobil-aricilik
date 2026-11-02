// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_status_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HiveStatusEvent _$HiveStatusEventFromJson(Map<String, dynamic> json) =>
    _HiveStatusEvent(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      hiveId: json['hive_id'] as String,
      apiaryId: json['apiary_id'] as String,
      fromStatus: $enumDecode(_$HiveStatusEnumMap, json['from_status']),
      toStatus: $enumDecode(_$HiveStatusEnumMap, json['to_status']),
      changedAt: DateTime.parse(json['changed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lossReason: $enumDecodeNullable(
        _$HiveLossReasonEnumMap,
        json['loss_reason'],
      ),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HiveStatusEventToJson(_HiveStatusEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'hive_id': instance.hiveId,
      'apiary_id': instance.apiaryId,
      'from_status': _$HiveStatusEnumMap[instance.fromStatus]!,
      'to_status': _$HiveStatusEnumMap[instance.toStatus]!,
      'changed_at': instance.changedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'loss_reason': _$HiveLossReasonEnumMap[instance.lossReason],
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$HiveStatusEnumMap = {
  HiveStatus.active: 'active',
  HiveStatus.dead: 'dead',
  HiveStatus.merged: 'merged',
  HiveStatus.sold: 'sold',
  HiveStatus.lost: 'lost',
};

const _$HiveLossReasonEnumMap = {
  HiveLossReason.wintering: 'wintering',
  HiveLossReason.queenless: 'queenless',
  HiveLossReason.varroa: 'varroa',
  HiveLossReason.disease: 'disease',
  HiveLossReason.starvation: 'starvation',
  HiveLossReason.robbing: 'robbing',
  HiveLossReason.predator: 'predator',
  HiveLossReason.poisoning: 'poisoning',
  HiveLossReason.other: 'other',
};
