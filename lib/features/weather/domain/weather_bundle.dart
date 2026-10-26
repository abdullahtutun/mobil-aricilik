import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_bundle.freezed.dart';
part 'weather_bundle.g.dart';

/// `weather-bundle` Edge Function'ının yanıtı: işletmenin konumlu
/// arılıkları için WeatherAPI.com tahmini (planın verdiği kadar gün; ücretsiz
/// 3, Starter 7). Telefonda son alınan paket
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

/// Tahmin, sütunlar hâlinde. Saatler Unix saniyesi; günler arılığın saat
/// dilimindeki gece yarısı. Sağlayıcı bazı değerleri boş verebilir.
/// Sağlayıcıya özel hiçbir kod taşımaz; sunucu çevirir.
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
  WeatherCondition? condition,
});

/// Sağlayıcıdan bağımsız gökyüzü durumu; sunucu WeatherAPI kodundan çevirir.
/// Bilinmeyen değer null okunur.
@JsonEnum(fieldRename: FieldRename.snake)
enum WeatherCondition { clear, partlyCloudy, cloudy, fog, rain, snow, thunder }

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

    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    required List<WeatherCondition?> condition,
  }) = _HourlySeries;

  factory fromJson(Map<String, Object?> json) => _$HourlySeriesFromJson(json);
}

/// Günlük sütunlar; hepsi [time] ile aynı uzunlukta.
@freezed
abstract class DailySeries with _$DailySeries {
  const factory({
    required List<int> time,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    required List<WeatherCondition?> condition,
    required List<double?> temperatureMaxC,
    required List<double?> temperatureMinC,
    required List<double?> precipitationMm,
    required List<double?> precipitationProbabilityMax,
    required List<double?> windMaxKmh,
  }) = _DailySeries;

  factory fromJson(Map<String, Object?> json) => _$DailySeriesFromJson(json);
}
