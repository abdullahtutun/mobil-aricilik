// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_profile_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BusinessProfileFields {

 String get name; String get fullName; OrgAvatarColor? get avatarColor;/// Logonun Storage yolu; yeni seçilen logo da bu yolla yazılır.
 String? get logoPath; OperationType get operationType; String get currency;
/// Create a copy of BusinessProfileFields
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProfileFieldsCopyWith<BusinessProfileFields> get copyWith => _$BusinessProfileFieldsCopyWithImpl<BusinessProfileFields>(this as BusinessProfileFields, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BusinessProfileFields;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProfileFields&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.avatarColor, _this.avatarColor) || other.avatarColor == _this.avatarColor)&&(identical(other.logoPath, _this.logoPath) || other.logoPath == _this.logoPath)&&(identical(other.operationType, _this.operationType) || other.operationType == _this.operationType)&&(identical(other.currency, _this.currency) || other.currency == _this.currency));
}


@override
int get hashCode {
  final _this = this as BusinessProfileFields;
  return Object.hash(runtimeType,_this.name,_this.fullName,_this.avatarColor,_this.logoPath,_this.operationType,_this.currency);
}

@override
String toString() {
  final _this = this as BusinessProfileFields;
  return 'BusinessProfileFields(name: ${_this.name}, fullName: ${_this.fullName}, avatarColor: ${_this.avatarColor}, logoPath: ${_this.logoPath}, operationType: ${_this.operationType}, currency: ${_this.currency})';
}


}

