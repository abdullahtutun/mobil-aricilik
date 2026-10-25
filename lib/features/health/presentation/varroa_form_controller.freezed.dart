// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'varroa_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VarroaFormState {

 Hive get hive; MiteCountMethod get method; int get sampleBees; int get days;/// Sayılan akar; girilene kadar boş ve Kaydet kapalı. Yanlışlıkla
/// "0 akar" kaydedilmesin.
 int? get mites; bool get saving;
/// Create a copy of VarroaFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VarroaFormStateCopyWith<VarroaFormState> get copyWith => _$VarroaFormStateCopyWithImpl<VarroaFormState>(this as VarroaFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VarroaFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VarroaFormState&&(identical(other.hive, _this.hive) || other.hive == _this.hive)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.sampleBees, _this.sampleBees) || other.sampleBees == _this.sampleBees)&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.mites, _this.mites) || other.mites == _this.mites)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as VarroaFormState;
  return Object.hash(runtimeType,_this.hive,_this.method,_this.sampleBees,_this.days,_this.mites,_this.saving);
}

@override
String toString() {
  final _this = this as VarroaFormState;
  return 'VarroaFormState(hive: ${_this.hive}, method: ${_this.method}, sampleBees: ${_this.sampleBees}, days: ${_this.days}, mites: ${_this.mites}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $VarroaFormStateCopyWith<$Res>  {
  factory $VarroaFormStateCopyWith(VarroaFormState value, $Res Function(VarroaFormState) _then) = _$VarroaFormStateCopyWithImpl;
@useResult
$Res call({
 Hive hive, MiteCountMethod method, int sampleBees, int days, int? mites, bool saving
});


$HiveCopyWith<$Res> get hive;

}
/// @nodoc
class _$VarroaFormStateCopyWithImpl<$Res>
    implements $VarroaFormStateCopyWith<$Res> {
  _$VarroaFormStateCopyWithImpl(this._self, this._then);

  final VarroaFormState _self;
  final $Res Function(VarroaFormState) _then;

/// Create a copy of VarroaFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hive = null,Object? method = null,Object? sampleBees = null,Object? days = null,Object? mites = freezed,Object? saving = null,}) {
  return _then(VarroaFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as MiteCountMethod,sampleBees: null == sampleBees ? _self.sampleBees : sampleBees // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,mites: freezed == mites ? _self.mites : mites // ignore: cast_nullable_to_non_nullable
as int?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of VarroaFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}
}


/// Adds pattern-matching-related methods to [VarroaFormState].
extension VarroaFormStatePatterns on VarroaFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VarroaFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VarroaFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VarroaFormState value)  $default,){
final _that = this;
switch (_that) {
case _VarroaFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VarroaFormState value)?  $default,){
final _that = this;
switch (_that) {
case _VarroaFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Hive hive,  MiteCountMethod method,  int sampleBees,  int days,  int? mites,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VarroaFormState() when $default != null:
return $default(_that.hive,_that.method,_that.sampleBees,_that.days,_that.mites,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Hive hive,  MiteCountMethod method,  int sampleBees,  int days,  int? mites,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _VarroaFormState():
return $default(_that.hive,_that.method,_that.sampleBees,_that.days,_that.mites,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Hive hive,  MiteCountMethod method,  int sampleBees,  int days,  int? mites,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _VarroaFormState() when $default != null:
return $default(_that.hive,_that.method,_that.sampleBees,_that.days,_that.mites,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _VarroaFormState implements VarroaFormState {
  const _VarroaFormState({required this.hive, this.method = MiteCountMethod.sugarRoll, this.sampleBees = defaultSampleBees, this.days = defaultBoardDays, this.mites, this.saving = false});
  

@override final  Hive hive;
@override@JsonKey() final  MiteCountMethod method;
@override@JsonKey() final  int sampleBees;
@override@JsonKey() final  int days;
/// Sayılan akar; girilene kadar boş ve Kaydet kapalı. Yanlışlıkla
/// "0 akar" kaydedilmesin.
@override final  int? mites;
@override@JsonKey() final  bool saving;

/// Create a copy of VarroaFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VarroaFormStateCopyWith<_VarroaFormState> get copyWith => __$VarroaFormStateCopyWithImpl<_VarroaFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VarroaFormState&&(identical(other.hive, hive) || other.hive == hive)&&(identical(other.method, method) || other.method == method)&&(identical(other.sampleBees, sampleBees) || other.sampleBees == sampleBees)&&(identical(other.days, days) || other.days == days)&&(identical(other.mites, mites) || other.mites == mites)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hive,method,sampleBees,days,mites,saving);
}

@override
String toString() {
    return 'VarroaFormState(hive: $hive, method: $method, sampleBees: $sampleBees, days: $days, mites: $mites, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$VarroaFormStateCopyWith<$Res> implements $VarroaFormStateCopyWith<$Res> {
  factory _$VarroaFormStateCopyWith(_VarroaFormState value, $Res Function(_VarroaFormState) _then) = __$VarroaFormStateCopyWithImpl;
@override @useResult
$Res call({
 Hive hive, MiteCountMethod method, int sampleBees, int days, int? mites, bool saving
});


@override $HiveCopyWith<$Res> get hive;

}
/// @nodoc
class __$VarroaFormStateCopyWithImpl<$Res>
    implements _$VarroaFormStateCopyWith<$Res> {
  __$VarroaFormStateCopyWithImpl(this._self, this._then);

  final _VarroaFormState _self;
  final $Res Function(_VarroaFormState) _then;

/// Create a copy of VarroaFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hive = null,Object? method = null,Object? sampleBees = null,Object? days = null,Object? mites = freezed,Object? saving = null,}) {
  return _then(_VarroaFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as MiteCountMethod,sampleBees: null == sampleBees ? _self.sampleBees : sampleBees // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,mites: freezed == mites ? _self.mites : mites // ignore: cast_nullable_to_non_nullable
as int?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of VarroaFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}
}

// dart format on
