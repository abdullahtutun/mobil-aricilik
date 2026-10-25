// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Treatment _$TreatmentFromJson(Map<String, dynamic> json) => _Treatment(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  hiveId: json['hive_id'] as String,
  apiaryId: json['apiary_id'] as String,
  productName: json['product_name'] as String,
  activeIngredient: $enumDecode(
    _$DrugActiveIngredientEnumMap,
    json['active_ingredient'],
  ),
  dose: (json['dose'] as num).toDouble(),
  doseUnit: $enumDecode(_$DrugDoseUnitEnumMap, json['dose_unit']),
  startedAt: DateTime.parse(json['started_at'] as String),
  withdrawalDays: (json['withdrawal_days'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  refDrugId: json['ref_drug_id'] as String?,
  drugId: json['drug_id'] as String?,
  batchNo: json['batch_no'] as String?,
  plannedRemovalAt: json['planned_removal_at'] == null
      ? null
      : DateTime.parse(json['planned_removal_at'] as String),
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$TreatmentToJson(_Treatment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'hive_id': instance.hiveId,
      'apiary_id': instance.apiaryId,
      'product_name': instance.productName,
      'active_ingredient':
          _$DrugActiveIngredientEnumMap[instance.activeIngredient]!,
      'dose': instance.dose,
      'dose_unit': _$DrugDoseUnitEnumMap[instance.doseUnit]!,
      'started_at': instance.startedAt.toIso8601String(),
      'withdrawal_days': instance.withdrawalDays,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'ref_drug_id': instance.refDrugId,
      'drug_id': instance.drugId,
      'batch_no': instance.batchNo,
      'planned_removal_at': instance.plannedRemovalAt?.toIso8601String(),
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

const _$DrugActiveIngredientEnumMap = {
  DrugActiveIngredient.amitraz: 'amitraz',
  DrugActiveIngredient.oxalicAcid: 'oxalic_acid',
  DrugActiveIngredient.formicAcid: 'formic_acid',
  DrugActiveIngredient.thymol: 'thymol',
  DrugActiveIngredient.flumethrin: 'flumethrin',
  DrugActiveIngredient.tauFluvalinate: 'tau_fluvalinate',
  DrugActiveIngredient.coumaphos: 'coumaphos',
  DrugActiveIngredient.lacticAcid: 'lactic_acid',
  DrugActiveIngredient.other: 'other',
};

const _$DrugDoseUnitEnumMap = {
  DrugDoseUnit.strip: 'strip',
  DrugDoseUnit.ml: 'ml',
  DrugDoseUnit.g: 'g',
  DrugDoseUnit.dose: 'dose',
};
