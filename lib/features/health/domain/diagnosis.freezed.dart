// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diagnosis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiagnosisSymptom {

 String get id; LocalizedText get label;
/// Create a copy of DiagnosisSymptom
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosisSymptomCopyWith<DiagnosisSymptom> get copyWith => _$DiagnosisSymptomCopyWithImpl<DiagnosisSymptom>(this as DiagnosisSymptom, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiagnosisSymptom;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosisSymptom&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.label, _this.label));
}


@override
int get hashCode {
  final _this = this as DiagnosisSymptom;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.label));
}

@override
String toString() {
  final _this = this as DiagnosisSymptom;
  return 'DiagnosisSymptom(id: ${_this.id}, label: ${_this.label})';
}


}

/// @nodoc
abstract mixin class $DiagnosisSymptomCopyWith<$Res>  {
  factory $DiagnosisSymptomCopyWith(DiagnosisSymptom value, $Res Function(DiagnosisSymptom) _then) = _$DiagnosisSymptomCopyWithImpl;
@useResult
$Res call({
 String id, LocalizedText label
});




}
/// @nodoc
class _$DiagnosisSymptomCopyWithImpl<$Res>
    implements $DiagnosisSymptomCopyWith<$Res> {
  _$DiagnosisSymptomCopyWithImpl(this._self, this._then);

  final DiagnosisSymptom _self;
  final $Res Function(DiagnosisSymptom) _then;

/// Create a copy of DiagnosisSymptom
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,}) {
  return _then(DiagnosisSymptom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosisSymptom].
extension DiagnosisSymptomPatterns on DiagnosisSymptom {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosisSymptom value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosisSymptom() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosisSymptom value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosisSymptom():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosisSymptom value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosisSymptom() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LocalizedText label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosisSymptom() when $default != null:
return $default(_that.id,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LocalizedText label)  $default,) {final _that = this;
switch (_that) {
case _DiagnosisSymptom():
return $default(_that.id,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LocalizedText label)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosisSymptom() when $default != null:
return $default(_that.id,_that.label);case _:
  return null;

}
}

}

/// @nodoc


class _DiagnosisSymptom implements DiagnosisSymptom {
  const _DiagnosisSymptom({required this.id, required  LocalizedText label}): _label = label;
  

@override final  String id;
 final  LocalizedText _label;
@override LocalizedText get label {
  if (_label is EqualUnmodifiableMapView) return _label;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_label);
}


/// Create a copy of DiagnosisSymptom
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosisSymptomCopyWith<_DiagnosisSymptom> get copyWith => __$DiagnosisSymptomCopyWithImpl<_DiagnosisSymptom>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosisSymptom&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.label, _label));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_label));
}

@override
String toString() {
    return 'DiagnosisSymptom(id: $id, label: $label)';
}


}

/// @nodoc
abstract mixin class _$DiagnosisSymptomCopyWith<$Res> implements $DiagnosisSymptomCopyWith<$Res> {
  factory _$DiagnosisSymptomCopyWith(_DiagnosisSymptom value, $Res Function(_DiagnosisSymptom) _then) = __$DiagnosisSymptomCopyWithImpl;
@override @useResult
$Res call({
 String id, LocalizedText label
});




}
/// @nodoc
class __$DiagnosisSymptomCopyWithImpl<$Res>
    implements _$DiagnosisSymptomCopyWith<$Res> {
  __$DiagnosisSymptomCopyWithImpl(this._self, this._then);

  final _DiagnosisSymptom _self;
  final $Res Function(_DiagnosisSymptom) _then;

/// Create a copy of DiagnosisSymptom
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,}) {
  return _then(_DiagnosisSymptom(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self._label : label // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}


}

/// @nodoc
mixin _$DiagnosisRule {

 String get id; LocalizedText get name;/// [DiagnosisSymptom.id] değerleri.
 List<String> get symptoms; bool get notifiable;/// Ne yapılmalı.
 LocalizedText get advice;
/// Create a copy of DiagnosisRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosisRuleCopyWith<DiagnosisRule> get copyWith => _$DiagnosisRuleCopyWithImpl<DiagnosisRule>(this as DiagnosisRule, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiagnosisRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosisRule&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.name, _this.name)&&const DeepCollectionEquality().equals(other.symptoms, _this.symptoms)&&(identical(other.notifiable, _this.notifiable) || other.notifiable == _this.notifiable)&&const DeepCollectionEquality().equals(other.advice, _this.advice));
}


@override
int get hashCode {
  final _this = this as DiagnosisRule;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.name),const DeepCollectionEquality().hash(_this.symptoms),_this.notifiable,const DeepCollectionEquality().hash(_this.advice));
}

