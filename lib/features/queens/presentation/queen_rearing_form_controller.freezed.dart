// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queen_rearing_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueenRearingFormState {

 DateTime get graftedOn; int get graftedCount; String? get motherQueenId;/// Kabul edilen meme; sayılmadıysa boş.
 int? get acceptedCount; bool get saving;
/// Create a copy of QueenRearingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueenRearingFormStateCopyWith<QueenRearingFormState> get copyWith => _$QueenRearingFormStateCopyWithImpl<QueenRearingFormState>(this as QueenRearingFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QueenRearingFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueenRearingFormState&&(identical(other.graftedOn, _this.graftedOn) || other.graftedOn == _this.graftedOn)&&(identical(other.graftedCount, _this.graftedCount) || other.graftedCount == _this.graftedCount)&&(identical(other.motherQueenId, _this.motherQueenId) || other.motherQueenId == _this.motherQueenId)&&(identical(other.acceptedCount, _this.acceptedCount) || other.acceptedCount == _this.acceptedCount)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as QueenRearingFormState;
  return Object.hash(runtimeType,_this.graftedOn,_this.graftedCount,_this.motherQueenId,_this.acceptedCount,_this.saving);
}

@override
String toString() {
  final _this = this as QueenRearingFormState;
  return 'QueenRearingFormState(graftedOn: ${_this.graftedOn}, graftedCount: ${_this.graftedCount}, motherQueenId: ${_this.motherQueenId}, acceptedCount: ${_this.acceptedCount}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $QueenRearingFormStateCopyWith<$Res>  {
  factory $QueenRearingFormStateCopyWith(QueenRearingFormState value, $Res Function(QueenRearingFormState) _then) = _$QueenRearingFormStateCopyWithImpl;
@useResult
$Res call({
 DateTime graftedOn, int graftedCount, String? motherQueenId, int? acceptedCount, bool saving
});




}
/// @nodoc
class _$QueenRearingFormStateCopyWithImpl<$Res>
    implements $QueenRearingFormStateCopyWith<$Res> {
  _$QueenRearingFormStateCopyWithImpl(this._self, this._then);

  final QueenRearingFormState _self;
  final $Res Function(QueenRearingFormState) _then;

/// Create a copy of QueenRearingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? graftedOn = null,Object? graftedCount = null,Object? motherQueenId = freezed,Object? acceptedCount = freezed,Object? saving = null,}) {
  return _then(QueenRearingFormState(
graftedOn: null == graftedOn ? _self.graftedOn : graftedOn // ignore: cast_nullable_to_non_nullable
as DateTime,graftedCount: null == graftedCount ? _self.graftedCount : graftedCount // ignore: cast_nullable_to_non_nullable
as int,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,acceptedCount: freezed == acceptedCount ? _self.acceptedCount : acceptedCount // ignore: cast_nullable_to_non_nullable
as int?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QueenRearingFormState].
extension QueenRearingFormStatePatterns on QueenRearingFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueenRearingFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueenRearingFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueenRearingFormState value)  $default,){
final _that = this;
switch (_that) {
case _QueenRearingFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueenRearingFormState value)?  $default,){
final _that = this;
switch (_that) {
case _QueenRearingFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime graftedOn,  int graftedCount,  String? motherQueenId,  int? acceptedCount,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueenRearingFormState() when $default != null:
return $default(_that.graftedOn,_that.graftedCount,_that.motherQueenId,_that.acceptedCount,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime graftedOn,  int graftedCount,  String? motherQueenId,  int? acceptedCount,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _QueenRearingFormState():
return $default(_that.graftedOn,_that.graftedCount,_that.motherQueenId,_that.acceptedCount,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime graftedOn,  int graftedCount,  String? motherQueenId,  int? acceptedCount,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _QueenRearingFormState() when $default != null:
return $default(_that.graftedOn,_that.graftedCount,_that.motherQueenId,_that.acceptedCount,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _QueenRearingFormState implements QueenRearingFormState {
  const _QueenRearingFormState({required this.graftedOn, this.graftedCount = defaultGraftedCount, this.motherQueenId, this.acceptedCount, this.saving = false});
  

@override final  DateTime graftedOn;
@override@JsonKey() final  int graftedCount;
@override final  String? motherQueenId;
/// Kabul edilen meme; sayılmadıysa boş.
@override final  int? acceptedCount;
@override@JsonKey() final  bool saving;

/// Create a copy of QueenRearingFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueenRearingFormStateCopyWith<_QueenRearingFormState> get copyWith => __$QueenRearingFormStateCopyWithImpl<_QueenRearingFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueenRearingFormState&&(identical(other.graftedOn, graftedOn) || other.graftedOn == graftedOn)&&(identical(other.graftedCount, graftedCount) || other.graftedCount == graftedCount)&&(identical(other.motherQueenId, motherQueenId) || other.motherQueenId == motherQueenId)&&(identical(other.acceptedCount, acceptedCount) || other.acceptedCount == acceptedCount)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,graftedOn,graftedCount,motherQueenId,acceptedCount,saving);
}

@override
String toString() {
    return 'QueenRearingFormState(graftedOn: $graftedOn, graftedCount: $graftedCount, motherQueenId: $motherQueenId, acceptedCount: $acceptedCount, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$QueenRearingFormStateCopyWith<$Res> implements $QueenRearingFormStateCopyWith<$Res> {
  factory _$QueenRearingFormStateCopyWith(_QueenRearingFormState value, $Res Function(_QueenRearingFormState) _then) = __$QueenRearingFormStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime graftedOn, int graftedCount, String? motherQueenId, int? acceptedCount, bool saving
});




}
/// @nodoc
class __$QueenRearingFormStateCopyWithImpl<$Res>
    implements _$QueenRearingFormStateCopyWith<$Res> {
  __$QueenRearingFormStateCopyWithImpl(this._self, this._then);

  final _QueenRearingFormState _self;
  final $Res Function(_QueenRearingFormState) _then;

/// Create a copy of QueenRearingFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? graftedOn = null,Object? graftedCount = null,Object? motherQueenId = freezed,Object? acceptedCount = freezed,Object? saving = null,}) {
  return _then(_QueenRearingFormState(
graftedOn: null == graftedOn ? _self.graftedOn : graftedOn // ignore: cast_nullable_to_non_nullable
as DateTime,graftedCount: null == graftedCount ? _self.graftedCount : graftedCount // ignore: cast_nullable_to_non_nullable
as int,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,acceptedCount: freezed == acceptedCount ? _self.acceptedCount : acceptedCount // ignore: cast_nullable_to_non_nullable
as int?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
