// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeatherBundle {

 DateTime get generatedAt; List<ApiaryForecast> get forecasts;
/// Create a copy of WeatherBundle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherBundleCopyWith<WeatherBundle> get copyWith => _$WeatherBundleCopyWithImpl<WeatherBundle>(this as WeatherBundle, _$identity);

  /// Serializes this WeatherBundle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeatherBundle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherBundle&&(identical(other.generatedAt, _this.generatedAt) || other.generatedAt == _this.generatedAt)&&const DeepCollectionEquality().equals(other.forecasts, _this.forecasts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeatherBundle;
  return Object.hash(runtimeType,_this.generatedAt,const DeepCollectionEquality().hash(_this.forecasts));
}

@override
String toString() {
  final _this = this as WeatherBundle;
  return 'WeatherBundle(generatedAt: ${_this.generatedAt}, forecasts: ${_this.forecasts})';
}


}

/// @nodoc
abstract mixin class $WeatherBundleCopyWith<$Res>  {
  factory $WeatherBundleCopyWith(WeatherBundle value, $Res Function(WeatherBundle) _then) = _$WeatherBundleCopyWithImpl;
@useResult
$Res call({
 DateTime generatedAt, List<ApiaryForecast> forecasts
});




}
/// @nodoc
class _$WeatherBundleCopyWithImpl<$Res>
    implements $WeatherBundleCopyWith<$Res> {
  _$WeatherBundleCopyWithImpl(this._self, this._then);

  final WeatherBundle _self;
  final $Res Function(WeatherBundle) _then;

/// Create a copy of WeatherBundle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatedAt = null,Object? forecasts = null,}) {
  return _then(WeatherBundle(
generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,forecasts: null == forecasts ? _self.forecasts : forecasts // ignore: cast_nullable_to_non_nullable
as List<ApiaryForecast>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherBundle].
extension WeatherBundlePatterns on WeatherBundle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherBundle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherBundle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherBundle value)  $default,){
final _that = this;
switch (_that) {
case _WeatherBundle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherBundle value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherBundle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime generatedAt,  List<ApiaryForecast> forecasts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherBundle() when $default != null:
return $default(_that.generatedAt,_that.forecasts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime generatedAt,  List<ApiaryForecast> forecasts)  $default,) {final _that = this;
switch (_that) {
case _WeatherBundle():
return $default(_that.generatedAt,_that.forecasts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime generatedAt,  List<ApiaryForecast> forecasts)?  $default,) {final _that = this;
switch (_that) {
case _WeatherBundle() when $default != null:
return $default(_that.generatedAt,_that.forecasts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeatherBundle implements WeatherBundle {
  const _WeatherBundle({required this.generatedAt, required  List<ApiaryForecast> forecasts}): _forecasts = forecasts;
  factory _WeatherBundle.fromJson(Map<String, dynamic> json) => _$WeatherBundleFromJson(json);

@override final  DateTime generatedAt;
 final  List<ApiaryForecast> _forecasts;
@override List<ApiaryForecast> get forecasts {
  if (_forecasts is EqualUnmodifiableListView) return _forecasts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_forecasts);
}


/// Create a copy of WeatherBundle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherBundleCopyWith<_WeatherBundle> get copyWith => __$WeatherBundleCopyWithImpl<_WeatherBundle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeatherBundleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherBundle&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.forecasts, _forecasts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,generatedAt,const DeepCollectionEquality().hash(_forecasts));
}

@override
String toString() {
    return 'WeatherBundle(generatedAt: $generatedAt, forecasts: $forecasts)';
}


}

/// @nodoc
abstract mixin class _$WeatherBundleCopyWith<$Res> implements $WeatherBundleCopyWith<$Res> {
  factory _$WeatherBundleCopyWith(_WeatherBundle value, $Res Function(_WeatherBundle) _then) = __$WeatherBundleCopyWithImpl;
@override @useResult
$Res call({
 DateTime generatedAt, List<ApiaryForecast> forecasts
});




}
/// @nodoc
class __$WeatherBundleCopyWithImpl<$Res>
    implements _$WeatherBundleCopyWith<$Res> {
  __$WeatherBundleCopyWithImpl(this._self, this._then);

  final _WeatherBundle _self;
  final $Res Function(_WeatherBundle) _then;

/// Create a copy of WeatherBundle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAt = null,Object? forecasts = null,}) {
  return _then(_WeatherBundle(
generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,forecasts: null == forecasts ? _self._forecasts : forecasts // ignore: cast_nullable_to_non_nullable
as List<ApiaryForecast>,
  ));
}


}


/// @nodoc
mixin _$ApiaryForecast {

 String get apiaryId; String get cell; DateTime get fetchedAt; Forecast get forecast;
/// Create a copy of ApiaryForecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiaryForecastCopyWith<ApiaryForecast> get copyWith => _$ApiaryForecastCopyWithImpl<ApiaryForecast>(this as ApiaryForecast, _$identity);

  /// Serializes this ApiaryForecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ApiaryForecast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiaryForecast&&(identical(other.apiaryId, _this.apiaryId) || other.apiaryId == _this.apiaryId)&&(identical(other.cell, _this.cell) || other.cell == _this.cell)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt)&&(identical(other.forecast, _this.forecast) || other.forecast == _this.forecast));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApiaryForecast;
  return Object.hash(runtimeType,_this.apiaryId,_this.cell,_this.fetchedAt,_this.forecast);
}

@override
String toString() {
  final _this = this as ApiaryForecast;
  return 'ApiaryForecast(apiaryId: ${_this.apiaryId}, cell: ${_this.cell}, fetchedAt: ${_this.fetchedAt}, forecast: ${_this.forecast})';
}


}

/// @nodoc
abstract mixin class $ApiaryForecastCopyWith<$Res>  {
  factory $ApiaryForecastCopyWith(ApiaryForecast value, $Res Function(ApiaryForecast) _then) = _$ApiaryForecastCopyWithImpl;
@useResult
$Res call({
 String apiaryId, String cell, DateTime fetchedAt, Forecast forecast
});


$ForecastCopyWith<$Res> get forecast;

}
/// @nodoc
class _$ApiaryForecastCopyWithImpl<$Res>
    implements $ApiaryForecastCopyWith<$Res> {
  _$ApiaryForecastCopyWithImpl(this._self, this._then);

  final ApiaryForecast _self;
  final $Res Function(ApiaryForecast) _then;

/// Create a copy of ApiaryForecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiaryId = null,Object? cell = null,Object? fetchedAt = null,Object? forecast = null,}) {
  return _then(ApiaryForecast(
apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,cell: null == cell ? _self.cell : cell // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,forecast: null == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as Forecast,
  ));
}
/// Create a copy of ApiaryForecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastCopyWith<$Res> get forecast {
  
