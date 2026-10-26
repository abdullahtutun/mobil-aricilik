// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiary_tour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiaryTour _$ApiaryTourFromJson(Map<String, dynamic> json) => _ApiaryTour(
  orgId: json['org_id'] as String,
  apiaryId: json['apiary_id'] as String,
  startedAt: DateTime.parse(json['started_at'] as String),
  hiveIds: (json['hive_ids'] as List<dynamic>).map((e) => e as String).toList(),
  inspections:
      (json['inspections'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  skipped:
      (json['skipped'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  finishedAt: json['finished_at'] == null
      ? null
      : DateTime.parse(json['finished_at'] as String),
);

Map<String, dynamic> _$ApiaryTourToJson(_ApiaryTour instance) =>
    <String, dynamic>{
      'org_id': instance.orgId,
      'apiary_id': instance.apiaryId,
      'started_at': instance.startedAt.toIso8601String(),
      'hive_ids': instance.hiveIds,
      'inspections': instance.inspections,
      'skipped': instance.skipped,
      'finished_at': instance.finishedAt?.toIso8601String(),
    };
