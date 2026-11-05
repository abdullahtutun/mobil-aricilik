// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BusinessFeatures {

/// Gezginci modülleri: göç planı, duraklar, taşıma (yükleme/indirme),
/// gidere taşıma bağlama ve offline haritadaki göç durakları.
 bool get migratory;
/// Create a copy of BusinessFeatures
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessFeaturesCopyWith<BusinessFeatures> get copyWith => _$BusinessFeaturesCopyWithImpl<BusinessFeatures>(this as BusinessFeatures, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BusinessFeatures;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessFeatures&&(identical(other.migratory, _this.migratory) || other.migratory == _this.migratory));
}


@override
int get hashCode {
  final _this = this as BusinessFeatures;
  return Object.hash(runtimeType,_this.migratory);
}

@override
String toString() {
  final _this = this as BusinessFeatures;
  return 'BusinessFeatures(migratory: ${_this.migratory})';
}


}

/// @nodoc
abstract mixin class $BusinessFeaturesCopyWith<$Res>  {
  factory $BusinessFeaturesCopyWith(BusinessFeatures value, $Res Function(BusinessFeatures) _then) = _$BusinessFeaturesCopyWithImpl;
@useResult
$Res call({
 bool migratory
});




}
/// @nodoc
class _$BusinessFeaturesCopyWithImpl<$Res>
    implements $BusinessFeaturesCopyWith<$Res> {
  _$BusinessFeaturesCopyWithImpl(this._self, this._then);

  final BusinessFeatures _self;
  final $Res Function(BusinessFeatures) _then;

/// Create a copy of BusinessFeatures
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? migratory = null,}) {
  return _then(BusinessFeatures(
migratory: null == migratory ? _self.migratory : migratory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessFeatures].
extension BusinessFeaturesPatterns on BusinessFeatures {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessFeatures value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessFeatures() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessFeatures value)  $default,){
final _that = this;
switch (_that) {
case _BusinessFeatures():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessFeatures value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessFeatures() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool migratory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessFeatures() when $default != null:
return $default(_that.migratory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool migratory)  $default,) {final _that = this;
switch (_that) {
case _BusinessFeatures():
return $default(_that.migratory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool migratory)?  $default,) {final _that = this;
switch (_that) {
case _BusinessFeatures() when $default != null:
return $default(_that.migratory);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessFeatures implements BusinessFeatures {
  const _BusinessFeatures({this.migratory = true});
  

/// Gezginci modülleri: göç planı, duraklar, taşıma (yükleme/indirme),
/// gidere taşıma bağlama ve offline haritadaki göç durakları.
@override@JsonKey() final  bool migratory;

/// Create a copy of BusinessFeatures
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessFeaturesCopyWith<_BusinessFeatures> get copyWith => __$BusinessFeaturesCopyWithImpl<_BusinessFeatures>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessFeatures&&(identical(other.migratory, migratory) || other.migratory == migratory));
}


@override
int get hashCode {
    return Object.hash(runtimeType,migratory);
}

@override
String toString() {
    return 'BusinessFeatures(migratory: $migratory)';
}


}

/// @nodoc
abstract mixin class _$BusinessFeaturesCopyWith<$Res> implements $BusinessFeaturesCopyWith<$Res> {
  factory _$BusinessFeaturesCopyWith(_BusinessFeatures value, $Res Function(_BusinessFeatures) _then) = __$BusinessFeaturesCopyWithImpl;
@override @useResult
$Res call({
 bool migratory
});




}
/// @nodoc
class __$BusinessFeaturesCopyWithImpl<$Res>
    implements _$BusinessFeaturesCopyWith<$Res> {
  __$BusinessFeaturesCopyWithImpl(this._self, this._then);

  final _BusinessFeatures _self;
  final $Res Function(_BusinessFeatures) _then;

/// Create a copy of BusinessFeatures
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? migratory = null,}) {
  return _then(_BusinessFeatures(
migratory: null == migratory ? _self.migratory : migratory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$BusinessConfig {

 OperationType get operationType; BusinessFeatures get features;
/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessConfigCopyWith<BusinessConfig> get copyWith => _$BusinessConfigCopyWithImpl<BusinessConfig>(this as BusinessConfig, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BusinessConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessConfig&&(identical(other.operationType, _this.operationType) || other.operationType == _this.operationType)&&(identical(other.features, _this.features) || other.features == _this.features));
}


@override
int get hashCode {
  final _this = this as BusinessConfig;
  return Object.hash(runtimeType,_this.operationType,_this.features);
}

@override
String toString() {
  final _this = this as BusinessConfig;
  return 'BusinessConfig(operationType: ${_this.operationType}, features: ${_this.features})';
}


}

/// @nodoc
abstract mixin class $BusinessConfigCopyWith<$Res>  {
  factory $BusinessConfigCopyWith(BusinessConfig value, $Res Function(BusinessConfig) _then) = _$BusinessConfigCopyWithImpl;
@useResult
$Res call({
 OperationType operationType, BusinessFeatures features
});


$BusinessFeaturesCopyWith<$Res> get features;

}
/// @nodoc
class _$BusinessConfigCopyWithImpl<$Res>
    implements $BusinessConfigCopyWith<$Res> {
  _$BusinessConfigCopyWithImpl(this._self, this._then);

  final BusinessConfig _self;
  final $Res Function(BusinessConfig) _then;

/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operationType = null,Object? features = null,}) {
  return _then(BusinessConfig(
operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as OperationType,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as BusinessFeatures,
  ));
}
/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessFeaturesCopyWith<$Res> get features {
  
  return $BusinessFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}
}


/// Adds pattern-matching-related methods to [BusinessConfig].
extension BusinessConfigPatterns on BusinessConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessConfig value)  $default,){
final _that = this;
switch (_that) {
case _BusinessConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OperationType operationType,  BusinessFeatures features)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
return $default(_that.operationType,_that.features);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OperationType operationType,  BusinessFeatures features)  $default,) {final _that = this;
switch (_that) {
case _BusinessConfig():
return $default(_that.operationType,_that.features);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OperationType operationType,  BusinessFeatures features)?  $default,) {final _that = this;
switch (_that) {
case _BusinessConfig() when $default != null:
return $default(_that.operationType,_that.features);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessConfig implements BusinessConfig {
  const _BusinessConfig({required this.operationType, required this.features});
  

@override final  OperationType operationType;
@override final  BusinessFeatures features;

/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessConfigCopyWith<_BusinessConfig> get copyWith => __$BusinessConfigCopyWithImpl<_BusinessConfig>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessConfig&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.features, features) || other.features == features));
}


