// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_pack.dart';

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
mixin _$MapPack {

/// `tr-48`; dosya adı olur.
 String get id;/// Dil kodundan ada (`{"tr": "Muğla", "en": "Mugla"}`).
 Map<String, String> get names; MapBounds get bounds; int get minZoom; int get maxZoom;/// İndirme adresi (public bucket).
 String get url;/// İndirilecek dosyanın tam boyutu.
 int get bytes;/// Küçük harf hex SHA-256; indirmeden sonra doğrulanır.
 String get sha256;
/// Create a copy of MapPack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPackCopyWith<MapPack> get copyWith => _$MapPackCopyWithImpl<MapPack>(this as MapPack, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapPack;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPack&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.names, _this.names)&&(identical(other.bounds, _this.bounds) || other.bounds == _this.bounds)&&(identical(other.minZoom, _this.minZoom) || other.minZoom == _this.minZoom)&&(identical(other.maxZoom, _this.maxZoom) || other.maxZoom == _this.maxZoom)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.bytes, _this.bytes) || other.bytes == _this.bytes)&&(identical(other.sha256, _this.sha256) || other.sha256 == _this.sha256));
}


@override
int get hashCode {
  final _this = this as MapPack;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.names),_this.bounds,_this.minZoom,_this.maxZoom,_this.url,_this.bytes,_this.sha256);
}

@override
String toString() {
  final _this = this as MapPack;
  return 'MapPack(id: ${_this.id}, names: ${_this.names}, bounds: ${_this.bounds}, minZoom: ${_this.minZoom}, maxZoom: ${_this.maxZoom}, url: ${_this.url}, bytes: ${_this.bytes}, sha256: ${_this.sha256})';
}


}

/// @nodoc
abstract mixin class $MapPackCopyWith<$Res>  {
  factory $MapPackCopyWith(MapPack value, $Res Function(MapPack) _then) = _$MapPackCopyWithImpl;
@useResult
$Res call({
 String id, Map<String, String> names, MapBounds bounds, int minZoom, int maxZoom, String url, int bytes, String sha256
});


$MapBoundsCopyWith<$Res> get bounds;

}
/// @nodoc
class _$MapPackCopyWithImpl<$Res>
    implements $MapPackCopyWith<$Res> {
  _$MapPackCopyWithImpl(this._self, this._then);

  final MapPack _self;
  final $Res Function(MapPack) _then;

/// Create a copy of MapPack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? names = null,Object? bounds = null,Object? minZoom = null,Object? maxZoom = null,Object? url = null,Object? bytes = null,Object? sha256 = null,}) {
  return _then(MapPack(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,names: null == names ? _self.names : names // ignore: cast_nullable_to_non_nullable
as Map<String, String>,bounds: null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as MapBounds,minZoom: null == minZoom ? _self.minZoom : minZoom // ignore: cast_nullable_to_non_nullable
as int,maxZoom: null == maxZoom ? _self.maxZoom : maxZoom // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MapPack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapBoundsCopyWith<$Res> get bounds {
  
  return $MapBoundsCopyWith<$Res>(_self.bounds, (value) {
    return _then(_self.copyWith(bounds: value));
  });
}
}


/// Adds pattern-matching-related methods to [MapPack].
extension MapPackPatterns on MapPack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapPack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapPack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapPack value)  $default,){
final _that = this;
switch (_that) {
case _MapPack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapPack value)?  $default,){
final _that = this;
switch (_that) {
case _MapPack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Map<String, String> names,  MapBounds bounds,  int minZoom,  int maxZoom,  String url,  int bytes,  String sha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapPack() when $default != null:
return $default(_that.id,_that.names,_that.bounds,_that.minZoom,_that.maxZoom,_that.url,_that.bytes,_that.sha256);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Map<String, String> names,  MapBounds bounds,  int minZoom,  int maxZoom,  String url,  int bytes,  String sha256)  $default,) {final _that = this;
switch (_that) {
case _MapPack():
return $default(_that.id,_that.names,_that.bounds,_that.minZoom,_that.maxZoom,_that.url,_that.bytes,_that.sha256);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Map<String, String> names,  MapBounds bounds,  int minZoom,  int maxZoom,  String url,  int bytes,  String sha256)?  $default,) {final _that = this;
switch (_that) {
case _MapPack() when $default != null:
return $default(_that.id,_that.names,_that.bounds,_that.minZoom,_that.maxZoom,_that.url,_that.bytes,_that.sha256);case _:
  return null;

}
}

}

