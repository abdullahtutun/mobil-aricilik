// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Harvest _$HarvestFromJson(Map<String, dynamic> json) => _Harvest(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  apiaryId: json['apiary_id'] as String,
  harvestedAt: DateTime.parse(json['harvested_at'] as String),
  honeyKind: $enumDecode(_$HoneyKindEnumMap, json['honey_kind']),
  unit: $enumDecode(_$HarvestUnitEnumMap, json['unit']),
  unitCount: (json['unit_count'] as num).toInt(),
  netKg: (json['net_kg'] as num).toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$HarvestToJson(_Harvest instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'apiary_id': instance.apiaryId,
  'harvested_at': instance.harvestedAt.toIso8601String(),
  'honey_kind': _$HoneyKindEnumMap[instance.honeyKind]!,
  'unit': _$HarvestUnitEnumMap[instance.unit]!,
  'unit_count': instance.unitCount,
  'net_kg': instance.netKg,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$HoneyKindEnumMap = {
  HoneyKind.pine: 'pine',
  HoneyKind.flower: 'flower',
  HoneyKind.chestnut: 'chestnut',
  HoneyKind.citrus: 'citrus',
  HoneyKind.other: 'other',
};

const _$HarvestUnitEnumMap = {
  HarvestUnit.superBox: 'super',
  HarvestUnit.frame: 'frame',
};

_HarvestHive _$HarvestHiveFromJson(Map<String, dynamic> json) => _HarvestHive(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  harvestId: json['harvest_id'] as String,
  hiveId: json['hive_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  withdrawalTreatmentId: json['withdrawal_treatment_id'] as String?,
  withdrawalOverrideReason: $enumDecodeNullable(
    _$WithdrawalOverrideReasonEnumMap,
    json['withdrawal_override_reason'],
  ),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$HarvestHiveToJson(_HarvestHive instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'harvest_id': instance.harvestId,
      'hive_id': instance.hiveId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'withdrawal_treatment_id': instance.withdrawalTreatmentId,
      'withdrawal_override_reason':
          _$WithdrawalOverrideReasonEnumMap[instance.withdrawalOverrideReason],
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$WithdrawalOverrideReasonEnumMap = {
  WithdrawalOverrideReason.removedEarly: 'removed_early',
  WithdrawalOverrideReason.notForSale: 'not_for_sale',
};
