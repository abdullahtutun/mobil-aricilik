// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hive_status_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HiveStatusEvent {

 String get id; String get orgId; String get hiveId; String get apiaryId; HiveStatus get fromStatus; HiveStatus get toStatus; DateTime get changedAt; DateTime get createdAt; DateTime get updatedAt;/// Yalnız söndü ya da kayboldu'da; boş: belirtilmemiş.
 HiveLossReason? get lossReason; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of HiveStatusEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HiveStatusEventCopyWith<HiveStatusEvent> get copyWith => _$HiveStatusEventCopyWithImpl<HiveStatusEvent>(this as HiveStatusEvent, _$identity);

  /// Serializes this HiveStatusEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HiveStatusEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HiveStatusEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.fromStatus, _this.fromStatus) || other.fromStatus == _this.fromStatus)&&(identical(other.toStatus, _this.toStatus) || other.toStatus == _this.toStatus)&&(identical(other.changedAt, _this.changedAt) || other.changedAt == _this.changedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.lossReason, _this.lossReason) || other.lossReason == _this.lossReason)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HiveStatusEvent;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.hiveId,_this.apiaryId,_this.fromStatus,_this.toStatus,_this.changedAt,_this.createdAt,_this.updatedAt,_this.lossReason,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as HiveStatusEvent;
  return 'HiveStatusEvent(id: ${_this.id}, orgId: ${_this.orgId}, hiveId: ${_this.hiveId}, apiaryId: ${_this.apiaryId}, fromStatus: ${_this.fromStatus}, toStatus: ${_this.toStatus}, changedAt: ${_this.changedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, lossReason: ${_this.lossReason}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $HiveStatusEventCopyWith<$Res>  {
  factory $HiveStatusEventCopyWith(HiveStatusEvent value, $Res Function(HiveStatusEvent) _then) = _$HiveStatusEventCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, HiveStatus fromStatus, HiveStatus toStatus, DateTime changedAt, DateTime createdAt, DateTime updatedAt, HiveLossReason? lossReason, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$HiveStatusEventCopyWithImpl<$Res>
    implements $HiveStatusEventCopyWith<$Res> {
  _$HiveStatusEventCopyWithImpl(this._self, this._then);

  final HiveStatusEvent _self;
  final $Res Function(HiveStatusEvent) _then;

/// Create a copy of HiveStatusEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? fromStatus = null,Object? toStatus = null,Object? changedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? lossReason = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(HiveStatusEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as HiveStatus,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as HiveStatus,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lossReason: freezed == lossReason ? _self.lossReason : lossReason // ignore: cast_nullable_to_non_nullable
as HiveLossReason?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HiveStatusEvent].
extension HiveStatusEventPatterns on HiveStatusEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HiveStatusEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HiveStatusEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HiveStatusEvent value)  $default,){
final _that = this;
switch (_that) {
case _HiveStatusEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HiveStatusEvent value)?  $default,){
final _that = this;
switch (_that) {
case _HiveStatusEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  HiveStatus fromStatus,  HiveStatus toStatus,  DateTime changedAt,  DateTime createdAt,  DateTime updatedAt,  HiveLossReason? lossReason,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HiveStatusEvent() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.fromStatus,_that.toStatus,_that.changedAt,_that.createdAt,_that.updatedAt,_that.lossReason,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  HiveStatus fromStatus,  HiveStatus toStatus,  DateTime changedAt,  DateTime createdAt,  DateTime updatedAt,  HiveLossReason? lossReason,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _HiveStatusEvent():
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.fromStatus,_that.toStatus,_that.changedAt,_that.createdAt,_that.updatedAt,_that.lossReason,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String hiveId,  String apiaryId,  HiveStatus fromStatus,  HiveStatus toStatus,  DateTime changedAt,  DateTime createdAt,  DateTime updatedAt,  HiveLossReason? lossReason,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _HiveStatusEvent() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.fromStatus,_that.toStatus,_that.changedAt,_that.createdAt,_that.updatedAt,_that.lossReason,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HiveStatusEvent implements HiveStatusEvent {
  const _HiveStatusEvent({required this.id, required this.orgId, required this.hiveId, required this.apiaryId, required this.fromStatus, required this.toStatus, required this.changedAt, required this.createdAt, required this.updatedAt, this.lossReason, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _HiveStatusEvent.fromJson(Map<String, dynamic> json) => _$HiveStatusEventFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String hiveId;
@override final  String apiaryId;
@override final  HiveStatus fromStatus;
@override final  HiveStatus toStatus;
@override final  DateTime changedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Yalnız söndü ya da kayboldu'da; boş: belirtilmemiş.
@override final  HiveLossReason? lossReason;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of HiveStatusEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HiveStatusEventCopyWith<_HiveStatusEvent> get copyWith => __$HiveStatusEventCopyWithImpl<_HiveStatusEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HiveStatusEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HiveStatusEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.fromStatus, fromStatus) || other.fromStatus == fromStatus)&&(identical(other.toStatus, toStatus) || other.toStatus == toStatus)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lossReason, lossReason) || other.lossReason == lossReason)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,hiveId,apiaryId,fromStatus,toStatus,changedAt,createdAt,updatedAt,lossReason,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'HiveStatusEvent(id: $id, orgId: $orgId, hiveId: $hiveId, apiaryId: $apiaryId, fromStatus: $fromStatus, toStatus: $toStatus, changedAt: $changedAt, createdAt: $createdAt, updatedAt: $updatedAt, lossReason: $lossReason, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$HiveStatusEventCopyWith<$Res> implements $HiveStatusEventCopyWith<$Res> {
  factory _$HiveStatusEventCopyWith(_HiveStatusEvent value, $Res Function(_HiveStatusEvent) _then) = __$HiveStatusEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, HiveStatus fromStatus, HiveStatus toStatus, DateTime changedAt, DateTime createdAt, DateTime updatedAt, HiveLossReason? lossReason, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$HiveStatusEventCopyWithImpl<$Res>
    implements _$HiveStatusEventCopyWith<$Res> {
  __$HiveStatusEventCopyWithImpl(this._self, this._then);

  final _HiveStatusEvent _self;
  final $Res Function(_HiveStatusEvent) _then;

/// Create a copy of HiveStatusEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? fromStatus = null,Object? toStatus = null,Object? changedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? lossReason = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_HiveStatusEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,fromStatus: null == fromStatus ? _self.fromStatus : fromStatus // ignore: cast_nullable_to_non_nullable
as HiveStatus,toStatus: null == toStatus ? _self.toStatus : toStatus // ignore: cast_nullable_to_non_nullable
as HiveStatus,changedAt: null == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lossReason: freezed == lossReason ? _self.lossReason : lossReason // ignore: cast_nullable_to_non_nullable
as HiveLossReason?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
