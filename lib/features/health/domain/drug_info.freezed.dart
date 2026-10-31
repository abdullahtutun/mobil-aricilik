// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drug_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrugInfo {

 String get refDrugId;@JsonKey(name: 'ilac_adi') String get name;@JsonKey(name: 'etken_madde') String get activeIngredient;@JsonKey(name: 'endikasyonlar') String? get indications;/// Kullanım ve sıklık; anahtarlar ürüne göre değişir
/// ([drugUsageItems] sıralar).
@JsonKey(name: 'kullanimi_ve_sikligi') Map<String, String> get usage;@JsonKey(name: 'uygulandigi_donem') DrugInfoPeriods get periods;@JsonKey(name: 'kalinti_bilgisi_ikas') DrugInfoResidue? get residue;/// İlaç seçilince formda dolan değerler.
@JsonKey(name: 'otomatik_doldurma') DrugInfoDefaults? get defaults;
/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugInfoCopyWith<DrugInfo> get copyWith => _$DrugInfoCopyWithImpl<DrugInfo>(this as DrugInfo, _$identity);

  /// Serializes this DrugInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrugInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugInfo&&(identical(other.refDrugId, _this.refDrugId) || other.refDrugId == _this.refDrugId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.activeIngredient, _this.activeIngredient) || other.activeIngredient == _this.activeIngredient)&&(identical(other.indications, _this.indications) || other.indications == _this.indications)&&const DeepCollectionEquality().equals(other.usage, _this.usage)&&(identical(other.periods, _this.periods) || other.periods == _this.periods)&&(identical(other.residue, _this.residue) || other.residue == _this.residue)&&(identical(other.defaults, _this.defaults) || other.defaults == _this.defaults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrugInfo;
  return Object.hash(runtimeType,_this.refDrugId,_this.name,_this.activeIngredient,_this.indications,const DeepCollectionEquality().hash(_this.usage),_this.periods,_this.residue,_this.defaults);
}

@override
String toString() {
  final _this = this as DrugInfo;
  return 'DrugInfo(refDrugId: ${_this.refDrugId}, name: ${_this.name}, activeIngredient: ${_this.activeIngredient}, indications: ${_this.indications}, usage: ${_this.usage}, periods: ${_this.periods}, residue: ${_this.residue}, defaults: ${_this.defaults})';
}


}

/// @nodoc
abstract mixin class $DrugInfoCopyWith<$Res>  {
  factory $DrugInfoCopyWith(DrugInfo value, $Res Function(DrugInfo) _then) = _$DrugInfoCopyWithImpl;
@useResult
$Res call({
 String refDrugId,@JsonKey(name: 'ilac_adi') String name,@JsonKey(name: 'etken_madde') String activeIngredient,@JsonKey(name: 'endikasyonlar') String? indications,@JsonKey(name: 'kullanimi_ve_sikligi') Map<String, String> usage,@JsonKey(name: 'uygulandigi_donem') DrugInfoPeriods periods,@JsonKey(name: 'kalinti_bilgisi_ikas') DrugInfoResidue? residue,@JsonKey(name: 'otomatik_doldurma') DrugInfoDefaults? defaults
});


$DrugInfoPeriodsCopyWith<$Res> get periods;$DrugInfoResidueCopyWith<$Res>? get residue;$DrugInfoDefaultsCopyWith<$Res>? get defaults;

}
/// @nodoc
class _$DrugInfoCopyWithImpl<$Res>
    implements $DrugInfoCopyWith<$Res> {
  _$DrugInfoCopyWithImpl(this._self, this._then);

  final DrugInfo _self;
  final $Res Function(DrugInfo) _then;

/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? refDrugId = null,Object? name = null,Object? activeIngredient = null,Object? indications = freezed,Object? usage = null,Object? periods = null,Object? residue = freezed,Object? defaults = freezed,}) {
  return _then(DrugInfo(
refDrugId: null == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as String,indications: freezed == indications ? _self.indications : indications // ignore: cast_nullable_to_non_nullable
as String?,usage: null == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as Map<String, String>,periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as DrugInfoPeriods,residue: freezed == residue ? _self.residue : residue // ignore: cast_nullable_to_non_nullable
as DrugInfoResidue?,defaults: freezed == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as DrugInfoDefaults?,
  ));
}
/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugInfoPeriodsCopyWith<$Res> get periods {
  
  return $DrugInfoPeriodsCopyWith<$Res>(_self.periods, (value) {
    return _then(_self.copyWith(periods: value));
  });
}/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugInfoResidueCopyWith<$Res>? get residue {
    if (_self.residue == null) {
    return null;
  }

  return $DrugInfoResidueCopyWith<$Res>(_self.residue!, (value) {
    return _then(_self.copyWith(residue: value));
  });
}/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugInfoDefaultsCopyWith<$Res>? get defaults {
    if (_self.defaults == null) {
    return null;
  }

  return $DrugInfoDefaultsCopyWith<$Res>(_self.defaults!, (value) {
    return _then(_self.copyWith(defaults: value));
  });
}
}


