import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';

import '../../../helpers/fake_weather_service.dart';

HiveOpeningAdvice _advice({
  double temperatureC = 22,
  double windKmh = 8,
  double precipitationMm = 0,
  double? precipitationProbability = 0,
}) => hiveOpeningAdvice(
  temperatureC: temperatureC,
  windKmh: windKmh,
  precipitationMm: precipitationMm,
  precipitationProbability: precipitationProbability,
);

const HiveOpeningAdvice _suitable = (
  level: HiveOpening.suitable,
  concern: null,
);

void main() {
  group('hiveOpeningAdvice', () {
    test('ılık, sakin ve kuru hava yeşil', () {
      expect(_advice(), _suitable);
      expect(
        _advice(temperatureC: 16, windKmh: 19.9, precipitationProbability: 29),
        _suitable,
      );
    });

    test('sıcaklık: 16 altı sarı, 12 altı kırmızı', () {
      expect(_advice(temperatureC: 15.9), (
        level: HiveOpening.caution,
        concern: WeatherConcern.cold,
      ));
      expect(_advice(temperatureC: 12), (
        level: HiveOpening.caution,
        concern: WeatherConcern.cold,
      ));
      expect(_advice(temperatureC: 11.9), (
        level: HiveOpening.unsuitable,
        concern: WeatherConcern.cold,
      ));
    });

    test('rüzgar: 20 ve üstü sarı, 30 ve üstü kırmızı', () {
      expect(_advice(windKmh: 20), (
        level: HiveOpening.caution,
        concern: WeatherConcern.wind,
      ));
      expect(_advice(windKmh: 29.9), (
        level: HiveOpening.caution,
        concern: WeatherConcern.wind,
      ));
      expect(_advice(windKmh: 30), (
        level: HiveOpening.unsuitable,
        concern: WeatherConcern.wind,
      ));
    });

    test('yağış: hafif ya da olası sarı, 0,5 mm ya da %60 kırmızı', () {
      expect(_advice(precipitationMm: 0.1), (
        level: HiveOpening.caution,
        concern: WeatherConcern.rain,
      ));
      expect(_advice(precipitationProbability: 30), (
        level: HiveOpening.caution,
        concern: WeatherConcern.rain,
      ));
      expect(_advice(precipitationMm: 0.5), (
        level: HiveOpening.unsuitable,
        concern: WeatherConcern.rain,
      ));
      expect(_advice(precipitationProbability: 60), (
        level: HiveOpening.unsuitable,
        concern: WeatherConcern.rain,
      ));
    });

    test('olasılık bilinmiyorsa yalnız yağış miktarına bakılır', () {
      expect(_advice(precipitationProbability: null), _suitable);
      expect(_advice(precipitationMm: 0.2, precipitationProbability: null), (
        level: HiveOpening.caution,
        concern: WeatherConcern.rain,
      ));
    });

    test('en kötü etken kazanır; eşitlikte yağış, rüzgar, soğuk', () {
      // Tasarımdaki Yayla: 13°, rüzgar 31 → rüzgar kırmızı, soğuk sarı.
      expect(_advice(temperatureC: 13, windKmh: 31), (
        level: HiveOpening.unsuitable,
        concern: WeatherConcern.wind,
      ));
      expect(_advice(temperatureC: 10, windKmh: 25), (
        level: HiveOpening.unsuitable,
        concern: WeatherConcern.cold,
      ));
      expect(
        _advice(temperatureC: 14, windKmh: 25, precipitationProbability: 40),
        (level: HiveOpening.caution, concern: WeatherConcern.rain),
      );
      expect(_advice(temperatureC: 5, windKmh: 40, precipitationMm: 3), (
        level: HiveOpening.unsuitable,
        concern: WeatherConcern.rain,
      ));
    });
  });

  group('forecastHourAt ve hourOpeningAdvice', () {
    final at = DateTime.utc(2026, 10, 26, 9, 30);

    test('anın içinde olduğu saati verir', () {
      final forecast = testForecast(at: DateTime.utc(2026, 10, 26, 6));
      final hourly = forecast.hourly.copyWith(
        temperatureC: [
          for (var i = 0; i < forecast.hourly.time.length; i++) i.toDouble(),
        ],
      );
      final hour = forecastHourAt(forecast.copyWith(hourly: hourly), at);
      expect(hour?.temperatureC, 3);
      expect(
        forecastHourAt(
          forecast.copyWith(hourly: hourly),
          DateTime.utc(2026, 10, 26, 10),
        )?.temperatureC,
        4,
      );
    });

    test('tahmin aralığı dışında null', () {
      final forecast = testForecast(at: at, hours: 2);
      expect(forecastHourAt(forecast, at.add(const Duration(hours: 3))), null);
      expect(
        forecastHourAt(forecast, at.subtract(const Duration(hours: 1))),
        null,
      );
    });

    test('sıcaklık, rüzgar ya da yağış eksikse uygunluk yok', () {
      for (final forecast in [
        testForecast(at: at, temperatureC: null),
        testForecast(at: at, windKmh: null),
        testForecast(at: at, precipitationMm: null),
      ]) {
        expect(hourOpeningAdvice(forecastHourAt(forecast, at)!), null);
      }
      expect(
        hourOpeningAdvice(
          forecastHourAt(
            testForecast(at: at, precipitationProbability: null),
            at,
          )!,
        ),
        _suitable,
      );
    });
  });

  group('weatherNeedsRefresh', () {
    final now = DateTime.utc(2026, 10, 26, 12);
    WeatherBundle bundle(Duration age, List<String> apiaryIds) => testBundle(
      generatedAt: now.subtract(age),
      forecasts: {for (final id in apiaryIds) id: testForecast(at: now)},
    );

    test('konumlu arılık yoksa sormaz', () {
      expect(
        weatherNeedsRefresh(bundle: null, now: now, locatedApiaryIds: {}),
        isFalse,
      );
    });

    test('paket yoksa ya da 1 saatten eskiyse sorar', () {
      expect(
        weatherNeedsRefresh(bundle: null, now: now, locatedApiaryIds: {'a'}),
        isTrue,
      );
      expect(
        weatherNeedsRefresh(
          bundle: bundle(const Duration(minutes: 59), ['a']),
          now: now,
          locatedApiaryIds: {'a'},
        ),
        isFalse,
      );
      expect(
        weatherNeedsRefresh(
          bundle: bundle(const Duration(hours: 1), ['a']),
          now: now,
          locatedApiaryIds: {'a'},
        ),
        isTrue,
      );
    });

    test('pakette olmayan arılık için en erken 10 dakika sonra sorar', () {
      expect(
        weatherNeedsRefresh(
          bundle: bundle(const Duration(minutes: 9), ['a']),
          now: now,
          locatedApiaryIds: {'a', 'b'},
        ),
        isFalse,
      );
      expect(
        weatherNeedsRefresh(
          bundle: bundle(const Duration(minutes: 10), ['a']),
          now: now,
          locatedApiaryIds: {'a', 'b'},
        ),
        isTrue,
      );
    });
  });

  group('WeatherBundle', () {
    test('Edge Function yanıtını okur; boş değerler null', () {
      final bundle = WeatherBundle.fromJson({
        'generated_at': '2026-10-26T08:25:53.663Z',
        'forecasts': [
          {
            'apiary_id': 'a1',
            'cell': '37.10,28.39',
            'fetched_at': '2026-10-26T08:25:53.85+00:00',
            'forecast': {
              'timezone': 'Europe/Istanbul',
              'utc_offset_seconds': 10800,
              'hourly': {
                'time': [1792962000, 1792965600],
                'temperature_c': [14, 14.2],
                'wind_kmh': [3.1, null],
                'precipitation_mm': [0, 0.3],
                'precipitation_probability': [null, 40],
                'weather_code': [0, 61],
              },
              'daily': {
                'time': [1792962000],
                'weather_code': [61],
                'temperature_max_c': [22.4],
                'temperature_min_c': [9.1],
                'precipitation_mm': [1.2],
                'precipitation_probability_max': [55],
                'wind_max_kmh': [14.8],
              },
            },
          },
        ],
      });

      final forecast = bundle.forecasts.single;
      expect(forecast.fetchedAt, DateTime.utc(2026, 10, 26, 8, 25, 53, 850));
      expect(forecast.forecast.hourly.temperatureC, [14.0, 14.2]);
      expect(forecast.forecast.hourly.windKmh, [3.1, null]);
      expect(forecast.forecast.hourly.precipitationProbability, [null, 40.0]);
      expect(forecast.forecast.daily.temperatureMaxC, [22.4]);
    });

    test('JSON metni üzerinden aynı paketi geri verir', () {
      final bundle = testBundle(
        generatedAt: DateTime.utc(2026, 10, 26, 8),
        forecasts: {'a1': testForecast(at: DateTime.utc(2026, 10, 26, 8))},
      );
      final decoded = WeatherBundle.fromJson(
        jsonDecode(jsonEncode(bundle.toJson())) as Map<String, Object?>,
      );
      expect(decoded, bundle);
    });
  });
}
