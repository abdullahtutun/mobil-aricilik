// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeatherBundle _$WeatherBundleFromJson(Map<String, dynamic> json) =>
    _WeatherBundle(
      generatedAt: DateTime.parse(json['generated_at'] as String),
      forecasts: (json['forecasts'] as List<dynamic>)
          .map((e) => ApiaryForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeatherBundleToJson(_WeatherBundle instance) =>
    <String, dynamic>{
      'generated_at': instance.generatedAt.toIso8601String(),
      'forecasts': instance.forecasts,
    };

_ApiaryForecast _$ApiaryForecastFromJson(Map<String, dynamic> json) =>
    _ApiaryForecast(
      apiaryId: json['apiary_id'] as String,
      cell: json['cell'] as String,
      fetchedAt: DateTime.parse(json['fetched_at'] as String),
      forecast: Forecast.fromJson(json['forecast'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiaryForecastToJson(_ApiaryForecast instance) =>
    <String, dynamic>{
      'apiary_id': instance.apiaryId,
      'cell': instance.cell,
      'fetched_at': instance.fetchedAt.toIso8601String(),
      'forecast': instance.forecast,
    };

_Forecast _$ForecastFromJson(Map<String, dynamic> json) => _Forecast(
  timezone: json['timezone'] as String,
  utcOffsetSeconds: (json['utc_offset_seconds'] as num).toInt(),
  hourly: HourlySeries.fromJson(json['hourly'] as Map<String, dynamic>),
  daily: DailySeries.fromJson(json['daily'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ForecastToJson(_Forecast instance) => <String, dynamic>{
  'timezone': instance.timezone,
  'utc_offset_seconds': instance.utcOffsetSeconds,
  'hourly': instance.hourly,
  'daily': instance.daily,
};

_HourlySeries _$HourlySeriesFromJson(
  Map<String, dynamic> json,
) => _HourlySeries(
  time: (json['time'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  temperatureC: (json['temperature_c'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
  windKmh: (json['wind_kmh'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
  precipitationMm: (json['precipitation_mm'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
  precipitationProbability: (json['precipitation_probability'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
  condition: (json['condition'] as List<dynamic>)
      .map(
        (e) => $enumDecodeNullable(
          _$WeatherConditionEnumMap,
          e,
          unknownValue: JsonKey.nullForUndefinedEnumValue,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$HourlySeriesToJson(_HourlySeries instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_c': instance.temperatureC,
      'wind_kmh': instance.windKmh,
      'precipitation_mm': instance.precipitationMm,
      'precipitation_probability': instance.precipitationProbability,
      'condition': instance.condition
          .map((e) => _$WeatherConditionEnumMap[e])
          .toList(),
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'clear',
  WeatherCondition.partlyCloudy: 'partly_cloudy',
  WeatherCondition.cloudy: 'cloudy',
  WeatherCondition.fog: 'fog',
  WeatherCondition.rain: 'rain',
  WeatherCondition.snow: 'snow',
  WeatherCondition.thunder: 'thunder',
};

_DailySeries _$DailySeriesFromJson(Map<String, dynamic> json) => _DailySeries(
  time: (json['time'] as List<dynamic>).map((e) => (e as num).toInt()).toList(),
  condition: (json['condition'] as List<dynamic>)
      .map(
        (e) => $enumDecodeNullable(
          _$WeatherConditionEnumMap,
          e,
          unknownValue: JsonKey.nullForUndefinedEnumValue,
        ),
      )
      .toList(),
  temperatureMaxC: (json['temperature_max_c'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
  temperatureMinC: (json['temperature_min_c'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
  precipitationMm: (json['precipitation_mm'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
  precipitationProbabilityMax:
      (json['precipitation_probability_max'] as List<dynamic>)
          .map((e) => (e as num?)?.toDouble())
          .toList(),
  windMaxKmh: (json['wind_max_kmh'] as List<dynamic>)
      .map((e) => (e as num?)?.toDouble())
      .toList(),
);

Map<String, dynamic> _$DailySeriesToJson(_DailySeries instance) =>
    <String, dynamic>{
      'time': instance.time,
      'condition': instance.condition
          .map((e) => _$WeatherConditionEnumMap[e])
          .toList(),
      'temperature_max_c': instance.temperatureMaxC,
      'temperature_min_c': instance.temperatureMinC,
      'precipitation_mm': instance.precipitationMm,
      'precipitation_probability_max': instance.precipitationProbabilityMax,
      'wind_max_kmh': instance.windMaxKmh,
    };
