// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedbackFormState {

 FeedbackKind get kind; String get message;/// Seçilen ekran görüntüsünün medya klasöründeki dosya adı ve tam
/// yolu (küçük resim için).
 String? get screenshotFileName; String? get screenshotPath; bool get includeDeviceInfo; bool get sending;
/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackFormStateCopyWith<FeedbackFormState> get copyWith => _$FeedbackFormStateCopyWithImpl<FeedbackFormState>(this as FeedbackFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedbackFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackFormState&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.screenshotFileName, _this.screenshotFileName) || other.screenshotFileName == _this.screenshotFileName)&&(identical(other.screenshotPath, _this.screenshotPath) || other.screenshotPath == _this.screenshotPath)&&(identical(other.includeDeviceInfo, _this.includeDeviceInfo) || other.includeDeviceInfo == _this.includeDeviceInfo)&&(identical(other.sending, _this.sending) || other.sending == _this.sending));
}


@override
int get hashCode {
  final _this = this as FeedbackFormState;
  return Object.hash(runtimeType,_this.kind,_this.message,_this.screenshotFileName,_this.screenshotPath,_this.includeDeviceInfo,_this.sending);
}

@override
String toString() {
  final _this = this as FeedbackFormState;
  return 'FeedbackFormState(kind: ${_this.kind}, message: ${_this.message}, screenshotFileName: ${_this.screenshotFileName}, screenshotPath: ${_this.screenshotPath}, includeDeviceInfo: ${_this.includeDeviceInfo}, sending: ${_this.sending})';
}


}

/// @nodoc
abstract mixin class $FeedbackFormStateCopyWith<$Res>  {
  factory $FeedbackFormStateCopyWith(FeedbackFormState value, $Res Function(FeedbackFormState) _then) = _$FeedbackFormStateCopyWithImpl;
@useResult
$Res call({
 FeedbackKind kind, String message, String? screenshotFileName, String? screenshotPath, bool includeDeviceInfo, bool sending
});




}
/// @nodoc
class _$FeedbackFormStateCopyWithImpl<$Res>
    implements $FeedbackFormStateCopyWith<$Res> {
  _$FeedbackFormStateCopyWithImpl(this._self, this._then);

  final FeedbackFormState _self;
  final $Res Function(FeedbackFormState) _then;

/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? message = null,Object? screenshotFileName = freezed,Object? screenshotPath = freezed,Object? includeDeviceInfo = null,Object? sending = null,}) {
  return _then(FeedbackFormState(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FeedbackKind,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,screenshotFileName: freezed == screenshotFileName ? _self.screenshotFileName : screenshotFileName // ignore: cast_nullable_to_non_nullable
as String?,screenshotPath: freezed == screenshotPath ? _self.screenshotPath : screenshotPath // ignore: cast_nullable_to_non_nullable
as String?,includeDeviceInfo: null == includeDeviceInfo ? _self.includeDeviceInfo : includeDeviceInfo // ignore: cast_nullable_to_non_nullable
as bool,sending: null == sending ? _self.sending : sending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackFormState].
extension FeedbackFormStatePatterns on FeedbackFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackFormState value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackFormState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FeedbackKind kind,  String message,  String? screenshotFileName,  String? screenshotPath,  bool includeDeviceInfo,  bool sending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
return $default(_that.kind,_that.message,_that.screenshotFileName,_that.screenshotPath,_that.includeDeviceInfo,_that.sending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FeedbackKind kind,  String message,  String? screenshotFileName,  String? screenshotPath,  bool includeDeviceInfo,  bool sending)  $default,) {final _that = this;
switch (_that) {
case _FeedbackFormState():
return $default(_that.kind,_that.message,_that.screenshotFileName,_that.screenshotPath,_that.includeDeviceInfo,_that.sending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FeedbackKind kind,  String message,  String? screenshotFileName,  String? screenshotPath,  bool includeDeviceInfo,  bool sending)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackFormState() when $default != null:
return $default(_that.kind,_that.message,_that.screenshotFileName,_that.screenshotPath,_that.includeDeviceInfo,_that.sending);case _:
  return null;

}
}

}

/// @nodoc


class _FeedbackFormState implements FeedbackFormState {
  const _FeedbackFormState({this.kind = FeedbackKind.bug, this.message = '', this.screenshotFileName, this.screenshotPath, this.includeDeviceInfo = true, this.sending = false});
  

@override@JsonKey() final  FeedbackKind kind;
@override@JsonKey() final  String message;
/// Seçilen ekran görüntüsünün medya klasöründeki dosya adı ve tam
/// yolu (küçük resim için).
@override final  String? screenshotFileName;
@override final  String? screenshotPath;
@override@JsonKey() final  bool includeDeviceInfo;
@override@JsonKey() final  bool sending;

/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackFormStateCopyWith<_FeedbackFormState> get copyWith => __$FeedbackFormStateCopyWithImpl<_FeedbackFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackFormState&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.message, message) || other.message == message)&&(identical(other.screenshotFileName, screenshotFileName) || other.screenshotFileName == screenshotFileName)&&(identical(other.screenshotPath, screenshotPath) || other.screenshotPath == screenshotPath)&&(identical(other.includeDeviceInfo, includeDeviceInfo) || other.includeDeviceInfo == includeDeviceInfo)&&(identical(other.sending, sending) || other.sending == sending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kind,message,screenshotFileName,screenshotPath,includeDeviceInfo,sending);
}

@override
String toString() {
    return 'FeedbackFormState(kind: $kind, message: $message, screenshotFileName: $screenshotFileName, screenshotPath: $screenshotPath, includeDeviceInfo: $includeDeviceInfo, sending: $sending)';
}


}

/// @nodoc
abstract mixin class _$FeedbackFormStateCopyWith<$Res> implements $FeedbackFormStateCopyWith<$Res> {
  factory _$FeedbackFormStateCopyWith(_FeedbackFormState value, $Res Function(_FeedbackFormState) _then) = __$FeedbackFormStateCopyWithImpl;
@override @useResult
$Res call({
 FeedbackKind kind, String message, String? screenshotFileName, String? screenshotPath, bool includeDeviceInfo, bool sending
});




}
/// @nodoc
class __$FeedbackFormStateCopyWithImpl<$Res>
    implements _$FeedbackFormStateCopyWith<$Res> {
  __$FeedbackFormStateCopyWithImpl(this._self, this._then);

  final _FeedbackFormState _self;
  final $Res Function(_FeedbackFormState) _then;

/// Create a copy of FeedbackFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? message = null,Object? screenshotFileName = freezed,Object? screenshotPath = freezed,Object? includeDeviceInfo = null,Object? sending = null,}) {
  return _then(_FeedbackFormState(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FeedbackKind,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,screenshotFileName: freezed == screenshotFileName ? _self.screenshotFileName : screenshotFileName // ignore: cast_nullable_to_non_nullable
as String?,screenshotPath: freezed == screenshotPath ? _self.screenshotPath : screenshotPath // ignore: cast_nullable_to_non_nullable
as String?,includeDeviceInfo: null == includeDeviceInfo ? _self.includeDeviceInfo : includeDeviceInfo // ignore: cast_nullable_to_non_nullable
as bool,sending: null == sending ? _self.sending : sending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
