// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegionFeatures {

/// AKS, işletme tescil no ve birlik üyeliği. Kapalıyken yerine serbest
/// "kayıt numarası" alanı gelir.
 bool get aks;/// Arılı kovan desteği ve destek hatırlatıcıları.
 bool get subsidies;/// TR mevzuat kütüphanesi.
 bool get regulations;/// TR'de ruhsatlı ilaç listesi. Kapalıyken etken madde bazlı genel liste.
 bool get trDrugList;/// TR bölgelerinin hazır flora takvimi. Kapalıyken takvim boş başlar.
 bool get trFlora;/// TR gezginci belge türleri (nakil evrakı, sağlık raporu vb.). Kapalıyken
/// belge türlerini kullanıcı tanımlar.
 bool get trMigrationDocs;
/// Create a copy of RegionFeatures
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegionFeaturesCopyWith<RegionFeatures> get copyWith => _$RegionFeaturesCopyWithImpl<RegionFeatures>(this as RegionFeatures, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegionFeatures;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegionFeatures&&(identical(other.aks, _this.aks) || other.aks == _this.aks)&&(identical(other.subsidies, _this.subsidies) || other.subsidies == _this.subsidies)&&(identical(other.regulations, _this.regulations) || other.regulations == _this.regulations)&&(identical(other.trDrugList, _this.trDrugList) || other.trDrugList == _this.trDrugList)&&(identical(other.trFlora, _this.trFlora) || other.trFlora == _this.trFlora)&&(identical(other.trMigrationDocs, _this.trMigrationDocs) || other.trMigrationDocs == _this.trMigrationDocs));
}


@override
int get hashCode {
  final _this = this as RegionFeatures;
  return Object.hash(runtimeType,_this.aks,_this.subsidies,_this.regulations,_this.trDrugList,_this.trFlora,_this.trMigrationDocs);
}

@override
String toString() {
  final _this = this as RegionFeatures;
  return 'RegionFeatures(aks: ${_this.aks}, subsidies: ${_this.subsidies}, regulations: ${_this.regulations}, trDrugList: ${_this.trDrugList}, trFlora: ${_this.trFlora}, trMigrationDocs: ${_this.trMigrationDocs})';
}


}

