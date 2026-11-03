// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MapBounds {

 double get west; double get south; double get east; double get north;
/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapBoundsCopyWith<MapBounds> get copyWith => _$MapBoundsCopyWithImpl<MapBounds>(this as MapBounds, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapBounds;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapBounds&&(identical(other.west, _this.west) || other.west == _this.west)&&(identical(other.south, _this.south) || other.south == _this.south)&&(identical(other.east, _this.east) || other.east == _this.east)&&(identical(other.north, _this.north) || other.north == _this.north));
}


@override
int get hashCode {
  final _this = this as MapBounds;
  return Object.hash(runtimeType,_this.west,_this.south,_this.east,_this.north);
}

@override
String toString() {
  final _this = this as MapBounds;
  return 'MapBounds(west: ${_this.west}, south: ${_this.south}, east: ${_this.east}, north: ${_this.north})';
}


}

/// @nodoc
abstract mixin class $MapBoundsCopyWith<$Res>  {
  factory $MapBoundsCopyWith(MapBounds value, $Res Function(MapBounds) _then) = _$MapBoundsCopyWithImpl;
@useResult
$Res call({
 double west, double south, double east, double north
});




}
/// @nodoc
class _$MapBoundsCopyWithImpl<$Res>
    implements $MapBoundsCopyWith<$Res> {
  _$MapBoundsCopyWithImpl(this._self, this._then);

  final MapBounds _self;
  final $Res Function(MapBounds) _then;

/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? west = null,Object? south = null,Object? east = null,Object? north = null,}) {
  return _then(MapBounds(
west: null == west ? _self.west : west // ignore: cast_nullable_to_non_nullable
as double,south: null == south ? _self.south : south // ignore: cast_nullable_to_non_nullable
as double,east: null == east ? _self.east : east // ignore: cast_nullable_to_non_nullable
as double,north: null == north ? _self.north : north // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MapBounds].
extension MapBoundsPatterns on MapBounds {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapBounds value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapBounds value)  $default,){
final _that = this;
switch (_that) {
case _MapBounds():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapBounds value)?  $default,){
final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double west,  double south,  double east,  double north)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
return $default(_that.west,_that.south,_that.east,_that.north);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double west,  double south,  double east,  double north)  $default,) {final _that = this;
switch (_that) {
case _MapBounds():
return $default(_that.west,_that.south,_that.east,_that.north);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double west,  double south,  double east,  double north)?  $default,) {final _that = this;
switch (_that) {
case _MapBounds() when $default != null:
return $default(_that.west,_that.south,_that.east,_that.north);case _:
  return null;

}
}

}

/// @nodoc


class _MapBounds implements MapBounds {
  const _MapBounds({required this.west, required this.south, required this.east, required this.north});
  

@override final  double west;
@override final  double south;
@override final  double east;
@override final  double north;

/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapBoundsCopyWith<_MapBounds> get copyWith => __$MapBoundsCopyWithImpl<_MapBounds>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapBounds&&(identical(other.west, west) || other.west == west)&&(identical(other.south, south) || other.south == south)&&(identical(other.east, east) || other.east == east)&&(identical(other.north, north) || other.north == north));
}


@override
int get hashCode {
    return Object.hash(runtimeType,west,south,east,north);
}

@override
String toString() {
    return 'MapBounds(west: $west, south: $south, east: $east, north: $north)';
}


}

