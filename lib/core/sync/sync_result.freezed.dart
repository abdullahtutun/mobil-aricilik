// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncResult {

 SyncStatus get status;/// Sunucunun kabul ettiği ve outbox'tan silinen kayıt sayısı.
 int get pushed;/// Bu turda kalıcı olarak reddedilip işaretlenen kayıt sayısı.
 int get rejected;/// Sunucudan inip yerel DB'ye yazılan satır sayısı.
 int get pulled;
/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncResultCopyWith<SyncResult> get copyWith => _$SyncResultCopyWithImpl<SyncResult>(this as SyncResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SyncResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncResult&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.pushed, _this.pushed) || other.pushed == _this.pushed)&&(identical(other.rejected, _this.rejected) || other.rejected == _this.rejected)&&(identical(other.pulled, _this.pulled) || other.pulled == _this.pulled));
}


@override
int get hashCode {
  final _this = this as SyncResult;
  return Object.hash(runtimeType,_this.status,_this.pushed,_this.rejected,_this.pulled);
}

@override
String toString() {
  final _this = this as SyncResult;
  return 'SyncResult(status: ${_this.status}, pushed: ${_this.pushed}, rejected: ${_this.rejected}, pulled: ${_this.pulled})';
}


}

/// @nodoc
abstract mixin class $SyncResultCopyWith<$Res>  {
  factory $SyncResultCopyWith(SyncResult value, $Res Function(SyncResult) _then) = _$SyncResultCopyWithImpl;
@useResult
$Res call({
 SyncStatus status, int pushed, int rejected, int pulled
});




}
/// @nodoc
class _$SyncResultCopyWithImpl<$Res>
    implements $SyncResultCopyWith<$Res> {
  _$SyncResultCopyWithImpl(this._self, this._then);

  final SyncResult _self;
  final $Res Function(SyncResult) _then;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? pushed = null,Object? rejected = null,Object? pulled = null,}) {
  return _then(SyncResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,pushed: null == pushed ? _self.pushed : pushed // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,pulled: null == pulled ? _self.pulled : pulled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncResult].
extension SyncResultPatterns on SyncResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncResult value)  $default,){
final _that = this;
switch (_that) {
case _SyncResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncResult value)?  $default,){
final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SyncStatus status,  int pushed,  int rejected,  int pulled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that.status,_that.pushed,_that.rejected,_that.pulled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SyncStatus status,  int pushed,  int rejected,  int pulled)  $default,) {final _that = this;
switch (_that) {
case _SyncResult():
return $default(_that.status,_that.pushed,_that.rejected,_that.pulled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SyncStatus status,  int pushed,  int rejected,  int pulled)?  $default,) {final _that = this;
switch (_that) {
case _SyncResult() when $default != null:
return $default(_that.status,_that.pushed,_that.rejected,_that.pulled);case _:
  return null;

}
}

}

/// @nodoc


class _SyncResult implements SyncResult {
  const _SyncResult({required this.status, this.pushed = 0, this.rejected = 0, this.pulled = 0});
  

@override final  SyncStatus status;
/// Sunucunun kabul ettiği ve outbox'tan silinen kayıt sayısı.
@override@JsonKey() final  int pushed;
/// Bu turda kalıcı olarak reddedilip işaretlenen kayıt sayısı.
@override@JsonKey() final  int rejected;
/// Sunucudan inip yerel DB'ye yazılan satır sayısı.
@override@JsonKey() final  int pulled;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncResultCopyWith<_SyncResult> get copyWith => __$SyncResultCopyWithImpl<_SyncResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncResult&&(identical(other.status, status) || other.status == status)&&(identical(other.pushed, pushed) || other.pushed == pushed)&&(identical(other.rejected, rejected) || other.rejected == rejected)&&(identical(other.pulled, pulled) || other.pulled == pulled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,pushed,rejected,pulled);
}

@override
String toString() {
    return 'SyncResult(status: $status, pushed: $pushed, rejected: $rejected, pulled: $pulled)';
}


}