  return $ForecastCopyWith<$Res>(_self.forecast, (value) {
    return _then(_self.copyWith(forecast: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApiaryForecast].
extension ApiaryForecastPatterns on ApiaryForecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiaryForecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiaryForecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiaryForecast value)  $default,){
final _that = this;
switch (_that) {
case _ApiaryForecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiaryForecast value)?  $default,){
final _that = this;
switch (_that) {
case _ApiaryForecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String apiaryId,  String cell,  DateTime fetchedAt,  Forecast forecast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiaryForecast() when $default != null:
return $default(_that.apiaryId,_that.cell,_that.fetchedAt,_that.forecast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String apiaryId,  String cell,  DateTime fetchedAt,  Forecast forecast)  $default,) {final _that = this;
switch (_that) {
case _ApiaryForecast():
return $default(_that.apiaryId,_that.cell,_that.fetchedAt,_that.forecast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String apiaryId,  String cell,  DateTime fetchedAt,  Forecast forecast)?  $default,) {final _that = this;
switch (_that) {
case _ApiaryForecast() when $default != null:
return $default(_that.apiaryId,_that.cell,_that.fetchedAt,_that.forecast);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApiaryForecast implements ApiaryForecast {
  const _ApiaryForecast({required this.apiaryId, required this.cell, required this.fetchedAt, required this.forecast});
  factory _ApiaryForecast.fromJson(Map<String, dynamic> json) => _$ApiaryForecastFromJson(json);

@override final  String apiaryId;
@override final  String cell;
@override final  DateTime fetchedAt;
@override final  Forecast forecast;

/// Create a copy of ApiaryForecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiaryForecastCopyWith<_ApiaryForecast> get copyWith => __$ApiaryForecastCopyWithImpl<_ApiaryForecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApiaryForecastToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiaryForecast&&(identical(other.apiaryId, apiaryId) || other.apiaryId == apiaryId)&&(identical(other.cell, cell) || other.cell == cell)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt)&&(identical(other.forecast, forecast) || other.forecast == forecast));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,apiaryId,cell,fetchedAt,forecast);
}

@override
String toString() {
    return 'ApiaryForecast(apiaryId: $apiaryId, cell: $cell, fetchedAt: $fetchedAt, forecast: $forecast)';
}


}

/// @nodoc
abstract mixin class _$ApiaryForecastCopyWith<$Res> implements $ApiaryForecastCopyWith<$Res> {
  factory _$ApiaryForecastCopyWith(_ApiaryForecast value, $Res Function(_ApiaryForecast) _then) = __$ApiaryForecastCopyWithImpl;
@override @useResult
$Res call({
 String apiaryId, String cell, DateTime fetchedAt, Forecast forecast
});


@override $ForecastCopyWith<$Res> get forecast;

}
/// @nodoc
class __$ApiaryForecastCopyWithImpl<$Res>
    implements _$ApiaryForecastCopyWith<$Res> {
  __$ApiaryForecastCopyWithImpl(this._self, this._then);

  final _ApiaryForecast _self;
  final $Res Function(_ApiaryForecast) _then;

/// Create a copy of ApiaryForecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiaryId = null,Object? cell = null,Object? fetchedAt = null,Object? forecast = null,}) {
  return _then(_ApiaryForecast(
apiaryId: null == apiaryId ? _self.apiaryId : apiaryId // ignore: cast_nullable_to_non_nullable
as String,cell: null == cell ? _self.cell : cell // ignore: cast_nullable_to_non_nullable
as String,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,forecast: null == forecast ? _self.forecast : forecast // ignore: cast_nullable_to_non_nullable
as Forecast,
  ));
}

/// Create a copy of ApiaryForecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForecastCopyWith<$Res> get forecast {
  
  return $ForecastCopyWith<$Res>(_self.forecast, (value) {
    return _then(_self.copyWith(forecast: value));
  });
}
}


/// @nodoc
mixin _$Forecast {

 String get timezone; int get utcOffsetSeconds; HourlySeries get hourly; DailySeries get daily;
/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForecastCopyWith<Forecast> get copyWith => _$ForecastCopyWithImpl<Forecast>(this as Forecast, _$identity);

  /// Serializes this Forecast to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Forecast;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Forecast&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.utcOffsetSeconds, _this.utcOffsetSeconds) || other.utcOffsetSeconds == _this.utcOffsetSeconds)&&(identical(other.hourly, _this.hourly) || other.hourly == _this.hourly)&&(identical(other.daily, _this.daily) || other.daily == _this.daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Forecast;
  return Object.hash(runtimeType,_this.timezone,_this.utcOffsetSeconds,_this.hourly,_this.daily);
}

@override
String toString() {
  final _this = this as Forecast;
  return 'Forecast(timezone: ${_this.timezone}, utcOffsetSeconds: ${_this.utcOffsetSeconds}, hourly: ${_this.hourly}, daily: ${_this.daily})';
}


}

/// @nodoc
abstract mixin class $ForecastCopyWith<$Res>  {
  factory $ForecastCopyWith(Forecast value, $Res Function(Forecast) _then) = _$ForecastCopyWithImpl;
@useResult
$Res call({
 String timezone, int utcOffsetSeconds, HourlySeries hourly, DailySeries daily
});


$HourlySeriesCopyWith<$Res> get hourly;$DailySeriesCopyWith<$Res> get daily;

}
/// @nodoc
class _$ForecastCopyWithImpl<$Res>
    implements $ForecastCopyWith<$Res> {
  _$ForecastCopyWithImpl(this._self, this._then);

  final Forecast _self;
  final $Res Function(Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timezone = null,Object? utcOffsetSeconds = null,Object? hourly = null,Object? daily = null,}) {
  return _then(Forecast(
timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as HourlySeries,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as DailySeries,
  ));
}
/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlySeriesCopyWith<$Res> get hourly {
  
  return $HourlySeriesCopyWith<$Res>(_self.hourly, (value) {
    return _then(_self.copyWith(hourly: value));
  });
}/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailySeriesCopyWith<$Res> get daily {
  
  return $DailySeriesCopyWith<$Res>(_self.daily, (value) {
    return _then(_self.copyWith(daily: value));
  });
}
}


/// Adds pattern-matching-related methods to [Forecast].
extension ForecastPatterns on Forecast {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Forecast value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Forecast() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Forecast value)  $default,){
final _that = this;
switch (_that) {
case _Forecast():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Forecast value)?  $default,){
final _that = this;
switch (_that) {
case _Forecast() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String timezone,  int utcOffsetSeconds,  HourlySeries hourly,  DailySeries daily)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.timezone,_that.utcOffsetSeconds,_that.hourly,_that.daily);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String timezone,  int utcOffsetSeconds,  HourlySeries hourly,  DailySeries daily)  $default,) {final _that = this;
switch (_that) {
case _Forecast():
return $default(_that.timezone,_that.utcOffsetSeconds,_that.hourly,_that.daily);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String timezone,  int utcOffsetSeconds,  HourlySeries hourly,  DailySeries daily)?  $default,) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.timezone,_that.utcOffsetSeconds,_that.hourly,_that.daily);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Forecast implements Forecast {
  const _Forecast({required this.timezone, required this.utcOffsetSeconds, required this.hourly, required this.daily});
  factory _Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);

