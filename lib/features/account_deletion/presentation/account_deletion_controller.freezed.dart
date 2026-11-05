// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_deletion_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DeletionFlowState {

 DeletionStep get step;/// Ekipli sahibin seçimi.
 OwnerDeletionChoice? get choice;/// Devirde seçilen ortağın kullanıcı kimliği.
 String? get transferTo;/// Kod bu akışta doğrulandı mı; doğrulanmadan son onaya geçilmez.
 bool get verified;/// Talep gönderiliyor.
 bool get busy; AccountDeletionFailure? get failure;
/// Create a copy of DeletionFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeletionFlowStateCopyWith<DeletionFlowState> get copyWith => _$DeletionFlowStateCopyWithImpl<DeletionFlowState>(this as DeletionFlowState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DeletionFlowState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeletionFlowState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.choice, _this.choice) || other.choice == _this.choice)&&(identical(other.transferTo, _this.transferTo) || other.transferTo == _this.transferTo)&&(identical(other.verified, _this.verified) || other.verified == _this.verified)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as DeletionFlowState;
  return Object.hash(runtimeType,_this.step,_this.choice,_this.transferTo,_this.verified,_this.busy,_this.failure);
}

@override
String toString() {
  final _this = this as DeletionFlowState;
  return 'DeletionFlowState(step: ${_this.step}, choice: ${_this.choice}, transferTo: ${_this.transferTo}, verified: ${_this.verified}, busy: ${_this.busy}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $DeletionFlowStateCopyWith<$Res>  {
  factory $DeletionFlowStateCopyWith(DeletionFlowState value, $Res Function(DeletionFlowState) _then) = _$DeletionFlowStateCopyWithImpl;
@useResult
$Res call({
 DeletionStep step, OwnerDeletionChoice? choice, String? transferTo, bool verified, bool busy, AccountDeletionFailure? failure
});




}
/// @nodoc
class _$DeletionFlowStateCopyWithImpl<$Res>
    implements $DeletionFlowStateCopyWith<$Res> {
  _$DeletionFlowStateCopyWithImpl(this._self, this._then);

  final DeletionFlowState _self;
  final $Res Function(DeletionFlowState) _then;

/// Create a copy of DeletionFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? choice = freezed,Object? transferTo = freezed,Object? verified = null,Object? busy = null,Object? failure = freezed,}) {
  return _then(DeletionFlowState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as DeletionStep,choice: freezed == choice ? _self.choice : choice // ignore: cast_nullable_to_non_nullable
as OwnerDeletionChoice?,transferTo: freezed == transferTo ? _self.transferTo : transferTo // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AccountDeletionFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeletionFlowState].
extension DeletionFlowStatePatterns on DeletionFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeletionFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeletionFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeletionFlowState value)  $default,){
final _that = this;
switch (_that) {
case _DeletionFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeletionFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _DeletionFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeletionStep step,  OwnerDeletionChoice? choice,  String? transferTo,  bool verified,  bool busy,  AccountDeletionFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeletionFlowState() when $default != null:
return $default(_that.step,_that.choice,_that.transferTo,_that.verified,_that.busy,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeletionStep step,  OwnerDeletionChoice? choice,  String? transferTo,  bool verified,  bool busy,  AccountDeletionFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _DeletionFlowState():
return $default(_that.step,_that.choice,_that.transferTo,_that.verified,_that.busy,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeletionStep step,  OwnerDeletionChoice? choice,  String? transferTo,  bool verified,  bool busy,  AccountDeletionFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DeletionFlowState() when $default != null:
return $default(_that.step,_that.choice,_that.transferTo,_that.verified,_that.busy,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DeletionFlowState implements DeletionFlowState {
  const _DeletionFlowState({this.step = DeletionStep.overview, this.choice, this.transferTo, this.verified = false, this.busy = false, this.failure});
  

@override@JsonKey() final  DeletionStep step;
/// Ekipli sahibin seçimi.
@override final  OwnerDeletionChoice? choice;
/// Devirde seçilen ortağın kullanıcı kimliği.
@override final  String? transferTo;
/// Kod bu akışta doğrulandı mı; doğrulanmadan son onaya geçilmez.
@override@JsonKey() final  bool verified;
/// Talep gönderiliyor.
@override@JsonKey() final  bool busy;
@override final  AccountDeletionFailure? failure;

/// Create a copy of DeletionFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletionFlowStateCopyWith<_DeletionFlowState> get copyWith => __$DeletionFlowStateCopyWithImpl<_DeletionFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeletionFlowState&&(identical(other.step, step) || other.step == step)&&(identical(other.choice, choice) || other.choice == choice)&&(identical(other.transferTo, transferTo) || other.transferTo == transferTo)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,choice,transferTo,verified,busy,failure);
}

@override
String toString() {
    return 'DeletionFlowState(step: $step, choice: $choice, transferTo: $transferTo, verified: $verified, busy: $busy, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DeletionFlowStateCopyWith<$Res> implements $DeletionFlowStateCopyWith<$Res> {
  factory _$DeletionFlowStateCopyWith(_DeletionFlowState value, $Res Function(_DeletionFlowState) _then) = __$DeletionFlowStateCopyWithImpl;
@override @useResult
$Res call({
 DeletionStep step, OwnerDeletionChoice? choice, String? transferTo, bool verified, bool busy, AccountDeletionFailure? failure
});




}
/// @nodoc
class __$DeletionFlowStateCopyWithImpl<$Res>
    implements _$DeletionFlowStateCopyWith<$Res> {
  __$DeletionFlowStateCopyWithImpl(this._self, this._then);

  final _DeletionFlowState _self;
  final $Res Function(_DeletionFlowState) _then;

/// Create a copy of DeletionFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? choice = freezed,Object? transferTo = freezed,Object? verified = null,Object? busy = null,Object? failure = freezed,}) {
  return _then(_DeletionFlowState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as DeletionStep,choice: freezed == choice ? _self.choice : choice // ignore: cast_nullable_to_non_nullable
as OwnerDeletionChoice?,transferTo: freezed == transferTo ? _self.transferTo : transferTo // ignore: cast_nullable_to_non_nullable
as String?,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AccountDeletionFailure?,
  ));
}


}

// dart format on
