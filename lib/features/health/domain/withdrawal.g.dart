// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WithdrawalOverride _$WithdrawalOverrideFromJson(Map<String, dynamic> json) =>
    _WithdrawalOverride(
      treatmentId: json['treatment_id'] as String,
      reason: $enumDecode(_$WithdrawalOverrideReasonEnumMap, json['reason']),
    );

Map<String, dynamic> _$WithdrawalOverrideToJson(_WithdrawalOverride instance) =>
    <String, dynamic>{
      'treatment_id': instance.treatmentId,
      'reason': _$WithdrawalOverrideReasonEnumMap[instance.reason]!,
    };

const _$WithdrawalOverrideReasonEnumMap = {
  WithdrawalOverrideReason.removedEarly: 'removed_early',
  WithdrawalOverrideReason.notForSale: 'not_for_sale',
};
