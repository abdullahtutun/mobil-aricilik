// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'treatment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Treatment {

 String get id; String get orgId; String get hiveId;/// Uygulamanın yapıldığı arılık; kovan sonra taşınsa da değişmez.
 String get apiaryId; String get productName; DrugActiveIngredient get activeIngredient;/// Kovan başına doz.
 double get dose; DrugDoseUnit get doseUnit; DateTime get startedAt;/// Çıkarmadan (yoksa başlangıçtan) sonra bal katı ve hasat için gün.
 int get withdrawalDays; DateTime get createdAt; DateTime get updatedAt; String? get refDrugId; String? get drugId; String? get batchNo;/// Şeridin çıkarılacağı gün; tek seferlik uygulamada boş.
 DateTime? get plannedRemovalAt; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Treatment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TreatmentCopyWith<Treatment> get copyWith => _$TreatmentCopyWithImpl<Treatment>(this as Treatment, _$identity);

  /// Serializes this Treatment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Treatment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Treatment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.productName, _this.productName) || other.productName == _this.productName)&&(identical(other.activeIngredient, _this.activeIngredient) || other.activeIngredient == _this.activeIngredient)&&(identical(other.dose, _this.dose) || other.dose == _this.dose)&&(identical(other.doseUnit, _this.doseUnit) || other.doseUnit == _this.doseUnit)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.withdrawalDays, _this.withdrawalDays) || other.withdrawalDays == _this.withdrawalDays)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.refDrugId, _this.refDrugId) || other.refDrugId == _this.refDrugId)&&(identical(other.drugId, _this.drugId) || other.drugId == _this.drugId)&&(identical(other.batchNo, _this.batchNo) || other.batchNo == _this.batchNo)&&(identical(other.plannedRemovalAt, _this.plannedRemovalAt) || other.plannedRemovalAt == _this.plannedRemovalAt)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Treatment;
  return Object.hashAll([runtimeType,_this.id,_this.orgId,_this.hiveId,_this.apiaryId,_this.productName,_this.activeIngredient,_this.dose,_this.doseUnit,_this.startedAt,_this.withdrawalDays,_this.createdAt,_this.updatedAt,_this.refDrugId,_this.drugId,_this.batchNo,_this.plannedRemovalAt,_this.createdBy,_this.deletedAt,_this.serverSeq]);
}