@override
String toString() {
  final _this = this as DiagnosisRule;
  return 'DiagnosisRule(id: ${_this.id}, name: ${_this.name}, symptoms: ${_this.symptoms}, notifiable: ${_this.notifiable}, advice: ${_this.advice})';
}


}

/// @nodoc
abstract mixin class $DiagnosisRuleCopyWith<$Res>  {
  factory $DiagnosisRuleCopyWith(DiagnosisRule value, $Res Function(DiagnosisRule) _then) = _$DiagnosisRuleCopyWithImpl;
@useResult
$Res call({
 String id, LocalizedText name, List<String> symptoms, bool notifiable, LocalizedText advice
});




}
/// @nodoc
class _$DiagnosisRuleCopyWithImpl<$Res>
    implements $DiagnosisRuleCopyWith<$Res> {
  _$DiagnosisRuleCopyWithImpl(this._self, this._then);

  final DiagnosisRule _self;
  final $Res Function(DiagnosisRule) _then;

/// Create a copy of DiagnosisRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? symptoms = null,Object? notifiable = null,Object? advice = null,}) {
  return _then(DiagnosisRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<String>,notifiable: null == notifiable ? _self.notifiable : notifiable // ignore: cast_nullable_to_non_nullable
as bool,advice: null == advice ? _self.advice : advice // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosisRule].
extension DiagnosisRulePatterns on DiagnosisRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosisRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosisRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosisRule value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosisRule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosisRule value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosisRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LocalizedText name,  List<String> symptoms,  bool notifiable,  LocalizedText advice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosisRule() when $default != null:
return $default(_that.id,_that.name,_that.symptoms,_that.notifiable,_that.advice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LocalizedText name,  List<String> symptoms,  bool notifiable,  LocalizedText advice)  $default,) {final _that = this;
switch (_that) {
case _DiagnosisRule():
return $default(_that.id,_that.name,_that.symptoms,_that.notifiable,_that.advice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LocalizedText name,  List<String> symptoms,  bool notifiable,  LocalizedText advice)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosisRule() when $default != null:
return $default(_that.id,_that.name,_that.symptoms,_that.notifiable,_that.advice);case _:
  return null;

}
}

}

/// @nodoc


class _DiagnosisRule implements DiagnosisRule {
  const _DiagnosisRule({required this.id, required  LocalizedText name, required  List<String> symptoms, required this.notifiable, required  LocalizedText advice}): _name = name,_symptoms = symptoms,_advice = advice;
  

@override final  String id;
 final  LocalizedText _name;
@override LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

/// [DiagnosisSymptom.id] değerleri.
 final  List<String> _symptoms;
/// [DiagnosisSymptom.id] değerleri.
@override List<String> get symptoms {
  if (_symptoms is EqualUnmodifiableListView) return _symptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_symptoms);
}

@override final  bool notifiable;
/// Ne yapılmalı.
 final  LocalizedText _advice;
/// Ne yapılmalı.
@override LocalizedText get advice {
  if (_advice is EqualUnmodifiableMapView) return _advice;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_advice);
}


/// Create a copy of DiagnosisRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosisRuleCopyWith<_DiagnosisRule> get copyWith => __$DiagnosisRuleCopyWithImpl<_DiagnosisRule>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosisRule&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.name, _name)&&const DeepCollectionEquality().equals(other.symptoms, _symptoms)&&(identical(other.notifiable, notifiable) || other.notifiable == notifiable)&&const DeepCollectionEquality().equals(other.advice, _advice));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_name),const DeepCollectionEquality().hash(_symptoms),notifiable,const DeepCollectionEquality().hash(_advice));
}

