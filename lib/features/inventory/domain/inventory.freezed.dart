// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryItem {

 String get id; String get orgId; String get name; InventoryCategory get category; InventoryUnit get unit; DateTime get createdAt; DateTime get updatedAt;/// Kalemin durduğu yer ("depo", "kamyonet"); serbest metin.
 String? get place;/// Stok bunun altına düşünce uyarı; boşsa uyarı yok.
 double? get threshold; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryItemCopyWith<InventoryItem> get copyWith => _$InventoryItemCopyWithImpl<InventoryItem>(this as InventoryItem, _$identity);

  /// Serializes this InventoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InventoryItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.unit, _this.unit) || other.unit == _this.unit)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.threshold, _this.threshold) || other.threshold == _this.threshold)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InventoryItem;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.name,_this.category,_this.unit,_this.createdAt,_this.updatedAt,_this.place,_this.threshold,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as InventoryItem;
  return 'InventoryItem(id: ${_this.id}, orgId: ${_this.orgId}, name: ${_this.name}, category: ${_this.category}, unit: ${_this.unit}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, place: ${_this.place}, threshold: ${_this.threshold}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $InventoryItemCopyWith<$Res>  {
  factory $InventoryItemCopyWith(InventoryItem value, $Res Function(InventoryItem) _then) = _$InventoryItemCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String name, InventoryCategory category, InventoryUnit unit, DateTime createdAt, DateTime updatedAt, String? place, double? threshold, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$InventoryItemCopyWithImpl<$Res>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._self, this._then);

  final InventoryItem _self;
  final $Res Function(InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? name = null,Object? category = null,Object? unit = null,Object? createdAt = null,Object? updatedAt = null,Object? place = freezed,Object? threshold = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(InventoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryCategory,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryUnit,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,threshold: freezed == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as double?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryItem].
extension InventoryItemPatterns on InventoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryItem value)  $default,){
final _that = this;
switch (_that) {
case _InventoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String name,  InventoryCategory category,  InventoryUnit unit,  DateTime createdAt,  DateTime updatedAt,  String? place,  double? threshold,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.orgId,_that.name,_that.category,_that.unit,_that.createdAt,_that.updatedAt,_that.place,_that.threshold,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String name,  InventoryCategory category,  InventoryUnit unit,  DateTime createdAt,  DateTime updatedAt,  String? place,  double? threshold,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _InventoryItem():
return $default(_that.id,_that.orgId,_that.name,_that.category,_that.unit,_that.createdAt,_that.updatedAt,_that.place,_that.threshold,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String name,  InventoryCategory category,  InventoryUnit unit,  DateTime createdAt,  DateTime updatedAt,  String? place,  double? threshold,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.orgId,_that.name,_that.category,_that.unit,_that.createdAt,_that.updatedAt,_that.place,_that.threshold,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryItem implements InventoryItem {
  const _InventoryItem({required this.id, required this.orgId, required this.name, required this.category, required this.unit, required this.createdAt, required this.updatedAt, this.place, this.threshold, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String name;
@override final  InventoryCategory category;
@override final  InventoryUnit unit;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Kalemin durduğu yer ("depo", "kamyonet"); serbest metin.
@override final  String? place;
/// Stok bunun altına düşünce uyarı; boşsa uyarı yok.
@override final  double? threshold;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryItemCopyWith<_InventoryItem> get copyWith => __$InventoryItemCopyWithImpl<_InventoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.place, place) || other.place == place)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,name,category,unit,createdAt,updatedAt,place,threshold,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'InventoryItem(id: $id, orgId: $orgId, name: $name, category: $category, unit: $unit, createdAt: $createdAt, updatedAt: $updatedAt, place: $place, threshold: $threshold, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$InventoryItemCopyWith<$Res> implements $InventoryItemCopyWith<$Res> {
  factory _$InventoryItemCopyWith(_InventoryItem value, $Res Function(_InventoryItem) _then) = __$InventoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String name, InventoryCategory category, InventoryUnit unit, DateTime createdAt, DateTime updatedAt, String? place, double? threshold, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$InventoryItemCopyWithImpl<$Res>
    implements _$InventoryItemCopyWith<$Res> {
  __$InventoryItemCopyWithImpl(this._self, this._then);

  final _InventoryItem _self;
  final $Res Function(_InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? name = null,Object? category = null,Object? unit = null,Object? createdAt = null,Object? updatedAt = null,Object? place = freezed,Object? threshold = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_InventoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as InventoryCategory,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as InventoryUnit,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,threshold: freezed == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as double?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$InventoryMove {

 String get id; String get orgId; String get itemId; InventoryMoveKind get kind;/// İşaretli değişim: giriş pozitif, çıkış negatif, düzeltme iki yönde.
 double get quantity; DateTime get movedAt; DateTime get createdAt; DateTime get updatedAt;/// Hareketin bağlı olduğu kaydın tablosu (ör. `feedings`) ve kimliği;
/// ikisi birlikte dolu ya da boş.
 String? get linkedTable; String? get linkedId; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of InventoryMove
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryMoveCopyWith<InventoryMove> get copyWith => _$InventoryMoveCopyWithImpl<InventoryMove>(this as InventoryMove, _$identity);

  /// Serializes this InventoryMove to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InventoryMove;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryMove&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.movedAt, _this.movedAt) || other.movedAt == _this.movedAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.linkedTable, _this.linkedTable) || other.linkedTable == _this.linkedTable)&&(identical(other.linkedId, _this.linkedId) || other.linkedId == _this.linkedId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InventoryMove;
  return Object.hash(runtimeType,_this.id,_this.orgId,_this.itemId,_this.kind,_this.quantity,_this.movedAt,_this.createdAt,_this.updatedAt,_this.linkedTable,_this.linkedId,_this.createdBy,_this.deletedAt,_this.serverSeq);
}

@override
String toString() {
  final _this = this as InventoryMove;
  return 'InventoryMove(id: ${_this.id}, orgId: ${_this.orgId}, itemId: ${_this.itemId}, kind: ${_this.kind}, quantity: ${_this.quantity}, movedAt: ${_this.movedAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, linkedTable: ${_this.linkedTable}, linkedId: ${_this.linkedId}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $InventoryMoveCopyWith<$Res>  {
  factory $InventoryMoveCopyWith(InventoryMove value, $Res Function(InventoryMove) _then) = _$InventoryMoveCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, String itemId, InventoryMoveKind kind, double quantity, DateTime movedAt, DateTime createdAt, DateTime updatedAt, String? linkedTable, String? linkedId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$InventoryMoveCopyWithImpl<$Res>
    implements $InventoryMoveCopyWith<$Res> {
  _$InventoryMoveCopyWithImpl(this._self, this._then);

  final InventoryMove _self;
  final $Res Function(InventoryMove) _then;

/// Create a copy of InventoryMove
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? itemId = null,Object? kind = null,Object? quantity = null,Object? movedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? linkedTable = freezed,Object? linkedId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(InventoryMove(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InventoryMoveKind,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,linkedTable: freezed == linkedTable ? _self.linkedTable : linkedTable // ignore: cast_nullable_to_non_nullable
as String?,linkedId: freezed == linkedId ? _self.linkedId : linkedId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryMove].
extension InventoryMovePatterns on InventoryMove {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryMove value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryMove() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryMove value)  $default,){
final _that = this;
switch (_that) {
case _InventoryMove():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryMove value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryMove() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  String itemId,  InventoryMoveKind kind,  double quantity,  DateTime movedAt,  DateTime createdAt,  DateTime updatedAt,  String? linkedTable,  String? linkedId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryMove() when $default != null:
return $default(_that.id,_that.orgId,_that.itemId,_that.kind,_that.quantity,_that.movedAt,_that.createdAt,_that.updatedAt,_that.linkedTable,_that.linkedId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  String itemId,  InventoryMoveKind kind,  double quantity,  DateTime movedAt,  DateTime createdAt,  DateTime updatedAt,  String? linkedTable,  String? linkedId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _InventoryMove():
return $default(_that.id,_that.orgId,_that.itemId,_that.kind,_that.quantity,_that.movedAt,_that.createdAt,_that.updatedAt,_that.linkedTable,_that.linkedId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  String itemId,  InventoryMoveKind kind,  double quantity,  DateTime movedAt,  DateTime createdAt,  DateTime updatedAt,  String? linkedTable,  String? linkedId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _InventoryMove() when $default != null:
return $default(_that.id,_that.orgId,_that.itemId,_that.kind,_that.quantity,_that.movedAt,_that.createdAt,_that.updatedAt,_that.linkedTable,_that.linkedId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryMove implements InventoryMove {
  const _InventoryMove({required this.id, required this.orgId, required this.itemId, required this.kind, required this.quantity, required this.movedAt, required this.createdAt, required this.updatedAt, this.linkedTable, this.linkedId, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _InventoryMove.fromJson(Map<String, dynamic> json) => _$InventoryMoveFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  String itemId;
@override final  InventoryMoveKind kind;
/// İşaretli değişim: giriş pozitif, çıkış negatif, düzeltme iki yönde.
@override final  double quantity;
@override final  DateTime movedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
/// Hareketin bağlı olduğu kaydın tablosu (ör. `feedings`) ve kimliği;
/// ikisi birlikte dolu ya da boş.
@override final  String? linkedTable;
@override final  String? linkedId;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of InventoryMove
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryMoveCopyWith<_InventoryMove> get copyWith => __$InventoryMoveCopyWithImpl<_InventoryMove>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryMoveToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryMove&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.movedAt, movedAt) || other.movedAt == movedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.linkedTable, linkedTable) || other.linkedTable == linkedTable)&&(identical(other.linkedId, linkedId) || other.linkedId == linkedId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,orgId,itemId,kind,quantity,movedAt,createdAt,updatedAt,linkedTable,linkedId,createdBy,deletedAt,serverSeq);
}

@override
String toString() {
    return 'InventoryMove(id: $id, orgId: $orgId, itemId: $itemId, kind: $kind, quantity: $quantity, movedAt: $movedAt, createdAt: $createdAt, updatedAt: $updatedAt, linkedTable: $linkedTable, linkedId: $linkedId, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$InventoryMoveCopyWith<$Res> implements $InventoryMoveCopyWith<$Res> {
  factory _$InventoryMoveCopyWith(_InventoryMove value, $Res Function(_InventoryMove) _then) = __$InventoryMoveCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, String itemId, InventoryMoveKind kind, double quantity, DateTime movedAt, DateTime createdAt, DateTime updatedAt, String? linkedTable, String? linkedId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$InventoryMoveCopyWithImpl<$Res>
    implements _$InventoryMoveCopyWith<$Res> {
  __$InventoryMoveCopyWithImpl(this._self, this._then);

  final _InventoryMove _self;
  final $Res Function(_InventoryMove) _then;

/// Create a copy of InventoryMove
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? itemId = null,Object? kind = null,Object? quantity = null,Object? movedAt = null,Object? createdAt = null,Object? updatedAt = null,Object? linkedTable = freezed,Object? linkedId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_InventoryMove(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as InventoryMoveKind,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,linkedTable: freezed == linkedTable ? _self.linkedTable : linkedTable // ignore: cast_nullable_to_non_nullable
as String?,linkedId: freezed == linkedId ? _self.linkedId : linkedId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
