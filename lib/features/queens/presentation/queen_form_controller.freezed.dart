// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queen_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueenFormState {

/// Anayı alan ya da anası düzenlenen kovan.
 Hive get hive;/// Düzenlenen ana; yeni anada null.
 String? get queenId; int? get year; QueenMarkColor? get markColor; String get breed; String get breedLine; QueenSource? get source; bool get wingClipped; String? get motherQueenId; bool get saving;
/// Create a copy of QueenFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueenFormStateCopyWith<QueenFormState> get copyWith => _$QueenFormStateCopyWithImpl<QueenFormState>(this as QueenFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QueenFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueenFormState&&(identical(other.hive, _this.hive) || other.hive == _this.hive)&&(identical(other.queenId, _this.queenId) || other.queenId == _this.queenId)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.markColor, _this.markColor) || other.markColor == _this.markColor)&&(identical(other.breed, _this.breed) || other.breed == _this.breed)&&(identical(other.breedLine, _this.breedLine) || other.breedLine == _this.breedLine)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.wingClipped, _this.wingClipped) || other.wingClipped == _this.wingClipped)&&(identical(other.motherQueenId, _this.motherQueenId) || other.motherQueenId == _this.motherQueenId)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as QueenFormState;
  return Object.hash(runtimeType,_this.hive,_this.queenId,_this.year,_this.markColor,_this.breed,_this.breedLine,_this.source,_this.wingClipped,_this.motherQueenId,_this.saving);
}