/// @nodoc
abstract mixin class $RegionFeaturesCopyWith<$Res>  {
  factory $RegionFeaturesCopyWith(RegionFeatures value, $Res Function(RegionFeatures) _then) = _$RegionFeaturesCopyWithImpl;
@useResult
$Res call({
 bool aks, bool subsidies, bool regulations, bool trDrugList, bool trFlora, bool trMigrationDocs
});




}
/// @nodoc
class _$RegionFeaturesCopyWithImpl<$Res>
    implements $RegionFeaturesCopyWith<$Res> {
  _$RegionFeaturesCopyWithImpl(this._self, this._then);

  final RegionFeatures _self;
  final $Res Function(RegionFeatures) _then;

/// Create a copy of RegionFeatures
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aks = null,Object? subsidies = null,Object? regulations = null,Object? trDrugList = null,Object? trFlora = null,Object? trMigrationDocs = null,}) {
  return _then(RegionFeatures(
aks: null == aks ? _self.aks : aks // ignore: cast_nullable_to_non_nullable
as bool,subsidies: null == subsidies ? _self.subsidies : subsidies // ignore: cast_nullable_to_non_nullable
as bool,regulations: null == regulations ? _self.regulations : regulations // ignore: cast_nullable_to_non_nullable
as bool,trDrugList: null == trDrugList ? _self.trDrugList : trDrugList // ignore: cast_nullable_to_non_nullable
as bool,trFlora: null == trFlora ? _self.trFlora : trFlora // ignore: cast_nullable_to_non_nullable
as bool,trMigrationDocs: null == trMigrationDocs ? _self.trMigrationDocs : trMigrationDocs // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RegionFeatures].
extension RegionFeaturesPatterns on RegionFeatures {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegionFeatures value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegionFeatures() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegionFeatures value)  $default,){
final _that = this;
switch (_that) {
case _RegionFeatures():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegionFeatures value)?  $default,){
final _that = this;
switch (_that) {
case _RegionFeatures() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool aks,  bool subsidies,  bool regulations,  bool trDrugList,  bool trFlora,  bool trMigrationDocs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegionFeatures() when $default != null:
return $default(_that.aks,_that.subsidies,_that.regulations,_that.trDrugList,_that.trFlora,_that.trMigrationDocs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool aks,  bool subsidies,  bool regulations,  bool trDrugList,  bool trFlora,  bool trMigrationDocs)  $default,) {final _that = this;
switch (_that) {
case _RegionFeatures():
return $default(_that.aks,_that.subsidies,_that.regulations,_that.trDrugList,_that.trFlora,_that.trMigrationDocs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool aks,  bool subsidies,  bool regulations,  bool trDrugList,  bool trFlora,  bool trMigrationDocs)?  $default,) {final _that = this;
switch (_that) {
case _RegionFeatures() when $default != null:
return $default(_that.aks,_that.subsidies,_that.regulations,_that.trDrugList,_that.trFlora,_that.trMigrationDocs);case _:
  return null;

}
}

}

/// @nodoc


class _RegionFeatures implements RegionFeatures {
  const _RegionFeatures({this.aks = false, this.subsidies = false, this.regulations = false, this.trDrugList = false, this.trFlora = false, this.trMigrationDocs = false});
  

/// AKS, işletme tescil no ve birlik üyeliği. Kapalıyken yerine serbest
/// "kayıt numarası" alanı gelir.
@override@JsonKey() final  bool aks;
/// Arılı kovan desteği ve destek hatırlatıcıları.
@override@JsonKey() final  bool subsidies;
/// TR mevzuat kütüphanesi.
@override@JsonKey() final  bool regulations;
/// TR'de ruhsatlı ilaç listesi. Kapalıyken etken madde bazlı genel liste.
@override@JsonKey() final  bool trDrugList;
/// TR bölgelerinin hazır flora takvimi. Kapalıyken takvim boş başlar.
@override@JsonKey() final  bool trFlora;
/// TR gezginci belge türleri (nakil evrakı, sağlık raporu vb.). Kapalıyken
/// belge türlerini kullanıcı tanımlar.
@override@JsonKey() final  bool trMigrationDocs;

/// Create a copy of RegionFeatures
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegionFeaturesCopyWith<_RegionFeatures> get copyWith => __$RegionFeaturesCopyWithImpl<_RegionFeatures>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegionFeatures&&(identical(other.aks, aks) || other.aks == aks)&&(identical(other.subsidies, subsidies) || other.subsidies == subsidies)&&(identical(other.regulations, regulations) || other.regulations == regulations)&&(identical(other.trDrugList, trDrugList) || other.trDrugList == trDrugList)&&(identical(other.trFlora, trFlora) || other.trFlora == trFlora)&&(identical(other.trMigrationDocs, trMigrationDocs) || other.trMigrationDocs == trMigrationDocs));
}


@override
int get hashCode {
    return Object.hash(runtimeType,aks,subsidies,regulations,trDrugList,trFlora,trMigrationDocs);
}

@override
String toString() {
    return 'RegionFeatures(aks: $aks, subsidies: $subsidies, regulations: $regulations, trDrugList: $trDrugList, trFlora: $trFlora, trMigrationDocs: $trMigrationDocs)';
}


}

/// @nodoc
abstract mixin class _$RegionFeaturesCopyWith<$Res> implements $RegionFeaturesCopyWith<$Res> {
  factory _$RegionFeaturesCopyWith(_RegionFeatures value, $Res Function(_RegionFeatures) _then) = __$RegionFeaturesCopyWithImpl;
@override @useResult
$Res call({
 bool aks, bool subsidies, bool regulations, bool trDrugList, bool trFlora, bool trMigrationDocs
});




}
/// @nodoc
class __$RegionFeaturesCopyWithImpl<$Res>
    implements _$RegionFeaturesCopyWith<$Res> {
  __$RegionFeaturesCopyWithImpl(this._self, this._then);

  final _RegionFeatures _self;
  final $Res Function(_RegionFeatures) _then;

/// Create a copy of RegionFeatures
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aks = null,Object? subsidies = null,Object? regulations = null,Object? trDrugList = null,Object? trFlora = null,Object? trMigrationDocs = null,}) {
  return _then(_RegionFeatures(
aks: null == aks ? _self.aks : aks // ignore: cast_nullable_to_non_nullable
as bool,subsidies: null == subsidies ? _self.subsidies : subsidies // ignore: cast_nullable_to_non_nullable
as bool,regulations: null == regulations ? _self.regulations : regulations // ignore: cast_nullable_to_non_nullable
as bool,trDrugList: null == trDrugList ? _self.trDrugList : trDrugList // ignore: cast_nullable_to_non_nullable
as bool,trFlora: null == trFlora ? _self.trFlora : trFlora // ignore: cast_nullable_to_non_nullable
as bool,trMigrationDocs: null == trMigrationDocs ? _self.trMigrationDocs : trMigrationDocs // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DefaultUnits {

 MassUnit get mass; TemperatureUnit get temperature; VolumeUnit get volume; SpeedUnit get speed;
/// Create a copy of DefaultUnits
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultUnitsCopyWith<DefaultUnits> get copyWith => _$DefaultUnitsCopyWithImpl<DefaultUnits>(this as DefaultUnits, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DefaultUnits;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultUnits&&(identical(other.mass, _this.mass) || other.mass == _this.mass)&&(identical(other.temperature, _this.temperature) || other.temperature == _this.temperature)&&(identical(other.volume, _this.volume) || other.volume == _this.volume)&&(identical(other.speed, _this.speed) || other.speed == _this.speed));
}


@override
int get hashCode {
  final _this = this as DefaultUnits;
  return Object.hash(runtimeType,_this.mass,_this.temperature,_this.volume,_this.speed);
}

@override
String toString() {
  final _this = this as DefaultUnits;
  return 'DefaultUnits(mass: ${_this.mass}, temperature: ${_this.temperature}, volume: ${_this.volume}, speed: ${_this.speed})';
}


}

/// @nodoc
abstract mixin class $DefaultUnitsCopyWith<$Res>  {
  factory $DefaultUnitsCopyWith(DefaultUnits value, $Res Function(DefaultUnits) _then) = _$DefaultUnitsCopyWithImpl;
@useResult
$Res call({
 MassUnit mass, TemperatureUnit temperature, VolumeUnit volume, SpeedUnit speed
});




}
/// @nodoc
class _$DefaultUnitsCopyWithImpl<$Res>
    implements $DefaultUnitsCopyWith<$Res> {
  _$DefaultUnitsCopyWithImpl(this._self, this._then);

  final DefaultUnits _self;
  final $Res Function(DefaultUnits) _then;

/// Create a copy of DefaultUnits
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mass = null,Object? temperature = null,Object? volume = null,Object? speed = null,}) {
  return _then(DefaultUnits(
mass: null == mass ? _self.mass : mass // ignore: cast_nullable_to_non_nullable
as MassUnit,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as TemperatureUnit,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as VolumeUnit,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as SpeedUnit,
  ));
}

}


