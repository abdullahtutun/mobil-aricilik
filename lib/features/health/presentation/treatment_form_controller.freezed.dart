// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'treatment_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TreatmentFormState {

 Hive get hive;/// Başlangıç günü (yerel takvimde gün başı).
 DateTime get startedOn; TreatmentScope get scope;/// Seçilene kadar boş ve Kaydet kapalı.
 DrugChoice? get drug; int get dose; int get withdrawalDays;/// Planlanan çıkarma günü; tek seferlik uygulamada boş.
 DateTime? get removalOn; String get batchNo; bool get saving;
/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TreatmentFormStateCopyWith<TreatmentFormState> get copyWith => _$TreatmentFormStateCopyWithImpl<TreatmentFormState>(this as TreatmentFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TreatmentFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TreatmentFormState&&(identical(other.hive, _this.hive) || other.hive == _this.hive)&&(identical(other.startedOn, _this.startedOn) || other.startedOn == _this.startedOn)&&(identical(other.scope, _this.scope) || other.scope == _this.scope)&&(identical(other.drug, _this.drug) || other.drug == _this.drug)&&(identical(other.dose, _this.dose) || other.dose == _this.dose)&&(identical(other.withdrawalDays, _this.withdrawalDays) || other.withdrawalDays == _this.withdrawalDays)&&(identical(other.removalOn, _this.removalOn) || other.removalOn == _this.removalOn)&&(identical(other.batchNo, _this.batchNo) || other.batchNo == _this.batchNo)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as TreatmentFormState;
  return Object.hash(runtimeType,_this.hive,_this.startedOn,_this.scope,_this.drug,_this.dose,_this.withdrawalDays,_this.removalOn,_this.batchNo,_this.saving);
}

@override
String toString() {
  final _this = this as TreatmentFormState;
  return 'TreatmentFormState(hive: ${_this.hive}, startedOn: ${_this.startedOn}, scope: ${_this.scope}, drug: ${_this.drug}, dose: ${_this.dose}, withdrawalDays: ${_this.withdrawalDays}, removalOn: ${_this.removalOn}, batchNo: ${_this.batchNo}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $TreatmentFormStateCopyWith<$Res>  {
  factory $TreatmentFormStateCopyWith(TreatmentFormState value, $Res Function(TreatmentFormState) _then) = _$TreatmentFormStateCopyWithImpl;
@useResult
$Res call({
 Hive hive, DateTime startedOn, TreatmentScope scope, DrugChoice? drug, int dose, int withdrawalDays, DateTime? removalOn, String batchNo, bool saving
});


$HiveCopyWith<$Res> get hive;$DrugChoiceCopyWith<$Res>? get drug;

}
/// @nodoc
class _$TreatmentFormStateCopyWithImpl<$Res>
    implements $TreatmentFormStateCopyWith<$Res> {
  _$TreatmentFormStateCopyWithImpl(this._self, this._then);

  final TreatmentFormState _self;
  final $Res Function(TreatmentFormState) _then;

/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hive = null,Object? startedOn = null,Object? scope = null,Object? drug = freezed,Object? dose = null,Object? withdrawalDays = null,Object? removalOn = freezed,Object? batchNo = null,Object? saving = null,}) {
  return _then(TreatmentFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,startedOn: null == startedOn ? _self.startedOn : startedOn // ignore: cast_nullable_to_non_nullable
as DateTime,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as TreatmentScope,drug: freezed == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as DrugChoice?,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as int,withdrawalDays: null == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int,removalOn: freezed == removalOn ? _self.removalOn : removalOn // ignore: cast_nullable_to_non_nullable
as DateTime?,batchNo: null == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugChoiceCopyWith<$Res>? get drug {
    if (_self.drug == null) {
    return null;
  }

  return $DrugChoiceCopyWith<$Res>(_self.drug!, (value) {
    return _then(_self.copyWith(drug: value));
  });
}
}


/// Adds pattern-matching-related methods to [TreatmentFormState].
extension TreatmentFormStatePatterns on TreatmentFormState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TreatmentFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TreatmentFormState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TreatmentFormState value)  $default,){
final _that = this;
switch (_that) {
case _TreatmentFormState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TreatmentFormState value)?  $default,){
final _that = this;
switch (_that) {
case _TreatmentFormState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Hive hive,  DateTime startedOn,  TreatmentScope scope,  DrugChoice? drug,  int dose,  int withdrawalDays,  DateTime? removalOn,  String batchNo,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TreatmentFormState() when $default != null:
return $default(_that.hive,_that.startedOn,_that.scope,_that.drug,_that.dose,_that.withdrawalDays,_that.removalOn,_that.batchNo,_that.saving);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Hive hive,  DateTime startedOn,  TreatmentScope scope,  DrugChoice? drug,  int dose,  int withdrawalDays,  DateTime? removalOn,  String batchNo,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _TreatmentFormState():
return $default(_that.hive,_that.startedOn,_that.scope,_that.drug,_that.dose,_that.withdrawalDays,_that.removalOn,_that.batchNo,_that.saving);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Hive hive,  DateTime startedOn,  TreatmentScope scope,  DrugChoice? drug,  int dose,  int withdrawalDays,  DateTime? removalOn,  String batchNo,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _TreatmentFormState() when $default != null:
return $default(_that.hive,_that.startedOn,_that.scope,_that.drug,_that.dose,_that.withdrawalDays,_that.removalOn,_that.batchNo,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _TreatmentFormState implements TreatmentFormState {
  const _TreatmentFormState({required this.hive, required this.startedOn, this.scope = TreatmentScope.hive, this.drug, this.dose = 1, this.withdrawalDays = 0, this.removalOn, this.batchNo = '', this.saving = false});
  

@override final  Hive hive;
/// Başlangıç günü (yerel takvimde gün başı).
@override final  DateTime startedOn;
@override@JsonKey() final  TreatmentScope scope;
/// Seçilene kadar boş ve Kaydet kapalı.
@override final  DrugChoice? drug;
@override@JsonKey() final  int dose;
@override@JsonKey() final  int withdrawalDays;
/// Planlanan çıkarma günü; tek seferlik uygulamada boş.
@override final  DateTime? removalOn;
@override@JsonKey() final  String batchNo;
@override@JsonKey() final  bool saving;

/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TreatmentFormStateCopyWith<_TreatmentFormState> get copyWith => __$TreatmentFormStateCopyWithImpl<_TreatmentFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TreatmentFormState&&(identical(other.hive, hive) || other.hive == hive)&&(identical(other.startedOn, startedOn) || other.startedOn == startedOn)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.drug, drug) || other.drug == drug)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.removalOn, removalOn) || other.removalOn == removalOn)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hive,startedOn,scope,drug,dose,withdrawalDays,removalOn,batchNo,saving);
}

