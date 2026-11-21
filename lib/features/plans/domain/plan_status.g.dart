// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlanStatus _$PlanStatusFromJson(Map<String, dynamic> json) => _PlanStatus(
  plansEnabled: json['plans_enabled'] as bool? ?? false,
  plan: json['plan'] == null
      ? PlanTier.free
      : PlanTier.fromServer(json['plan'] as String?),
  expiresAt: _timeFromJson(json['expires_at']),
  hiveLimit: (json['hive_limit'] as num?)?.toInt(),
  team: json['team'] as bool? ?? true,
  forecastDays: (json['forecast_days'] as num?)?.toInt(),
);

Map<String, dynamic> _$PlanStatusToJson(_PlanStatus instance) =>
    <String, dynamic>{
      'plans_enabled': instance.plansEnabled,
      'plan': _tierToJson(instance.plan),
      'expires_at': _timeToJson(instance.expiresAt),
      'hive_limit': instance.hiveLimit,
      'team': instance.team,
      'forecast_days': instance.forecastDays,
    };

_StoredPlanStatus _$StoredPlanStatusFromJson(Map<String, dynamic> json) =>
    _StoredPlanStatus(
      status: PlanStatus.fromJson(json['status'] as Map<String, dynamic>),
      fetchedAt: DateTime.parse(json['fetched_at'] as String),
    );

Map<String, dynamic> _$StoredPlanStatusToJson(_StoredPlanStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'fetched_at': instance.fetchedAt.toIso8601String(),
    };