/// @nodoc
abstract mixin class _$MapBoundsCopyWith<$Res> implements $MapBoundsCopyWith<$Res> {
  factory _$MapBoundsCopyWith(_MapBounds value, $Res Function(_MapBounds) _then) = __$MapBoundsCopyWithImpl;
@override @useResult
$Res call({
 double west, double south, double east, double north
});




}
/// @nodoc
class __$MapBoundsCopyWithImpl<$Res>
    implements _$MapBoundsCopyWith<$Res> {
  __$MapBoundsCopyWithImpl(this._self, this._then);

  final _MapBounds _self;
  final $Res Function(_MapBounds) _then;

/// Create a copy of MapBounds
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? west = null,Object? south = null,Object? east = null,Object? north = null,}) {
  return _then(_MapBounds(
west: null == west ? _self.west : west // ignore: cast_nullable_to_non_nullable
as double,south: null == south ? _self.south : south // ignore: cast_nullable_to_non_nullable
as double,east: null == east ? _self.east : east // ignore: cast_nullable_to_non_nullable
as double,north: null == north ? _self.north : north // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$MapArea {

/// Arılığın kimliği; dosya adı olur.
 String get id;/// Arılığın adı (indirildiği andaki).
 String get name; double get latitude; double get longitude;
/// Create a copy of MapArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapAreaCopyWith<MapArea> get copyWith => _$MapAreaCopyWithImpl<MapArea>(this as MapArea, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapArea;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapArea&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude));
}


@override
int get hashCode {
  final _this = this as MapArea;
  return Object.hash(runtimeType,_this.id,_this.name,_this.latitude,_this.longitude);
}

@override
String toString() {
  final _this = this as MapArea;
  return 'MapArea(id: ${_this.id}, name: ${_this.name}, latitude: ${_this.latitude}, longitude: ${_this.longitude})';
}


}

/// @nodoc
abstract mixin class $MapAreaCopyWith<$Res>  {
  factory $MapAreaCopyWith(MapArea value, $Res Function(MapArea) _then) = _$MapAreaCopyWithImpl;
@useResult
$Res call({
 String id, String name, double latitude, double longitude
});




}
/// @nodoc
class _$MapAreaCopyWithImpl<$Res>
    implements $MapAreaCopyWith<$Res> {
  _$MapAreaCopyWithImpl(this._self, this._then);

  final MapArea _self;
  final $Res Function(MapArea) _then;

/// Create a copy of MapArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(MapArea(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MapArea].
extension MapAreaPatterns on MapArea {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapArea() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapArea value)  $default,){
final _that = this;
switch (_that) {
case _MapArea():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapArea value)?  $default,){
final _that = this;
switch (_that) {
case _MapArea() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapArea() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double latitude,  double longitude)  $default,) {final _that = this;
switch (_that) {
case _MapArea():
return $default(_that.id,_that.name,_that.latitude,_that.longitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double latitude,  double longitude)?  $default,) {final _that = this;
switch (_that) {
case _MapArea() when $default != null:
return $default(_that.id,_that.name,_that.latitude,_that.longitude);case _:
  return null;

}
}

}

/// @nodoc


class _MapArea implements MapArea {
  const _MapArea({required this.id, required this.name, required this.latitude, required this.longitude});
  

/// Arılığın kimliği; dosya adı olur.
@override final  String id;
/// Arılığın adı (indirildiği andaki).
@override final  String name;
@override final  double latitude;
@override final  double longitude;

/// Create a copy of MapArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapAreaCopyWith<_MapArea> get copyWith => __$MapAreaCopyWithImpl<_MapArea>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapArea&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,latitude,longitude);
}

@override
String toString() {
    return 'MapArea(id: $id, name: $name, latitude: $latitude, longitude: $longitude)';
}


}