/// @nodoc


class _MapPack implements MapPack {
  const _MapPack({required this.id, required  Map<String, String> names, required this.bounds, required this.minZoom, required this.maxZoom, required this.url, required this.bytes, required this.sha256}): _names = names;
  

/// `tr-48`; dosya adı olur.
@override final  String id;
/// Dil kodundan ada (`{"tr": "Muğla", "en": "Mugla"}`).
 final  Map<String, String> _names;
/// Dil kodundan ada (`{"tr": "Muğla", "en": "Mugla"}`).
@override Map<String, String> get names {
  if (_names is EqualUnmodifiableMapView) return _names;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_names);
}

@override final  MapBounds bounds;
@override final  int minZoom;
@override final  int maxZoom;
/// İndirme adresi (public bucket).
@override final  String url;
/// İndirilecek dosyanın tam boyutu.
@override final  int bytes;
/// Küçük harf hex SHA-256; indirmeden sonra doğrulanır.
@override final  String sha256;

/// Create a copy of MapPack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapPackCopyWith<_MapPack> get copyWith => __$MapPackCopyWithImpl<_MapPack>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapPack&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.names, _names)&&(identical(other.bounds, bounds) || other.bounds == bounds)&&(identical(other.minZoom, minZoom) || other.minZoom == minZoom)&&(identical(other.maxZoom, maxZoom) || other.maxZoom == maxZoom)&&(identical(other.url, url) || other.url == url)&&(identical(other.bytes, bytes) || other.bytes == bytes)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_names),bounds,minZoom,maxZoom,url,bytes,sha256);
}

@override
String toString() {
    return 'MapPack(id: $id, names: $names, bounds: $bounds, minZoom: $minZoom, maxZoom: $maxZoom, url: $url, bytes: $bytes, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class _$MapPackCopyWith<$Res> implements $MapPackCopyWith<$Res> {
  factory _$MapPackCopyWith(_MapPack value, $Res Function(_MapPack) _then) = __$MapPackCopyWithImpl;
@override @useResult
$Res call({
 String id, Map<String, String> names, MapBounds bounds, int minZoom, int maxZoom, String url, int bytes, String sha256
});


@override $MapBoundsCopyWith<$Res> get bounds;

}
/// @nodoc
class __$MapPackCopyWithImpl<$Res>
    implements _$MapPackCopyWith<$Res> {
  __$MapPackCopyWithImpl(this._self, this._then);

  final _MapPack _self;
  final $Res Function(_MapPack) _then;

/// Create a copy of MapPack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? names = null,Object? bounds = null,Object? minZoom = null,Object? maxZoom = null,Object? url = null,Object? bytes = null,Object? sha256 = null,}) {
  return _then(_MapPack(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,names: null == names ? _self._names : names // ignore: cast_nullable_to_non_nullable
as Map<String, String>,bounds: null == bounds ? _self.bounds : bounds // ignore: cast_nullable_to_non_nullable
as MapBounds,minZoom: null == minZoom ? _self.minZoom : minZoom // ignore: cast_nullable_to_non_nullable
as int,maxZoom: null == maxZoom ? _self.maxZoom : maxZoom // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MapPack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapBoundsCopyWith<$Res> get bounds {
  
  return $MapBoundsCopyWith<$Res>(_self.bounds, (value) {
    return _then(_self.copyWith(bounds: value));
  });
}
}

/// @nodoc
mixin _$MapPackCatalog {

 String get version;/// Paketlerin kesildiği gün; "güncelleme: Eyl 2026".
 DateTime get generatedAt; List<MapPack> get packs;
/// Create a copy of MapPackCatalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPackCatalogCopyWith<MapPackCatalog> get copyWith => _$MapPackCatalogCopyWithImpl<MapPackCatalog>(this as MapPackCatalog, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapPackCatalog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPackCatalog&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&const DeepCollectionEquality().equals(other.packs, _this.packs));
}


@override
int get hashCode {
  final _this = this as MapPackCatalog;
  return Object.hash(runtimeType,_this.version,_this.generatedAt,const DeepCollectionEquality().hash(_this.packs));
}

@override
String toString() {
  final _this = this as MapPackCatalog;
  return 'MapPackCatalog(version: ${_this.version}, generatedAt: ${_this.generatedAt}, packs: ${_this.packs})';
}


}

