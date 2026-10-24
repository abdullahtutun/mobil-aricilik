// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

/// Kurulacak işletmenin kimliği. Yeniden denemede aynı kalır; yanıtı
/// kaybolan istek tekrarlanınca ikinci işletme açılmaz.
 String get organizationId; OnboardingStep get step;/// Cihazın dil listesinden önerilen ülke; listede en üstte durur.
 String? get suggestedCountryCode;/// Başta önerilen ülke.
 String? get countryCode; String get name; HiveCountRange? get hiveCountRange;/// İşletme kuruluyor.
 bool get busy; OrganizationFailure? get failure;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.organizationId, _this.organizationId) || other.organizationId == _this.organizationId)&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.suggestedCountryCode, _this.suggestedCountryCode) || other.suggestedCountryCode == _this.suggestedCountryCode)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.hiveCountRange, _this.hiveCountRange) || other.hiveCountRange == _this.hiveCountRange)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as OnboardingState;
  return Object.hash(runtimeType,_this.organizationId,_this.step,_this.suggestedCountryCode,_this.countryCode,_this.name,_this.hiveCountRange,_this.busy,_this.failure);
}

@override
String toString() {
  final _this = this as OnboardingState;
  return 'OnboardingState(organizationId: ${_this.organizationId}, step: ${_this.step}, suggestedCountryCode: ${_this.suggestedCountryCode}, countryCode: ${_this.countryCode}, name: ${_this.name}, hiveCountRange: ${_this.hiveCountRange}, busy: ${_this.busy}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 String organizationId, OnboardingStep step, String? suggestedCountryCode, String? countryCode, String name, HiveCountRange? hiveCountRange, bool busy, OrganizationFailure? failure
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizationId = null,Object? step = null,Object? suggestedCountryCode = freezed,Object? countryCode = freezed,Object? name = null,Object? hiveCountRange = freezed,Object? busy = null,Object? failure = freezed,}) {
  return _then(OnboardingState(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,suggestedCountryCode: freezed == suggestedCountryCode ? _self.suggestedCountryCode : suggestedCountryCode // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hiveCountRange: freezed == hiveCountRange ? _self.hiveCountRange : hiveCountRange // ignore: cast_nullable_to_non_nullable
as HiveCountRange?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as OrganizationFailure?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String organizationId,  OnboardingStep step,  String? suggestedCountryCode,  String? countryCode,  String name,  HiveCountRange? hiveCountRange,  bool busy,  OrganizationFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.organizationId,_that.step,_that.suggestedCountryCode,_that.countryCode,_that.name,_that.hiveCountRange,_that.busy,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String organizationId,  OnboardingStep step,  String? suggestedCountryCode,  String? countryCode,  String name,  HiveCountRange? hiveCountRange,  bool busy,  OrganizationFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.organizationId,_that.step,_that.suggestedCountryCode,_that.countryCode,_that.name,_that.hiveCountRange,_that.busy,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String organizationId,  OnboardingStep step,  String? suggestedCountryCode,  String? countryCode,  String name,  HiveCountRange? hiveCountRange,  bool busy,  OrganizationFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.organizationId,_that.step,_that.suggestedCountryCode,_that.countryCode,_that.name,_that.hiveCountRange,_that.busy,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({required this.organizationId, this.step = OnboardingStep.languageAndCountry, this.suggestedCountryCode, this.countryCode, this.name = '', this.hiveCountRange, this.busy = false, this.failure});
  

/// Kurulacak işletmenin kimliği. Yeniden denemede aynı kalır; yanıtı
/// kaybolan istek tekrarlanınca ikinci işletme açılmaz.
@override final  String organizationId;
@override@JsonKey() final  OnboardingStep step;
/// Cihazın dil listesinden önerilen ülke; listede en üstte durur.
@override final  String? suggestedCountryCode;
/// Başta önerilen ülke.
@override final  String? countryCode;
@override@JsonKey() final  String name;
@override final  HiveCountRange? hiveCountRange;
/// İşletme kuruluyor.
@override@JsonKey() final  bool busy;
@override final  OrganizationFailure? failure;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId)&&(identical(other.step, step) || other.step == step)&&(identical(other.suggestedCountryCode, suggestedCountryCode) || other.suggestedCountryCode == suggestedCountryCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.name, name) || other.name == name)&&(identical(other.hiveCountRange, hiveCountRange) || other.hiveCountRange == hiveCountRange)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,organizationId,step,suggestedCountryCode,countryCode,name,hiveCountRange,busy,failure);
}

@override
String toString() {
    return 'OnboardingState(organizationId: $organizationId, step: $step, suggestedCountryCode: $suggestedCountryCode, countryCode: $countryCode, name: $name, hiveCountRange: $hiveCountRange, busy: $busy, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 String organizationId, OnboardingStep step, String? suggestedCountryCode, String? countryCode, String name, HiveCountRange? hiveCountRange, bool busy, OrganizationFailure? failure
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizationId = null,Object? step = null,Object? suggestedCountryCode = freezed,Object? countryCode = freezed,Object? name = null,Object? hiveCountRange = freezed,Object? busy = null,Object? failure = freezed,}) {
  return _then(_OnboardingState(
organizationId: null == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as String,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep,suggestedCountryCode: freezed == suggestedCountryCode ? _self.suggestedCountryCode : suggestedCountryCode // ignore: cast_nullable_to_non_nullable
as String?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hiveCountRange: freezed == hiveCountRange ? _self.hiveCountRange : hiveCountRange // ignore: cast_nullable_to_non_nullable
as HiveCountRange?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as OrganizationFailure?,
  ));
}


}

// dart format on
