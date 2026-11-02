// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinanceTransaction {

 String get id; String get orgId; TransactionKind get kind; TransactionCategory get category;/// Pozitif tutar, en çok iki ondalık.
 double get amount;/// ISO 4217 kodu.
 String get currency;@DateOnlyJsonConverter() DateTime get occurredOn; DateTime get createdAt; DateTime get updatedAt; String? get description;/// `receipts` bucket'ındaki yol (`receiptStoragePath`); fiş yoksa boş.
 String? get receiptPath; String? get apiaryId; String? get lotId; String? get transportId;/// Lottan satışta düşülen kilogramın kaydı.
 String? get lotSaleId;/// Satışın müşterisi; yalnız gelirde. Alacak bu satışa alınan
/// tahsilatlarla kapanır.
 String? get customerId; String? get createdBy; DateTime? get deletedAt;@JsonKey(includeToJson: false) int? get serverSeq;
/// Create a copy of FinanceTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinanceTransactionCopyWith<FinanceTransaction> get copyWith => _$FinanceTransactionCopyWithImpl<FinanceTransaction>(this as FinanceTransaction, _$identity);

  /// Serializes this FinanceTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FinanceTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinanceTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.orgId, _this.orgId) || other.orgId == _this.orgId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.occurredOn, _this.occurredOn) || other.occurredOn == _this.occurredOn)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.receiptPath, _this.receiptPath) || other.receiptPath == _this.receiptPath)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.lotId, _this.lotId) || other.lotId == _this.lotId)&&(identical(other.transportId, _this.transportId) || other.transportId == _this.transportId)&&(identical(other.lotSaleId, _this.lotSaleId) || other.lotSaleId == _this.lotSaleId)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.serverSeq, _this.serverSeq) || other.serverSeq == _this.serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FinanceTransaction;
  return Object.hashAll([runtimeType,_this.id,_this.orgId,_this.kind,_this.category,_this.amount,_this.currency,_this.occurredOn,_this.createdAt,_this.updatedAt,_this.description,_this.receiptPath,_this.apiaryId,_this.lotId,_this.transportId,_this.lotSaleId,_this.customerId,_this.createdBy,_this.deletedAt,_this.serverSeq]);
}

@override
String toString() {
  final _this = this as FinanceTransaction;
  return 'FinanceTransaction(id: ${_this.id}, orgId: ${_this.orgId}, kind: ${_this.kind}, category: ${_this.category}, amount: ${_this.amount}, currency: ${_this.currency}, occurredOn: ${_this.occurredOn}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, description: ${_this.description}, receiptPath: ${_this.receiptPath}, apiaryId: ${_this.apiaryId}, lotId: ${_this.lotId}, transportId: ${_this.transportId}, lotSaleId: ${_this.lotSaleId}, customerId: ${_this.customerId}, createdBy: ${_this.createdBy}, deletedAt: ${_this.deletedAt}, serverSeq: ${_this.serverSeq})';
}


}

