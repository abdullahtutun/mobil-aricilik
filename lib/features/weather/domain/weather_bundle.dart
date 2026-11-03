import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_bundle.freezed.dart';
part 'weather_bundle.g.dart';

/// `weather-bundle` Edge Function'ının yanıtı: işletmenin konumlu
/// arılıkları için WeatherAPI.com tahmini (sunucunun istediği kadar gün,
/// planın sınırıyla; gün sayısı sabit değil). Telefonda son alınan paket
/// saklanır; çevrimdışıyken o gösterilir. Birimler metrik.
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

/// Tahmin, sütunlar hâlinde. Saatler Unix saniyesi; günler arılığın saat
/// dilimindeki gece yarısı. Sağlayıcı bazı değerleri boş verebilir. Durum
/// kodları WeatherAPI'nin `condition.code`'u; simgeye `weatherIconFor`
/// çevirir.
@freezed
abstract class Forecast with _$Forecast {
  const factory({
    required String timezone,
    required int utcOffsetSeconds,
    required CurrentWeather current,
    required HourlySeries hourly,
    required DailySeries daily,

    /// WeatherAPI'nin yer adı (genelde ilçe) ve bölgesi (il).
    String? place,
    String? region,
  }) = _Forecast;

  factory fromJson(Map<String, Object?> json) => _$ForecastFromJson(json);
}

/// Sağlayıcının son ölçümü (`time` Unix saniyesi).
@freezed
abstract class CurrentWeather with _$CurrentWeather {
  const factory({
    required int time,
    double? temperatureC,
    double? feelsLikeC,

    /// Bağıl nem, yüzde (0–100).
    double? humidity,
    double? windKmh,
    double? precipitationMm,
    int? conditionCode,
  }) = _CurrentWeather;

  factory fromJson(Map<String, Object?> json) => _$CurrentWeatherFromJson(json);
}

/// Bir saatin tahmini.
typedef HourlyWeather = ({
  int time,
  double? temperatureC,
  double? windKmh,
  double? precipitationMm,
  double? precipitationProbability,
  int? conditionCode,
});

/// Bir günün tahmini; `day` arılığın takvimindeki gün (yerel gece yarısı).
typedef DailyWeather = ({
  DateTime day,
  int? conditionCode,
  double? temperatureMaxC,
  double? temperatureMinC,
  double? precipitationProbability,
  double? windMaxKmh,
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
    required List<int?> conditionCode,
  }) = _HourlySeries;

  factory fromJson(Map<String, Object?> json) => _$HourlySeriesFromJson(json);
}

/// Günlük sütunlar; hepsi [time] ile aynı uzunlukta.
@freezed
abstract class DailySeries with _$DailySeries {
  const factory({
    required List<int> time,
    required List<int?> conditionCode,
    required List<double?> temperatureMaxC,
    required List<double?> temperatureMinC,
    required List<double?> precipitationMm,
    required List<double?> precipitationProbabilityMax,
    required List<double?> windMaxKmh,
  }) = _DailySeries;

  factory fromJson(Map<String, Object?> json) => _$DailySeriesFromJson(json);
}
