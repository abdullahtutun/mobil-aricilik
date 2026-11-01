// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  dueAt: DateTime.parse(json['due_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  source:
      $enumDecodeNullable(_$TaskSourceEnumMap, json['source']) ??
      TaskSource.manual,
  title: json['title'] as String?,
  apiaryId: json['apiary_id'] as String?,
  hiveId: json['hive_id'] as String?,
  assignedTo: json['assigned_to'] as String?,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  sourceId: json['source_id'] as String?,
  refDrugId: json['ref_drug_id'] as String?,
  drugId: json['drug_id'] as String?,
  dose: (json['dose'] as num?)?.toDouble(),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'due_at': instance.dueAt.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'source': _$TaskSourceEnumMap[instance.source]!,
  'title': instance.title,
  'apiary_id': instance.apiaryId,
  'hive_id': instance.hiveId,
  'assigned_to': instance.assignedTo,
  'completed_at': instance.completedAt?.toIso8601String(),
  'source_id': instance.sourceId,
  'ref_drug_id': instance.refDrugId,
  'drug_id': instance.drugId,
  'dose': instance.dose,
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$TaskSourceEnumMap = {
  TaskSource.manual: 'manual',
  TaskSource.inspection: 'inspection',
  TaskSource.treatment: 'treatment',
};