/// @nodoc
abstract mixin class $FinanceTransactionCopyWith<$Res>  {
  factory $FinanceTransactionCopyWith(FinanceTransaction value, $Res Function(FinanceTransaction) _then) = _$FinanceTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String orgId, TransactionKind kind, TransactionCategory category, double amount, String currency,@DateOnlyJsonConverter() DateTime occurredOn, DateTime createdAt, DateTime updatedAt, String? description, String? receiptPath, String? apiaryId, String? lotId, String? transportId, String? lotSaleId, String? customerId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class _$FinanceTransactionCopyWithImpl<$Res>
    implements $FinanceTransactionCopyWith<$Res> {
  _$FinanceTransactionCopyWithImpl(this._self, this._then);

  final FinanceTransaction _self;
  final $Res Function(FinanceTransaction) _then;

/// Create a copy of FinanceTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? orgId = null,Object? kind = null,Object? category = null,Object? amount = null,Object? currency = null,Object? occurredOn = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? receiptPath = freezed,Object? apiaryId = freezed,Object? lotId = freezed,Object? transportId = freezed,Object? lotSaleId = freezed,Object? customerId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(FinanceTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptPath: freezed == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String?,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,lotId: freezed == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String?,lotSaleId: freezed == lotSaleId ? _self.lotSaleId : lotSaleId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinanceTransaction].
extension FinanceTransactionPatterns on FinanceTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinanceTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinanceTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinanceTransaction value)  $default,){
final _that = this;
switch (_that) {
case _FinanceTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinanceTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _FinanceTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String orgId,  TransactionKind kind,  TransactionCategory category,  double amount,  String currency, @DateOnlyJsonConverter()  DateTime occurredOn,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? receiptPath,  String? apiaryId,  String? lotId,  String? transportId,  String? lotSaleId,  String? customerId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinanceTransaction() when $default != null:
return $default(_that.id,_that.orgId,_that.kind,_that.category,_that.amount,_that.currency,_that.occurredOn,_that.createdAt,_that.updatedAt,_that.description,_that.receiptPath,_that.apiaryId,_that.lotId,_that.transportId,_that.lotSaleId,_that.customerId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String orgId,  TransactionKind kind,  TransactionCategory category,  double amount,  String currency, @DateOnlyJsonConverter()  DateTime occurredOn,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? receiptPath,  String? apiaryId,  String? lotId,  String? transportId,  String? lotSaleId,  String? customerId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)  $default,) {final _that = this;
switch (_that) {
case _FinanceTransaction():
return $default(_that.id,_that.orgId,_that.kind,_that.category,_that.amount,_that.currency,_that.occurredOn,_that.createdAt,_that.updatedAt,_that.description,_that.receiptPath,_that.apiaryId,_that.lotId,_that.transportId,_that.lotSaleId,_that.customerId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String orgId,  TransactionKind kind,  TransactionCategory category,  double amount,  String currency, @DateOnlyJsonConverter()  DateTime occurredOn,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? receiptPath,  String? apiaryId,  String? lotId,  String? transportId,  String? lotSaleId,  String? customerId,  String? createdBy,  DateTime? deletedAt, @JsonKey(includeToJson: false)  int? serverSeq)?  $default,) {final _that = this;
switch (_that) {
case _FinanceTransaction() when $default != null:
return $default(_that.id,_that.orgId,_that.kind,_that.category,_that.amount,_that.currency,_that.occurredOn,_that.createdAt,_that.updatedAt,_that.description,_that.receiptPath,_that.apiaryId,_that.lotId,_that.transportId,_that.lotSaleId,_that.customerId,_that.createdBy,_that.deletedAt,_that.serverSeq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinanceTransaction implements FinanceTransaction {
  const _FinanceTransaction({required this.id, required this.orgId, required this.kind, required this.category, required this.amount, required this.currency, @DateOnlyJsonConverter() required this.occurredOn, required this.createdAt, required this.updatedAt, this.description, this.receiptPath, this.apiaryId, this.lotId, this.transportId, this.lotSaleId, this.customerId, this.createdBy, this.deletedAt, @JsonKey(includeToJson: false) this.serverSeq});
  factory _FinanceTransaction.fromJson(Map<String, dynamic> json) => _$FinanceTransactionFromJson(json);

@override final  String id;
@override final  String orgId;
@override final  TransactionKind kind;
@override final  TransactionCategory category;
/// Pozitif tutar, en çok iki ondalık.
@override final  double amount;
/// ISO 4217 kodu.
@override final  String currency;
@override@DateOnlyJsonConverter() final  DateTime occurredOn;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
/// `receipts` bucket'ındaki yol (`receiptStoragePath`); fiş yoksa boş.
@override final  String? receiptPath;
@override final  String? apiaryId;
@override final  String? lotId;
@override final  String? transportId;
/// Lottan satışta düşülen kilogramın kaydı.
@override final  String? lotSaleId;
/// Satışın müşterisi; yalnız gelirde. Alacak bu satışa alınan
/// tahsilatlarla kapanır.
@override final  String? customerId;
@override final  String? createdBy;
@override final  DateTime? deletedAt;
@override@JsonKey(includeToJson: false) final  int? serverSeq;

/// Create a copy of FinanceTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinanceTransactionCopyWith<_FinanceTransaction> get copyWith => __$FinanceTransactionCopyWithImpl<_FinanceTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinanceTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinanceTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.orgId, orgId) || other.orgId == orgId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.receiptPath, receiptPath) || other.receiptPath == receiptPath)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.transportId, transportId) || other.transportId == transportId)&&(identical(other.lotSaleId, lotSaleId) || other.lotSaleId == lotSaleId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.serverSeq, serverSeq) || other.serverSeq == serverSeq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,orgId,kind,category,amount,currency,occurredOn,createdAt,updatedAt,description,receiptPath,apiaryId,lotId,transportId,lotSaleId,customerId,createdBy,deletedAt,serverSeq]);
}

@override
String toString() {
    return 'FinanceTransaction(id: $id, orgId: $orgId, kind: $kind, category: $category, amount: $amount, currency: $currency, occurredOn: $occurredOn, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, receiptPath: $receiptPath, apiaryId: $apiaryId, lotId: $lotId, transportId: $transportId, lotSaleId: $lotSaleId, customerId: $customerId, createdBy: $createdBy, deletedAt: $deletedAt, serverSeq: $serverSeq)';
}


}

/// @nodoc
abstract mixin class _$FinanceTransactionCopyWith<$Res> implements $FinanceTransactionCopyWith<$Res> {
  factory _$FinanceTransactionCopyWith(_FinanceTransaction value, $Res Function(_FinanceTransaction) _then) = __$FinanceTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String orgId, TransactionKind kind, TransactionCategory category, double amount, String currency,@DateOnlyJsonConverter() DateTime occurredOn, DateTime createdAt, DateTime updatedAt, String? description, String? receiptPath, String? apiaryId, String? lotId, String? transportId, String? lotSaleId, String? customerId, String? createdBy, DateTime? deletedAt,@JsonKey(includeToJson: false) int? serverSeq
});




}
/// @nodoc
class __$FinanceTransactionCopyWithImpl<$Res>
    implements _$FinanceTransactionCopyWith<$Res> {
  __$FinanceTransactionCopyWithImpl(this._self, this._then);

  final _FinanceTransaction _self;
  final $Res Function(_FinanceTransaction) _then;

/// Create a copy of FinanceTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? orgId = null,Object? kind = null,Object? category = null,Object? amount = null,Object? currency = null,Object? occurredOn = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? receiptPath = freezed,Object? apiaryId = freezed,Object? lotId = freezed,Object? transportId = freezed,Object? lotSaleId = freezed,Object? customerId = freezed,Object? createdBy = freezed,Object? deletedAt = freezed,Object? serverSeq = freezed,}) {
  return _then(_FinanceTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,orgId: null == orgId ? _self.orgId : orgId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,receiptPath: freezed == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String?,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,lotId: freezed == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String?,lotSaleId: freezed == lotSaleId ? _self.lotSaleId : lotSaleId // ignore: cast_nullable_to_non_nullable
as String?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,serverSeq: freezed == serverSeq ? _self.serverSeq : serverSeq // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