@override final  String timezone;
@override final  int utcOffsetSeconds;
@override final  HourlySeries hourly;
@override final  DailySeries daily;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForecastCopyWith<_Forecast> get copyWith => __$ForecastCopyWithImpl<_Forecast>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ForecastToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Forecast&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.hourly, hourly) || other.hourly == hourly)&&(identical(other.daily, daily) || other.daily == daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,timezone,utcOffsetSeconds,hourly,daily);
}

@override
String toString() {
    return 'Forecast(timezone: $timezone, utcOffsetSeconds: $utcOffsetSeconds, hourly: $hourly, daily: $daily)';
}


}

/// @nodoc
abstract mixin class _$ForecastCopyWith<$Res> implements $ForecastCopyWith<$Res> {
  factory _$ForecastCopyWith(_Forecast value, $Res Function(_Forecast) _then) = __$ForecastCopyWithImpl;
@override @useResult
$Res call({
 String timezone, int utcOffsetSeconds, HourlySeries hourly, DailySeries daily
});


@override $HourlySeriesCopyWith<$Res> get hourly;@override $DailySeriesCopyWith<$Res> get daily;

}
/// @nodoc
class __$ForecastCopyWithImpl<$Res>
    implements _$ForecastCopyWith<$Res> {
  __$ForecastCopyWithImpl(this._self, this._then);

  final _Forecast _self;
  final $Res Function(_Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timezone = null,Object? utcOffsetSeconds = null,Object? hourly = null,Object? daily = null,}) {
  return _then(_Forecast(
timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as HourlySeries,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as DailySeries,
  ));
}

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HourlySeriesCopyWith<$Res> get hourly {
  
  return $HourlySeriesCopyWith<$Res>(_self.hourly, (value) {
    return _then(_self.copyWith(hourly: value));
  });
}/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailySeriesCopyWith<$Res> get daily {
  
  return $DailySeriesCopyWith<$Res>(_self.daily, (value) {
    return _then(_self.copyWith(daily: value));
  });
}
}


