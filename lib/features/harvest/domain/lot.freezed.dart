// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lot {

 String get id; String get orgId; int get year;/// Yıl içindeki sıra; tekil değil (offline iki telefon aynısını
/// verebilir).
 int get seq; HoneyKind get honeyKind; DateTime get createdAt; DateTime get updatedAt; LotStatus get status;/// Yöre (ör. arılığın adı); serbest metin.
 String? get origin;/// Refraktömetre nemi, %.
 double? get moisture;/// Herkese açık sayfası (`lot-page`) var mı. Yalnız owner değiştirir;
/// başkasının yazmasını sunucu yok sayar.
 bool get published;/// Sayfada işletme adı ve aktif kovan sayısı görünür.
 bool get publicProducer;/// Sayfada yöre ve hasat ayı görünür.
 bool get publicOrigin;/// Sayfada son analizin değerleri görünür.
 bool get publicLab;/// Sayfada son analizin raporu açılır.
 bool get publicReport; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotCopyWith<Lot> get copyWith => _$LotCopyWithImpl<Lot>(this as Lot, _$identity);

  /// Serializes this Lot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Lot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lot&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.seq, _this.seq) || other.seq == _this.seq)&&(identical(other.honeyKind, _this.honeyKind) || other.honeyKind == _this.honeyKind)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.origin, _this.origin) || other.origin == _this.origin)&&(identical(other.moisture, _this.moisture) || other.moisture == _this.moisture)&&(identical(other.published, _this.published) || other.published == _this.published)&&(identical(other.publicProducer, _this.publicProducer) || other.publicProducer == _this.publicProducer)&&(identical(other.publicOrigin, _this.publicOrigin) || other.publicOrigin == _this.publicOrigin)&&(identical(other.publicLab, _this.publicLab) || other.publicLab == _this.publicLab)&&(identical(other.publicReport, _this.publicReport) || other.publicReport == _this.publicReport)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Lot;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.year,_this.seq,_this.honeyKind,_this.createdAt,_this.updatedAt,_this.status,_this.origin,_this.moisture,_this.published,_this.publicProducer,_this.publicOrigin,_this.publicLab,_this.publicReport,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Lot;
  return 'Lot(id: ${_this.id}, orgId: ${_this.orgId}, year: ${_this.year}, seq: ${_this.seq}, honeyKind: ${_this.honeyKind}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, status: ${_this.status}, origin: ${_this.origin}, moisture: ${_this.moisture}, published: ${_this.published}, publicProducer: ${_this.publicProducer}, publicOrigin: ${_this.publicOrigin}, publicLab: ${_this.publicLab}, publicReport: ${_this.publicReport}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $LotCopyWith<$Res>  {
  factory $LotCopyWith(Lot value, $Res Function(Lot) _then) = _$LotCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, int year, int seq, HoneyKind honeyKind, DateTime createdAt, DateTime updatedAt, LotStatus status, String? origin, double? moisture, bool published, bool publicProducer, bool publicOrigin, bool publicLab, bool publicReport, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$LotCopyWithImpl<$Res>
    implements $LotCopyWith<$Res> {
  _$LotCopyWithImpl(this._self, this._then);

  final Lot _self;
  final $Res Function(Lot) _then;

/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? year = null,Object? seq = null,Object? honeyKind = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? origin = freezed,Object? moisture = freezed,Object? published = null,Object? publicProducer = null,Object? publicOrigin = null,Object? publicLab = null,Object? publicReport = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Lot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,honeyKind: null == honeyKind ? _self.honeyKind : honeyKind // ignore: cast_nullable_to_non_nullable
as HoneyKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LotStatus,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,moisture: freezed == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as double?,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as bool,publicProducer: null == publicProducer ? _self.publicProducer : publicProducer // ignore: cast_nullable_to_non_nullable
as bool,publicOrigin: null == publicOrigin ? _self.publicOrigin : publicOrigin // ignore: cast_nullable_to_non_nullable
as bool,publicLab: null == publicLab ? _self.publicLab : publicLab // ignore: cast_nullable_to_non_nullable
as bool,publicReport: null == publicReport ? _self.publicReport : publicReport // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Lot].
extension LotPatterns on Lot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lot value)  $default,){
final _that = this;
switch (_that) {
case _Lot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lot value)?  $default,){
final _that = this;
switch (_that) {
case _Lot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  int year,  int seq,  HoneyKind honeyKind,  DateTime createdAt,  DateTime updatedAt,  LotStatus status,  String? origin,  double? moisture,  bool published,  bool publicProducer,  bool publicOrigin,  bool publicLab,  bool publicReport,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lot() when $default != null:
return $default(_that.id,_that.orgId,_that.year,_that.seq,_that.honeyKind,_that.createdAt,_that.updatedAt,_that.status,_that.origin,_that.moisture,_that.published,_that.publicProducer,_that.publicOrigin,_that.publicLab,_that.publicReport,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  int year,  int seq,  HoneyKind honeyKind,  DateTime createdAt,  DateTime updatedAt,  LotStatus status,  String? origin,  double? moisture,  bool published,  bool publicProducer,  bool publicOrigin,  bool publicLab,  bool publicReport,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Lot():
return $default(_that.id,_that.orgId,_that.year,_that.seq,_that.honeyKind,_that.createdAt,_that.updatedAt,_that.status,_that.origin,_that.moisture,_that.published,_that.publicProducer,_that.publicOrigin,_that.publicLab,_that.publicReport,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  int year,  int seq,  HoneyKind honeyKind,  DateTime createdAt,  DateTime updatedAt,  LotStatus status,  String? origin,  double? moisture,  bool published,  bool publicProducer,  bool publicOrigin,  bool publicLab,  bool publicReport,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Lot() when $default != null:
return $default(_that.id,_that.orgId,_that.year,_that.seq,_that.honeyKind,_that.createdAt,_that.updatedAt,_that.status,_that.origin,_that.moisture,_that.published,_that.publicProducer,_that.publicOrigin,_that.publicLab,_that.publicReport,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lot implements Lot {
  const _Lot({required this.id, required this.orgId, required this.year, required this.seq, required this.honeyKind, required this.createdAt, required this.updatedAt, this.status = LotStatus.open, this.origin, this.moisture, this.published = false, this.publicProducer = true, this.publicOrigin = true, this.publicLab = true, this.publicReport = true, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Lot.fromJson(Map<String, dynamic> json) => _$LotFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  int year;
/// Yıl içindeki sıra; tekil değil (offline iki telefon aynısını
/// verebilir).
@override final  int seq;
@override final  HoneyKind honeyKind;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  LotStatus status;
/// Yöre (ör. arılığın adı); serbest metin.
@override final  String? origin;
/// Refraktömetre nemi, %.
@override final  double? moisture;
/// Herkese açık sayfası (`lot-page`) var mı. Yalnız owner değiştirir;
/// başkasının yazmasını sunucu yok sayar.
@override@JsonKey() final  bool published;
/// Sayfada işletme adı ve aktif kovan sayısı görünür.
@override@JsonKey() final  bool publicProducer;
/// Sayfada yöre ve hasat ayı görünür.
@override@JsonKey() final  bool publicOrigin;
/// Sayfada son analizin değerleri görünür.
@override@JsonKey() final  bool publicLab;
/// Sayfada son analizin raporu açılır.
@override@JsonKey() final  bool publicReport;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotCopyWith<_Lot> get copyWith => __$LotCopyWithImpl<_Lot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lot&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.year, year) || other.year == year)&&(identical(other.seq, seq) || other.seq == seq)&&(identical(other.honeyKind, honeyKind) || other.honeyKind == honeyKind)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.moisture, moisture) || other.moisture == moisture)&&(identical(other.published, published) || other.published == published)&&(identical(other.publicProducer, publicProducer) || other.publicProducer == publicProducer)&&(identical(other.publicOrigin, publicOrigin) || other.publicOrigin == publicOrigin)&&(identical(other.publicLab, publicLab) || other.publicLab == publicLab)&&(identical(other.publicReport, publicReport) || other.publicReport == publicReport)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,year,seq,honeyKind,createdAt,updatedAt,status,origin,moisture,published,publicProducer,publicOrigin,publicLab,publicReport,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Lot(id: $id, orgId: $orgId, year: $year, seq: $seq, honeyKind: $honeyKind, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, origin: $origin, moisture: $moisture, published: $published, publicProducer: $publicProducer, publicOrigin: $publicOrigin, publicLab: $publicLab, publicReport: $publicReport, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$LotCopyWith<$Res> implements $LotCopyWith<$Res> {
  factory _$LotCopyWith(_Lot value, $Res Function(_Lot) _then) = __$LotCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, int year, int seq, HoneyKind honeyKind, DateTime createdAt, DateTime updatedAt, LotStatus status, String? origin, double? moisture, bool published, bool publicProducer, bool publicOrigin, bool publicLab, bool publicReport, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$LotCopyWithImpl<$Res>
    implements _$LotCopyWith<$Res> {
  __$LotCopyWithImpl(this._self, this._then);

  final _Lot _self;
  final $Res Function(_Lot) _then;

/// Create a copy of Lot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? year = null,Object? seq = null,Object? honeyKind = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? origin = freezed,Object? moisture = freezed,Object? published = null,Object? publicProducer = null,Object? publicOrigin = null,Object? publicLab = null,Object? publicReport = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Lot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,seq: null == seq ? _self.seq : seq // ignore: cast_nullable_to_non_nullable
as int,honeyKind: null == honeyKind ? _self.honeyKind : honeyKind // ignore: cast_nullable_to_non_nullable
as HoneyKind,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LotStatus,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,moisture: freezed == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as double?,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as bool,publicProducer: null == publicProducer ? _self.publicProducer : publicProducer // ignore: cast_nullable_to_non_nullable
as bool,publicOrigin: null == publicOrigin ? _self.publicOrigin : publicOrigin // ignore: cast_nullable_to_non_nullable
as bool,publicLab: null == publicLab ? _self.publicLab : publicLab // ignore: cast_nullable_to_non_nullable
as bool,publicReport: null == publicReport ? _self.publicReport : publicReport // ignore: cast_nullable_to_non_nullable
as bool,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LotHarvest {

 String get id; String get orgId; String get lotId; String get harvestId; DateTime get createdAt; DateTime get updatedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of LotHarvest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotHarvestCopyWith<LotHarvest> get copyWith => _$LotHarvestCopyWithImpl<LotHarvest>(this as LotHarvest, _$identity);

  /// Serializes this LotHarvest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LotHarvest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LotHarvest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.lotId, _this.lotId) || other.lotId == _this.lotId)&&(identical(other.harvestId, _this.harvestId) || other.harvestId == _this.harvestId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LotHarvest;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.lotId,_this.harvestId,_this.createdAt,_this.updatedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as LotHarvest;
  return 'LotHarvest(id: ${_this.id}, orgId: ${_this.orgId}, lotId: ${_this.lotId}, harvestId: ${_this.harvestId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $LotHarvestCopyWith<$Res>  {
  factory $LotHarvestCopyWith(LotHarvest value, $Res Function(LotHarvest) _then) = _$LotHarvestCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String lotId, String harvestId, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$LotHarvestCopyWithImpl<$Res>
    implements $LotHarvestCopyWith<$Res> {
  _$LotHarvestCopyWithImpl(this._self, this._then);

  final LotHarvest _self;
  final $Res Function(LotHarvest) _then;

/// Create a copy of LotHarvest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? harvestId = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(LotHarvest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,harvestId: null == harvestId ? _self.harvestId : harvestId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LotHarvest].
extension LotHarvestPatterns on LotHarvest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LotHarvest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LotHarvest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LotHarvest value)  $default,){
final _that = this;
switch (_that) {
case _LotHarvest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LotHarvest value)?  $default,){
final _that = this;
switch (_that) {
case _LotHarvest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId,  String harvestId,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LotHarvest() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.harvestId,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId,  String harvestId,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _LotHarvest():
return $default(_that.id,_that.orgId,_that.lotId,_that.harvestId,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String lotId,  String harvestId,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _LotHarvest() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.harvestId,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LotHarvest implements LotHarvest {
  const _LotHarvest({required this.id, required this.orgId, required this.lotId, required this.harvestId, required this.createdAt, required this.updatedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _LotHarvest.fromJson(Map<String, dynamic> json) => _$LotHarvestFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String lotId;
@override final  String harvestId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of LotHarvest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotHarvestCopyWith<_LotHarvest> get copyWith => __$LotHarvestCopyWithImpl<_LotHarvest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotHarvestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LotHarvest&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.harvestId, harvestId) || other.harvestId == harvestId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,lotId,harvestId,createdAt,updatedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'LotHarvest(id: $id, orgId: $orgId, lotId: $lotId, harvestId: $harvestId, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$LotHarvestCopyWith<$Res> implements $LotHarvestCopyWith<$Res> {
  factory _$LotHarvestCopyWith(_LotHarvest value, $Res Function(_LotHarvest) _then) = __$LotHarvestCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String lotId, String harvestId, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$LotHarvestCopyWithImpl<$Res>
    implements _$LotHarvestCopyWith<$Res> {
  __$LotHarvestCopyWithImpl(this._self, this._then);

  final _LotHarvest _self;
  final $Res Function(_LotHarvest) _then;

/// Create a copy of LotHarvest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? harvestId = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_LotHarvest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,harvestId: null == harvestId ? _self.harvestId : harvestId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LotTreatment {

 String get id; String get orgId; String get lotId; String get harvestId; String get hiveId;/// Kovanın hasat gününe kadarki son uygulaması.
 String get treatmentId;/// Son uygulamanın başlangıcı.
 DateTime get treatedAt;/// Hasat gününe kadar başlamış uygulamaların bekleme süresinin en geç
/// bittiği gün (o gün serbest).
@DateOnlyJsonConverter() DateTime get withdrawalEndsOn;/// Hasat günü bekleme süresindeydi.
 bool get withdrawalViolation; DateTime get createdAt; DateTime get updatedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of LotTreatment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotTreatmentCopyWith<LotTreatment> get copyWith => _$LotTreatmentCopyWithImpl<LotTreatment>(this as LotTreatment, _$identity);

  /// Serializes this LotTreatment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LotTreatment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LotTreatment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.lotId, _this.lotId) || other.lotId == _this.lotId)&&(identical(other.harvestId, _this.harvestId) || other.harvestId == _this.harvestId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.treatmentId, _this.treatmentId) || other.treatmentId == _this.treatmentId)&&(identical(other.treatedAt, _this.treatedAt) || other.treatedAt == _this.treatedAt)&&(identical(other.withdrawalEndsOn, _this.withdrawalEndsOn) || other.withdrawalEndsOn == _this.withdrawalEndsOn)&&(identical(other.withdrawalViolation, _this.withdrawalViolation) || other.withdrawalViolation == _this.withdrawalViolation)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LotTreatment;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.lotId,_this.harvestId,_this.hiveId,_this.treatmentId,_this.treatedAt,_this.withdrawalEndsOn,_this.withdrawalViolation,_this.createdAt,_this.updatedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as LotTreatment;
  return 'LotTreatment(id: ${_this.id}, orgId: ${_this.orgId}, lotId: ${_this.lotId}, harvestId: ${_this.harvestId}, hiveId: ${_this.hiveId}, treatmentId: ${_this.treatmentId}, treatedAt: ${_this.treatedAt}, withdrawalEndsOn: ${_this.withdrawalEndsOn}, withdrawalViolation: ${_this.withdrawalViolation}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $LotTreatmentCopyWith<$Res>  {
  factory $LotTreatmentCopyWith(LotTreatment value, $Res Function(LotTreatment) _then) = _$LotTreatmentCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String lotId, String harvestId, String hiveId, String treatmentId, DateTime treatedAt,@DateOnlyJsonConverter() DateTime withdrawalEndsOn, bool withdrawalViolation, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$LotTreatmentCopyWithImpl<$Res>
    implements $LotTreatmentCopyWith<$Res> {
  _$LotTreatmentCopyWithImpl(this._self, this._then);

  final LotTreatment _self;
  final $Res Function(LotTreatment) _then;

/// Create a copy of LotTreatment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? harvestId = null,Object? hiveId = null,Object? treatmentId = null,Object? treatedAt = null,Object? withdrawalEndsOn = null,Object? withdrawalViolation = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(LotTreatment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,harvestId: null == harvestId ? _self.harvestId : harvestId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,treatmentId: null == treatmentId ? _self.treatmentId : treatmentId // ignore: cast_nullable_to_non_nullable
as String,treatedAt: null == treatedAt ? _self.treatedAt : treatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalEndsOn: null == withdrawalEndsOn ? _self.withdrawalEndsOn : withdrawalEndsOn // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalViolation: null == withdrawalViolation ? _self.withdrawalViolation : withdrawalViolation // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LotTreatment].
extension LotTreatmentPatterns on LotTreatment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LotTreatment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LotTreatment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LotTreatment value)  $default,){
final _that = this;
switch (_that) {
case _LotTreatment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LotTreatment value)?  $default,){
final _that = this;
switch (_that) {
case _LotTreatment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId,  String harvestId,  String hiveId,  String treatmentId,  DateTime treatedAt, @DateOnlyJsonConverter()  DateTime withdrawalEndsOn,  bool withdrawalViolation,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LotTreatment() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.harvestId,_that.hiveId,_that.treatmentId,_that.treatedAt,_that.withdrawalEndsOn,_that.withdrawalViolation,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId,  String harvestId,  String hiveId,  String treatmentId,  DateTime treatedAt, @DateOnlyJsonConverter()  DateTime withdrawalEndsOn,  bool withdrawalViolation,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _LotTreatment():
return $default(_that.id,_that.orgId,_that.lotId,_that.harvestId,_that.hiveId,_that.treatmentId,_that.treatedAt,_that.withdrawalEndsOn,_that.withdrawalViolation,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String lotId,  String harvestId,  String hiveId,  String treatmentId,  DateTime treatedAt, @DateOnlyJsonConverter()  DateTime withdrawalEndsOn,  bool withdrawalViolation,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _LotTreatment() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.harvestId,_that.hiveId,_that.treatmentId,_that.treatedAt,_that.withdrawalEndsOn,_that.withdrawalViolation,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LotTreatment implements LotTreatment {
  const _LotTreatment({required this.id, required this.orgId, required this.lotId, required this.harvestId, required this.hiveId, required this.treatmentId, required this.treatedAt, @DateOnlyJsonConverter() required this.withdrawalEndsOn, required this.withdrawalViolation, required this.createdAt, required this.updatedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _LotTreatment.fromJson(Map<String, dynamic> json) => _$LotTreatmentFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String lotId;
@override final  String harvestId;
@override final  String hiveId;
/// Kovanın hasat gününe kadarki son uygulaması.
@override final  String treatmentId;
/// Son uygulamanın başlangıcı.
@override final  DateTime treatedAt;
/// Hasat gününe kadar başlamış uygulamaların bekleme süresinin en geç
/// bittiği gün (o gün serbest).
@override@DateOnlyJsonConverter() final  DateTime withdrawalEndsOn;
/// Hasat günü bekleme süresindeydi.
@override final  bool withdrawalViolation;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of LotTreatment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotTreatmentCopyWith<_LotTreatment> get copyWith => __$LotTreatmentCopyWithImpl<_LotTreatment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotTreatmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LotTreatment&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.harvestId, harvestId) || other.harvestId == harvestId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.treatmentId, treatmentId) || other.treatmentId == treatmentId)&&(identical(other.treatedAt, treatedAt) || other.treatedAt == treatedAt)&&(identical(other.withdrawalEndsOn, withdrawalEndsOn) || other.withdrawalEndsOn == withdrawalEndsOn)&&(identical(other.withdrawalViolation, withdrawalViolation) || other.withdrawalViolation == withdrawalViolation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,lotId,harvestId,hiveId,treatmentId,treatedAt,withdrawalEndsOn,withdrawalViolation,createdAt,updatedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'LotTreatment(id: $id, orgId: $orgId, lotId: $lotId, harvestId: $harvestId, hiveId: $hiveId, treatmentId: $treatmentId, treatedAt: $treatedAt, withdrawalEndsOn: $withdrawalEndsOn, withdrawalViolation: $withdrawalViolation, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$LotTreatmentCopyWith<$Res> implements $LotTreatmentCopyWith<$Res> {
  factory _$LotTreatmentCopyWith(_LotTreatment value, $Res Function(_LotTreatment) _then) = __$LotTreatmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String lotId, String harvestId, String hiveId, String treatmentId, DateTime treatedAt,@DateOnlyJsonConverter() DateTime withdrawalEndsOn, bool withdrawalViolation, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$LotTreatmentCopyWithImpl<$Res>
    implements _$LotTreatmentCopyWith<$Res> {
  __$LotTreatmentCopyWithImpl(this._self, this._then);

  final _LotTreatment _self;
  final $Res Function(_LotTreatment) _then;

/// Create a copy of LotTreatment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? harvestId = null,Object? hiveId = null,Object? treatmentId = null,Object? treatedAt = null,Object? withdrawalEndsOn = null,Object? withdrawalViolation = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_LotTreatment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,harvestId: null == harvestId ? _self.harvestId : harvestId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,treatmentId: null == treatmentId ? _self.treatmentId : treatmentId // ignore: cast_nullable_to_non_nullable
as String,treatedAt: null == treatedAt ? _self.treatedAt : treatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalEndsOn: null == withdrawalEndsOn ? _self.withdrawalEndsOn : withdrawalEndsOn // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalViolation: null == withdrawalViolation ? _self.withdrawalViolation : withdrawalViolation // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LabResult {

 String get id; String get orgId; String get lotId;@DateOnlyJsonConverter() DateTime get testedOn; DateTime get createdAt; DateTime get updatedAt;/// HMF, mg/kg.
 double? get hmf;/// Diastaz sayısı (Schade).
 double? get diastase;/// Prolin, mg/kg.
 double? get proline;/// Nem, %.
 double? get moisture; ResidueResult? get residue; String? get documentId; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of LabResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LabResultCopyWith<LabResult> get copyWith => _$LabResultCopyWithImpl<LabResult>(this as LabResult, _$identity);

  /// Serializes this LabResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LabResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LabResult&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.lotId, _this.lotId) || other.lotId == _this.lotId)&&(identical(other.testedOn, _this.testedOn) || other.testedOn == _this.testedOn)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.hmf, _this.hmf) || other.hmf == _this.hmf)&&(identical(other.diastase, _this.diastase) || other.diastase == _this.diastase)&&(identical(other.proline, _this.proline) || other.proline == _this.proline)&&(identical(other.moisture, _this.moisture) || other.moisture == _this.moisture)&&(identical(other.residue, _this.residue) || other.residue == _this.residue)&&(identical(other.documentId, _this.documentId) || other.documentId == _this.documentId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LabResult;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.lotId,_this.testedOn,_this.createdAt,_this.updatedAt,_this.hmf,_this.diastase,_this.proline,_this.moisture,_this.residue,_this.documentId,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as LabResult;
  return 'LabResult(id: ${_this.id}, orgId: ${_this.orgId}, lotId: ${_this.lotId}, testedOn: ${_this.testedOn}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, hmf: ${_this.hmf}, diastase: ${_this.diastase}, proline: ${_this.proline}, moisture: ${_this.moisture}, residue: ${_this.residue}, documentId: ${_this.documentId}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $LabResultCopyWith<$Res>  {
  factory $LabResultCopyWith(LabResult value, $Res Function(LabResult) _then) = _$LabResultCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String lotId,@DateOnlyJsonConverter() DateTime testedOn, DateTime createdAt, DateTime updatedAt, double? hmf, double? diastase, double? proline, double? moisture, ResidueResult? residue, String? documentId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$LabResultCopyWithImpl<$Res>
    implements $LabResultCopyWith<$Res> {
  _$LabResultCopyWithImpl(this._self, this._then);

  final LabResult _self;
  final $Res Function(LabResult) _then;

/// Create a copy of LabResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? testedOn = null,Object? createdAt = null,Object? updatedAt = null,Object? hmf = freezed,Object? diastase = freezed,Object? proline = freezed,Object? moisture = freezed,Object? residue = freezed,Object? documentId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(LabResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,testedOn: null == testedOn ? _self.testedOn : testedOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hmf: freezed == hmf ? _self.hmf : hmf // ignore: cast_nullable_to_non_nullable
as double?,diastase: freezed == diastase ? _self.diastase : diastase // ignore: cast_nullable_to_non_nullable
as double?,proline: freezed == proline ? _self.proline : proline // ignore: cast_nullable_to_non_nullable
as double?,moisture: freezed == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as double?,residue: freezed == residue ? _self.residue : residue // ignore: cast_nullable_to_non_nullable
as ResidueResult?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LabResult].
extension LabResultPatterns on LabResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LabResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LabResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LabResult value)  $default,){
final _that = this;
switch (_that) {
case _LabResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LabResult value)?  $default,){
final _that = this;
switch (_that) {
case _LabResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId, @DateOnlyJsonConverter()  DateTime testedOn,  DateTime createdAt,  DateTime updatedAt,  double? hmf,  double? diastase,  double? proline,  double? moisture,  ResidueResult? residue,  String? documentId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LabResult() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.testedOn,_that.createdAt,_that.updatedAt,_that.hmf,_that.diastase,_that.proline,_that.moisture,_that.residue,_that.documentId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId, @DateOnlyJsonConverter()  DateTime testedOn,  DateTime createdAt,  DateTime updatedAt,  double? hmf,  double? diastase,  double? proline,  double? moisture,  ResidueResult? residue,  String? documentId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _LabResult():
return $default(_that.id,_that.orgId,_that.lotId,_that.testedOn,_that.createdAt,_that.updatedAt,_that.hmf,_that.diastase,_that.proline,_that.moisture,_that.residue,_that.documentId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String lotId, @DateOnlyJsonConverter()  DateTime testedOn,  DateTime createdAt,  DateTime updatedAt,  double? hmf,  double? diastase,  double? proline,  double? moisture,  ResidueResult? residue,  String? documentId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _LabResult() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.testedOn,_that.createdAt,_that.updatedAt,_that.hmf,_that.diastase,_that.proline,_that.moisture,_that.residue,_that.documentId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LabResult implements LabResult {
  const _LabResult({required this.id, required this.orgId, required this.lotId, @DateOnlyJsonConverter() required this.testedOn, required this.createdAt, required this.updatedAt, this.hmf, this.diastase, this.proline, this.moisture, this.residue, this.documentId, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _LabResult.fromJson(Map<String, dynamic> json) => _$LabResultFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String lotId;
@override@DateOnlyJsonConverter() final  DateTime testedOn;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// HMF, mg/kg.
@override final  double? hmf;
/// Diastaz sayısı (Schade).
@override final  double? diastase;
/// Prolin, mg/kg.
@override final  double? proline;
/// Nem, %.
@override final  double? moisture;
@override final  ResidueResult? residue;
@override final  String? documentId;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of LabResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LabResultCopyWith<_LabResult> get copyWith => __$LabResultCopyWithImpl<_LabResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LabResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LabResult&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.testedOn, testedOn) || other.testedOn == testedOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.hmf, hmf) || other.hmf == hmf)&&(identical(other.diastase, diastase) || other.diastase == diastase)&&(identical(other.proline, proline) || other.proline == proline)&&(identical(other.moisture, moisture) || other.moisture == moisture)&&(identical(other.residue, residue) || other.residue == residue)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,lotId,testedOn,createdAt,updatedAt,hmf,diastase,proline,moisture,residue,documentId,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'LabResult(id: $id, orgId: $orgId, lotId: $lotId, testedOn: $testedOn, createdAt: $createdAt, updatedAt: $updatedAt, hmf: $hmf, diastase: $diastase, proline: $proline, moisture: $moisture, residue: $residue, documentId: $documentId, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$LabResultCopyWith<$Res> implements $LabResultCopyWith<$Res> {
  factory _$LabResultCopyWith(_LabResult value, $Res Function(_LabResult) _then) = __$LabResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String lotId,@DateOnlyJsonConverter() DateTime testedOn, DateTime createdAt, DateTime updatedAt, double? hmf, double? diastase, double? proline, double? moisture, ResidueResult? residue, String? documentId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$LabResultCopyWithImpl<$Res>
    implements _$LabResultCopyWith<$Res> {
  __$LabResultCopyWithImpl(this._self, this._then);

  final _LabResult _self;
  final $Res Function(_LabResult) _then;

/// Create a copy of LabResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? testedOn = null,Object? createdAt = null,Object? updatedAt = null,Object? hmf = freezed,Object? diastase = freezed,Object? proline = freezed,Object? moisture = freezed,Object? residue = freezed,Object? documentId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_LabResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,testedOn: null == testedOn ? _self.testedOn : testedOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hmf: freezed == hmf ? _self.hmf : hmf // ignore: cast_nullable_to_non_nullable
as double?,diastase: freezed == diastase ? _self.diastase : diastase // ignore: cast_nullable_to_non_nullable
as double?,proline: freezed == proline ? _self.proline : proline // ignore: cast_nullable_to_non_nullable
as double?,moisture: freezed == moisture ? _self.moisture : moisture // ignore: cast_nullable_to_non_nullable
as double?,residue: freezed == residue ? _self.residue : residue // ignore: cast_nullable_to_non_nullable
as ResidueResult?,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$LotSale {

 String get id; String get orgId; String get lotId;@DateOnlyJsonConverter() DateTime get soldOn;/// Satılan bal, kilogram.
 double get kg; DateTime get createdAt; DateTime get updatedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of LotSale
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LotSaleCopyWith<LotSale> get copyWith => _$LotSaleCopyWithImpl<LotSale>(this as LotSale, _$identity);

  /// Serializes this LotSale to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LotSale;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LotSale&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.lotId, _this.lotId) || other.lotId == _this.lotId)&&(identical(other.soldOn, _this.soldOn) || other.soldOn == _this.soldOn)&&(identical(other.kg, _this.kg) || other.kg == _this.kg)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LotSale;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.lotId,_this.soldOn,_this.kg,_this.createdAt,_this.updatedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as LotSale;
  return 'LotSale(id: ${_this.id}, orgId: ${_this.orgId}, lotId: ${_this.lotId}, soldOn: ${_this.soldOn}, kg: ${_this.kg}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $LotSaleCopyWith<$Res>  {
  factory $LotSaleCopyWith(LotSale value, $Res Function(LotSale) _then) = _$LotSaleCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String lotId,@DateOnlyJsonConverter() DateTime soldOn, double kg, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$LotSaleCopyWithImpl<$Res>
    implements $LotSaleCopyWith<$Res> {
  _$LotSaleCopyWithImpl(this._self, this._then);

  final LotSale _self;
  final $Res Function(LotSale) _then;

/// Create a copy of LotSale
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? soldOn = null,Object? kg = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(LotSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,soldOn: null == soldOn ? _self.soldOn : soldOn // ignore: cast_nullable_to_non_nullable
as DateTime,kg: null == kg ? _self.kg : kg // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LotSale].
extension LotSalePatterns on LotSale {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LotSale value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LotSale() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LotSale value)  $default,){
final _that = this;
switch (_that) {
case _LotSale():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LotSale value)?  $default,){
final _that = this;
switch (_that) {
case _LotSale() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId, @DateOnlyJsonConverter()  DateTime soldOn,  double kg,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LotSale() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.soldOn,_that.kg,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String lotId, @DateOnlyJsonConverter()  DateTime soldOn,  double kg,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _LotSale():
return $default(_that.id,_that.orgId,_that.lotId,_that.soldOn,_that.kg,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String lotId, @DateOnlyJsonConverter()  DateTime soldOn,  double kg,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _LotSale() when $default != null:
return $default(_that.id,_that.orgId,_that.lotId,_that.soldOn,_that.kg,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LotSale implements LotSale {
  const _LotSale({required this.id, required this.orgId, required this.lotId, @DateOnlyJsonConverter() required this.soldOn, required this.kg, required this.createdAt, required this.updatedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _LotSale.fromJson(Map<String, dynamic> json) => _$LotSaleFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String lotId;
@override@DateOnlyJsonConverter() final  DateTime soldOn;
/// Satılan bal, kilogram.
@override final  double kg;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of LotSale
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LotSaleCopyWith<_LotSale> get copyWith => __$LotSaleCopyWithImpl<_LotSale>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LotSaleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LotSale&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.soldOn, soldOn) || other.soldOn == soldOn)&&(identical(other.kg, kg) || other.kg == kg)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,lotId,soldOn,kg,createdAt,updatedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'LotSale(id: $id, orgId: $orgId, lotId: $lotId, soldOn: $soldOn, kg: $kg, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$LotSaleCopyWith<$Res> implements $LotSaleCopyWith<$Res> {
  factory _$LotSaleCopyWith(_LotSale value, $Res Function(_LotSale) _then) = __$LotSaleCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String lotId,@DateOnlyJsonConverter() DateTime soldOn, double kg, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$LotSaleCopyWithImpl<$Res>
    implements _$LotSaleCopyWith<$Res> {
  __$LotSaleCopyWithImpl(this._self, this._then);

  final _LotSale _self;
  final $Res Function(_LotSale) _then;

/// Create a copy of LotSale
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? lotId = null,Object? soldOn = null,Object? kg = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_LotSale(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,lotId: null == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String,soldOn: null == soldOn ? _self.soldOn : soldOn // ignore: cast_nullable_to_non_nullable
as DateTime,kg: null == kg ? _self.kg : kg // ignore: cast_nullable_to_non_nullable
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
