// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'migration_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MigrationFormState {

 int get year; String get name; bool get saving;
/// Create a copy of MigrationFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MigrationFormStateCopyWith<MigrationFormState> get copyWith => _$MigrationFormStateCopyWithImpl<MigrationFormState>(this as MigrationFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MigrationFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MigrationFormState&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as MigrationFormState;
  return Object.hash(runtimeType,_this.year,_this.name,_this.saving);
}

@override
String toString() {
  final _this = this as MigrationFormState;
  return 'MigrationFormState(year: ${_this.year}, name: ${_this.name}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $MigrationFormStateCopyWith<$Res>  {
  factory $MigrationFormStateCopyWith(MigrationFormState value, $Res Function(MigrationFormState) _then) = _$MigrationFormStateCopyWithImpl;
@useResult
$Res call({
 int year, String name, bool saving
});




}
/// @nodoc
class _$MigrationFormStateCopyWithImpl<$Res>
    implements $MigrationFormStateCopyWith<$Res> {
  _$MigrationFormStateCopyWithImpl(this._self, this._then);

  final MigrationFormState _self;
  final $Res Function(MigrationFormState) _then;

/// Create a copy of MigrationFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? name = null,Object? saving = null,}) {
  return _then(MigrationFormState(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MigrationFormState].
extension MigrationFormStatePatterns on MigrationFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MigrationFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MigrationFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MigrationFormState value)  $default,){
final _that = this;
switch (_that) {
case _MigrationFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MigrationFormState value)?  $default,){
final _that = this;
switch (_that) {
case _MigrationFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  String name,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MigrationFormState() when $default != null:
return $default(_that.year,_that.name,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  String name,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _MigrationFormState():
return $default(_that.year,_that.name,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  String name,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _MigrationFormState() when $default != null:
return $default(_that.year,_that.name,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _MigrationFormState implements MigrationFormState {
  const _MigrationFormState({required this.year, this.name = '', this.saving = false});
  

@override final  int year;
@override@JsonKey() final  String name;
@override@JsonKey() final  bool saving;

/// Create a copy of MigrationFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MigrationFormStateCopyWith<_MigrationFormState> get copyWith => __$MigrationFormStateCopyWithImpl<_MigrationFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MigrationFormState&&(identical(other.year, year) || other.year == year)&&(identical(other.name, name) || other.name == name)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,year,name,saving);
}

@override
String toString() {
    return 'MigrationFormState(year: $year, name: $name, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$MigrationFormStateCopyWith<$Res> implements $MigrationFormStateCopyWith<$Res> {
  factory _$MigrationFormStateCopyWith(_MigrationFormState value, $Res Function(_MigrationFormState) _then) = __$MigrationFormStateCopyWithImpl;
@override @useResult
$Res call({
 int year, String name, bool saving
});




}
/// @nodoc
class __$MigrationFormStateCopyWithImpl<$Res>
    implements _$MigrationFormStateCopyWith<$Res> {
  __$MigrationFormStateCopyWithImpl(this._self, this._then);

  final _MigrationFormState _self;
  final $Res Function(_MigrationFormState) _then;

/// Create a copy of MigrationFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? name = null,Object? saving = null,}) {
  return _then(_MigrationFormState(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
