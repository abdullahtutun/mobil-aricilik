// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Feeding {

 String get id; String get orgId; String get hiveId;/// Beslemenin yapıldığı arılık; kovan sonra taşınsa da değişmez.
 String get apiaryId;/// Aynı anda birçok kovana yazılan beslemenin ortak kimliği; tek
/// kovanda da dolu.
 String get feedingGroupId; DateTime get fedAt; FeedingKind get kind;/// Kovan başına; şurupta litre, değilse kilogram.
 double get amount; DateTime get createdAt; DateTime get updatedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Feeding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingCopyWith<Feeding> get copyWith => _$FeedingCopyWithImpl<Feeding>(this as Feeding, _$identity);

  /// Serializes this Feeding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Feeding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Feeding&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.feedingGroupId, _this.feedingGroupId) || other.feedingGroupId == _this.feedingGroupId)&&(identical(other.fedAt, _this.fedAt) || other.fedAt == _this.fedAt)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Feeding;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.hiveId,_this.apiaryId,_this.feedingGroupId,_this.fedAt,_this.kind,_this.amount,_this.createdAt,_this.updatedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Feeding;
  return 'Feeding(id: ${_this.id}, orgId: ${_this.orgId}, hiveId: ${_this.hiveId}, apiaryId: ${_this.apiaryId}, feedingGroupId: ${_this.feedingGroupId}, fedAt: ${_this.fedAt}, kind: ${_this.kind}, amount: ${_this.amount}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $FeedingCopyWith<$Res>  {
  factory $FeedingCopyWith(Feeding value, $Res Function(Feeding) _then) = _$FeedingCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, String feedingGroupId, DateTime fedAt, FeedingKind kind, double amount, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$FeedingCopyWithImpl<$Res>
    implements $FeedingCopyWith<$Res> {
  _$FeedingCopyWithImpl(this._self, this._then);

  final Feeding _self;
  final $Res Function(Feeding) _then;

/// Create a copy of Feeding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? feedingGroupId = null,Object? fedAt = null,Object? kind = null,Object? amount = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Feeding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,feedingGroupId: null == feedingGroupId ? _self.feedingGroupId : feedingGroupId // ignore: cast_nullable_to_non_nullable
as String,fedAt: null == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FeedingKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Feeding].
extension FeedingPatterns on Feeding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Feeding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Feeding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Feeding value)  $default,){
final _that = this;
switch (_that) {
case _Feeding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Feeding value)?  $default,){
final _that = this;
switch (_that) {
case _Feeding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  String feedingGroupId,  DateTime fedAt,  FeedingKind kind,  double amount,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Feeding() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.feedingGroupId,_that.fedAt,_that.kind,_that.amount,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  String feedingGroupId,  DateTime fedAt,  FeedingKind kind,  double amount,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Feeding():
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.feedingGroupId,_that.fedAt,_that.kind,_that.amount,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String hiveId,  String apiaryId,  String feedingGroupId,  DateTime fedAt,  FeedingKind kind,  double amount,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Feeding() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.feedingGroupId,_that.fedAt,_that.kind,_that.amount,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Feeding implements Feeding {
  const _Feeding({required this.id, required this.orgId, required this.hiveId, required this.apiaryId, required this.feedingGroupId, required this.fedAt, required this.kind, required this.amount, required this.createdAt, required this.updatedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Feeding.fromJson(Map<String, dynamic> json) => _$FeedingFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String hiveId;
/// Beslemenin yapıldığı arılık; kovan sonra taşınsa da değişmez.
@override final  String apiaryId;
/// Aynı anda birçok kovana yazılan beslemenin ortak kimliği; tek
/// kovanda da dolu.
@override final  String feedingGroupId;
@override final  DateTime fedAt;
@override final  FeedingKind kind;
/// Kovan başına; şurupta litre, değilse kilogram.
@override final  double amount;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Feeding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingCopyWith<_Feeding> get copyWith => __$FeedingCopyWithImpl<_Feeding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Feeding&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.feedingGroupId, feedingGroupId) || other.feedingGroupId == feedingGroupId)&&(identical(other.fedAt, fedAt) || other.fedAt == fedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,hiveId,apiaryId,feedingGroupId,fedAt,kind,amount,createdAt,updatedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Feeding(id: $id, orgId: $orgId, hiveId: $hiveId, apiaryId: $apiaryId, feedingGroupId: $feedingGroupId, fedAt: $fedAt, kind: $kind, amount: $amount, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$FeedingCopyWith<$Res> implements $FeedingCopyWith<$Res> {
  factory _$FeedingCopyWith(_Feeding value, $Res Function(_Feeding) _then) = __$FeedingCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, String feedingGroupId, DateTime fedAt, FeedingKind kind, double amount, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$FeedingCopyWithImpl<$Res>
    implements _$FeedingCopyWith<$Res> {
  __$FeedingCopyWithImpl(this._self, this._then);

  final _Feeding _self;
  final $Res Function(_Feeding) _then;

/// Create a copy of Feeding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? feedingGroupId = null,Object? fedAt = null,Object? kind = null,Object? amount = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Feeding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,feedingGroupId: null == feedingGroupId ? _self.feedingGroupId : feedingGroupId // ignore: cast_nullable_to_non_nullable
as String,fedAt: null == fedAt ? _self.fedAt : fedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FeedingKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
