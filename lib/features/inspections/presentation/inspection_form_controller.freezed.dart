// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inspection_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InspectionFormState {

 Hive get hive; InspectionDraft get draft;/// Kovanın önceki muayenesi; soluk değerler buradan gelir.
 Inspection? get previous; bool get saving;
/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InspectionFormStateCopyWith<InspectionFormState> get copyWith => _$InspectionFormStateCopyWithImpl<InspectionFormState>(this as InspectionFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InspectionFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InspectionFormState&&(identical(other.hive, _this.hive) || other.hive == _this.hive)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.previous, _this.previous) || other.previous == _this.previous)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as InspectionFormState;
  return Object.hash(runtimeType,_this.hive,_this.draft,_this.previous,_this.saving);
}

@override
String toString() {
  final _this = this as InspectionFormState;
  return 'InspectionFormState(hive: ${_this.hive}, draft: ${_this.draft}, previous: ${_this.previous}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $InspectionFormStateCopyWith<$Res>  {
  factory $InspectionFormStateCopyWith(InspectionFormState value, $Res Function(InspectionFormState) _then) = _$InspectionFormStateCopyWithImpl;
@useResult
$Res call({
 Hive hive, InspectionDraft draft, Inspection? previous, bool saving
});


$HiveCopyWith<$Res> get hive;$InspectionDraftCopyWith<$Res> get draft;$InspectionCopyWith<$Res>? get previous;

}
/// @nodoc
class _$InspectionFormStateCopyWithImpl<$Res>
    implements $InspectionFormStateCopyWith<$Res> {
  _$InspectionFormStateCopyWithImpl(this._self, this._then);

  final InspectionFormState _self;
  final $Res Function(InspectionFormState) _then;

/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hive = null,Object? draft = null,Object? previous = freezed,Object? saving = null,}) {
  return _then(InspectionFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as InspectionDraft,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as Inspection?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspectionDraftCopyWith<$Res> get draft {
  
  return $InspectionDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspectionCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $InspectionCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// Adds pattern-matching-related methods to [InspectionFormState].
extension InspectionFormStatePatterns on InspectionFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InspectionFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InspectionFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InspectionFormState value)  $default,){
final _that = this;
switch (_that) {
case _InspectionFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InspectionFormState value)?  $default,){
final _that = this;
switch (_that) {
case _InspectionFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Hive hive,  InspectionDraft draft,  Inspection? previous,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InspectionFormState() when $default != null:
return $default(_that.hive,_that.draft,_that.previous,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Hive hive,  InspectionDraft draft,  Inspection? previous,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _InspectionFormState():
return $default(_that.hive,_that.draft,_that.previous,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Hive hive,  InspectionDraft draft,  Inspection? previous,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _InspectionFormState() when $default != null:
return $default(_that.hive,_that.draft,_that.previous,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _InspectionFormState implements InspectionFormState {
  const _InspectionFormState({required this.hive, required this.draft, this.previous, this.saving = false});
  

@override final  Hive hive;
@override final  InspectionDraft draft;
/// Kovanın önceki muayenesi; soluk değerler buradan gelir.
@override final  Inspection? previous;
@override@JsonKey() final  bool saving;

/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InspectionFormStateCopyWith<_InspectionFormState> get copyWith => __$InspectionFormStateCopyWithImpl<_InspectionFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InspectionFormState&&(identical(other.hive, hive) || other.hive == hive)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hive,draft,previous,saving);
}

@override
String toString() {
    return 'InspectionFormState(hive: $hive, draft: $draft, previous: $previous, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$InspectionFormStateCopyWith<$Res> implements $InspectionFormStateCopyWith<$Res> {
  factory _$InspectionFormStateCopyWith(_InspectionFormState value, $Res Function(_InspectionFormState) _then) = __$InspectionFormStateCopyWithImpl;
@override @useResult
$Res call({
 Hive hive, InspectionDraft draft, Inspection? previous, bool saving
});


@override $HiveCopyWith<$Res> get hive;@override $InspectionDraftCopyWith<$Res> get draft;@override $InspectionCopyWith<$Res>? get previous;

}
/// @nodoc
class __$InspectionFormStateCopyWithImpl<$Res>
    implements _$InspectionFormStateCopyWith<$Res> {
  __$InspectionFormStateCopyWithImpl(this._self, this._then);

  final _InspectionFormState _self;
  final $Res Function(_InspectionFormState) _then;

/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hive = null,Object? draft = null,Object? previous = freezed,Object? saving = null,}) {
  return _then(_InspectionFormState(
hive: null == hive ? _self.hive : hive // ignore: cast_nullable_to_non_nullable
as Hive,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as InspectionDraft,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as Inspection?,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HiveCopyWith<$Res> get hive {
  
  return $HiveCopyWith<$Res>(_self.hive, (value) {
    return _then(_self.copyWith(hive: value));
  });
}/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspectionDraftCopyWith<$Res> get draft {
  
  return $InspectionDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of InspectionFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InspectionCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $InspectionCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

// dart format on