/// @nodoc
mixin _$HourlySeries {

 List<int> get time; List<double?> get temperatureC; List<double?> get windKmh; List<double?> get precipitationMm;/// Yüzde (0–100).
 List<double?> get precipitationProbability;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> get condition;
/// Create a copy of HourlySeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlySeriesCopyWith<HourlySeries> get copyWith => _$HourlySeriesCopyWithImpl<HourlySeries>(this as HourlySeries, _$identity);

  /// Serializes this HourlySeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HourlySeries;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlySeries&&const DeepCollectionEquality().equals(other.time, _this.time)&&const DeepCollectionEquality().equals(other.temperatureC, _this.temperatureC)&&const DeepCollectionEquality().equals(other.windKmh, _this.windKmh)&&const DeepCollectionEquality().equals(other.precipitationMm, _this.precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbability, _this.precipitationProbability)&&const DeepCollectionEquality().equals(other.condition, _this.condition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HourlySeries;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.time),const DeepCollectionEquality().hash(_this.temperatureC),const DeepCollectionEquality().hash(_this.windKmh),const DeepCollectionEquality().hash(_this.precipitationMm),const DeepCollectionEquality().hash(_this.precipitationProbability),const DeepCollectionEquality().hash(_this.condition));
}

@override
String toString() {
  final _this = this as HourlySeries;
  return 'HourlySeries(time: ${_this.time}, temperatureC: ${_this.temperatureC}, windKmh: ${_this.windKmh}, precipitationMm: ${_this.precipitationMm}, precipitationProbability: ${_this.precipitationProbability}, condition: ${_this.condition})';
}


}