/// @nodoc
abstract mixin class $MapPackCatalogCopyWith<$Res>  {
  factory $MapPackCatalogCopyWith(MapPackCatalog value, $Res Function(MapPackCatalog) _then) = _$MapPackCatalogCopyWithImpl;
@useResult
$Res call({
 String version, DateTime generatedAt, List<MapPack> packs
});




}
/// @nodoc
class _$MapPackCatalogCopyWithImpl<$Res>
    implements $MapPackCatalogCopyWith<$Res> {
  _$MapPackCatalogCopyWithImpl(this._self, this._then);

  final MapPackCatalog _self;
  final $Res Function(MapPackCatalog) _then;

/// Create a copy of MapPackCatalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? generatedAt = null,Object? packs = null,}) {
  return _then(MapPackCatalog(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,packs: null == packs ? _self.packs : packs // ignore: cast_nullable_to_non_nullable
as List<MapPack>,
  ));
}

}


/// Adds pattern-matching-related methods to [MapPackCatalog].
extension MapPackCatalogPatterns on MapPackCatalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapPackCatalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapPackCatalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapPackCatalog value)  $default,){
final _that = this;
switch (_that) {
case _MapPackCatalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapPackCatalog value)?  $default,){
final _that = this;
switch (_that) {
case _MapPackCatalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  DateTime generatedAt,  List<MapPack> packs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapPackCatalog() when $default != null:
return $default(_that.version,_that.generatedAt,_that.packs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  DateTime generatedAt,  List<MapPack> packs)  $default,) {final _that = this;
switch (_that) {
case _MapPackCatalog():
return $default(_that.version,_that.generatedAt,_that.packs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  DateTime generatedAt,  List<MapPack> packs)?  $default,) {final _that = this;
switch (_that) {
case _MapPackCatalog() when $default != null:
return $default(_that.version,_that.generatedAt,_that.packs);case _:
  return null;

}
}

}

/// @nodoc


class _MapPackCatalog implements MapPackCatalog {
  const _MapPackCatalog({required this.version, required this.generatedAt, required  List<MapPack> packs}): _packs = packs;
  

@override final  String version;
/// Paketlerin kesildiği gün; "güncelleme: Eyl 2026".
@override final  DateTime generatedAt;
 final  List<MapPack> _packs;
@override List<MapPack> get packs {
  if (_packs is EqualUnmodifiableListView) return _packs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packs);
}


/// Create a copy of MapPackCatalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapPackCatalogCopyWith<_MapPackCatalog> get copyWith => __$MapPackCatalogCopyWithImpl<_MapPackCatalog>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapPackCatalog&&(identical(other.version, version) || other.version == version)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.packs, _packs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,version,generatedAt,const DeepCollectionEquality().hash(_packs));
}

@override
String toString() {
    return 'MapPackCatalog(version: $version, generatedAt: $generatedAt, packs: $packs)';
}


}

/// @nodoc
abstract mixin class _$MapPackCatalogCopyWith<$Res> implements $MapPackCatalogCopyWith<$Res> {
  factory _$MapPackCatalogCopyWith(_MapPackCatalog value, $Res Function(_MapPackCatalog) _then) = __$MapPackCatalogCopyWithImpl;
@override @useResult
$Res call({
 String version, DateTime generatedAt, List<MapPack> packs
});




}
/// @nodoc
class __$MapPackCatalogCopyWithImpl<$Res>
    implements _$MapPackCatalogCopyWith<$Res> {
  __$MapPackCatalogCopyWithImpl(this._self, this._then);

  final _MapPackCatalog _self;
  final $Res Function(_MapPackCatalog) _then;

/// Create a copy of MapPackCatalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? generatedAt = null,Object? packs = null,}) {
  return _then(_MapPackCatalog(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,packs: null == packs ? _self._packs : packs // ignore: cast_nullable_to_non_nullable
as List<MapPack>,
  ));
}


}

