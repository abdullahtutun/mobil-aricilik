// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InspectionValues {

 QueenState? get queenState;/// Arılı, yavrulu ve ballı çerçeve sayıları.
 int? get beeFrames; int? get broodFrames; int? get honeyFrames; Temperament? get temperament; bool? get swarmSigns; QueenCells? get queenCells; bool? get diseaseSuspected; Set<InspectionAction> get actions;
/// Create a copy of InspectionValues
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionValuesCopyWith<InspectionValues> get copyWith => _$InspectionValuesCopyWithImpl<InspectionValues>(this as InspectionValues, _$identity);

  /// Serializes this InspectionValues to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InspectionValues;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionValues&&(identical(other.queenState, _this.queenState) || other.queenState == _this.queenState)&&(identical(other.beeFrames, _this.beeFrames) || other.beeFrames == _this.beeFrames)&&(identical(other.broodFrames, _this.broodFrames) || other.broodFrames == _this.broodFrames)&&(identical(other.honeyFrames, _this.honeyFrames) || other.honeyFrames == _this.honeyFrames)&&(identical(other.temperament, _this.temperament) || other.temperament == _this.temperament)&&(identical(other.swarmSigns, _this.swarmSigns) || other.swarmSigns == _this.swarmSigns)&&(identical(other.queenCells, _this.queenCells) || other.queenCells == _this.queenCells)&&(identical(other.diseaseSuspected, _this.diseaseSuspected) || other.diseaseSuspected == _this.diseaseSuspected)&&const DeepCollectionEquality().equals(other.actions, _this.actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InspectionValues;
  return Object.hash(runtimeType,_this.queenState,_this.beeFrames,_this.broodFrames,_this.honeyFrames,_this.temperament,_this.swarmSigns,_this.queenCells,_this.diseaseSuspected,const DeepCollectionEquality().hash(_this.actions));
}

@override
String toString() {
  final _this = this as InspectionValues;
  return 'InspectionValues(queenState: ${_this.queenState}, beeFrames: ${_this.beeFrames}, broodFrames: ${_this.broodFrames}, honeyFrames: ${_this.honeyFrames}, temperament: ${_this.temperament}, swarmSigns: ${_this.swarmSigns}, queenCells: ${_this.queenCells}, diseaseSuspected: ${_this.diseaseSuspected}, actions: ${_this.actions})';
}


}

/// @nodoc
abstract mixin class $InspectionValuesCopyWith<$Res>  {
  factory $InspectionValuesCopyWith(InspectionValues value, $Res Function(InspectionValues) _then) = _$InspectionValuesCopyWithImpl;
@useResult
$Res call({
 QueenState? queenState, int? beeFrames, int? broodFrames, int? honeyFrames, Temperament? temperament, bool? swarmSigns, QueenCells? queenCells, bool? diseaseSuspected, Set<InspectionAction> actions
});




}
/// @nodoc
class _$InspectionValuesCopyWithImpl<$Res>
    implements $InspectionValuesCopyWith<$Res> {
  _$InspectionValuesCopyWithImpl(this._self, this._then);

  final InspectionValues _self;
  final $Res Function(InspectionValues) _then;

/// Create a copy of InspectionValues
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? queenState = freezed,Object? beeFrames = freezed,Object? broodFrames = freezed,Object? honeyFrames = freezed,Object? temperament = freezed,Object? swarmSigns = freezed,Object? queenCells = freezed,Object? diseaseSuspected = freezed,Object? actions = null,}) {
  return _then(InspectionValues(
queenState: freezed == queenState ? _self.queenState : queenState // ignore: cast_nullable_to_non_nullable
as QueenState?,beeFrames: freezed == beeFrames ? _self.beeFrames : beeFrames // ignore: cast_nullable_to_non_nullable
as int?,broodFrames: freezed == broodFrames ? _self.broodFrames : broodFrames // ignore: cast_nullable_to_non_nullable
as int?,honeyFrames: freezed == honeyFrames ? _self.honeyFrames : honeyFrames // ignore: cast_nullable_to_non_nullable
as int?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as Temperament?,swarmSigns: freezed == swarmSigns ? _self.swarmSigns : swarmSigns // ignore: cast_nullable_to_non_nullable
as bool?,queenCells: freezed == queenCells ? _self.queenCells : queenCells // ignore: cast_nullable_to_non_nullable
as QueenCells?,diseaseSuspected: freezed == diseaseSuspected ? _self.diseaseSuspected : diseaseSuspected // ignore: cast_nullable_to_non_nullable
as bool?,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as Set<InspectionAction>,
  ));
}

}


