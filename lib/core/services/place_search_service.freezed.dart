// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_search_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaceResult {

/// Kısa ad (ör. "Kemaliye").
 String get name;/// Bağlı olduğu yerlerle tam ad (ör. "Kemaliye, Erzincan, Türkiye").
 String get displayName; double get latitude; double get longitude;/// Yerin sınır kutusu (güney, kuzey, batı, doğu); harita yeri bütün
/// gösterecek kadar yakınlaşır. Bilinmiyorsa null.
 PlaceBounds? get bounds;
/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceResultCopyWith<PlaceResult> get copyWith => _$PlaceResultCopyWithImpl<PlaceResult>(this as PlaceResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlaceResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceResult&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.bounds, _this.bounds) || other.bounds == _this.bounds));
}


@override
int get hashCode {
  final _this = this as PlaceResult;
  return Object.hash(runtimeType,_this.name,_this.displayName,_this.latitude,_this.longitude,_this.bounds);
}

@override
String toString() {
  final _this = this as PlaceResult;
  return 'PlaceResult(name: ${_this.name}, displayName: ${_this.displayName}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, bounds: ${_this.bounds})';
}


}

/// @nodoc
abstract mixin class $PlaceResultCopyWith<$Res>  {
  factory $PlaceResultCopyWith(PlaceResult value, $Res Function(PlaceResult) _then) = _$PlaceResultCopyWithImpl;
@useResult
$Res call({
 String name, String displayName, double latitude, double longitude, PlaceBounds? bounds
});


$PlaceBoundsCopyWith<$Res>? get bounds;

}
/// @nodoc
class _$PlaceResultCopyWithImpl<$Res>
    implements $PlaceResultCopyWith<$Res> {
  _$PlaceResultCopyWithImpl(this._self, this._then);

  final PlaceResult _self;
  final $Res Function(PlaceResult) _then;

/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? displayName = null,Object? latitude = null,Object? longitude = null,Object? bounds = freezed,}) {
  return _then(PlaceResult(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,bounds: freezed == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as PlaceBounds?,
  ));
}
/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceBoundsCopyWith<$Res>? get bounds {
    if (_self.bounds == null) {
    return null;
  }

  return $PlaceBoundsCopyWith<$Res>(_self.bounds!, (value) {
    return _then(_self.copyWith(bounds: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlaceResult].
extension PlaceResultPatterns on PlaceResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceResult value)  $default,){
final _that = this;
switch (_that) {
case _PlaceResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceResult value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String displayName,  double latitude,  double longitude,  PlaceBounds? bounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
return $default(_that.name,_that.displayName,_that.latitude,_that.longitude,_that.bounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String displayName,  double latitude,  double longitude,  PlaceBounds? bounds)  $default,) {final _that = this;
switch (_that) {
case _PlaceResult():
return $default(_that.name,_that.displayName,_that.latitude,_that.longitude,_that.bounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String displayName,  double latitude,  double longitude,  PlaceBounds? bounds)?  $default,) {final _that = this;
switch (_that) {
case _PlaceResult() when $default != null:
return $default(_that.name,_that.displayName,_that.latitude,_that.longitude,_that.bounds);case _:
  return null;

}
}

}

/// @nodoc


class _PlaceResult implements PlaceResult {
  const _PlaceResult({required this.name, required this.displayName, required this.latitude, required this.longitude, this.bounds});
  

/// Kısa ad (ör. "Kemaliye").
@override final  String name;
/// Bağlı olduğu yerlerle tam ad (ör. "Kemaliye, Erzincan, Türkiye").
@override final  String displayName;
@override final  double latitude;
@override final  double longitude;
/// Yerin sınır kutusu (güney, kuzey, batı, doğu); harita yeri bütün
/// gösterecek kadar yakınlaşır. Bilinmiyorsa null.
@override final  PlaceBounds? bounds;

/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceResultCopyWith<_PlaceResult> get copyWith => __$PlaceResultCopyWithImpl<_PlaceResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceResult&&(identical(other.name, name) || other.name == name)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.bounds, bounds) || other.bounds == bounds));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,displayName,latitude,longitude,bounds);
}

@override
String toString() {
    return 'PlaceResult(name: $name, displayName: $displayName, latitude: $latitude, longitude: $longitude, bounds: $bounds)';
}


}

/// @nodoc
abstract mixin class _$PlaceResultCopyWith<$Res> implements $PlaceResultCopyWith<$Res> {
  factory _$PlaceResultCopyWith(_PlaceResult value, $Res Function(_PlaceResult) _then) = __$PlaceResultCopyWithImpl;
@override @useResult
$Res call({
 String name, String displayName, double latitude, double longitude, PlaceBounds? bounds
});


@override $PlaceBoundsCopyWith<$Res>? get bounds;

}
/// @nodoc
class __$PlaceResultCopyWithImpl<$Res>
    implements _$PlaceResultCopyWith<$Res> {
  __$PlaceResultCopyWithImpl(this._self, this._then);

  final _PlaceResult _self;
  final $Res Function(_PlaceResult) _then;

/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? displayName = null,Object? latitude = null,Object? longitude = null,Object? bounds = freezed,}) {
  return _then(_PlaceResult(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,bounds: freezed == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as PlaceBounds?,
  ));
}

