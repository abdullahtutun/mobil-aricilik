// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apiary_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiarySummary {

 Apiary get apiary;/// Arılıktaki aktif kovanlar; sönen, birleşen, satılan ve kaybolan
/// kovanlar sayılmaz.
 int get activeHiveCount;/// Son ziyaret. Muayene kayıtları gelene kadar hep boş.
 DateTime? get lastVisitAt;
/// Create a copy of ApiarySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiarySummaryCopyWith<ApiarySummary> get copyWith => _$ApiarySummaryCopyWithImpl<ApiarySummary>(this as ApiarySummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ApiarySummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiarySummary&&(identical(other.apiary, _this.apiary) || other.apiary == _this.apiary)&&(identical(other.activeHiveCount, _this.activeHiveCount) || other.activeHiveCount == _this.activeHiveCount)&&(identical(other.lastVisitAt, _this.lastVisitAt) || other.lastVisitAt == _this.lastVisitAt));
}


@override
int get hashCode {
  final _this = this as ApiarySummary;
  return Object.hash(runtimeType,_this.apiary,_this.activeHiveCount,_this.lastVisitAt);
}

@override
String toString() {
  final _this = this as ApiarySummary;
  return 'ApiarySummary(apiary: ${_this.apiary}, activeHiveCount: ${_this.activeHiveCount}, lastVisitAt: ${_this.lastVisitAt})';
}


}

/// @nodoc
abstract mixin class $ApiarySummaryCopyWith<$Res>  {
  factory $ApiarySummaryCopyWith(ApiarySummary value, $Res Function(ApiarySummary) _then) = _$ApiarySummaryCopyWithImpl;
@useResult
$Res call({
 Apiary apiary, int activeHiveCount, DateTime? lastVisitAt
});


$ApiaryCopyWith<$Res> get apiary;

}
/// @nodoc
class _$ApiarySummaryCopyWithImpl<$Res>
    implements $ApiarySummaryCopyWith<$Res> {
  _$ApiarySummaryCopyWithImpl(this._self, this._then);

  final ApiarySummary _self;
  final $Res Function(ApiarySummary) _then;

/// Create a copy of ApiarySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiary = null,Object? activeHiveCount = null,Object? lastVisitAt = freezed,}) {
  return _then(ApiarySummary(
apiary: null == apiary ? _self.apiary : apiary // ignore: cast_nullable_to_non_nullable
as Apiary,activeHiveCount: null == activeHiveCount ? _self.activeHiveCount : activeHiveCount // ignore: cast_nullable_to_non_nullable
as int,lastVisitAt: freezed == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ApiarySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiaryCopyWith<$Res> get apiary {
  
  return $ApiaryCopyWith<$Res>(_self.apiary, (value) {
    return _then(_self.copyWith(apiary: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiarySummary].
extension ApiarySummaryPatterns on ApiarySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiarySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiarySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiarySummary value)  $default,){
final _that = this;
switch (_that) {
case _ApiarySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiarySummary value)?  $default,){
final _that = this;
switch (_that) {
case _ApiarySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Apiary apiary,  int activeHiveCount,  DateTime? lastVisitAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiarySummary() when $default != null:
return $default(_that.apiary,_that.activeHiveCount,_that.lastVisitAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Apiary apiary,  int activeHiveCount,  DateTime? lastVisitAt)  $default,) {final _that = this;
switch (_that) {
case _ApiarySummary():
return $default(_that.apiary,_that.activeHiveCount,_that.lastVisitAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Apiary apiary,  int activeHiveCount,  DateTime? lastVisitAt)?  $default,) {final _that = this;
switch (_that) {
case _ApiarySummary() when $default != null:
return $default(_that.apiary,_that.activeHiveCount,_that.lastVisitAt);case _:
  return null;

}
}

}

/// @nodoc


class _ApiarySummary implements ApiarySummary {
  const _ApiarySummary({required this.apiary, required this.activeHiveCount, this.lastVisitAt});
  

@override final  Apiary apiary;
/// Arılıktaki aktif kovanlar; sönen, birleşen, satılan ve kaybolan
/// kovanlar sayılmaz.
@override final  int activeHiveCount;
/// Son ziyaret. Muayene kayıtları gelene kadar hep boş.
@override final  DateTime? lastVisitAt;

/// Create a copy of ApiarySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiarySummaryCopyWith<_ApiarySummary> get copyWith => __$ApiarySummaryCopyWithImpl<_ApiarySummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiarySummary&&(identical(other.apiary, apiary) || other.apiary == apiary)&&(identical(other.activeHiveCount, activeHiveCount) || other.activeHiveCount == activeHiveCount)&&(identical(other.lastVisitAt, lastVisitAt) || other.lastVisitAt == lastVisitAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,apiary,activeHiveCount,lastVisitAt);
}

@override
String toString() {
    return 'ApiarySummary(apiary: $apiary, activeHiveCount: $activeHiveCount, lastVisitAt: $lastVisitAt)';
}


}

/// @nodoc
abstract mixin class _$ApiarySummaryCopyWith<$Res> implements $ApiarySummaryCopyWith<$Res> {
  factory _$ApiarySummaryCopyWith(_ApiarySummary value, $Res Function(_ApiarySummary) _then) = __$ApiarySummaryCopyWithImpl;
@override @useResult
$Res call({
 Apiary apiary, int activeHiveCount, DateTime? lastVisitAt
});


@override $ApiaryCopyWith<$Res> get apiary;

}
/// @nodoc
class __$ApiarySummaryCopyWithImpl<$Res>
    implements _$ApiarySummaryCopyWith<$Res> {
  __$ApiarySummaryCopyWithImpl(this._self, this._then);

  final _ApiarySummary _self;
  final $Res Function(_ApiarySummary) _then;

/// Create a copy of ApiarySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiary = null,Object? activeHiveCount = null,Object? lastVisitAt = freezed,}) {
  return _then(_ApiarySummary(
apiary: null == apiary ? _self.apiary : apiary // ignore: cast_nullable_to_non_nullable
as Apiary,activeHiveCount: null == activeHiveCount ? _self.activeHiveCount : activeHiveCount // ignore: cast_nullable_to_non_nullable
as int,lastVisitAt: freezed == lastVisitAt ? _self.lastVisitAt : lastVisitAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ApiarySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiaryCopyWith<$Res> get apiary {
  
  return $ApiaryCopyWith<$Res>(_self.apiary, (value) {
    return _then(_self.copyWith(apiary: value));
  });
}
}

// dart format on