/// @nodoc
abstract mixin class _$MapAreaCopyWith<$Res> implements $MapAreaCopyWith<$Res> {
  factory _$MapAreaCopyWith(_MapArea value, $Res Function(_MapArea) _then) = __$MapAreaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double latitude, double longitude
});




}
/// @nodoc
class __$MapAreaCopyWithImpl<$Res>
    implements _$MapAreaCopyWith<$Res> {
  __$MapAreaCopyWithImpl(this._self, this._then);

  final _MapArea _self;
  final $Res Function(_MapArea) _then;

/// Create a copy of MapArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? latitude = null,Object? longitude = null,}) {
  return _then(_MapArea(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$InstalledMapArea {

 MapArea get area;/// Paketteki karolar ve dosyanın boyutu.
 int get tileCount; int get bytes; DateTime get downloadedAt;
/// Create a copy of InstalledMapArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstalledMapAreaCopyWith<InstalledMapArea> get copyWith => _$InstalledMapAreaCopyWithImpl<InstalledMapArea>(this as InstalledMapArea, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InstalledMapArea;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstalledMapArea&&(identical(other.area, _this.area) || other.area == _this.area)&&(identical(other.tileCount, _this.tileCount) || other.tileCount == _this.tileCount)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes)&&(identical(other.downloadedAt, _this.downloadedAt) || other.downloadedAt == _this.downloadedAt));
}


@override
int get hashCode {
  final _this = this as InstalledMapArea;
  return Object.hash(runtimeType,_this.area,_this.tileCount,_this.bytes,_this.downloadedAt);
}

@override
String toString() {
  final _this = this as InstalledMapArea;
  return 'InstalledMapArea(area: ${_this.area}, tileCount: ${_this.tileCount}, bytes: ${_this.bytes}, downloadedAt: ${_this.downloadedAt})';
}


}

/// @nodoc
abstract mixin class $InstalledMapAreaCopyWith<$Res>  {
  factory $InstalledMapAreaCopyWith(InstalledMapArea value, $Res Function(InstalledMapArea) _then) = _$InstalledMapAreaCopyWithImpl;
@useResult
$Res call({
 MapArea area, int tileCount, int bytes, DateTime downloadedAt
});


$MapAreaCopyWith<$Res> get area;

}
/// @nodoc
class _$InstalledMapAreaCopyWithImpl<$Res>
    implements $InstalledMapAreaCopyWith<$Res> {
  _$InstalledMapAreaCopyWithImpl(this._self, this._then);

  final InstalledMapArea _self;
  final $Res Function(InstalledMapArea) _then;

/// Create a copy of InstalledMapArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? area = null,Object? tileCount = null,Object? bytes = null,Object? downloadedAt = null,}) {
  return _then(InstalledMapArea(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as MapArea,tileCount: null == tileCount ? _self.tileCount : tileCount // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of InstalledMapArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapAreaCopyWith<$Res> get area {
  
  return $MapAreaCopyWith<$Res>(_self.area, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}


/// Adds pattern-matching-related methods to [InstalledMapArea].
extension InstalledMapAreaPatterns on InstalledMapArea {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstalledMapArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstalledMapArea() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstalledMapArea value)  $default,){
final _that = this;
switch (_that) {
case _InstalledMapArea():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstalledMapArea value)?  $default,){
final _that = this;
switch (_that) {
case _InstalledMapArea() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapArea area,  int tileCount,  int bytes,  DateTime downloadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstalledMapArea() when $default != null:
return $default(_that.area,_that.tileCount,_that.bytes,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapArea area,  int tileCount,  int bytes,  DateTime downloadedAt)  $default,) {final _that = this;
switch (_that) {
case _InstalledMapArea():
return $default(_that.area,_that.tileCount,_that.bytes,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapArea area,  int tileCount,  int bytes,  DateTime downloadedAt)?  $default,) {final _that = this;
switch (_that) {
case _InstalledMapArea() when $default != null:
return $default(_that.area,_that.tileCount,_that.bytes,_that.downloadedAt);case _:
  return null;

}
}

}

/// @nodoc


class _InstalledMapArea implements InstalledMapArea {
  const _InstalledMapArea({required this.area, required this.tileCount, required this.bytes, required this.downloadedAt});
  

@override final  MapArea area;
/// Paketteki karolar ve dosyanın boyutu.
@override final  int tileCount;
@override final  int bytes;
@override final  DateTime downloadedAt;

/// Create a copy of InstalledMapArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstalledMapAreaCopyWith<_InstalledMapArea> get copyWith => __$InstalledMapAreaCopyWithImpl<_InstalledMapArea>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstalledMapArea&&(identical(other.area, area) || other.area == area)&&(identical(other.tileCount, tileCount) || other.tileCount == tileCount)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,area,tileCount,bytes,downloadedAt);
}

@override
String toString() {
    return 'InstalledMapArea(area: $area, tileCount: $tileCount, bytes: $bytes, downloadedAt: $downloadedAt)';
}


}

/// @nodoc
abstract mixin class _$InstalledMapAreaCopyWith<$Res> implements $InstalledMapAreaCopyWith<$Res> {
  factory _$InstalledMapAreaCopyWith(_InstalledMapArea value, $Res Function(_InstalledMapArea) _then) = __$InstalledMapAreaCopyWithImpl;
@override @useResult
$Res call({
 MapArea area, int tileCount, int bytes, DateTime downloadedAt
});


@override $MapAreaCopyWith<$Res> get area;

}
/// @nodoc
class __$InstalledMapAreaCopyWithImpl<$Res>
    implements _$InstalledMapAreaCopyWith<$Res> {
  __$InstalledMapAreaCopyWithImpl(this._self, this._then);

  final _InstalledMapArea _self;
  final $Res Function(_InstalledMapArea) _then;

/// Create a copy of InstalledMapArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? area = null,Object? tileCount = null,Object? bytes = null,Object? downloadedAt = null,}) {
  return _then(_InstalledMapArea(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as MapArea,tileCount: null == tileCount ? _self.tileCount : tileCount // ignore: cast_nullable_to_non_nullable
as int,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of InstalledMapArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapAreaCopyWith<$Res> get area {
  
  return $MapAreaCopyWith<$Res>(_self.area, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}

/// @nodoc
mixin _$MapAreaCandidate {

 MapArea get area;/// Arılığa bağlı, geçmişte kalmamış göç duraklarının adları.
 List<String> get stopNames;/// İndirilmiş ama arılık o zamandan beri taşınmış; yeniden indirilmeli.
 bool get moved;
/// Create a copy of MapAreaCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapAreaCandidateCopyWith<MapAreaCandidate> get copyWith => _$MapAreaCandidateCopyWithImpl<MapAreaCandidate>(this as MapAreaCandidate, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapAreaCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapAreaCandidate&&(identical(other.area, _this.area) || other.area == _this.area)&&const DeepCollectionEquality().equals(other.stopNames, _this.stopNames)&&(identical(other.moved, _this.moved) || other.moved == _this.moved));
}


@override
int get hashCode {
  final _this = this as MapAreaCandidate;
  return Object.hash(runtimeType,_this.area,const DeepCollectionEquality().hash(_this.stopNames),_this.moved);
}

@override
String toString() {
  final _this = this as MapAreaCandidate;
  return 'MapAreaCandidate(area: ${_this.area}, stopNames: ${_this.stopNames}, moved: ${_this.moved})';
}


}

/// @nodoc
abstract mixin class $MapAreaCandidateCopyWith<$Res>  {
  factory $MapAreaCandidateCopyWith(MapAreaCandidate value, $Res Function(MapAreaCandidate) _then) = _$MapAreaCandidateCopyWithImpl;
@useResult
$Res call({
 MapArea area, List<String> stopNames, bool moved
});


$MapAreaCopyWith<$Res> get area;

}
/// @nodoc
class _$MapAreaCandidateCopyWithImpl<$Res>
    implements $MapAreaCandidateCopyWith<$Res> {
  _$MapAreaCandidateCopyWithImpl(this._self, this._then);

  final MapAreaCandidate _self;
  final $Res Function(MapAreaCandidate) _then;

/// Create a copy of MapAreaCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? area = null,Object? stopNames = null,Object? moved = null,}) {
  return _then(MapAreaCandidate(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as MapArea,stopNames: null == stopNames ? _self.stopNames : stopNames // ignore: cast_nullable_to_non_nullable
as List<String>,moved: null == moved ? _self.moved : moved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MapAreaCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapAreaCopyWith<$Res> get area {
  
  return $MapAreaCopyWith<$Res>(_self.area, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}


/// Adds pattern-matching-related methods to [MapAreaCandidate].
extension MapAreaCandidatePatterns on MapAreaCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapAreaCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapAreaCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapAreaCandidate value)  $default,){
final _that = this;
switch (_that) {
case _MapAreaCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapAreaCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _MapAreaCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapArea area,  List<String> stopNames,  bool moved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapAreaCandidate() when $default != null:
return $default(_that.area,_that.stopNames,_that.moved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapArea area,  List<String> stopNames,  bool moved)  $default,) {final _that = this;
switch (_that) {
case _MapAreaCandidate():
return $default(_that.area,_that.stopNames,_that.moved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapArea area,  List<String> stopNames,  bool moved)?  $default,) {final _that = this;
switch (_that) {
case _MapAreaCandidate() when $default != null:
return $default(_that.area,_that.stopNames,_that.moved);case _:
  return null;

}
}

}

/// @nodoc


class _MapAreaCandidate implements MapAreaCandidate {
  const _MapAreaCandidate({required this.area, required  List<String> stopNames, this.moved = false}): _stopNames = stopNames;
  

@override final  MapArea area;
/// Arılığa bağlı, geçmişte kalmamış göç duraklarının adları.
 final  List<String> _stopNames;
/// Arılığa bağlı, geçmişte kalmamış göç duraklarının adları.
@override List<String> get stopNames {
  if (_stopNames is EqualUnmodifiableListView) return _stopNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stopNames);
}

/// İndirilmiş ama arılık o zamandan beri taşınmış; yeniden indirilmeli.
@override@JsonKey() final  bool moved;

/// Create a copy of MapAreaCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapAreaCandidateCopyWith<_MapAreaCandidate> get copyWith => __$MapAreaCandidateCopyWithImpl<_MapAreaCandidate>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapAreaCandidate&&(identical(other.area, area) || other.area == area)&&const DeepCollectionEquality().equals(other.stopNames, _stopNames)&&(identical(other.moved, moved) || other.moved == moved));
}


@override
int get hashCode {
    return Object.hash(runtimeType,area,const DeepCollectionEquality().hash(_stopNames),moved);
}

@override
String toString() {
    return 'MapAreaCandidate(area: $area, stopNames: $stopNames, moved: $moved)';
}


}

/// @nodoc
abstract mixin class _$MapAreaCandidateCopyWith<$Res> implements $MapAreaCandidateCopyWith<$Res> {
  factory _$MapAreaCandidateCopyWith(_MapAreaCandidate value, $Res Function(_MapAreaCandidate) _then) = __$MapAreaCandidateCopyWithImpl;
@override @useResult
$Res call({
 MapArea area, List<String> stopNames, bool moved
});


@override $MapAreaCopyWith<$Res> get area;

}
/// @nodoc
class __$MapAreaCandidateCopyWithImpl<$Res>
    implements _$MapAreaCandidateCopyWith<$Res> {
  __$MapAreaCandidateCopyWithImpl(this._self, this._then);

  final _MapAreaCandidate _self;
  final $Res Function(_MapAreaCandidate) _then;

/// Create a copy of MapAreaCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? area = null,Object? stopNames = null,Object? moved = null,}) {
  return _then(_MapAreaCandidate(
area: null == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as MapArea,stopNames: null == stopNames ? _self._stopNames : stopNames // ignore: cast_nullable_to_non_nullable
as List<String>,moved: null == moved ? _self.moved : moved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MapAreaCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapAreaCopyWith<$Res> get area {
  
  return $MapAreaCopyWith<$Res>(_self.area, (value) {
    return _then(_self.copyWith(area: value));
  });
}
}

// dart format on