/// @nodoc
abstract mixin class $HourlySeriesCopyWith<$Res>  {
  factory $HourlySeriesCopyWith(HourlySeries value, $Res Function(HourlySeries) _then) = _$HourlySeriesCopyWithImpl;
@useResult
$Res call({
 List<int> time, List<double?> temperatureC, List<double?> windKmh, List<double?> precipitationMm, List<double?> precipitationProbability,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> condition
});




}
/// @nodoc
class _$HourlySeriesCopyWithImpl<$Res>
    implements $HourlySeriesCopyWith<$Res> {
  _$HourlySeriesCopyWithImpl(this._self, this._then);

  final HourlySeries _self;
  final $Res Function(HourlySeries) _then;

/// Create a copy of HourlySeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperatureC = null,Object? windKmh = null,Object? precipitationMm = null,Object? precipitationProbability = null,Object? condition = null,}) {
  return _then(HourlySeries(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<int>,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as List<double?>,windKmh: null == windKmh ? _self.windKmh : windKmh // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as List<double?>,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as List<WeatherCondition?>,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlySeries].
extension HourlySeriesPatterns on HourlySeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlySeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlySeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlySeries value)  $default,){
final _that = this;
switch (_that) {
case _HourlySeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlySeries value)?  $default,){
final _that = this;
switch (_that) {
case _HourlySeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> time,  List<double?> temperatureC,  List<double?> windKmh,  List<double?> precipitationMm,  List<double?> precipitationProbability, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  List<WeatherCondition?> condition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlySeries() when $default != null:
return $default(_that.time,_that.temperatureC,_that.windKmh,_that.precipitationMm,_that.precipitationProbability,_that.condition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> time,  List<double?> temperatureC,  List<double?> windKmh,  List<double?> precipitationMm,  List<double?> precipitationProbability, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  List<WeatherCondition?> condition)  $default,) {final _that = this;
switch (_that) {
case _HourlySeries():
return $default(_that.time,_that.temperatureC,_that.windKmh,_that.precipitationMm,_that.precipitationProbability,_that.condition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> time,  List<double?> temperatureC,  List<double?> windKmh,  List<double?> precipitationMm,  List<double?> precipitationProbability, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  List<WeatherCondition?> condition)?  $default,) {final _that = this;
switch (_that) {
case _HourlySeries() when $default != null:
return $default(_that.time,_that.temperatureC,_that.windKmh,_that.precipitationMm,_that.precipitationProbability,_that.condition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlySeries implements HourlySeries {
  const _HourlySeries({required  List<int> time, required  List<double?> temperatureC, required  List<double?> windKmh, required  List<double?> precipitationMm, required  List<double?> precipitationProbability, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) required  List<WeatherCondition?> condition}): _time = time,_temperatureC = temperatureC,_windKmh = windKmh,_precipitationMm = precipitationMm,_precipitationProbability = precipitationProbability,_condition = condition;
  factory _HourlySeries.fromJson(Map<String, dynamic> json) => _$HourlySeriesFromJson(json);

 final  List<int> _time;
@override List<int> get time {
  if (_time is EqualUnmodifiableListView) return _time;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_time);
}

 final  List<double?> _temperatureC;
@override List<double?> get temperatureC {
  if (_temperatureC is EqualUnmodifiableListView) return _temperatureC;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperatureC);
}

 final  List<double?> _windKmh;
@override List<double?> get windKmh {
  if (_windKmh is EqualUnmodifiableListView) return _windKmh;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_windKmh);
}

 final  List<double?> _precipitationMm;
@override List<double?> get precipitationMm {
  if (_precipitationMm is EqualUnmodifiableListView) return _precipitationMm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_precipitationMm);
}

/// Yüzde (0–100).
 final  List<double?> _precipitationProbability;
/// Yüzde (0–100).
@override List<double?> get precipitationProbability {
  if (_precipitationProbability is EqualUnmodifiableListView) return _precipitationProbability;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_precipitationProbability);
}

 final  List<WeatherCondition?> _condition;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> get condition {
  if (_condition is EqualUnmodifiableListView) return _condition;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_condition);
}


