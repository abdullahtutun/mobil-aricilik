// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lot _$LotFromJson(Map<String, dynamic> json) => _Lot(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  year: (json['year'] as num).toInt(),
  seq: (json['seq'] as num).toInt(),
  honeyKind: $enumDecode(_$HoneyKindEnumMap, json['honey_kind']),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  status:
      $enumDecodeNullable(_$LotStatusEnumMap, json['status']) ?? LotStatus.open,
  origin: json['origin'] as String?,
  moisture: (json['moisture'] as num?)?.toDouble(),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$LotToJson(_Lot instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'year': instance.year,
  'seq': instance.seq,
  'honey_kind': _$HoneyKindEnumMap[instance.honeyKind]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'status': _$LotStatusEnumMap[instance.status]!,
  'origin': instance.origin,
  'moisture': instance.moisture,
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

const _$LotStatusEnumMap = {LotStatus.open: 'open', LotStatus.closed: 'closed'};

_LotHarvest _$LotHarvestFromJson(Map<String, dynamic> json) => _LotHarvest(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  lotId: json['lot_id'] as String,
  harvestId: json['harvest_id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$LotHarvestToJson(_LotHarvest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'lot_id': instance.lotId,
      'harvest_id': instance.harvestId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

_LotTreatment _$LotTreatmentFromJson(Map<String, dynamic> json) =>
    _LotTreatment(
      id: json['id'] as String,
      orgId: json['org_id'] as String,
      lotId: json['lot_id'] as String,
      harvestId: json['harvest_id'] as String,
      hiveId: json['hive_id'] as String,
      treatmentId: json['treatment_id'] as String,
      treatedAt: DateTime.parse(json['treated_at'] as String),
      withdrawalEndsOn: const DateOnlyJsonConverter().fromJson(
        json['withdrawal_ends_on'] as String,
      ),
      withdrawalViolation: json['withdrawal_violation'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      createdBy: json['created_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      serverSeq: (json['server_seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LotTreatmentToJson(_LotTreatment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'lot_id': instance.lotId,
      'harvest_id': instance.harvestId,
      'hive_id': instance.hiveId,
      'treatment_id': instance.treatmentId,
      'treated_at': instance.treatedAt.toIso8601String(),
      'withdrawal_ends_on': const DateOnlyJsonConverter().toJson(
        instance.withdrawalEndsOn,
      ),
      'withdrawal_violation': instance.withdrawalViolation,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

_LabResult _$LabResultFromJson(Map<String, dynamic> json) => _LabResult(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  lotId: json['lot_id'] as String,
  testedOn: const DateOnlyJsonConverter().fromJson(json['tested_on'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  hmf: (json['hmf'] as num?)?.toDouble(),
  diastase: (json['diastase'] as num?)?.toDouble(),
  proline: (json['proline'] as num?)?.toDouble(),
  moisture: (json['moisture'] as num?)?.toDouble(),
  residue: $enumDecodeNullable(_$ResidueResultEnumMap, json['residue']),
  documentId: json['document_id'] as String?,
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$LabResultToJson(_LabResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'lot_id': instance.lotId,
      'tested_on': const DateOnlyJsonConverter().toJson(instance.testedOn),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'hmf': instance.hmf,
      'diastase': instance.diastase,
      'proline': instance.proline,
      'moisture': instance.moisture,
      'residue': _$ResidueResultEnumMap[instance.residue],
      'document_id': instance.documentId,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$ResidueResultEnumMap = {
  ResidueResult.none: 'none',
  ResidueResult.detected: 'detected',
};

_LotSale _$LotSaleFromJson(Map<String, dynamic> json) => _LotSale(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  lotId: json['lot_id'] as String,
  soldOn: const DateOnlyJsonConverter().fromJson(json['sold_on'] as String),
  kg: (json['kg'] as num).toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$LotSaleToJson(_LotSale instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'lot_id': instance.lotId,
  'sold_on': const DateOnlyJsonConverter().toJson(instance.soldOn),
  'kg': instance.kg,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};
