// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'harvest_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HarvestFormState {

/// Hasat günü (yerel takvimde gece yarısı); gelecek olamaz.
 DateTime get day;/// Hasada alınacak kovanlar. Bekleme süresindeki kovan ancak
/// [overrides]'ta gerekçesi varsa alınır ([harvestTargets]).
 Set<String> get selected; Map<String, WithdrawalOverride> get overrides;/// Seçilene kadar boş ve Kaydet kapalı.
 HoneyKind? get honeyKind; HarvestUnit get unit; int get unitCount;/// Süzülen bal, kullanıcının yazdığı gibi (kullanıcının biriminde).
 String get weight; bool get saving;
/// Create a copy of HarvestFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HarvestFormStateCopyWith<HarvestFormState> get copyWith => _$HarvestFormStateCopyWithImpl<HarvestFormState>(this as HarvestFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HarvestFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HarvestFormState&&(identical(other.day, _this.day) || other.day == _this.day)&&const DeepCollectionEquality().equals(other.selected, _this.selected)&&const DeepCollectionEquality().equals(other.overrides, _this.overrides)&&(identical(other.honeyKind, _this.honeyKind) || other.honeyKind == _this.honeyKind)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.unitCount, _this.unitCount) || other.unitCount == _this.unitCount)&&(identical(other.weight, _this.weight) || other.weight == _this.weight)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as HarvestFormState;
  return Object.hash(runtimeType,_this.day,const DeepCollectionEquality().hash(_this.selected),const DeepCollectionEquality().hash(_this.overrides),_this.honeyKind,_this.unit,_this.unitCount,_this.weight,_this.saving);
}