/// @nodoc
mixin _$InstalledMapPack {

 MapPack get pack;/// Katalogun sürümü ve kesildiği gün.
 String get version; DateTime get generatedAt; DateTime get downloadedAt;
/// Create a copy of InstalledMapPack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstalledMapPackCopyWith<InstalledMapPack> get copyWith => _$InstalledMapPackCopyWithImpl<InstalledMapPack>(this as InstalledMapPack, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InstalledMapPack;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstalledMapPack&&(identical(other.pack, _this.pack) || other.pack == _this.pack)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&(identical(other.downloadedAt, _this.downloadedAt) || other.downloadedAt == _this.downloadedAt));
}


@override
int get hashCode {
  final _this = this as InstalledMapPack;
  return Object.hash(runtimeType,_this.pack,_this.version,_this.generatedAt,_this.downloadedAt);
}

@override
String toString() {
  final _this = this as InstalledMapPack;
  return 'InstalledMapPack(pack: ${_this.pack}, version: ${_this.version}, generatedAt: ${_this.generatedAt}, downloadedAt: ${_this.downloadedAt})';
}


}

/// @nodoc
abstract mixin class $InstalledMapPackCopyWith<$Res>  {
  factory $InstalledMapPackCopyWith(InstalledMapPack value, $Res Function(InstalledMapPack) _then) = _$InstalledMapPackCopyWithImpl;
@useResult
$Res call({
 MapPack pack, String version, DateTime generatedAt, DateTime downloadedAt
});


$MapPackCopyWith<$Res> get pack;

}
/// @nodoc
class _$InstalledMapPackCopyWithImpl<$Res>
    implements $InstalledMapPackCopyWith<$Res> {
  _$InstalledMapPackCopyWithImpl(this._self, this._then);

  final InstalledMapPack _self;
  final $Res Function(InstalledMapPack) _then;

/// Create a copy of InstalledMapPack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pack = null,Object? version = null,Object? generatedAt = null,Object? downloadedAt = null,}) {
  return _then(InstalledMapPack(
pack: null == pack ? _self.pack : pack // ignore: cast_nullable_to_non_nullable
as MapPack,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of InstalledMapPack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPackCopyWith<$Res> get pack {
  
  return $MapPackCopyWith<$Res>(_self.pack, (value) {
    return _then(_self.copyWith(pack: value));
  });
}
}


/// Adds pattern-matching-related methods to [InstalledMapPack].
extension InstalledMapPackPatterns on InstalledMapPack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstalledMapPack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstalledMapPack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstalledMapPack value)  $default,){
final _that = this;
switch (_that) {
case _InstalledMapPack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstalledMapPack value)?  $default,){
final _that = this;
switch (_that) {
case _InstalledMapPack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapPack pack,  String version,  DateTime generatedAt,  DateTime downloadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstalledMapPack() when $default != null:
return $default(_that.pack,_that.version,_that.generatedAt,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapPack pack,  String version,  DateTime generatedAt,  DateTime downloadedAt)  $default,) {final _that = this;
switch (_that) {
case _InstalledMapPack():
return $default(_that.pack,_that.version,_that.generatedAt,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapPack pack,  String version,  DateTime generatedAt,  DateTime downloadedAt)?  $default,) {final _that = this;
switch (_that) {
case _InstalledMapPack() when $default != null:
return $default(_that.pack,_that.version,_that.generatedAt,_that.downloadedAt);case _:
  return null;

}
}

}

/// @nodoc


class _InstalledMapPack implements InstalledMapPack {
  const _InstalledMapPack({required this.pack, required this.version, required this.generatedAt, required this.downloadedAt});
  

@override final  MapPack pack;
/// Katalogun sürümü ve kesildiği gün.
@override final  String version;
@override final  DateTime generatedAt;
@override final  DateTime downloadedAt;

/// Create a copy of InstalledMapPack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstalledMapPackCopyWith<_InstalledMapPack> get copyWith => __$InstalledMapPackCopyWithImpl<_InstalledMapPack>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstalledMapPack&&(identical(other.pack, pack) || other.pack == pack)&&(identical(other.version, version) || other.version == version)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pack,version,generatedAt,downloadedAt);
}

@override
String toString() {
    return 'InstalledMapPack(pack: $pack, version: $version, generatedAt: $generatedAt, downloadedAt: $downloadedAt)';
}


}