/// Create a copy of HourlySeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlySeriesCopyWith<_HourlySeries> get copyWith => __$HourlySeriesCopyWithImpl<_HourlySeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlySeriesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlySeries&&const DeepCollectionEquality().equals(other.time, _time)&&const DeepCollectionEquality().equals(other.temperatureC, _temperatureC)&&const DeepCollectionEquality().equals(other.windKmh, _windKmh)&&const DeepCollectionEquality().equals(other.precipitationMm, _precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbability, _precipitationProbability)&&const DeepCollectionEquality().equals(other.condition, _condition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_temperatureC),const DeepCollectionEquality().hash(_windKmh),const DeepCollectionEquality().hash(_precipitationMm),const DeepCollectionEquality().hash(_precipitationProbability),const DeepCollectionEquality().hash(_condition));
}

@override
String toString() {
    return 'HourlySeries(time: $time, temperatureC: $temperatureC, windKmh: $windKmh, precipitationMm: $precipitationMm, precipitationProbability: $precipitationProbability, condition: $condition)';
}


}

/// @nodoc
abstract mixin class _$HourlySeriesCopyWith<$Res> implements $HourlySeriesCopyWith<$Res> {
  factory _$HourlySeriesCopyWith(_HourlySeries value, $Res Function(_HourlySeries) _then) = __$HourlySeriesCopyWithImpl;
@override @useResult
$Res call({
 List<int> time, List<double?> temperatureC, List<double?> windKmh, List<double?> precipitationMm, List<double?> precipitationProbability,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> condition
});




}
/// @nodoc
class __$HourlySeriesCopyWithImpl<$Res>
    implements _$HourlySeriesCopyWith<$Res> {
  __$HourlySeriesCopyWithImpl(this._self, this._then);

  final _HourlySeries _self;
  final $Res Function(_HourlySeries) _then;

/// Create a copy of HourlySeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperatureC = null,Object? windKmh = null,Object? precipitationMm = null,Object? precipitationProbability = null,Object? condition = null,}) {
  return _then(_HourlySeries(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<int>,temperatureC: null == temperatureC ? _self._temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as List<double?>,windKmh: null == windKmh ? _self._windKmh : windKmh // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationMm: null == precipitationMm ? _self._precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationProbability: null == precipitationProbability ? _self._precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as List<double?>,condition: null == condition ? _self._condition : condition // ignore: cast_nullable_to_non_nullable
as List<WeatherCondition?>,
  ));
}


}


/// @nodoc
mixin _$DailySeries {

 List<int> get time;@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> get condition; List<double?> get temperatureMaxC; List<double?> get temperatureMinC; List<double?> get precipitationMm; List<double?> get precipitationProbabilityMax; List<double?> get windMaxKmh;
/// Create a copy of DailySeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailySeriesCopyWith<DailySeries> get copyWith => _$DailySeriesCopyWithImpl<DailySeries>(this as DailySeries, _$identity);

  /// Serializes this DailySeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailySeries;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailySeries&&const DeepCollectionEquality().equals(other.time, _this.time)&&const DeepCollectionEquality().equals(other.condition, _this.condition)&&const DeepCollectionEquality().equals(other.temperatureMaxC, _this.temperatureMaxC)&&const DeepCollectionEquality().equals(other.temperatureMinC, _this.temperatureMinC)&&const DeepCollectionEquality().equals(other.precipitationMm, _this.precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbabilityMax, _this.precipitationProbabilityMax)&&const DeepCollectionEquality().equals(other.windMaxKmh, _this.windMaxKmh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailySeries;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.time),const DeepCollectionEquality().hash(_this.condition),const DeepCollectionEquality().hash(_this.temperatureMaxC),const DeepCollectionEquality().hash(_this.temperatureMinC),const DeepCollectionEquality().hash(_this.precipitationMm),const DeepCollectionEquality().hash(_this.precipitationProbabilityMax),const DeepCollectionEquality().hash(_this.windMaxKmh));
}

