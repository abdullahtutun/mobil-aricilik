// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apiary_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiaryFormState {

 String get name; double? get latitude; double? get longitude;/// Bu formda GPS'ten alınan konumun doğruluğu (m); kayıtlı konumda
/// bilinmez.
 double? get accuracyM; String get notes;/// GPS'ten konum bekleniyor.
 bool get locating; LocationFailure? get locationFailure; bool get saving;
/// Create a copy of ApiaryFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiaryFormStateCopyWith<ApiaryFormState> get copyWith => _$ApiaryFormStateCopyWithImpl<ApiaryFormState>(this as ApiaryFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ApiaryFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiaryFormState&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.accuracyM, _this.accuracyM) || other.accuracyM == _this.accuracyM)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.locating, _this.locating) || other.locating == _this.locating)&&(identical(other.locationFailure, _this.locationFailure) || other.locationFailure == _this.locationFailure)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as ApiaryFormState;
  return Object.hash(runtimeType,_this.name,_this.latitude,_this.longitude,_this.accuracyM,_this.notes,_this.locating,_this.locationFailure,_this.saving);
}

@override
String toString() {
  final _this = this as ApiaryFormState;
  return 'ApiaryFormState(name: ${_this.name}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, accuracyM: ${_this.accuracyM}, notes: ${_this.notes}, locating: ${_this.locating}, locationFailure: ${_this.locationFailure}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $ApiaryFormStateCopyWith<$Res>  {
  factory $ApiaryFormStateCopyWith(ApiaryFormState value, $Res Function(ApiaryFormState) _then) = _$ApiaryFormStateCopyWithImpl;
@useResult
$Res call({
 String name, double? latitude, double? longitude, double? accuracyM, String notes, bool locating, LocationFailure? locationFailure, bool saving
});




}
/// @nodoc
class _$ApiaryFormStateCopyWithImpl<$Res>
    implements $ApiaryFormStateCopyWith<$Res> {
  _$ApiaryFormStateCopyWithImpl(this._self, this._then);

  final ApiaryFormState _self;
  final $Res Function(ApiaryFormState) _then;

/// Create a copy of ApiaryFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? latitude = freezed,Object? longitude = freezed,Object? accuracyM = freezed,Object? notes = null,Object? locating = null,Object? locationFailure = freezed,Object? saving = null,}) {
  return _then(ApiaryFormState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,accuracyM: freezed == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,locating: null == locating ? _self.locating : locating // ignore: cast_nullable_to_non_nullable
as bool,locationFailure: freezed == locationFailure ? _self.locationFailure : locationFailure // ignore: cast_nullable_to_non_nullable
as LocationFailure?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiaryFormState].
extension ApiaryFormStatePatterns on ApiaryFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiaryFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiaryFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiaryFormState value)  $default,){
final _that = this;
switch (_that) {
case _ApiaryFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiaryFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ApiaryFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double? latitude,  double? longitude,  double? accuracyM,  String notes,  bool locating,  LocationFailure? locationFailure,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiaryFormState() when $default != null:
return $default(_that.name,_that.latitude,_that.longitude,_that.accuracyM,_that.notes,_that.locating,_that.locationFailure,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double? latitude,  double? longitude,  double? accuracyM,  String notes,  bool locating,  LocationFailure? locationFailure,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _ApiaryFormState():
return $default(_that.name,_that.latitude,_that.longitude,_that.accuracyM,_that.notes,_that.locating,_that.locationFailure,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double? latitude,  double? longitude,  double? accuracyM,  String notes,  bool locating,  LocationFailure? locationFailure,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _ApiaryFormState() when $default != null:
return $default(_that.name,_that.latitude,_that.longitude,_that.accuracyM,_that.notes,_that.locating,_that.locationFailure,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _ApiaryFormState implements ApiaryFormState {
  const _ApiaryFormState({this.name = '', this.latitude, this.longitude, this.accuracyM, this.notes = '', this.locating = false, this.locationFailure, this.saving = false});
  

@override@JsonKey() final  String name;
@override final  double? latitude;
@override final  double? longitude;
/// Bu formda GPS'ten alınan konumun doğruluğu (m); kayıtlı konumda
/// bilinmez.
@override final  double? accuracyM;
@override@JsonKey() final  String notes;
/// GPS'ten konum bekleniyor.
@override@JsonKey() final  bool locating;
@override final  LocationFailure? locationFailure;
@override@JsonKey() final  bool saving;

/// Create a copy of ApiaryFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiaryFormStateCopyWith<_ApiaryFormState> get copyWith => __$ApiaryFormStateCopyWithImpl<_ApiaryFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiaryFormState&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.locating, locating) || other.locating == locating)&&(identical(other.locationFailure, locationFailure) || other.locationFailure == locationFailure)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,latitude,longitude,accuracyM,notes,locating,locationFailure,saving);
}

@override
String toString() {
    return 'ApiaryFormState(name: $name, latitude: $latitude, longitude: $longitude, accuracyM: $accuracyM, notes: $notes, locating: $locating, locationFailure: $locationFailure, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$ApiaryFormStateCopyWith<$Res> implements $ApiaryFormStateCopyWith<$Res> {
  factory _$ApiaryFormStateCopyWith(_ApiaryFormState value, $Res Function(_ApiaryFormState) _then) = __$ApiaryFormStateCopyWithImpl;
@override @useResult
$Res call({
 String name, double? latitude, double? longitude, double? accuracyM, String notes, bool locating, LocationFailure? locationFailure, bool saving
});




}
/// @nodoc
class __$ApiaryFormStateCopyWithImpl<$Res>
    implements _$ApiaryFormStateCopyWith<$Res> {
  __$ApiaryFormStateCopyWithImpl(this._self, this._then);

  final _ApiaryFormState _self;
  final $Res Function(_ApiaryFormState) _then;

/// Create a copy of ApiaryFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? latitude = freezed,Object? longitude = freezed,Object? accuracyM = freezed,Object? notes = null,Object? locating = null,Object? locationFailure = freezed,Object? saving = null,}) {
  return _then(_ApiaryFormState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,accuracyM: freezed == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,locating: null == locating ? _self.locating : locating // ignore: cast_nullable_to_non_nullable
as bool,locationFailure: freezed == locationFailure ? _self.locationFailure : locationFailure // ignore: cast_nullable_to_non_nullable
as LocationFailure?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
