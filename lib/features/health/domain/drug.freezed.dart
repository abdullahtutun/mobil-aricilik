// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drug.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RefDrug {

 String get id; String get countryCode; String get nameTr; String get nameEn; DrugActiveIngredient get activeIngredient; DrugDoseUnit get doseUnit; DateTime get createdAt; DateTime get updatedAt;/// Etiketteki bal bekleme süresi; bilinmiyorsa boş.
 int? get withdrawalDays; String? get licenseNo; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of RefDrug
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefDrugCopyWith<RefDrug> get copyWith => _$RefDrugCopyWithImpl<RefDrug>(this as RefDrug, _$identity);

  /// Serializes this RefDrug to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RefDrug;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefDrug&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.countryCode, _this.countryCode) || other.countryCode == _this.countryCode)&&(identical(other.nameTr, _this.nameTr) || other.nameTr == _this.nameTr)&&(identical(other.nameEn, _this.nameEn) || other.nameEn == _this.nameEn)&&(identical(other.activeIngredient, _this.activeIngredient) || other.activeIngredient == _this.activeIngredient)&&(identical(other.doseUnit, _this.doseUnit) || other.doseUnit == _this.doseUnit)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.withdrawalDays, _this.withdrawalDays) || other.withdrawalDays == _this.withdrawalDays)&&(identical(other.licenseNo, _this.licenseNo) || other.licenseNo == _this.licenseNo)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RefDrug;
  return Object.hash(runtimeType,_this.id,_this.countryCode,_this.nameTr,_this.nameEn,_this.activeIngredient,_this.doseUnit,_this.createdAt,_this.updatedAt,_this.withdrawalDays,_this.licenseNo,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as RefDrug;
  return 'RefDrug(id: ${_this.id}, countryCode: ${_this.countryCode}, nameTr: ${_this.nameTr}, nameEn: ${_this.nameEn}, activeIngredient: ${_this.activeIngredient}, doseUnit: ${_this.doseUnit}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, withdrawalDays: ${_this.withdrawalDays}, licenseNo: ${_this.licenseNo}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $RefDrugCopyWith<$Res>  {
  factory $RefDrugCopyWith(RefDrug value, $Res Function(RefDrug) _then) = _$RefDrugCopyWithImpl;
@useResult
$Res call({
 String id, String countryCode, String nameTr, String nameEn, DrugActiveIngredient activeIngredient, DrugDoseUnit doseUnit, DateTime createdAt, DateTime updatedAt, int? withdrawalDays, String? licenseNo, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$RefDrugCopyWithImpl<$Res>
    implements $RefDrugCopyWith<$Res> {
  _$RefDrugCopyWithImpl(this._self, this._then);

  final RefDrug _self;
  final $Res Function(RefDrug) _then;

/// Create a copy of RefDrug
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? countryCode = null,Object? nameTr = null,Object? nameEn = null,Object? activeIngredient = null,Object? doseUnit = null,Object? createdAt = null,Object? updatedAt = null,Object? withdrawalDays = freezed,Object? licenseNo = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(RefDrug(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,nameTr: null == nameTr ? _self.nameTr : nameTr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int?,licenseNo: freezed == licenseNo ? _self.licenseNo : licenseNo // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [RefDrug].
extension RefDrugPatterns on RefDrug {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RefDrug value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RefDrug() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RefDrug value)  $default,){
final _that = this;
switch (_that) {
case _RefDrug():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RefDrug value)?  $default,){
final _that = this;
switch (_that) {
case _RefDrug() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String countryCode,  String nameTr,  String nameEn,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  DateTime createdAt,  DateTime updatedAt,  int? withdrawalDays,  String? licenseNo,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RefDrug() when $default != null:
return $default(_that.id,_that.countryCode,_that.nameTr,_that.nameEn,_that.activeIngredient,_that.doseUnit,_that.createdAt,_that.updatedAt,_that.withdrawalDays,_that.licenseNo,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String countryCode,  String nameTr,  String nameEn,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  DateTime createdAt,  DateTime updatedAt,  int? withdrawalDays,  String? licenseNo,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _RefDrug():
return $default(_that.id,_that.countryCode,_that.nameTr,_that.nameEn,_that.activeIngredient,_that.doseUnit,_that.createdAt,_that.updatedAt,_that.withdrawalDays,_that.licenseNo,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String countryCode,  String nameTr,  String nameEn,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  DateTime createdAt,  DateTime updatedAt,  int? withdrawalDays,  String? licenseNo,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _RefDrug() when $default != null:
return $default(_that.id,_that.countryCode,_that.nameTr,_that.nameEn,_that.activeIngredient,_that.doseUnit,_that.createdAt,_that.updatedAt,_that.withdrawalDays,_that.licenseNo,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RefDrug implements RefDrug {
  const _RefDrug({required this.id, required this.countryCode, required this.nameTr, required this.nameEn, required this.activeIngredient, required this.doseUnit, required this.createdAt, required this.updatedAt, this.withdrawalDays, this.licenseNo, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _RefDrug.fromJson(Map<String, dynamic> json) => _$RefDrugFromJson(json);

@override final  String id;
@override final  String countryCode;
@override final  String nameTr;
@override final  String nameEn;
@override final  DrugActiveIngredient activeIngredient;
@override final  DrugDoseUnit doseUnit;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Etiketteki bal bekleme süresi; bilinmiyorsa boş.
@override final  int? withdrawalDays;
@override final  String? licenseNo;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of RefDrug
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefDrugCopyWith<_RefDrug> get copyWith => __$RefDrugCopyWithImpl<_RefDrug>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefDrugToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RefDrug&&(identical(other.id, id) || other.id == id)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.nameTr, nameTr) || other.nameTr == nameTr)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.activeIngredient, activeIngredient) || other.activeIngredient == activeIngredient)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.licenseNo, licenseNo) || other.licenseNo == licenseNo)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,countryCode,nameTr,nameEn,activeIngredient,doseUnit,createdAt,updatedAt,withdrawalDays,licenseNo,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'RefDrug(id: $id, countryCode: $countryCode, nameTr: $nameTr, nameEn: $nameEn, activeIngredient: $activeIngredient, doseUnit: $doseUnit, createdAt: $createdAt, updatedAt: $updatedAt, withdrawalDays: $withdrawalDays, licenseNo: $licenseNo, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$RefDrugCopyWith<$Res> implements $RefDrugCopyWith<$Res> {
  factory _$RefDrugCopyWith(_RefDrug value, $Res Function(_RefDrug) _then) = __$RefDrugCopyWithImpl;
@override @useResult
$Res call({
 String id, String countryCode, String nameTr, String nameEn, DrugActiveIngredient activeIngredient, DrugDoseUnit doseUnit, DateTime createdAt, DateTime updatedAt, int? withdrawalDays, String? licenseNo, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$RefDrugCopyWithImpl<$Res>
    implements _$RefDrugCopyWith<$Res> {
  __$RefDrugCopyWithImpl(this._self, this._then);

  final _RefDrug _self;
  final $Res Function(_RefDrug) _then;

/// Create a copy of RefDrug
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? countryCode = null,Object? nameTr = null,Object? nameEn = null,Object? activeIngredient = null,Object? doseUnit = null,Object? createdAt = null,Object? updatedAt = null,Object? withdrawalDays = freezed,Object? licenseNo = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_RefDrug(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,nameTr: null == nameTr ? _self.nameTr : nameTr // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int?,licenseNo: freezed == licenseNo ? _self.licenseNo : licenseNo // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Drug {

 String get id; String get orgId; String get name; DrugActiveIngredient get activeIngredient; DrugDoseUnit get doseUnit; DateTime get createdAt; DateTime get updatedAt; int? get withdrawalDays; String? get licenseNo; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugCopyWith<Drug> get copyWith => _$DrugCopyWithImpl<Drug>(this as Drug, _$identity);

  /// Serializes this Drug to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Drug;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Drug&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.activeIngredient, _this.activeIngredient) || other.activeIngredient == _this.activeIngredient)&&(identical(other.doseUnit, _this.doseUnit) || other.doseUnit == _this.doseUnit)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.withdrawalDays, _this.withdrawalDays) || other.withdrawalDays == _this.withdrawalDays)&&(identical(other.licenseNo, _this.licenseNo) || other.licenseNo == _this.licenseNo)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Drug;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.name,_this.activeIngredient,_this.doseUnit,_this.createdAt,_this.updatedAt,_this.withdrawalDays,_this.licenseNo,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as Drug;
  return 'Drug(id: ${_this.id}, orgId: ${_this.orgId}, name: ${_this.name}, activeIngredient: ${_this.activeIngredient}, doseUnit: ${_this.doseUnit}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, withdrawalDays: ${_this.withdrawalDays}, licenseNo: ${_this.licenseNo}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $DrugCopyWith<$Res>  {
  factory $DrugCopyWith(Drug value, $Res Function(Drug) _then) = _$DrugCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String name, DrugActiveIngredient activeIngredient, DrugDoseUnit doseUnit, DateTime createdAt, DateTime updatedAt, int? withdrawalDays, String? licenseNo, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$DrugCopyWithImpl<$Res>
    implements $DrugCopyWith<$Res> {
  _$DrugCopyWithImpl(this._self, this._then);

  final Drug _self;
  final $Res Function(Drug) _then;

/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? name = null,Object? activeIngredient = null,Object? doseUnit = null,Object? createdAt = null,Object? updatedAt = null,Object? withdrawalDays = freezed,Object? licenseNo = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Drug(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int?,licenseNo: freezed == licenseNo ? _self.licenseNo : licenseNo // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Drug].
extension DrugPatterns on Drug {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Drug value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Drug() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Drug value)  $default,){
final _that = this;
switch (_that) {
case _Drug():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Drug value)?  $default,){
final _that = this;
switch (_that) {
case _Drug() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String name,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  DateTime createdAt,  DateTime updatedAt,  int? withdrawalDays,  String? licenseNo,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Drug() when $default != null:
return $default(_that.id,_that.orgId,_that.name,_that.activeIngredient,_that.doseUnit,_that.createdAt,_that.updatedAt,_that.withdrawalDays,_that.licenseNo,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String name,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  DateTime createdAt,  DateTime updatedAt,  int? withdrawalDays,  String? licenseNo,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Drug():
return $default(_that.id,_that.orgId,_that.name,_that.activeIngredient,_that.doseUnit,_that.createdAt,_that.updatedAt,_that.withdrawalDays,_that.licenseNo,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String name,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  DateTime createdAt,  DateTime updatedAt,  int? withdrawalDays,  String? licenseNo,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Drug() when $default != null:
return $default(_that.id,_that.orgId,_that.name,_that.activeIngredient,_that.doseUnit,_that.createdAt,_that.updatedAt,_that.withdrawalDays,_that.licenseNo,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Drug implements Drug {
  const _Drug({required this.id, required this.orgId, required this.name, required this.activeIngredient, required this.doseUnit, required this.createdAt, required this.updatedAt, this.withdrawalDays, this.licenseNo, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String name;
@override final  DrugActiveIngredient activeIngredient;
@override final  DrugDoseUnit doseUnit;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  int? withdrawalDays;
@override final  String? licenseNo;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugCopyWith<_Drug> get copyWith => __$DrugCopyWithImpl<_Drug>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrugToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Drug&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.name, name) || other.name == name)&&(identical(other.activeIngredient, activeIngredient) || other.activeIngredient == activeIngredient)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.licenseNo, licenseNo) || other.licenseNo == licenseNo)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,name,activeIngredient,doseUnit,createdAt,updatedAt,withdrawalDays,licenseNo,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'Drug(id: $id, orgId: $orgId, name: $name, activeIngredient: $activeIngredient, doseUnit: $doseUnit, createdAt: $createdAt, updatedAt: $updatedAt, withdrawalDays: $withdrawalDays, licenseNo: $licenseNo, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$DrugCopyWith<$Res> implements $DrugCopyWith<$Res> {
  factory _$DrugCopyWith(_Drug value, $Res Function(_Drug) _then) = __$DrugCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String name, DrugActiveIngredient activeIngredient, DrugDoseUnit doseUnit, DateTime createdAt, DateTime updatedAt, int? withdrawalDays, String? licenseNo, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$DrugCopyWithImpl<$Res>
    implements _$DrugCopyWith<$Res> {
  __$DrugCopyWithImpl(this._self, this._then);

  final _Drug _self;
  final $Res Function(_Drug) _then;

/// Create a copy of Drug
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? name = null,Object? activeIngredient = null,Object? doseUnit = null,Object? createdAt = null,Object? updatedAt = null,Object? withdrawalDays = freezed,Object? licenseNo = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Drug(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int?,licenseNo: freezed == licenseNo ? _self.licenseNo : licenseNo // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$DrugChoice {

 String get name; DrugActiveIngredient get activeIngredient; DrugDoseUnit get doseUnit; String? get refDrugId; String? get drugId; int? get withdrawalDays; String? get licenseNo;/// Ürün bilgisindeki kovan başı doz; seçilince forma yazılır.
 int? get defaultDose;/// Ürün bilgisindeki kovanda kalma süresi (gün); planlanan çıkarma
/// buna göre önerilir.
 int? get treatmentDays;
/// Create a copy of DrugChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrugChoiceCopyWith<DrugChoice> get copyWith => _$DrugChoiceCopyWithImpl<DrugChoice>(this as DrugChoice, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DrugChoice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrugChoice&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.activeIngredient, _this.activeIngredient) || other.activeIngredient == _this.activeIngredient)&&(identical(other.doseUnit, _this.doseUnit) || other.doseUnit == _this.doseUnit)&&(identical(other.refDrugId, _this.refDrugId) || other.refDrugId == _this.refDrugId)&&(identical(other.drugId, _this.drugId) || other.drugId == _this.drugId)&&(identical(other.withdrawalDays, _this.withdrawalDays) || other.withdrawalDays == _this.withdrawalDays)&&(identical(other.licenseNo, _this.licenseNo) || other.licenseNo == _this.licenseNo)&&(identical(other.defaultDose, _this.defaultDose) || other.defaultDose == _this.defaultDose)&&(identical(other.treatmentDays, _this.treatmentDays) || other.treatmentDays == _this.treatmentDays));
}


@override
int get hashCode {
  final _this = this as DrugChoice;
  return Object.hash(runtimeType,_this.name,_this.activeIngredient,_this.doseUnit,_this.refDrugId,_this.drugId,_this.withdrawalDays,_this.licenseNo,_this.defaultDose,_this.treatmentDays);
}

@override
String toString() {
  final _this = this as DrugChoice;
  return 'DrugChoice(name: ${_this.name}, activeIngredient: ${_this.activeIngredient}, doseUnit: ${_this.doseUnit}, refDrugId: ${_this.refDrugId}, drugId: ${_this.drugId}, withdrawalDays: ${_this.withdrawalDays}, licenseNo: ${_this.licenseNo}, defaultDose: ${_this.defaultDose}, treatmentDays: ${_this.treatmentDays})';
}


}

/// @nodoc
abstract mixin class $DrugChoiceCopyWith<$Res>  {
  factory $DrugChoiceCopyWith(DrugChoice value, $Res Function(DrugChoice) _then) = _$DrugChoiceCopyWithImpl;
@useResult
$Res call({
 String name, DrugActiveIngredient activeIngredient, DrugDoseUnit doseUnit, String? refDrugId, String? drugId, int? withdrawalDays, String? licenseNo, int? defaultDose, int? treatmentDays
});




}
/// @nodoc
class _$DrugChoiceCopyWithImpl<$Res>
    implements $DrugChoiceCopyWith<$Res> {
  _$DrugChoiceCopyWithImpl(this._self, this._then);

  final DrugChoice _self;
  final $Res Function(DrugChoice) _then;

/// Create a copy of DrugChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? activeIngredient = null,Object? doseUnit = null,Object? refDrugId = freezed,Object? drugId = freezed,Object? withdrawalDays = freezed,Object? licenseNo = freezed,Object? defaultDose = freezed,Object? treatmentDays = freezed,}) {
  return _then(DrugChoice(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,refDrugId: freezed == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int?,licenseNo: freezed == licenseNo ? _self.licenseNo : licenseNo // ignore: cast_nullable_to_non_nullable
as String?,defaultDose: freezed == defaultDose ? _self.defaultDose : defaultDose // ignore: cast_nullable_to_non_nullable
as int?,treatmentDays: freezed == treatmentDays ? _self.treatmentDays : treatmentDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DrugChoice].
extension DrugChoicePatterns on DrugChoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrugChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrugChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrugChoice value)  $default,){
final _that = this;
switch (_that) {
case _DrugChoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrugChoice value)?  $default,){
final _that = this;
switch (_that) {
case _DrugChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  String? refDrugId,  String? drugId,  int? withdrawalDays,  String? licenseNo,  int? defaultDose,  int? treatmentDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrugChoice() when $default != null:
return $default(_that.name,_that.activeIngredient,_that.doseUnit,_that.refDrugId,_that.drugId,_that.withdrawalDays,_that.licenseNo,_that.defaultDose,_that.treatmentDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  String? refDrugId,  String? drugId,  int? withdrawalDays,  String? licenseNo,  int? defaultDose,  int? treatmentDays)  $default,) {final _that = this;
switch (_that) {
case _DrugChoice():
return $default(_that.name,_that.activeIngredient,_that.doseUnit,_that.refDrugId,_that.drugId,_that.withdrawalDays,_that.licenseNo,_that.defaultDose,_that.treatmentDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DrugActiveIngredient activeIngredient,  DrugDoseUnit doseUnit,  String? refDrugId,  String? drugId,  int? withdrawalDays,  String? licenseNo,  int? defaultDose,  int? treatmentDays)?  $default,) {final _that = this;
switch (_that) {
case _DrugChoice() when $default != null:
return $default(_that.name,_that.activeIngredient,_that.doseUnit,_that.refDrugId,_that.drugId,_that.withdrawalDays,_that.licenseNo,_that.defaultDose,_that.treatmentDays);case _:
  return null;

}
}

}

/// @nodoc


class _DrugChoice implements DrugChoice {
  const _DrugChoice({required this.name, required this.activeIngredient, required this.doseUnit, this.refDrugId, this.drugId, this.withdrawalDays, this.licenseNo, this.defaultDose, this.treatmentDays});
  

@override final  String name;
@override final  DrugActiveIngredient activeIngredient;
@override final  DrugDoseUnit doseUnit;
@override final  String? refDrugId;
@override final  String? drugId;
@override final  int? withdrawalDays;
@override final  String? licenseNo;
/// Ürün bilgisindeki kovan başı doz; seçilince forma yazılır.
@override final  int? defaultDose;
/// Ürün bilgisindeki kovanda kalma süresi (gün); planlanan çıkarma
/// buna göre önerilir.
@override final  int? treatmentDays;

/// Create a copy of DrugChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrugChoiceCopyWith<_DrugChoice> get copyWith => __$DrugChoiceCopyWithImpl<_DrugChoice>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrugChoice&&(identical(other.name, name) || other.name == name)&&(identical(other.activeIngredient, activeIngredient) || other.activeIngredient == activeIngredient)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.refDrugId, refDrugId) || other.refDrugId == refDrugId)&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.licenseNo, licenseNo) || other.licenseNo == licenseNo)&&(identical(other.defaultDose, defaultDose) || other.defaultDose == defaultDose)&&(identical(other.treatmentDays, treatmentDays) || other.treatmentDays == treatmentDays));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,activeIngredient,doseUnit,refDrugId,drugId,withdrawalDays,licenseNo,defaultDose,treatmentDays);
}

@override
String toString() {
    return 'DrugChoice(name: $name, activeIngredient: $activeIngredient, doseUnit: $doseUnit, refDrugId: $refDrugId, drugId: $drugId, withdrawalDays: $withdrawalDays, licenseNo: $licenseNo, defaultDose: $defaultDose, treatmentDays: $treatmentDays)';
}


}

/// @nodoc
abstract mixin class _$DrugChoiceCopyWith<$Res> implements $DrugChoiceCopyWith<$Res> {
  factory _$DrugChoiceCopyWith(_DrugChoice value, $Res Function(_DrugChoice) _then) = __$DrugChoiceCopyWithImpl;
@override @useResult
$Res call({
 String name, DrugActiveIngredient activeIngredient, DrugDoseUnit doseUnit, String? refDrugId, String? drugId, int? withdrawalDays, String? licenseNo, int? defaultDose, int? treatmentDays
});




}
/// @nodoc
class __$DrugChoiceCopyWithImpl<$Res>
    implements _$DrugChoiceCopyWith<$Res> {
  __$DrugChoiceCopyWithImpl(this._self, this._then);

  final _DrugChoice _self;
  final $Res Function(_DrugChoice) _then;

/// Create a copy of DrugChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? activeIngredient = null,Object? doseUnit = null,Object? refDrugId = freezed,Object? drugId = freezed,Object? withdrawalDays = freezed,Object? licenseNo = freezed,Object? defaultDose = freezed,Object? treatmentDays = freezed,}) {
  return _then(_DrugChoice(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,refDrugId: freezed == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,withdrawalDays: freezed == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int?,licenseNo: freezed == licenseNo ? _self.licenseNo : licenseNo // ignore: cast_nullable_to_non_nullable
as String?,defaultDose: freezed == defaultDose ? _self.defaultDose : defaultDose // ignore: cast_nullable_to_non_nullable
as int?,treatmentDays: freezed == treatmentDays ? _self.treatmentDays : treatmentDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