@override
String toString() {
    return 'DiagnosisRule(id: $id, name: $name, symptoms: $symptoms, notifiable: $notifiable, advice: $advice)';
}


}

/// @nodoc
abstract mixin class _$DiagnosisRuleCopyWith<$Res> implements $DiagnosisRuleCopyWith<$Res> {
  factory _$DiagnosisRuleCopyWith(_DiagnosisRule value, $Res Function(_DiagnosisRule) _then) = __$DiagnosisRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, LocalizedText name, List<String> symptoms, bool notifiable, LocalizedText advice
});




}
/// @nodoc
class __$DiagnosisRuleCopyWithImpl<$Res>
    implements _$DiagnosisRuleCopyWith<$Res> {
  __$DiagnosisRuleCopyWithImpl(this._self, this._then);

  final _DiagnosisRule _self;
  final $Res Function(_DiagnosisRule) _then;

/// Create a copy of DiagnosisRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? symptoms = null,Object? notifiable = null,Object? advice = null,}) {
  return _then(_DiagnosisRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,symptoms: null == symptoms ? _self._symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<String>,notifiable: null == notifiable ? _self.notifiable : notifiable // ignore: cast_nullable_to_non_nullable
as bool,advice: null == advice ? _self._advice : advice // ignore: cast_nullable_to_non_nullable
as LocalizedText,
  ));
}


}

/// @nodoc
mixin _$DiagnosisAuthority {

 LocalizedText get name; LocalizedText? get detail;/// Aranacak numara (ör. "174").
 String? get phone;
/// Create a copy of DiagnosisAuthority
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosisAuthorityCopyWith<DiagnosisAuthority> get copyWith => _$DiagnosisAuthorityCopyWithImpl<DiagnosisAuthority>(this as DiagnosisAuthority, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiagnosisAuthority;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosisAuthority&&const DeepCollectionEquality().equals(other.name, _this.name)&&const DeepCollectionEquality().equals(other.detail, _this.detail)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}


@override
int get hashCode {
  final _this = this as DiagnosisAuthority;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.name),const DeepCollectionEquality().hash(_this.detail),_this.phone);
}

