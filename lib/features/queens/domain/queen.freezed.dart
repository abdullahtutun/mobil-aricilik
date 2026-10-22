// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Queen {

 String get id; String get orgId; DateTime get createdAt; DateTime get updatedAt;/// Doğum ya da alım yılı; işaret rengi önerisi buradan çıkar.
 int? get year;/// Boş: işaretsiz. Değerler `public.queen_mark_color` ile aynı.
 QueenMarkColor? get markColor; String? get breed; String? get breedLine; QueenSource? get source;/// Boş: bilinmiyor.
 QueenMatingStatus? get matingStatus; bool get wingClipped; String? get motherQueenId; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Queen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueenCopyWith<Queen> get copyWith => _$QueenCopyWithImpl<Queen>(this as Queen, _$identity);

  /// Serializes this Queen to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Queen;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Queen&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.markColor, _this.markColor) || other.markColor == _this.markColor)&&(identical(other.breed, _this.breed) || other.breed == _this.breed)&&(identical(other.breedLine, _this.breedLine) || other.breedLine == _this.breedLine)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.matingStatus, _this.matingStatus) || other.matingStatus == _this.matingStatus)&&(identical(other.wingClipped, _this.wingClipped) || other.wingClipped == _this.wingClipped)&&(identical(other.motherQueenId, _this.motherQueenId) || other.motherQueenId == _this.motherQueenId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Queen;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.createdAt,_this.updatedAt,_this.year,_this.markColor,_this.breed,_this.breedLine,_this.source,_this.matingStatus,_this.wingClipped,_this.motherQueenId,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Queen;
  return 'Queen(id: ${_this.id}, orgId: ${_this.orgId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, year: ${_this.year}, markColor: ${_this.markColor}, breed: ${_this.breed}, breedLine: ${_this.breedLine}, source: ${_this.source}, matingStatus: ${_this.matingStatus}, wingClipped: ${_this.wingClipped}, motherQueenId: ${_this.motherQueenId}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $QueenCopyWith<$Res>  {
  factory $QueenCopyWith(Queen value, $Res Function(Queen) _then) = _$QueenCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, DateTime createdAt, DateTime updatedAt, int? year, QueenMarkColor? markColor, String? breed, String? breedLine, QueenSource? source, QueenMatingStatus? matingStatus, bool wingClipped, String? motherQueenId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$QueenCopyWithImpl<$Res>
    implements $QueenCopyWith<$Res> {
  _$QueenCopyWithImpl(this._self, this._then);

  final Queen _self;
  final $Res Function(Queen) _then;

/// Create a copy of Queen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? createdAt = null,Object? updatedAt = null,Object? year = freezed,Object? markColor = freezed,Object? breed = freezed,Object? breedLine = freezed,Object? source = freezed,Object? matingStatus = freezed,Object? wingClipped = null,Object? motherQueenId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Queen(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,markColor: freezed == markColor ? _self.markColor : markColor // ignore: cast_nullable_to_non_nullable
as QueenMarkColor?,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String?,breedLine: freezed == breedLine ? _self.breedLine : breedLine // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as QueenSource?,matingStatus: freezed == matingStatus ? _self.matingStatus : matingStatus // ignore: cast_nullable_to_non_nullable
as QueenMatingStatus?,wingClipped: null == wingClipped ? _self.wingClipped : wingClipped // ignore: cast_nullable_to_non_nullable
as bool,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Queen].
extension QueenPatterns on Queen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Queen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Queen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Queen value)  $default,){
final _that = this;
switch (_that) {
case _Queen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Queen value)?  $default,){
final _that = this;
switch (_that) {
case _Queen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  DateTime createdAt,  DateTime updatedAt,  int? year,  QueenMarkColor? markColor,  String? breed,  String? breedLine,  QueenSource? source,  QueenMatingStatus? matingStatus,  bool wingClipped,  String? motherQueenId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Queen() when $default != null:
return $default(_that.id,_that.orgId,_that.createdAt,_that.updatedAt,_that.year,_that.markColor,_that.breed,_that.breedLine,_that.source,_that.matingStatus,_that.wingClipped,_that.motherQueenId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  DateTime createdAt,  DateTime updatedAt,  int? year,  QueenMarkColor? markColor,  String? breed,  String? breedLine,  QueenSource? source,  QueenMatingStatus? matingStatus,  bool wingClipped,  String? motherQueenId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Queen():
return $default(_that.id,_that.orgId,_that.createdAt,_that.updatedAt,_that.year,_that.markColor,_that.breed,_that.breedLine,_that.source,_that.matingStatus,_that.wingClipped,_that.motherQueenId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  DateTime createdAt,  DateTime updatedAt,  int? year,  QueenMarkColor? markColor,  String? breed,  String? breedLine,  QueenSource? source,  QueenMatingStatus? matingStatus,  bool wingClipped,  String? motherQueenId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Queen() when $default != null:
return $default(_that.id,_that.orgId,_that.createdAt,_that.updatedAt,_that.year,_that.markColor,_that.breed,_that.breedLine,_that.source,_that.matingStatus,_that.wingClipped,_that.motherQueenId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Queen implements Queen {
  const _Queen({required this.id, required this.orgId, required this.createdAt, required this.updatedAt, this.year, this.markColor, this.breed, this.breedLine, this.source, this.matingStatus, this.wingClipped = false, this.motherQueenId, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Queen.fromJson(Map<String, dynamic> json) => _$QueenFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Doğum ya da alım yılı; işaret rengi önerisi buradan çıkar.
@override final  int? year;
/// Boş: işaretsiz. Değerler `public.queen_mark_color` ile aynı.
@override final  QueenMarkColor? markColor;
@override final  String? breed;
@override final  String? breedLine;
@override final  QueenSource? source;
/// Boş: bilinmiyor.
@override final  QueenMatingStatus? matingStatus;
@override@JsonKey() final  bool wingClipped;
@override final  String? motherQueenId;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Queen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueenCopyWith<_Queen> get copyWith => __$QueenCopyWithImpl<_Queen>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueenToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Queen&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.year, year) || other.year == year)&&(identical(other.markColor, markColor) || other.markColor == markColor)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.breedLine, breedLine) || other.breedLine == breedLine)&&(identical(other.source, source) || other.source == source)&&(identical(other.matingStatus, matingStatus) || other.matingStatus == matingStatus)&&(identical(other.wingClipped, wingClipped) || other.wingClipped == wingClipped)&&(identical(other.motherQueenId, motherQueenId) || other.motherQueenId == motherQueenId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,createdAt,updatedAt,year,markColor,breed,breedLine,source,matingStatus,wingClipped,motherQueenId,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Queen(id: $id, orgId: $orgId, createdAt: $createdAt, updatedAt: $updatedAt, year: $year, markColor: $markColor, breed: $breed, breedLine: $breedLine, source: $source, matingStatus: $matingStatus, wingClipped: $wingClipped, motherQueenId: $motherQueenId, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$QueenCopyWith<$Res> implements $QueenCopyWith<$Res> {
  factory _$QueenCopyWith(_Queen value, $Res Function(_Queen) _then) = __$QueenCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, DateTime createdAt, DateTime updatedAt, int? year, QueenMarkColor? markColor, String? breed, String? breedLine, QueenSource? source, QueenMatingStatus? matingStatus, bool wingClipped, String? motherQueenId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$QueenCopyWithImpl<$Res>
    implements _$QueenCopyWith<$Res> {
  __$QueenCopyWithImpl(this._self, this._then);

  final _Queen _self;
  final $Res Function(_Queen) _then;

/// Create a copy of Queen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? createdAt = null,Object? updatedAt = null,Object? year = freezed,Object? markColor = freezed,Object? breed = freezed,Object? breedLine = freezed,Object? source = freezed,Object? matingStatus = freezed,Object? wingClipped = null,Object? motherQueenId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Queen(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,markColor: freezed == markColor ? _self.markColor : markColor // ignore: cast_nullable_to_non_nullable
as QueenMarkColor?,breed: freezed == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String?,breedLine: freezed == breedLine ? _self.breedLine : breedLine // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as QueenSource?,matingStatus: freezed == matingStatus ? _self.matingStatus : matingStatus // ignore: cast_nullable_to_non_nullable
as QueenMatingStatus?,wingClipped: null == wingClipped ? _self.wingClipped : wingClipped // ignore: cast_nullable_to_non_nullable
as bool,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