@override
String toString() {
  final _this = this as DailySeries;
  return 'DailySeries(time: ${_this.time}, condition: ${_this.condition}, temperatureMaxC: ${_this.temperatureMaxC}, temperatureMinC: ${_this.temperatureMinC}, precipitationMm: ${_this.precipitationMm}, precipitationProbabilityMax: ${_this.precipitationProbabilityMax}, windMaxKmh: ${_this.windMaxKmh})';
}


}

/// @nodoc
abstract mixin class $DailySeriesCopyWith<$Res>  {
  factory $DailySeriesCopyWith(DailySeries value, $Res Function(DailySeries) _then) = _$DailySeriesCopyWithImpl;
@useResult
$Res call({
 List<int> time,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> condition, List<double?> temperatureMaxC, List<double?> temperatureMinC, List<double?> precipitationMm, List<double?> precipitationProbabilityMax, List<double?> windMaxKmh
});




}
/// @nodoc
class _$DailySeriesCopyWithImpl<$Res>
    implements $DailySeriesCopyWith<$Res> {
  _$DailySeriesCopyWithImpl(this._self, this._then);

  final DailySeries _self;
  final $Res Function(DailySeries) _then;

/// Create a copy of DailySeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? condition = null,Object? temperatureMaxC = null,Object? temperatureMinC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? windMaxKmh = null,}) {
  return _then(DailySeries(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<int>,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as List<WeatherCondition?>,temperatureMaxC: null == temperatureMaxC ? _self.temperatureMaxC : temperatureMaxC // ignore: cast_nullable_to_non_nullable
as List<double?>,temperatureMinC: null == temperatureMinC ? _self.temperatureMinC : temperatureMinC // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationProbabilityMax: null == precipitationProbabilityMax ? _self.precipitationProbabilityMax : precipitationProbabilityMax // ignore: cast_nullable_to_non_nullable
as List<double?>,windMaxKmh: null == windMaxKmh ? _self.windMaxKmh : windMaxKmh // ignore: cast_nullable_to_non_nullable
as List<double?>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailySeries].
extension DailySeriesPatterns on DailySeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailySeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailySeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailySeries value)  $default,){
final _that = this;
switch (_that) {
case _DailySeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailySeries value)?  $default,){
final _that = this;
switch (_that) {
case _DailySeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> time, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  List<WeatherCondition?> condition,  List<double?> temperatureMaxC,  List<double?> temperatureMinC,  List<double?> precipitationMm,  List<double?> precipitationProbabilityMax,  List<double?> windMaxKmh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailySeries() when $default != null:
return $default(_that.time,_that.condition,_that.temperatureMaxC,_that.temperatureMinC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.windMaxKmh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> time, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  List<WeatherCondition?> condition,  List<double?> temperatureMaxC,  List<double?> temperatureMinC,  List<double?> precipitationMm,  List<double?> precipitationProbabilityMax,  List<double?> windMaxKmh)  $default,) {final _that = this;
switch (_that) {
case _DailySeries():
return $default(_that.time,_that.condition,_that.temperatureMaxC,_that.temperatureMinC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.windMaxKmh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> time, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)  List<WeatherCondition?> condition,  List<double?> temperatureMaxC,  List<double?> temperatureMinC,  List<double?> precipitationMm,  List<double?> precipitationProbabilityMax,  List<double?> windMaxKmh)?  $default,) {final _that = this;
switch (_that) {
case _DailySeries() when $default != null:
return $default(_that.time,_that.condition,_that.temperatureMaxC,_that.temperatureMinC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.windMaxKmh);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailySeries implements DailySeries {
  const _DailySeries({required  List<int> time, @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) required  List<WeatherCondition?> condition, required  List<double?> temperatureMaxC, required  List<double?> temperatureMinC, required  List<double?> precipitationMm, required  List<double?> precipitationProbabilityMax, required  List<double?> windMaxKmh}): _time = time,_condition = condition,_temperatureMaxC = temperatureMaxC,_temperatureMinC = temperatureMinC,_precipitationMm = precipitationMm,_precipitationProbabilityMax = precipitationProbabilityMax,_windMaxKmh = windMaxKmh;
  factory _DailySeries.fromJson(Map<String, dynamic> json) => _$DailySeriesFromJson(json);

 final  List<int> _time;
@override List<int> get time {
  if (_time is EqualUnmodifiableListView) return _time;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_time);
}

 final  List<WeatherCondition?> _condition;
@override@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> get condition {
  if (_condition is EqualUnmodifiableListView) return _condition;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_condition);
}

 final  List<double?> _temperatureMaxC;
@override List<double?> get temperatureMaxC {
  if (_temperatureMaxC is EqualUnmodifiableListView) return _temperatureMaxC;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperatureMaxC);
}

 final  List<double?> _temperatureMinC;
