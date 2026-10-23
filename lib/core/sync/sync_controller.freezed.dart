// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncActivity {

 bool get running;/// Süren turun çekme ilerleyişi; gönderme sürerken ya da tur yokken
/// boş.
 SyncProgress? get progress;/// Son biten turun sonucu.
 SyncResult? get lastResult;/// Son başarılı turun bittiği an.
 DateTime? get lastSyncedAt;
/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncActivityCopyWith<SyncActivity> get copyWith => _$SyncActivityCopyWithImpl<SyncActivity>(this as SyncActivity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SyncActivity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncActivity&&(identical(other.running, _this.running) || other.running == _this.running)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.lastResult, _this.lastResult) || other.lastResult == _this.lastResult)&&(identical(other.lastSyncedAt, _this.lastSyncedAt) || other.lastSyncedAt == _this.lastSyncedAt));
}


@override
int get hashCode {
  final _this = this as SyncActivity;
  return Object.hash(runtimeType,_this.running,_this.progress,_this.lastResult,_this.lastSyncedAt);
}

@override
String toString() {
  final _this = this as SyncActivity;
  return 'SyncActivity(running: ${_this.running}, progress: ${_this.progress}, lastResult: ${_this.lastResult}, lastSyncedAt: ${_this.lastSyncedAt})';
}


}

/// @nodoc
abstract mixin class $SyncActivityCopyWith<$Res>  {
  factory $SyncActivityCopyWith(SyncActivity value, $Res Function(SyncActivity) _then) = _$SyncActivityCopyWithImpl;
@useResult
$Res call({
 bool running, SyncProgress? progress, SyncResult? lastResult, DateTime? lastSyncedAt
});


$SyncProgressCopyWith<$Res>? get progress;$SyncResultCopyWith<$Res>? get lastResult;

}
/// @nodoc
class _$SyncActivityCopyWithImpl<$Res>
    implements $SyncActivityCopyWith<$Res> {
  _$SyncActivityCopyWithImpl(this._self, this._then);

  final SyncActivity _self;
  final $Res Function(SyncActivity) _then;

/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? running = null,Object? progress = freezed,Object? lastResult = freezed,Object? lastSyncedAt = freezed,}) {
  return _then(SyncActivity(
running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as SyncProgress?,lastResult: freezed == lastResult ? _self.lastResult : lastResult // ignore: cast_nullable_to_non_nullable
as SyncResult?,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $SyncProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncResultCopyWith<$Res>? get lastResult {
    if (_self.lastResult == null) {
    return null;
  }

  return $SyncResultCopyWith<$Res>(_self.lastResult!, (value) {
    return _then(_self.copyWith(lastResult: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncActivity].
extension SyncActivityPatterns on SyncActivity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncActivity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncActivity value)  $default,){
final _that = this;
switch (_that) {
case _SyncActivity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncActivity value)?  $default,){
final _that = this;
switch (_that) {
case _SyncActivity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool running,  SyncProgress? progress,  SyncResult? lastResult,  DateTime? lastSyncedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncActivity() when $default != null:
return $default(_that.running,_that.progress,_that.lastResult,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool running,  SyncProgress? progress,  SyncResult? lastResult,  DateTime? lastSyncedAt)  $default,) {final _that = this;
switch (_that) {
case _SyncActivity():
return $default(_that.running,_that.progress,_that.lastResult,_that.lastSyncedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool running,  SyncProgress? progress,  SyncResult? lastResult,  DateTime? lastSyncedAt)?  $default,) {final _that = this;
switch (_that) {
case _SyncActivity() when $default != null:
return $default(_that.running,_that.progress,_that.lastResult,_that.lastSyncedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SyncActivity implements SyncActivity {
  const _SyncActivity({this.running = false, this.progress, this.lastResult, this.lastSyncedAt});
  

@override@JsonKey() final  bool running;
/// Süren turun çekme ilerleyişi; gönderme sürerken ya da tur yokken
/// boş.
@override final  SyncProgress? progress;
/// Son biten turun sonucu.
@override final  SyncResult? lastResult;
/// Son başarılı turun bittiği an.
@override final  DateTime? lastSyncedAt;

/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncActivityCopyWith<_SyncActivity> get copyWith => __$SyncActivityCopyWithImpl<_SyncActivity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncActivity&&(identical(other.running, running) || other.running == running)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.lastResult, lastResult) || other.lastResult == lastResult)&&(identical(other.lastSyncedAt, lastSyncedAt) || other.lastSyncedAt == lastSyncedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,running,progress,lastResult,lastSyncedAt);
}

@override
String toString() {
    return 'SyncActivity(running: $running, progress: $progress, lastResult: $lastResult, lastSyncedAt: $lastSyncedAt)';
}


}

/// @nodoc
abstract mixin class _$SyncActivityCopyWith<$Res> implements $SyncActivityCopyWith<$Res> {
  factory _$SyncActivityCopyWith(_SyncActivity value, $Res Function(_SyncActivity) _then) = __$SyncActivityCopyWithImpl;
@override @useResult
$Res call({
 bool running, SyncProgress? progress, SyncResult? lastResult, DateTime? lastSyncedAt
});


@override $SyncProgressCopyWith<$Res>? get progress;@override $SyncResultCopyWith<$Res>? get lastResult;

}
/// @nodoc
class __$SyncActivityCopyWithImpl<$Res>
    implements _$SyncActivityCopyWith<$Res> {
  __$SyncActivityCopyWithImpl(this._self, this._then);

  final _SyncActivity _self;
  final $Res Function(_SyncActivity) _then;

/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? running = null,Object? progress = freezed,Object? lastResult = freezed,Object? lastSyncedAt = freezed,}) {
  return _then(_SyncActivity(
running: null == running ? _self.running : running // ignore: cast_nullable_to_non_nullable
as bool,progress: freezed == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as SyncProgress?,lastResult: freezed == lastResult ? _self.lastResult : lastResult // ignore: cast_nullable_to_non_nullable
as SyncResult?,lastSyncedAt: freezed == lastSyncedAt ? _self.lastSyncedAt : lastSyncedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncProgressCopyWith<$Res>? get progress {
    if (_self.progress == null) {
    return null;
  }

  return $SyncProgressCopyWith<$Res>(_self.progress!, (value) {
    return _then(_self.copyWith(progress: value));
  });
}/// Create a copy of SyncActivity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncResultCopyWith<$Res>? get lastResult {
    if (_self.lastResult == null) {
    return null;
  }

  return $SyncResultCopyWith<$Res>(_self.lastResult!, (value) {
    return _then(_self.copyWith(lastResult: value));
  });
}
}

// dart format on
