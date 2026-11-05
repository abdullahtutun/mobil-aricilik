// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportData {

 List<Apiary> get apiaries; List<Hive> get hives; List<Queen> get queens; List<Inspection> get inspections; List<Feeding> get feedings; List<Treatment> get treatments; List<MiteCount> get miteCounts; List<Harvest> get harvests;/// Hasat kimliği → hasada katılan kovan sayısı.
 Map<String, int> get harvestHiveCounts; List<Task> get tasks; List<InventoryStock> get inventory;/// Finansı görme yetkisi yoksa null; sayfa hiç yazılmaz.
 List<FinanceTransaction>? get transactions;
/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportDataCopyWith<ExportData> get copyWith => _$ExportDataCopyWithImpl<ExportData>(this as ExportData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExportData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportData&&const DeepCollectionEquality().equals(other.apiaries, _this.apiaries)&&const DeepCollectionEquality().equals(other.hives, _this.hives)&&const DeepCollectionEquality().equals(other.queens, _this.queens)&&const DeepCollectionEquality().equals(other.inspections, _this.inspections)&&const DeepCollectionEquality().equals(other.feedings, _this.feedings)&&const DeepCollectionEquality().equals(other.treatments, _this.treatments)&&const DeepCollectionEquality().equals(other.miteCounts, _this.miteCounts)&&const DeepCollectionEquality().equals(other.harvests, _this.harvests)&&const DeepCollectionEquality().equals(other.harvestHiveCounts, _this.harvestHiveCounts)&&const DeepCollectionEquality().equals(other.tasks, _this.tasks)&&const DeepCollectionEquality().equals(other.inventory, _this.inventory)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions));
}


@override
int get hashCode {
  final _this = this as ExportData;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.apiaries),const DeepCollectionEquality().hash(_this.hives),const DeepCollectionEquality().hash(_this.queens),const DeepCollectionEquality().hash(_this.inspections),const DeepCollectionEquality().hash(_this.feedings),const DeepCollectionEquality().hash(_this.treatments),const DeepCollectionEquality().hash(_this.miteCounts),const DeepCollectionEquality().hash(_this.harvests),const DeepCollectionEquality().hash(_this.harvestHiveCounts),const DeepCollectionEquality().hash(_this.tasks),const DeepCollectionEquality().hash(_this.inventory),const DeepCollectionEquality().hash(_this.transactions));
}

@override
String toString() {
  final _this = this as ExportData;
  return 'ExportData(apiaries: ${_this.apiaries}, hives: ${_this.hives}, queens: ${_this.queens}, inspections: ${_this.inspections}, feedings: ${_this.feedings}, treatments: ${_this.treatments}, miteCounts: ${_this.miteCounts}, harvests: ${_this.harvests}, harvestHiveCounts: ${_this.harvestHiveCounts}, tasks: ${_this.tasks}, inventory: ${_this.inventory}, transactions: ${_this.transactions})';
}


}

