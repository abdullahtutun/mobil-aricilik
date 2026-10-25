// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mite_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MiteCount {

 String get id; String get orgId; String get hiveId;/// Ölçümün yapıldığı arılık; kovan sonra taşınsa da değişmez.
 String get apiaryId; DateTime get countedAt; MiteCountMethod get method;/// Bulunan (alt tablada dökülen) akar.
 int get mites; DateTime get createdAt; DateTime get updatedAt;/// Yıkanan arı; yalnız örnekli yöntemlerde.
 int? get sampleBees;/// Tablanın kovanda kaldığı gün; yalnız alt tablada.
 int? get days; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of MiteCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiteCountCopyWith<MiteCount> get copyWith => _$MiteCountCopyWithImpl<MiteCount>(this as MiteCount, _$identity);

  /// Serializes this MiteCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MiteCount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiteCount&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.countedAt, _this.countedAt) || other.countedAt == _this.countedAt)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.mites, _this.mites) || other.mites == _this.mites)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.sampleBees, _this.sampleBees) || other.sampleBees == _this.sampleBees)&&(identical(other.days, _this.days) || other.days == _this.days)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MiteCount;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.hiveId,_this.apiaryId,_this.countedAt,_this.method,_this.mites,_this.createdAt,_this.updatedAt,_this.sampleBees,_this.days,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as MiteCount;
  return 'MiteCount(id: ${_this.id}, orgId: ${_this.orgId}, hiveId: ${_this.hiveId}, apiaryId: ${_this.apiaryId}, countedAt: ${_this.countedAt}, method: ${_this.method}, mites: ${_this.mites}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, sampleBees: ${_this.sampleBees}, days: ${_this.days}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $MiteCountCopyWith<$Res>  {
  factory $MiteCountCopyWith(MiteCount value, $Res Function(MiteCount) _then) = _$MiteCountCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, DateTime countedAt, MiteCountMethod method, int mites, DateTime createdAt, DateTime updatedAt, int? sampleBees, int? days, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$MiteCountCopyWithImpl<$Res>
    implements $MiteCountCopyWith<$Res> {
  _$MiteCountCopyWithImpl(this._self, this._then);

  final MiteCount _self;
  final $Res Function(MiteCount) _then;

/// Create a copy of MiteCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? countedAt = null,Object? method = null,Object? mites = null,Object? createdAt = null,Object? updatedAt = null,Object? sampleBees = freezed,Object? days = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(MiteCount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,countedAt: null == countedAt ? _self.countedAt : countedAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as MiteCountMethod,mites: null == mites ? _self.mites : mites // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sampleBees: freezed == sampleBees ? _self.sampleBees : sampleBees // ignore: cast_nullable_to_non_nullable
as int?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MiteCount].
extension MiteCountPatterns on MiteCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiteCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiteCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiteCount value)  $default,){
final _that = this;
switch (_that) {
case _MiteCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiteCount value)?  $default,){
final _that = this;
switch (_that) {
case _MiteCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime countedAt,  MiteCountMethod method,  int mites,  DateTime createdAt,  DateTime updatedAt,  int? sampleBees,  int? days,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiteCount() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.countedAt,_that.method,_that.mites,_that.createdAt,_that.updatedAt,_that.sampleBees,_that.days,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime countedAt,  MiteCountMethod method,  int mites,  DateTime createdAt,  DateTime updatedAt,  int? sampleBees,  int? days,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _MiteCount():
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.countedAt,_that.method,_that.mites,_that.createdAt,_that.updatedAt,_that.sampleBees,_that.days,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime countedAt,  MiteCountMethod method,  int mites,  DateTime createdAt,  DateTime updatedAt,  int? sampleBees,  int? days,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _MiteCount() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.countedAt,_that.method,_that.mites,_that.createdAt,_that.updatedAt,_that.sampleBees,_that.days,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MiteCount implements MiteCount {
  const _MiteCount({required this.id, required this.orgId, required this.hiveId, required this.apiaryId, required this.countedAt, required this.method, required this.mites, required this.createdAt, required this.updatedAt, this.sampleBees, this.days, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _MiteCount.fromJson(Map<String, dynamic> json) => _$MiteCountFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String hiveId;
/// Ölçümün yapıldığı arılık; kovan sonra taşınsa da değişmez.
@override final  String apiaryId;
@override final  DateTime countedAt;
@override final  MiteCountMethod method;
/// Bulunan (alt tablada dökülen) akar.
@override final  int mites;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Yıkanan arı; yalnız örnekli yöntemlerde.
@override final  int? sampleBees;
/// Tablanın kovanda kaldığı gün; yalnız alt tablada.
@override final  int? days;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of MiteCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiteCountCopyWith<_MiteCount> get copyWith => __$MiteCountCopyWithImpl<_MiteCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MiteCountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiteCount&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.countedAt, countedAt) || other.countedAt == countedAt)&&(identical(other.method, method) || other.method == method)&&(identical(other.mites, mites) || other.mites == mites)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.sampleBees, sampleBees) || other.sampleBees == sampleBees)&&(identical(other.days, days) || other.days == days)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,hiveId,apiaryId,countedAt,method,mites,createdAt,updatedAt,sampleBees,days,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'MiteCount(id: $id, orgId: $orgId, hiveId: $hiveId, apiaryId: $apiaryId, countedAt: $countedAt, method: $method, mites: $mites, createdAt: $createdAt, updatedAt: $updatedAt, sampleBees: $sampleBees, days: $days, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$MiteCountCopyWith<$Res> implements $MiteCountCopyWith<$Res> {
  factory _$MiteCountCopyWith(_MiteCount value, $Res Function(_MiteCount) _then) = __$MiteCountCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, DateTime countedAt, MiteCountMethod method, int mites, DateTime createdAt, DateTime updatedAt, int? sampleBees, int? days, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$MiteCountCopyWithImpl<$Res>
    implements _$MiteCountCopyWith<$Res> {
  __$MiteCountCopyWithImpl(this._self, this._then);

  final _MiteCount _self;
  final $Res Function(_MiteCount) _then;

/// Create a copy of MiteCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? countedAt = null,Object? method = null,Object? mites = null,Object? createdAt = null,Object? updatedAt = null,Object? sampleBees = freezed,Object? days = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_MiteCount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,countedAt: null == countedAt ? _self.countedAt : countedAt // ignore: cast_nullable_to_non_nullable
as DateTime,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as MiteCountMethod,mites: null == mites ? _self.mites : mites // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sampleBees: freezed == sampleBees ? _self.sampleBees : sampleBees // ignore: cast_nullable_to_non_nullable
as int?,days: freezed == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