@override
String toString() {
  final _this = this as QueenFormState;
  return 'QueenFormState(hive: ${_this.hive}, queenId: ${_this.queenId}, year: ${_this.year}, markColor: ${_this.markColor}, breed: ${_this.breed}, breedLine: ${_this.breedLine}, source: ${_this.source}, wingClipped: ${_this.wingClipped}, motherQueenId: ${_this.motherQueenId}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $QueenFormStateCopyWith<$Res>  {
  factory $QueenFormStateCopyWith(QueenFormState value, $Res Function(QueenFormState) _then) = _$QueenFormStateCopyWithImpl;
@useResult
$Res call({
 Hive hive, String? queenId, int? year, QueenMarkColor? markColor, String breed, String breedLine, QueenSource? source, bool wingClipped, String? motherQueenId, bool saving
});


$HiveCopyWith<$Res> get hive;

}
/// @nodoc
class _$QueenFormStateCopyWithImpl<$Res>
    implements $QueenFormStateCopyWith<$Res> {
  _$QueenFormStateCopyWithImpl(this._self, this._then);

  final QueenFormState _self;
  final $Res Function(QueenFormState) _then;

/// Create a copy of QueenFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hive = null,Object? queenId = freezed,Object? year = freezed,Object? markColor = freezed,Object? breed = null,Object? breedLine = null,Object? source = freezed,Object? wingClipped = null,Object? motherQueenId = freezed,Object? saving = null,}) {
  return _then(QueenFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,queenId: freezed == queenId ? _self.queenId : queenId // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,markColor: freezed == markColor ? _self.markColor : markColor // ignore: cast_nullable_to_non_nullable
as QueenMarkColor?,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,breedLine: null == breedLine ? _self.breedLine : breedLine // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as QueenSource?,wingClipped: null == wingClipped ? _self.wingClipped : wingClipped // ignore: cast_nullable_to_non_nullable
as bool,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of QueenFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueenFormState].
extension QueenFormStatePatterns on QueenFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueenFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueenFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueenFormState value)  $default,){
final _that = this;
switch (_that) {
case _QueenFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueenFormState value)?  $default,){
final _that = this;
switch (_that) {
case _QueenFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Hive hive,  String? queenId,  int? year,  QueenMarkColor? markColor,  String breed,  String breedLine,  QueenSource? source,  bool wingClipped,  String? motherQueenId,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueenFormState() when $default != null:
return $default(_that.hive,_that.queenId,_that.year,_that.markColor,_that.breed,_that.breedLine,_that.source,_that.wingClipped,_that.motherQueenId,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Hive hive,  String? queenId,  int? year,  QueenMarkColor? markColor,  String breed,  String breedLine,  QueenSource? source,  bool wingClipped,  String? motherQueenId,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _QueenFormState():
return $default(_that.hive,_that.queenId,_that.year,_that.markColor,_that.breed,_that.breedLine,_that.source,_that.wingClipped,_that.motherQueenId,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Hive hive,  String? queenId,  int? year,  QueenMarkColor? markColor,  String breed,  String breedLine,  QueenSource? source,  bool wingClipped,  String? motherQueenId,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _QueenFormState() when $default != null:
return $default(_that.hive,_that.queenId,_that.year,_that.markColor,_that.breed,_that.breedLine,_that.source,_that.wingClipped,_that.motherQueenId,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _QueenFormState implements QueenFormState {
  const _QueenFormState({required this.hive, this.queenId, this.year, this.markColor, this.breed = '', this.breedLine = '', this.source, this.wingClipped = false, this.motherQueenId, this.saving = false});
  

/// Anayı alan ya da anası düzenlenen kovan.
@override final  Hive hive;
/// Düzenlenen ana; yeni anada null.
@override final  String? queenId;
@override final  int? year;
@override final  QueenMarkColor? markColor;
@override@JsonKey() final  String breed;
@override@JsonKey() final  String breedLine;
@override final  QueenSource? source;
@override@JsonKey() final  bool wingClipped;
@override final  String? motherQueenId;
@override@JsonKey() final  bool saving;

/// Create a copy of QueenFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueenFormStateCopyWith<_QueenFormState> get copyWith => __$QueenFormStateCopyWithImpl<_QueenFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueenFormState&&(identical(other.hive, hive) || other.hive == hive)&&(identical(other.queenId, queenId) || other.queenId == queenId)&&(identical(other.year, year) || other.year == year)&&(identical(other.markColor, markColor) || other.markColor == markColor)&&(identical(other.breed, breed) || other.breed == breed)&&(identical(other.breedLine, breedLine) || other.breedLine == breedLine)&&(identical(other.source, source) || other.source == source)&&(identical(other.wingClipped, wingClipped) || other.wingClipped == wingClipped)&&(identical(other.motherQueenId, motherQueenId) || other.motherQueenId == motherQueenId)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hive,queenId,year,markColor,breed,breedLine,source,wingClipped,motherQueenId,saving);
}

@override
String toString() {
    return 'QueenFormState(hive: $hive, queenId: $queenId, year: $year, markColor: $markColor, breed: $breed, breedLine: $breedLine, source: $source, wingClipped: $wingClipped, motherQueenId: $motherQueenId, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$QueenFormStateCopyWith<$Res> implements $QueenFormStateCopyWith<$Res> {
  factory _$QueenFormStateCopyWith(_QueenFormState value, $Res Function(_QueenFormState) _then) = __$QueenFormStateCopyWithImpl;
@override @useResult
$Res call({
 Hive hive, String? queenId, int? year, QueenMarkColor? markColor, String breed, String breedLine, QueenSource? source, bool wingClipped, String? motherQueenId, bool saving
});


@override $HiveCopyWith<$Res> get hive;

}
/// @nodoc
class __$QueenFormStateCopyWithImpl<$Res>
    implements _$QueenFormStateCopyWith<$Res> {
  __$QueenFormStateCopyWithImpl(this._self, this._then);

  final _QueenFormState _self;
  final $Res Function(_QueenFormState) _then;

/// Create a copy of QueenFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hive = null,Object? queenId = freezed,Object? year = freezed,Object? markColor = freezed,Object? breed = null,Object? breedLine = null,Object? source = freezed,Object? wingClipped = null,Object? motherQueenId = freezed,Object? saving = null,}) {
  return _then(_QueenFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,queenId: freezed == queenId ? _self.queenId : queenId // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,markColor: freezed == markColor ? _self.markColor : markColor // ignore: cast_nullable_to_non_nullable
as QueenMarkColor?,breed: null == breed ? _self.breed : breed // ignore: cast_nullable_to_non_nullable
as String,breedLine: null == breedLine ? _self.breedLine : breedLine // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as QueenSource?,wingClipped: null == wingClipped ? _self.wingClipped : wingClipped // ignore: cast_nullable_to_non_nullable
as bool,motherQueenId: freezed == motherQueenId ? _self.motherQueenId : motherQueenId // ignore: cast_nullable_to_non_nullable
as String?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of QueenFormState
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