@override List<double?> get temperatureMinC {
  if (_temperatureMinC is EqualUnmodifiableListView) return _temperatureMinC;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temperatureMinC);
}

 final  List<double?> _precipitationMm;
@override List<double?> get precipitationMm {
  if (_precipitationMm is EqualUnmodifiableListView) return _precipitationMm;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_precipitationMm);
}

 final  List<double?> _precipitationProbabilityMax;
@override List<double?> get precipitationProbabilityMax {
  if (_precipitationProbabilityMax is EqualUnmodifiableListView) return _precipitationProbabilityMax;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_precipitationProbabilityMax);
}

 final  List<double?> _windMaxKmh;
@override List<double?> get windMaxKmh {
  if (_windMaxKmh is EqualUnmodifiableListView) return _windMaxKmh;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_windMaxKmh);
}


/// Create a copy of DailySeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailySeriesCopyWith<_DailySeries> get copyWith => __$DailySeriesCopyWithImpl<_DailySeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailySeriesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailySeries&&const DeepCollectionEquality().equals(other.time, _time)&&const DeepCollectionEquality().equals(other.condition, _condition)&&const DeepCollectionEquality().equals(other.temperatureMaxC, _temperatureMaxC)&&const DeepCollectionEquality().equals(other.temperatureMinC, _temperatureMinC)&&const DeepCollectionEquality().equals(other.precipitationMm, _precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbabilityMax, _precipitationProbabilityMax)&&const DeepCollectionEquality().equals(other.windMaxKmh, _windMaxKmh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_condition),const DeepCollectionEquality().hash(_temperatureMaxC),const DeepCollectionEquality().hash(_temperatureMinC),const DeepCollectionEquality().hash(_precipitationMm),const DeepCollectionEquality().hash(_precipitationProbabilityMax),const DeepCollectionEquality().hash(_windMaxKmh));
}

@override
String toString() {
    return 'DailySeries(time: $time, condition: $condition, temperatureMaxC: $temperatureMaxC, temperatureMinC: $temperatureMinC, precipitationMm: $precipitationMm, precipitationProbabilityMax: $precipitationProbabilityMax, windMaxKmh: $windMaxKmh)';
}


}

/// @nodoc
abstract mixin class _$DailySeriesCopyWith<$Res> implements $DailySeriesCopyWith<$Res> {
  factory _$DailySeriesCopyWith(_DailySeries value, $Res Function(_DailySeries) _then) = __$DailySeriesCopyWithImpl;
@override @useResult
$Res call({
 List<int> time,@JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue) List<WeatherCondition?> condition, List<double?> temperatureMaxC, List<double?> temperatureMinC, List<double?> precipitationMm, List<double?> precipitationProbabilityMax, List<double?> windMaxKmh
});




}
/// @nodoc
class __$DailySeriesCopyWithImpl<$Res>
    implements _$DailySeriesCopyWith<$Res> {
  __$DailySeriesCopyWithImpl(this._self, this._then);

  final _DailySeries _self;
  final $Res Function(_DailySeries) _then;

/// Create a copy of DailySeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? condition = null,Object? temperatureMaxC = null,Object? temperatureMinC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? windMaxKmh = null,}) {
  return _then(_DailySeries(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<int>,condition: null == condition ? _self._condition : condition // ignore: cast_nullable_to_non_nullable
as List<WeatherCondition?>,temperatureMaxC: null == temperatureMaxC ? _self._temperatureMaxC : temperatureMaxC // ignore: cast_nullable_to_non_nullable
as List<double?>,temperatureMinC: null == temperatureMinC ? _self._temperatureMinC : temperatureMinC // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationMm: null == precipitationMm ? _self._precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationProbabilityMax: null == precipitationProbabilityMax ? _self._precipitationProbabilityMax : precipitationProbabilityMax // ignore: cast_nullable_to_non_nullable
as List<double?>,windMaxKmh: null == windMaxKmh ? _self._windMaxKmh : windMaxKmh // ignore: cast_nullable_to_non_nullable
as List<double?>,
  ));
}


}

// dart format on
