// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Organization {

/// İstemcide üretilen UUIDv7.
 String get id; String get name;/// ISO 3166-1 alpha-2, büyük harf.
 String get countryCode;/// ISO 4217.
 String get currency; HiveCountRange? get hiveCountRange;/// Eski önbellekte yok; o zaman gezginci (sunucunun varsayılanı).
 OperationType get operationType;
/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationCopyWith<Organization> get copyWith => _$OrganizationCopyWithImpl<Organization>(this as Organization, _$identity);

  /// Serializes this Organization to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Organization;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Organization&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.hiveCountRange, _this.hiveCountRange) || other.hiveCountRange == _this.hiveCountRange)&&(identical(other.operationType, _this.operationType) || other.operationType == _this.operationType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Organization;
  return Object.hash(runtimeType,_this.id,_this.name,_this.countryCode,_this.currency,_this.hiveCountRange,_this.operationType);
}

@override
String toString() {
  final _this = this as Organization;
  return 'Organization(id: ${_this.id}, name: ${_this.name}, countryCode: ${_this.countryCode}, currency: ${_this.currency}, hiveCountRange: ${_this.hiveCountRange}, operationType: ${_this.operationType})';
}


}

/// @nodoc
abstract mixin class $OrganizationCopyWith<$Res>  {
  factory $OrganizationCopyWith(Organization value, $Res Function(Organization) _then) = _$OrganizationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String countryCode, String currency, HiveCountRange? hiveCountRange, OperationType operationType
});




}
/// @nodoc
class _$OrganizationCopyWithImpl<$Res>
    implements $OrganizationCopyWith<$Res> {
  _$OrganizationCopyWithImpl(this._self, this._then);

  final Organization _self;
  final $Res Function(Organization) _then;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? countryCode = null,Object? currency = null,Object? hiveCountRange = freezed,Object? operationType = null,}) {
  return _then(Organization(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,hiveCountRange: freezed == hiveCountRange ? _self.hiveCountRange : hiveCountRange // ignore: cast_nullable_to_non_nullable
as HiveCountRange?,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as OperationType,
  ));
}

}


/// Adds pattern-matching-related methods to [Organization].
extension OrganizationPatterns on Organization {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Organization value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Organization() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Organization value)  $default,){
final _that = this;
switch (_that) {
case _Organization():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Organization value)?  $default,){
final _that = this;
switch (_that) {
case _Organization() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String countryCode,  String currency,  HiveCountRange? hiveCountRange,  OperationType operationType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Organization() when $default != null:
return $default(_that.id,_that.name,_that.countryCode,_that.currency,_that.hiveCountRange,_that.operationType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String countryCode,  String currency,  HiveCountRange? hiveCountRange,  OperationType operationType)  $default,) {final _that = this;
switch (_that) {
case _Organization():
return $default(_that.id,_that.name,_that.countryCode,_that.currency,_that.hiveCountRange,_that.operationType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String countryCode,  String currency,  HiveCountRange? hiveCountRange,  OperationType operationType)?  $default,) {final _that = this;
switch (_that) {
case _Organization() when $default != null:
return $default(_that.id,_that.name,_that.countryCode,_that.currency,_that.hiveCountRange,_that.operationType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Organization implements Organization {
  const _Organization({required this.id, required this.name, required this.countryCode, required this.currency, this.hiveCountRange, this.operationType = OperationType.migratory});
  factory _Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);

/// İstemcide üretilen UUIDv7.
@override final  String id;
@override final  String name;
/// ISO 3166-1 alpha-2, büyük harf.
@override final  String countryCode;
/// ISO 4217.
@override final  String currency;
@override final  HiveCountRange? hiveCountRange;
/// Eski önbellekte yok; o zaman gezginci (sunucunun varsayılanı).
@override@JsonKey() final  OperationType operationType;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationCopyWith<_Organization> get copyWith => __$OrganizationCopyWithImpl<_Organization>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Organization&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.hiveCountRange, hiveCountRange) || other.hiveCountRange == hiveCountRange)&&(identical(other.operationType, operationType) || other.operationType == operationType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,countryCode,currency,hiveCountRange,operationType);
}

@override
String toString() {
    return 'Organization(id: $id, name: $name, countryCode: $countryCode, currency: $currency, hiveCountRange: $hiveCountRange, operationType: $operationType)';
}


}

/// @nodoc
abstract mixin class _$OrganizationCopyWith<$Res> implements $OrganizationCopyWith<$Res> {
  factory _$OrganizationCopyWith(_Organization value, $Res Function(_Organization) _then) = __$OrganizationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String countryCode, String currency, HiveCountRange? hiveCountRange, OperationType operationType
});




}
/// @nodoc
class __$OrganizationCopyWithImpl<$Res>
    implements _$OrganizationCopyWith<$Res> {
  __$OrganizationCopyWithImpl(this._self, this._then);

  final _Organization _self;
  final $Res Function(_Organization) _then;

/// Create a copy of Organization
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? countryCode = null,Object? currency = null,Object? hiveCountRange = freezed,Object? operationType = null,}) {
  return _then(_Organization(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,hiveCountRange: freezed == hiveCountRange ? _self.hiveCountRange : hiveCountRange // ignore: cast_nullable_to_non_nullable
as HiveCountRange?,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as OperationType,
  ));
}


}

// dart format on