/// Adds pattern-matching-related methods to [DrugInfo].
extension DrugInfoPatterns on DrugInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugInfo value)  $default,){
final _that = this;
switch (_that) {
case _DrugInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DrugInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String refDrugId, @JsonKey(name: 'ilac_adi')  String name, @JsonKey(name: 'etken_madde')  String activeIngredient, @JsonKey(name: 'endikasyonlar')  String? indications, @JsonKey(name: 'kullanimi_ve_sikligi')  Map<String, String> usage, @JsonKey(name: 'uygulandigi_donem')  DrugInfoPeriods periods, @JsonKey(name: 'kalinti_bilgisi_ikas')  DrugInfoResidue? residue, @JsonKey(name: 'otomatik_doldurma')  DrugInfoDefaults? defaults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugInfo() when $default != null:
return $default(_that.refDrugId,_that.name,_that.activeIngredient,_that.indications,_that.usage,_that.periods,_that.residue,_that.defaults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String refDrugId, @JsonKey(name: 'ilac_adi')  String name, @JsonKey(name: 'etken_madde')  String activeIngredient, @JsonKey(name: 'endikasyonlar')  String? indications, @JsonKey(name: 'kullanimi_ve_sikligi')  Map<String, String> usage, @JsonKey(name: 'uygulandigi_donem')  DrugInfoPeriods periods, @JsonKey(name: 'kalinti_bilgisi_ikas')  DrugInfoResidue? residue, @JsonKey(name: 'otomatik_doldurma')  DrugInfoDefaults? defaults)  $default,) {final _that = this;
switch (_that) {
case _DrugInfo():
return $default(_that.refDrugId,_that.name,_that.activeIngredient,_that.indications,_that.usage,_that.periods,_that.residue,_that.defaults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String refDrugId, @JsonKey(name: 'ilac_adi')  String name, @JsonKey(name: 'etken_madde')  String activeIngredient, @JsonKey(name: 'endikasyonlar')  String? indications, @JsonKey(name: 'kullanimi_ve_sikligi')  Map<String, String> usage, @JsonKey(name: 'uygulandigi_donem')  DrugInfoPeriods periods, @JsonKey(name: 'kalinti_bilgisi_ikas')  DrugInfoResidue? residue, @JsonKey(name: 'otomatik_doldurma')  DrugInfoDefaults? defaults)?  $default,) {final _that = this;
switch (_that) {
case _DrugInfo() when $default != null:
return $default(_that.refDrugId,_that.name,_that.activeIngredient,_that.indications,_that.usage,_that.periods,_that.residue,_that.defaults);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrugInfo implements DrugInfo {
  const _DrugInfo({required this.refDrugId, @JsonKey(name: 'ilac_adi') required this.name, @JsonKey(name: 'etken_madde') required this.activeIngredient, @JsonKey(name: 'endikasyonlar') this.indications, @JsonKey(name: 'kullanimi_ve_sikligi')  Map<String, String> usage = const {}, @JsonKey(name: 'uygulandigi_donem') this.periods = const DrugInfoPeriods(), @JsonKey(name: 'kalinti_bilgisi_ikas') this.residue, @JsonKey(name: 'otomatik_doldurma') this.defaults}): _usage = usage;
  factory _DrugInfo.fromJson(Map<String, dynamic> json) => _$DrugInfoFromJson(json);

@override final  String refDrugId;
@override@JsonKey(name: 'ilac_adi') final  String name;
@override@JsonKey(name: 'etken_madde') final  String activeIngredient;
@override@JsonKey(name: 'endikasyonlar') final  String? indications;
/// Kullanım ve sıklık; anahtarlar ürüne göre değişir
/// ([drugUsageItems] sıralar).
 final  Map<String, String> _usage;
/// Kullanım ve sıklık; anahtarlar ürüne göre değişir
/// ([drugUsageItems] sıralar).
@override@JsonKey(name: 'kullanimi_ve_sikligi') Map<String, String> get usage {
  if (_usage is EqualUnmodifiableMapView) return _usage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usage);
}

@override@JsonKey(name: 'uygulandigi_donem') final  DrugInfoPeriods periods;
@override@JsonKey(name: 'kalinti_bilgisi_ikas') final  DrugInfoResidue? residue;
/// İlaç seçilince formda dolan değerler.
@override@JsonKey(name: 'otomatik_doldurma') final  DrugInfoDefaults? defaults;

/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugInfoCopyWith<_DrugInfo> get copyWith => __$DrugInfoCopyWithImpl<_DrugInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrugInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugInfo&&(identical(other.refDrugId, refDrugId) || other.refDrugId == refDrugId)&&(identical(other.name, name) || other.name == name)&&(identical(other.activeIngredient, activeIngredient) || other.activeIngredient == activeIngredient)&&(identical(other.indications, indications) || other.indications == indications)&&const DeepCollectionEquality().equals(other.usage, _usage)&&(identical(other.periods, periods) || other.periods == periods)&&(identical(other.residue, residue) || other.residue == residue)&&(identical(other.defaults, defaults) || other.defaults == defaults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,refDrugId,name,activeIngredient,indications,const DeepCollectionEquality().hash(_usage),periods,residue,defaults);
}

@override
String toString() {
    return 'DrugInfo(refDrugId: $refDrugId, name: $name, activeIngredient: $activeIngredient, indications: $indications, usage: $usage, periods: $periods, residue: $residue, defaults: $defaults)';
}


}

/// @nodoc
abstract mixin class _$DrugInfoCopyWith<$Res> implements $DrugInfoCopyWith<$Res> {
  factory _$DrugInfoCopyWith(_DrugInfo value, $Res Function(_DrugInfo) _then) = __$DrugInfoCopyWithImpl;
@override @useResult
$Res call({
 String refDrugId,@JsonKey(name: 'ilac_adi') String name,@JsonKey(name: 'etken_madde') String activeIngredient,@JsonKey(name: 'endikasyonlar') String? indications,@JsonKey(name: 'kullanimi_ve_sikligi') Map<String, String> usage,@JsonKey(name: 'uygulandigi_donem') DrugInfoPeriods periods,@JsonKey(name: 'kalinti_bilgisi_ikas') DrugInfoResidue? residue,@JsonKey(name: 'otomatik_doldurma') DrugInfoDefaults? defaults
});


@override $DrugInfoPeriodsCopyWith<$Res> get periods;@override $DrugInfoResidueCopyWith<$Res>? get residue;@override $DrugInfoDefaultsCopyWith<$Res>? get defaults;

}
/// @nodoc
class __$DrugInfoCopyWithImpl<$Res>
    implements _$DrugInfoCopyWith<$Res> {
  __$DrugInfoCopyWithImpl(this._self, this._then);

  final _DrugInfo _self;
  final $Res Function(_DrugInfo) _then;

/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? refDrugId = null,Object? name = null,Object? activeIngredient = null,Object? indications = freezed,Object? usage = null,Object? periods = null,Object? residue = freezed,Object? defaults = freezed,}) {
  return _then(_DrugInfo(
refDrugId: null == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as String,indications: freezed == indications ? _self.indications : indications // ignore: cast_nullable_to_non_nullable
as String?,usage: null == usage ? _self._usage : usage // ignore: cast_nullable_to_non_nullable
as Map<String, String>,periods: null == periods ? _self.periods : periods // ignore: cast_nullable_to_non_nullable
as DrugInfoPeriods,residue: freezed == residue ? _self.residue : residue // ignore: cast_nullable_to_non_nullable
as DrugInfoResidue?,defaults: freezed == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as DrugInfoDefaults?,
  ));
}

/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugInfoPeriodsCopyWith<$Res> get periods {
  
  return $DrugInfoPeriodsCopyWith<$Res>(_self.periods, (value) {
    return _then(_self.copyWith(periods: value));
  });
}/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugInfoResidueCopyWith<$Res>? get residue {
    if (_self.residue == null) {
    return null;
  }

  return $DrugInfoResidueCopyWith<$Res>(_self.residue!, (value) {
    return _then(_self.copyWith(residue: value));
  });
}/// Create a copy of DrugInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugInfoDefaultsCopyWith<$Res>? get defaults {
    if (_self.defaults == null) {
    return null;
  }

