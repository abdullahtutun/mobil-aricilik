// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hive.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Hive {

 String get id; String get orgId;/// Arıcının verdiği numara ("101", "A-12"); tekrar edebilir.
 String get number; HiveType get type;/// Güncel arılık; geçmişi `hive_location_history`'de.
 String get apiaryId; DateTime get createdAt; DateTime get updatedAt; HiveStatus get status;/// Önceden basılmış QR ya da NFC etiketin kodu.
 String? get tagCode; String? get queenId; int get boxCount; int? get frameCount; HiveSource? get source;/// Kutunun rengi ya da üstündeki işaret.
 String? get marking; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Hive
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HiveCopyWith<Hive> get copyWith => _$HiveCopyWithImpl<Hive>(this as Hive, _$identity);

  /// Serializes this Hive to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Hive;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Hive&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.tagCode, _this.tagCode) || other.tagCode == _this.tagCode)&&(identical(other.queenId, _this.queenId) || other.queenId == _this.queenId)&&(identical(other.boxCount, _this.boxCount) || other.boxCount == _this.boxCount)&&(identical(other.frameCount, _this.frameCount) || other.frameCount == _this.frameCount)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.marking, _this.marking) || other.marking == _this.marking)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Hive;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.number,_this.type,_this.apiaryId,_this.createdAt,_this.updatedAt,_this.status,_this.tagCode,_this.queenId,_this.boxCount,_this.frameCount,_this.source,_this.marking,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Hive;
  return 'Hive(id: ${_this.id}, orgId: ${_this.orgId}, number: ${_this.number}, type: ${_this.type}, apiaryId: ${_this.apiaryId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, status: ${_this.status}, tagCode: ${_this.tagCode}, queenId: ${_this.queenId}, boxCount: ${_this.boxCount}, frameCount: ${_this.frameCount}, source: ${_this.source}, marking: ${_this.marking}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $HiveCopyWith<$Res>  {
  factory $HiveCopyWith(Hive value, $Res Function(Hive) _then) = _$HiveCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String number, HiveType type, String apiaryId, DateTime createdAt, DateTime updatedAt, HiveStatus status, String? tagCode, String? queenId, int boxCount, int? frameCount, HiveSource? source, String? marking, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$HiveCopyWithImpl<$Res>
    implements $HiveCopyWith<$Res> {
  _$HiveCopyWithImpl(this._self, this._then);

  final Hive _self;
  final $Res Function(Hive) _then;

/// Create a copy of Hive
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? number = null,Object? type = null,Object? apiaryId = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? tagCode = freezed,Object? queenId = freezed,Object? boxCount = null,Object? frameCount = freezed,Object? source = freezed,Object? marking = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Hive(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HiveType,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HiveStatus,tagCode: freezed == tagCode ? _self.tagCode : tagCode // ignore: cast_nullable_to_non_nullable
as String?,queenId: freezed == queenId ? _self.queenId : queenId // ignore: cast_nullable_to_non_nullable
as String?,boxCount: null == boxCount ? _self.boxCount : boxCount // ignore: cast_nullable_to_non_nullable
as int,frameCount: freezed == frameCount ? _self.frameCount : frameCount // ignore: cast_nullable_to_non_nullable
as int?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HiveSource?,marking: freezed == marking ? _self.marking : marking // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Hive].
extension HivePatterns on Hive {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Hive value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hive() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Hive value)  $default,){
final _that = this;
switch (_that) {
case _Hive():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Hive value)?  $default,){
final _that = this;
switch (_that) {
case _Hive() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String number,  HiveType type,  String apiaryId,  DateTime createdAt,  DateTime updatedAt,  HiveStatus status,  String? tagCode,  String? queenId,  int boxCount,  int? frameCount,  HiveSource? source,  String? marking,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hive() when $default != null:
return $default(_that.id,_that.orgId,_that.number,_that.type,_that.apiaryId,_that.createdAt,_that.updatedAt,_that.status,_that.tagCode,_that.queenId,_that.boxCount,_that.frameCount,_that.source,_that.marking,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String number,  HiveType type,  String apiaryId,  DateTime createdAt,  DateTime updatedAt,  HiveStatus status,  String? tagCode,  String? queenId,  int boxCount,  int? frameCount,  HiveSource? source,  String? marking,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Hive():
return $default(_that.id,_that.orgId,_that.number,_that.type,_that.apiaryId,_that.createdAt,_that.updatedAt,_that.status,_that.tagCode,_that.queenId,_that.boxCount,_that.frameCount,_that.source,_that.marking,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String number,  HiveType type,  String apiaryId,  DateTime createdAt,  DateTime updatedAt,  HiveStatus status,  String? tagCode,  String? queenId,  int boxCount,  int? frameCount,  HiveSource? source,  String? marking,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Hive() when $default != null:
return $default(_that.id,_that.orgId,_that.number,_that.type,_that.apiaryId,_that.createdAt,_that.updatedAt,_that.status,_that.tagCode,_that.queenId,_that.boxCount,_that.frameCount,_that.source,_that.marking,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Hive implements Hive {
  const _Hive({required this.id, required this.orgId, required this.number, required this.type, required this.apiaryId, required this.createdAt, required this.updatedAt, this.status = HiveStatus.active, this.tagCode, this.queenId, this.boxCount = 1, this.frameCount, this.source, this.marking, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Hive.fromJson(Map<String, dynamic> json) => _$HiveFromJson(json);

@override final  String id;
@override final  String orgId;
/// Arıcının verdiği numara ("101", "A-12"); tekrar edebilir.
@override final  String number;
@override final  HiveType type;
/// Güncel arılık; geçmişi `hive_location_history`'de.
@override final  String apiaryId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  HiveStatus status;
/// Önceden basılmış QR ya da NFC etiketin kodu.
@override final  String? tagCode;
@override final  String? queenId;
@override@JsonKey() final  int boxCount;
@override final  int? frameCount;
@override final  HiveSource? source;
/// Kutunun rengi ya da üstündeki işaret.
@override final  String? marking;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Hive
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HiveCopyWith<_Hive> get copyWith => __$HiveCopyWithImpl<_Hive>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HiveToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hive&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.number, number) || other.number == number)&&(identical(other.type, type) || other.type == type)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.tagCode, tagCode) || other.tagCode == tagCode)&&(identical(other.queenId, queenId) || other.queenId == queenId)&&(identical(other.boxCount, boxCount) || other.boxCount == boxCount)&&(identical(other.frameCount, frameCount) || other.frameCount == frameCount)&&(identical(other.source, source) || other.source == source)&&(identical(other.marking, marking) || other.marking == marking)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,number,type,apiaryId,createdAt,updatedAt,status,tagCode,queenId,boxCount,frameCount,source,marking,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Hive(id: $id, orgId: $orgId, number: $number, type: $type, apiaryId: $apiaryId, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, tagCode: $tagCode, queenId: $queenId, boxCount: $boxCount, frameCount: $frameCount, source: $source, marking: $marking, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$HiveCopyWith<$Res> implements $HiveCopyWith<$Res> {
  factory _$HiveCopyWith(_Hive value, $Res Function(_Hive) _then) = __$HiveCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String number, HiveType type, String apiaryId, DateTime createdAt, DateTime updatedAt, HiveStatus status, String? tagCode, String? queenId, int boxCount, int? frameCount, HiveSource? source, String? marking, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$HiveCopyWithImpl<$Res>
    implements _$HiveCopyWith<$Res> {
  __$HiveCopyWithImpl(this._self, this._then);

  final _Hive _self;
  final $Res Function(_Hive) _then;

/// Create a copy of Hive
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? number = null,Object? type = null,Object? apiaryId = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? tagCode = freezed,Object? queenId = freezed,Object? boxCount = null,Object? frameCount = freezed,Object? source = freezed,Object? marking = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Hive(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HiveType,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HiveStatus,tagCode: freezed == tagCode ? _self.tagCode : tagCode // ignore: cast_nullable_to_non_nullable
as String?,queenId: freezed == queenId ? _self.queenId : queenId // ignore: cast_nullable_to_non_nullable
as String?,boxCount: null == boxCount ? _self.boxCount : boxCount // ignore: cast_nullable_to_non_nullable
as int,frameCount: freezed == frameCount ? _self.frameCount : frameCount // ignore: cast_nullable_to_non_nullable
as int?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HiveSource?,marking: freezed == marking ? _self.marking : marking // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
