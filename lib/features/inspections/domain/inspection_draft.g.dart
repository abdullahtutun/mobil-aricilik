// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionDraft _$InspectionDraftFromJson(Map<String, dynamic> json) =>
    _InspectionDraft(
      values: json['values'] == null
          ? const InspectionValues()
          : InspectionValues.fromJson(json['values'] as Map<String, dynamic>),
      suggested:
          (json['suggested'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$InspectionFieldEnumMap, e))
              .toSet() ??
          const <InspectionField>{},
    );

Map<String, dynamic> _$InspectionDraftToJson(_InspectionDraft instance) =>
    <String, dynamic>{
      'values': instance.values,
      'suggested': instance.suggested
          .map((e) => _$InspectionFieldEnumMap[e]!)
          .toList(),
    };

const _$InspectionFieldEnumMap = {
  InspectionField.queenState: 'queenState',
  InspectionField.beeFrames: 'beeFrames',
  InspectionField.broodFrames: 'broodFrames',
  InspectionField.honeyFrames: 'honeyFrames',
  InspectionField.temperament: 'temperament',
  InspectionField.swarmSigns: 'swarmSigns',
  InspectionField.queenCells: 'queenCells',
  InspectionField.diseaseSuspected: 'diseaseSuspected',
};