@override
String toString() {
  final _this = this as HarvestFormState;
  return 'HarvestFormState(day: ${_this.day}, selected: ${_this.selected}, overrides: ${_this.overrides}, honeyKind: ${_this.honeyKind}, unit: ${_this.unit}, unitCount: ${_this.unitCount}, weight: ${_this.weight}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $HarvestFormStateCopyWith<$Res>  {
  factory $HarvestFormStateCopyWith(HarvestFormState value, $Res Function(HarvestFormState) _then) = _$HarvestFormStateCopyWithImpl;
@useResult
$Res call({
 DateTime day, Set<String> selected, Map<String, WithdrawalOverride> overrides, HoneyKind? honeyKind, HarvestUnit unit, int unitCount, String weight, bool saving
});




}
/// @nodoc
class _$HarvestFormStateCopyWithImpl<$Res>
    implements $HarvestFormStateCopyWith<$Res> {
  _$HarvestFormStateCopyWithImpl(this._self, this._then);

  final HarvestFormState _self;
  final $Res Function(HarvestFormState) _then;

/// Create a copy of HarvestFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? selected = null,Object? overrides = null,Object? honeyKind = freezed,Object? unit = null,Object? unitCount = null,Object? weight = null,Object? saving = null,}) {
  return _then(HarvestFormState(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,overrides: null == overrides ? _self.overrides : overrides // ignore: cast_nullable_to_non_nullable
as Map<String, WithdrawalOverride>,honeyKind: freezed == honeyKind ? _self.honeyKind : honeyKind // ignore: cast_nullable_to_non_nullable
as HoneyKind?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as HarvestUnit,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HarvestFormState].
extension HarvestFormStatePatterns on HarvestFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HarvestFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HarvestFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HarvestFormState value)  $default,){
final _that = this;
switch (_that) {
case _HarvestFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HarvestFormState value)?  $default,){
final _that = this;
switch (_that) {
case _HarvestFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime day,  Set<String> selected,  Map<String, WithdrawalOverride> overrides,  HoneyKind? honeyKind,  HarvestUnit unit,  int unitCount,  String weight,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HarvestFormState() when $default != null:
return $default(_that.day,_that.selected,_that.overrides,_that.honeyKind,_that.unit,_that.unitCount,_that.weight,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime day,  Set<String> selected,  Map<String, WithdrawalOverride> overrides,  HoneyKind? honeyKind,  HarvestUnit unit,  int unitCount,  String weight,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _HarvestFormState():
return $default(_that.day,_that.selected,_that.overrides,_that.honeyKind,_that.unit,_that.unitCount,_that.weight,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime day,  Set<String> selected,  Map<String, WithdrawalOverride> overrides,  HoneyKind? honeyKind,  HarvestUnit unit,  int unitCount,  String weight,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _HarvestFormState() when $default != null:
return $default(_that.day,_that.selected,_that.overrides,_that.honeyKind,_that.unit,_that.unitCount,_that.weight,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _HarvestFormState implements HarvestFormState {
  const _HarvestFormState({required this.day, required  Set<String> selected,  Map<String, WithdrawalOverride> overrides = const <String, WithdrawalOverride>{}, this.honeyKind, this.unit = HarvestUnit.superBox, this.unitCount = 1, this.weight = '', this.saving = false}): _selected = selected,_overrides = overrides;
  

/// Hasat günü (yerel takvimde gece yarısı); gelecek olamaz.
@override final  DateTime day;
/// Hasada alınacak kovanlar. Bekleme süresindeki kovan ancak
/// [overrides]'ta gerekçesi varsa alınır ([harvestTargets]).
 final  Set<String> _selected;
/// Hasada alınacak kovanlar. Bekleme süresindeki kovan ancak
/// [overrides]'ta gerekçesi varsa alınır ([harvestTargets]).
@override Set<String> get selected {
  if (_selected is EqualUnmodifiableSetView) return _selected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selected);
}

 final  Map<String, WithdrawalOverride> _overrides;
@override@JsonKey() Map<String, WithdrawalOverride> get overrides {
  if (_overrides is EqualUnmodifiableMapView) return _overrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_overrides);
}

/// Seçilene kadar boş ve Kaydet kapalı.
@override final  HoneyKind? honeyKind;
@override@JsonKey() final  HarvestUnit unit;
@override@JsonKey() final  int unitCount;
/// Süzülen bal, kullanıcının yazdığı gibi (kullanıcının biriminde).
@override@JsonKey() final  String weight;
@override@JsonKey() final  bool saving;

/// Create a copy of HarvestFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HarvestFormStateCopyWith<_HarvestFormState> get copyWith => __$HarvestFormStateCopyWithImpl<_HarvestFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HarvestFormState&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other.selected, _selected)&&const DeepCollectionEquality().equals(other.overrides, _overrides)&&(identical(other.honeyKind, honeyKind) || other.honeyKind == honeyKind)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,const DeepCollectionEquality().hash(_selected),const DeepCollectionEquality().hash(_overrides),honeyKind,unit,unitCount,weight,saving);
}

@override
String toString() {
    return 'HarvestFormState(day: $day, selected: $selected, overrides: $overrides, honeyKind: $honeyKind, unit: $unit, unitCount: $unitCount, weight: $weight, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$HarvestFormStateCopyWith<$Res> implements $HarvestFormStateCopyWith<$Res> {
  factory _$HarvestFormStateCopyWith(_HarvestFormState value, $Res Function(_HarvestFormState) _then) = __$HarvestFormStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime day, Set<String> selected, Map<String, WithdrawalOverride> overrides, HoneyKind? honeyKind, HarvestUnit unit, int unitCount, String weight, bool saving
});




}
/// @nodoc
class __$HarvestFormStateCopyWithImpl<$Res>
    implements _$HarvestFormStateCopyWith<$Res> {
  __$HarvestFormStateCopyWithImpl(this._self, this._then);

  final _HarvestFormState _self;
  final $Res Function(_HarvestFormState) _then;

/// Create a copy of HarvestFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? selected = null,Object? overrides = null,Object? honeyKind = freezed,Object? unit = null,Object? unitCount = null,Object? weight = null,Object? saving = null,}) {
  return _then(_HarvestFormState(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,overrides: null == overrides ? _self._overrides : overrides // ignore: cast_nullable_to_non_nullable
as Map<String, WithdrawalOverride>,honeyKind: freezed == honeyKind ? _self.honeyKind : honeyKind // ignore: cast_nullable_to_non_nullable
as HoneyKind?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as HarvestUnit,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as String,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
