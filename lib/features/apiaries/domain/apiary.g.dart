// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Apiary _$ApiaryFromJson(Map<String, dynamic> json) => _Apiary(
  id: json['id'] as String,
  orgId: json['org_id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  altitudeM: (json['altitude_m'] as num?)?.toInt(),
  landTenure: $enumDecodeNullable(_$LandTenureEnumMap, json['land_tenure']),
  waterSource: json['water_source'] as String?,
  vehicleDistanceM: (json['vehicle_distance_m'] as num?)?.toInt(),
  roadNotes: json['road_notes'] as String?,
  notes: json['notes'] as String?,
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  serverSeq: (json['server_seq'] as num?)?.toInt(),
);

Map<String, dynamic> _$ApiaryToJson(_Apiary instance) => <String, dynamic>{
  'id': instance.id,
  'org_id': instance.orgId,
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'altitude_m': instance.altitudeM,
  'land_tenure': _$LandTenureEnumMap[instance.landTenure],
  'water_source': instance.waterSource,
  'vehicle_distance_m': instance.vehicleDistanceM,
  'road_notes': instance.roadNotes,
  'notes': instance.notes,
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$LandTenureEnumMap = {
  LandTenure.owned: 'owned',
  LandTenure.rented: 'rented',
  LandTenure.permitted: 'permitted',
};