/// @nodoc
abstract mixin class _$InstalledMapPackCopyWith<$Res> implements $InstalledMapPackCopyWith<$Res> {
  factory _$InstalledMapPackCopyWith(_InstalledMapPack value, $Res Function(_InstalledMapPack) _then) = __$InstalledMapPackCopyWithImpl;
@override @useResult
$Res call({
 MapPack pack, String version, DateTime generatedAt, DateTime downloadedAt
});


@override $MapPackCopyWith<$Res> get pack;

}
/// @nodoc
class __$InstalledMapPackCopyWithImpl<$Res>
    implements _$InstalledMapPackCopyWith<$Res> {
  __$InstalledMapPackCopyWithImpl(this._self, this._then);

  final _InstalledMapPack _self;
  final $Res Function(_InstalledMapPack) _then;

/// Create a copy of InstalledMapPack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pack = null,Object? version = null,Object? generatedAt = null,Object? downloadedAt = null,}) {
  return _then(_InstalledMapPack(
pack: null == pack ? _self.pack : pack // ignore: cast_nullable_to_non_nullable
as MapPack,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of InstalledMapPack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPackCopyWith<$Res> get pack {
  
  return $MapPackCopyWith<$Res>(_self.pack, (value) {
    return _then(_self.copyWith(pack: value));
  });
}
}

/// @nodoc
mixin _$MapPackSuggestion {

 MapPack get pack;/// Paketin içindeki konumlu arılık sayısı.
 int get apiaryCount;/// Paketin içindeki, geçmişte kalmamış göç duraklarının adları.
 List<String> get stopNames;
/// Create a copy of MapPackSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPackSuggestionCopyWith<MapPackSuggestion> get copyWith => _$MapPackSuggestionCopyWithImpl<MapPackSuggestion>(this as MapPackSuggestion, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MapPackSuggestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapPackSuggestion&&(identical(other.pack, _this.pack) || other.pack == _this.pack)&&(identical(other.apiaryCount, _this.apiaryCount) || other.apiaryCount == _this.apiaryCount)&&const DeepCollectionEquality().equals(other.stopNames, _this.stopNames));
}


@override
int get hashCode {
  final _this = this as MapPackSuggestion;
  return Object.hash(runtimeType,_this.pack,_this.apiaryCount,const DeepCollectionEquality().hash(_this.stopNames));
}

@override
String toString() {
  final _this = this as MapPackSuggestion;
  return 'MapPackSuggestion(pack: ${_this.pack}, apiaryCount: ${_this.apiaryCount}, stopNames: ${_this.stopNames})';
}


}

/// @nodoc
abstract mixin class $MapPackSuggestionCopyWith<$Res>  {
  factory $MapPackSuggestionCopyWith(MapPackSuggestion value, $Res Function(MapPackSuggestion) _then) = _$MapPackSuggestionCopyWithImpl;
@useResult
$Res call({
 MapPack pack, int apiaryCount, List<String> stopNames
});


$MapPackCopyWith<$Res> get pack;

}
/// @nodoc
class _$MapPackSuggestionCopyWithImpl<$Res>
    implements $MapPackSuggestionCopyWith<$Res> {
  _$MapPackSuggestionCopyWithImpl(this._self, this._then);

  final MapPackSuggestion _self;
  final $Res Function(MapPackSuggestion) _then;

/// Create a copy of MapPackSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pack = null,Object? apiaryCount = null,Object? stopNames = null,}) {
  return _then(MapPackSuggestion(
pack: null == pack ? _self.pack : pack // ignore: cast_nullable_to_non_nullable
as MapPack,apiaryCount: null == apiaryCount ? _self.apiaryCount : apiaryCount // ignore: cast_nullable_to_non_nullable
as int,stopNames: null == stopNames ? _self.stopNames : stopNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of MapPackSuggestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPackCopyWith<$Res> get pack {
  
  return $MapPackCopyWith<$Res>(_self.pack, (value) {
    return _then(_self.copyWith(pack: value));
  });
}
}


/// Adds pattern-matching-related methods to [MapPackSuggestion].
extension MapPackSuggestionPatterns on MapPackSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MapPackSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MapPackSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MapPackSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _MapPackSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MapPackSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _MapPackSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MapPack pack,  int apiaryCount,  List<String> stopNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MapPackSuggestion() when $default != null:
return $default(_that.pack,_that.apiaryCount,_that.stopNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MapPack pack,  int apiaryCount,  List<String> stopNames)  $default,) {final _that = this;
switch (_that) {
case _MapPackSuggestion():
return $default(_that.pack,_that.apiaryCount,_that.stopNames);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MapPack pack,  int apiaryCount,  List<String> stopNames)?  $default,) {final _that = this;
switch (_that) {
case _MapPackSuggestion() when $default != null:
return $default(_that.pack,_that.apiaryCount,_that.stopNames);case _:
  return null;

}
}

}

/// @nodoc


class _MapPackSuggestion implements MapPackSuggestion {
  const _MapPackSuggestion({required this.pack, required this.apiaryCount, required  List<String> stopNames}): _stopNames = stopNames;
  

@override final  MapPack pack;
/// Paketin içindeki konumlu arılık sayısı.
@override final  int apiaryCount;
/// Paketin içindeki, geçmişte kalmamış göç duraklarının adları.
 final  List<String> _stopNames;
/// Paketin içindeki, geçmişte kalmamış göç duraklarının adları.
@override List<String> get stopNames {
  if (_stopNames is EqualUnmodifiableListView) return _stopNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stopNames);
}


/// Create a copy of MapPackSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MapPackSuggestionCopyWith<_MapPackSuggestion> get copyWith => __$MapPackSuggestionCopyWithImpl<_MapPackSuggestion>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MapPackSuggestion&&(identical(other.pack, pack) || other.pack == pack)&&(identical(other.apiaryCount, apiaryCount) || other.apiaryCount == apiaryCount)&&const DeepCollectionEquality().equals(other.stopNames, _stopNames));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pack,apiaryCount,const DeepCollectionEquality().hash(_stopNames));
}

