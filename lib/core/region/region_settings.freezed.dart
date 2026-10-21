// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegionSettings {

/// ISO 3166-1 alpha-2, büyük harf.
 String get countryCode;/// Yarımküre için enlem; bilinmiyorsa null ve Kuzey sayılır.
 double? get latitude;
/// Create a copy of RegionSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegionSettingsCopyWith<RegionSettings> get copyWith => _$RegionSettingsCopyWithImpl<RegionSettings>(this as RegionSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegionSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegionSettings&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude));
}


@override
int get hashCode {
  final _this = this as RegionSettings;
  return Object.hash(runtimeType,_this.countryCode,_this.latitude);
}

@override
String toString() {
  final _this = this as RegionSettings;
  return 'RegionSettings(countryCode: ${_this.countryCode}, latitude: ${_this.latitude})';
}


}

/// @nodoc
abstract mixin class $RegionSettingsCopyWith<$Res>  {
  factory $RegionSettingsCopyWith(RegionSettings value, $Res Function(RegionSettings) _then) = _$RegionSettingsCopyWithImpl;
@useResult
$Res call({
 String countryCode, double? latitude
});




}
/// @nodoc
class _$RegionSettingsCopyWithImpl<$Res>
    implements $RegionSettingsCopyWith<$Res> {
  _$RegionSettingsCopyWithImpl(this._self, this._then);

  final RegionSettings _self;
  final $Res Function(RegionSettings) _then;

/// Create a copy of RegionSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryCode = null,Object? latitude = freezed,}) {
  return _then(RegionSettings(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegionSettings].
extension RegionSettingsPatterns on RegionSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegionSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegionSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegionSettings value)  $default,){
final _that = this;
switch (_that) {
case _RegionSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegionSettings value)?  $default,){
final _that = this;
switch (_that) {
case _RegionSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  double? latitude)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegionSettings() when $default != null:
return $default(_that.countryCode,_that.latitude);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  double? latitude)  $default,) {final _that = this;
switch (_that) {
case _RegionSettings():
return $default(_that.countryCode,_that.latitude);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  double? latitude)?  $default,) {final _that = this;
switch (_that) {
case _RegionSettings() when $default != null:
return $default(_that.countryCode,_that.latitude);case _:
  return null;

}
}

}

/// @nodoc


class _RegionSettings implements RegionSettings {
  const _RegionSettings({this.countryCode = defaultCountryCode, this.latitude});
  

/// ISO 3166-1 alpha-2, büyük harf.
@override@JsonKey() final  String countryCode;
/// Yarımküre için enlem; bilinmiyorsa null ve Kuzey sayılır.
@override final  double? latitude;

/// Create a copy of RegionSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegionSettingsCopyWith<_RegionSettings> get copyWith => __$RegionSettingsCopyWithImpl<_RegionSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegionSettings&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.latitude, latitude) || other.latitude == latitude));
}


@override
int get hashCode {
    return Object.hash(runtimeType,countryCode,latitude);
}

@override
String toString() {
    return 'RegionSettings(countryCode: $countryCode, latitude: $latitude)';
}


}

/// @nodoc
abstract mixin class _$RegionSettingsCopyWith<$Res> implements $RegionSettingsCopyWith<$Res> {
  factory _$RegionSettingsCopyWith(_RegionSettings value, $Res Function(_RegionSettings) _then) = __$RegionSettingsCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, double? latitude
});




}
/// @nodoc
class __$RegionSettingsCopyWithImpl<$Res>
    implements _$RegionSettingsCopyWith<$Res> {
  __$RegionSettingsCopyWithImpl(this._self, this._then);

  final _RegionSettings _self;
  final $Res Function(_RegionSettings) _then;

/// Create a copy of RegionSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? latitude = freezed,}) {
  return _then(_RegionSettings(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