  return $DrugInfoDefaultsCopyWith<$Res>(_self.defaults!, (value) {
    return _then(_self.copyWith(defaults: value));
  });
}
}


/// @nodoc
mixin _$DrugInfoDefaults {

@JsonKey(name: 'doz') int? get dose;@JsonKey(name: 'uygulama_gun') int? get treatmentDays;
/// Create a copy of DrugInfoDefaults
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugInfoDefaultsCopyWith<DrugInfoDefaults> get copyWith => _$DrugInfoDefaultsCopyWithImpl<DrugInfoDefaults>(this as DrugInfoDefaults, _$identity);

  /// Serializes this DrugInfoDefaults to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrugInfoDefaults;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugInfoDefaults&&(identical(other.dose, _this.dose) || other.dose == _this.dose)&&(identical(other.treatmentDays, _this.treatmentDays) || other.treatmentDays == _this.treatmentDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrugInfoDefaults;
  return Object.hash(runtimeType,_this.dose,_this.treatmentDays);
}

@override
String toString() {
  final _this = this as DrugInfoDefaults;
  return 'DrugInfoDefaults(dose: ${_this.dose}, treatmentDays: ${_this.treatmentDays})';
}


}

/// @nodoc
abstract mixin class $DrugInfoDefaultsCopyWith<$Res>  {
  factory $DrugInfoDefaultsCopyWith(DrugInfoDefaults value, $Res Function(DrugInfoDefaults) _then) = _$DrugInfoDefaultsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'doz') int? dose,@JsonKey(name: 'uygulama_gun') int? treatmentDays
});




}
/// @nodoc
class _$DrugInfoDefaultsCopyWithImpl<$Res>
    implements $DrugInfoDefaultsCopyWith<$Res> {
  _$DrugInfoDefaultsCopyWithImpl(this._self, this._then);

  final DrugInfoDefaults _self;
  final $Res Function(DrugInfoDefaults) _then;

/// Create a copy of DrugInfoDefaults
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dose = freezed,Object? treatmentDays = freezed,}) {
  return _then(DrugInfoDefaults(
dose: freezed == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as int?,treatmentDays: freezed == treatmentDays ? _self.treatmentDays : treatmentDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DrugInfoDefaults].
extension DrugInfoDefaultsPatterns on DrugInfoDefaults {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugInfoDefaults value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugInfoDefaults() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugInfoDefaults value)  $default,){
final _that = this;
switch (_that) {
case _DrugInfoDefaults():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugInfoDefaults value)?  $default,){
final _that = this;
switch (_that) {
case _DrugInfoDefaults() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'doz')  int? dose, @JsonKey(name: 'uygulama_gun')  int? treatmentDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugInfoDefaults() when $default != null:
return $default(_that.dose,_that.treatmentDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'doz')  int? dose, @JsonKey(name: 'uygulama_gun')  int? treatmentDays)  $default,) {final _that = this;
switch (_that) {
case _DrugInfoDefaults():
return $default(_that.dose,_that.treatmentDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'doz')  int? dose, @JsonKey(name: 'uygulama_gun')  int? treatmentDays)?  $default,) {final _that = this;
switch (_that) {
case _DrugInfoDefaults() when $default != null:
return $default(_that.dose,_that.treatmentDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrugInfoDefaults implements DrugInfoDefaults {
  const _DrugInfoDefaults({@JsonKey(name: 'doz') this.dose, @JsonKey(name: 'uygulama_gun') this.treatmentDays});
  factory _DrugInfoDefaults.fromJson(Map<String, dynamic> json) => _$DrugInfoDefaultsFromJson(json);

@override@JsonKey(name: 'doz') final  int? dose;
@override@JsonKey(name: 'uygulama_gun') final  int? treatmentDays;

/// Create a copy of DrugInfoDefaults
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugInfoDefaultsCopyWith<_DrugInfoDefaults> get copyWith => __$DrugInfoDefaultsCopyWithImpl<_DrugInfoDefaults>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrugInfoDefaultsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugInfoDefaults&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.treatmentDays, treatmentDays) || other.treatmentDays == treatmentDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,dose,treatmentDays);
}

@override
String toString() {
    return 'DrugInfoDefaults(dose: $dose, treatmentDays: $treatmentDays)';
}


}

