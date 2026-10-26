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

/// [at]'in saatinden başlayan [hours] saatlik tahmin; her saat aynı hava.
/// Günlük sütunlar tek gün.
Forecast testForecast({
  required DateTime at,
  double? temperatureC = 22,
  double? windKmh = 8,
  double? precipitationMm = 0,
  double? precipitationProbability = 0,
  int? weatherCode = 0,
  int hours = 24,
}) {
  const hour = Duration.secondsPerHour;
  final start = at.millisecondsSinceEpoch ~/ 1000 ~/ hour * hour;
  List<T> repeat<T>(T value) => List.filled(hours, value);
  return Forecast(
    timezone: 'Europe/Istanbul',
    utcOffsetSeconds: 10800,
    hourly: HourlySeries(
      time: [for (var i = 0; i < hours; i++) start + i * hour],
      temperatureC: repeat(temperatureC),
      windKmh: repeat(windKmh),
      precipitationMm: repeat(precipitationMm),
      precipitationProbability: repeat(precipitationProbability),
      weatherCode: repeat(weatherCode),
    ),
    daily: DailySeries(
      time: [start],
      weatherCode: [weatherCode],
      temperatureMaxC: [temperatureC],
      temperatureMinC: [temperatureC],
      precipitationMm: [precipitationMm],
      precipitationProbabilityMax: [precipitationProbability],
      windMaxKmh: [windKmh],
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
