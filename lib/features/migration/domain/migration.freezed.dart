// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'migration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Migration {

 String get id; String get orgId; int get year; String get name; DateTime get createdAt; DateTime get updatedAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MigrationCopyWith<Migration> get copyWith => _$MigrationCopyWithImpl<Migration>(this as Migration, _$identity);

  /// Serializes this Migration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Migration;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Migration&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Migration;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.year,_this.name,_this.createdAt,_this.updatedAt,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Migration;
  return 'Migration(id: ${_this.id}, orgId: ${_this.orgId}, year: ${_this.year}, name: ${_this.name}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $MigrationCopyWith<$Res>  {
  factory $MigrationCopyWith(Migration value, $Res Function(Migration) _then) = _$MigrationCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, int year, String name, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$MigrationCopyWithImpl<$Res>
    implements $MigrationCopyWith<$Res> {
  _$MigrationCopyWithImpl(this._self, this._then);

  final Migration _self;
  final $Res Function(Migration) _then;

/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? year = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Migration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Migration].
extension MigrationPatterns on Migration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Migration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Migration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Migration value)  $default,){
final _that = this;
switch (_that) {
case _Migration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Migration value)?  $default,){
final _that = this;
switch (_that) {
case _Migration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  int year,  String name,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Migration() when $default != null:
return $default(_that.id,_that.orgId,_that.year,_that.name,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  int year,  String name,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Migration():
return $default(_that.id,_that.orgId,_that.year,_that.name,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  int year,  String name,  DateTime createdAt,  DateTime updatedAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Migration() when $default != null:
return $default(_that.id,_that.orgId,_that.year,_that.name,_that.createdAt,_that.updatedAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Migration implements Migration {
  const _Migration({required this.id, required this.orgId, required this.year, required this.name, required this.createdAt, required this.updatedAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Migration.fromJson(Map<String, dynamic> json) => _$MigrationFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  int year;
@override final  String name;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MigrationCopyWith<_Migration> get copyWith => __$MigrationCopyWithImpl<_Migration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MigrationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Migration&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.year, year) || other.year == year)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,year,name,createdAt,updatedAt,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Migration(id: $id, orgId: $orgId, year: $year, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$MigrationCopyWith<$Res> implements $MigrationCopyWith<$Res> {
  factory _$MigrationCopyWith(_Migration value, $Res Function(_Migration) _then) = __$MigrationCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, int year, String name, DateTime createdAt, DateTime updatedAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$MigrationCopyWithImpl<$Res>
    implements _$MigrationCopyWith<$Res> {
  __$MigrationCopyWithImpl(this._self, this._then);

  final _Migration _self;
  final $Res Function(_Migration) _then;

/// Create a copy of Migration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? year = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Migration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
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
mixin _$MigrationStop {

 String get id; String get orgId; String get migrationId;/// Rotadaki sıra; küçük önce.
 int get position;/// Kaynağın adı ("Narenciye", "Çam").
 String get name;/// Planlanan ilk ve son konaklama günü (ikisi dahil).
@DateOnlyJsonConverter() DateTime get plannedStartOn;@DateOnlyJsonConverter() DateTime get plannedEndOn; DateTime get createdAt; DateTime get updatedAt; MigrationStopStatus get status;/// Yer ("Erdemli, Mersin").
 String? get place;/// Hedef arılık; geçmiş yılların verimi onun hasatlarından.
 String? get apiaryId; int? get hiveCount; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of MigrationStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MigrationStopCopyWith<MigrationStop> get copyWith => _$MigrationStopCopyWithImpl<MigrationStop>(this as MigrationStop, _$identity);

  /// Serializes this MigrationStop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MigrationStop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MigrationStop&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.migrationId, _this.migrationId) || other.migrationId == _this.migrationId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.plannedStartOn, _this.plannedStartOn) || other.plannedStartOn == _this.plannedStartOn)&&(identical(other.plannedEndOn, _this.plannedEndOn) || other.plannedEndOn == _this.plannedEndOn)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.hiveCount, _this.hiveCount) || other.hiveCount == _this.hiveCount)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MigrationStop;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.migrationId,_this.position,_this.name,_this.plannedStartOn,_this.plannedEndOn,_this.createdAt,_this.updatedAt,_this.status,_this.place,_this.apiaryId,_this.hiveCount,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as MigrationStop;
  return 'MigrationStop(id: ${_this.id}, orgId: ${_this.orgId}, migrationId: ${_this.migrationId}, position: ${_this.position}, name: ${_this.name}, plannedStartOn: ${_this.plannedStartOn}, plannedEndOn: ${_this.plannedEndOn}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, status: ${_this.status}, place: ${_this.place}, apiaryId: ${_this.apiaryId}, hiveCount: ${_this.hiveCount}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $MigrationStopCopyWith<$Res>  {
  factory $MigrationStopCopyWith(MigrationStop value, $Res Function(MigrationStop) _then) = _$MigrationStopCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String migrationId, int position, String name,@DateOnlyJsonConverter() DateTime plannedStartOn,@DateOnlyJsonConverter() DateTime plannedEndOn, DateTime createdAt, DateTime updatedAt, MigrationStopStatus status, String? place, String? apiaryId, int? hiveCount, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$MigrationStopCopyWithImpl<$Res>
    implements $MigrationStopCopyWith<$Res> {
  _$MigrationStopCopyWithImpl(this._self, this._then);

  final MigrationStop _self;
  final $Res Function(MigrationStop) _then;

/// Create a copy of MigrationStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? migrationId = null,Object? position = null,Object? name = null,Object? plannedStartOn = null,Object? plannedEndOn = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? place = freezed,Object? apiaryId = freezed,Object? hiveCount = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(MigrationStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,migrationId: null == migrationId ? _self.migrationId : migrationId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,plannedStartOn: null == plannedStartOn ? _self.plannedStartOn : plannedStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: null == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MigrationStopStatus,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveCount: freezed == hiveCount ? _self.hiveCount : hiveCount // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MigrationStop].
extension MigrationStopPatterns on MigrationStop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MigrationStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MigrationStop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MigrationStop value)  $default,){
final _that = this;
switch (_that) {
case _MigrationStop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MigrationStop value)?  $default,){
final _that = this;
switch (_that) {
case _MigrationStop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String migrationId,  int position,  String name, @DateOnlyJsonConverter()  DateTime plannedStartOn, @DateOnlyJsonConverter()  DateTime plannedEndOn,  DateTime createdAt,  DateTime updatedAt,  MigrationStopStatus status,  String? place,  String? apiaryId,  int? hiveCount,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MigrationStop() when $default != null:
return $default(_that.id,_that.orgId,_that.migrationId,_that.position,_that.name,_that.plannedStartOn,_that.plannedEndOn,_that.createdAt,_that.updatedAt,_that.status,_that.place,_that.apiaryId,_that.hiveCount,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String migrationId,  int position,  String name, @DateOnlyJsonConverter()  DateTime plannedStartOn, @DateOnlyJsonConverter()  DateTime plannedEndOn,  DateTime createdAt,  DateTime updatedAt,  MigrationStopStatus status,  String? place,  String? apiaryId,  int? hiveCount,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _MigrationStop():
return $default(_that.id,_that.orgId,_that.migrationId,_that.position,_that.name,_that.plannedStartOn,_that.plannedEndOn,_that.createdAt,_that.updatedAt,_that.status,_that.place,_that.apiaryId,_that.hiveCount,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String migrationId,  int position,  String name, @DateOnlyJsonConverter()  DateTime plannedStartOn, @DateOnlyJsonConverter()  DateTime plannedEndOn,  DateTime createdAt,  DateTime updatedAt,  MigrationStopStatus status,  String? place,  String? apiaryId,  int? hiveCount,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _MigrationStop() when $default != null:
return $default(_that.id,_that.orgId,_that.migrationId,_that.position,_that.name,_that.plannedStartOn,_that.plannedEndOn,_that.createdAt,_that.updatedAt,_that.status,_that.place,_that.apiaryId,_that.hiveCount,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MigrationStop implements MigrationStop {
  const _MigrationStop({required this.id, required this.orgId, required this.migrationId, required this.position, required this.name, @DateOnlyJsonConverter() required this.plannedStartOn, @DateOnlyJsonConverter() required this.plannedEndOn, required this.createdAt, required this.updatedAt, this.status = MigrationStopStatus.planned, this.place, this.apiaryId, this.hiveCount, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _MigrationStop.fromJson(Map<String, dynamic> json) => _$MigrationStopFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String migrationId;
/// Rotadaki sıra; küçük önce.
@override final  int position;
/// Kaynağın adı ("Narenciye", "Çam").
@override final  String name;
/// Planlanan ilk ve son konaklama günü (ikisi dahil).
@override@DateOnlyJsonConverter() final  DateTime plannedStartOn;
@override@DateOnlyJsonConverter() final  DateTime plannedEndOn;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  MigrationStopStatus status;
/// Yer ("Erdemli, Mersin").
@override final  String? place;
/// Hedef arılık; geçmiş yılların verimi onun hasatlarından.
@override final  String? apiaryId;
@override final  int? hiveCount;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of MigrationStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MigrationStopCopyWith<_MigrationStop> get copyWith => __$MigrationStopCopyWithImpl<_MigrationStop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MigrationStopToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MigrationStop&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.migrationId, migrationId) || other.migrationId == migrationId)&&(identical(other.position, position) || other.position == position)&&(identical(other.name, name) || other.name == name)&&(identical(other.plannedStartOn, plannedStartOn) || other.plannedStartOn == plannedStartOn)&&(identical(other.plannedEndOn, plannedEndOn) || other.plannedEndOn == plannedEndOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.place, place) || other.place == place)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.hiveCount, hiveCount) || other.hiveCount == hiveCount)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,migrationId,position,name,plannedStartOn,plannedEndOn,createdAt,updatedAt,status,place,apiaryId,hiveCount,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'MigrationStop(id: $id, orgId: $orgId, migrationId: $migrationId, position: $position, name: $name, plannedStartOn: $plannedStartOn, plannedEndOn: $plannedEndOn, createdAt: $createdAt, updatedAt: $updatedAt, status: $status, place: $place, apiaryId: $apiaryId, hiveCount: $hiveCount, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$MigrationStopCopyWith<$Res> implements $MigrationStopCopyWith<$Res> {
  factory _$MigrationStopCopyWith(_MigrationStop value, $Res Function(_MigrationStop) _then) = __$MigrationStopCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String migrationId, int position, String name,@DateOnlyJsonConverter() DateTime plannedStartOn,@DateOnlyJsonConverter() DateTime plannedEndOn, DateTime createdAt, DateTime updatedAt, MigrationStopStatus status, String? place, String? apiaryId, int? hiveCount, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$MigrationStopCopyWithImpl<$Res>
    implements _$MigrationStopCopyWith<$Res> {
  __$MigrationStopCopyWithImpl(this._self, this._then);

  final _MigrationStop _self;
  final $Res Function(_MigrationStop) _then;

/// Create a copy of MigrationStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? migrationId = null,Object? position = null,Object? name = null,Object? plannedStartOn = null,Object? plannedEndOn = null,Object? createdAt = null,Object? updatedAt = null,Object? status = null,Object? place = freezed,Object? apiaryId = freezed,Object? hiveCount = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_MigrationStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,migrationId: null == migrationId ? _self.migrationId : migrationId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,plannedStartOn: null == plannedStartOn ? _self.plannedStartOn : plannedStartOn // ignore: cast_nullable_to_non_nullable
as DateTime,plannedEndOn: null == plannedEndOn ? _self.plannedEndOn : plannedEndOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MigrationStopStatus,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveCount: freezed == hiveCount ? _self.hiveCount : hiveCount // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