/// @nodoc
abstract mixin class _$DrugInfoDefaultsCopyWith<$Res> implements $DrugInfoDefaultsCopyWith<$Res> {
  factory _$DrugInfoDefaultsCopyWith(_DrugInfoDefaults value, $Res Function(_DrugInfoDefaults) _then) = __$DrugInfoDefaultsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'doz') int? dose,@JsonKey(name: 'uygulama_gun') int? treatmentDays
});




}
/// @nodoc
class __$DrugInfoDefaultsCopyWithImpl<$Res>
    implements _$DrugInfoDefaultsCopyWith<$Res> {
  __$DrugInfoDefaultsCopyWithImpl(this._self, this._then);

  final _DrugInfoDefaults _self;
  final $Res Function(_DrugInfoDefaults) _then;

/// Create a copy of DrugInfoDefaults
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dose = freezed,Object? treatmentDays = freezed,}) {
  return _then(_DrugInfoDefaults(
dose: freezed == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as int?,treatmentDays: freezed == treatmentDays ? _self.treatmentDays : treatmentDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DrugInfoPeriods {

@JsonKey(name: 'uygun_donemler') List<String> get suitable;@JsonKey(name: 'kullanilmamasi_gereken_donemler') List<String> get avoid;
/// Create a copy of DrugInfoPeriods
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugInfoPeriodsCopyWith<DrugInfoPeriods> get copyWith => _$DrugInfoPeriodsCopyWithImpl<DrugInfoPeriods>(this as DrugInfoPeriods, _$identity);

  /// Serializes this DrugInfoPeriods to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrugInfoPeriods;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugInfoPeriods&&const DeepCollectionEquality().equals(other.suitable, _this.suitable)&&const DeepCollectionEquality().equals(other.avoid, _this.avoid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrugInfoPeriods;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.suitable),const DeepCollectionEquality().hash(_this.avoid));
}

@override
String toString() {
  final _this = this as DrugInfoPeriods;
  return 'DrugInfoPeriods(suitable: ${_this.suitable}, avoid: ${_this.avoid})';
}


}

/// @nodoc
abstract mixin class $DrugInfoPeriodsCopyWith<$Res>  {
  factory $DrugInfoPeriodsCopyWith(DrugInfoPeriods value, $Res Function(DrugInfoPeriods) _then) = _$DrugInfoPeriodsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'uygun_donemler') List<String> suitable,@JsonKey(name: 'kullanilmamasi_gereken_donemler') List<String> avoid
});




}
/// @nodoc
class _$DrugInfoPeriodsCopyWithImpl<$Res>
    implements $DrugInfoPeriodsCopyWith<$Res> {
  _$DrugInfoPeriodsCopyWithImpl(this._self, this._then);

  final DrugInfoPeriods _self;
  final $Res Function(DrugInfoPeriods) _then;

/// Create a copy of DrugInfoPeriods
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? suitable = null,Object? avoid = null,}) {
  return _then(DrugInfoPeriods(
suitable: null == suitable ? _self.suitable : suitable // ignore: cast_nullable_to_non_nullable
as List<String>,avoid: null == avoid ? _self.avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DrugInfoPeriods].
extension DrugInfoPeriodsPatterns on DrugInfoPeriods {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugInfoPeriods value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugInfoPeriods() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugInfoPeriods value)  $default,){
final _that = this;
switch (_that) {
case _DrugInfoPeriods():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugInfoPeriods value)?  $default,){
final _that = this;
switch (_that) {
case _DrugInfoPeriods() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'uygun_donemler')  List<String> suitable, @JsonKey(name: 'kullanilmamasi_gereken_donemler')  List<String> avoid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugInfoPeriods() when $default != null:
return $default(_that.suitable,_that.avoid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'uygun_donemler')  List<String> suitable, @JsonKey(name: 'kullanilmamasi_gereken_donemler')  List<String> avoid)  $default,) {final _that = this;
switch (_that) {
case _DrugInfoPeriods():
return $default(_that.suitable,_that.avoid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'uygun_donemler')  List<String> suitable, @JsonKey(name: 'kullanilmamasi_gereken_donemler')  List<String> avoid)?  $default,) {final _that = this;
switch (_that) {
case _DrugInfoPeriods() when $default != null:
return $default(_that.suitable,_that.avoid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrugInfoPeriods implements DrugInfoPeriods {
  const _DrugInfoPeriods({@JsonKey(name: 'uygun_donemler')  List<String> suitable = const [], @JsonKey(name: 'kullanilmamasi_gereken_donemler')  List<String> avoid = const []}): _suitable = suitable,_avoid = avoid;
  factory _DrugInfoPeriods.fromJson(Map<String, dynamic> json) => _$DrugInfoPeriodsFromJson(json);

 final  List<String> _suitable;
@override@JsonKey(name: 'uygun_donemler') List<String> get suitable {
  if (_suitable is EqualUnmodifiableListView) return _suitable;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suitable);
}

 final  List<String> _avoid;
@override@JsonKey(name: 'kullanilmamasi_gereken_donemler') List<String> get avoid {
  if (_avoid is EqualUnmodifiableListView) return _avoid;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_avoid);
}


/// Create a copy of DrugInfoPeriods
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugInfoPeriodsCopyWith<_DrugInfoPeriods> get copyWith => __$DrugInfoPeriodsCopyWithImpl<_DrugInfoPeriods>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrugInfoPeriodsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugInfoPeriods&&const DeepCollectionEquality().equals(other.suitable, _suitable)&&const DeepCollectionEquality().equals(other.avoid, _avoid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_suitable),const DeepCollectionEquality().hash(_avoid));
}