@override
String toString() {
  final _this = this as Treatment;
  return 'Treatment(id: ${_this.id}, orgId: ${_this.orgId}, hiveId: ${_this.hiveId}, apiaryId: ${_this.apiaryId}, productName: ${_this.productName}, activeIngredient: ${_this.activeIngredient}, dose: ${_this.dose}, doseUnit: ${_this.doseUnit}, startedAt: ${_this.startedAt}, withdrawalDays: ${_this.withdrawalDays}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, refDrugId: ${_this.refDrugId}, drugId: ${_this.drugId}, batchNo: ${_this.batchNo}, plannedRemovalAt: ${_this.plannedRemovalAt}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $TreatmentCopyWith<$Res>  {
  factory $TreatmentCopyWith(Treatment value, $Res Function(Treatment) _then) = _$TreatmentCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, String productName, DrugActiveIngredient activeIngredient, double dose, DrugDoseUnit doseUnit, DateTime startedAt, int withdrawalDays, DateTime createdAt, DateTime updatedAt, String? refDrugId, String? drugId, String? batchNo, DateTime? plannedRemovalAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$TreatmentCopyWithImpl<$Res>
    implements $TreatmentCopyWith<$Res> {
  _$TreatmentCopyWithImpl(this._self, this._then);

  final Treatment _self;
  final $Res Function(Treatment) _then;

/// Create a copy of Treatment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? productName = null,Object? activeIngredient = null,Object? dose = null,Object? doseUnit = null,Object? startedAt = null,Object? withdrawalDays = null,Object? createdAt = null,Object? updatedAt = null,Object? refDrugId = freezed,Object? drugId = freezed,Object? batchNo = freezed,Object? plannedRemovalAt = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Treatment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: null == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,refDrugId: freezed == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,plannedRemovalAt: freezed == plannedRemovalAt ? _self.plannedRemovalAt : plannedRemovalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Treatment].
extension TreatmentPatterns on Treatment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Treatment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Treatment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Treatment value)  $default,){
final _that = this;
switch (_that) {
case _Treatment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Treatment value)?  $default,){
final _that = this;
switch (_that) {
case _Treatment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  String productName,  DrugActiveIngredient activeIngredient,  double dose,  DrugDoseUnit doseUnit,  DateTime startedAt,  int withdrawalDays,  DateTime createdAt,  DateTime updatedAt,  String? refDrugId,  String? drugId,  String? batchNo,  DateTime? plannedRemovalAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Treatment() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.productName,_that.activeIngredient,_that.dose,_that.doseUnit,_that.startedAt,_that.withdrawalDays,_that.createdAt,_that.updatedAt,_that.refDrugId,_that.drugId,_that.batchNo,_that.plannedRemovalAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  String productName,  DrugActiveIngredient activeIngredient,  double dose,  DrugDoseUnit doseUnit,  DateTime startedAt,  int withdrawalDays,  DateTime createdAt,  DateTime updatedAt,  String? refDrugId,  String? drugId,  String? batchNo,  DateTime? plannedRemovalAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Treatment():
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.productName,_that.activeIngredient,_that.dose,_that.doseUnit,_that.startedAt,_that.withdrawalDays,_that.createdAt,_that.updatedAt,_that.refDrugId,_that.drugId,_that.batchNo,_that.plannedRemovalAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String hiveId,  String apiaryId,  String productName,  DrugActiveIngredient activeIngredient,  double dose,  DrugDoseUnit doseUnit,  DateTime startedAt,  int withdrawalDays,  DateTime createdAt,  DateTime updatedAt,  String? refDrugId,  String? drugId,  String? batchNo,  DateTime? plannedRemovalAt,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Treatment() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.productName,_that.activeIngredient,_that.dose,_that.doseUnit,_that.startedAt,_that.withdrawalDays,_that.createdAt,_that.updatedAt,_that.refDrugId,_that.drugId,_that.batchNo,_that.plannedRemovalAt,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Treatment implements Treatment {
  const _Treatment({required this.id, required this.orgId, required this.hiveId, required this.apiaryId, required this.productName, required this.activeIngredient, required this.dose, required this.doseUnit, required this.startedAt, required this.withdrawalDays, required this.createdAt, required this.updatedAt, this.refDrugId, this.drugId, this.batchNo, this.plannedRemovalAt, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _Treatment.fromJson(Map<String, dynamic> json) => _$TreatmentFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String hiveId;
/// Uygulamanın yapıldığı arılık; kovan sonra taşınsa da değişmez.
@override final  String apiaryId;
@override final  String productName;
@override final  DrugActiveIngredient activeIngredient;
/// Kovan başına doz.
@override final  double dose;
@override final  DrugDoseUnit doseUnit;
@override final  DateTime startedAt;
/// Çıkarmadan (yoksa başlangıçtan) sonra bal katı ve hasat için gün.
@override final  int withdrawalDays;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? refDrugId;
@override final  String? drugId;
@override final  String? batchNo;
/// Şeridin çıkarılacağı gün; tek seferlik uygulamada boş.
@override final  DateTime? plannedRemovalAt;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Treatment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TreatmentCopyWith<_Treatment> get copyWith => __$TreatmentCopyWithImpl<_Treatment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TreatmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Treatment&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.activeIngredient, activeIngredient) || other.activeIngredient == activeIngredient)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.doseUnit, doseUnit) || other.doseUnit == doseUnit)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.refDrugId, refDrugId) || other.refDrugId == refDrugId)&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.plannedRemovalAt, plannedRemovalAt) || other.plannedRemovalAt == plannedRemovalAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,orgId,hiveId,apiaryId,productName,activeIngredient,dose,doseUnit,startedAt,withdrawalDays,createdAt,updatedAt,refDrugId,drugId,batchNo,plannedRemovalAt,createdBy,deletedAt,serverSeq]);
}

