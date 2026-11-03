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

 String get timezone; int get utcOffsetSeconds; CurrentWeather get current;/// WeatherAPI'nin yer adı (genelde ilçe) ve bölgesi (il).
 String? get place; String? get region; HourlySeries get hourly; DailySeries get daily;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Forecast&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.utcOffsetSeconds, _this.utcOffsetSeconds) || other.utcOffsetSeconds == _this.utcOffsetSeconds)&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.place, _this.place) || other.place == _this.place)&&(identical(other.region, _this.region) || other.region == _this.region)&&(identical(other.hourly, _this.hourly) || other.hourly == _this.hourly)&&(identical(other.daily, _this.daily) || other.daily == _this.daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Forecast;
  return Object.hash(runtimeType,_this.timezone,_this.utcOffsetSeconds,_this.current,_this.place,_this.region,_this.hourly,_this.daily);
}

@override
String toString() {
  final _this = this as Forecast;
  return 'Forecast(timezone: ${_this.timezone}, utcOffsetSeconds: ${_this.utcOffsetSeconds}, current: ${_this.current}, place: ${_this.place}, region: ${_this.region}, hourly: ${_this.hourly}, daily: ${_this.daily})';
}


}

/// @nodoc
abstract mixin class $ForecastCopyWith<$Res>  {
  factory $ForecastCopyWith(Forecast value, $Res Function(Forecast) _then) = _$ForecastCopyWithImpl;
@useResult
$Res call({
 String timezone, int utcOffsetSeconds, CurrentWeather current, String? place, String? region, HourlySeries hourly, DailySeries daily
});


$CurrentWeatherCopyWith<$Res> get current;$HourlySeriesCopyWith<$Res> get hourly;$DailySeriesCopyWith<$Res> get daily;

}
/// @nodoc
class _$ForecastCopyWithImpl<$Res>
    implements $ForecastCopyWith<$Res> {
  _$ForecastCopyWithImpl(this._self, this._then);

  final Forecast _self;
  final $Res Function(Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timezone = null,Object? utcOffsetSeconds = null,Object? current = null,Object? place = freezed,Object? region = freezed,Object? hourly = null,Object? daily = null,}) {
  return _then(Forecast(
timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurrentWeather,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as HourlySeries,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as DailySeries,
  ));
}
/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<$Res> get current {
  
  return $CurrentWeatherCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of Forecast
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String timezone,  int utcOffsetSeconds,  CurrentWeather current,  String? place,  String? region,  HourlySeries hourly,  DailySeries daily)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.timezone,_that.utcOffsetSeconds,_that.current,_that.place,_that.region,_that.hourly,_that.daily);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String timezone,  int utcOffsetSeconds,  CurrentWeather current,  String? place,  String? region,  HourlySeries hourly,  DailySeries daily)  $default,) {final _that = this;
switch (_that) {
case _Forecast():
return $default(_that.timezone,_that.utcOffsetSeconds,_that.current,_that.place,_that.region,_that.hourly,_that.daily);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String timezone,  int utcOffsetSeconds,  CurrentWeather current,  String? place,  String? region,  HourlySeries hourly,  DailySeries daily)?  $default,) {final _that = this;
switch (_that) {
case _Forecast() when $default != null:
return $default(_that.timezone,_that.utcOffsetSeconds,_that.current,_that.place,_that.region,_that.hourly,_that.daily);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Forecast implements Forecast {
  const _Forecast({required this.timezone, required this.utcOffsetSeconds, required this.current, this.place, this.region, required this.hourly, required this.daily});
  factory _Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);

@override final  String timezone;
@override final  int utcOffsetSeconds;
@override final  CurrentWeather current;
/// WeatherAPI'nin yer adı (genelde ilçe) ve bölgesi (il).
@override final  String? place;
@override final  String? region;
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Forecast&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.utcOffsetSeconds, utcOffsetSeconds) || other.utcOffsetSeconds == utcOffsetSeconds)&&(identical(other.current, current) || other.current == current)&&(identical(other.place, place) || other.place == place)&&(identical(other.region, region) || other.region == region)&&(identical(other.hourly, hourly) || other.hourly == hourly)&&(identical(other.daily, daily) || other.daily == daily));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,timezone,utcOffsetSeconds,current,place,region,hourly,daily);
}