/// @nodoc
abstract mixin class _$SyncResultCopyWith<$Res> implements $SyncResultCopyWith<$Res> {
  factory _$SyncResultCopyWith(_SyncResult value, $Res Function(_SyncResult) _then) = __$SyncResultCopyWithImpl;
@override @useResult
$Res call({
 SyncStatus status, int pushed, int rejected, int pulled
});




}
/// @nodoc
class __$SyncResultCopyWithImpl<$Res>
    implements _$SyncResultCopyWith<$Res> {
  __$SyncResultCopyWithImpl(this._self, this._then);

  final _SyncResult _self;
  final $Res Function(_SyncResult) _then;

/// Create a copy of SyncResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? pushed = null,Object? rejected = null,Object? pulled = null,}) {
  return _then(_SyncResult(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,pushed: null == pushed ? _self.pushed : pushed // ignore: cast_nullable_to_non_nullable
as int,rejected: null == rejected ? _self.rejected : rejected // ignore: cast_nullable_to_non_nullable
as int,pulled: null == pulled ? _self.pulled : pulled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$SyncProgress {

 int get tablesDone; int get tableCount; int get rowsPulled;
/// Create a copy of SyncProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncProgressCopyWith<SyncProgress> get copyWith => _$SyncProgressCopyWithImpl<SyncProgress>(this as SyncProgress, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SyncProgress;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncProgress&&(identical(other.tablesDone, _this.tablesDone) || other.tablesDone == _this.tablesDone)&&(identical(other.tableCount, _this.tableCount) || other.tableCount == _this.tableCount)&&(identical(other.rowsPulled, _this.rowsPulled) || other.rowsPulled == _this.rowsPulled));
}


@override
int get hashCode {
  final _this = this as SyncProgress;
  return Object.hash(runtimeType,_this.tablesDone,_this.tableCount,_this.rowsPulled);
}

@override
String toString() {
  final _this = this as SyncProgress;
  return 'SyncProgress(tablesDone: ${_this.tablesDone}, tableCount: ${_this.tableCount}, rowsPulled: ${_this.rowsPulled})';
}


}

/// @nodoc
abstract mixin class $SyncProgressCopyWith<$Res>  {
  factory $SyncProgressCopyWith(SyncProgress value, $Res Function(SyncProgress) _then) = _$SyncProgressCopyWithImpl;
@useResult
$Res call({
 int tablesDone, int tableCount, int rowsPulled
});




}
/// @nodoc
class _$SyncProgressCopyWithImpl<$Res>
    implements $SyncProgressCopyWith<$Res> {
  _$SyncProgressCopyWithImpl(this._self, this._then);

  final SyncProgress _self;
  final $Res Function(SyncProgress) _then;

/// Create a copy of SyncProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tablesDone = null,Object? tableCount = null,Object? rowsPulled = null,}) {
  return _then(SyncProgress(
tablesDone: null == tablesDone ? _self.tablesDone : tablesDone // ignore: cast_nullable_to_non_nullable
as int,tableCount: null == tableCount ? _self.tableCount : tableCount // ignore: cast_nullable_to_non_nullable
as int,rowsPulled: null == rowsPulled ? _self.rowsPulled : rowsPulled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncProgress].
extension SyncProgressPatterns on SyncProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncProgress value)  $default,){
final _that = this;
switch (_that) {
case _SyncProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncProgress value)?  $default,){
final _that = this;
switch (_that) {
case _SyncProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int tablesDone,  int tableCount,  int rowsPulled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncProgress() when $default != null:
return $default(_that.tablesDone,_that.tableCount,_that.rowsPulled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int tablesDone,  int tableCount,  int rowsPulled)  $default,) {final _that = this;
switch (_that) {
case _SyncProgress():
return $default(_that.tablesDone,_that.tableCount,_that.rowsPulled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int tablesDone,  int tableCount,  int rowsPulled)?  $default,) {final _that = this;
switch (_that) {
case _SyncProgress() when $default != null:
return $default(_that.tablesDone,_that.tableCount,_that.rowsPulled);case _:
  return null;

}
}

}

/// @nodoc


class _SyncProgress implements SyncProgress {
  const _SyncProgress({required this.tablesDone, required this.tableCount, required this.rowsPulled});
  

@override final  int tablesDone;
@override final  int tableCount;
@override final  int rowsPulled;

/// Create a copy of SyncProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncProgressCopyWith<_SyncProgress> get copyWith => __$SyncProgressCopyWithImpl<_SyncProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncProgress&&(identical(other.tablesDone, tablesDone) || other.tablesDone == tablesDone)&&(identical(other.tableCount, tableCount) || other.tableCount == tableCount)&&(identical(other.rowsPulled, rowsPulled) || other.rowsPulled == rowsPulled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tablesDone,tableCount,rowsPulled);
}

@override
String toString() {
    return 'SyncProgress(tablesDone: $tablesDone, tableCount: $tableCount, rowsPulled: $rowsPulled)';
}


}

/// @nodoc
abstract mixin class _$SyncProgressCopyWith<$Res> implements $SyncProgressCopyWith<$Res> {
  factory _$SyncProgressCopyWith(_SyncProgress value, $Res Function(_SyncProgress) _then) = __$SyncProgressCopyWithImpl;
@override @useResult
$Res call({
 int tablesDone, int tableCount, int rowsPulled
});




}
/// @nodoc
class __$SyncProgressCopyWithImpl<$Res>
    implements _$SyncProgressCopyWith<$Res> {
  __$SyncProgressCopyWithImpl(this._self, this._then);

  final _SyncProgress _self;
  final $Res Function(_SyncProgress) _then;

/// Create a copy of SyncProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tablesDone = null,Object? tableCount = null,Object? rowsPulled = null,}) {
  return _then(_SyncProgress(
tablesDone: null == tablesDone ? _self.tablesDone : tablesDone // ignore: cast_nullable_to_non_nullable
as int,tableCount: null == tableCount ? _self.tableCount : tableCount // ignore: cast_nullable_to_non_nullable
as int,rowsPulled: null == rowsPulled ? _self.rowsPulled : rowsPulled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
