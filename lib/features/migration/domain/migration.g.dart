// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Migration _$MigrationFromJson(Map<String, dynamic> json) => _Migration(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  year: (json['year'] as num).toInt(),
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$MigrationToJson(_Migration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'year': instance.year,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

_MigrationStop _$MigrationStopFromJson(Map<String, dynamic> json) =>
    _MigrationStop(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      migrationId: json['migration_id'] as String,
      position: (json['position'] as num).toInt(),
      name: json['name'] as String,
      plannedStartOn: const DateOnlyJsonConverter().fromJson(
        json['planned_start_on'] as String,
      ),
      plannedEndOn: const DateOnlyJsonConverter().fromJson(
        json['planned_end_on'] as String,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      status:
          $enumDecodeNullable(_$MigrationStopStatusEnumMap, json['status']) ??
          MigrationStopStatus.planned,
      place: json['place'] as String?,
      apiaryId: json['apiary_id'] as String?,
      hiveCount: (json['hive_count'] as num?)?.toInt(),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MigrationStopToJson(
  _MigrationStop instance,
) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'migration_id': instance.migrationId,
  'position': instance.position,
  'name': instance.name,
  'planned_start_on': const DateOnlyJsonConverter().toJson(
    instance.plannedStartOn,
  ),
  'planned_end_on': const DateOnlyJsonConverter().toJson(instance.plannedEndOn),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'status': _$MigrationStopStatusEnumMap[instance.status]!,
  'place': instance.place,
  'apiary_id': instance.apiaryId,
  'hive_count': instance.hiveCount,
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$MigrationStopStatusEnumMap = {
  MigrationStopStatus.past: 'past',
  MigrationStopStatus.current: 'current',
  MigrationStopStatus.planned: 'planned',
};