@override
String toString() {
    return 'Forecast(timezone: $timezone, utcOffsetSeconds: $utcOffsetSeconds, current: $current, place: $place, region: $region, hourly: $hourly, daily: $daily)';
}


}

/// @nodoc
abstract mixin class _$ForecastCopyWith<$Res> implements $ForecastCopyWith<$Res> {
  factory _$ForecastCopyWith(_Forecast value, $Res Function(_Forecast) _then) = __$ForecastCopyWithImpl;
@override @useResult
$Res call({
 String timezone, int utcOffsetSeconds, CurrentWeather current, String? place, String? region, HourlySeries hourly, DailySeries daily
});


@override $CurrentWeatherCopyWith<$Res> get current;@override $HourlySeriesCopyWith<$Res> get hourly;@override $DailySeriesCopyWith<$Res> get daily;

}
/// @nodoc
class __$ForecastCopyWithImpl<$Res>
    implements _$ForecastCopyWith<$Res> {
  __$ForecastCopyWithImpl(this._self, this._then);

  final _Forecast _self;
  final $Res Function(_Forecast) _then;

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timezone = null,Object? utcOffsetSeconds = null,Object? current = null,Object? place = freezed,Object? region = freezed,Object? hourly = null,Object? daily = null,}) {
  return _then(_Forecast(
timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,utcOffsetSeconds: null == utcOffsetSeconds ? _self.utcOffsetSeconds : utcOffsetSeconds // ignore: cast_nullable_to_non_nullable
as int,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as CurrentWeather,place: freezed == place ? _self.place : place // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as HourlySeries,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as DailySeries,
  ));
}

