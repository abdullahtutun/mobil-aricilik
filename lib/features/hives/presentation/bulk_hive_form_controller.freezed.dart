// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_hive_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BulkHiveFormState {

/// Kaç kovan; alan yazıldığı gibi.
 String get count; String get startNumber; HiveType get type; HiveSource? get source; bool get saving;
/// Create a copy of BulkHiveFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkHiveFormStateCopyWith<BulkHiveFormState> get copyWith => _$BulkHiveFormStateCopyWithImpl<BulkHiveFormState>(this as BulkHiveFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BulkHiveFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkHiveFormState&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.startNumber, _this.startNumber) || other.startNumber == _this.startNumber)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as BulkHiveFormState;
  return Object.hash(runtimeType,_this.count,_this.startNumber,_this.type,_this.source,_this.saving);
}

@override
String toString() {
  final _this = this as BulkHiveFormState;
  return 'BulkHiveFormState(count: ${_this.count}, startNumber: ${_this.startNumber}, type: ${_this.type}, source: ${_this.source}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $BulkHiveFormStateCopyWith<$Res>  {
  factory $BulkHiveFormStateCopyWith(BulkHiveFormState value, $Res Function(BulkHiveFormState) _then) = _$BulkHiveFormStateCopyWithImpl;
@useResult
$Res call({
 String count, String startNumber, HiveType type, HiveSource? source, bool saving
});




}
/// @nodoc
class _$BulkHiveFormStateCopyWithImpl<$Res>
    implements $BulkHiveFormStateCopyWith<$Res> {
  _$BulkHiveFormStateCopyWithImpl(this._self, this._then);

  final BulkHiveFormState _self;
  final $Res Function(BulkHiveFormState) _then;

/// Create a copy of BulkHiveFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? startNumber = null,Object? type = null,Object? source = freezed,Object? saving = null,}) {
  return _then(BulkHiveFormState(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as String,startNumber: null == startNumber ? _self.startNumber : startNumber // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HiveType,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HiveSource?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BulkHiveFormState].
extension BulkHiveFormStatePatterns on BulkHiveFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BulkHiveFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BulkHiveFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BulkHiveFormState value)  $default,){
final _that = this;
switch (_that) {
case _BulkHiveFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BulkHiveFormState value)?  $default,){
final _that = this;
switch (_that) {
case _BulkHiveFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String count,  String startNumber,  HiveType type,  HiveSource? source,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BulkHiveFormState() when $default != null:
return $default(_that.count,_that.startNumber,_that.type,_that.source,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String count,  String startNumber,  HiveType type,  HiveSource? source,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _BulkHiveFormState():
return $default(_that.count,_that.startNumber,_that.type,_that.source,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String count,  String startNumber,  HiveType type,  HiveSource? source,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _BulkHiveFormState() when $default != null:
return $default(_that.count,_that.startNumber,_that.type,_that.source,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _BulkHiveFormState implements BulkHiveFormState {
  const _BulkHiveFormState({this.count = '', this.startNumber = '', this.type = HiveType.langstroth, this.source, this.saving = false});
  

/// Kaç kovan; alan yazıldığı gibi.
@override@JsonKey() final  String count;
@override@JsonKey() final  String startNumber;
@override@JsonKey() final  HiveType type;
@override final  HiveSource? source;
@override@JsonKey() final  bool saving;

/// Create a copy of BulkHiveFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BulkHiveFormStateCopyWith<_BulkHiveFormState> get copyWith => __$BulkHiveFormStateCopyWithImpl<_BulkHiveFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BulkHiveFormState&&(identical(other.count, count) || other.count == count)&&(identical(other.startNumber, startNumber) || other.startNumber == startNumber)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,count,startNumber,type,source,saving);
}

@override
String toString() {
    return 'BulkHiveFormState(count: $count, startNumber: $startNumber, type: $type, source: $source, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$BulkHiveFormStateCopyWith<$Res> implements $BulkHiveFormStateCopyWith<$Res> {
  factory _$BulkHiveFormStateCopyWith(_BulkHiveFormState value, $Res Function(_BulkHiveFormState) _then) = __$BulkHiveFormStateCopyWithImpl;
@override @useResult
$Res call({
 String count, String startNumber, HiveType type, HiveSource? source, bool saving
});




}
/// @nodoc
class __$BulkHiveFormStateCopyWithImpl<$Res>
    implements _$BulkHiveFormStateCopyWith<$Res> {
  __$BulkHiveFormStateCopyWithImpl(this._self, this._then);

  final _BulkHiveFormState _self;
  final $Res Function(_BulkHiveFormState) _then;

/// Create a copy of BulkHiveFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? startNumber = null,Object? type = null,Object? source = freezed,Object? saving = null,}) {
  return _then(_BulkHiveFormState(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as String,startNumber: null == startNumber ? _self.startNumber : startNumber // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as HiveType,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HiveSource?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
