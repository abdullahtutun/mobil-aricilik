// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionFormState {

 TransactionKind get kind; DateTime get occurredOn; TransactionCategory? get category;/// Ayrıştırılmış tutar; boş ya da bozuksa null.
 double? get amount; String get description;/// Bu formda çekilen, henüz kaydedilmemiş fiş.
 ReceiptCapture? get receipt; String? get apiaryId; String? get lotId; String? get transportId;/// Lottan satılan bal (kg); yalnız lotlu gelirde.
 double? get saleKg;/// Satışın müşterisi; yalnız gelirde.
 String? get customerId;/// Müşteriden satışta alınan ödeme; boşsa tamamı alacak.
 double? get paidNow; bool get saving;
/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionFormStateCopyWith<TransactionFormState> get copyWith => _$TransactionFormStateCopyWithImpl<TransactionFormState>(this as TransactionFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TransactionFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionFormState&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.occurredOn, _this.occurredOn) || other.occurredOn == _this.occurredOn)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.receipt, _this.receipt) || other.receipt == _this.receipt)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.lotId, _this.lotId) || other.lotId == _this.lotId)&&(identical(other.transportId, _this.transportId) || other.transportId == _this.transportId)&&(identical(other.saleKg, _this.saleKg) || other.saleKg == _this.saleKg)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.paidNow, _this.paidNow) || other.paidNow == _this.paidNow)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as TransactionFormState;
  return Object.hash(runtimeType,_this.kind,_this.occurredOn,_this.category,_this.amount,_this.description,_this.receipt,_this.apiaryId,_this.lotId,_this.transportId,_this.saleKg,_this.customerId,_this.paidNow,_this.saving);
}

@override
String toString() {
  final _this = this as TransactionFormState;
  return 'TransactionFormState(kind: ${_this.kind}, occurredOn: ${_this.occurredOn}, category: ${_this.category}, amount: ${_this.amount}, description: ${_this.description}, receipt: ${_this.receipt}, apiaryId: ${_this.apiaryId}, lotId: ${_this.lotId}, transportId: ${_this.transportId}, saleKg: ${_this.saleKg}, customerId: ${_this.customerId}, paidNow: ${_this.paidNow}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $TransactionFormStateCopyWith<$Res>  {
  factory $TransactionFormStateCopyWith(TransactionFormState value, $Res Function(TransactionFormState) _then) = _$TransactionFormStateCopyWithImpl;
@useResult
$Res call({
 TransactionKind kind, DateTime occurredOn, TransactionCategory? category, double? amount, String description, ReceiptCapture? receipt, String? apiaryId, String? lotId, String? transportId, double? saleKg, String? customerId, double? paidNow, bool saving
});




}
/// @nodoc
class _$TransactionFormStateCopyWithImpl<$Res>
    implements $TransactionFormStateCopyWith<$Res> {
  _$TransactionFormStateCopyWithImpl(this._self, this._then);

  final TransactionFormState _self;
  final $Res Function(TransactionFormState) _then;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? occurredOn = null,Object? category = freezed,Object? amount = freezed,Object? description = null,Object? receipt = freezed,Object? apiaryId = freezed,Object? lotId = freezed,Object? transportId = freezed,Object? saleKg = freezed,Object? customerId = freezed,Object? paidNow = freezed,Object? saving = null,}) {
  return _then(TransactionFormState(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as ReceiptCapture?,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,lotId: freezed == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String?,saleKg: freezed == saleKg ? _self.saleKg : saleKg // ignore: cast_nullable_to_non_nullable
as double?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,paidNow: freezed == paidNow ? _self.paidNow : paidNow // ignore: cast_nullable_to_non_nullable
as double?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionFormState].
extension TransactionFormStatePatterns on TransactionFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionFormState value)  $default,){
final _that = this;
switch (_that) {
case _TransactionFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionFormState value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TransactionKind kind,  DateTime occurredOn,  TransactionCategory? category,  double? amount,  String description,  ReceiptCapture? receipt,  String? apiaryId,  String? lotId,  String? transportId,  double? saleKg,  String? customerId,  double? paidNow,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
return $default(_that.kind,_that.occurredOn,_that.category,_that.amount,_that.description,_that.receipt,_that.apiaryId,_that.lotId,_that.transportId,_that.saleKg,_that.customerId,_that.paidNow,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TransactionKind kind,  DateTime occurredOn,  TransactionCategory? category,  double? amount,  String description,  ReceiptCapture? receipt,  String? apiaryId,  String? lotId,  String? transportId,  double? saleKg,  String? customerId,  double? paidNow,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _TransactionFormState():
return $default(_that.kind,_that.occurredOn,_that.category,_that.amount,_that.description,_that.receipt,_that.apiaryId,_that.lotId,_that.transportId,_that.saleKg,_that.customerId,_that.paidNow,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TransactionKind kind,  DateTime occurredOn,  TransactionCategory? category,  double? amount,  String description,  ReceiptCapture? receipt,  String? apiaryId,  String? lotId,  String? transportId,  double? saleKg,  String? customerId,  double? paidNow,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _TransactionFormState() when $default != null:
return $default(_that.kind,_that.occurredOn,_that.category,_that.amount,_that.description,_that.receipt,_that.apiaryId,_that.lotId,_that.transportId,_that.saleKg,_that.customerId,_that.paidNow,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionFormState implements TransactionFormState {
  const _TransactionFormState({required this.kind, required this.occurredOn, this.category, this.amount, this.description = '', this.receipt, this.apiaryId, this.lotId, this.transportId, this.saleKg, this.customerId, this.paidNow, this.saving = false});
  

@override final  TransactionKind kind;
@override final  DateTime occurredOn;
@override final  TransactionCategory? category;
/// Ayrıştırılmış tutar; boş ya da bozuksa null.
@override final  double? amount;
@override@JsonKey() final  String description;
/// Bu formda çekilen, henüz kaydedilmemiş fiş.
@override final  ReceiptCapture? receipt;
@override final  String? apiaryId;
@override final  String? lotId;
@override final  String? transportId;
/// Lottan satılan bal (kg); yalnız lotlu gelirde.
@override final  double? saleKg;
/// Satışın müşterisi; yalnız gelirde.
@override final  String? customerId;
/// Müşteriden satışta alınan ödeme; boşsa tamamı alacak.
@override final  double? paidNow;
@override@JsonKey() final  bool saving;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionFormStateCopyWith<_TransactionFormState> get copyWith => __$TransactionFormStateCopyWithImpl<_TransactionFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionFormState&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.occurredOn, occurredOn) || other.occurredOn == occurredOn)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.description, description) || other.description == description)&&(identical(other.receipt, receipt) || other.receipt == receipt)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.lotId, lotId) || other.lotId == lotId)&&(identical(other.transportId, transportId) || other.transportId == transportId)&&(identical(other.saleKg, saleKg) || other.saleKg == saleKg)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.paidNow, paidNow) || other.paidNow == paidNow)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kind,occurredOn,category,amount,description,receipt,apiaryId,lotId,transportId,saleKg,customerId,paidNow,saving);
}

