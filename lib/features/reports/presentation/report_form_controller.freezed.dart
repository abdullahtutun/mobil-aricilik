// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportFormState {

/// Dönemin ilk ve son günü (yerel takvimde gece yarısı); ilk gün son
/// günden sonra olamaz.
 DateTime get from; DateTime get to; ReportKind get kind;/// Boşsa bütün arılıklar.
 String? get apiaryId;/// Yalnız kovan geçmişinde; boşsa kapsamdaki bütün kovanlar.
 String? get hiveId;/// PDF'in dili; boşsa uygulamanın dili.
 AppLanguage? get language;
/// Create a copy of ReportFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportFormStateCopyWith<ReportFormState> get copyWith => _$ReportFormStateCopyWithImpl<ReportFormState>(this as ReportFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReportFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportFormState&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.language, _this.language) || other.language == _this.language));
}


@override
int get hashCode {
  final _this = this as ReportFormState;
  return Object.hash(runtimeType,_this.from,_this.to,_this.kind,_this.apiaryId,_this.hiveId,_this.language);
}

@override
String toString() {
  final _this = this as ReportFormState;
  return 'ReportFormState(from: ${_this.from}, to: ${_this.to}, kind: ${_this.kind}, apiaryId: ${_this.apiaryId}, hiveId: ${_this.hiveId}, language: ${_this.language})';
}


}

/// @nodoc
abstract mixin class $ReportFormStateCopyWith<$Res>  {
  factory $ReportFormStateCopyWith(ReportFormState value, $Res Function(ReportFormState) _then) = _$ReportFormStateCopyWithImpl;
@useResult
$Res call({
 DateTime from, DateTime to, ReportKind kind, String? apiaryId, String? hiveId, AppLanguage? language
});




}
/// @nodoc
class _$ReportFormStateCopyWithImpl<$Res>
    implements $ReportFormStateCopyWith<$Res> {
  _$ReportFormStateCopyWithImpl(this._self, this._then);

  final ReportFormState _self;
  final $Res Function(ReportFormState) _then;

/// Create a copy of ReportFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,Object? kind = null,Object? apiaryId = freezed,Object? hiveId = freezed,Object? language = freezed,}) {
  return _then(ReportFormState(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReportKind,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveId: freezed == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as AppLanguage?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportFormState].
extension ReportFormStatePatterns on ReportFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportFormState value)  $default,){
final _that = this;
switch (_that) {
case _ReportFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ReportFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  ReportKind kind,  String? apiaryId,  String? hiveId,  AppLanguage? language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportFormState() when $default != null:
return $default(_that.from,_that.to,_that.kind,_that.apiaryId,_that.hiveId,_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime from,  DateTime to,  ReportKind kind,  String? apiaryId,  String? hiveId,  AppLanguage? language)  $default,) {final _that = this;
switch (_that) {
case _ReportFormState():
return $default(_that.from,_that.to,_that.kind,_that.apiaryId,_that.hiveId,_that.language);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime from,  DateTime to,  ReportKind kind,  String? apiaryId,  String? hiveId,  AppLanguage? language)?  $default,) {final _that = this;
switch (_that) {
case _ReportFormState() when $default != null:
return $default(_that.from,_that.to,_that.kind,_that.apiaryId,_that.hiveId,_that.language);case _:
  return null;

}
}

}

/// @nodoc


class _ReportFormState implements ReportFormState {
  const _ReportFormState({required this.from, required this.to, this.kind = ReportKind.treatmentRegister, this.apiaryId, this.hiveId, this.language});
  

/// Dönemin ilk ve son günü (yerel takvimde gece yarısı); ilk gün son
/// günden sonra olamaz.
@override final  DateTime from;
@override final  DateTime to;
@override@JsonKey() final  ReportKind kind;
/// Boşsa bütün arılıklar.
@override final  String? apiaryId;
/// Yalnız kovan geçmişinde; boşsa kapsamdaki bütün kovanlar.
@override final  String? hiveId;
/// PDF'in dili; boşsa uygulamanın dili.
@override final  AppLanguage? language;

/// Create a copy of ReportFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportFormStateCopyWith<_ReportFormState> get copyWith => __$ReportFormStateCopyWithImpl<_ReportFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportFormState&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode {
    return Object.hash(runtimeType,from,to,kind,apiaryId,hiveId,language);
}

@override
String toString() {
    return 'ReportFormState(from: $from, to: $to, kind: $kind, apiaryId: $apiaryId, hiveId: $hiveId, language: $language)';
}


}

/// @nodoc
abstract mixin class _$ReportFormStateCopyWith<$Res> implements $ReportFormStateCopyWith<$Res> {
  factory _$ReportFormStateCopyWith(_ReportFormState value, $Res Function(_ReportFormState) _then) = __$ReportFormStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime from, DateTime to, ReportKind kind, String? apiaryId, String? hiveId, AppLanguage? language
});




}
/// @nodoc
class __$ReportFormStateCopyWithImpl<$Res>
    implements _$ReportFormStateCopyWith<$Res> {
  __$ReportFormStateCopyWithImpl(this._self, this._then);

  final _ReportFormState _self;
  final $Res Function(_ReportFormState) _then;

/// Create a copy of ReportFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,Object? kind = null,Object? apiaryId = freezed,Object? hiveId = freezed,Object? language = freezed,}) {
  return _then(_ReportFormState(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReportKind,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveId: freezed == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as AppLanguage?,
  ));
}


}

// dart format on
