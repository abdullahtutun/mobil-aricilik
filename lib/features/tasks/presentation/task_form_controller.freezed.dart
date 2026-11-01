// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskFormState {

/// Son tarih, yerel saat.
 DateTime get dueAt; String get title; String? get apiaryId; String? get hiveId; String? get assignedTo; bool get completed;/// Düzenlenen görevin kaynağı; otomatik görevde başlık, arılık ve kovan
/// kaynaktan gelir, değişmez.
 TaskSource get source;/// Ana yetiştirme görevinin takvim günü; başlık bundan.
 int? get sourceStep;/// Planlı ilaçlama: ilaç (referans ya da işletmenin; en çok biri) ve
/// kovan başı doz. İlaç yoksa doz yazılmaz.
 String? get refDrugId; String? get drugId; int get dose; bool get saving;
/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskFormStateCopyWith<TaskFormState> get copyWith => _$TaskFormStateCopyWithImpl<TaskFormState>(this as TaskFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TaskFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskFormState&&(identical(other.dueAt, _this.dueAt) || other.dueAt == _this.dueAt)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.hiveId, _this.hiveId) || other.hiveId == _this.hiveId)&&(identical(other.assignedTo, _this.assignedTo) || other.assignedTo == _this.assignedTo)&&(identical(other.completed, _this.completed) || other.completed == _this.completed)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.sourceStep, _this.sourceStep) || other.sourceStep == _this.sourceStep)&&(identical(other.refDrugId, _this.refDrugId) || other.refDrugId == _this.refDrugId)&&(identical(other.drugId, _this.drugId) || other.drugId == _this.drugId)&&(identical(other.dose, _this.dose) || other.dose == _this.dose)&&(identical(other.saving, _this.saving) || other.saving == _this.saving));
}


@override
int get hashCode {
  final _this = this as TaskFormState;
  return Object.hash(runtimeType,_this.dueAt,_this.title,_this.apiaryId,_this.hiveId,_this.assignedTo,_this.completed,_this.source,_this.sourceStep,_this.refDrugId,_this.drugId,_this.dose,_this.saving);
}

@override
String toString() {
  final _this = this as TaskFormState;
  return 'TaskFormState(dueAt: ${_this.dueAt}, title: ${_this.title}, apiaryId: ${_this.apiaryId}, hiveId: ${_this.hiveId}, assignedTo: ${_this.assignedTo}, completed: ${_this.completed}, source: ${_this.source}, sourceStep: ${_this.sourceStep}, refDrugId: ${_this.refDrugId}, drugId: ${_this.drugId}, dose: ${_this.dose}, saving: ${_this.saving})';
}


}

/// @nodoc
abstract mixin class $TaskFormStateCopyWith<$Res>  {
  factory $TaskFormStateCopyWith(TaskFormState value, $Res Function(TaskFormState) _then) = _$TaskFormStateCopyWithImpl;
@useResult
$Res call({
 DateTime dueAt, String title, String? apiaryId, String? hiveId, String? assignedTo, bool completed, TaskSource source, int? sourceStep, String? refDrugId, String? drugId, int dose, bool saving
});




}
/// @nodoc
class _$TaskFormStateCopyWithImpl<$Res>
    implements $TaskFormStateCopyWith<$Res> {
  _$TaskFormStateCopyWithImpl(this._self, this._then);

  final TaskFormState _self;
  final $Res Function(TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dueAt = null,Object? title = null,Object? apiaryId = freezed,Object? hiveId = freezed,Object? assignedTo = freezed,Object? completed = null,Object? source = null,Object? sourceStep = freezed,Object? refDrugId = freezed,Object? drugId = freezed,Object? dose = null,Object? saving = null,}) {
  return _then(TaskFormState(
dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveId: freezed == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TaskSource,sourceStep: freezed == sourceStep ? _self.sourceStep : sourceStep // ignore: cast_nullable_to_non_nullable
as int?,refDrugId: freezed == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as int,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskFormState].
extension TaskFormStatePatterns on TaskFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskFormState value)  $default,){
final _that = this;
switch (_that) {
case _TaskFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskFormState value)?  $default,){
final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime dueAt,  String title,  String? apiaryId,  String? hiveId,  String? assignedTo,  bool completed,  TaskSource source,  int? sourceStep,  String? refDrugId,  String? drugId,  int dose,  bool saving)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
return $default(_that.dueAt,_that.title,_that.apiaryId,_that.hiveId,_that.assignedTo,_that.completed,_that.source,_that.sourceStep,_that.refDrugId,_that.drugId,_that.dose,_that.saving);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime dueAt,  String title,  String? apiaryId,  String? hiveId,  String? assignedTo,  bool completed,  TaskSource source,  int? sourceStep,  String? refDrugId,  String? drugId,  int dose,  bool saving)  $default,) {final _that = this;
switch (_that) {
case _TaskFormState():
return $default(_that.dueAt,_that.title,_that.apiaryId,_that.hiveId,_that.assignedTo,_that.completed,_that.source,_that.sourceStep,_that.refDrugId,_that.drugId,_that.dose,_that.saving);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime dueAt,  String title,  String? apiaryId,  String? hiveId,  String? assignedTo,  bool completed,  TaskSource source,  int? sourceStep,  String? refDrugId,  String? drugId,  int dose,  bool saving)?  $default,) {final _that = this;
switch (_that) {
case _TaskFormState() when $default != null:
return $default(_that.dueAt,_that.title,_that.apiaryId,_that.hiveId,_that.assignedTo,_that.completed,_that.source,_that.sourceStep,_that.refDrugId,_that.drugId,_that.dose,_that.saving);case _:
  return null;

}
}

}