/// Adds pattern-matching-related methods to [DefaultUnits].
extension DefaultUnitsPatterns on DefaultUnits {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DefaultUnits value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DefaultUnits() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DefaultUnits value)  $default,){
final _that = this;
switch (_that) {
case _DefaultUnits():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DefaultUnits value)?  $default,){
final _that = this;
switch (_that) {
case _DefaultUnits() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MassUnit mass,  TemperatureUnit temperature,  VolumeUnit volume,  SpeedUnit speed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DefaultUnits() when $default != null:
return $default(_that.mass,_that.temperature,_that.volume,_that.speed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MassUnit mass,  TemperatureUnit temperature,  VolumeUnit volume,  SpeedUnit speed)  $default,) {final _that = this;
switch (_that) {
case _DefaultUnits():
return $default(_that.mass,_that.temperature,_that.volume,_that.speed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MassUnit mass,  TemperatureUnit temperature,  VolumeUnit volume,  SpeedUnit speed)?  $default,) {final _that = this;
switch (_that) {
case _DefaultUnits() when $default != null:
return $default(_that.mass,_that.temperature,_that.volume,_that.speed);case _:
  return null;

}
}

}

/// @nodoc


class _DefaultUnits implements DefaultUnits {
  const _DefaultUnits({this.mass = MassUnit.kilogram, this.temperature = TemperatureUnit.celsius, this.volume = VolumeUnit.liter, this.speed = SpeedUnit.kilometersPerHour});
  

@override@JsonKey() final  MassUnit mass;
@override@JsonKey() final  TemperatureUnit temperature;
@override@JsonKey() final  VolumeUnit volume;
@override@JsonKey() final  SpeedUnit speed;

/// Create a copy of DefaultUnits
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DefaultUnitsCopyWith<_DefaultUnits> get copyWith => __$DefaultUnitsCopyWithImpl<_DefaultUnits>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DefaultUnits&&(identical(other.mass, mass) || other.mass == mass)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.speed, speed) || other.speed == speed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mass,temperature,volume,speed);
}