@override
String toString() {
    return 'Treatment(id: $id, orgId: $orgId, hiveId: $hiveId, apiaryId: $apiaryId, productName: $productName, activeIngredient: $activeIngredient, dose: $dose, doseUnit: $doseUnit, startedAt: $startedAt, withdrawalDays: $withdrawalDays, createdAt: $createdAt, updatedAt: $updatedAt, refDrugId: $refDrugId, drugId: $drugId, batchNo: $batchNo, plannedRemovalAt: $plannedRemovalAt, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$TreatmentCopyWith<$Res> implements $TreatmentCopyWith<$Res> {
  factory _$TreatmentCopyWith(_Treatment value, $Res Function(_Treatment) _then) = __$TreatmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, String productName, DrugActiveIngredient activeIngredient, double dose, DrugDoseUnit doseUnit, DateTime startedAt, int withdrawalDays, DateTime createdAt, DateTime updatedAt, String? refDrugId, String? drugId, String? batchNo, DateTime? plannedRemovalAt, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$TreatmentCopyWithImpl<$Res>
    implements _$TreatmentCopyWith<$Res> {
  __$TreatmentCopyWithImpl(this._self, this._then);

  final _Treatment _self;
  final $Res Function(_Treatment) _then;

/// Create a copy of Treatment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? productName = null,Object? activeIngredient = null,Object? dose = null,Object? doseUnit = null,Object? startedAt = null,Object? withdrawalDays = null,Object? createdAt = null,Object? updatedAt = null,Object? refDrugId = freezed,Object? drugId = freezed,Object? batchNo = freezed,Object? plannedRemovalAt = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Treatment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,activeIngredient: null == activeIngredient ? _self.activeIngredient : activeIngredient // ignore: cast_nullable_to_non_nullable
as DrugActiveIngredient,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,doseUnit: null == doseUnit ? _self.doseUnit : doseUnit // ignore: cast_nullable_to_non_nullable
as DrugDoseUnit,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: null == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,refDrugId: freezed == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,plannedRemovalAt: freezed == plannedRemovalAt ? _self.plannedRemovalAt : plannedRemovalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$TreatmentPlan {

 DrugChoice get drug;/// Kovan başına doz; birimi ilacın.
 double get dose; DateTime get startedAt; int get withdrawalDays; String? get batchNo; DateTime? get plannedRemovalAt;
/// Create a copy of TreatmentPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TreatmentPlanCopyWith<TreatmentPlan> get copyWith => _$TreatmentPlanCopyWithImpl<TreatmentPlan>(this as TreatmentPlan, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TreatmentPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TreatmentPlan&&(identical(other.drug, _this.drug) || other.drug == _this.drug)&&(identical(other.dose, _this.dose) || other.dose == _this.dose)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.withdrawalDays, _this.withdrawalDays) || other.withdrawalDays == _this.withdrawalDays)&&(identical(other.batchNo, _this.batchNo) || other.batchNo == _this.batchNo)&&(identical(other.plannedRemovalAt, _this.plannedRemovalAt) || other.plannedRemovalAt == _this.plannedRemovalAt));
}


@override
int get hashCode {
  final _this = this as TreatmentPlan;
  return Object.hash(runtimeType,_this.drug,_this.dose,_this.startedAt,_this.withdrawalDays,_this.batchNo,_this.plannedRemovalAt);
}

@override
String toString() {
  final _this = this as TreatmentPlan;
  return 'TreatmentPlan(drug: ${_this.drug}, dose: ${_this.dose}, startedAt: ${_this.startedAt}, withdrawalDays: ${_this.withdrawalDays}, batchNo: ${_this.batchNo}, plannedRemovalAt: ${_this.plannedRemovalAt})';
}


}

/// @nodoc
abstract mixin class $TreatmentPlanCopyWith<$Res>  {
  factory $TreatmentPlanCopyWith(TreatmentPlan value, $Res Function(TreatmentPlan) _then) = _$TreatmentPlanCopyWithImpl;
@useResult
$Res call({
 DrugChoice drug, double dose, DateTime startedAt, int withdrawalDays, String? batchNo, DateTime? plannedRemovalAt
});


$DrugChoiceCopyWith<$Res> get drug;

}
/// @nodoc
class _$TreatmentPlanCopyWithImpl<$Res>
    implements $TreatmentPlanCopyWith<$Res> {
  _$TreatmentPlanCopyWithImpl(this._self, this._then);

  final TreatmentPlan _self;
  final $Res Function(TreatmentPlan) _then;

/// Create a copy of TreatmentPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drug = null,Object? dose = null,Object? startedAt = null,Object? withdrawalDays = null,Object? batchNo = freezed,Object? plannedRemovalAt = freezed,}) {
  return _then(TreatmentPlan(
drug: null == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as DrugChoice,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: null == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,plannedRemovalAt: freezed == plannedRemovalAt ? _self.plannedRemovalAt : plannedRemovalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of TreatmentPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugChoiceCopyWith<$Res> get drug {
  
  return $DrugChoiceCopyWith<$Res>(_self.drug, (value) {
    return _then(_self.copyWith(drug: value));
  });
}
}


/// Adds pattern-matching-related methods to [TreatmentPlan].
extension TreatmentPlanPatterns on TreatmentPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TreatmentPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TreatmentPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TreatmentPlan value)  $default,){
final _that = this;
switch (_that) {
case _TreatmentPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TreatmentPlan value)?  $default,){
final _that = this;
switch (_that) {
case _TreatmentPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DrugChoice drug,  double dose,  DateTime startedAt,  int withdrawalDays,  String? batchNo,  DateTime? plannedRemovalAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TreatmentPlan() when $default != null:
return $default(_that.drug,_that.dose,_that.startedAt,_that.withdrawalDays,_that.batchNo,_that.plannedRemovalAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DrugChoice drug,  double dose,  DateTime startedAt,  int withdrawalDays,  String? batchNo,  DateTime? plannedRemovalAt)  $default,) {final _that = this;
switch (_that) {
case _TreatmentPlan():
return $default(_that.drug,_that.dose,_that.startedAt,_that.withdrawalDays,_that.batchNo,_that.plannedRemovalAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DrugChoice drug,  double dose,  DateTime startedAt,  int withdrawalDays,  String? batchNo,  DateTime? plannedRemovalAt)?  $default,) {final _that = this;
switch (_that) {
case _TreatmentPlan() when $default != null:
return $default(_that.drug,_that.dose,_that.startedAt,_that.withdrawalDays,_that.batchNo,_that.plannedRemovalAt);case _:
  return null;

}
}

}

/// @nodoc


class _TreatmentPlan implements TreatmentPlan {
  const _TreatmentPlan({required this.drug, required this.dose, required this.startedAt, required this.withdrawalDays, this.batchNo, this.plannedRemovalAt});
  

@override final  DrugChoice drug;
/// Kovan başına doz; birimi ilacın.
@override final  double dose;
@override final  DateTime startedAt;
@override final  int withdrawalDays;
@override final  String? batchNo;
@override final  DateTime? plannedRemovalAt;

/// Create a copy of TreatmentPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TreatmentPlanCopyWith<_TreatmentPlan> get copyWith => __$TreatmentPlanCopyWithImpl<_TreatmentPlan>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TreatmentPlan&&(identical(other.drug, drug) || other.drug == drug)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.withdrawalDays, withdrawalDays) || other.withdrawalDays == withdrawalDays)&&(identical(other.batchNo, batchNo) || other.batchNo == batchNo)&&(identical(other.plannedRemovalAt, plannedRemovalAt) || other.plannedRemovalAt == plannedRemovalAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,drug,dose,startedAt,withdrawalDays,batchNo,plannedRemovalAt);
}

@override
String toString() {
    return 'TreatmentPlan(drug: $drug, dose: $dose, startedAt: $startedAt, withdrawalDays: $withdrawalDays, batchNo: $batchNo, plannedRemovalAt: $plannedRemovalAt)';
}


}

/// @nodoc
abstract mixin class _$TreatmentPlanCopyWith<$Res> implements $TreatmentPlanCopyWith<$Res> {
  factory _$TreatmentPlanCopyWith(_TreatmentPlan value, $Res Function(_TreatmentPlan) _then) = __$TreatmentPlanCopyWithImpl;
@override @useResult
$Res call({
 DrugChoice drug, double dose, DateTime startedAt, int withdrawalDays, String? batchNo, DateTime? plannedRemovalAt
});


@override $DrugChoiceCopyWith<$Res> get drug;

}
/// @nodoc
class __$TreatmentPlanCopyWithImpl<$Res>
    implements _$TreatmentPlanCopyWith<$Res> {
  __$TreatmentPlanCopyWithImpl(this._self, this._then);

  final _TreatmentPlan _self;
  final $Res Function(_TreatmentPlan) _then;

/// Create a copy of TreatmentPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drug = null,Object? dose = null,Object? startedAt = null,Object? withdrawalDays = null,Object? batchNo = freezed,Object? plannedRemovalAt = freezed,}) {
  return _then(_TreatmentPlan(
drug: null == drug ? _self.drug : drug // ignore: cast_nullable_to_non_nullable
as DrugChoice,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as double,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,withdrawalDays: null == withdrawalDays ? _self.withdrawalDays : withdrawalDays // ignore: cast_nullable_to_non_nullable
as int,batchNo: freezed == batchNo ? _self.batchNo : batchNo // ignore: cast_nullable_to_non_nullable
as String?,plannedRemovalAt: freezed == plannedRemovalAt ? _self.plannedRemovalAt : plannedRemovalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of TreatmentPlan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrugChoiceCopyWith<$Res> get drug {
  
  return $DrugChoiceCopyWith<$Res>(_self.drug, (value) {
    return _then(_self.copyWith(drug: value));
  });
}
}

// dart format on
