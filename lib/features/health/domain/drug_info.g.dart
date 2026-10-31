// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DrugInfo _$DrugInfoFromJson(Map<String, dynamic> json) => _DrugInfo(
  refDrugId: json['ref_drug_id'] as String,
  name: json['ilac_adi'] as String,
  activeIngredient: json['etken_madde'] as String,
  indications: json['endikasyonlar'] as String,
  usage: Map<String, String>.from(json['kullanimi_ve_sikligi'] as Map),
  periods: DrugInfoPeriods.fromJson(
    json['uygulandigi_donem'] as Map<String, dynamic>,
  ),
  residue: DrugInfoResidue.fromJson(
    json['kalinti_bilgisi_ikas'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$DrugInfoToJson(_DrugInfo instance) => <String, dynamic>{
  'ref_drug_id': instance.refDrugId,
  'ilac_adi': instance.name,
  'etken_madde': instance.activeIngredient,
  'endikasyonlar': instance.indications,
  'kullanimi_ve_sikligi': instance.usage,
  'uygulandigi_donem': instance.periods,
  'kalinti_bilgisi_ikas': instance.residue,
};

_DrugInfoPeriods _$DrugInfoPeriodsFromJson(Map<String, dynamic> json) =>
    _DrugInfoPeriods(
      suitable:
          (json['uygun_donemler'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      avoid:
          (json['kullanilmamasi_gereken_donemler'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DrugInfoPeriodsToJson(_DrugInfoPeriods instance) =>
    <String, dynamic>{
      'uygun_donemler': instance.suitable,
      'kullanilmamasi_gereken_donemler': instance.avoid,
    };

_DrugInfoResidue _$DrugInfoResidueFromJson(Map<String, dynamic> json) =>
    _DrugInfoResidue(
      withdrawal: json['arinma_suresi'] as String,
      warnings: json['uyarilar'] as String?,
    );

Map<String, dynamic> _$DrugInfoResidueToJson(_DrugInfoResidue instance) =>
    <String, dynamic>{
      'arinma_suresi': instance.withdrawal,
      'uyarilar': instance.warnings,
    };