@override
String toString() {
    return 'DefaultUnits(mass: $mass, temperature: $temperature, volume: $volume, speed: $speed)';
}


}

/// @nodoc
abstract mixin class _$DefaultUnitsCopyWith<$Res> implements $DefaultUnitsCopyWith<$Res> {
  factory _$DefaultUnitsCopyWith(_DefaultUnits value, $Res Function(_DefaultUnits) _then) = __$DefaultUnitsCopyWithImpl;
@override @useResult
$Res call({
 MassUnit mass, TemperatureUnit temperature, VolumeUnit volume, SpeedUnit speed
});




}
/// @nodoc
class __$DefaultUnitsCopyWithImpl<$Res>
    implements _$DefaultUnitsCopyWith<$Res> {
  __$DefaultUnitsCopyWithImpl(this._self, this._then);

  final _DefaultUnits _self;
  final $Res Function(_DefaultUnits) _then;

/// Create a copy of DefaultUnits
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mass = null,Object? temperature = null,Object? volume = null,Object? speed = null,}) {
  return _then(_DefaultUnits(
mass: null == mass ? _self.mass : mass // ignore: cast_nullable_to_non_nullable
as MassUnit,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as TemperatureUnit,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as VolumeUnit,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as SpeedUnit,
  ));
}


}

/// @nodoc
mixin _$RegionConfig {

/// ISO 3166-1 alpha-2, büyük harf. Referans verinin ülke etiketi için;
/// ekran kararları bundan değil `features`'tan verilir.
 String get countryCode; RegionProfile get profile; RegionFeatures get features;/// ISO 4217 (ör. `TRY`).
 String get currencyCode; DefaultUnits get defaultUnits; Hemisphere get hemisphere;
/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegionConfigCopyWith<RegionConfig> get copyWith => _$RegionConfigCopyWithImpl<RegionConfig>(this as RegionConfig, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RegionConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegionConfig&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.features, _this.features) || other.features == _this.features)&&(identical(other.currencyCode, _this.currencyCode) || other.currencyCode == _this.currencyCode)&&(identical(other.defaultUnits, _this.defaultUnits) || other.defaultUnits == _this.defaultUnits)&&(identical(other.hemisphere, _this.hemisphere) || other.hemisphere == _this.hemisphere));
}


@override
int get hashCode {
  final _this = this as RegionConfig;
  return Object.hash(runtimeType,_this.countryCode,_this.profile,_this.features,_this.currencyCode,_this.defaultUnits,_this.hemisphere);
}

@override
String toString() {
  final _this = this as RegionConfig;
  return 'RegionConfig(countryCode: ${_this.countryCode}, profile: ${_this.profile}, features: ${_this.features}, currencyCode: ${_this.currencyCode}, defaultUnits: ${_this.defaultUnits}, hemisphere: ${_this.hemisphere})';
}


}

/// @nodoc
abstract mixin class $RegionConfigCopyWith<$Res>  {
  factory $RegionConfigCopyWith(RegionConfig value, $Res Function(RegionConfig) _then) = _$RegionConfigCopyWithImpl;
@useResult
$Res call({
 String countryCode, RegionProfile profile, RegionFeatures features, String currencyCode, DefaultUnits defaultUnits, Hemisphere hemisphere
});


$RegionFeaturesCopyWith<$Res> get features;$DefaultUnitsCopyWith<$Res> get defaultUnits;

}
/// @nodoc
class _$RegionConfigCopyWithImpl<$Res>
    implements $RegionConfigCopyWith<$Res> {
  _$RegionConfigCopyWithImpl(this._self, this._then);

  final RegionConfig _self;
  final $Res Function(RegionConfig) _then;

/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryCode = null,Object? profile = null,Object? features = null,Object? currencyCode = null,Object? defaultUnits = null,Object? hemisphere = null,}) {
  return _then(RegionConfig(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as RegionProfile,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as RegionFeatures,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,defaultUnits: null == defaultUnits ? _self.defaultUnits : defaultUnits // ignore: cast_nullable_to_non_nullable
as DefaultUnits,hemisphere: null == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere,
  ));
}
/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegionFeaturesCopyWith<$Res> get features {
  
  return $RegionFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DefaultUnitsCopyWith<$Res> get defaultUnits {
  
  return $DefaultUnitsCopyWith<$Res>(_self.defaultUnits, (value) {
    return _then(_self.copyWith(defaultUnits: value));
  });
}
}


