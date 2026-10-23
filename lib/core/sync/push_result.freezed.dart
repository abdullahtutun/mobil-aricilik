// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PushResult {

 PushStatus get status;/// Sunucunun kabul ettiği ve outbox'tan silinen kayıt sayısı.
 int get pushed;/// Bu turda kalıcı olarak reddedilip işaretlenen kayıt sayısı.
 int get rejected;
/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushResultCopyWith<PushResult> get copyWith => _$PushResultCopyWithImpl<PushResult>(this as PushResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PushResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushResult&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.pushed, _this.pushed) || other.pushed == _this.pushed)&&(identical(other.rejected, _this.rejected) || other.rejected == _this.rejected));
}


@override
int get hashCode {
  final _this = this as PushResult;
  return Object.hash(runtimeType,_this.status,_this.pushed,_this.rejected);
}

@override
String toString() {
  final _this = this as PushResult;
  return 'PushResult(status: ${_this.status}, pushed: ${_this.pushed}, rejected: ${_this.rejected})';
}


}

/// @nodoc
abstract mixin class $PushResultCopyWith<$Res>  {
  factory $PushResultCopyWith(PushResult value, $Res Function(PushResult) _then) = _$PushResultCopyWithImpl;
@useResult
$Res call({
 PushStatus status, int pushed, int rejected
});




}
/// @nodoc
class _$PushResultCopyWithImpl<$Res>
    implements $PushResultCopyWith<$Res> {
  _$PushResultCopyWithImpl(this._self, this._then);

  final PushResult _self;
  final $Res Function(PushResult) _then;

/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? pushed = null,Object? rejected = null,}) {
  return _then(PushResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PushStatus,pushed: null == pushed ? _self.pushed : pushed // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PushResult].
extension PushResultPatterns on PushResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushResult value)  $default,){
final _that = this;
switch (_that) {
case _PushResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushResult value)?  $default,){
final _that = this;
switch (_that) {
case _PushResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PushStatus status,  int pushed,  int rejected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushResult() when $default != null:
return $default(_that.status,_that.pushed,_that.rejected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PushStatus status,  int pushed,  int rejected)  $default,) {final _that = this;
switch (_that) {
case _PushResult():
return $default(_that.status,_that.pushed,_that.rejected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PushStatus status,  int pushed,  int rejected)?  $default,) {final _that = this;
switch (_that) {
case _PushResult() when $default != null:
return $default(_that.status,_that.pushed,_that.rejected);case _:
  return null;

}
}

}

/// @nodoc


class _PushResult implements PushResult {
  const _PushResult({required this.status, this.pushed = 0, this.rejected = 0});
  

@override final  PushStatus status;
/// Sunucunun kabul ettiği ve outbox'tan silinen kayıt sayısı.
@override@JsonKey() final  int pushed;
/// Bu turda kalıcı olarak reddedilip işaretlenen kayıt sayısı.
@override@JsonKey() final  int rejected;

/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushResultCopyWith<_PushResult> get copyWith => __$PushResultCopyWithImpl<_PushResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushResult&&(identical(other.status, status) || other.status == status)&&(identical(other.pushed, pushed) || other.pushed == pushed)&&(identical(other.rejected, rejected) || other.rejected == rejected));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,pushed,rejected);
}

@override
String toString() {
    return 'PushResult(status: $status, pushed: $pushed, rejected: $rejected)';
}


}

/// @nodoc
abstract mixin class _$PushResultCopyWith<$Res> implements $PushResultCopyWith<$Res> {
  factory _$PushResultCopyWith(_PushResult value, $Res Function(_PushResult) _then) = __$PushResultCopyWithImpl;
@override @useResult
$Res call({
 PushStatus status, int pushed, int rejected
});




}
/// @nodoc
class __$PushResultCopyWithImpl<$Res>
    implements _$PushResultCopyWith<$Res> {
  __$PushResultCopyWithImpl(this._self, this._then);

  final _PushResult _self;
  final $Res Function(_PushResult) _then;

/// Create a copy of PushResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? pushed = null,Object? rejected = null,}) {
  return _then(_PushResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PushStatus,pushed: null == pushed ? _self.pushed : pushed // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