/// Adds pattern-matching-related methods to [InspectionValues].
extension InspectionValuesPatterns on InspectionValues {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionValues value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionValues() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionValues value)  $default,){
final _that = this;
switch (_that) {
case _InspectionValues():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionValues value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionValues() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QueenState? queenState,  int? beeFrames,  int? broodFrames,  int? honeyFrames,  Temperament? temperament,  bool? swarmSigns,  QueenCells? queenCells,  bool? diseaseSuspected,  Set<InspectionAction> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionValues() when $default != null:
return $default(_that.queenState,_that.beeFrames,_that.broodFrames,_that.honeyFrames,_that.temperament,_that.swarmSigns,_that.queenCells,_that.diseaseSuspected,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QueenState? queenState,  int? beeFrames,  int? broodFrames,  int? honeyFrames,  Temperament? temperament,  bool? swarmSigns,  QueenCells? queenCells,  bool? diseaseSuspected,  Set<InspectionAction> actions)  $default,) {final _that = this;
switch (_that) {
case _InspectionValues():
return $default(_that.queenState,_that.beeFrames,_that.broodFrames,_that.honeyFrames,_that.temperament,_that.swarmSigns,_that.queenCells,_that.diseaseSuspected,_that.actions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QueenState? queenState,  int? beeFrames,  int? broodFrames,  int? honeyFrames,  Temperament? temperament,  bool? swarmSigns,  QueenCells? queenCells,  bool? diseaseSuspected,  Set<InspectionAction> actions)?  $default,) {final _that = this;
switch (_that) {
case _InspectionValues() when $default != null:
return $default(_that.queenState,_that.beeFrames,_that.broodFrames,_that.honeyFrames,_that.temperament,_that.swarmSigns,_that.queenCells,_that.diseaseSuspected,_that.actions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InspectionValues implements InspectionValues {
  const _InspectionValues({this.queenState, this.beeFrames, this.broodFrames, this.honeyFrames, this.temperament, this.swarmSigns, this.queenCells, this.diseaseSuspected,  Set<InspectionAction> actions = const <InspectionAction>{}}): _actions = actions;
  factory _InspectionValues.fromJson(Map<String, dynamic> json) => _$InspectionValuesFromJson(json);

@override final  QueenState? queenState;
/// Arılı, yavrulu ve ballı çerçeve sayıları.
@override final  int? beeFrames;
@override final  int? broodFrames;
@override final  int? honeyFrames;
@override final  Temperament? temperament;
@override final  bool? swarmSigns;
@override final  QueenCells? queenCells;
@override final  bool? diseaseSuspected;
 final  Set<InspectionAction> _actions;
@override@JsonKey() Set<InspectionAction> get actions {
  if (_actions is EqualUnmodifiableSetView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_actions);
}


/// Create a copy of InspectionValues
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionValuesCopyWith<_InspectionValues> get copyWith => __$InspectionValuesCopyWithImpl<_InspectionValues>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionValuesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionValues&&(identical(other.queenState, queenState) || other.queenState == queenState)&&(identical(other.beeFrames, beeFrames) || other.beeFrames == beeFrames)&&(identical(other.broodFrames, broodFrames) || other.broodFrames == broodFrames)&&(identical(other.honeyFrames, honeyFrames) || other.honeyFrames == honeyFrames)&&(identical(other.temperament, temperament) || other.temperament == temperament)&&(identical(other.swarmSigns, swarmSigns) || other.swarmSigns == swarmSigns)&&(identical(other.queenCells, queenCells) || other.queenCells == queenCells)&&(identical(other.diseaseSuspected, diseaseSuspected) || other.diseaseSuspected == diseaseSuspected)&&const DeepCollectionEquality().equals(other.actions, _actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,queenState,beeFrames,broodFrames,honeyFrames,temperament,swarmSigns,queenCells,diseaseSuspected,const DeepCollectionEquality().hash(_actions));
}

@override
String toString() {
    return 'InspectionValues(queenState: $queenState, beeFrames: $beeFrames, broodFrames: $broodFrames, honeyFrames: $honeyFrames, temperament: $temperament, swarmSigns: $swarmSigns, queenCells: $queenCells, diseaseSuspected: $diseaseSuspected, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$InspectionValuesCopyWith<$Res> implements $InspectionValuesCopyWith<$Res> {
  factory _$InspectionValuesCopyWith(_InspectionValues value, $Res Function(_InspectionValues) _then) = __$InspectionValuesCopyWithImpl;
@override @useResult
$Res call({
 QueenState? queenState, int? beeFrames, int? broodFrames, int? honeyFrames, Temperament? temperament, bool? swarmSigns, QueenCells? queenCells, bool? diseaseSuspected, Set<InspectionAction> actions
});




}
/// @nodoc
class __$InspectionValuesCopyWithImpl<$Res>
    implements _$InspectionValuesCopyWith<$Res> {
  __$InspectionValuesCopyWithImpl(this._self, this._then);

  final _InspectionValues _self;
  final $Res Function(_InspectionValues) _then;

/// Create a copy of InspectionValues
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? queenState = freezed,Object? beeFrames = freezed,Object? broodFrames = freezed,Object? honeyFrames = freezed,Object? temperament = freezed,Object? swarmSigns = freezed,Object? queenCells = freezed,Object? diseaseSuspected = freezed,Object? actions = null,}) {
  return _then(_InspectionValues(
queenState: freezed == queenState ? _self.queenState : queenState // ignore: cast_nullable_to_non_nullable
as QueenState?,beeFrames: freezed == beeFrames ? _self.beeFrames : beeFrames // ignore: cast_nullable_to_non_nullable
as int?,broodFrames: freezed == broodFrames ? _self.broodFrames : broodFrames // ignore: cast_nullable_to_non_nullable
as int?,honeyFrames: freezed == honeyFrames ? _self.honeyFrames : honeyFrames // ignore: cast_nullable_to_non_nullable
as int?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as Temperament?,swarmSigns: freezed == swarmSigns ? _self.swarmSigns : swarmSigns // ignore: cast_nullable_to_non_nullable
as bool?,queenCells: freezed == queenCells ? _self.queenCells : queenCells // ignore: cast_nullable_to_non_nullable
as QueenCells?,diseaseSuspected: freezed == diseaseSuspected ? _self.diseaseSuspected : diseaseSuspected // ignore: cast_nullable_to_non_nullable
as bool?,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as Set<InspectionAction>,
  ));
}


}


/// @nodoc
mixin _$Inspection {

 String get id; String get orgId; String get hiveId;/// Muayenenin yapıldığı arılık; kovan sonra taşınsa da değişmez.
 String get apiaryId; DateTime get inspectedAt; DateTime get createdAt; DateTime get updatedAt; QueenState? get queenState; int? get beeFrames; int? get broodFrames; int? get honeyFrames; Temperament? get temperament; bool? get swarmSigns; QueenCells? get queenCells; bool? get diseaseSuspected;/// Esnek alanlar (`data jsonb`): `actions` ve bekleme süresi geçildiyse
/// `withdrawal_override` (uygulama ve gerekçe). Bu sürümün
/// tanımadığı anahtarlar olduğu gibi korunur.
 Map<String, Object?> get data; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionCopyWith<Inspection> get copyWith => _$InspectionCopyWithImpl<Inspection>(this as Inspection, _$identity);

  /// Serializes this Inspection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Inspection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Inspection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.inspectedAt, _this.inspectedAt) || other.inspectedAt == _this.inspectedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.queenState, _this.queenState) || other.queenState == _this.queenState)&&(identical(other.beeFrames, _this.beeFrames) || other.beeFrames == _this.beeFrames)&&(identical(other.broodFrames, _this.broodFrames) || other.broodFrames == _this.broodFrames)&&(identical(other.honeyFrames, _this.honeyFrames) || other.honeyFrames == _this.honeyFrames)&&(identical(other.temperament, _this.temperament) || other.temperament == _this.temperament)&&(identical(other.swarmSigns, _this.swarmSigns) || other.swarmSigns == _this.swarmSigns)&&(identical(other.queenCells, _this.queenCells) || other.queenCells == _this.queenCells)&&(identical(other.diseaseSuspected, _this.diseaseSuspected) || other.diseaseSuspected == _this.diseaseSuspected)&&const DeepCollectionEquality().equals(other.data, _this.data)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Inspection;
  return Object.hashAll([runtimeType,_this.id,_this.orgId,_this.hiveId,_this.apiaryId,_this.inspectedAt,_this.createdAt,_this.updatedAt,_this.queenState,_this.beeFrames,_this.broodFrames,_this.honeyFrames,_this.temperament,_this.swarmSigns,_this.queenCells,_this.diseaseSuspected,const DeepCollectionEquality().hash(_this.data),_this.createdBy,_this.deletedAt,_this.serverSeq]);
}

@override
String toString() {
  final _this = this as Inspection;
  return 'Inspection(id: ${_this.id}, orgId: ${_this.orgId}, hiveId: ${_this.hiveId}, apiaryId: ${_this.apiaryId}, inspectedAt: ${_this.inspectedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, queenState: ${_this.queenState}, beeFrames: ${_this.beeFrames}, broodFrames: ${_this.broodFrames}, honeyFrames: ${_this.honeyFrames}, temperament: ${_this.temperament}, swarmSigns: ${_this.swarmSigns}, queenCells: ${_this.queenCells}, diseaseSuspected: ${_this.diseaseSuspected}, data: ${_this.data}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $InspectionCopyWith<$Res>  {
  factory $InspectionCopyWith(Inspection value, $Res Function(Inspection) _then) = _$InspectionCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, DateTime inspectedAt, DateTime createdAt, DateTime updatedAt, QueenState? queenState, int? beeFrames, int? broodFrames, int? honeyFrames, Temperament? temperament, bool? swarmSigns, QueenCells? queenCells, bool? diseaseSuspected, Map<String, Object?> data, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$InspectionCopyWithImpl<$Res>
    implements $InspectionCopyWith<$Res> {
  _$InspectionCopyWithImpl(this._self, this._then);

  final Inspection _self;
  final $Res Function(Inspection) _then;

/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? inspectedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? queenState = freezed,Object? beeFrames = freezed,Object? broodFrames = freezed,Object? honeyFrames = freezed,Object? temperament = freezed,Object? swarmSigns = freezed,Object? queenCells = freezed,Object? diseaseSuspected = freezed,Object? data = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(Inspection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,inspectedAt: null == inspectedAt ? _self.inspectedAt : inspectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,queenState: freezed == queenState ? _self.queenState : queenState // ignore: cast_nullable_to_non_nullable
as QueenState?,beeFrames: freezed == beeFrames ? _self.beeFrames : beeFrames // ignore: cast_nullable_to_non_nullable
as int?,broodFrames: freezed == broodFrames ? _self.broodFrames : broodFrames // ignore: cast_nullable_to_non_nullable
as int?,honeyFrames: freezed == honeyFrames ? _self.honeyFrames : honeyFrames // ignore: cast_nullable_to_non_nullable
as int?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as Temperament?,swarmSigns: freezed == swarmSigns ? _self.swarmSigns : swarmSigns // ignore: cast_nullable_to_non_nullable
as bool?,queenCells: freezed == queenCells ? _self.queenCells : queenCells // ignore: cast_nullable_to_non_nullable
as QueenCells?,diseaseSuspected: freezed == diseaseSuspected ? _self.diseaseSuspected : diseaseSuspected // ignore: cast_nullable_to_non_nullable
as bool?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Inspection].
extension InspectionPatterns on Inspection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Inspection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Inspection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Inspection value)  $default,){
final _that = this;
switch (_that) {
case _Inspection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Inspection value)?  $default,){
final _that = this;
switch (_that) {
case _Inspection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime inspectedAt,  DateTime createdAt,  DateTime updatedAt,  QueenState? queenState,  int? beeFrames,  int? broodFrames,  int? honeyFrames,  Temperament? temperament,  bool? swarmSigns,  QueenCells? queenCells,  bool? diseaseSuspected,  Map<String, Object?> data,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Inspection() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.inspectedAt,_that.createdAt,_that.updatedAt,_that.queenState,_that.beeFrames,_that.broodFrames,_that.honeyFrames,_that.temperament,_that.swarmSigns,_that.queenCells,_that.diseaseSuspected,_that.data,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime inspectedAt,  DateTime createdAt,  DateTime updatedAt,  QueenState? queenState,  int? beeFrames,  int? broodFrames,  int? honeyFrames,  Temperament? temperament,  bool? swarmSigns,  QueenCells? queenCells,  bool? diseaseSuspected,  Map<String, Object?> data,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _Inspection():
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.inspectedAt,_that.createdAt,_that.updatedAt,_that.queenState,_that.beeFrames,_that.broodFrames,_that.honeyFrames,_that.temperament,_that.swarmSigns,_that.queenCells,_that.diseaseSuspected,_that.data,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String hiveId,  String apiaryId,  DateTime inspectedAt,  DateTime createdAt,  DateTime updatedAt,  QueenState? queenState,  int? beeFrames,  int? broodFrames,  int? honeyFrames,  Temperament? temperament,  bool? swarmSigns,  QueenCells? queenCells,  bool? diseaseSuspected,  Map<String, Object?> data,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _Inspection() when $default != null:
return $default(_that.id,_that.orgId,_that.hiveId,_that.apiaryId,_that.inspectedAt,_that.createdAt,_that.updatedAt,_that.queenState,_that.beeFrames,_that.broodFrames,_that.honeyFrames,_that.temperament,_that.swarmSigns,_that.queenCells,_that.diseaseSuspected,_that.data,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Inspection implements Inspection {
  const _Inspection({required this.id, required this.orgId, required this.hiveId, required this.apiaryId, required this.inspectedAt, required this.createdAt, required this.updatedAt, this.queenState, this.beeFrames, this.broodFrames, this.honeyFrames, this.temperament, this.swarmSigns, this.queenCells, this.diseaseSuspected,  Map<String, Object?> data = const <String, Object?>{}, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq}): _data = data;
  factory _Inspection.fromJson(Map<String, dynamic> json) => _$InspectionFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String hiveId;
/// Muayenenin yapıldığı arılık; kovan sonra taşınsa da değişmez.
@override final  String apiaryId;
@override final  DateTime inspectedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  QueenState? queenState;
@override final  int? beeFrames;
@override final  int? broodFrames;
@override final  int? honeyFrames;
@override final  Temperament? temperament;
@override final  bool? swarmSigns;
@override final  QueenCells? queenCells;
@override final  bool? diseaseSuspected;
/// Esnek alanlar (`data jsonb`): `actions` ve bekleme süresi geçildiyse
/// `withdrawal_override` (uygulama ve gerekçe). Bu sürümün
/// tanımadığı anahtarlar olduğu gibi korunur.
 final  Map<String, Object?> _data;
/// Esnek alanlar (`data jsonb`): `actions` ve bekleme süresi geçildiyse
/// `withdrawal_override` (uygulama ve gerekçe). Bu sürümün
/// tanımadığı anahtarlar olduğu gibi korunur.
@override@JsonKey() Map<String, Object?> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionCopyWith<_Inspection> get copyWith => __$InspectionCopyWithImpl<_Inspection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InspectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Inspection&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.inspectedAt, inspectedAt) || other.inspectedAt == inspectedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.queenState, queenState) || other.queenState == queenState)&&(identical(other.beeFrames, beeFrames) || other.beeFrames == beeFrames)&&(identical(other.broodFrames, broodFrames) || other.broodFrames == broodFrames)&&(identical(other.honeyFrames, honeyFrames) || other.honeyFrames == honeyFrames)&&(identical(other.temperament, temperament) || other.temperament == temperament)&&(identical(other.swarmSigns, swarmSigns) || other.swarmSigns == swarmSigns)&&(identical(other.queenCells, queenCells) || other.queenCells == queenCells)&&(identical(other.diseaseSuspected, diseaseSuspected) || other.diseaseSuspected == diseaseSuspected)&&const DeepCollectionEquality().equals(other.data, _data)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,orgId,hiveId,apiaryId,inspectedAt,createdAt,updatedAt,queenState,beeFrames,broodFrames,honeyFrames,temperament,swarmSigns,queenCells,diseaseSuspected,const DeepCollectionEquality().hash(_data),createdBy,deletedAt,serverSeq]);
}

@override
String toString() {
    return 'Inspection(id: $id, orgId: $orgId, hiveId: $hiveId, apiaryId: $apiaryId, inspectedAt: $inspectedAt, createdAt: $createdAt, updatedAt: $updatedAt, queenState: $queenState, beeFrames: $beeFrames, broodFrames: $broodFrames, honeyFrames: $honeyFrames, temperament: $temperament, swarmSigns: $swarmSigns, queenCells: $queenCells, diseaseSuspected: $diseaseSuspected, data: $data, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$InspectionCopyWith<$Res> implements $InspectionCopyWith<$Res> {
  factory _$InspectionCopyWith(_Inspection value, $Res Function(_Inspection) _then) = __$InspectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String hiveId, String apiaryId, DateTime inspectedAt, DateTime createdAt, DateTime updatedAt, QueenState? queenState, int? beeFrames, int? broodFrames, int? honeyFrames, Temperament? temperament, bool? swarmSigns, QueenCells? queenCells, bool? diseaseSuspected, Map<String, Object?> data, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$InspectionCopyWithImpl<$Res>
    implements _$InspectionCopyWith<$Res> {
  __$InspectionCopyWithImpl(this._self, this._then);

  final _Inspection _self;
  final $Res Function(_Inspection) _then;

/// Create a copy of Inspection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? hiveId = null,Object? apiaryId = null,Object? inspectedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? queenState = freezed,Object? beeFrames = freezed,Object? broodFrames = freezed,Object? honeyFrames = freezed,Object? temperament = freezed,Object? swarmSigns = freezed,Object? queenCells = freezed,Object? diseaseSuspected = freezed,Object? data = null,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_Inspection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,hiveId: null == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String,apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,inspectedAt: null == inspectedAt ? _self.inspectedAt : inspectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,queenState: freezed == queenState ? _self.queenState : queenState // ignore: cast_nullable_to_non_nullable
as QueenState?,beeFrames: freezed == beeFrames ? _self.beeFrames : beeFrames // ignore: cast_nullable_to_non_nullable
as int?,broodFrames: freezed == broodFrames ? _self.broodFrames : broodFrames // ignore: cast_nullable_to_non_nullable
as int?,honeyFrames: freezed == honeyFrames ? _self.honeyFrames : honeyFrames // ignore: cast_nullable_to_non_nullable
as int?,temperament: freezed == temperament ? _self.temperament : temperament // ignore: cast_nullable_to_non_nullable
as Temperament?,swarmSigns: freezed == swarmSigns ? _self.swarmSigns : swarmSigns // ignore: cast_nullable_to_non_nullable
as bool?,queenCells: freezed == queenCells ? _self.queenCells : queenCells // ignore: cast_nullable_to_non_nullable
as QueenCells?,diseaseSuspected: freezed == diseaseSuspected ? _self.diseaseSuspected : diseaseSuspected // ignore: cast_nullable_to_non_nullable
as bool?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
