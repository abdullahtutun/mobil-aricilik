// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GpsFix {

 double get latitude; double get longitude;/// Yatay doğruluk yarıçapı, metre.
 double get accuracyM;
/// Create a copy of GpsFix
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GpsFixCopyWith<GpsFix> get copyWith => _$GpsFixCopyWithImpl<GpsFix>(this as GpsFix, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as GpsFix;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GpsFix&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.accuracyM, _this.accuracyM) || other.accuracyM == _this.accuracyM));
}


@override
int get hashCode {
  final _this = this as GpsFix;
  return Object.hash(runtimeType,_this.latitude,_this.longitude,_this.accuracyM);
}

@override
String toString() {
  final _this = this as GpsFix;
  return 'GpsFix(latitude: ${_this.latitude}, longitude: ${_this.longitude}, accuracyM: ${_this.accuracyM})';
}


}

/// @nodoc
abstract mixin class $GpsFixCopyWith<$Res>  {
  factory $GpsFixCopyWith(GpsFix value, $Res Function(GpsFix) _then) = _$GpsFixCopyWithImpl;
@useResult
$Res call({
 double latitude, double longitude, double accuracyM
});




}
/// @nodoc
class _$GpsFixCopyWithImpl<$Res>
    implements $GpsFixCopyWith<$Res> {
  _$GpsFixCopyWithImpl(this._self, this._then);

  final GpsFix _self;
  final $Res Function(GpsFix) _then;

/// Create a copy of GpsFix
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyM = null,}) {
  return _then(GpsFix(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyM: null == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GpsFix].
extension GpsFixPatterns on GpsFix {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GpsFix value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GpsFix() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GpsFix value)  $default,){
final _that = this;
switch (_that) {
case _GpsFix():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GpsFix value)?  $default,){
final _that = this;
switch (_that) {
case _GpsFix() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyM)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GpsFix() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyM);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double latitude,  double longitude,  double accuracyM)  $default,) {final _that = this;
switch (_that) {
case _GpsFix():
return $default(_that.latitude,_that.longitude,_that.accuracyM);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double latitude,  double longitude,  double accuracyM)?  $default,) {final _that = this;
switch (_that) {
case _GpsFix() when $default != null:
return $default(_that.latitude,_that.longitude,_that.accuracyM);case _:
  return null;

}
}

}

/// @nodoc


class _GpsFix implements GpsFix {
  const _GpsFix({required this.latitude, required this.longitude, required this.accuracyM});
  

@override final  double latitude;
@override final  double longitude;
/// Yatay doğruluk yarıçapı, metre.
@override final  double accuracyM;

/// Create a copy of GpsFix
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GpsFixCopyWith<_GpsFix> get copyWith => __$GpsFixCopyWithImpl<_GpsFix>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GpsFix&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.accuracyM, accuracyM) || other.accuracyM == accuracyM));
}


@override
int get hashCode {
    return Object.hash(runtimeType,latitude,longitude,accuracyM);
}

@override
String toString() {
    return 'GpsFix(latitude: $latitude, longitude: $longitude, accuracyM: $accuracyM)';
}


}

/// @nodoc
abstract mixin class _$GpsFixCopyWith<$Res> implements $GpsFixCopyWith<$Res> {
  factory _$GpsFixCopyWith(_GpsFix value, $Res Function(_GpsFix) _then) = __$GpsFixCopyWithImpl;
@override @useResult
$Res call({
 double latitude, double longitude, double accuracyM
});




}
/// @nodoc
class __$GpsFixCopyWithImpl<$Res>
    implements _$GpsFixCopyWith<$Res> {
  __$GpsFixCopyWithImpl(this._self, this._then);

  final _GpsFix _self;
  final $Res Function(_GpsFix) _then;

/// Create a copy of GpsFix
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? latitude = null,Object? longitude = null,Object? accuracyM = null,}) {
  return _then(_GpsFix(
latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,accuracyM: null == accuracyM ? _self.accuracyM : accuracyM // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
