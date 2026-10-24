// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionDraft {

 InspectionValues get values;/// Değeri önceki muayeneden gelen ve bu muayenede dokunulmamış alanlar;
/// soluk gösterilir. Dokunulmasa da değerleriyle kaydedilir.
 Set<InspectionField> get suggested;
/// Create a copy of InspectionDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionDraftCopyWith<InspectionDraft> get copyWith => _$InspectionDraftCopyWithImpl<InspectionDraft>(this as InspectionDraft, _$identity);

  /// Serializes this InspectionDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectionDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionDraft&&(identical(other.values, _this.values) || other.values == _this.values)&&const DeepCollectionEquality().equals(other.suggested, _this.suggested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectionDraft;
  return Object.hash(runtimeType,_this.values,const DeepCollectionEquality().hash(_this.suggested));
}

@override
String toString() {
  final _this = this as InspectionDraft;
  return 'InspectionDraft(values: ${_this.values}, suggested: ${_this.suggested})';
}


}

/// @nodoc
abstract mixin class $InspectionDraftCopyWith<$Res>  {
  factory $InspectionDraftCopyWith(InspectionDraft value, $Res Function(InspectionDraft) _then) = _$InspectionDraftCopyWithImpl;
@useResult
$Res call({
 InspectionValues values, Set<InspectionField> suggested
});


$InspectionValuesCopyWith<$Res> get values;

}
/// @nodoc
class _$InspectionDraftCopyWithImpl<$Res>
    implements $InspectionDraftCopyWith<$Res> {
  _$InspectionDraftCopyWithImpl(this._self, this._then);

  final InspectionDraft _self;
  final $Res Function(InspectionDraft) _then;

/// Create a copy of InspectionDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? values = null,Object? suggested = null,}) {
  return _then(InspectionDraft(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as InspectionValues,suggested: null == suggested ? _self.suggested : suggested // ignore: cast_nullable_to_non_nullable
as Set<InspectionField>,
  ));
}
/// Create a copy of InspectionDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspectionValuesCopyWith<$Res> get values {
  
  return $InspectionValuesCopyWith<$Res>(_self.values, (value) {
    return _then(_self.copyWith(values: value));
  });
}
}


/// Adds pattern-matching-related methods to [InspectionDraft].
extension InspectionDraftPatterns on InspectionDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionDraft value)  $default,){
final _that = this;
switch (_that) {
case _InspectionDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionDraft value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InspectionValues values,  Set<InspectionField> suggested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionDraft() when $default != null:
return $default(_that.values,_that.suggested);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InspectionValues values,  Set<InspectionField> suggested)  $default,) {final _that = this;
switch (_that) {
case _InspectionDraft():
return $default(_that.values,_that.suggested);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InspectionValues values,  Set<InspectionField> suggested)?  $default,) {final _that = this;
switch (_that) {
case _InspectionDraft() when $default != null:
return $default(_that.values,_that.suggested);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionDraft implements InspectionDraft {
  const _InspectionDraft({this.values = const InspectionValues(),  Set<InspectionField> suggested = const <InspectionField>{}}): _suggested = suggested;
  factory _InspectionDraft.fromJson(Map<String, dynamic> json) => _$InspectionDraftFromJson(json);

@override@JsonKey() final  InspectionValues values;
/// Değeri önceki muayeneden gelen ve bu muayenede dokunulmamış alanlar;
/// soluk gösterilir. Dokunulmasa da değerleriyle kaydedilir.
 final  Set<InspectionField> _suggested;
/// Değeri önceki muayeneden gelen ve bu muayenede dokunulmamış alanlar;
/// soluk gösterilir. Dokunulmasa da değerleriyle kaydedilir.
@override@JsonKey() Set<InspectionField> get suggested {
  if (_suggested is EqualUnmodifiableSetView) return _suggested;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_suggested);
}


/// Create a copy of InspectionDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionDraftCopyWith<_InspectionDraft> get copyWith => __$InspectionDraftCopyWithImpl<_InspectionDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionDraftToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionDraft&&(identical(other.values, values) || other.values == values)&&const DeepCollectionEquality().equals(other.suggested, _suggested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,values,const DeepCollectionEquality().hash(_suggested));
}

@override
String toString() {
    return 'InspectionDraft(values: $values, suggested: $suggested)';
}


}

/// @nodoc
abstract mixin class _$InspectionDraftCopyWith<$Res> implements $InspectionDraftCopyWith<$Res> {
  factory _$InspectionDraftCopyWith(_InspectionDraft value, $Res Function(_InspectionDraft) _then) = __$InspectionDraftCopyWithImpl;
@override @useResult
$Res call({
 InspectionValues values, Set<InspectionField> suggested
});


@override $InspectionValuesCopyWith<$Res> get values;

}
/// @nodoc
class __$InspectionDraftCopyWithImpl<$Res>
    implements _$InspectionDraftCopyWith<$Res> {
  __$InspectionDraftCopyWithImpl(this._self, this._then);

  final _InspectionDraft _self;
  final $Res Function(_InspectionDraft) _then;

/// Create a copy of InspectionDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? values = null,Object? suggested = null,}) {
  return _then(_InspectionDraft(
values: null == values ? _self.values : values // ignore: cast_nullable_to_non_nullable
as InspectionValues,suggested: null == suggested ? _self._suggested : suggested // ignore: cast_nullable_to_non_nullable
as Set<InspectionField>,
  ));
}

/// Create a copy of InspectionDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspectionValuesCopyWith<$Res> get values {
  
  return $InspectionValuesCopyWith<$Res>(_self.values, (value) {
    return _then(_self.copyWith(values: value));
  });
}
}

// dart format on
