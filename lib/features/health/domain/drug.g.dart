// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RefDrug _$RefDrugFromJson(Map<String, dynamic> json) => _RefDrug(
  id: json['id'] as String,
  countryCode: json['country_code'] as String,
  nameTr: json['name_tr'] as String,
  nameEn: json['name_en'] as String,
  activeIngredient: $enumDecode(
    _$DrugActiveIngredientEnumMap,
    json['active_ingredient'],
  ),
  doseUnit: $enumDecode(_$DrugDoseUnitEnumMap, json['dose_unit']),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  withdrawalDays: (json['withdrawal_days'] as num?)?.toInt(),
  licenseNo: json['license_no'] as String?,
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$RefDrugToJson(_RefDrug instance) => <String, dynamic>{
  'id': instance.id,
  'country_code': instance.countryCode,
  'name_tr': instance.nameTr,
  'name_en': instance.nameEn,
  'active_ingredient':
      _$DrugActiveIngredientEnumMap[instance.activeIngredient]!,
  'dose_unit': _$DrugDoseUnitEnumMap[instance.doseUnit]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'withdrawal_days': instance.withdrawalDays,
  'license_no': instance.licenseNo,
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

_Drug _$DrugFromJson(Map<String, dynamic> json) => _Drug(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  name: json['name'] as String,
  activeIngredient: $enumDecode(
    _$DrugActiveIngredientEnumMap,
    json['active_ingredient'],
  ),
  doseUnit: $enumDecode(_$DrugDoseUnitEnumMap, json['dose_unit']),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  withdrawalDays: (json['withdrawal_days'] as num?)?.toInt(),
  licenseNo: json['license_no'] as String?,
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$DrugToJson(_Drug instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'name': instance.name,
  'active_ingredient':
      _$DrugActiveIngredientEnumMap[instance.activeIngredient]!,
  'dose_unit': _$DrugDoseUnitEnumMap[instance.doseUnit]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'withdrawal_days': instance.withdrawalDays,
  'license_no': instance.licenseNo,
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};
