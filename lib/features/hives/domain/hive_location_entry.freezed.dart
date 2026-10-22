// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hive_location_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HiveLocationEntry {

 String get id; String get orgId; String get hiveId; String get apiaryId; DateTime get movedAt; DateTime get createdAt; DateTime get updatedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of HiveLocationEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HiveLocationEntryCopyWith<HiveLocationEntry> get copyWith => _$HiveLocationEntryCopyWithImpl<HiveLocationEntry>(this as HiveLocationEntry, _$identity);

  /// Serializes this HiveLocationEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HiveLocationEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HiveLocationEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.movedAt, _this.movedAt) || other.movedAt == _this.movedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HiveLocationEntry;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.hiveId,_this.apiaryId,_this.movedAt,_this.createdAt,_this.updatedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as HiveLocationEntry;
  return 'HiveLocationEntry(id: ${_this.id}, orgId: ${_this.orgId}, hiveId: ${_this.hiveId}, apiaryId: ${_this.apiaryId}, movedAt: ${_this.movedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $HiveLocationEntryCopyWith<$Res>  {
  factory $HiveLocationEntryCopyWith(HiveLocationEntry value, $Res Function(HiveLocationEntry) _then) = _$HiveLocationEntryCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, DateTime movedAt, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$HiveLocationEntryCopyWithImpl<$Res>
    implements $HiveLocationEntryCopyWith<$Res> {
  _$HiveLocationEntryCopyWithImpl(this._self, this._then);

  final HiveLocationEntry _self;
  final $Res Function(HiveLocationEntry) _then;

/// Create a copy of HiveLocationEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? movedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(HiveLocationEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HiveLocationEntry].
extension HiveLocationEntryPatterns on HiveLocationEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HiveLocationEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HiveLocationEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HiveLocationEntry value)  $default,){
final _that = this;
switch (_that) {
case _HiveLocationEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HiveLocationEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HiveLocationEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime movedAt,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HiveLocationEntry() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.movedAt,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime movedAt,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _HiveLocationEntry():
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.movedAt,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime movedAt,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _HiveLocationEntry() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.movedAt,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HiveLocationEntry implements HiveLocationEntry {
  const _HiveLocationEntry({required this.id, required this.orgId, required this.hiveId, required this.apiaryId, required this.movedAt, required this.createdAt, required this.updatedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _HiveLocationEntry.fromJson(Map<String, dynamic> json) => _$HiveLocationEntryFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String hiveId;
@override final  String apiaryId;
@override final  DateTime movedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of HiveLocationEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HiveLocationEntryCopyWith<_HiveLocationEntry> get copyWith => __$HiveLocationEntryCopyWithImpl<_HiveLocationEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HiveLocationEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HiveLocationEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.movedAt, movedAt) || other.movedAt == movedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,hiveId,apiaryId,movedAt,createdAt,updatedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'HiveLocationEntry(id: $id, orgId: $orgId, hiveId: $hiveId, apiaryId: $apiaryId, movedAt: $movedAt, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$HiveLocationEntryCopyWith<$Res> implements $HiveLocationEntryCopyWith<$Res> {
  factory _$HiveLocationEntryCopyWith(_HiveLocationEntry value, $Res Function(_HiveLocationEntry) _then) = __$HiveLocationEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, DateTime movedAt, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$HiveLocationEntryCopyWithImpl<$Res>
    implements _$HiveLocationEntryCopyWith<$Res> {
  __$HiveLocationEntryCopyWithImpl(this._self, this._then);

  final _HiveLocationEntry _self;
  final $Res Function(_HiveLocationEntry) _then;

/// Create a copy of HiveLocationEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? movedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_HiveLocationEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