/// Adds pattern-matching-related methods to [RegionConfig].
extension RegionConfigPatterns on RegionConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegionConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegionConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegionConfig value)  $default,){
final _that = this;
switch (_that) {
case _RegionConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegionConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RegionConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  RegionProfile profile,  RegionFeatures features,  String currencyCode,  DefaultUnits defaultUnits,  Hemisphere hemisphere)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegionConfig() when $default != null:
return $default(_that.countryCode,_that.profile,_that.features,_that.currencyCode,_that.defaultUnits,_that.hemisphere);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  RegionProfile profile,  RegionFeatures features,  String currencyCode,  DefaultUnits defaultUnits,  Hemisphere hemisphere)  $default,) {final _that = this;
switch (_that) {
case _RegionConfig():
return $default(_that.countryCode,_that.profile,_that.features,_that.currencyCode,_that.defaultUnits,_that.hemisphere);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  RegionProfile profile,  RegionFeatures features,  String currencyCode,  DefaultUnits defaultUnits,  Hemisphere hemisphere)?  $default,) {final _that = this;
switch (_that) {
case _RegionConfig() when $default != null:
return $default(_that.countryCode,_that.profile,_that.features,_that.currencyCode,_that.defaultUnits,_that.hemisphere);case _:
  return null;

}
}

}

/// @nodoc


class _RegionConfig implements RegionConfig {
  const _RegionConfig({required this.countryCode, required this.profile, required this.features, required this.currencyCode, required this.defaultUnits, required this.hemisphere});
  

/// ISO 3166-1 alpha-2, büyük harf. Referans verinin ülke etiketi için;
/// ekran kararları bundan değil `features`'tan verilir.
@override final  String countryCode;
@override final  RegionProfile profile;
@override final  RegionFeatures features;
/// ISO 4217 (ör. `TRY`).
@override final  String currencyCode;
@override final  DefaultUnits defaultUnits;
@override final  Hemisphere hemisphere;

/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegionConfigCopyWith<_RegionConfig> get copyWith => __$RegionConfigCopyWithImpl<_RegionConfig>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegionConfig&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.features, features) || other.features == features)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&(identical(other.defaultUnits, defaultUnits) || other.defaultUnits == defaultUnits)&&(identical(other.hemisphere, hemisphere) || other.hemisphere == hemisphere));
}


@override
int get hashCode {
    return Object.hash(runtimeType,countryCode,profile,features,currencyCode,defaultUnits,hemisphere);
}

@override
String toString() {
    return 'RegionConfig(countryCode: $countryCode, profile: $profile, features: $features, currencyCode: $currencyCode, defaultUnits: $defaultUnits, hemisphere: $hemisphere)';
}


}

/// @nodoc
abstract mixin class _$RegionConfigCopyWith<$Res> implements $RegionConfigCopyWith<$Res> {
  factory _$RegionConfigCopyWith(_RegionConfig value, $Res Function(_RegionConfig) _then) = __$RegionConfigCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, RegionProfile profile, RegionFeatures features, String currencyCode, DefaultUnits defaultUnits, Hemisphere hemisphere
});


@override $RegionFeaturesCopyWith<$Res> get features;@override $DefaultUnitsCopyWith<$Res> get defaultUnits;

}
/// @nodoc
class __$RegionConfigCopyWithImpl<$Res>
    implements _$RegionConfigCopyWith<$Res> {
  __$RegionConfigCopyWithImpl(this._self, this._then);

  final _RegionConfig _self;
  final $Res Function(_RegionConfig) _then;

/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? profile = null,Object? features = null,Object? currencyCode = null,Object? defaultUnits = null,Object? hemisphere = null,}) {
  return _then(_RegionConfig(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as RegionProfile,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as RegionFeatures,currencyCode: null == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String,defaultUnits: null == defaultUnits ? _self.defaultUnits : defaultUnits // ignore: cast_nullable_to_non_nullable
as DefaultUnits,hemisphere: null == hemisphere ? _self.hemisphere : hemisphere // ignore: cast_nullable_to_non_nullable
as Hemisphere,
  ));
}

/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegionFeaturesCopyWith<$Res> get features {
  
  return $RegionFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}/// Create a copy of RegionConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DefaultUnitsCopyWith<$Res> get defaultUnits {
  
  return $DefaultUnitsCopyWith<$Res>(_self.defaultUnits, (value) {
    return _then(_self.copyWith(defaultUnits: value));
  });
}
}

// dart format on
