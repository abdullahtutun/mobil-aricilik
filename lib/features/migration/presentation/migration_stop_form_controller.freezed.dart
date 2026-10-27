// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'migration_stop_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MigrationStopFormState {

 int get position; DateTime get plannedStartOn; DateTime get plannedEndOn; String get name; String get place; String? get apiaryId; int? get hiveCount; MigrationStopStatus get status; bool get saving;
/// Create a copy of MigrationStopFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MigrationStopFormStateCopyWith<MigrationStopFormState> get copyWith => _$MigrationStopFormStateCopyWithImpl<MigrationStopFormState>(this as MigrationStopFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MigrationStopFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MigrationStopFormState&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.plannedStartOn, _this.plannedStartOn) || other.plannedStartOn == _this.plannedStartOn)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.hiveCount, _this.hiveCount) || other.hiveCount == _this.hiveCount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as MigrationStopFormState;
  return Object.hash(runtimeType,_this.position,_this.plannedStartOn,_this.plannedEndOn,_this.name,_this.place,_this.apiaryId,_this.hiveCount,_this.status,_this.saving);
}

@override
String toString() {
  final _this = this as MigrationStopFormState;
  return 'MigrationStopFormState(position: ${_this.position}, plannedStartOn: ${_this.plannedStartOn}, plannedEndOn: ${_this.plannedEndOn}, name: ${_this.name}, place: ${_this.place}, apiaryId: ${_this.apiaryId}, hiveCount: ${_this.hiveCount}, status: ${_this.status}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $MigrationStopFormStateCopyWith<$Res>  {
  factory $MigrationStopFormStateCopyWith(MigrationStopFormState value, $Res Function(MigrationStopFormState) _then) = _$MigrationStopFormStateCopyWithImpl;
@useResult
$Res call({
 int position, DateTime plannedStartOn, DateTime plannedEndOn, String name, String place, String? apiaryId, int? hiveCount, MigrationStopStatus status, bool saving
});




}
/// @nodoc
class _$MigrationStopFormStateCopyWithImpl<$Res>
    implements $MigrationStopFormStateCopyWith<$Res> {
  _$MigrationStopFormStateCopyWithImpl(this._self, this._then);

  final MigrationStopFormState _self;
  final $Res Function(MigrationStopFormState) _then;

/// Create a copy of MigrationStopFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? plannedStartOn = null,Object? plannedEndOn = null,Object? name = null,Object? place = null,Object? apiaryId = freezed,Object? hiveCount = freezed,Object? status = null,Object? saving = null,}) {
  return _then(MigrationStopFormState(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,plannedStartOn: null == plannedStartOn ? _self.plannedStartOn : plannedStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: null == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveCount: freezed == hiveCount ? _self.hiveCount : hiveCount // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MigrationStopStatus,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MigrationStopFormState].
extension MigrationStopFormStatePatterns on MigrationStopFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MigrationStopFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MigrationStopFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MigrationStopFormState value)  $default,){
final _that = this;
switch (_that) {
case _MigrationStopFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MigrationStopFormState value)?  $default,){
final _that = this;
switch (_that) {
case _MigrationStopFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int position,  DateTime plannedStartOn,  DateTime plannedEndOn,  String name,  String place,  String? apiaryId,  int? hiveCount,  MigrationStopStatus status,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MigrationStopFormState() when $default != null:
return $default(_that.position,_that.plannedStartOn,_that.plannedEndOn,_that.name,_that.place,_that.apiaryId,_that.hiveCount,_that.status,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int position,  DateTime plannedStartOn,  DateTime plannedEndOn,  String name,  String place,  String? apiaryId,  int? hiveCount,  MigrationStopStatus status,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _MigrationStopFormState():
return $default(_that.position,_that.plannedStartOn,_that.plannedEndOn,_that.name,_that.place,_that.apiaryId,_that.hiveCount,_that.status,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int position,  DateTime plannedStartOn,  DateTime plannedEndOn,  String name,  String place,  String? apiaryId,  int? hiveCount,  MigrationStopStatus status,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _MigrationStopFormState() when $default != null:
return $default(_that.position,_that.plannedStartOn,_that.plannedEndOn,_that.name,_that.place,_that.apiaryId,_that.hiveCount,_that.status,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _MigrationStopFormState implements MigrationStopFormState {
  const _MigrationStopFormState({required this.position, required this.plannedStartOn, required this.plannedEndOn, this.name = '', this.place = '', this.apiaryId, this.hiveCount, this.status = MigrationStopStatus.planned, this.saving = false});
  

@override final  int position;
@override final  DateTime plannedStartOn;
@override final  DateTime plannedEndOn;
@override@JsonKey() final  String name;
@override@JsonKey() final  String place;
@override final  String? apiaryId;
@override final  int? hiveCount;
@override@JsonKey() final  MigrationStopStatus status;
@override@JsonKey() final  bool saving;

/// Create a copy of MigrationStopFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MigrationStopFormStateCopyWith<_MigrationStopFormState> get copyWith => __$MigrationStopFormStateCopyWithImpl<_MigrationStopFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MigrationStopFormState&&(identical(other.position, position) || other.position == position)&&(identical(other.plannedStartOn, plannedStartOn) || other.plannedStartOn == plannedStartOn)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.name, name) || other.name == name)&&(identical(other.place, place) || other.place == place)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.hiveCount, hiveCount) || other.hiveCount == hiveCount)&&(identical(other.status, status) || other.status == status)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,position,plannedStartOn,plannedEndOn,name,place,apiaryId,hiveCount,status,saving);
}

@override
String toString() {
    return 'MigrationStopFormState(position: $position, plannedStartOn: $plannedStartOn, plannedEndOn: $plannedEndOn, name: $name, place: $place, apiaryId: $apiaryId, hiveCount: $hiveCount, status: $status, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$MigrationStopFormStateCopyWith<$Res> implements $MigrationStopFormStateCopyWith<$Res> {
  factory _$MigrationStopFormStateCopyWith(_MigrationStopFormState value, $Res Function(_MigrationStopFormState) _then) = __$MigrationStopFormStateCopyWithImpl;
@override @useResult
$Res call({
 int position, DateTime plannedStartOn, DateTime plannedEndOn, String name, String place, String? apiaryId, int? hiveCount, MigrationStopStatus status, bool saving
});




}
/// @nodoc
class __$MigrationStopFormStateCopyWithImpl<$Res>
    implements _$MigrationStopFormStateCopyWith<$Res> {
  __$MigrationStopFormStateCopyWithImpl(this._self, this._then);

  final _MigrationStopFormState _self;
  final $Res Function(_MigrationStopFormState) _then;

/// Create a copy of MigrationStopFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? plannedStartOn = null,Object? plannedEndOn = null,Object? name = null,Object? place = null,Object? apiaryId = freezed,Object? hiveCount = freezed,Object? status = null,Object? saving = null,}) {
  return _then(_MigrationStopFormState(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,plannedStartOn: null == plannedStartOn ? _self.plannedStartOn : plannedStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: null == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveCount: freezed == hiveCount ? _self.hiveCount : hiveCount // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MigrationStopStatus,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
