// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apiary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Apiary {

 String get id; String get orgId; String get name; DateTime get createdAt; DateTime get updatedAt;/// WGS 84. Sunucuda tek bir `location` noktası; ikisi birlikte dolu ya
/// da birlikte boş (GPS alınamadıysa).
 double? get latitude; double? get longitude; int? get altitudeM; LandTenure? get landTenure; String? get waterSource;/// Aracın bırakıldığı yerden arılığa uzaklık.
 int? get vehicleDistanceM; String? get roadNotes; String? get notes; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Apiary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiaryCopyWith<Apiary> get copyWith => _$ApiaryCopyWithImpl<Apiary>(this as Apiary, _$identity);

  /// Serializes this Apiary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Apiary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Apiary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.altitudeM, _this.altitudeM) || other.altitudeM == _this.altitudeM)&&(identical(other.landTenure, _this.landTenure) || other.landTenure == _this.landTenure)&&(identical(other.waterSource, _this.waterSource) || other.waterSource == _this.waterSource)&&(identical(other.vehicleDistanceM, _this.vehicleDistanceM) || other.vehicleDistanceM == _this.vehicleDistanceM)&&(identical(other.roadNotes, _this.roadNotes) || other.roadNotes == _this.roadNotes)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Apiary;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.name,_this.createdAt,_this.updatedAt,_this.latitude,_this.longitude,_this.altitudeM,_this.landTenure,_this.waterSource,_this.vehicleDistanceM,_this.roadNotes,_this.notes,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Apiary;
  return 'Apiary(id: ${_this.id}, orgId: ${_this.orgId}, name: ${_this.name}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, latitude: ${_this.latitude}, longitude: ${_this.longitude}, altitudeM: ${_this.altitudeM}, landTenure: ${_this.landTenure}, waterSource: ${_this.waterSource}, vehicleDistanceM: ${_this.vehicleDistanceM}, roadNotes: ${_this.roadNotes}, notes: ${_this.notes}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $ApiaryCopyWith<$Res>  {
  factory $ApiaryCopyWith(Apiary value, $Res Function(Apiary) _then) = _$ApiaryCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String name, DateTime createdAt, DateTime updatedAt, double? latitude, double? longitude, int? altitudeM, LandTenure? landTenure, String? waterSource, int? vehicleDistanceM, String? roadNotes, String? notes, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$ApiaryCopyWithImpl<$Res>
    implements $ApiaryCopyWith<$Res> {
  _$ApiaryCopyWithImpl(this._self, this._then);

  final Apiary _self;
  final $Res Function(Apiary) _then;

/// Create a copy of Apiary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? latitude = freezed,Object? longitude = freezed,Object? altitudeM = freezed,Object? landTenure = freezed,Object? waterSource = freezed,Object? vehicleDistanceM = freezed,Object? roadNotes = freezed,Object? notes = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Apiary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,altitudeM: freezed == altitudeM ? _self.altitudeM : altitudeM // ignore: cast_nullable_to_non_nullable
as int?,landTenure: freezed == landTenure ? _self.landTenure : landTenure // ignore: cast_nullable_to_non_nullable
as LandTenure?,waterSource: freezed == waterSource ? _self.waterSource : waterSource // ignore: cast_nullable_to_non_nullable
as String?,vehicleDistanceM: freezed == vehicleDistanceM ? _self.vehicleDistanceM : vehicleDistanceM // ignore: cast_nullable_to_non_nullable
as int?,roadNotes: freezed == roadNotes ? _self.roadNotes : roadNotes // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Apiary].
extension ApiaryPatterns on Apiary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Apiary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Apiary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Apiary value)  $default,){
final _that = this;
switch (_that) {
case _Apiary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Apiary value)?  $default,){
final _that = this;
switch (_that) {
case _Apiary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String name,  DateTime createdAt,  DateTime updatedAt,  double? latitude,  double? longitude,  int? altitudeM,  LandTenure? landTenure,  String? waterSource,  int? vehicleDistanceM,  String? roadNotes,  String? notes,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Apiary() when $default != null:
return $default(_that.id,_that.orgId,_that.name,_that.createdAt,_that.updatedAt,_that.latitude,_that.longitude,_that.altitudeM,_that.landTenure,_that.waterSource,_that.vehicleDistanceM,_that.roadNotes,_that.notes,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String name,  DateTime createdAt,  DateTime updatedAt,  double? latitude,  double? longitude,  int? altitudeM,  LandTenure? landTenure,  String? waterSource,  int? vehicleDistanceM,  String? roadNotes,  String? notes,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Apiary():
return $default(_that.id,_that.orgId,_that.name,_that.createdAt,_that.updatedAt,_that.latitude,_that.longitude,_that.altitudeM,_that.landTenure,_that.waterSource,_that.vehicleDistanceM,_that.roadNotes,_that.notes,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String name,  DateTime createdAt,  DateTime updatedAt,  double? latitude,  double? longitude,  int? altitudeM,  LandTenure? landTenure,  String? waterSource,  int? vehicleDistanceM,  String? roadNotes,  String? notes,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Apiary() when $default != null:
return $default(_that.id,_that.orgId,_that.name,_that.createdAt,_that.updatedAt,_that.latitude,_that.longitude,_that.altitudeM,_that.landTenure,_that.waterSource,_that.vehicleDistanceM,_that.roadNotes,_that.notes,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Apiary implements Apiary {
  const _Apiary({required this.id, required this.orgId, required this.name, required this.createdAt, required this.updatedAt, this.latitude, this.longitude, this.altitudeM, this.landTenure, this.waterSource, this.vehicleDistanceM, this.roadNotes, this.notes, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Apiary.fromJson(Map<String, dynamic> json) => _$ApiaryFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String name;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// WGS 84. Sunucuda tek bir `location` noktası; ikisi birlikte dolu ya
/// da birlikte boş (GPS alınamadıysa).
@override final  double? latitude;
@override final  double? longitude;
@override final  int? altitudeM;
@override final  LandTenure? landTenure;
@override final  String? waterSource;
/// Aracın bırakıldığı yerden arılığa uzaklık.
@override final  int? vehicleDistanceM;
@override final  String? roadNotes;
@override final  String? notes;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Apiary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiaryCopyWith<_Apiary> get copyWith => __$ApiaryCopyWithImpl<_Apiary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Apiary&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.altitudeM, altitudeM) || other.altitudeM == altitudeM)&&(identical(other.landTenure, landTenure) || other.landTenure == landTenure)&&(identical(other.waterSource, waterSource) || other.waterSource == waterSource)&&(identical(other.vehicleDistanceM, vehicleDistanceM) || other.vehicleDistanceM == vehicleDistanceM)&&(identical(other.roadNotes, roadNotes) || other.roadNotes == roadNotes)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,name,createdAt,updatedAt,latitude,longitude,altitudeM,landTenure,waterSource,vehicleDistanceM,roadNotes,notes,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Apiary(id: $id, orgId: $orgId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, latitude: $latitude, longitude: $longitude, altitudeM: $altitudeM, landTenure: $landTenure, waterSource: $waterSource, vehicleDistanceM: $vehicleDistanceM, roadNotes: $roadNotes, notes: $notes, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$ApiaryCopyWith<$Res> implements $ApiaryCopyWith<$Res> {
  factory _$ApiaryCopyWith(_Apiary value, $Res Function(_Apiary) _then) = __$ApiaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String name, DateTime createdAt, DateTime updatedAt, double? latitude, double? longitude, int? altitudeM, LandTenure? landTenure, String? waterSource, int? vehicleDistanceM, String? roadNotes, String? notes, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$ApiaryCopyWithImpl<$Res>
    implements _$ApiaryCopyWith<$Res> {
  __$ApiaryCopyWithImpl(this._self, this._then);

  final _Apiary _self;
  final $Res Function(_Apiary) _then;

/// Create a copy of Apiary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? latitude = freezed,Object? longitude = freezed,Object? altitudeM = freezed,Object? landTenure = freezed,Object? waterSource = freezed,Object? vehicleDistanceM = freezed,Object? roadNotes = freezed,Object? notes = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Apiary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,altitudeM: freezed == altitudeM ? _self.altitudeM : altitudeM // ignore: cast_nullable_to_non_nullable
as int?,landTenure: freezed == landTenure ? _self.landTenure : landTenure // ignore: cast_nullable_to_non_nullable
as LandTenure?,waterSource: freezed == waterSource ? _self.waterSource : waterSource // ignore: cast_nullable_to_non_nullable
as String?,vehicleDistanceM: freezed == vehicleDistanceM ? _self.vehicleDistanceM : vehicleDistanceM // ignore: cast_nullable_to_non_nullable
as int?,roadNotes: freezed == roadNotes ? _self.roadNotes : roadNotes // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
