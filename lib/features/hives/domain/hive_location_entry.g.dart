// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_location_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HiveLocationEntry _$HiveLocationEntryFromJson(Map<String, dynamic> json) =>
    _HiveLocationEntry(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      hiveId: json['hive_id'] as String,
      apiaryId: json['apiary_id'] as String,
      movedAt: DateTime.parse(json['moved_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HiveLocationEntryToJson(_HiveLocationEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'hive_id': instance.hiveId,
      'apiary_id': instance.apiaryId,
      'moved_at': instance.movedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
