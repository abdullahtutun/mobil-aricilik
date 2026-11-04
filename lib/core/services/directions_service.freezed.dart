// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'directions_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DirectionsApp {

/// Kalıcı kimlik (ör. `google`, `waze`).
 String get id;/// Uygulamanın kendi adı (ör. "Apple Maps"); çevrilmez.
 String get name;
/// Create a copy of DirectionsApp
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirectionsAppCopyWith<DirectionsApp> get copyWith => _$DirectionsAppCopyWithImpl<DirectionsApp>(this as DirectionsApp, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DirectionsApp;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirectionsApp&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}


@override
int get hashCode {
  final _this = this as DirectionsApp;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as DirectionsApp;
  return 'DirectionsApp(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $DirectionsAppCopyWith<$Res>  {
  factory $DirectionsAppCopyWith(DirectionsApp value, $Res Function(DirectionsApp) _then) = _$DirectionsAppCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$DirectionsAppCopyWithImpl<$Res>
    implements $DirectionsAppCopyWith<$Res> {
  _$DirectionsAppCopyWithImpl(this._self, this._then);

  final DirectionsApp _self;
  final $Res Function(DirectionsApp) _then;

/// Create a copy of DirectionsApp
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(DirectionsApp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DirectionsApp].
extension DirectionsAppPatterns on DirectionsApp {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirectionsApp value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirectionsApp() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirectionsApp value)  $default,){
final _that = this;
switch (_that) {
case _DirectionsApp():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirectionsApp value)?  $default,){
final _that = this;
switch (_that) {
case _DirectionsApp() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirectionsApp() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _DirectionsApp():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _DirectionsApp() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _DirectionsApp implements DirectionsApp {
  const _DirectionsApp({required this.id, required this.name});
  

/// Kalıcı kimlik (ör. `google`, `waze`).
@override final  String id;
/// Uygulamanın kendi adı (ör. "Apple Maps"); çevrilmez.
@override final  String name;

/// Create a copy of DirectionsApp
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirectionsAppCopyWith<_DirectionsApp> get copyWith => __$DirectionsAppCopyWithImpl<_DirectionsApp>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirectionsApp&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'DirectionsApp(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$DirectionsAppCopyWith<$Res> implements $DirectionsAppCopyWith<$Res> {
  factory _$DirectionsAppCopyWith(_DirectionsApp value, $Res Function(_DirectionsApp) _then) = __$DirectionsAppCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$DirectionsAppCopyWithImpl<$Res>
    implements _$DirectionsAppCopyWith<$Res> {
  __$DirectionsAppCopyWithImpl(this._self, this._then);

  final _DirectionsApp _self;
  final $Res Function(_DirectionsApp) _then;

/// Create a copy of DirectionsApp
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_DirectionsApp(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