/// @nodoc
abstract mixin class $ExportDataCopyWith<$Res>  {
  factory $ExportDataCopyWith(ExportData value, $Res Function(ExportData) _then) = _$ExportDataCopyWithImpl;
@useResult
$Res call({
 List<Apiary> apiaries, List<Hive> hives, List<Queen> queens, List<Inspection> inspections, List<Feeding> feedings, List<Treatment> treatments, List<MiteCount> miteCounts, List<Harvest> harvests, Map<String, int> harvestHiveCounts, List<Task> tasks, List<InventoryStock> inventory, List<FinanceTransaction>? transactions
});




}
/// @nodoc
class _$ExportDataCopyWithImpl<$Res>
    implements $ExportDataCopyWith<$Res> {
  _$ExportDataCopyWithImpl(this._self, this._then);

  final ExportData _self;
  final $Res Function(ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiaries = null,Object? hives = null,Object? queens = null,Object? inspections = null,Object? feedings = null,Object? treatments = null,Object? miteCounts = null,Object? harvests = null,Object? harvestHiveCounts = null,Object? tasks = null,Object? inventory = null,Object? transactions = freezed,}) {
  return _then(ExportData(
apiaries: null == apiaries ? _self.apiaries : apiaries // ignore: cast_nullable_to_non_nullable
as List<Apiary>,hives: null == hives ? _self.hives : hives // ignore: cast_nullable_to_non_nullable
as List<Hive>,queens: null == queens ? _self.queens : queens // ignore: cast_nullable_to_non_nullable
as List<Queen>,inspections: null == inspections ? _self.inspections : inspections // ignore: cast_nullable_to_non_nullable
as List<Inspection>,feedings: null == feedings ? _self.feedings : feedings // ignore: cast_nullable_to_non_nullable
as List<Feeding>,treatments: null == treatments ? _self.treatments : treatments // ignore: cast_nullable_to_non_nullable
as List<Treatment>,miteCounts: null == miteCounts ? _self.miteCounts : miteCounts // ignore: cast_nullable_to_non_nullable
as List<MiteCount>,harvests: null == harvests ? _self.harvests : harvests // ignore: cast_nullable_to_non_nullable
as List<Harvest>,harvestHiveCounts: null == harvestHiveCounts ? _self.harvestHiveCounts : harvestHiveCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as List<InventoryStock>,transactions: freezed == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<FinanceTransaction>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportData].
extension ExportDataPatterns on ExportData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportData value)  $default,){
final _that = this;
switch (_that) {
case _ExportData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportData value)?  $default,){
final _that = this;
switch (_that) {
case _ExportData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Apiary> apiaries,  List<Hive> hives,  List<Queen> queens,  List<Inspection> inspections,  List<Feeding> feedings,  List<Treatment> treatments,  List<MiteCount> miteCounts,  List<Harvest> harvests,  Map<String, int> harvestHiveCounts,  List<Task> tasks,  List<InventoryStock> inventory,  List<FinanceTransaction>? transactions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.apiaries,_that.hives,_that.queens,_that.inspections,_that.feedings,_that.treatments,_that.miteCounts,_that.harvests,_that.harvestHiveCounts,_that.tasks,_that.inventory,_that.transactions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Apiary> apiaries,  List<Hive> hives,  List<Queen> queens,  List<Inspection> inspections,  List<Feeding> feedings,  List<Treatment> treatments,  List<MiteCount> miteCounts,  List<Harvest> harvests,  Map<String, int> harvestHiveCounts,  List<Task> tasks,  List<InventoryStock> inventory,  List<FinanceTransaction>? transactions)  $default,) {final _that = this;
switch (_that) {
case _ExportData():
return $default(_that.apiaries,_that.hives,_that.queens,_that.inspections,_that.feedings,_that.treatments,_that.miteCounts,_that.harvests,_that.harvestHiveCounts,_that.tasks,_that.inventory,_that.transactions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Apiary> apiaries,  List<Hive> hives,  List<Queen> queens,  List<Inspection> inspections,  List<Feeding> feedings,  List<Treatment> treatments,  List<MiteCount> miteCounts,  List<Harvest> harvests,  Map<String, int> harvestHiveCounts,  List<Task> tasks,  List<InventoryStock> inventory,  List<FinanceTransaction>? transactions)?  $default,) {final _that = this;
switch (_that) {
case _ExportData() when $default != null:
return $default(_that.apiaries,_that.hives,_that.queens,_that.inspections,_that.feedings,_that.treatments,_that.miteCounts,_that.harvests,_that.harvestHiveCounts,_that.tasks,_that.inventory,_that.transactions);case _:
  return null;

}
}

}

/// @nodoc


class _ExportData implements ExportData {
  const _ExportData({required  List<Apiary> apiaries, required  List<Hive> hives, required  List<Queen> queens, required  List<Inspection> inspections, required  List<Feeding> feedings, required  List<Treatment> treatments, required  List<MiteCount> miteCounts, required  List<Harvest> harvests, required  Map<String, int> harvestHiveCounts, required  List<Task> tasks, required  List<InventoryStock> inventory,  List<FinanceTransaction>? transactions}): _apiaries = apiaries,_hives = hives,_queens = queens,_inspections = inspections,_feedings = feedings,_treatments = treatments,_miteCounts = miteCounts,_harvests = harvests,_harvestHiveCounts = harvestHiveCounts,_tasks = tasks,_inventory = inventory,_transactions = transactions;
  

 final  List<Apiary> _apiaries;
@override List<Apiary> get apiaries {
  if (_apiaries is EqualUnmodifiableListView) return _apiaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_apiaries);
}

 final  List<Hive> _hives;
@override List<Hive> get hives {
  if (_hives is EqualUnmodifiableListView) return _hives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hives);
}

 final  List<Queen> _queens;
@override List<Queen> get queens {
  if (_queens is EqualUnmodifiableListView) return _queens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queens);
}

 final  List<Inspection> _inspections;
@override List<Inspection> get inspections {
  if (_inspections is EqualUnmodifiableListView) return _inspections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inspections);
}

 final  List<Feeding> _feedings;
@override List<Feeding> get feedings {
  if (_feedings is EqualUnmodifiableListView) return _feedings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feedings);
}

 final  List<Treatment> _treatments;
@override List<Treatment> get treatments {
  if (_treatments is EqualUnmodifiableListView) return _treatments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_treatments);
}

 final  List<MiteCount> _miteCounts;
@override List<MiteCount> get miteCounts {
  if (_miteCounts is EqualUnmodifiableListView) return _miteCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_miteCounts);
}

 final  List<Harvest> _harvests;
@override List<Harvest> get harvests {
  if (_harvests is EqualUnmodifiableListView) return _harvests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_harvests);
}

/// Hasat kimliği → hasada katılan kovan sayısı.
 final  Map<String, int> _harvestHiveCounts;
/// Hasat kimliği → hasada katılan kovan sayısı.
@override Map<String, int> get harvestHiveCounts {
  if (_harvestHiveCounts is EqualUnmodifiableMapView) return _harvestHiveCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_harvestHiveCounts);
}

 final  List<Task> _tasks;
