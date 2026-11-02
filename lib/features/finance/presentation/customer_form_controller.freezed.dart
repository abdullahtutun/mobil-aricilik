// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerFormState {

 String get name; String get phone; String get address; String get notes; bool get saving;
/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerFormStateCopyWith<CustomerFormState> get copyWith => _$CustomerFormStateCopyWithImpl<CustomerFormState>(this as CustomerFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CustomerFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerFormState&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as CustomerFormState;
  return Object.hash(runtimeType,_this.name,_this.phone,_this.address,_this.notes,_this.saving);
}

@override
String toString() {
  final _this = this as CustomerFormState;
  return 'CustomerFormState(name: ${_this.name}, phone: ${_this.phone}, address: ${_this.address}, notes: ${_this.notes}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $CustomerFormStateCopyWith<$Res>  {
  factory $CustomerFormStateCopyWith(CustomerFormState value, $Res Function(CustomerFormState) _then) = _$CustomerFormStateCopyWithImpl;
@useResult
$Res call({
 String name, String phone, String address, String notes, bool saving
});




}
/// @nodoc
class _$CustomerFormStateCopyWithImpl<$Res>
    implements $CustomerFormStateCopyWith<$Res> {
  _$CustomerFormStateCopyWithImpl(this._self, this._then);

  final CustomerFormState _self;
  final $Res Function(CustomerFormState) _then;

/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? phone = null,Object? address = null,Object? notes = null,Object? saving = null,}) {
  return _then(CustomerFormState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerFormState].
extension CustomerFormStatePatterns on CustomerFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerFormState value)  $default,){
final _that = this;
switch (_that) {
case _CustomerFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String phone,  String address,  String notes,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
return $default(_that.name,_that.phone,_that.address,_that.notes,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String phone,  String address,  String notes,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _CustomerFormState():
return $default(_that.name,_that.phone,_that.address,_that.notes,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String phone,  String address,  String notes,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _CustomerFormState() when $default != null:
return $default(_that.name,_that.phone,_that.address,_that.notes,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerFormState implements CustomerFormState {
  const _CustomerFormState({this.name = '', this.phone = '', this.address = '', this.notes = '', this.saving = false});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String address;
@override@JsonKey() final  String notes;
@override@JsonKey() final  bool saving;

/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerFormStateCopyWith<_CustomerFormState> get copyWith => __$CustomerFormStateCopyWithImpl<_CustomerFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerFormState&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,phone,address,notes,saving);
}

@override
String toString() {
    return 'CustomerFormState(name: $name, phone: $phone, address: $address, notes: $notes, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$CustomerFormStateCopyWith<$Res> implements $CustomerFormStateCopyWith<$Res> {
  factory _$CustomerFormStateCopyWith(_CustomerFormState value, $Res Function(_CustomerFormState) _then) = __$CustomerFormStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String phone, String address, String notes, bool saving
});




}
/// @nodoc
class __$CustomerFormStateCopyWithImpl<$Res>
    implements _$CustomerFormStateCopyWith<$Res> {
  __$CustomerFormStateCopyWithImpl(this._self, this._then);

  final _CustomerFormState _self;
  final $Res Function(_CustomerFormState) _then;

/// Create a copy of CustomerFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? phone = null,Object? address = null,Object? notes = null,Object? saving = null,}) {
  return _then(_CustomerFormState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