/// @nodoc


class _TaskFormState implements TaskFormState {
  const _TaskFormState({required this.dueAt, this.title = '', this.apiaryId, this.hiveId, this.assignedTo, this.completed = false, this.source = TaskSource.manual, this.sourceStep, this.refDrugId, this.drugId, this.dose = 1, this.saving = false});
  

/// Son tarih, yerel saat.
@override final  DateTime dueAt;
@override@JsonKey() final  String title;
@override final  String? apiaryId;
@override final  String? hiveId;
@override final  String? assignedTo;
@override@JsonKey() final  bool completed;
/// Düzenlenen görevin kaynağı; otomatik görevde başlık, arılık ve kovan
/// kaynaktan gelir, değişmez.
@override@JsonKey() final  TaskSource source;
/// Ana yetiştirme görevinin takvim günü; başlık bundan.
@override final  int? sourceStep;
/// Planlı ilaçlama: ilaç (referans ya da işletmenin; en çok biri) ve
/// kovan başı doz. İlaç yoksa doz yazılmaz.
@override final  String? refDrugId;
@override final  String? drugId;
@override@JsonKey() final  int dose;
@override@JsonKey() final  bool saving;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskFormStateCopyWith<_TaskFormState> get copyWith => __$TaskFormStateCopyWithImpl<_TaskFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskFormState&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.hiveId, hiveId) || other.hiveId == hiveId)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.source, source) || other.source == source)&&(identical(other.sourceStep, sourceStep) || other.sourceStep == sourceStep)&&(identical(other.refDrugId, refDrugId) || other.refDrugId == refDrugId)&&(identical(other.drugId, drugId) || other.drugId == drugId)&&(identical(other.dose, dose) || other.dose == dose)&&(identical(other.saving, saving) || other.saving == saving));
}


@override
int get hashCode {
    return Object.hash(runtimeType,dueAt,title,apiaryId,hiveId,assignedTo,completed,source,sourceStep,refDrugId,drugId,dose,saving);
}

@override
String toString() {
    return 'TaskFormState(dueAt: $dueAt, title: $title, apiaryId: $apiaryId, hiveId: $hiveId, assignedTo: $assignedTo, completed: $completed, source: $source, sourceStep: $sourceStep, refDrugId: $refDrugId, drugId: $drugId, dose: $dose, saving: $saving)';
}


}

/// @nodoc
abstract mixin class _$TaskFormStateCopyWith<$Res> implements $TaskFormStateCopyWith<$Res> {
  factory _$TaskFormStateCopyWith(_TaskFormState value, $Res Function(_TaskFormState) _then) = __$TaskFormStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime dueAt, String title, String? apiaryId, String? hiveId, String? assignedTo, bool completed, TaskSource source, int? sourceStep, String? refDrugId, String? drugId, int dose, bool saving
});




}
/// @nodoc
class __$TaskFormStateCopyWithImpl<$Res>
    implements _$TaskFormStateCopyWith<$Res> {
  __$TaskFormStateCopyWithImpl(this._self, this._then);

  final _TaskFormState _self;
  final $Res Function(_TaskFormState) _then;

/// Create a copy of TaskFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dueAt = null,Object? title = null,Object? apiaryId = freezed,Object? hiveId = freezed,Object? assignedTo = freezed,Object? completed = null,Object? source = null,Object? sourceStep = freezed,Object? refDrugId = freezed,Object? drugId = freezed,Object? dose = null,Object? saving = null,}) {
  return _then(_TaskFormState(
dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,apiaryId: freezed == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String?,hiveId: freezed == hiveId ? _self.hiveId : hiveId // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as TaskSource,sourceStep: freezed == sourceStep ? _self.sourceStep : sourceStep // ignore: cast_nullable_to_non_nullable
as int?,refDrugId: freezed == refDrugId ? _self.refDrugId : refDrugId // ignore: cast_nullable_to_non_nullable
as String?,drugId: freezed == drugId ? _self.drugId : drugId // ignore: cast_nullable_to_non_nullable
as String?,dose: null == dose ? _self.dose : dose // ignore: cast_nullable_to_non_nullable
as int,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