/// Create a copy of PlaceResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaceBoundsCopyWith<$Res>? get bounds {
    if (_self.bounds == null) {
    return null;
  }

  return $PlaceBoundsCopyWith<$Res>(_self.bounds!, (value) {
    return _then(_self.copyWith(bounds: value));
  });
}
}

/// @nodoc
mixin _$PlaceBounds {

 double get south; double get north; double get west; double get east;
/// Create a copy of PlaceBounds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceBoundsCopyWith<PlaceBounds> get copyWith => _$PlaceBoundsCopyWithImpl<PlaceBounds>(this as PlaceBounds, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlaceBounds;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaceBounds&&(identical(other.south, _this.south) || other.south == _this.south)&&(identical(other.north, _this.north) || other.north == _this.north)&&(identical(other.west, _this.west) || other.west == _this.west)&&(identical(other.east, _this.east) || other.east == _this.east));
}


@override
int get hashCode {
  final _this = this as PlaceBounds;
  return Object.hash(runtimeType,_this.south,_this.north,_this.west,_this.east);
}

@override
String toString() {
  final _this = this as PlaceBounds;
  return 'PlaceBounds(south: ${_this.south}, north: ${_this.north}, west: ${_this.west}, east: ${_this.east})';
}


}

/// @nodoc
abstract mixin class $PlaceBoundsCopyWith<$Res>  {
  factory $PlaceBoundsCopyWith(PlaceBounds value, $Res Function(PlaceBounds) _then) = _$PlaceBoundsCopyWithImpl;
@useResult
$Res call({
 double south, double north, double west, double east
});




}
/// @nodoc
class _$PlaceBoundsCopyWithImpl<$Res>
    implements $PlaceBoundsCopyWith<$Res> {
  _$PlaceBoundsCopyWithImpl(this._self, this._then);

  final PlaceBounds _self;
  final $Res Function(PlaceBounds) _then;

/// Create a copy of PlaceBounds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? south = null,Object? north = null,Object? west = null,Object? east = null,}) {
  return _then(PlaceBounds(
south: null == south ? _self.south : south // ignore: cast_nullable_to_non_nullable
as double,north: null == north ? _self.north : north // ignore: cast_nullable_to_non_nullable
as double,west: null == west ? _self.west : west // ignore: cast_nullable_to_non_nullable
as double,east: null == east ? _self.east : east // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaceBounds].
extension PlaceBoundsPatterns on PlaceBounds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaceBounds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaceBounds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaceBounds value)  $default,){
final _that = this;
switch (_that) {
case _PlaceBounds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaceBounds value)?  $default,){
final _that = this;
switch (_that) {
case _PlaceBounds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double south,  double north,  double west,  double east)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaceBounds() when $default != null:
return $default(_that.south,_that.north,_that.west,_that.east);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double south,  double north,  double west,  double east)  $default,) {final _that = this;
switch (_that) {
case _PlaceBounds():
return $default(_that.south,_that.north,_that.west,_that.east);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double south,  double north,  double west,  double east)?  $default,) {final _that = this;
switch (_that) {
case _PlaceBounds() when $default != null:
return $default(_that.south,_that.north,_that.west,_that.east);case _:
  return null;

}
}

}

/// @nodoc


class _PlaceBounds implements PlaceBounds {
  const _PlaceBounds({required this.south, required this.north, required this.west, required this.east});
  

@override final  double south;
@override final  double north;
@override final  double west;
@override final  double east;

/// Create a copy of PlaceBounds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceBoundsCopyWith<_PlaceBounds> get copyWith => __$PlaceBoundsCopyWithImpl<_PlaceBounds>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaceBounds&&(identical(other.south, south) || other.south == south)&&(identical(other.north, north) || other.north == north)&&(identical(other.west, west) || other.west == west)&&(identical(other.east, east) || other.east == east));
}


@override
int get hashCode {
    return Object.hash(runtimeType,south,north,west,east);
}

@override
String toString() {
    return 'PlaceBounds(south: $south, north: $north, west: $west, east: $east)';
}


}

/// @nodoc
abstract mixin class _$PlaceBoundsCopyWith<$Res> implements $PlaceBoundsCopyWith<$Res> {
  factory _$PlaceBoundsCopyWith(_PlaceBounds value, $Res Function(_PlaceBounds) _then) = __$PlaceBoundsCopyWithImpl;
@override @useResult
$Res call({
 double south, double north, double west, double east
});




}
/// @nodoc
class __$PlaceBoundsCopyWithImpl<$Res>
    implements _$PlaceBoundsCopyWith<$Res> {
  __$PlaceBoundsCopyWithImpl(this._self, this._then);

  final _PlaceBounds _self;
  final $Res Function(_PlaceBounds) _then;

/// Create a copy of PlaceBounds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? south = null,Object? north = null,Object? west = null,Object? east = null,}) {
  return _then(_PlaceBounds(
south: null == south ? _self.south : south // ignore: cast_nullable_to_non_nullable
as double,north: null == north ? _self.north : north // ignore: cast_nullable_to_non_nullable
as double,west: null == west ? _self.west : west // ignore: cast_nullable_to_non_nullable
as double,east: null == east ? _self.east : east // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