@override
String toString() {
    return 'TransactionFormState(kind: $kind, occurredOn: $occurredOn, category: $category, amount: $amount, description: $description, receipt: $receipt, apiaryId: $apiaryId, lotId: $lotId, transportId: $transportId, saleKg: $saleKg, customerId: $customerId, paidNow: $paidNow, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$TransactionFormStateCopyWith<$Res> implements $TransactionFormStateCopyWith<$Res> {
  factory _$TransactionFormStateCopyWith(_TransactionFormState value, $Res Function(_TransactionFormState) _then) = __$TransactionFormStateCopyWithImpl;
@override @useResult
$Res call({
 TransactionKind kind, DateTime occurredOn, TransactionCategory? category, double? amount, String description, ReceiptCapture? receipt, String? apiaryId, String? lotId, String? transportId, double? saleKg, String? customerId, double? paidNow, bool saving
});




}
/// @nodoc
class __$TransactionFormStateCopyWithImpl<$Res>
    implements _$TransactionFormStateCopyWith<$Res> {
  __$TransactionFormStateCopyWithImpl(this._self, this._then);

  final _TransactionFormState _self;
  final $Res Function(_TransactionFormState) _then;

/// Create a copy of TransactionFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? occurredOn = null,Object? category = freezed,Object? amount = freezed,Object? description = null,Object? receipt = freezed,Object? apiaryId = freezed,Object? lotId = freezed,Object? transportId = freezed,Object? saleKg = freezed,Object? customerId = freezed,Object? paidNow = freezed,Object? saving = null,}) {
  return _then(_TransactionFormState(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,occurredOn: null == occurredOn ? _self.occurredOn : occurredOn // ignore: cast_nullable_to_non_nullable
as DateTime,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TransactionCategory?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as ReceiptCapture?,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,lotId: freezed == lotId ? _self.lotId : lotId // ignore: cast_nullable_to_non_nullable
as String?,transportId: freezed == transportId ? _self.transportId : transportId // ignore: cast_nullable_to_non_nullable
as String?,saleKg: freezed == saleKg ? _self.saleKg : saleKg // ignore: cast_nullable_to_non_nullable
as double?,customerId: freezed == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String?,paidNow: freezed == paidNow ? _self.paidNow : paidNow // ignore: cast_nullable_to_non_nullable
as double?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