/// @nodoc
abstract mixin class $BusinessProfileFieldsCopyWith<$Res>  {
  factory $BusinessProfileFieldsCopyWith(BusinessProfileFields value, $Res Function(BusinessProfileFields) _then) = _$BusinessProfileFieldsCopyWithImpl;
@useResult
$Res call({
 String name, String fullName, OrgAvatarColor? avatarColor, String? logoPath, OperationType operationType, String currency
});




}
/// @nodoc
class _$BusinessProfileFieldsCopyWithImpl<$Res>
    implements $BusinessProfileFieldsCopyWith<$Res> {
  _$BusinessProfileFieldsCopyWithImpl(this._self, this._then);

  final BusinessProfileFields _self;
  final $Res Function(BusinessProfileFields) _then;

/// Create a copy of BusinessProfileFields
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? fullName = null,Object? avatarColor = freezed,Object? logoPath = freezed,Object? operationType = null,Object? currency = null,}) {
  return _then(BusinessProfileFields(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: freezed == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as OrgAvatarColor?,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as OperationType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BusinessProfileFields].
extension BusinessProfileFieldsPatterns on BusinessProfileFields {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProfileFields value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProfileFields() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProfileFields value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProfileFields():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProfileFields value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProfileFields() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String fullName,  OrgAvatarColor? avatarColor,  String? logoPath,  OperationType operationType,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProfileFields() when $default != null:
return $default(_that.name,_that.fullName,_that.avatarColor,_that.logoPath,_that.operationType,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String fullName,  OrgAvatarColor? avatarColor,  String? logoPath,  OperationType operationType,  String currency)  $default,) {final _that = this;
switch (_that) {
case _BusinessProfileFields():
return $default(_that.name,_that.fullName,_that.avatarColor,_that.logoPath,_that.operationType,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String fullName,  OrgAvatarColor? avatarColor,  String? logoPath,  OperationType operationType,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProfileFields() when $default != null:
return $default(_that.name,_that.fullName,_that.avatarColor,_that.logoPath,_that.operationType,_that.currency);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessProfileFields implements BusinessProfileFields {
  const _BusinessProfileFields({this.name = '', this.fullName = '', this.avatarColor, this.logoPath, this.operationType = OperationType.migratory, this.currency = ''});
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String fullName;
@override final  OrgAvatarColor? avatarColor;
/// Logonun Storage yolu; yeni seçilen logo da bu yolla yazılır.
@override final  String? logoPath;
@override@JsonKey() final  OperationType operationType;
@override@JsonKey() final  String currency;

/// Create a copy of BusinessProfileFields
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProfileFieldsCopyWith<_BusinessProfileFields> get copyWith => __$BusinessProfileFieldsCopyWithImpl<_BusinessProfileFields>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProfileFields&&(identical(other.name, name) || other.name == name)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarColor, avatarColor) || other.avatarColor == avatarColor)&&(identical(other.logoPath, logoPath) || other.logoPath == logoPath)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,fullName,avatarColor,logoPath,operationType,currency);
}

@override
String toString() {
    return 'BusinessProfileFields(name: $name, fullName: $fullName, avatarColor: $avatarColor, logoPath: $logoPath, operationType: $operationType, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$BusinessProfileFieldsCopyWith<$Res> implements $BusinessProfileFieldsCopyWith<$Res> {
  factory _$BusinessProfileFieldsCopyWith(_BusinessProfileFields value, $Res Function(_BusinessProfileFields) _then) = __$BusinessProfileFieldsCopyWithImpl;
@override @useResult
$Res call({
 String name, String fullName, OrgAvatarColor? avatarColor, String? logoPath, OperationType operationType, String currency
});




}
/// @nodoc
class __$BusinessProfileFieldsCopyWithImpl<$Res>
    implements _$BusinessProfileFieldsCopyWith<$Res> {
  __$BusinessProfileFieldsCopyWithImpl(this._self, this._then);

  final _BusinessProfileFields _self;
  final $Res Function(_BusinessProfileFields) _then;

/// Create a copy of BusinessProfileFields
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? fullName = null,Object? avatarColor = freezed,Object? logoPath = freezed,Object? operationType = null,Object? currency = null,}) {
  return _then(_BusinessProfileFields(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: freezed == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as OrgAvatarColor?,logoPath: freezed == logoPath ? _self.logoPath : logoPath // ignore: cast_nullable_to_non_nullable
as String?,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as OperationType,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BusinessProfileFormState {

/// Formun açıldığı andaki hâli; çıkışta "değişiklikleri at?" buna göre.
 BusinessProfileFields get initial; BusinessProfileFields get fields; bool get saving;
/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessProfileFormStateCopyWith<BusinessProfileFormState> get copyWith => _$BusinessProfileFormStateCopyWithImpl<BusinessProfileFormState>(this as BusinessProfileFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BusinessProfileFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BusinessProfileFormState&&(identical(other.initial, _this.initial) || other.initial == _this.initial)&&(identical(other.fields, _this.fields) || other.fields == _this.fields)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as BusinessProfileFormState;
  return Object.hash(runtimeType,_this.initial,_this.fields,_this.saving);
}

@override
String toString() {
  final _this = this as BusinessProfileFormState;
  return 'BusinessProfileFormState(initial: ${_this.initial}, fields: ${_this.fields}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $BusinessProfileFormStateCopyWith<$Res>  {
  factory $BusinessProfileFormStateCopyWith(BusinessProfileFormState value, $Res Function(BusinessProfileFormState) _then) = _$BusinessProfileFormStateCopyWithImpl;
@useResult
$Res call({
 BusinessProfileFields initial, BusinessProfileFields fields, bool saving
});


$BusinessProfileFieldsCopyWith<$Res> get initial;$BusinessProfileFieldsCopyWith<$Res> get fields;

}
/// @nodoc
class _$BusinessProfileFormStateCopyWithImpl<$Res>
    implements $BusinessProfileFormStateCopyWith<$Res> {
  _$BusinessProfileFormStateCopyWithImpl(this._self, this._then);

  final BusinessProfileFormState _self;
  final $Res Function(BusinessProfileFormState) _then;

/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? initial = null,Object? fields = null,Object? saving = null,}) {
  return _then(BusinessProfileFormState(
initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as BusinessProfileFields,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as BusinessProfileFields,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessProfileFieldsCopyWith<$Res> get initial {
  
  return $BusinessProfileFieldsCopyWith<$Res>(_self.initial, (value) {
    return _then(_self.copyWith(initial: value));
  });
}/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessProfileFieldsCopyWith<$Res> get fields {
  
  return $BusinessProfileFieldsCopyWith<$Res>(_self.fields, (value) {
    return _then(_self.copyWith(fields: value));
  });
}
}


/// Adds pattern-matching-related methods to [BusinessProfileFormState].
extension BusinessProfileFormStatePatterns on BusinessProfileFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BusinessProfileFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BusinessProfileFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BusinessProfileFormState value)  $default,){
final _that = this;
switch (_that) {
case _BusinessProfileFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BusinessProfileFormState value)?  $default,){
final _that = this;
switch (_that) {
case _BusinessProfileFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BusinessProfileFields initial,  BusinessProfileFields fields,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BusinessProfileFormState() when $default != null:
return $default(_that.initial,_that.fields,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BusinessProfileFields initial,  BusinessProfileFields fields,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _BusinessProfileFormState():
return $default(_that.initial,_that.fields,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BusinessProfileFields initial,  BusinessProfileFields fields,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _BusinessProfileFormState() when $default != null:
return $default(_that.initial,_that.fields,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _BusinessProfileFormState implements BusinessProfileFormState {
  const _BusinessProfileFormState({required this.initial, required this.fields, this.saving = false});
  

/// Formun açıldığı andaki hâli; çıkışta "değişiklikleri at?" buna göre.
@override final  BusinessProfileFields initial;
@override final  BusinessProfileFields fields;
@override@JsonKey() final  bool saving;

/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessProfileFormStateCopyWith<_BusinessProfileFormState> get copyWith => __$BusinessProfileFormStateCopyWithImpl<_BusinessProfileFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BusinessProfileFormState&&(identical(other.initial, initial) || other.initial == initial)&&(identical(other.fields, fields) || other.fields == fields)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,initial,fields,saving);
}

@override
String toString() {
    return 'BusinessProfileFormState(initial: $initial, fields: $fields, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$BusinessProfileFormStateCopyWith<$Res> implements $BusinessProfileFormStateCopyWith<$Res> {
  factory _$BusinessProfileFormStateCopyWith(_BusinessProfileFormState value, $Res Function(_BusinessProfileFormState) _then) = __$BusinessProfileFormStateCopyWithImpl;
@override @useResult
$Res call({
 BusinessProfileFields initial, BusinessProfileFields fields, bool saving
});


@override $BusinessProfileFieldsCopyWith<$Res> get initial;@override $BusinessProfileFieldsCopyWith<$Res> get fields;

}
/// @nodoc
class __$BusinessProfileFormStateCopyWithImpl<$Res>
    implements _$BusinessProfileFormStateCopyWith<$Res> {
  __$BusinessProfileFormStateCopyWithImpl(this._self, this._then);

  final _BusinessProfileFormState _self;
  final $Res Function(_BusinessProfileFormState) _then;

/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? initial = null,Object? fields = null,Object? saving = null,}) {
  return _then(_BusinessProfileFormState(
initial: null == initial ? _self.initial : initial // ignore: cast_nullable_to_non_nullable
as BusinessProfileFields,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as BusinessProfileFields,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessProfileFieldsCopyWith<$Res> get initial {
  
  return $BusinessProfileFieldsCopyWith<$Res>(_self.initial, (value) {
    return _then(_self.copyWith(initial: value));
  });
}/// Create a copy of BusinessProfileFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessProfileFieldsCopyWith<$Res> get fields {
  
  return $BusinessProfileFieldsCopyWith<$Res>(_self.fields, (value) {
    return _then(_self.copyWith(fields: value));
  });
}
}

// dart format on
