// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queen_rearing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueenRearingBatch {

 String get id; String get orgId;/// İşletmenin verdiği seri numarası ("Seri 3"); tekil değil.
 int get number;/// Larva aktarma günü.
@DateOnlyJsonConverter() DateTime get graftedOn;/// Aktarılan larva sayısı.
 int get graftedCount; DateTime get createdAt; DateTime get updatedAt;/// Larvaların alındığı anne ana; bilinmiyorsa boş.
 String? get motherQueenId;/// G1'de kabul edilen meme; sayılmadıysa boş. Aktarılandan fazla
/// olamaz.
 int? get acceptedCount; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of QueenRearingBatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueenRearingBatchCopyWith<QueenRearingBatch> get copyWith => _$QueenRearingBatchCopyWithImpl<QueenRearingBatch>(this as QueenRearingBatch, _$identity);

  /// Serializes this QueenRearingBatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QueenRearingBatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueenRearingBatch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.graftedOn, _this.graftedOn) || other.graftedOn == _this.graftedOn)&&(identical(other.graftedCount, _this.graftedCount) || other.graftedCount == _this.graftedCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.motherQueenId, _this.motherQueenId) || other.motherQueenId == _this.motherQueenId)&&(identical(other.acceptedCount, _this.acceptedCount) || other.acceptedCount == _this.acceptedCount)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QueenRearingBatch;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.number,_this.graftedOn,_this.graftedCount,_this.createdAt,_this.updatedAt,_this.motherQueenId,_this.acceptedCount,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as QueenRearingBatch;
  return 'QueenRearingBatch(id: ${_this.id}, orgId: ${_this.orgId}, number: ${_this.number}, graftedOn: ${_this.graftedOn}, graftedCount: ${_this.graftedCount}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, motherQueenId: ${_this.motherQueenId}, acceptedCount: ${_this.acceptedCount}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $QueenRearingBatchCopyWith<$Res>  {
  factory $QueenRearingBatchCopyWith(QueenRearingBatch value, $Res Function(QueenRearingBatch) _then) = _$QueenRearingBatchCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, int number,@DateOnlyJsonConverter() DateTime graftedOn, int graftedCount, DateTime createdAt, DateTime updatedAt, String? motherQueenId, int? acceptedCount, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$QueenRearingBatchCopyWithImpl<$Res>
    implements $QueenRearingBatchCopyWith<$Res> {
  _$QueenRearingBatchCopyWithImpl(this._self, this._then);

  final QueenRearingBatch _self;
  final $Res Function(QueenRearingBatch) _then;

/// Create a copy of QueenRearingBatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? number = null,Object? graftedOn = null,Object? graftedCount = null,Object? createdAt = null,Object? updatedAt = null,Object? motherQueenId = freezed,Object? acceptedCount = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(QueenRearingBatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,graftedOn: null == graftedOn ? _self.graftedOn : graftedOn // ignore: cast_nullable_to_non_nullable
as DateTime,graftedCount: null == graftedCount ? _self.graftedCount : graftedCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,acceptedCount: freezed == acceptedCount ? _self.acceptedCount : acceptedCount // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueenRearingBatch].
extension QueenRearingBatchPatterns on QueenRearingBatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueenRearingBatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueenRearingBatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueenRearingBatch value)  $default,){
final _that = this;
switch (_that) {
case _QueenRearingBatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueenRearingBatch value)?  $default,){
final _that = this;
switch (_that) {
case _QueenRearingBatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  int number, @DateOnlyJsonConverter()  DateTime graftedOn,  int graftedCount,  DateTime createdAt,  DateTime updatedAt,  String? motherQueenId,  int? acceptedCount,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueenRearingBatch() when $default != null:
return $default(_that.id,_that.orgId,_that.number,_that.graftedOn,_that.graftedCount,_that.createdAt,_that.updatedAt,_that.motherQueenId,_that.acceptedCount,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  int number, @DateOnlyJsonConverter()  DateTime graftedOn,  int graftedCount,  DateTime createdAt,  DateTime updatedAt,  String? motherQueenId,  int? acceptedCount,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _QueenRearingBatch():
return $default(_that.id,_that.orgId,_that.number,_that.graftedOn,_that.graftedCount,_that.createdAt,_that.updatedAt,_that.motherQueenId,_that.acceptedCount,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  int number, @DateOnlyJsonConverter()  DateTime graftedOn,  int graftedCount,  DateTime createdAt,  DateTime updatedAt,  String? motherQueenId,  int? acceptedCount,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _QueenRearingBatch() when $default != null:
return $default(_that.id,_that.orgId,_that.number,_that.graftedOn,_that.graftedCount,_that.createdAt,_that.updatedAt,_that.motherQueenId,_that.acceptedCount,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueenRearingBatch implements QueenRearingBatch {
  const _QueenRearingBatch({required this.id, required this.orgId, required this.number, @DateOnlyJsonConverter() required this.graftedOn, required this.graftedCount, required this.createdAt, required this.updatedAt, this.motherQueenId, this.acceptedCount, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _QueenRearingBatch.fromJson(Map<String, dynamic> json) => _$QueenRearingBatchFromJson(json);

@override final  String id;
@override final  String orgId;
/// İşletmenin verdiği seri numarası ("Seri 3"); tekil değil.
@override final  int number;
/// Larva aktarma günü.
@override@DateOnlyJsonConverter() final  DateTime graftedOn;
/// Aktarılan larva sayısı.
@override final  int graftedCount;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Larvaların alındığı anne ana; bilinmiyorsa boş.
@override final  String? motherQueenId;
/// G1'de kabul edilen meme; sayılmadıysa boş. Aktarılandan fazla
/// olamaz.
@override final  int? acceptedCount;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of QueenRearingBatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueenRearingBatchCopyWith<_QueenRearingBatch> get copyWith => __$QueenRearingBatchCopyWithImpl<_QueenRearingBatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueenRearingBatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueenRearingBatch&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.number, number) || other.number == number)&&(identical(other.graftedOn, graftedOn) || other.graftedOn == graftedOn)&&(identical(other.graftedCount, graftedCount) || other.graftedCount == graftedCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.motherQueenId, motherQueenId) || other.motherQueenId == motherQueenId)&&(identical(other.acceptedCount, acceptedCount) || other.acceptedCount == acceptedCount)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,number,graftedOn,graftedCount,createdAt,updatedAt,motherQueenId,acceptedCount,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'QueenRearingBatch(id: $id, orgId: $orgId, number: $number, graftedOn: $graftedOn, graftedCount: $graftedCount, createdAt: $createdAt, updatedAt: $updatedAt, motherQueenId: $motherQueenId, acceptedCount: $acceptedCount, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$QueenRearingBatchCopyWith<$Res> implements $QueenRearingBatchCopyWith<$Res> {
  factory _$QueenRearingBatchCopyWith(_QueenRearingBatch value, $Res Function(_QueenRearingBatch) _then) = __$QueenRearingBatchCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, int number,@DateOnlyJsonConverter() DateTime graftedOn, int graftedCount, DateTime createdAt, DateTime updatedAt, String? motherQueenId, int? acceptedCount, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$QueenRearingBatchCopyWithImpl<$Res>
    implements _$QueenRearingBatchCopyWith<$Res> {
  __$QueenRearingBatchCopyWithImpl(this._self, this._then);

  final _QueenRearingBatch _self;
  final $Res Function(_QueenRearingBatch) _then;

/// Create a copy of QueenRearingBatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? number = null,Object? graftedOn = null,Object? graftedCount = null,Object? createdAt = null,Object? updatedAt = null,Object? motherQueenId = freezed,Object? acceptedCount = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_QueenRearingBatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,graftedOn: null == graftedOn ? _self.graftedOn : graftedOn // ignore: cast_nullable_to_non_nullable
as DateTime,graftedCount: null == graftedCount ? _self.graftedCount : graftedCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,acceptedCount: freezed == acceptedCount ? _self.acceptedCount : acceptedCount // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$MatingNuc {

 String get id; String get orgId;/// Kutunun numarası ("1", "K-12").
 String get number; String get apiaryId; DateTime get createdAt; DateTime get updatedAt; MatingNucStatus get status;/// Kutudaki memenin serisi; boş kutuda boş olabilir.
 String? get rearingBatchId;/// Kutudan kovana verilen ananın kaydı; yalnız [MatingNucStatus.given]
/// durumunda dolu.
 String? get queenId; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of MatingNuc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatingNucCopyWith<MatingNuc> get copyWith => _$MatingNucCopyWithImpl<MatingNuc>(this as MatingNuc, _$identity);

  /// Serializes this MatingNuc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MatingNuc;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatingNuc&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.rearingBatchId, _this.rearingBatchId) || other.rearingBatchId == _this.rearingBatchId)&&(identical(other.queenId, _this.queenId) || other.queenId == _this.queenId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MatingNuc;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.number,_this.apiaryId,_this.createdAt,_this.updatedAt,_this.status,_this.rearingBatchId,_this.queenId,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as MatingNuc;
  return 'MatingNuc(id: ${_this.id}, orgId: ${_this.orgId}, number: ${_this.number}, apiaryId: ${_this.apiaryId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, status: ${_this.status}, rearingBatchId: ${_this.rearingBatchId}, queenId: ${_this.queenId}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $MatingNucCopyWith<$Res>  {
  factory $MatingNucCopyWith(MatingNuc value, $Res Function(MatingNuc) _then) = _$MatingNucCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String number, String apiaryId, DateTime createdAt, DateTime updatedAt, MatingNucStatus status, String? rearingBatchId, String? queenId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$MatingNucCopyWithImpl<$Res>
    implements $MatingNucCopyWith<$Res> {
  _$MatingNucCopyWithImpl(this._self, this._then);

  final MatingNuc _self;
  final $Res Function(MatingNuc) _then;

/// Create a copy of MatingNuc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? number = null,Object? apiaryId = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? rearingBatchId = freezed,Object? queenId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(MatingNuc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MatingNucStatus,rearingBatchId: freezed == rearingBatchId ? _self.rearingBatchId : rearingBatchId // ignore: cast_nullable_to_non_nullable
as String?,queenId: freezed == queenId ? _self.queenId : queenId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MatingNuc].
extension MatingNucPatterns on MatingNuc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatingNuc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatingNuc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatingNuc value)  $default,){
final _that = this;
switch (_that) {
case _MatingNuc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatingNuc value)?  $default,){
final _that = this;
switch (_that) {
case _MatingNuc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String number,  String apiaryId,  DateTime createdAt,  DateTime updatedAt,  MatingNucStatus status,  String? rearingBatchId,  String? queenId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatingNuc() when $default != null:
return $default(_that.id,_that.orgId,_that.number,_that.apiaryId,_that.createdAt,_that.updatedAt,_that.status,_that.rearingBatchId,_that.queenId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String number,  String apiaryId,  DateTime createdAt,  DateTime updatedAt,  MatingNucStatus status,  String? rearingBatchId,  String? queenId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _MatingNuc():
return $default(_that.id,_that.orgId,_that.number,_that.apiaryId,_that.createdAt,_that.updatedAt,_that.status,_that.rearingBatchId,_that.queenId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String number,  String apiaryId,  DateTime createdAt,  DateTime updatedAt,  MatingNucStatus status,  String? rearingBatchId,  String? queenId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _MatingNuc() when $default != null:
return $default(_that.id,_that.orgId,_that.number,_that.apiaryId,_that.createdAt,_that.updatedAt,_that.status,_that.rearingBatchId,_that.queenId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatingNuc implements MatingNuc {
  const _MatingNuc({required this.id, required this.orgId, required this.number, required this.apiaryId, required this.createdAt, required this.updatedAt, this.status = MatingNucStatus.empty, this.rearingBatchId, this.queenId, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _MatingNuc.fromJson(Map<String, dynamic> json) => _$MatingNucFromJson(json);

@override final  String id;
@override final  String orgId;
/// Kutunun numarası ("1", "K-12").
@override final  String number;
@override final  String apiaryId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  MatingNucStatus status;
/// Kutudaki memenin serisi; boş kutuda boş olabilir.
@override final  String? rearingBatchId;
/// Kutudan kovana verilen ananın kaydı; yalnız [MatingNucStatus.given]
/// durumunda dolu.
@override final  String? queenId;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of MatingNuc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatingNucCopyWith<_MatingNuc> get copyWith => __$MatingNucCopyWithImpl<_MatingNuc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatingNucToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatingNuc&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.number, number) || other.number == number)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.rearingBatchId, rearingBatchId) || other.rearingBatchId == rearingBatchId)&&(identical(other.queenId, queenId) || other.queenId == queenId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,number,apiaryId,createdAt,updatedAt,status,rearingBatchId,queenId,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'MatingNuc(id: $id, orgId: $orgId, number: $number, apiaryId: $apiaryId, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, rearingBatchId: $rearingBatchId, queenId: $queenId, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$MatingNucCopyWith<$Res> implements $MatingNucCopyWith<$Res> {
  factory _$MatingNucCopyWith(_MatingNuc value, $Res Function(_MatingNuc) _then) = __$MatingNucCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String number, String apiaryId, DateTime createdAt, DateTime updatedAt, MatingNucStatus status, String? rearingBatchId, String? queenId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$MatingNucCopyWithImpl<$Res>
    implements _$MatingNucCopyWith<$Res> {
  __$MatingNucCopyWithImpl(this._self, this._then);

  final _MatingNuc _self;
  final $Res Function(_MatingNuc) _then;

/// Create a copy of MatingNuc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? number = null,Object? apiaryId = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? rearingBatchId = freezed,Object? queenId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_MatingNuc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MatingNucStatus,rearingBatchId: freezed == rearingBatchId ? _self.rearingBatchId : rearingBatchId // ignore: cast_nullable_to_non_nullable
as String?,queenId: freezed == queenId ? _self.queenId : queenId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
