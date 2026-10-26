// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apiary_tour.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiaryTour {

 String get orgId; String get apiaryId; DateTime get startedAt;/// Tur başladığında muayene edilebilen kovanlar, numara sırasıyla.
 List<String> get hiveIds;/// Turda muayene edilen kovan → muayenenin kimliği.
 Map<String, String> get inspections;/// Atlanan kovanlar, atlanma sırasıyla; muayene edilince düşer.
 List<String> get skipped;/// "Turu bitir" anı; özet ekranı açıkken dolu.
 DateTime? get finishedAt;
/// Create a copy of ApiaryTour
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiaryTourCopyWith<ApiaryTour> get copyWith => _$ApiaryTourCopyWithImpl<ApiaryTour>(this as ApiaryTour, _$identity);

  /// Serializes this ApiaryTour to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ApiaryTour;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiaryTour&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&const DeepCollectionEquality().equals(other.hiveIds, _this.hiveIds)&&const DeepCollectionEquality().equals(other.inspections, _this.inspections)&&const DeepCollectionEquality().equals(other.skipped, _this.skipped)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApiaryTour;
  return Object.hash(runtimeType,_this.orgId,_this.apiaryId,_this.startedAt,const DeepCollectionEquality().hash(_this.hiveIds),const DeepCollectionEquality().hash(_this.inspections),const DeepCollectionEquality().hash(_this.skipped),_this.finishedAt);
}

@override
String toString() {
  final _this = this as ApiaryTour;
  return 'ApiaryTour(orgId: ${_this.orgId}, apiaryId: ${_this.apiaryId}, startedAt: ${_this.startedAt}, hiveIds: ${_this.hiveIds}, inspections: ${_this.inspections}, skipped: ${_this.skipped}, finishedAt: ${_this.finishedAt})';
}


}

