// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaCapture _$MediaCaptureFromJson(Map<String, dynamic> json) =>
    _MediaCapture(
      fileName: json['file_name'] as String,
      kind: $enumDecode(_$MediaKindEnumMap, json['kind']),
      capturedAt: DateTime.parse(json['captured_at'] as String),
      byteSize: (json['byte_size'] as num).toInt(),
      durationMs: (json['duration_ms'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MediaCaptureToJson(_MediaCapture instance) =>
    <String, dynamic>{
      'file_name': instance.fileName,
      'kind': _$MediaKindEnumMap[instance.kind]!,
      'captured_at': instance.capturedAt.toIso8601String(),
      'byte_size': instance.byteSize,
      'duration_ms': instance.durationMs,
    };

const _$MediaKindEnumMap = {MediaKind.photo: 'photo', MediaKind.audio: 'audio'};

_MediaItem _$MediaItemFromJson(Map<String, dynamic> json) => _MediaItem(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  hiveId: json['hive_id'] as String,
  kind: $enumDecode(_$MediaKindEnumMap, json['kind']),
  storagePath: json['storage_path'] as String,
  capturedAt: DateTime.parse(json['captured_at'] as String),
  byteSize: (json['byte_size'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  inspectionId: json['inspection_id'] as String?,
  durationMs: (json['duration_ms'] as num?)?.toInt(),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$MediaItemToJson(_MediaItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'hive_id': instance.hiveId,
      'kind': _$MediaKindEnumMap[instance.kind]!,
      'storage_path': instance.storagePath,
      'captured_at': instance.capturedAt.toIso8601String(),
      'byte_size': instance.byteSize,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'inspection_id': instance.inspectionId,
      'duration_ms': instance.durationMs,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