@override
String toString() {
    return 'MapPackSuggestion(pack: $pack, apiaryCount: $apiaryCount, stopNames: $stopNames)';
}


}

/// @nodoc
abstract mixin class _$MapPackSuggestionCopyWith<$Res> implements $MapPackSuggestionCopyWith<$Res> {
  factory _$MapPackSuggestionCopyWith(_MapPackSuggestion value, $Res Function(_MapPackSuggestion) _then) = __$MapPackSuggestionCopyWithImpl;
@override @useResult
$Res call({
 MapPack pack, int apiaryCount, List<String> stopNames
});


@override $MapPackCopyWith<$Res> get pack;

}
/// @nodoc
class __$MapPackSuggestionCopyWithImpl<$Res>
    implements _$MapPackSuggestionCopyWith<$Res> {
  __$MapPackSuggestionCopyWithImpl(this._self, this._then);

  final _MapPackSuggestion _self;
  final $Res Function(_MapPackSuggestion) _then;

/// Create a copy of MapPackSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pack = null,Object? apiaryCount = null,Object? stopNames = null,}) {
  return _then(_MapPackSuggestion(
pack: null == pack ? _self.pack : pack // ignore: cast_nullable_to_non_nullable
as MapPack,apiaryCount: null == apiaryCount ? _self.apiaryCount : apiaryCount // ignore: cast_nullable_to_non_nullable
as int,stopNames: null == stopNames ? _self._stopNames : stopNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of MapPackSuggestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MapPackCopyWith<$Res> get pack {
  
  return $MapPackCopyWith<$Res>(_self.pack, (value) {
    return _then(_self.copyWith(pack: value));
  });
}
}

// dart format on
