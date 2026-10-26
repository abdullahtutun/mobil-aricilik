import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_bundle.freezed.dart';
part 'weather_bundle.g.dart';

/// `weather-bundle` Edge Function'ının yanıtı: işletmenin konumlu
/// arılıkları için 7 günlük Open-Meteo tahmini. Telefonda son alınan paket
/// saklanır; çevrimdışıyken o gösterilir.
@freezed
abstract class WeatherBundle with _$WeatherBundle {
  const factory({
    required DateTime generatedAt,
    required List<ApiaryForecast> forecasts,
  }) = _WeatherBundle;

  factory fromJson(Map<String, Object?> json) => _$WeatherBundleFromJson(json);
}

/// Bir arılığın tahmini. [cell] 0,01°'lik hücre ("37.11,28.39"); yakın
/// arılıklar aynı tahmini paylaşır.
@freezed
abstract class ApiaryForecast with _$ApiaryForecast {
  const factory({
    required String apiaryId,
    required String cell,
    required DateTime fetchedAt,
    required Forecast forecast,
  }) = _ApiaryForecast;

  factory fromJson(Map<String, Object?> json) => _$ApiaryForecastFromJson(json);
}

/// Open-Meteo tahmini, sütunlar hâlinde. Saatler Unix saniyesi; günler
/// arılığın saat dilimindeki gece yarısı. Open-Meteo bazı değerleri boş
/// verebilir.
@freezed
abstract class Forecast with _$Forecast {
  const factory({
    required String timezone,
    required int utcOffsetSeconds,
    required HourlySeries hourly,
    required DailySeries daily,
  }) = _Forecast;

  factory fromJson(Map<String, Object?> json) => _$ForecastFromJson(json);
}

/// Bir saatin tahmini.
typedef HourlyWeather = ({
  double? temperatureC,
  double? windKmh,
  double? precipitationMm,
  double? precipitationProbability,
  int? weatherCode,
});

/// Saatlik sütunlar; hepsi [time] ile aynı uzunlukta.
@freezed
abstract class HourlySeries with _$HourlySeries {
  const factory({
    required List<int> time,
    required List<double?> temperatureC,
    required List<double?> windKmh,
    required List<double?> precipitationMm,

    /// Yüzde (0–100).
    required List<double?> precipitationProbability,

    /// WMO hava kodu.
    required List<int?> weatherCode,
  }) = _HourlySeries;

  factory fromJson(Map<String, Object?> json) => _$HourlySeriesFromJson(json);
}

/// Günlük sütunlar; hepsi [time] ile aynı uzunlukta.
@freezed
abstract class DailySeries with _$DailySeries {
  const factory({
    required List<int> time,
    required List<int?> weatherCode,
    required List<double?> temperatureMaxC,
    required List<double?> temperatureMinC,
    required List<double?> precipitationMm,
    required List<double?> precipitationProbabilityMax,
    required List<double?> windMaxKmh,
  }) = _DailySeries;

  factory fromJson(Map<String, Object?> json) => _$DailySeriesFromJson(json);
}