@override
String toString() {
    return 'DrugInfoPeriods(suitable: $suitable, avoid: $avoid)';
}


}

/// @nodoc
abstract mixin class _$DrugInfoPeriodsCopyWith<$Res> implements $DrugInfoPeriodsCopyWith<$Res> {
  factory _$DrugInfoPeriodsCopyWith(_DrugInfoPeriods value, $Res Function(_DrugInfoPeriods) _then) = __$DrugInfoPeriodsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'uygun_donemler') List<String> suitable,@JsonKey(name: 'kullanilmamasi_gereken_donemler') List<String> avoid
});




}
/// @nodoc
class __$DrugInfoPeriodsCopyWithImpl<$Res>
    implements _$DrugInfoPeriodsCopyWith<$Res> {
  __$DrugInfoPeriodsCopyWithImpl(this._self, this._then);

  final _DrugInfoPeriods _self;
  final $Res Function(_DrugInfoPeriods) _then;

/// Create a copy of DrugInfoPeriods
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? suitable = null,Object? avoid = null,}) {
  return _then(_DrugInfoPeriods(
suitable: null == suitable ? _self._suitable : suitable // ignore: cast_nullable_to_non_nullable
as List<String>,avoid: null == avoid ? _self._avoid : avoid // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$DrugInfoResidue {

@JsonKey(name: 'arinma_suresi') String get withdrawal;@JsonKey(name: 'uyarilar') String? get warnings;
/// Create a copy of DrugInfoResidue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugInfoResidueCopyWith<DrugInfoResidue> get copyWith => _$DrugInfoResidueCopyWithImpl<DrugInfoResidue>(this as DrugInfoResidue, _$identity);

  /// Serializes this DrugInfoResidue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrugInfoResidue;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugInfoResidue&&(identical(other.withdrawal, _this.withdrawal) || other.withdrawal == _this.withdrawal)&&(identical(other.warnings, _this.warnings) || other.warnings == _this.warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrugInfoResidue;
  return Object.hash(runtimeType,_this.withdrawal,_this.warnings);
}

@override
String toString() {
  final _this = this as DrugInfoResidue;
  return 'DrugInfoResidue(withdrawal: ${_this.withdrawal}, warnings: ${_this.warnings})';
}


}

/// @nodoc
abstract mixin class $DrugInfoResidueCopyWith<$Res>  {
  factory $DrugInfoResidueCopyWith(DrugInfoResidue value, $Res Function(DrugInfoResidue) _then) = _$DrugInfoResidueCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'arinma_suresi') String withdrawal,@JsonKey(name: 'uyarilar') String? warnings
});




}
/// @nodoc
class _$DrugInfoResidueCopyWithImpl<$Res>
    implements $DrugInfoResidueCopyWith<$Res> {
  _$DrugInfoResidueCopyWithImpl(this._self, this._then);

  final DrugInfoResidue _self;
  final $Res Function(DrugInfoResidue) _then;

/// Create a copy of DrugInfoResidue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? withdrawal = null,Object? warnings = freezed,}) {
  return _then(DrugInfoResidue(
withdrawal: null == withdrawal ? _self.withdrawal : withdrawal // ignore: cast_nullable_to_non_nullable
as String,warnings: freezed == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DrugInfoResidue].
extension DrugInfoResiduePatterns on DrugInfoResidue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugInfoResidue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugInfoResidue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugInfoResidue value)  $default,){
final _that = this;
switch (_that) {
case _DrugInfoResidue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugInfoResidue value)?  $default,){
final _that = this;
switch (_that) {
case _DrugInfoResidue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'arinma_suresi')  String withdrawal, @JsonKey(name: 'uyarilar')  String? warnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugInfoResidue() when $default != null:
return $default(_that.withdrawal,_that.warnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'arinma_suresi')  String withdrawal, @JsonKey(name: 'uyarilar')  String? warnings)  $default,) {final _that = this;
switch (_that) {
case _DrugInfoResidue():
return $default(_that.withdrawal,_that.warnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'arinma_suresi')  String withdrawal, @JsonKey(name: 'uyarilar')  String? warnings)?  $default,) {final _that = this;
switch (_that) {
case _DrugInfoResidue() when $default != null:
return $default(_that.withdrawal,_that.warnings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrugInfoResidue implements DrugInfoResidue {
  const _DrugInfoResidue({@JsonKey(name: 'arinma_suresi') required this.withdrawal, @JsonKey(name: 'uyarilar') this.warnings});
  factory _DrugInfoResidue.fromJson(Map<String, dynamic> json) => _$DrugInfoResidueFromJson(json);

@override@JsonKey(name: 'arinma_suresi') final  String withdrawal;
@override@JsonKey(name: 'uyarilar') final  String? warnings;

/// Create a copy of DrugInfoResidue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugInfoResidueCopyWith<_DrugInfoResidue> get copyWith => __$DrugInfoResidueCopyWithImpl<_DrugInfoResidue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrugInfoResidueToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugInfoResidue&&(identical(other.withdrawal, withdrawal) || other.withdrawal == withdrawal)&&(identical(other.warnings, warnings) || other.warnings == warnings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,withdrawal,warnings);
}

@override
String toString() {
    return 'DrugInfoResidue(withdrawal: $withdrawal, warnings: $warnings)';
}


}

/// @nodoc
abstract mixin class _$DrugInfoResidueCopyWith<$Res> implements $DrugInfoResidueCopyWith<$Res> {
  factory _$DrugInfoResidueCopyWith(_DrugInfoResidue value, $Res Function(_DrugInfoResidue) _then) = __$DrugInfoResidueCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'arinma_suresi') String withdrawal,@JsonKey(name: 'uyarilar') String? warnings
});




}
/// @nodoc
class __$DrugInfoResidueCopyWithImpl<$Res>
    implements _$DrugInfoResidueCopyWith<$Res> {
  __$DrugInfoResidueCopyWithImpl(this._self, this._then);

  final _DrugInfoResidue _self;
  final $Res Function(_DrugInfoResidue) _then;

/// Create a copy of DrugInfoResidue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? withdrawal = null,Object? warnings = freezed,}) {
  return _then(_DrugInfoResidue(
withdrawal: null == withdrawal ? _self.withdrawal : withdrawal // ignore: cast_nullable_to_non_nullable
as String,warnings: freezed == warnings ? _self.warnings : warnings // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
