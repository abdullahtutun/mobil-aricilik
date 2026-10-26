// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harvest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Harvest {

 String get id; String get orgId;/// Hasadın yapıldığı arılık; kovanlar sonra taşınsa da değişmez.
 String get apiaryId; DateTime get harvestedAt; HoneyKind get honeyKind; HarvestUnit get unit;/// Alınan kat ya da çerçeve sayısı.
 int get unitCount;/// Süzülen bal, kilogram.
 double get netKg; DateTime get createdAt; DateTime get updatedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestCopyWith<Harvest> get copyWith => _$HarvestCopyWithImpl<Harvest>(this as Harvest, _$identity);

  /// Serializes this Harvest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Harvest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Harvest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.harvestedAt, _this.harvestedAt) || other.harvestedAt == _this.harvestedAt)&&(identical(other.honeyKind, _this.honeyKind) || other.honeyKind == _this.honeyKind)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.unitCount, _this.unitCount) || other.unitCount == _this.unitCount)&&(identical(other.netKg, _this.netKg) || other.netKg == _this.netKg)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Harvest;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.apiaryId,_this.harvestedAt,_this.honeyKind,_this.unit,_this.unitCount,_this.netKg,_this.createdAt,_this.updatedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Harvest;
  return 'Harvest(id: ${_this.id}, orgId: ${_this.orgId}, apiaryId: ${_this.apiaryId}, harvestedAt: ${_this.harvestedAt}, honeyKind: ${_this.honeyKind}, unit: ${_this.unit}, unitCount: ${_this.unitCount}, netKg: ${_this.netKg}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $HarvestCopyWith<$Res>  {
  factory $HarvestCopyWith(Harvest value, $Res Function(Harvest) _then) = _$HarvestCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String apiaryId, DateTime harvestedAt, HoneyKind honeyKind, HarvestUnit unit, int unitCount, double netKg, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$HarvestCopyWithImpl<$Res>
    implements $HarvestCopyWith<$Res> {
  _$HarvestCopyWithImpl(this._self, this._then);

  final Harvest _self;
  final $Res Function(Harvest) _then;

/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? apiaryId = null,Object? harvestedAt = null,Object? honeyKind = null,Object? unit = null,Object? unitCount = null,Object? netKg = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Harvest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,harvestedAt: null == harvestedAt ? _self.harvestedAt : harvestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,honeyKind: null == honeyKind ? _self.honeyKind : honeyKind // ignore: cast_nullable_to_non_nullable
as HoneyKind,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as HarvestUnit,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,netKg: null == netKg ? _self.netKg : netKg // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Harvest].
extension HarvestPatterns on Harvest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Harvest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Harvest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Harvest value)  $default,){
final _that = this;
switch (_that) {
case _Harvest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Harvest value)?  $default,){
final _that = this;
switch (_that) {
case _Harvest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String apiaryId,  DateTime harvestedAt,  HoneyKind honeyKind,  HarvestUnit unit,  int unitCount,  double netKg,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Harvest() when $default != null:
return $default(_that.id,_that.orgId,_that.apiaryId,_that.harvestedAt,_that.honeyKind,_that.unit,_that.unitCount,_that.netKg,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String apiaryId,  DateTime harvestedAt,  HoneyKind honeyKind,  HarvestUnit unit,  int unitCount,  double netKg,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Harvest():
return $default(_that.id,_that.orgId,_that.apiaryId,_that.harvestedAt,_that.honeyKind,_that.unit,_that.unitCount,_that.netKg,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String apiaryId,  DateTime harvestedAt,  HoneyKind honeyKind,  HarvestUnit unit,  int unitCount,  double netKg,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Harvest() when $default != null:
return $default(_that.id,_that.orgId,_that.apiaryId,_that.harvestedAt,_that.honeyKind,_that.unit,_that.unitCount,_that.netKg,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Harvest implements Harvest {
  const _Harvest({required this.id, required this.orgId, required this.apiaryId, required this.harvestedAt, required this.honeyKind, required this.unit, required this.unitCount, required this.netKg, required this.createdAt, required this.updatedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Harvest.fromJson(Map<String, dynamic> json) => _$HarvestFromJson(json);

@override final  String id;
@override final  String orgId;
/// Hasadın yapıldığı arılık; kovanlar sonra taşınsa da değişmez.
@override final  String apiaryId;
@override final  DateTime harvestedAt;
@override final  HoneyKind honeyKind;
@override final  HarvestUnit unit;
/// Alınan kat ya da çerçeve sayısı.
@override final  int unitCount;
/// Süzülen bal, kilogram.
@override final  double netKg;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestCopyWith<_Harvest> get copyWith => __$HarvestCopyWithImpl<_Harvest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarvestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Harvest&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.harvestedAt, harvestedAt) || other.harvestedAt == harvestedAt)&&(identical(other.honeyKind, honeyKind) || other.honeyKind == honeyKind)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.netKg, netKg) || other.netKg == netKg)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,apiaryId,harvestedAt,honeyKind,unit,unitCount,netKg,createdAt,updatedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Harvest(id: $id, orgId: $orgId, apiaryId: $apiaryId, harvestedAt: $harvestedAt, honeyKind: $honeyKind, unit: $unit, unitCount: $unitCount, netKg: $netKg, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$HarvestCopyWith<$Res> implements $HarvestCopyWith<$Res> {
  factory _$HarvestCopyWith(_Harvest value, $Res Function(_Harvest) _then) = __$HarvestCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String apiaryId, DateTime harvestedAt, HoneyKind honeyKind, HarvestUnit unit, int unitCount, double netKg, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$HarvestCopyWithImpl<$Res>
    implements _$HarvestCopyWith<$Res> {
  __$HarvestCopyWithImpl(this._self, this._then);

  final _Harvest _self;
  final $Res Function(_Harvest) _then;

/// Create a copy of Harvest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? apiaryId = null,Object? harvestedAt = null,Object? honeyKind = null,Object? unit = null,Object? unitCount = null,Object? netKg = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Harvest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,harvestedAt: null == harvestedAt ? _self.harvestedAt : harvestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,honeyKind: null == honeyKind ? _self.honeyKind : honeyKind // ignore: cast_nullable_to_non_nullable
as HoneyKind,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as HarvestUnit,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,netKg: null == netKg ? _self.netKg : netKg // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$HarvestHive {

 String get id; String get orgId; String get harvestId; String get hiveId; DateTime get createdAt; DateTime get updatedAt; String? get withdrawalTreatmentId; WithdrawalOverrideReason? get withdrawalOverrideReason; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of HarvestHive
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestHiveCopyWith<HarvestHive> get copyWith => _$HarvestHiveCopyWithImpl<HarvestHive>(this as HarvestHive, _$identity);

  /// Serializes this HarvestHive to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HarvestHive;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarvestHive&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.harvestId, _this.harvestId) || other.harvestId == _this.harvestId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.withdrawalTreatmentId, _this.withdrawalTreatmentId) || other.withdrawalTreatmentId == _this.withdrawalTreatmentId)&&(identical(other.withdrawalOverrideReason, _this.withdrawalOverrideReason) || other.withdrawalOverrideReason == _this.withdrawalOverrideReason)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HarvestHive;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.harvestId,_this.hiveId,_this.createdAt,_this.updatedAt,_this.withdrawalTreatmentId,_this.withdrawalOverrideReason,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as HarvestHive;
  return 'HarvestHive(id: ${_this.id}, orgId: ${_this.orgId}, harvestId: ${_this.harvestId}, hiveId: ${_this.hiveId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, withdrawalTreatmentId: ${_this.withdrawalTreatmentId}, withdrawalOverrideReason: ${_this.withdrawalOverrideReason}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $HarvestHiveCopyWith<$Res>  {
  factory $HarvestHiveCopyWith(HarvestHive value, $Res Function(HarvestHive) _then) = _$HarvestHiveCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String harvestId, String hiveId, DateTime createdAt, DateTime updatedAt, String? withdrawalTreatmentId, WithdrawalOverrideReason? withdrawalOverrideReason, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$HarvestHiveCopyWithImpl<$Res>
    implements $HarvestHiveCopyWith<$Res> {
  _$HarvestHiveCopyWithImpl(this._self, this._then);

  final HarvestHive _self;
  final $Res Function(HarvestHive) _then;

/// Create a copy of HarvestHive
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? harvestId = null,Object? hiveId = null,Object? createdAt = null,Object? updatedAt = null,Object? withdrawalTreatmentId = freezed,Object? withdrawalOverrideReason = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(HarvestHive(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,harvestId: null == harvestId ? _self.harvestId : harvestId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalTreatmentId: freezed == withdrawalTreatmentId ? _self.withdrawalTreatmentId : withdrawalTreatmentId // ignore: cast_nullable_to_non_nullable
as String?,withdrawalOverrideReason: freezed == withdrawalOverrideReason ? _self.withdrawalOverrideReason : withdrawalOverrideReason // ignore: cast_nullable_to_non_nullable
as WithdrawalOverrideReason?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HarvestHive].
extension HarvestHivePatterns on HarvestHive {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarvestHive value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarvestHive() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarvestHive value)  $default,){
final _that = this;
switch (_that) {
case _HarvestHive():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarvestHive value)?  $default,){
final _that = this;
switch (_that) {
case _HarvestHive() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String harvestId,  String hiveId,  DateTime createdAt,  DateTime updatedAt,  String? withdrawalTreatmentId,  WithdrawalOverrideReason? withdrawalOverrideReason,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarvestHive() when $default != null:
return $default(_that.id,_that.orgId,_that.harvestId,_that.hiveId,_that.createdAt,_that.updatedAt,_that.withdrawalTreatmentId,_that.withdrawalOverrideReason,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String harvestId,  String hiveId,  DateTime createdAt,  DateTime updatedAt,  String? withdrawalTreatmentId,  WithdrawalOverrideReason? withdrawalOverrideReason,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _HarvestHive():
return $default(_that.id,_that.orgId,_that.harvestId,_that.hiveId,_that.createdAt,_that.updatedAt,_that.withdrawalTreatmentId,_that.withdrawalOverrideReason,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String harvestId,  String hiveId,  DateTime createdAt,  DateTime updatedAt,  String? withdrawalTreatmentId,  WithdrawalOverrideReason? withdrawalOverrideReason,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _HarvestHive() when $default != null:
return $default(_that.id,_that.orgId,_that.harvestId,_that.hiveId,_that.createdAt,_that.updatedAt,_that.withdrawalTreatmentId,_that.withdrawalOverrideReason,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HarvestHive implements HarvestHive {
  const _HarvestHive({required this.id, required this.orgId, required this.harvestId, required this.hiveId, required this.createdAt, required this.updatedAt, this.withdrawalTreatmentId, this.withdrawalOverrideReason, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _HarvestHive.fromJson(Map<String, dynamic> json) => _$HarvestHiveFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String harvestId;
@override final  String hiveId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? withdrawalTreatmentId;
@override final  WithdrawalOverrideReason? withdrawalOverrideReason;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of HarvestHive
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestHiveCopyWith<_HarvestHive> get copyWith => __$HarvestHiveCopyWithImpl<_HarvestHive>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HarvestHiveToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarvestHive&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.harvestId, harvestId) || other.harvestId == harvestId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.withdrawalTreatmentId, withdrawalTreatmentId) || other.withdrawalTreatmentId == withdrawalTreatmentId)&&(identical(other.withdrawalOverrideReason, withdrawalOverrideReason) || other.withdrawalOverrideReason == withdrawalOverrideReason)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,harvestId,hiveId,createdAt,updatedAt,withdrawalTreatmentId,withdrawalOverrideReason,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'HarvestHive(id: $id, orgId: $orgId, harvestId: $harvestId, hiveId: $hiveId, createdAt: $createdAt, updatedAt: $updatedAt, withdrawalTreatmentId: $withdrawalTreatmentId, withdrawalOverrideReason: $withdrawalOverrideReason, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$HarvestHiveCopyWith<$Res> implements $HarvestHiveCopyWith<$Res> {
  factory _$HarvestHiveCopyWith(_HarvestHive value, $Res Function(_HarvestHive) _then) = __$HarvestHiveCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String harvestId, String hiveId, DateTime createdAt, DateTime updatedAt, String? withdrawalTreatmentId, WithdrawalOverrideReason? withdrawalOverrideReason, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$HarvestHiveCopyWithImpl<$Res>
    implements _$HarvestHiveCopyWith<$Res> {
  __$HarvestHiveCopyWithImpl(this._self, this._then);

  final _HarvestHive _self;
  final $Res Function(_HarvestHive) _then;

/// Create a copy of HarvestHive
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? harvestId = null,Object? hiveId = null,Object? createdAt = null,Object? updatedAt = null,Object? withdrawalTreatmentId = freezed,Object? withdrawalOverrideReason = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_HarvestHive(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,harvestId: null == harvestId ? _self.harvestId : harvestId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalTreatmentId: freezed == withdrawalTreatmentId ? _self.withdrawalTreatmentId : withdrawalTreatmentId // ignore: cast_nullable_to_non_nullable
as String?,withdrawalOverrideReason: freezed == withdrawalOverrideReason ? _self.withdrawalOverrideReason : withdrawalOverrideReason // ignore: cast_nullable_to_non_nullable
as WithdrawalOverrideReason?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
