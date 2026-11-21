// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlanStatus {

 bool get plansEnabled;@JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson) PlanTier get plan;/// Pro döneminin bittiği an; süresiz satın almada ya da ücretsizde null.
@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) DateTime? get expiresAt;/// En çok kaç aktif kovan; null sınırsız.
 int? get hiveLimit;/// Sahibin dışında üye alınabilir mi.
 bool get team;/// En çok kaç günlük hava tahmini; null sunucuda ne varsa.
 int? get forecastDays;
/// Create a copy of PlanStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlanStatusCopyWith<PlanStatus> get copyWith => _$PlanStatusCopyWithImpl<PlanStatus>(this as PlanStatus, _$identity);

  /// Serializes this PlanStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlanStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlanStatus&&(identical(other.plansEnabled, _this.plansEnabled) || other.plansEnabled == _this.plansEnabled)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.hiveLimit, _this.hiveLimit) || other.hiveLimit == _this.hiveLimit)&&(identical(other.team, _this.team) || other.team == _this.team)&&(identical(other.forecastDays, _this.forecastDays) || other.forecastDays == _this.forecastDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlanStatus;
  return Object.hash(runtimeType,_this.plansEnabled,_this.plan,_this.expiresAt,_this.hiveLimit,_this.team,_this.forecastDays);
}

@override
String toString() {
  final _this = this as PlanStatus;
  return 'PlanStatus(plansEnabled: ${_this.plansEnabled}, plan: ${_this.plan}, expiresAt: ${_this.expiresAt}, hiveLimit: ${_this.hiveLimit}, team: ${_this.team}, forecastDays: ${_this.forecastDays})';
}


}

/// @nodoc
abstract mixin class $PlanStatusCopyWith<$Res>  {
  factory $PlanStatusCopyWith(PlanStatus value, $Res Function(PlanStatus) _then) = _$PlanStatusCopyWithImpl;
@useResult
$Res call({
 bool plansEnabled,@JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson) PlanTier plan,@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) DateTime? expiresAt, int? hiveLimit, bool team, int? forecastDays
});




}
/// @nodoc
class _$PlanStatusCopyWithImpl<$Res>
    implements $PlanStatusCopyWith<$Res> {
  _$PlanStatusCopyWithImpl(this._self, this._then);

  final PlanStatus _self;
  final $Res Function(PlanStatus) _then;

/// Create a copy of PlanStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plansEnabled = null,Object? plan = null,Object? expiresAt = freezed,Object? hiveLimit = freezed,Object? team = null,Object? forecastDays = freezed,}) {
  return _then(PlanStatus(
plansEnabled: null == plansEnabled ? _self.plansEnabled : plansEnabled // ignore: cast_nullable_to_non_nullable
as bool,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanTier,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,hiveLimit: freezed == hiveLimit ? _self.hiveLimit : hiveLimit // ignore: cast_nullable_to_non_nullable
as int?,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as bool,forecastDays: freezed == forecastDays ? _self.forecastDays : forecastDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlanStatus].
extension PlanStatusPatterns on PlanStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlanStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlanStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlanStatus value)  $default,){
final _that = this;
switch (_that) {
case _PlanStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlanStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PlanStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool plansEnabled, @JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson)  PlanTier plan, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  DateTime? expiresAt,  int? hiveLimit,  bool team,  int? forecastDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlanStatus() when $default != null:
return $default(_that.plansEnabled,_that.plan,_that.expiresAt,_that.hiveLimit,_that.team,_that.forecastDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool plansEnabled, @JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson)  PlanTier plan, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  DateTime? expiresAt,  int? hiveLimit,  bool team,  int? forecastDays)  $default,) {final _that = this;
switch (_that) {
case _PlanStatus():
return $default(_that.plansEnabled,_that.plan,_that.expiresAt,_that.hiveLimit,_that.team,_that.forecastDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool plansEnabled, @JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson)  PlanTier plan, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)  DateTime? expiresAt,  int? hiveLimit,  bool team,  int? forecastDays)?  $default,) {final _that = this;
switch (_that) {
case _PlanStatus() when $default != null:
return $default(_that.plansEnabled,_that.plan,_that.expiresAt,_that.hiveLimit,_that.team,_that.forecastDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlanStatus implements PlanStatus {
  const _PlanStatus({this.plansEnabled = false, @JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson) this.plan = PlanTier.free, @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) this.expiresAt, this.hiveLimit, this.team = true, this.forecastDays});
  factory _PlanStatus.fromJson(Map<String, dynamic> json) => _$PlanStatusFromJson(json);

@override@JsonKey() final  bool plansEnabled;
@override@JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson) final  PlanTier plan;
/// Pro döneminin bittiği an; süresiz satın almada ya da ücretsizde null.
@override@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) final  DateTime? expiresAt;
/// En çok kaç aktif kovan; null sınırsız.
@override final  int? hiveLimit;
/// Sahibin dışında üye alınabilir mi.
@override@JsonKey() final  bool team;
/// En çok kaç günlük hava tahmini; null sunucuda ne varsa.
@override final  int? forecastDays;

