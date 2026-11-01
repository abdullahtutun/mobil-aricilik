// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InventoryFormState {

 String get name; InventoryCategory? get category; InventoryUnit? get unit; String get place;/// Yazıldığı gibi; boşsa eşik yok.
 String get threshold; bool get saving;
/// Create a copy of InventoryFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryFormStateCopyWith<InventoryFormState> get copyWith => _$InventoryFormStateCopyWithImpl<InventoryFormState>(this as InventoryFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InventoryFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryFormState&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.threshold, _this.threshold) || other.threshold == _this.threshold)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as InventoryFormState;
  return Object.hash(runtimeType,_this.name,_this.category,_this.unit,_this.place,_this.threshold,_this.saving);
}

@override
String toString() {
  final _this = this as InventoryFormState;
  return 'InventoryFormState(name: ${_this.name}, category: ${_this.category}, unit: ${_this.unit}, place: ${_this.place}, threshold: ${_this.threshold}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $InventoryFormStateCopyWith<$Res>  {
  factory $InventoryFormStateCopyWith(InventoryFormState value, $Res Function(InventoryFormState) _then) = _$InventoryFormStateCopyWithImpl;
@useResult
$Res call({
 String name, InventoryCategory? category, InventoryUnit? unit, String place, String threshold, bool saving
});




}
/// @nodoc
class _$InventoryFormStateCopyWithImpl<$Res>
    implements $InventoryFormStateCopyWith<$Res> {
  _$InventoryFormStateCopyWithImpl(this._self, this._then);

  final InventoryFormState _self;
  final $Res Function(InventoryFormState) _then;

/// Create a copy of InventoryFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = freezed,Object? unit = freezed,Object? place = null,Object? threshold = null,Object? saving = null,}) {
  return _then(InventoryFormState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryCategory?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryUnit?,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryFormState].
extension InventoryFormStatePatterns on InventoryFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryFormState value)  $default,){
final _that = this;
switch (_that) {
case _InventoryFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryFormState value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  InventoryCategory? category,  InventoryUnit? unit,  String place,  String threshold,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryFormState() when $default != null:
return $default(_that.name,_that.category,_that.unit,_that.place,_that.threshold,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  InventoryCategory? category,  InventoryUnit? unit,  String place,  String threshold,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _InventoryFormState():
return $default(_that.name,_that.category,_that.unit,_that.place,_that.threshold,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  InventoryCategory? category,  InventoryUnit? unit,  String place,  String threshold,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _InventoryFormState() when $default != null:
return $default(_that.name,_that.category,_that.unit,_that.place,_that.threshold,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _InventoryFormState implements InventoryFormState {
  const _InventoryFormState({this.name = '', this.category, this.unit, this.place = '', this.threshold = '', this.saving = false});
  

@override@JsonKey() final  String name;
@override final  InventoryCategory? category;
@override final  InventoryUnit? unit;
@override@JsonKey() final  String place;
/// Yazıldığı gibi; boşsa eşik yok.
@override@JsonKey() final  String threshold;
@override@JsonKey() final  bool saving;

/// Create a copy of InventoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryFormStateCopyWith<_InventoryFormState> get copyWith => __$InventoryFormStateCopyWithImpl<_InventoryFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryFormState&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.place, place) || other.place == place)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,category,unit,place,threshold,saving);
}

@override
String toString() {
    return 'InventoryFormState(name: $name, category: $category, unit: $unit, place: $place, threshold: $threshold, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$InventoryFormStateCopyWith<$Res> implements $InventoryFormStateCopyWith<$Res> {
  factory _$InventoryFormStateCopyWith(_InventoryFormState value, $Res Function(_InventoryFormState) _then) = __$InventoryFormStateCopyWithImpl;
@override @useResult
$Res call({
 String name, InventoryCategory? category, InventoryUnit? unit, String place, String threshold, bool saving
});




}
/// @nodoc
class __$InventoryFormStateCopyWithImpl<$Res>
    implements _$InventoryFormStateCopyWith<$Res> {
  __$InventoryFormStateCopyWithImpl(this._self, this._then);

  final _InventoryFormState _self;
  final $Res Function(_InventoryFormState) _then;

/// Create a copy of InventoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = freezed,Object? unit = freezed,Object? place = null,Object? threshold = null,Object? saving = null,}) {
  return _then(_InventoryFormState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryCategory?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryUnit?,place: null == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
