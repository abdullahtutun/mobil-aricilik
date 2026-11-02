// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hive_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HiveFormState {

 String get number; HiveType get type; HiveStatus get status; HiveSource? get source;/// Kayba (söndü/kayboldu) geçişin nedeni; boş: belirtilmemiş.
 HiveLossReason? get lossReason;/// Düzenlenen kovanın form açılırkenki durumu; yeni kovanda null.
 HiveStatus? get savedStatus; bool get saving;
/// Create a copy of HiveFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HiveFormStateCopyWith<HiveFormState> get copyWith => _$HiveFormStateCopyWithImpl<HiveFormState>(this as HiveFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HiveFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HiveFormState&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.lossReason, _this.lossReason) || other.lossReason == _this.lossReason)&&(identical(other.savedStatus, _this.savedStatus) || other.savedStatus == _this.savedStatus)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as HiveFormState;
  return Object.hash(runtimeType,_this.number,_this.type,_this.status,_this.source,_this.lossReason,_this.savedStatus,_this.saving);
}

@override
String toString() {
  final _this = this as HiveFormState;
  return 'HiveFormState(number: ${_this.number}, type: ${_this.type}, status: ${_this.status}, source: ${_this.source}, lossReason: ${_this.lossReason}, savedStatus: ${_this.savedStatus}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $HiveFormStateCopyWith<$Res>  {
  factory $HiveFormStateCopyWith(HiveFormState value, $Res Function(HiveFormState) _then) = _$HiveFormStateCopyWithImpl;
@useResult
$Res call({
 String number, HiveType type, HiveStatus status, HiveSource? source, HiveLossReason? lossReason, HiveStatus? savedStatus, bool saving
});




}
/// @nodoc
class _$HiveFormStateCopyWithImpl<$Res>
    implements $HiveFormStateCopyWith<$Res> {
  _$HiveFormStateCopyWithImpl(this._self, this._then);

  final HiveFormState _self;
  final $Res Function(HiveFormState) _then;

/// Create a copy of HiveFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? type = null,Object? status = null,Object? source = freezed,Object? lossReason = freezed,Object? savedStatus = freezed,Object? saving = null,}) {
  return _then(HiveFormState(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HiveType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HiveStatus,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HiveSource?,lossReason: freezed == lossReason ? _self.lossReason : lossReason // ignore: cast_nullable_to_non_nullable
as HiveLossReason?,savedStatus: freezed == savedStatus ? _self.savedStatus : savedStatus // ignore: cast_nullable_to_non_nullable
as HiveStatus?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HiveFormState].
extension HiveFormStatePatterns on HiveFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HiveFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HiveFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HiveFormState value)  $default,){
final _that = this;
switch (_that) {
case _HiveFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HiveFormState value)?  $default,){
final _that = this;
switch (_that) {
case _HiveFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String number,  HiveType type,  HiveStatus status,  HiveSource? source,  HiveLossReason? lossReason,  HiveStatus? savedStatus,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HiveFormState() when $default != null:
return $default(_that.number,_that.type,_that.status,_that.source,_that.lossReason,_that.savedStatus,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String number,  HiveType type,  HiveStatus status,  HiveSource? source,  HiveLossReason? lossReason,  HiveStatus? savedStatus,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _HiveFormState():
return $default(_that.number,_that.type,_that.status,_that.source,_that.lossReason,_that.savedStatus,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String number,  HiveType type,  HiveStatus status,  HiveSource? source,  HiveLossReason? lossReason,  HiveStatus? savedStatus,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _HiveFormState() when $default != null:
return $default(_that.number,_that.type,_that.status,_that.source,_that.lossReason,_that.savedStatus,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _HiveFormState implements HiveFormState {
  const _HiveFormState({this.number = '', this.type = HiveType.langstroth, this.status = HiveStatus.active, this.source, this.lossReason, this.savedStatus, this.saving = false});
  

@override@JsonKey() final  String number;
@override@JsonKey() final  HiveType type;
@override@JsonKey() final  HiveStatus status;
@override final  HiveSource? source;
/// Kayba (söndü/kayboldu) geçişin nedeni; boş: belirtilmemiş.
@override final  HiveLossReason? lossReason;
/// Düzenlenen kovanın form açılırkenki durumu; yeni kovanda null.
@override final  HiveStatus? savedStatus;
@override@JsonKey() final  bool saving;

/// Create a copy of HiveFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HiveFormStateCopyWith<_HiveFormState> get copyWith => __$HiveFormStateCopyWithImpl<_HiveFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HiveFormState&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.source, source) || other.source == source)&&(identical(other.lossReason, lossReason) || other.lossReason == lossReason)&&(identical(other.savedStatus, savedStatus) || other.savedStatus == savedStatus)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,number,type,status,source,lossReason,savedStatus,saving);
}

@override
String toString() {
    return 'HiveFormState(number: $number, type: $type, status: $status, source: $source, lossReason: $lossReason, savedStatus: $savedStatus, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$HiveFormStateCopyWith<$Res> implements $HiveFormStateCopyWith<$Res> {
  factory _$HiveFormStateCopyWith(_HiveFormState value, $Res Function(_HiveFormState) _then) = __$HiveFormStateCopyWithImpl;
@override @useResult
$Res call({
 String number, HiveType type, HiveStatus status, HiveSource? source, HiveLossReason? lossReason, HiveStatus? savedStatus, bool saving
});




}
/// @nodoc
class __$HiveFormStateCopyWithImpl<$Res>
    implements _$HiveFormStateCopyWith<$Res> {
  __$HiveFormStateCopyWithImpl(this._self, this._then);

  final _HiveFormState _self;
  final $Res Function(_HiveFormState) _then;

/// Create a copy of HiveFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? type = null,Object? status = null,Object? source = freezed,Object? lossReason = freezed,Object? savedStatus = freezed,Object? saving = null,}) {
  return _then(_HiveFormState(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HiveType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HiveStatus,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HiveSource?,lossReason: freezed == lossReason ? _self.lossReason : lossReason // ignore: cast_nullable_to_non_nullable
as HiveLossReason?,savedStatus: freezed == savedStatus ? _self.savedStatus : savedStatus // ignore: cast_nullable_to_non_nullable
as HiveStatus?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