@override List<Task> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

 final  List<InventoryStock> _inventory;
@override List<InventoryStock> get inventory {
  if (_inventory is EqualUnmodifiableListView) return _inventory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inventory);
}

/// Finansı görme yetkisi yoksa null; sayfa hiç yazılmaz.
 final  List<FinanceTransaction>? _transactions;
/// Finansı görme yetkisi yoksa null; sayfa hiç yazılmaz.
@override List<FinanceTransaction>? get transactions {
  final value = _transactions;
  if (value == null) return null;
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportDataCopyWith<_ExportData> get copyWith => __$ExportDataCopyWithImpl<_ExportData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportData&&const DeepCollectionEquality().equals(other.apiaries, _apiaries)&&const DeepCollectionEquality().equals(other.hives, _hives)&&const DeepCollectionEquality().equals(other.queens, _queens)&&const DeepCollectionEquality().equals(other.inspections, _inspections)&&const DeepCollectionEquality().equals(other.feedings, _feedings)&&const DeepCollectionEquality().equals(other.treatments, _treatments)&&const DeepCollectionEquality().equals(other.miteCounts, _miteCounts)&&const DeepCollectionEquality().equals(other.harvests, _harvests)&&const DeepCollectionEquality().equals(other.harvestHiveCounts, _harvestHiveCounts)&&const DeepCollectionEquality().equals(other.tasks, _tasks)&&const DeepCollectionEquality().equals(other.inventory, _inventory)&&const DeepCollectionEquality().equals(other.transactions, _transactions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_apiaries),const DeepCollectionEquality().hash(_hives),const DeepCollectionEquality().hash(_queens),const DeepCollectionEquality().hash(_inspections),const DeepCollectionEquality().hash(_feedings),const DeepCollectionEquality().hash(_treatments),const DeepCollectionEquality().hash(_miteCounts),const DeepCollectionEquality().hash(_harvests),const DeepCollectionEquality().hash(_harvestHiveCounts),const DeepCollectionEquality().hash(_tasks),const DeepCollectionEquality().hash(_inventory),const DeepCollectionEquality().hash(_transactions));
}

@override
String toString() {
    return 'ExportData(apiaries: $apiaries, hives: $hives, queens: $queens, inspections: $inspections, feedings: $feedings, treatments: $treatments, miteCounts: $miteCounts, harvests: $harvests, harvestHiveCounts: $harvestHiveCounts, tasks: $tasks, inventory: $inventory, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$ExportDataCopyWith<$Res> implements $ExportDataCopyWith<$Res> {
  factory _$ExportDataCopyWith(_ExportData value, $Res Function(_ExportData) _then) = __$ExportDataCopyWithImpl;
@override @useResult
$Res call({
 List<Apiary> apiaries, List<Hive> hives, List<Queen> queens, List<Inspection> inspections, List<Feeding> feedings, List<Treatment> treatments, List<MiteCount> miteCounts, List<Harvest> harvests, Map<String, int> harvestHiveCounts, List<Task> tasks, List<InventoryStock> inventory, List<FinanceTransaction>? transactions
});




}
/// @nodoc
class __$ExportDataCopyWithImpl<$Res>
    implements _$ExportDataCopyWith<$Res> {
  __$ExportDataCopyWithImpl(this._self, this._then);

  final _ExportData _self;
  final $Res Function(_ExportData) _then;

/// Create a copy of ExportData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiaries = null,Object? hives = null,Object? queens = null,Object? inspections = null,Object? feedings = null,Object? treatments = null,Object? miteCounts = null,Object? harvests = null,Object? harvestHiveCounts = null,Object? tasks = null,Object? inventory = null,Object? transactions = freezed,}) {
  return _then(_ExportData(
apiaries: null == apiaries ? _self._apiaries : apiaries // ignore: cast_nullable_to_non_nullable
as List<Apiary>,hives: null == hives ? _self._hives : hives // ignore: cast_nullable_to_non_nullable
as List<Hive>,queens: null == queens ? _self._queens : queens // ignore: cast_nullable_to_non_nullable
as List<Queen>,inspections: null == inspections ? _self._inspections : inspections // ignore: cast_nullable_to_non_nullable
as List<Inspection>,feedings: null == feedings ? _self._feedings : feedings // ignore: cast_nullable_to_non_nullable
as List<Feeding>,treatments: null == treatments ? _self._treatments : treatments // ignore: cast_nullable_to_non_nullable
as List<Treatment>,miteCounts: null == miteCounts ? _self._miteCounts : miteCounts // ignore: cast_nullable_to_non_nullable
as List<MiteCount>,harvests: null == harvests ? _self._harvests : harvests // ignore: cast_nullable_to_non_nullable
as List<Harvest>,harvestHiveCounts: null == harvestHiveCounts ? _self._harvestHiveCounts : harvestHiveCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,inventory: null == inventory ? _self._inventory : inventory // ignore: cast_nullable_to_non_nullable
as List<InventoryStock>,transactions: freezed == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<FinanceTransaction>?,
  ));
}


}

// dart format on
