// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InspectionValues _$InspectionValuesFromJson(Map<String, dynamic> json) =>
    _InspectionValues(
      queenState: $enumDecodeNullable(_$QueenStateEnumMap, json['queen_state']),
      beeFrames: (json['bee_frames'] as num?)?.toInt(),
      broodFrames: (json['brood_frames'] as num?)?.toInt(),
      honeyFrames: (json['honey_frames'] as num?)?.toInt(),
      temperament: $enumDecodeNullable(
        _$TemperamentEnumMap,
        json['temperament'],
      ),
      swarmSigns: json['swarm_signs'] as bool?,
      queenCells: $enumDecodeNullable(_$QueenCellsEnumMap, json['queen_cells']),
      diseaseSuspected: json['disease_suspected'] as bool?,
      actions:
          (json['actions'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$InspectionActionEnumMap, e))
              .toSet() ??
          const <InspectionAction>{},
    );

Map<String, dynamic> _$InspectionValuesToJson(_InspectionValues instance) =>
    <String, dynamic>{
      'queen_state': _$QueenStateEnumMap[instance.queenState],
      'bee_frames': instance.beeFrames,
      'brood_frames': instance.broodFrames,
      'honey_frames': instance.honeyFrames,
      'temperament': _$TemperamentEnumMap[instance.temperament],
      'swarm_signs': instance.swarmSigns,
      'queen_cells': _$QueenCellsEnumMap[instance.queenCells],
      'disease_suspected': instance.diseaseSuspected,
      'actions': instance.actions
          .map((e) => _$InspectionActionEnumMap[e]!)
          .toList(),
    };

const _$QueenStateEnumMap = {
  QueenState.seen: 'seen',
  QueenState.eggs: 'eggs',
  QueenState.none: 'none',
};

const _$TemperamentEnumMap = {
  Temperament.calm: 'calm',
  Temperament.nervous: 'nervous',
};

const _$QueenCellsEnumMap = {
  QueenCells.none: 'none',
  QueenCells.swarm: 'swarm',
  QueenCells.supersedure: 'supersedure',
  QueenCells.emergency: 'emergency',
};

const _$InspectionActionEnumMap = {
  InspectionAction.superAdded: 'super_added',
  InspectionAction.superRemoved: 'super_removed',
  InspectionAction.framesAdded: 'frames_added',
  InspectionAction.foundationAdded: 'foundation_added',
  InspectionAction.fed: 'fed',
  InspectionAction.excluderFitted: 'excluder_fitted',
  InspectionAction.entranceReduced: 'entrance_reduced',
  InspectionAction.pollenTrapFitted: 'pollen_trap_fitted',
};

_Inspection _$InspectionFromJson(Map<String, dynamic> json) => _Inspection(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  hiveId: json['hive_id'] as String,
  apiaryId: json['apiary_id'] as String,
  inspectedAt: DateTime.parse(json['inspected_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  queenState: $enumDecodeNullable(_$QueenStateEnumMap, json['queen_state']),
  beeFrames: (json['bee_frames'] as num?)?.toInt(),
  broodFrames: (json['brood_frames'] as num?)?.toInt(),
  honeyFrames: (json['honey_frames'] as num?)?.toInt(),
  temperament: $enumDecodeNullable(_$TemperamentEnumMap, json['temperament']),
  swarmSigns: json['swarm_signs'] as bool?,
  queenCells: $enumDecodeNullable(_$QueenCellsEnumMap, json['queen_cells']),
  diseaseSuspected: json['disease_suspected'] as bool?,
  data: json['data'] as Map<String, dynamic>? ?? const <String, Object?>{},
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$InspectionToJson(_Inspection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'org_id': instance.orgId,
      'hive_id': instance.hiveId,
      'apiary_id': instance.apiaryId,
      'inspected_at': instance.inspectedAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'queen_state': _$QueenStateEnumMap[instance.queenState],
      'bee_frames': instance.beeFrames,
      'brood_frames': instance.broodFrames,
      'honey_frames': instance.honeyFrames,
      'temperament': _$TemperamentEnumMap[instance.temperament],
      'swarm_signs': instance.swarmSigns,
      'queen_cells': _$QueenCellsEnumMap[instance.queenCells],
      'disease_suspected': instance.diseaseSuspected,
      'data': instance.data,
      'created_by': instance.createdBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
