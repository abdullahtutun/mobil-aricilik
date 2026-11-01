// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeding_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedingFormState {

 Hive get hive; FeedingScope get scope;/// Seçilene kadar boş ve Kaydet kapalı.
 FeedingKind? get kind;/// Kovan başına, kullanıcının biriminde (şurupta hacim, değilse kütle).
 int get amount;/// Stoktan düşülecek kalem; seçilmediyse türün son kullanılanı.
 StockChoice get stock; bool get saving;
/// Create a copy of FeedingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedingFormStateCopyWith<FeedingFormState> get copyWith => _$FeedingFormStateCopyWithImpl<FeedingFormState>(this as FeedingFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FeedingFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedingFormState&&(identical(other.hive, _this.hive) || other.hive == _this.hive)&&(identical(other.scope, _this.scope) || other.scope == _this.scope)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.stock, _this.stock) || other.stock == _this.stock)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as FeedingFormState;
  return Object.hash(runtimeType,_this.hive,_this.scope,_this.kind,_this.amount,_this.stock,_this.saving);
}

@override
String toString() {
  final _this = this as FeedingFormState;
  return 'FeedingFormState(hive: ${_this.hive}, scope: ${_this.scope}, kind: ${_this.kind}, amount: ${_this.amount}, stock: ${_this.stock}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $FeedingFormStateCopyWith<$Res>  {
  factory $FeedingFormStateCopyWith(FeedingFormState value, $Res Function(FeedingFormState) _then) = _$FeedingFormStateCopyWithImpl;
@useResult
$Res call({
 Hive hive, FeedingScope scope, FeedingKind? kind, int amount, StockChoice stock, bool saving
});


$HiveCopyWith<$Res> get hive;

}
/// @nodoc
class _$FeedingFormStateCopyWithImpl<$Res>
    implements $FeedingFormStateCopyWith<$Res> {
  _$FeedingFormStateCopyWithImpl(this._self, this._then);

  final FeedingFormState _self;
  final $Res Function(FeedingFormState) _then;

/// Create a copy of FeedingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hive = null,Object? scope = null,Object? kind = freezed,Object? amount = null,Object? stock = null,Object? saving = null,}) {
  return _then(FeedingFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as FeedingScope,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FeedingKind?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockChoice,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FeedingFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}
}


/// Adds pattern-matching-related methods to [FeedingFormState].
extension FeedingFormStatePatterns on FeedingFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedingFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedingFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedingFormState value)  $default,){
final _that = this;
switch (_that) {
case _FeedingFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedingFormState value)?  $default,){
final _that = this;
switch (_that) {
case _FeedingFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Hive hive,  FeedingScope scope,  FeedingKind? kind,  int amount,  StockChoice stock,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedingFormState() when $default != null:
return $default(_that.hive,_that.scope,_that.kind,_that.amount,_that.stock,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Hive hive,  FeedingScope scope,  FeedingKind? kind,  int amount,  StockChoice stock,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _FeedingFormState():
return $default(_that.hive,_that.scope,_that.kind,_that.amount,_that.stock,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Hive hive,  FeedingScope scope,  FeedingKind? kind,  int amount,  StockChoice stock,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _FeedingFormState() when $default != null:
return $default(_that.hive,_that.scope,_that.kind,_that.amount,_that.stock,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _FeedingFormState implements FeedingFormState {
  const _FeedingFormState({required this.hive, this.scope = FeedingScope.hive, this.kind, this.amount = 1, this.stock = defaultStockChoice, this.saving = false});
  

@override final  Hive hive;
@override@JsonKey() final  FeedingScope scope;
/// Seçilene kadar boş ve Kaydet kapalı.
@override final  FeedingKind? kind;
/// Kovan başına, kullanıcının biriminde (şurupta hacim, değilse kütle).
@override@JsonKey() final  int amount;
/// Stoktan düşülecek kalem; seçilmediyse türün son kullanılanı.
@override@JsonKey() final  StockChoice stock;
@override@JsonKey() final  bool saving;

/// Create a copy of FeedingFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedingFormStateCopyWith<_FeedingFormState> get copyWith => __$FeedingFormStateCopyWithImpl<_FeedingFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedingFormState&&(identical(other.hive, hive) || other.hive == hive)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.stock, stock) || other.stock == stock)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hive,scope,kind,amount,stock,saving);
}

@override
String toString() {
    return 'FeedingFormState(hive: $hive, scope: $scope, kind: $kind, amount: $amount, stock: $stock, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$FeedingFormStateCopyWith<$Res> implements $FeedingFormStateCopyWith<$Res> {
  factory _$FeedingFormStateCopyWith(_FeedingFormState value, $Res Function(_FeedingFormState) _then) = __$FeedingFormStateCopyWithImpl;
@override @useResult
$Res call({
 Hive hive, FeedingScope scope, FeedingKind? kind, int amount, StockChoice stock, bool saving
});


@override $HiveCopyWith<$Res> get hive;

}
/// @nodoc
class __$FeedingFormStateCopyWithImpl<$Res>
    implements _$FeedingFormStateCopyWith<$Res> {
  __$FeedingFormStateCopyWithImpl(this._self, this._then);

  final _FeedingFormState _self;
  final $Res Function(_FeedingFormState) _then;

/// Create a copy of FeedingFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hive = null,Object? scope = null,Object? kind = freezed,Object? amount = null,Object? stock = null,Object? saving = null,}) {
  return _then(_FeedingFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as FeedingScope,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as FeedingKind?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,stock: null == stock ? _self.stock : stock // ignore: cast_nullable_to_non_nullable
as StockChoice,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FeedingFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}
}

// dart format on