/// Create a copy of Forecast
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<$Res> get current {
  
  return $CurrentWeatherCopyWith<$Res>(_self.current, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of Forecast
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
mixin _$CurrentWeather {

 int get time; double? get temperatureC; double? get feelsLikeC;/// Bağıl nem, yüzde (0–100).
 double? get humidity; double? get windKmh; double? get precipitationMm; int? get conditionCode;
/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CurrentWeatherCopyWith<CurrentWeather> get copyWith => _$CurrentWeatherCopyWithImpl<CurrentWeather>(this as CurrentWeather, _$identity);

  /// Serializes this CurrentWeather to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CurrentWeather;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CurrentWeather&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.temperatureC, _this.temperatureC) || other.temperatureC == _this.temperatureC)&&(identical(other.feelsLikeC, _this.feelsLikeC) || other.feelsLikeC == _this.feelsLikeC)&&(identical(other.humidity, _this.humidity) || other.humidity == _this.humidity)&&(identical(other.windKmh, _this.windKmh) || other.windKmh == _this.windKmh)&&(identical(other.precipitationMm, _this.precipitationMm) || other.precipitationMm == _this.precipitationMm)&&(identical(other.conditionCode, _this.conditionCode) || other.conditionCode == _this.conditionCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CurrentWeather;
  return Object.hash(runtimeType,_this.time,_this.temperatureC,_this.feelsLikeC,_this.humidity,_this.windKmh,_this.precipitationMm,_this.conditionCode);
}

@override
String toString() {
  final _this = this as CurrentWeather;
  return 'CurrentWeather(time: ${_this.time}, temperatureC: ${_this.temperatureC}, feelsLikeC: ${_this.feelsLikeC}, humidity: ${_this.humidity}, windKmh: ${_this.windKmh}, precipitationMm: ${_this.precipitationMm}, conditionCode: ${_this.conditionCode})';
}


}

/// @nodoc
abstract mixin class $CurrentWeatherCopyWith<$Res>  {
  factory $CurrentWeatherCopyWith(CurrentWeather value, $Res Function(CurrentWeather) _then) = _$CurrentWeatherCopyWithImpl;
@useResult
$Res call({
 int time, double? temperatureC, double? feelsLikeC, double? humidity, double? windKmh, double? precipitationMm, int? conditionCode
});




}
/// @nodoc
class _$CurrentWeatherCopyWithImpl<$Res>
    implements $CurrentWeatherCopyWith<$Res> {
  _$CurrentWeatherCopyWithImpl(this._self, this._then);

  final CurrentWeather _self;
  final $Res Function(CurrentWeather) _then;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperatureC = freezed,Object? feelsLikeC = freezed,Object? humidity = freezed,Object? windKmh = freezed,Object? precipitationMm = freezed,Object? conditionCode = freezed,}) {
  return _then(CurrentWeather(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,temperatureC: freezed == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as double?,feelsLikeC: freezed == feelsLikeC ? _self.feelsLikeC : feelsLikeC // ignore: cast_nullable_to_non_nullable
as double?,humidity: freezed == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as double?,windKmh: freezed == windKmh ? _self.windKmh : windKmh // ignore: cast_nullable_to_non_nullable
as double?,precipitationMm: freezed == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double?,conditionCode: freezed == conditionCode ? _self.conditionCode : conditionCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CurrentWeather].
extension CurrentWeatherPatterns on CurrentWeather {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CurrentWeather value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CurrentWeather value)  $default,){
final _that = this;
switch (_that) {
case _CurrentWeather():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CurrentWeather value)?  $default,){
final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int time,  double? temperatureC,  double? feelsLikeC,  double? humidity,  double? windKmh,  double? precipitationMm,  int? conditionCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
return $default(_that.time,_that.temperatureC,_that.feelsLikeC,_that.humidity,_that.windKmh,_that.precipitationMm,_that.conditionCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int time,  double? temperatureC,  double? feelsLikeC,  double? humidity,  double? windKmh,  double? precipitationMm,  int? conditionCode)  $default,) {final _that = this;
switch (_that) {
case _CurrentWeather():
return $default(_that.time,_that.temperatureC,_that.feelsLikeC,_that.humidity,_that.windKmh,_that.precipitationMm,_that.conditionCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int time,  double? temperatureC,  double? feelsLikeC,  double? humidity,  double? windKmh,  double? precipitationMm,  int? conditionCode)?  $default,) {final _that = this;
switch (_that) {
case _CurrentWeather() when $default != null:
return $default(_that.time,_that.temperatureC,_that.feelsLikeC,_that.humidity,_that.windKmh,_that.precipitationMm,_that.conditionCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CurrentWeather implements CurrentWeather {
  const _CurrentWeather({required this.time, this.temperatureC, this.feelsLikeC, this.humidity, this.windKmh, this.precipitationMm, this.conditionCode});
  factory _CurrentWeather.fromJson(Map<String, dynamic> json) => _$CurrentWeatherFromJson(json);

@override final  int time;
@override final  double? temperatureC;
@override final  double? feelsLikeC;
/// Bağıl nem, yüzde (0–100).
@override final  double? humidity;
@override final  double? windKmh;
@override final  double? precipitationMm;
@override final  int? conditionCode;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CurrentWeatherCopyWith<_CurrentWeather> get copyWith => __$CurrentWeatherCopyWithImpl<_CurrentWeather>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CurrentWeatherToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CurrentWeather&&(identical(other.time, time) || other.time == time)&&(identical(other.temperatureC, temperatureC) || other.temperatureC == temperatureC)&&(identical(other.feelsLikeC, feelsLikeC) || other.feelsLikeC == feelsLikeC)&&(identical(other.humidity, humidity) || other.humidity == humidity)&&(identical(other.windKmh, windKmh) || other.windKmh == windKmh)&&(identical(other.precipitationMm, precipitationMm) || other.precipitationMm == precipitationMm)&&(identical(other.conditionCode, conditionCode) || other.conditionCode == conditionCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,time,temperatureC,feelsLikeC,humidity,windKmh,precipitationMm,conditionCode);
}

@override
String toString() {
    return 'CurrentWeather(time: $time, temperatureC: $temperatureC, feelsLikeC: $feelsLikeC, humidity: $humidity, windKmh: $windKmh, precipitationMm: $precipitationMm, conditionCode: $conditionCode)';
}


}

/// @nodoc
abstract mixin class _$CurrentWeatherCopyWith<$Res> implements $CurrentWeatherCopyWith<$Res> {
  factory _$CurrentWeatherCopyWith(_CurrentWeather value, $Res Function(_CurrentWeather) _then) = __$CurrentWeatherCopyWithImpl;
@override @useResult
$Res call({
 int time, double? temperatureC, double? feelsLikeC, double? humidity, double? windKmh, double? precipitationMm, int? conditionCode
});




}
/// @nodoc
class __$CurrentWeatherCopyWithImpl<$Res>
    implements _$CurrentWeatherCopyWith<$Res> {
  __$CurrentWeatherCopyWithImpl(this._self, this._then);

  final _CurrentWeather _self;
  final $Res Function(_CurrentWeather) _then;

/// Create a copy of CurrentWeather
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperatureC = freezed,Object? feelsLikeC = freezed,Object? humidity = freezed,Object? windKmh = freezed,Object? precipitationMm = freezed,Object? conditionCode = freezed,}) {
  return _then(_CurrentWeather(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,temperatureC: freezed == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as double?,feelsLikeC: freezed == feelsLikeC ? _self.feelsLikeC : feelsLikeC // ignore: cast_nullable_to_non_nullable
as double?,humidity: freezed == humidity ? _self.humidity : humidity // ignore: cast_nullable_to_non_nullable
as double?,windKmh: freezed == windKmh ? _self.windKmh : windKmh // ignore: cast_nullable_to_non_nullable
as double?,precipitationMm: freezed == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as double?,conditionCode: freezed == conditionCode ? _self.conditionCode : conditionCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$HourlySeries {

 List<int> get time; List<double?> get temperatureC; List<double?> get windKmh; List<double?> get precipitationMm;/// Yüzde (0–100).
 List<double?> get precipitationProbability; List<int?> get conditionCode;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlySeries&&const DeepCollectionEquality().equals(other.time, _this.time)&&const DeepCollectionEquality().equals(other.temperatureC, _this.temperatureC)&&const DeepCollectionEquality().equals(other.windKmh, _this.windKmh)&&const DeepCollectionEquality().equals(other.precipitationMm, _this.precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbability, _this.precipitationProbability)&&const DeepCollectionEquality().equals(other.conditionCode, _this.conditionCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HourlySeries;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.time),const DeepCollectionEquality().hash(_this.temperatureC),const DeepCollectionEquality().hash(_this.windKmh),const DeepCollectionEquality().hash(_this.precipitationMm),const DeepCollectionEquality().hash(_this.precipitationProbability),const DeepCollectionEquality().hash(_this.conditionCode));
}

@override
String toString() {
  final _this = this as HourlySeries;
  return 'HourlySeries(time: ${_this.time}, temperatureC: ${_this.temperatureC}, windKmh: ${_this.windKmh}, precipitationMm: ${_this.precipitationMm}, precipitationProbability: ${_this.precipitationProbability}, conditionCode: ${_this.conditionCode})';
}


}

/// @nodoc
abstract mixin class $HourlySeriesCopyWith<$Res>  {
  factory $HourlySeriesCopyWith(HourlySeries value, $Res Function(HourlySeries) _then) = _$HourlySeriesCopyWithImpl;
@useResult
$Res call({
 List<int> time, List<double?> temperatureC, List<double?> windKmh, List<double?> precipitationMm, List<double?> precipitationProbability, List<int?> conditionCode
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
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? temperatureC = null,Object? windKmh = null,Object? precipitationMm = null,Object? precipitationProbability = null,Object? conditionCode = null,}) {
  return _then(HourlySeries(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<int>,temperatureC: null == temperatureC ? _self.temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as List<double?>,windKmh: null == windKmh ? _self.windKmh : windKmh // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationMm: null == precipitationMm ? _self.precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationProbability: null == precipitationProbability ? _self.precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as List<double?>,conditionCode: null == conditionCode ? _self.conditionCode : conditionCode // ignore: cast_nullable_to_non_nullable
as List<int?>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> time,  List<double?> temperatureC,  List<double?> windKmh,  List<double?> precipitationMm,  List<double?> precipitationProbability,  List<int?> conditionCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlySeries() when $default != null:
return $default(_that.time,_that.temperatureC,_that.windKmh,_that.precipitationMm,_that.precipitationProbability,_that.conditionCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> time,  List<double?> temperatureC,  List<double?> windKmh,  List<double?> precipitationMm,  List<double?> precipitationProbability,  List<int?> conditionCode)  $default,) {final _that = this;
switch (_that) {
case _HourlySeries():
return $default(_that.time,_that.temperatureC,_that.windKmh,_that.precipitationMm,_that.precipitationProbability,_that.conditionCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> time,  List<double?> temperatureC,  List<double?> windKmh,  List<double?> precipitationMm,  List<double?> precipitationProbability,  List<int?> conditionCode)?  $default,) {final _that = this;
switch (_that) {
case _HourlySeries() when $default != null:
return $default(_that.time,_that.temperatureC,_that.windKmh,_that.precipitationMm,_that.precipitationProbability,_that.conditionCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlySeries implements HourlySeries {
  const _HourlySeries({required  List<int> time, required  List<double?> temperatureC, required  List<double?> windKmh, required  List<double?> precipitationMm, required  List<double?> precipitationProbability, required  List<int?> conditionCode}): _time = time,_temperatureC = temperatureC,_windKmh = windKmh,_precipitationMm = precipitationMm,_precipitationProbability = precipitationProbability,_conditionCode = conditionCode;
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

 final  List<int?> _conditionCode;
@override List<int?> get conditionCode {
  if (_conditionCode is EqualUnmodifiableListView) return _conditionCode;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditionCode);
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlySeries&&const DeepCollectionEquality().equals(other.time, _time)&&const DeepCollectionEquality().equals(other.temperatureC, _temperatureC)&&const DeepCollectionEquality().equals(other.windKmh, _windKmh)&&const DeepCollectionEquality().equals(other.precipitationMm, _precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbability, _precipitationProbability)&&const DeepCollectionEquality().equals(other.conditionCode, _conditionCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_temperatureC),const DeepCollectionEquality().hash(_windKmh),const DeepCollectionEquality().hash(_precipitationMm),const DeepCollectionEquality().hash(_precipitationProbability),const DeepCollectionEquality().hash(_conditionCode));
}

@override
String toString() {
    return 'HourlySeries(time: $time, temperatureC: $temperatureC, windKmh: $windKmh, precipitationMm: $precipitationMm, precipitationProbability: $precipitationProbability, conditionCode: $conditionCode)';
}


}

/// @nodoc
abstract mixin class _$HourlySeriesCopyWith<$Res> implements $HourlySeriesCopyWith<$Res> {
  factory _$HourlySeriesCopyWith(_HourlySeries value, $Res Function(_HourlySeries) _then) = __$HourlySeriesCopyWithImpl;
@override @useResult
$Res call({
 List<int> time, List<double?> temperatureC, List<double?> windKmh, List<double?> precipitationMm, List<double?> precipitationProbability, List<int?> conditionCode
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
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? temperatureC = null,Object? windKmh = null,Object? precipitationMm = null,Object? precipitationProbability = null,Object? conditionCode = null,}) {
  return _then(_HourlySeries(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<int>,temperatureC: null == temperatureC ? _self._temperatureC : temperatureC // ignore: cast_nullable_to_non_nullable
as List<double?>,windKmh: null == windKmh ? _self._windKmh : windKmh // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationMm: null == precipitationMm ? _self._precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationProbability: null == precipitationProbability ? _self._precipitationProbability : precipitationProbability // ignore: cast_nullable_to_non_nullable
as List<double?>,conditionCode: null == conditionCode ? _self._conditionCode : conditionCode // ignore: cast_nullable_to_non_nullable
as List<int?>,
  ));
}


}


/// @nodoc
mixin _$DailySeries {

 List<int> get time; List<int?> get conditionCode; List<double?> get temperatureMaxC; List<double?> get temperatureMinC; List<double?> get precipitationMm; List<double?> get precipitationProbabilityMax; List<double?> get windMaxKmh;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailySeries&&const DeepCollectionEquality().equals(other.time, _this.time)&&const DeepCollectionEquality().equals(other.conditionCode, _this.conditionCode)&&const DeepCollectionEquality().equals(other.temperatureMaxC, _this.temperatureMaxC)&&const DeepCollectionEquality().equals(other.temperatureMinC, _this.temperatureMinC)&&const DeepCollectionEquality().equals(other.precipitationMm, _this.precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbabilityMax, _this.precipitationProbabilityMax)&&const DeepCollectionEquality().equals(other.windMaxKmh, _this.windMaxKmh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailySeries;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.time),const DeepCollectionEquality().hash(_this.conditionCode),const DeepCollectionEquality().hash(_this.temperatureMaxC),const DeepCollectionEquality().hash(_this.temperatureMinC),const DeepCollectionEquality().hash(_this.precipitationMm),const DeepCollectionEquality().hash(_this.precipitationProbabilityMax),const DeepCollectionEquality().hash(_this.windMaxKmh));
}

@override
String toString() {
  final _this = this as DailySeries;
  return 'DailySeries(time: ${_this.time}, conditionCode: ${_this.conditionCode}, temperatureMaxC: ${_this.temperatureMaxC}, temperatureMinC: ${_this.temperatureMinC}, precipitationMm: ${_this.precipitationMm}, precipitationProbabilityMax: ${_this.precipitationProbabilityMax}, windMaxKmh: ${_this.windMaxKmh})';
}


}

/// @nodoc
abstract mixin class $DailySeriesCopyWith<$Res>  {
  factory $DailySeriesCopyWith(DailySeries value, $Res Function(DailySeries) _then) = _$DailySeriesCopyWithImpl;
@useResult
$Res call({
 List<int> time, List<int?> conditionCode, List<double?> temperatureMaxC, List<double?> temperatureMinC, List<double?> precipitationMm, List<double?> precipitationProbabilityMax, List<double?> windMaxKmh
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
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? conditionCode = null,Object? temperatureMaxC = null,Object? temperatureMinC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? windMaxKmh = null,}) {
  return _then(DailySeries(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as List<int>,conditionCode: null == conditionCode ? _self.conditionCode : conditionCode // ignore: cast_nullable_to_non_nullable
as List<int?>,temperatureMaxC: null == temperatureMaxC ? _self.temperatureMaxC : temperatureMaxC // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<int> time,  List<int?> conditionCode,  List<double?> temperatureMaxC,  List<double?> temperatureMinC,  List<double?> precipitationMm,  List<double?> precipitationProbabilityMax,  List<double?> windMaxKmh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailySeries() when $default != null:
return $default(_that.time,_that.conditionCode,_that.temperatureMaxC,_that.temperatureMinC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.windMaxKmh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<int> time,  List<int?> conditionCode,  List<double?> temperatureMaxC,  List<double?> temperatureMinC,  List<double?> precipitationMm,  List<double?> precipitationProbabilityMax,  List<double?> windMaxKmh)  $default,) {final _that = this;
switch (_that) {
case _DailySeries():
return $default(_that.time,_that.conditionCode,_that.temperatureMaxC,_that.temperatureMinC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.windMaxKmh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<int> time,  List<int?> conditionCode,  List<double?> temperatureMaxC,  List<double?> temperatureMinC,  List<double?> precipitationMm,  List<double?> precipitationProbabilityMax,  List<double?> windMaxKmh)?  $default,) {final _that = this;
switch (_that) {
case _DailySeries() when $default != null:
return $default(_that.time,_that.conditionCode,_that.temperatureMaxC,_that.temperatureMinC,_that.precipitationMm,_that.precipitationProbabilityMax,_that.windMaxKmh);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailySeries implements DailySeries {
  const _DailySeries({required  List<int> time, required  List<int?> conditionCode, required  List<double?> temperatureMaxC, required  List<double?> temperatureMinC, required  List<double?> precipitationMm, required  List<double?> precipitationProbabilityMax, required  List<double?> windMaxKmh}): _time = time,_conditionCode = conditionCode,_temperatureMaxC = temperatureMaxC,_temperatureMinC = temperatureMinC,_precipitationMm = precipitationMm,_precipitationProbabilityMax = precipitationProbabilityMax,_windMaxKmh = windMaxKmh;
  factory _DailySeries.fromJson(Map<String, dynamic> json) => _$DailySeriesFromJson(json);

 final  List<int> _time;
@override List<int> get time {
  if (_time is EqualUnmodifiableListView) return _time;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_time);
}

 final  List<int?> _conditionCode;
@override List<int?> get conditionCode {
  if (_conditionCode is EqualUnmodifiableListView) return _conditionCode;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditionCode);
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailySeries&&const DeepCollectionEquality().equals(other.time, _time)&&const DeepCollectionEquality().equals(other.conditionCode, _conditionCode)&&const DeepCollectionEquality().equals(other.temperatureMaxC, _temperatureMaxC)&&const DeepCollectionEquality().equals(other.temperatureMinC, _temperatureMinC)&&const DeepCollectionEquality().equals(other.precipitationMm, _precipitationMm)&&const DeepCollectionEquality().equals(other.precipitationProbabilityMax, _precipitationProbabilityMax)&&const DeepCollectionEquality().equals(other.windMaxKmh, _windMaxKmh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_time),const DeepCollectionEquality().hash(_conditionCode),const DeepCollectionEquality().hash(_temperatureMaxC),const DeepCollectionEquality().hash(_temperatureMinC),const DeepCollectionEquality().hash(_precipitationMm),const DeepCollectionEquality().hash(_precipitationProbabilityMax),const DeepCollectionEquality().hash(_windMaxKmh));
}

@override
String toString() {
    return 'DailySeries(time: $time, conditionCode: $conditionCode, temperatureMaxC: $temperatureMaxC, temperatureMinC: $temperatureMinC, precipitationMm: $precipitationMm, precipitationProbabilityMax: $precipitationProbabilityMax, windMaxKmh: $windMaxKmh)';
}


}

/// @nodoc
abstract mixin class _$DailySeriesCopyWith<$Res> implements $DailySeriesCopyWith<$Res> {
  factory _$DailySeriesCopyWith(_DailySeries value, $Res Function(_DailySeries) _then) = __$DailySeriesCopyWithImpl;
@override @useResult
$Res call({
 List<int> time, List<int?> conditionCode, List<double?> temperatureMaxC, List<double?> temperatureMinC, List<double?> precipitationMm, List<double?> precipitationProbabilityMax, List<double?> windMaxKmh
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
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? conditionCode = null,Object? temperatureMaxC = null,Object? temperatureMinC = null,Object? precipitationMm = null,Object? precipitationProbabilityMax = null,Object? windMaxKmh = null,}) {
  return _then(_DailySeries(
time: null == time ? _self._time : time // ignore: cast_nullable_to_non_nullable
as List<int>,conditionCode: null == conditionCode ? _self._conditionCode : conditionCode // ignore: cast_nullable_to_non_nullable
as List<int?>,temperatureMaxC: null == temperatureMaxC ? _self._temperatureMaxC : temperatureMaxC // ignore: cast_nullable_to_non_nullable
as List<double?>,temperatureMinC: null == temperatureMinC ? _self._temperatureMinC : temperatureMinC // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationMm: null == precipitationMm ? _self._precipitationMm : precipitationMm // ignore: cast_nullable_to_non_nullable
as List<double?>,precipitationProbabilityMax: null == precipitationProbabilityMax ? _self._precipitationProbabilityMax : precipitationProbabilityMax // ignore: cast_nullable_to_non_nullable
as List<double?>,windMaxKmh: null == windMaxKmh ? _self._windMaxKmh : windMaxKmh // ignore: cast_nullable_to_non_nullable
as List<double?>,
  ));
}


}

// dart format on
