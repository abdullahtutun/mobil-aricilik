// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_period.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportPeriod {

 String get id; String get name;@DateOnlyJsonConverter() DateTime get applicationStartsOn;@DateOnlyJsonConverter() DateTime get applicationEndsOn; DateTime get createdAt; DateTime get updatedAt; String? get description;/// Resmî duyurunun adresi (http/https).
 String? get sourceUrl; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of SupportPeriod
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportPeriodCopyWith<SupportPeriod> get copyWith => _$SupportPeriodCopyWithImpl<SupportPeriod>(this as SupportPeriod, _$identity);

  /// Serializes this SupportPeriod to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SupportPeriod;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportPeriod&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.applicationStartsOn, _this.applicationStartsOn) || other.applicationStartsOn == _this.applicationStartsOn)&&(identical(other.applicationEndsOn, _this.applicationEndsOn) || other.applicationEndsOn == _this.applicationEndsOn)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.sourceUrl, _this.sourceUrl) || other.sourceUrl == _this.sourceUrl)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SupportPeriod;
  return Object.hash(runtimeType,_this.id,_this.name,_this.applicationStartsOn,_this.applicationEndsOn,_this.createdAt,_this.updatedAt,_this.description,_this.sourceUrl,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as SupportPeriod;
  return 'SupportPeriod(id: ${_this.id}, name: ${_this.name}, applicationStartsOn: ${_this.applicationStartsOn}, applicationEndsOn: ${_this.applicationEndsOn}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, description: ${_this.description}, sourceUrl: ${_this.sourceUrl}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $SupportPeriodCopyWith<$Res>  {
  factory $SupportPeriodCopyWith(SupportPeriod value, $Res Function(SupportPeriod) _then) = _$SupportPeriodCopyWithImpl;
@useResult
$Res call({
 String id, String name,@DateOnlyJsonConverter() DateTime applicationStartsOn,@DateOnlyJsonConverter() DateTime applicationEndsOn, DateTime createdAt, DateTime updatedAt, String? description, String? sourceUrl, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$SupportPeriodCopyWithImpl<$Res>
    implements $SupportPeriodCopyWith<$Res> {
  _$SupportPeriodCopyWithImpl(this._self, this._then);

  final SupportPeriod _self;
  final $Res Function(SupportPeriod) _then;

/// Create a copy of SupportPeriod
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? applicationStartsOn = null,Object? applicationEndsOn = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? sourceUrl = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(SupportPeriod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,applicationStartsOn: null == applicationStartsOn ? _self.applicationStartsOn : applicationStartsOn // ignore: cast_nullable_to_non_nullable
as DateTime,applicationEndsOn: null == applicationEndsOn ? _self.applicationEndsOn : applicationEndsOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportPeriod].
extension SupportPeriodPatterns on SupportPeriod {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportPeriod value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportPeriod() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportPeriod value)  $default,){
final _that = this;
switch (_that) {
case _SupportPeriod():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportPeriod value)?  $default,){
final _that = this;
switch (_that) {
case _SupportPeriod() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @DateOnlyJsonConverter()  DateTime applicationStartsOn, @DateOnlyJsonConverter()  DateTime applicationEndsOn,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? sourceUrl,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportPeriod() when $default != null:
return $default(_that.id,_that.name,_that.applicationStartsOn,_that.applicationEndsOn,_that.createdAt,_that.updatedAt,_that.description,_that.sourceUrl,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @DateOnlyJsonConverter()  DateTime applicationStartsOn, @DateOnlyJsonConverter()  DateTime applicationEndsOn,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? sourceUrl,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _SupportPeriod():
return $default(_that.id,_that.name,_that.applicationStartsOn,_that.applicationEndsOn,_that.createdAt,_that.updatedAt,_that.description,_that.sourceUrl,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @DateOnlyJsonConverter()  DateTime applicationStartsOn, @DateOnlyJsonConverter()  DateTime applicationEndsOn,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? sourceUrl,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _SupportPeriod() when $default != null:
return $default(_that.id,_that.name,_that.applicationStartsOn,_that.applicationEndsOn,_that.createdAt,_that.updatedAt,_that.description,_that.sourceUrl,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportPeriod implements SupportPeriod {
  const _SupportPeriod({required this.id, required this.name, @DateOnlyJsonConverter() required this.applicationStartsOn, @DateOnlyJsonConverter() required this.applicationEndsOn, required this.createdAt, required this.updatedAt, this.description, this.sourceUrl, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _SupportPeriod.fromJson(Map<String, dynamic> json) => _$SupportPeriodFromJson(json);

@override final  String id;
@override final  String name;
@override@DateOnlyJsonConverter() final  DateTime applicationStartsOn;
@override@DateOnlyJsonConverter() final  DateTime applicationEndsOn;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
/// Resmî duyurunun adresi (http/https).
@override final  String? sourceUrl;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of SupportPeriod
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportPeriodCopyWith<_SupportPeriod> get copyWith => __$SupportPeriodCopyWithImpl<_SupportPeriod>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportPeriodToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportPeriod&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.applicationStartsOn, applicationStartsOn) || other.applicationStartsOn == applicationStartsOn)&&(identical(other.applicationEndsOn, applicationEndsOn) || other.applicationEndsOn == applicationEndsOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,applicationStartsOn,applicationEndsOn,createdAt,updatedAt,description,sourceUrl,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'SupportPeriod(id: $id, name: $name, applicationStartsOn: $applicationStartsOn, applicationEndsOn: $applicationEndsOn, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, sourceUrl: $sourceUrl, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$SupportPeriodCopyWith<$Res> implements $SupportPeriodCopyWith<$Res> {
  factory _$SupportPeriodCopyWith(_SupportPeriod value, $Res Function(_SupportPeriod) _then) = __$SupportPeriodCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@DateOnlyJsonConverter() DateTime applicationStartsOn,@DateOnlyJsonConverter() DateTime applicationEndsOn, DateTime createdAt, DateTime updatedAt, String? description, String? sourceUrl, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$SupportPeriodCopyWithImpl<$Res>
    implements _$SupportPeriodCopyWith<$Res> {
  __$SupportPeriodCopyWithImpl(this._self, this._then);

  final _SupportPeriod _self;
  final $Res Function(_SupportPeriod) _then;

/// Create a copy of SupportPeriod
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? applicationStartsOn = null,Object? applicationEndsOn = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? sourceUrl = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_SupportPeriod(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,applicationStartsOn: null == applicationStartsOn ? _self.applicationStartsOn : applicationStartsOn // ignore: cast_nullable_to_non_nullable
as DateTime,applicationEndsOn: null == applicationEndsOn ? _self.applicationEndsOn : applicationEndsOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