/// Create a copy of PlanStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlanStatusCopyWith<_PlanStatus> get copyWith => __$PlanStatusCopyWithImpl<_PlanStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlanStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlanStatus&&(identical(other.plansEnabled, plansEnabled) || other.plansEnabled == plansEnabled)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.hiveLimit, hiveLimit) || other.hiveLimit == hiveLimit)&&(identical(other.team, team) || other.team == team)&&(identical(other.forecastDays, forecastDays) || other.forecastDays == forecastDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,plansEnabled,plan,expiresAt,hiveLimit,team,forecastDays);
}

@override
String toString() {
    return 'PlanStatus(plansEnabled: $plansEnabled, plan: $plan, expiresAt: $expiresAt, hiveLimit: $hiveLimit, team: $team, forecastDays: $forecastDays)';
}


}

/// @nodoc
abstract mixin class _$PlanStatusCopyWith<$Res> implements $PlanStatusCopyWith<$Res> {
  factory _$PlanStatusCopyWith(_PlanStatus value, $Res Function(_PlanStatus) _then) = __$PlanStatusCopyWithImpl;
@override @useResult
$Res call({
 bool plansEnabled,@JsonKey(fromJson: PlanTier.fromServer, toJson: _tierToJson) PlanTier plan,@JsonKey(fromJson: _timeFromJson, toJson: _timeToJson) DateTime? expiresAt, int? hiveLimit, bool team, int? forecastDays
});




}
/// @nodoc
class __$PlanStatusCopyWithImpl<$Res>
    implements _$PlanStatusCopyWith<$Res> {
  __$PlanStatusCopyWithImpl(this._self, this._then);

  final _PlanStatus _self;
  final $Res Function(_PlanStatus) _then;

/// Create a copy of PlanStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plansEnabled = null,Object? plan = null,Object? expiresAt = freezed,Object? hiveLimit = freezed,Object? team = null,Object? forecastDays = freezed,}) {
  return _then(_PlanStatus(
plansEnabled: null == plansEnabled ? _self.plansEnabled : plansEnabled // ignore: cast_nullable_to_non_nullable
as bool,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as PlanTier,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,hiveLimit: freezed == hiveLimit ? _self.hiveLimit : hiveLimit // ignore: cast_nullable_to_non_nullable
as int?,team: null == team ? _self.team : team // ignore: cast_nullable_to_non_nullable
as bool,forecastDays: freezed == forecastDays ? _self.forecastDays : forecastDays // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$StoredPlanStatus {

 PlanStatus get status; DateTime get fetchedAt;
/// Create a copy of StoredPlanStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoredPlanStatusCopyWith<StoredPlanStatus> get copyWith => _$StoredPlanStatusCopyWithImpl<StoredPlanStatus>(this as StoredPlanStatus, _$identity);

  /// Serializes this StoredPlanStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as StoredPlanStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoredPlanStatus&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as StoredPlanStatus;
  return Object.hash(runtimeType,_this.status,_this.fetchedAt);
}

@override
String toString() {
  final _this = this as StoredPlanStatus;
  return 'StoredPlanStatus(status: ${_this.status}, fetchedAt: ${_this.fetchedAt})';
}


}

/// @nodoc
abstract mixin class $StoredPlanStatusCopyWith<$Res>  {
  factory $StoredPlanStatusCopyWith(StoredPlanStatus value, $Res Function(StoredPlanStatus) _then) = _$StoredPlanStatusCopyWithImpl;
@useResult
$Res call({
 PlanStatus status, DateTime fetchedAt
});


$PlanStatusCopyWith<$Res> get status;

}
/// @nodoc
class _$StoredPlanStatusCopyWithImpl<$Res>
    implements $StoredPlanStatusCopyWith<$Res> {
  _$StoredPlanStatusCopyWithImpl(this._self, this._then);

  final StoredPlanStatus _self;
  final $Res Function(StoredPlanStatus) _then;

/// Create a copy of StoredPlanStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? fetchedAt = null,}) {
  return _then(StoredPlanStatus(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanStatus,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of StoredPlanStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanStatusCopyWith<$Res> get status {
  
  return $PlanStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoredPlanStatus].
extension StoredPlanStatusPatterns on StoredPlanStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoredPlanStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoredPlanStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoredPlanStatus value)  $default,){
final _that = this;
switch (_that) {
case _StoredPlanStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoredPlanStatus value)?  $default,){
final _that = this;
switch (_that) {
case _StoredPlanStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlanStatus status,  DateTime fetchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoredPlanStatus() when $default != null:
return $default(_that.status,_that.fetchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlanStatus status,  DateTime fetchedAt)  $default,) {final _that = this;
switch (_that) {
case _StoredPlanStatus():
return $default(_that.status,_that.fetchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlanStatus status,  DateTime fetchedAt)?  $default,) {final _that = this;
switch (_that) {
case _StoredPlanStatus() when $default != null:
return $default(_that.status,_that.fetchedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoredPlanStatus implements StoredPlanStatus {
  const _StoredPlanStatus({required this.status, required this.fetchedAt});
  factory _StoredPlanStatus.fromJson(Map<String, dynamic> json) => _$StoredPlanStatusFromJson(json);

@override final  PlanStatus status;
@override final  DateTime fetchedAt;

/// Create a copy of StoredPlanStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoredPlanStatusCopyWith<_StoredPlanStatus> get copyWith => __$StoredPlanStatusCopyWithImpl<_StoredPlanStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoredPlanStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoredPlanStatus&&(identical(other.status, status) || other.status == status)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status,fetchedAt);
}

@override
String toString() {
    return 'StoredPlanStatus(status: $status, fetchedAt: $fetchedAt)';
}


}

/// @nodoc
abstract mixin class _$StoredPlanStatusCopyWith<$Res> implements $StoredPlanStatusCopyWith<$Res> {
  factory _$StoredPlanStatusCopyWith(_StoredPlanStatus value, $Res Function(_StoredPlanStatus) _then) = __$StoredPlanStatusCopyWithImpl;
@override @useResult
$Res call({
 PlanStatus status, DateTime fetchedAt
});


@override $PlanStatusCopyWith<$Res> get status;

}
/// @nodoc
class __$StoredPlanStatusCopyWithImpl<$Res>
    implements _$StoredPlanStatusCopyWith<$Res> {
  __$StoredPlanStatusCopyWithImpl(this._self, this._then);

  final _StoredPlanStatus _self;
  final $Res Function(_StoredPlanStatus) _then;

/// Create a copy of StoredPlanStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? fetchedAt = null,}) {
  return _then(_StoredPlanStatus(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlanStatus,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of StoredPlanStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlanStatusCopyWith<$Res> get status {
  
  return $PlanStatusCopyWith<$Res>(_self.status, (value) {
    return _then(_self.copyWith(status: value));
  });
}
}

// dart format on
