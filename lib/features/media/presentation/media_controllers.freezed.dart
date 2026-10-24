// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_controllers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VoiceRecording {

 String get fileName; DateTime get startedAt;
/// Create a copy of VoiceRecording
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoiceRecordingCopyWith<VoiceRecording> get copyWith => _$VoiceRecordingCopyWithImpl<VoiceRecording>(this as VoiceRecording, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as VoiceRecording;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoiceRecording&&(identical(other.fileName, _this.fileName) || other.fileName == _this.fileName)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt));
}


@override
int get hashCode {
  final _this = this as VoiceRecording;
  return Object.hash(runtimeType,_this.fileName,_this.startedAt);
}

@override
String toString() {
  final _this = this as VoiceRecording;
  return 'VoiceRecording(fileName: ${_this.fileName}, startedAt: ${_this.startedAt})';
}


}

/// @nodoc
abstract mixin class $VoiceRecordingCopyWith<$Res>  {
  factory $VoiceRecordingCopyWith(VoiceRecording value, $Res Function(VoiceRecording) _then) = _$VoiceRecordingCopyWithImpl;
@useResult
$Res call({
 String fileName, DateTime startedAt
});




}
/// @nodoc
class _$VoiceRecordingCopyWithImpl<$Res>
    implements $VoiceRecordingCopyWith<$Res> {
  _$VoiceRecordingCopyWithImpl(this._self, this._then);

  final VoiceRecording _self;
  final $Res Function(VoiceRecording) _then;

/// Create a copy of VoiceRecording
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = null,Object? startedAt = null,}) {
  return _then(VoiceRecording(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [VoiceRecording].
extension VoiceRecordingPatterns on VoiceRecording {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoiceRecording value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoiceRecording() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoiceRecording value)  $default,){
final _that = this;
switch (_that) {
case _VoiceRecording():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoiceRecording value)?  $default,){
final _that = this;
switch (_that) {
case _VoiceRecording() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileName,  DateTime startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoiceRecording() when $default != null:
return $default(_that.fileName,_that.startedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileName,  DateTime startedAt)  $default,) {final _that = this;
switch (_that) {
case _VoiceRecording():
return $default(_that.fileName,_that.startedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileName,  DateTime startedAt)?  $default,) {final _that = this;
switch (_that) {
case _VoiceRecording() when $default != null:
return $default(_that.fileName,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc


class _VoiceRecording implements VoiceRecording {
  const _VoiceRecording({required this.fileName, required this.startedAt});
  

@override final  String fileName;
@override final  DateTime startedAt;

/// Create a copy of VoiceRecording
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoiceRecordingCopyWith<_VoiceRecording> get copyWith => __$VoiceRecordingCopyWithImpl<_VoiceRecording>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoiceRecording&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fileName,startedAt);
}

@override
String toString() {
    return 'VoiceRecording(fileName: $fileName, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$VoiceRecordingCopyWith<$Res> implements $VoiceRecordingCopyWith<$Res> {
  factory _$VoiceRecordingCopyWith(_VoiceRecording value, $Res Function(_VoiceRecording) _then) = __$VoiceRecordingCopyWithImpl;
@override @useResult
$Res call({
 String fileName, DateTime startedAt
});




}
/// @nodoc
class __$VoiceRecordingCopyWithImpl<$Res>
    implements _$VoiceRecordingCopyWith<$Res> {
  __$VoiceRecordingCopyWithImpl(this._self, this._then);

  final _VoiceRecording _self;
  final $Res Function(_VoiceRecording) _then;

/// Create a copy of VoiceRecording
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = null,Object? startedAt = null,}) {
  return _then(_VoiceRecording(
fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
