// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportPeriod _$SupportPeriodFromJson(Map<String, dynamic> json) =>
    _SupportPeriod(
      id: json['id'] as String,
      name: json['name'] as String,
      applicationStartsOn: const DateOnlyJsonConverter().fromJson(
        json['application_starts_on'] as String,
      ),
      applicationEndsOn: const DateOnlyJsonConverter().fromJson(
        json['application_ends_on'] as String,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      description: json['description'] as String?,
      sourceUrl: json['source_url'] as String?,
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SupportPeriodToJson(_SupportPeriod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'application_starts_on': const DateOnlyJsonConverter().toJson(
        instance.applicationStartsOn,
      ),
      'application_ends_on': const DateOnlyJsonConverter().toJson(
        instance.applicationEndsOn,
      ),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'source_url': instance.sourceUrl,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