@override
String toString() {
    return 'TreatmentFormState(hive: $hive, startedOn: $startedOn, scope: $scope, drug: $drug, dose: $dose, withdrawalDays: $withdrawalDays, removalOn: $removalOn, batchNo: $batchNo, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$TreatmentFormStateCopyWith<$Res> implements $TreatmentFormStateCopyWith<$Res> {
  factory _$TreatmentFormStateCopyWith(_TreatmentFormState value, $Res Function(_TreatmentFormState) _then) = __$TreatmentFormStateCopyWithImpl;
@override @useResult
$Res call({
 Hive hive, DateTime startedOn, TreatmentScope scope, DrugChoice? drug, int dose, int withdrawalDays, DateTime? removalOn, String batchNo, bool saving
});


@override $HiveCopyWith<$Res> get hive;@override $DrugChoiceCopyWith<$Res>? get drug;

}
/// @nodoc
class __$TreatmentFormStateCopyWithImpl<$Res>
    implements _$TreatmentFormStateCopyWith<$Res> {
  __$TreatmentFormStateCopyWithImpl(this._self, this._then);

  final _TreatmentFormState _self;
  final $Res Function(_TreatmentFormState) _then;

/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hive = null,Object? startedOn = null,Object? scope = null,Object? drug = freezed,Object? dose = null,Object? withdrawalDays = null,Object? removalOn = freezed,Object? batchNo = null,Object? saving = null,}) {
  return _then(_TreatmentFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,startedOn: null == startedOn ? _self.startedOn : startedOn // ignore: cast_nullable_to_non_nullable
as DateTime,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as TreatmentScope,drug: freezed == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as DrugChoice?,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as int,withdrawalDays: null == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int,removalOn: freezed == removalOn ? _self.removalOn : removalOn // ignore: cast_nullable_to_non_nullable
as DateTime?,batchNo: null == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}/// Create a copy of TreatmentFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugChoiceCopyWith<$Res>? get drug {
    if (_self.drug == null) {
    return null;
  }

  return $DrugChoiceCopyWith<$Res>(_self.drug!, (value) {
    return _then(_self.copyWith(drug: value));
  });
}
}

// dart format on
