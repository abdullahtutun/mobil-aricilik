// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queen_rearing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QueenRearingBatch _$QueenRearingBatchFromJson(Map<String, dynamic> json) =>
    _QueenRearingBatch(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      number: (json['number'] as num).toInt(),
      graftedOn: const DateOnlyJsonConverter().fromJson(
        json['grafted_on'] as String,
      ),
      graftedCount: (json['grafted_count'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      motherQueenId: json['mother_queen_id'] as String?,
      acceptedCount: (json['accepted_count'] as num?)?.toInt(),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QueenRearingBatchToJson(_QueenRearingBatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'number': instance.number,
      'grafted_on': const DateOnlyJsonConverter().toJson(instance.graftedOn),
      'grafted_count': instance.graftedCount,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'mother_queen_id': instance.motherQueenId,
      'accepted_count': instance.acceptedCount,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

_MatingNuc _$MatingNucFromJson(Map<String, dynamic> json) => _MatingNuc(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  number: json['number'] as String,
  apiaryId: json['apiary_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  status:
      $enumDecodeNullable(_$MatingNucStatusEnumMap, json['status']) ??
      MatingNucStatus.empty,
  rearingBatchId: json['rearing_batch_id'] as String?,
  queenId: json['queen_id'] as String?,
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$MatingNucToJson(_MatingNuc instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'number': instance.number,
      'apiary_id': instance.apiaryId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'status': _$MatingNucStatusEnumMap[instance.status]!,
      'rearing_batch_id': instance.rearingBatchId,
      'queen_id': instance.queenId,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$MatingNucStatusEnumMap = {
  MatingNucStatus.empty: 'empty',
  MatingNucStatus.cell: 'cell',
  MatingNucStatus.virgin: 'virgin',
  MatingNucStatus.laying: 'laying',
  MatingNucStatus.failed: 'failed',
  MatingNucStatus.given: 'given',
};
