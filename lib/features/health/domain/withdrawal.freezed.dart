// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdrawal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WithdrawalOverride {

 String get treatmentId; WithdrawalOverrideReason get reason;
/// Create a copy of WithdrawalOverride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WithdrawalOverrideCopyWith<WithdrawalOverride> get copyWith => _$WithdrawalOverrideCopyWithImpl<WithdrawalOverride>(this as WithdrawalOverride, _$identity);

  /// Serializes this WithdrawalOverride to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WithdrawalOverride;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WithdrawalOverride&&(identical(other.treatmentId, _this.treatmentId) || other.treatmentId == _this.treatmentId)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WithdrawalOverride;
  return Object.hash(runtimeType,_this.treatmentId,_this.reason);
}

@override
String toString() {
  final _this = this as WithdrawalOverride;
  return 'WithdrawalOverride(treatmentId: ${_this.treatmentId}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $WithdrawalOverrideCopyWith<$Res>  {
  factory $WithdrawalOverrideCopyWith(WithdrawalOverride value, $Res Function(WithdrawalOverride) _then) = _$WithdrawalOverrideCopyWithImpl;
@useResult
$Res call({
 String treatmentId, WithdrawalOverrideReason reason
});




}
/// @nodoc
class _$WithdrawalOverrideCopyWithImpl<$Res>
    implements $WithdrawalOverrideCopyWith<$Res> {
  _$WithdrawalOverrideCopyWithImpl(this._self, this._then);

  final WithdrawalOverride _self;
  final $Res Function(WithdrawalOverride) _then;

/// Create a copy of WithdrawalOverride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? treatmentId = null,Object? reason = null,}) {
  return _then(WithdrawalOverride(
treatmentId: null == treatmentId ? _self.treatmentId : treatmentId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as WithdrawalOverrideReason,
  ));
}

}


/// Adds pattern-matching-related methods to [WithdrawalOverride].
extension WithdrawalOverridePatterns on WithdrawalOverride {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WithdrawalOverride value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WithdrawalOverride() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WithdrawalOverride value)  $default,){
final _that = this;
switch (_that) {
case _WithdrawalOverride():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WithdrawalOverride value)?  $default,){
final _that = this;
switch (_that) {
case _WithdrawalOverride() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String treatmentId,  WithdrawalOverrideReason reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WithdrawalOverride() when $default != null:
return $default(_that.treatmentId,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String treatmentId,  WithdrawalOverrideReason reason)  $default,) {final _that = this;
switch (_that) {
case _WithdrawalOverride():
return $default(_that.treatmentId,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String treatmentId,  WithdrawalOverrideReason reason)?  $default,) {final _that = this;
switch (_that) {
case _WithdrawalOverride() when $default != null:
return $default(_that.treatmentId,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WithdrawalOverride implements WithdrawalOverride {
  const _WithdrawalOverride({required this.treatmentId, required this.reason});
  factory _WithdrawalOverride.fromJson(Map<String, dynamic> json) => _$WithdrawalOverrideFromJson(json);

@override final  String treatmentId;
@override final  WithdrawalOverrideReason reason;

/// Create a copy of WithdrawalOverride
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WithdrawalOverrideCopyWith<_WithdrawalOverride> get copyWith => __$WithdrawalOverrideCopyWithImpl<_WithdrawalOverride>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WithdrawalOverrideToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WithdrawalOverride&&(identical(other.treatmentId, treatmentId) || other.treatmentId == treatmentId)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,treatmentId,reason);
}

@override
String toString() {
    return 'WithdrawalOverride(treatmentId: $treatmentId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$WithdrawalOverrideCopyWith<$Res> implements $WithdrawalOverrideCopyWith<$Res> {
  factory _$WithdrawalOverrideCopyWith(_WithdrawalOverride value, $Res Function(_WithdrawalOverride) _then) = __$WithdrawalOverrideCopyWithImpl;
@override @useResult
$Res call({
 String treatmentId, WithdrawalOverrideReason reason
});




}
/// @nodoc
class __$WithdrawalOverrideCopyWithImpl<$Res>
    implements _$WithdrawalOverrideCopyWith<$Res> {
  __$WithdrawalOverrideCopyWithImpl(this._self, this._then);

  final _WithdrawalOverride _self;
  final $Res Function(_WithdrawalOverride) _then;

/// Create a copy of WithdrawalOverride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? treatmentId = null,Object? reason = null,}) {
  return _then(_WithdrawalOverride(
treatmentId: null == treatmentId ? _self.treatmentId : treatmentId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as WithdrawalOverrideReason,
  ));
}


}

// dart format on
