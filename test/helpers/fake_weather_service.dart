import 'package:mobil_arici/features/weather/data/weather_service.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

/// Ağsız hava servisi: [bundle]'ı döner; boşsa ya da [fail] doğruysa
/// sunucuya ulaşılamamış gibi hata atar. Çağrıları sayar.
class FakeWeatherService implements WeatherService {
  new({this.bundle});

  WeatherBundle? bundle;
  bool fail = false;
  int fetchCount = 0;

  @override
  Future<WeatherBundle> fetchBundle() async {
    fetchCount++;
    final bundle = this.bundle;
    if (fail || bundle == null) {
      throw const WeatherServiceException('çevrimdışı');
    }
    return bundle;
  }
}

/// WeatherAPI kodları: güneşli ve hafif yağmur.
const sunnyCode = 1000;
const rainCode = 1183;

/// [at]'in saatinden başlayan [hours] saatlik tahmin; her saat aynı hava.
/// Günlük sütunlar [days] gün (ilk gün [at]'in günü), hepsi aynı hava; şimdiki
/// durum da aynı.
Forecast testForecast({
  required DateTime at,
  double? temperatureC = 22,
  double? windKmh = 8,
  double? precipitationMm = 0,
  double? precipitationProbability = 0,
  int? conditionCode = sunnyCode,
  int hours = 24,
  int days = 1,
}) {
  const hour = Duration.secondsPerHour;
  const offset = 10800;
  final start = at.millisecondsSinceEpoch ~/ 1000 ~/ hour * hour;
  // Arılığın (UTC+3) gece yarısı.
  final midnight =
      (start + offset) ~/ Duration.secondsPerDay * Duration.secondsPerDay -
      offset;
  List<T> repeat<T>(T value, [int? count]) =>
      List.filled(count ?? hours, value);
  return Forecast(
    timezone: 'Europe/Istanbul',
    utcOffsetSeconds: offset,
    current: CurrentWeather(
      time: start,
      temperatureC: temperatureC,
      feelsLikeC: temperatureC,
      humidity: 48,
      windKmh: windKmh,
      precipitationMm: precipitationMm,
      conditionCode: conditionCode,
    ),
    hourly: HourlySeries(
      time: [for (var i = 0; i < hours; i++) start + i * hour],
      temperatureC: repeat(temperatureC),
      windKmh: repeat(windKmh),
      precipitationMm: repeat(precipitationMm),
      precipitationProbability: repeat(precipitationProbability),
      conditionCode: repeat(conditionCode),
    ),
    daily: DailySeries(
      time: [
        for (var i = 0; i < days; i++) midnight + i * Duration.secondsPerDay,
      ],
      conditionCode: repeat(conditionCode, days),
      temperatureMaxC: repeat(temperatureC, days),
      temperatureMinC: repeat(temperatureC, days),
      precipitationMm: repeat(precipitationMm, days),
      precipitationProbabilityMax: repeat(precipitationProbability, days),
      windMaxKmh: repeat(windKmh, days),
    ),
  );
}

/// [forecasts] arılık kimliğinden tahmine; paket [generatedAt]'te alınmış.
WeatherBundle testBundle({
  required DateTime generatedAt,
  required Map<String, Forecast> forecasts,
}) => WeatherBundle(
  generatedAt: generatedAt,
  forecasts: [
    for (final MapEntry(key: apiaryId, value: forecast) in forecasts.entries)
      ApiaryForecast(
        apiaryId: apiaryId,
        cell: '37.11,28.39',
        fetchedAt: generatedAt,
        forecast: forecast,
      ),
  ],
);