@override
int get hashCode {
    return Object.hash(runtimeType,operationType,features);
}

@override
String toString() {
    return 'BusinessConfig(operationType: $operationType, features: $features)';
}


}

/// @nodoc
abstract mixin class _$BusinessConfigCopyWith<$Res> implements $BusinessConfigCopyWith<$Res> {
  factory _$BusinessConfigCopyWith(_BusinessConfig value, $Res Function(_BusinessConfig) _then) = __$BusinessConfigCopyWithImpl;
@override @useResult
$Res call({
 OperationType operationType, BusinessFeatures features
});


@override $BusinessFeaturesCopyWith<$Res> get features;

}
/// @nodoc
class __$BusinessConfigCopyWithImpl<$Res>
    implements _$BusinessConfigCopyWith<$Res> {
  __$BusinessConfigCopyWithImpl(this._self, this._then);

  final _BusinessConfig _self;
  final $Res Function(_BusinessConfig) _then;

/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operationType = null,Object? features = null,}) {
  return _then(_BusinessConfig(
operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as OperationType,features: null == features ? _self.features : features // ignore: cast_nullable_to_non_nullable
as BusinessFeatures,
  ));
}

/// Create a copy of BusinessConfig
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessFeaturesCopyWith<$Res> get features {
  
  return $BusinessFeaturesCopyWith<$Res>(_self.features, (value) {
    return _then(_self.copyWith(features: value));
  });
}
}

// dart format on