@override
String toString() {
  final _this = this as DiagnosisAuthority;
  return 'DiagnosisAuthority(name: ${_this.name}, detail: ${_this.detail}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $DiagnosisAuthorityCopyWith<$Res>  {
  factory $DiagnosisAuthorityCopyWith(DiagnosisAuthority value, $Res Function(DiagnosisAuthority) _then) = _$DiagnosisAuthorityCopyWithImpl;
@useResult
$Res call({
 LocalizedText name, LocalizedText? detail, String? phone
});




}
/// @nodoc
class _$DiagnosisAuthorityCopyWithImpl<$Res>
    implements $DiagnosisAuthorityCopyWith<$Res> {
  _$DiagnosisAuthorityCopyWithImpl(this._self, this._then);

  final DiagnosisAuthority _self;
  final $Res Function(DiagnosisAuthority) _then;

/// Create a copy of DiagnosisAuthority
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? detail = freezed,Object? phone = freezed,}) {
  return _then(DiagnosisAuthority(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as LocalizedText?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosisAuthority].
extension DiagnosisAuthorityPatterns on DiagnosisAuthority {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosisAuthority value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosisAuthority() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosisAuthority value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosisAuthority():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosisAuthority value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosisAuthority() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocalizedText name,  LocalizedText? detail,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosisAuthority() when $default != null:
return $default(_that.name,_that.detail,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocalizedText name,  LocalizedText? detail,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _DiagnosisAuthority():
return $default(_that.name,_that.detail,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocalizedText name,  LocalizedText? detail,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosisAuthority() when $default != null:
return $default(_that.name,_that.detail,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _DiagnosisAuthority implements DiagnosisAuthority {
  const _DiagnosisAuthority({required  LocalizedText name,  LocalizedText? detail, this.phone}): _name = name,_detail = detail;
  

 final  LocalizedText _name;
@override LocalizedText get name {
  if (_name is EqualUnmodifiableMapView) return _name;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_name);
}

 final  LocalizedText? _detail;
@override LocalizedText? get detail {
  final value = _detail;
  if (value == null) return null;
  if (_detail is EqualUnmodifiableMapView) return _detail;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Aranacak numara (ör. "174").
@override final  String? phone;

/// Create a copy of DiagnosisAuthority
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosisAuthorityCopyWith<_DiagnosisAuthority> get copyWith => __$DiagnosisAuthorityCopyWithImpl<_DiagnosisAuthority>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosisAuthority&&const DeepCollectionEquality().equals(other.name, _name)&&const DeepCollectionEquality().equals(other.detail, _detail)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_name),const DeepCollectionEquality().hash(_detail),phone);
}

@override
String toString() {
    return 'DiagnosisAuthority(name: $name, detail: $detail, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$DiagnosisAuthorityCopyWith<$Res> implements $DiagnosisAuthorityCopyWith<$Res> {
  factory _$DiagnosisAuthorityCopyWith(_DiagnosisAuthority value, $Res Function(_DiagnosisAuthority) _then) = __$DiagnosisAuthorityCopyWithImpl;
@override @useResult
$Res call({
 LocalizedText name, LocalizedText? detail, String? phone
});




}
/// @nodoc
class __$DiagnosisAuthorityCopyWithImpl<$Res>
    implements _$DiagnosisAuthorityCopyWith<$Res> {
  __$DiagnosisAuthorityCopyWithImpl(this._self, this._then);

  final _DiagnosisAuthority _self;
  final $Res Function(_DiagnosisAuthority) _then;

/// Create a copy of DiagnosisAuthority
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? detail = freezed,Object? phone = freezed,}) {
  return _then(_DiagnosisAuthority(
name: null == name ? _self._name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,detail: freezed == detail ? _self._detail : detail // ignore: cast_nullable_to_non_nullable
as LocalizedText?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DiagnosisTable {

 List<DiagnosisSymptom> get symptoms; List<DiagnosisRule> get rules; Map<String, DiagnosisAuthority> get authorities;
/// Create a copy of DiagnosisTable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosisTableCopyWith<DiagnosisTable> get copyWith => _$DiagnosisTableCopyWithImpl<DiagnosisTable>(this as DiagnosisTable, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiagnosisTable;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosisTable&&const DeepCollectionEquality().equals(other.symptoms, _this.symptoms)&&const DeepCollectionEquality().equals(other.rules, _this.rules)&&const DeepCollectionEquality().equals(other.authorities, _this.authorities));
}


@override
int get hashCode {
  final _this = this as DiagnosisTable;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.symptoms),const DeepCollectionEquality().hash(_this.rules),const DeepCollectionEquality().hash(_this.authorities));
}

@override
String toString() {
  final _this = this as DiagnosisTable;
  return 'DiagnosisTable(symptoms: ${_this.symptoms}, rules: ${_this.rules}, authorities: ${_this.authorities})';
}


}

/// @nodoc
abstract mixin class $DiagnosisTableCopyWith<$Res>  {
  factory $DiagnosisTableCopyWith(DiagnosisTable value, $Res Function(DiagnosisTable) _then) = _$DiagnosisTableCopyWithImpl;
@useResult
$Res call({
 List<DiagnosisSymptom> symptoms, List<DiagnosisRule> rules, Map<String, DiagnosisAuthority> authorities
});




}
/// @nodoc
class _$DiagnosisTableCopyWithImpl<$Res>
    implements $DiagnosisTableCopyWith<$Res> {
  _$DiagnosisTableCopyWithImpl(this._self, this._then);

  final DiagnosisTable _self;
  final $Res Function(DiagnosisTable) _then;

/// Create a copy of DiagnosisTable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? symptoms = null,Object? rules = null,Object? authorities = null,}) {
  return _then(DiagnosisTable(
symptoms: null == symptoms ? _self.symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<DiagnosisSymptom>,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as List<DiagnosisRule>,authorities: null == authorities ? _self.authorities : authorities // ignore: cast_nullable_to_non_nullable
as Map<String, DiagnosisAuthority>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosisTable].
extension DiagnosisTablePatterns on DiagnosisTable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosisTable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosisTable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosisTable value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosisTable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosisTable value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosisTable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<DiagnosisSymptom> symptoms,  List<DiagnosisRule> rules,  Map<String, DiagnosisAuthority> authorities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosisTable() when $default != null:
return $default(_that.symptoms,_that.rules,_that.authorities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<DiagnosisSymptom> symptoms,  List<DiagnosisRule> rules,  Map<String, DiagnosisAuthority> authorities)  $default,) {final _that = this;
switch (_that) {
case _DiagnosisTable():
return $default(_that.symptoms,_that.rules,_that.authorities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<DiagnosisSymptom> symptoms,  List<DiagnosisRule> rules,  Map<String, DiagnosisAuthority> authorities)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosisTable() when $default != null:
return $default(_that.symptoms,_that.rules,_that.authorities);case _:
  return null;

}
}

}

/// @nodoc


class _DiagnosisTable implements DiagnosisTable {
  const _DiagnosisTable({required  List<DiagnosisSymptom> symptoms, required  List<DiagnosisRule> rules, required  Map<String, DiagnosisAuthority> authorities}): _symptoms = symptoms,_rules = rules,_authorities = authorities;
  

 final  List<DiagnosisSymptom> _symptoms;
@override List<DiagnosisSymptom> get symptoms {
  if (_symptoms is EqualUnmodifiableListView) return _symptoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_symptoms);
}

 final  List<DiagnosisRule> _rules;
@override List<DiagnosisRule> get rules {
  if (_rules is EqualUnmodifiableListView) return _rules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rules);
}

 final  Map<String, DiagnosisAuthority> _authorities;
@override Map<String, DiagnosisAuthority> get authorities {
  if (_authorities is EqualUnmodifiableMapView) return _authorities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_authorities);
}


/// Create a copy of DiagnosisTable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosisTableCopyWith<_DiagnosisTable> get copyWith => __$DiagnosisTableCopyWithImpl<_DiagnosisTable>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosisTable&&const DeepCollectionEquality().equals(other.symptoms, _symptoms)&&const DeepCollectionEquality().equals(other.rules, _rules)&&const DeepCollectionEquality().equals(other.authorities, _authorities));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_symptoms),const DeepCollectionEquality().hash(_rules),const DeepCollectionEquality().hash(_authorities));
}

