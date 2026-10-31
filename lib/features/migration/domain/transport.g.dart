// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transport _$TransportFromJson(Map<String, dynamic> json) => _Transport(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  sourceApiaryId: json['source_apiary_id'] as String,
  destinationApiaryId: json['destination_apiary_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  vehicles:
      (json['vehicles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  status:
      $enumDecodeNullable(_$TransportStatusEnumMap, json['status']) ??
      TransportStatus.loading,
  migrationStopId: json['migration_stop_id'] as String?,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$TransportToJson(_Transport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'source_apiary_id': instance.sourceApiaryId,
      'destination_apiary_id': instance.destinationApiaryId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'vehicles': instance.vehicles,
      'status': _$TransportStatusEnumMap[instance.status]!,
      'migration_stop_id': instance.migrationStopId,
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$TransportStatusEnumMap = {
  TransportStatus.loading: 'loading',
  TransportStatus.unloading: 'unloading',
  TransportStatus.completed: 'completed',
};

_TransportItem _$TransportItemFromJson(Map<String, dynamic> json) =>
    _TransportItem(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      transportId: json['transport_id'] as String,
      hiveId: json['hive_id'] as String,
      vehicle: json['vehicle'] as String,
      loadedAt: DateTime.parse(json['loaded_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      unloadedAt: json['unloaded_at'] == null
          ? null
          : DateTime.parse(json['unloaded_at'] as String),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransportItemToJson(_TransportItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'transport_id': instance.transportId,
      'hive_id': instance.hiveId,
      'vehicle': instance.vehicle,
      'loaded_at': instance.loadedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'unloaded_at': instance.unloadedAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
