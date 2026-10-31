// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transport.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transport {

 String get id; String get orgId; String get sourceApiaryId; String get destinationApiaryId; DateTime get createdAt; DateTime get updatedAt;/// Araçların adları, eklenme sırasıyla ("Kamyon 1", "Kamyon 2").
 List<String> get vehicles; TransportStatus get status;/// Taşımanın götürdüğü göç durağı; plansız taşımada null.
 String? get migrationStopId;/// İndirmenin bittiği an.
 DateTime? get completedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Transport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransportCopyWith<Transport> get copyWith => _$TransportCopyWithImpl<Transport>(this as Transport, _$identity);

  /// Serializes this Transport to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Transport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transport&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.sourceApiaryId, _this.sourceApiaryId) || other.sourceApiaryId == _this.sourceApiaryId)&&(identical(other.destinationApiaryId, _this.destinationApiaryId) || other.destinationApiaryId == _this.destinationApiaryId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&const DeepCollectionEquality().equals(other.vehicles, _this.vehicles)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.migrationStopId, _this.migrationStopId) || other.migrationStopId == _this.migrationStopId)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Transport;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.sourceApiaryId,_this.destinationApiaryId,_this.createdAt,_this.updatedAt,const DeepCollectionEquality().hash(_this.vehicles),_this.status,_this.migrationStopId,_this.completedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Transport;
  return 'Transport(id: ${_this.id}, orgId: ${_this.orgId}, sourceApiaryId: ${_this.sourceApiaryId}, destinationApiaryId: ${_this.destinationApiaryId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, vehicles: ${_this.vehicles}, status: ${_this.status}, migrationStopId: ${_this.migrationStopId}, completedAt: ${_this.completedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $TransportCopyWith<$Res>  {
  factory $TransportCopyWith(Transport value, $Res Function(Transport) _then) = _$TransportCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String sourceApiaryId, String destinationApiaryId, DateTime createdAt, DateTime updatedAt, List<String> vehicles, TransportStatus status, String? migrationStopId, DateTime? completedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$TransportCopyWithImpl<$Res>
    implements $TransportCopyWith<$Res> {
  _$TransportCopyWithImpl(this._self, this._then);

  final Transport _self;
  final $Res Function(Transport) _then;

/// Create a copy of Transport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? sourceApiaryId = null,Object? destinationApiaryId = null,Object? createdAt = null,Object? updatedAt = null,Object? vehicles = null,Object? status = null,Object? migrationStopId = freezed,Object? completedAt = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Transport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,sourceApiaryId: null == sourceApiaryId ? _self.sourceApiaryId : sourceApiaryId // ignore: cast_nullable_to_non_nullable
as String,destinationApiaryId: null == destinationApiaryId ? _self.destinationApiaryId : destinationApiaryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,vehicles: null == vehicles ? _self.vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransportStatus,migrationStopId: freezed == migrationStopId ? _self.migrationStopId : migrationStopId // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transport].
extension TransportPatterns on Transport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transport value)  $default,){
final _that = this;
switch (_that) {
case _Transport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transport value)?  $default,){
final _that = this;
switch (_that) {
case _Transport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String sourceApiaryId,  String destinationApiaryId,  DateTime createdAt,  DateTime updatedAt,  List<String> vehicles,  TransportStatus status,  String? migrationStopId,  DateTime? completedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transport() when $default != null:
return $default(_that.id,_that.orgId,_that.sourceApiaryId,_that.destinationApiaryId,_that.createdAt,_that.updatedAt,_that.vehicles,_that.status,_that.migrationStopId,_that.completedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String sourceApiaryId,  String destinationApiaryId,  DateTime createdAt,  DateTime updatedAt,  List<String> vehicles,  TransportStatus status,  String? migrationStopId,  DateTime? completedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Transport():
return $default(_that.id,_that.orgId,_that.sourceApiaryId,_that.destinationApiaryId,_that.createdAt,_that.updatedAt,_that.vehicles,_that.status,_that.migrationStopId,_that.completedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String sourceApiaryId,  String destinationApiaryId,  DateTime createdAt,  DateTime updatedAt,  List<String> vehicles,  TransportStatus status,  String? migrationStopId,  DateTime? completedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Transport() when $default != null:
return $default(_that.id,_that.orgId,_that.sourceApiaryId,_that.destinationApiaryId,_that.createdAt,_that.updatedAt,_that.vehicles,_that.status,_that.migrationStopId,_that.completedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transport implements Transport {
  const _Transport({required this.id, required this.orgId, required this.sourceApiaryId, required this.destinationApiaryId, required this.createdAt, required this.updatedAt,  List<String> vehicles = const <String>[], this.status = TransportStatus.loading, this.migrationStopId, this.completedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq}): _vehicles = vehicles;
  factory _Transport.fromJson(Map<String, dynamic> json) => _$TransportFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String sourceApiaryId;
@override final  String destinationApiaryId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Araçların adları, eklenme sırasıyla ("Kamyon 1", "Kamyon 2").
 final  List<String> _vehicles;
/// Araçların adları, eklenme sırasıyla ("Kamyon 1", "Kamyon 2").
@override@JsonKey() List<String> get vehicles {
  if (_vehicles is EqualUnmodifiableListView) return _vehicles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vehicles);
}

@override@JsonKey() final  TransportStatus status;
/// Taşımanın götürdüğü göç durağı; plansız taşımada null.
@override final  String? migrationStopId;
/// İndirmenin bittiği an.
@override final  DateTime? completedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Transport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransportCopyWith<_Transport> get copyWith => __$TransportCopyWithImpl<_Transport>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransportToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transport&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.sourceApiaryId, sourceApiaryId) || other.sourceApiaryId == sourceApiaryId)&&(identical(other.destinationApiaryId, destinationApiaryId) || other.destinationApiaryId == destinationApiaryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.vehicles, _vehicles)&&(identical(other.status, status) || other.status == status)&&(identical(other.migrationStopId, migrationStopId) || other.migrationStopId == migrationStopId)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,sourceApiaryId,destinationApiaryId,createdAt,updatedAt,const DeepCollectionEquality().hash(_vehicles),status,migrationStopId,completedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Transport(id: $id, orgId: $orgId, sourceApiaryId: $sourceApiaryId, destinationApiaryId: $destinationApiaryId, createdAt: $createdAt, updatedAt: $updatedAt, vehicles: $vehicles, status: $status, migrationStopId: $migrationStopId, completedAt: $completedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$TransportCopyWith<$Res> implements $TransportCopyWith<$Res> {
  factory _$TransportCopyWith(_Transport value, $Res Function(_Transport) _then) = __$TransportCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String sourceApiaryId, String destinationApiaryId, DateTime createdAt, DateTime updatedAt, List<String> vehicles, TransportStatus status, String? migrationStopId, DateTime? completedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$TransportCopyWithImpl<$Res>
    implements _$TransportCopyWith<$Res> {
  __$TransportCopyWithImpl(this._self, this._then);

  final _Transport _self;
  final $Res Function(_Transport) _then;

/// Create a copy of Transport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? sourceApiaryId = null,Object? destinationApiaryId = null,Object? createdAt = null,Object? updatedAt = null,Object? vehicles = null,Object? status = null,Object? migrationStopId = freezed,Object? completedAt = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Transport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,sourceApiaryId: null == sourceApiaryId ? _self.sourceApiaryId : sourceApiaryId // ignore: cast_nullable_to_non_nullable
as String,destinationApiaryId: null == destinationApiaryId ? _self.destinationApiaryId : destinationApiaryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,vehicles: null == vehicles ? _self._vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransportStatus,migrationStopId: freezed == migrationStopId ? _self.migrationStopId : migrationStopId // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$TransportItem {

 String get id; String get orgId; String get transportId; String get hiveId;/// Yüklendiği aracın adı.
 String get vehicle; DateTime get loadedAt; DateTime get createdAt; DateTime get updatedAt;/// Hedefte indirilirken okutulduğu an; indirilmediyse null.
 DateTime? get unloadedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of TransportItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransportItemCopyWith<TransportItem> get copyWith => _$TransportItemCopyWithImpl<TransportItem>(this as TransportItem, _$identity);

  /// Serializes this TransportItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TransportItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransportItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.transportId, _this.transportId) || other.transportId == _this.transportId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.vehicle, _this.vehicle) || other.vehicle == _this.vehicle)&&(identical(other.loadedAt, _this.loadedAt) || other.loadedAt == _this.loadedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.unloadedAt, _this.unloadedAt) || other.unloadedAt == _this.unloadedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TransportItem;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.transportId,_this.hiveId,_this.vehicle,_this.loadedAt,_this.createdAt,_this.updatedAt,_this.unloadedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as TransportItem;
  return 'TransportItem(id: ${_this.id}, orgId: ${_this.orgId}, transportId: ${_this.transportId}, hiveId: ${_this.hiveId}, vehicle: ${_this.vehicle}, loadedAt: ${_this.loadedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, unloadedAt: ${_this.unloadedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $TransportItemCopyWith<$Res>  {
  factory $TransportItemCopyWith(TransportItem value, $Res Function(TransportItem) _then) = _$TransportItemCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String transportId, String hiveId, String vehicle, DateTime loadedAt, DateTime createdAt, DateTime updatedAt, DateTime? unloadedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$TransportItemCopyWithImpl<$Res>
    implements $TransportItemCopyWith<$Res> {
  _$TransportItemCopyWithImpl(this._self, this._then);

  final TransportItem _self;
  final $Res Function(TransportItem) _then;

/// Create a copy of TransportItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? transportId = null,Object? hiveId = null,Object? vehicle = null,Object? loadedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? unloadedAt = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(TransportItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,transportId: null == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as String,loadedAt: null == loadedAt ? _self.loadedAt : loadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,unloadedAt: freezed == unloadedAt ? _self.unloadedAt : unloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransportItem].
extension TransportItemPatterns on TransportItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransportItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransportItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransportItem value)  $default,){
final _that = this;
switch (_that) {
case _TransportItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransportItem value)?  $default,){
final _that = this;
switch (_that) {
case _TransportItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String transportId,  String hiveId,  String vehicle,  DateTime loadedAt,  DateTime createdAt,  DateTime updatedAt,  DateTime? unloadedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransportItem() when $default != null:
return $default(_that.id,_that.orgId,_that.transportId,_that.hiveId,_that.vehicle,_that.loadedAt,_that.createdAt,_that.updatedAt,_that.unloadedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String transportId,  String hiveId,  String vehicle,  DateTime loadedAt,  DateTime createdAt,  DateTime updatedAt,  DateTime? unloadedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _TransportItem():
return $default(_that.id,_that.orgId,_that.transportId,_that.hiveId,_that.vehicle,_that.loadedAt,_that.createdAt,_that.updatedAt,_that.unloadedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String transportId,  String hiveId,  String vehicle,  DateTime loadedAt,  DateTime createdAt,  DateTime updatedAt,  DateTime? unloadedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _TransportItem() when $default != null:
return $default(_that.id,_that.orgId,_that.transportId,_that.hiveId,_that.vehicle,_that.loadedAt,_that.createdAt,_that.updatedAt,_that.unloadedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransportItem implements TransportItem {
  const _TransportItem({required this.id, required this.orgId, required this.transportId, required this.hiveId, required this.vehicle, required this.loadedAt, required this.createdAt, required this.updatedAt, this.unloadedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _TransportItem.fromJson(Map<String, dynamic> json) => _$TransportItemFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String transportId;
@override final  String hiveId;
/// Yüklendiği aracın adı.
@override final  String vehicle;
@override final  DateTime loadedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Hedefte indirilirken okutulduğu an; indirilmediyse null.
@override final  DateTime? unloadedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of TransportItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransportItemCopyWith<_TransportItem> get copyWith => __$TransportItemCopyWithImpl<_TransportItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransportItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransportItem&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.transportId, transportId) || other.transportId == transportId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.loadedAt, loadedAt) || other.loadedAt == loadedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.unloadedAt, unloadedAt) || other.unloadedAt == unloadedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,transportId,hiveId,vehicle,loadedAt,createdAt,updatedAt,unloadedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'TransportItem(id: $id, orgId: $orgId, transportId: $transportId, hiveId: $hiveId, vehicle: $vehicle, loadedAt: $loadedAt, createdAt: $createdAt, updatedAt: $updatedAt, unloadedAt: $unloadedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$TransportItemCopyWith<$Res> implements $TransportItemCopyWith<$Res> {
  factory _$TransportItemCopyWith(_TransportItem value, $Res Function(_TransportItem) _then) = __$TransportItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String transportId, String hiveId, String vehicle, DateTime loadedAt, DateTime createdAt, DateTime updatedAt, DateTime? unloadedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$TransportItemCopyWithImpl<$Res>
    implements _$TransportItemCopyWith<$Res> {
  __$TransportItemCopyWithImpl(this._self, this._then);

  final _TransportItem _self;
  final $Res Function(_TransportItem) _then;

/// Create a copy of TransportItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? transportId = null,Object? hiveId = null,Object? vehicle = null,Object? loadedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? unloadedAt = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_TransportItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,transportId: null == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,vehicle: null == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as String,loadedAt: null == loadedAt ? _self.loadedAt : loadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,unloadedAt: freezed == unloadedAt ? _self.unloadedAt : unloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