@override
String toString() {
    return 'DiagnosisTable(symptoms: $symptoms, rules: $rules, authorities: $authorities)';
}


}

/// @nodoc
abstract mixin class _$DiagnosisTableCopyWith<$Res> implements $DiagnosisTableCopyWith<$Res> {
  factory _$DiagnosisTableCopyWith(_DiagnosisTable value, $Res Function(_DiagnosisTable) _then) = __$DiagnosisTableCopyWithImpl;
@override @useResult
$Res call({
 List<DiagnosisSymptom> symptoms, List<DiagnosisRule> rules, Map<String, DiagnosisAuthority> authorities
});




}
/// @nodoc
class __$DiagnosisTableCopyWithImpl<$Res>
    implements _$DiagnosisTableCopyWith<$Res> {
  __$DiagnosisTableCopyWithImpl(this._self, this._then);

  final _DiagnosisTable _self;
  final $Res Function(_DiagnosisTable) _then;

/// Create a copy of DiagnosisTable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? symptoms = null,Object? rules = null,Object? authorities = null,}) {
  return _then(_DiagnosisTable(
symptoms: null == symptoms ? _self._symptoms : symptoms // ignore: cast_nullable_to_non_nullable
as List<DiagnosisSymptom>,rules: null == rules ? _self._rules : rules // ignore: cast_nullable_to_non_nullable
as List<DiagnosisRule>,authorities: null == authorities ? _self._authorities : authorities // ignore: cast_nullable_to_non_nullable
as Map<String, DiagnosisAuthority>,
  ));
}


}

// dart format on