/// @nodoc
abstract mixin class $ApiaryTourCopyWith<$Res>  {
  factory $ApiaryTourCopyWith(ApiaryTour value, $Res Function(ApiaryTour) _then) = _$ApiaryTourCopyWithImpl;
@useResult
$Res call({
 String orgId, String apiaryId, DateTime startedAt, List<String> hiveIds, Map<String, String> inspections, List<String> skipped, DateTime? finishedAt
});




}
/// @nodoc
class _$ApiaryTourCopyWithImpl<$Res>
    implements $ApiaryTourCopyWith<$Res> {
  _$ApiaryTourCopyWithImpl(this._self, this._then);

  final ApiaryTour _self;
  final $Res Function(ApiaryTour) _then;

/// Create a copy of ApiaryTour
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orgId = null,Object? apiaryId = null,Object? startedAt = null,Object? hiveIds = null,Object? inspections = null,Object? skipped = null,Object? finishedAt = freezed,}) {
  return _then(ApiaryTour(
orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hiveIds: null == hiveIds ? _self.hiveIds : hiveIds // ignore: cast_nullable_to_non_nullable
as List<String>,inspections: null == inspections ? _self.inspections : inspections // ignore: cast_nullable_to_non_nullable
as Map<String, String>,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<String>,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiaryTour].
extension ApiaryTourPatterns on ApiaryTour {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiaryTour value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiaryTour() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiaryTour value)  $default,){
final _that = this;
switch (_that) {
case _ApiaryTour():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiaryTour value)?  $default,){
final _that = this;
switch (_that) {
case _ApiaryTour() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String orgId,  String apiaryId,  DateTime startedAt,  List<String> hiveIds,  Map<String, String> inspections,  List<String> skipped,  DateTime? finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiaryTour() when $default != null:
return $default(_that.orgId,_that.apiaryId,_that.startedAt,_that.hiveIds,_that.inspections,_that.skipped,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String orgId,  String apiaryId,  DateTime startedAt,  List<String> hiveIds,  Map<String, String> inspections,  List<String> skipped,  DateTime? finishedAt)  $default,) {final _that = this;
switch (_that) {
case _ApiaryTour():
return $default(_that.orgId,_that.apiaryId,_that.startedAt,_that.hiveIds,_that.inspections,_that.skipped,_that.finishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String orgId,  String apiaryId,  DateTime startedAt,  List<String> hiveIds,  Map<String, String> inspections,  List<String> skipped,  DateTime? finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiaryTour() when $default != null:
return $default(_that.orgId,_that.apiaryId,_that.startedAt,_that.hiveIds,_that.inspections,_that.skipped,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiaryTour implements ApiaryTour {
  const _ApiaryTour({required this.orgId, required this.apiaryId, required this.startedAt, required  List<String> hiveIds,  Map<String, String> inspections = const {},  List<String> skipped = const [], this.finishedAt}): _hiveIds = hiveIds,_inspections = inspections,_skipped = skipped;
  factory _ApiaryTour.fromJson(Map<String, dynamic> json) => _$ApiaryTourFromJson(json);

@override final  String orgId;
@override final  String apiaryId;
@override final  DateTime startedAt;
/// Tur başladığında muayene edilebilen kovanlar, numara sırasıyla.
 final  List<String> _hiveIds;
/// Tur başladığında muayene edilebilen kovanlar, numara sırasıyla.
@override List<String> get hiveIds {
  if (_hiveIds is EqualUnmodifiableListView) return _hiveIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hiveIds);
}

/// Turda muayene edilen kovan → muayenenin kimliği.
 final  Map<String, String> _inspections;
/// Turda muayene edilen kovan → muayenenin kimliği.
@override@JsonKey() Map<String, String> get inspections {
  if (_inspections is EqualUnmodifiableMapView) return _inspections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_inspections);
}

/// Atlanan kovanlar, atlanma sırasıyla; muayene edilince düşer.
 final  List<String> _skipped;
/// Atlanan kovanlar, atlanma sırasıyla; muayene edilince düşer.
@override@JsonKey() List<String> get skipped {
  if (_skipped is EqualUnmodifiableListView) return _skipped;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skipped);
}

/// "Turu bitir" anı; özet ekranı açıkken dolu.
@override final  DateTime? finishedAt;

/// Create a copy of ApiaryTour
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiaryTourCopyWith<_ApiaryTour> get copyWith => __$ApiaryTourCopyWithImpl<_ApiaryTour>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiaryTourToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiaryTour&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&const DeepCollectionEquality().equals(other.hiveIds, _hiveIds)&&const DeepCollectionEquality().equals(other.inspections, _inspections)&&const DeepCollectionEquality().equals(other.skipped, _skipped)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,orgId,apiaryId,startedAt,const DeepCollectionEquality().hash(_hiveIds),const DeepCollectionEquality().hash(_inspections),const DeepCollectionEquality().hash(_skipped),finishedAt);
}

@override
String toString() {
    return 'ApiaryTour(orgId: $orgId, apiaryId: $apiaryId, startedAt: $startedAt, hiveIds: $hiveIds, inspections: $inspections, skipped: $skipped, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$ApiaryTourCopyWith<$Res> implements $ApiaryTourCopyWith<$Res> {
  factory _$ApiaryTourCopyWith(_ApiaryTour value, $Res Function(_ApiaryTour) _then) = __$ApiaryTourCopyWithImpl;
@override @useResult
$Res call({
 String orgId, String apiaryId, DateTime startedAt, List<String> hiveIds, Map<String, String> inspections, List<String> skipped, DateTime? finishedAt
});




}
/// @nodoc
class __$ApiaryTourCopyWithImpl<$Res>
    implements _$ApiaryTourCopyWith<$Res> {
  __$ApiaryTourCopyWithImpl(this._self, this._then);

  final _ApiaryTour _self;
  final $Res Function(_ApiaryTour) _then;

/// Create a copy of ApiaryTour
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orgId = null,Object? apiaryId = null,Object? startedAt = null,Object? hiveIds = null,Object? inspections = null,Object? skipped = null,Object? finishedAt = freezed,}) {
  return _then(_ApiaryTour(
orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hiveIds: null == hiveIds ? _self._hiveIds : hiveIds // ignore: cast_nullable_to_non_nullable
as List<String>,inspections: null == inspections ? _self._inspections : inspections // ignore: cast_nullable_to_non_nullable
as Map<String, String>,skipped: null == skipped ? _self._skipped : skipped // ignore: cast_nullable_to_non_nullable
as List<String>,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
