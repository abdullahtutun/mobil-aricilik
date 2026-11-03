import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';

import '../../../helpers/fake_weather_service.dart';

const HiveOpeningThresholds _defaults = defaultHiveOpeningThresholds;

HiveOpening _opening({
  double temperatureC = 22,
  double windKmh = 8,
  double? precipitationProbability = 0,
  double? precipitationMm = 0,
  HiveOpeningThresholds thresholds = _defaults,
}) => hiveOpening(
  temperatureC: temperatureC,
  windKmh: windKmh,
  thresholds: thresholds,
  precipitationProbability: precipitationProbability,
  precipitationMm: precipitationMm,
);

/// `weather-bundle`'ın döndüğü biçimde [days] günlük paket: her gün 24
/// saat, Europe/Istanbul (UTC+3). 2026-10-24 00:00 yerel saatten başlar.
Map<String, Object?> _bundleJson(int days) {
  const offset = 10800;
  final midnight =
      DateTime.utc(2026, 10, 24).millisecondsSinceEpoch ~/ 1000 - offset;
  final hours = [
    for (var i = 0; i < days * 24; i++) midnight + i * Duration.secondsPerHour,
  ];
  return {
    'generated_at': '2026-10-24T03:40:00.000Z',
    'forecasts': [
      {
        'apiary_id': 'a1',
        'cell': '37.10,28.39',
        'fetched_at': '2026-10-24T03:40:00.000Z',
        'forecast': {
          'format': 2,
          'place': 'Ula',
          'region': 'Mugla',
          'timezone': 'Europe/Istanbul',
          'utc_offset_seconds': offset,
          'current': {
            'time': midnight + 6 * Duration.secondsPerHour,
            'temperature_c': 22,
            'feels_like_c': 21.4,
            'humidity': 48,
            'wind_kmh': 8.3,
            'precipitation_mm': 0,
            'condition_code': 1000,
          },
          'hourly': {
            'time': hours,
            'temperature_c': [
              for (var i = 0; i < hours.length; i++) 10 + i % 24,
            ],
            'wind_kmh': [for (final _ in hours) 8],
            'precipitation_mm': [for (final _ in hours) 0],
            'precipitation_probability': [for (final _ in hours) 0],
            'condition_code': [for (final _ in hours) 1003],
          },
          'daily': {
            'time': [
              for (var i = 0; i < days; i++)
                midnight + i * Duration.secondsPerDay,
            ],
            'condition_code': [for (var i = 0; i < days; i++) 1000 + i],
            'temperature_max_c': [for (var i = 0; i < days; i++) 20 + i],
            'temperature_min_c': [for (var i = 0; i < days; i++) 10 + i],
            'precipitation_mm': [for (var i = 0; i < days; i++) 0],
            'precipitation_probability_max': [
              for (var i = 0; i < days; i++) i * 10,
            ],
            'wind_max_kmh': [for (var i = 0; i < days; i++) 5 + i],
          },
        },
      },
    ],
  };
}

/// 24 Ekim'den başlayan, her günü `days`'teki (sıcaklık, rüzgar, yağış %)
/// olan günlük tahmin.
List<DailyWeather> _days(List<(double, double, double)> days) {
  final start = DateTime(2026, 10, 24);
  return [
    for (final (i, (temperature, wind, precipitation)) in days.indexed)
      (
        day: DateTime(start.year, start.month, start.day + i),
        conditionCode: null,
        temperatureMaxC: temperature,
        temperatureMinC: temperature - 10,
        precipitationProbability: precipitation,
        windMaxKmh: wind,
      ),
  ];
}

const _ok = (22.0, 8.0, 0.0);
const _rain = (17.0, 18.0, 80.0);
const _wind = (16.0, 28.0, 20.0);
const _cold = (9.0, 5.0, 0.0);

void main() {
  group('hiveOpening (varsayılan eşikler: 15° üstü, 25 km/s, %40)', () {
    test('ılık, sakin ve kuru hava uygun', () {
      expect(_opening(), HiveOpening.suitable);
      expect(
        _opening(
          temperatureC: 15.1,
          windKmh: 24.9,
          precipitationProbability: 39,
        ),
        HiveOpening.suitable,
      );
    });

    test('sınırlar: 15° soğuk, 25 km/s rüzgarlı, %40 yağmur', () {
      expect(_opening(temperatureC: 15), HiveOpening.cold);
      expect(_opening(windKmh: 25), HiveOpening.wind);
      expect(_opening(precipitationProbability: 40), HiveOpening.rain);
    });

    test('olasılık düşük olsa da yağış miktarı 0,5 mm ise yağmur', () {
      expect(_opening(precipitationMm: 0.4), HiveOpening.suitable);
      expect(_opening(precipitationMm: 0.5), HiveOpening.rain);
    });

    test('bilinmeyen yağış sorun sayılmaz', () {
      expect(
        _opening(precipitationProbability: null, precipitationMm: null),
        HiveOpening.suitable,
      );
    });

    test('birden çok etkende yağmur, rüzgar, soğuk sırası', () {
      expect(
        _opening(temperatureC: 5, windKmh: 40, precipitationProbability: 90),
        HiveOpening.rain,
      );
      expect(_opening(temperatureC: 5, windKmh: 40), HiveOpening.wind);
    });
  });

  group('hiveOpening eşik varyasyonları', () {
    test('sıcaklık eşiği 12° olunca 13° uygun, 20° olunca 19° soğuk', () {
      expect(
        _opening(
          temperatureC: 13,
          thresholds: (
            minTemperatureC: 12,
            maxWindKmh: 25,
            maxPrecipitationProbability: 40,
          ),
        ),
        HiveOpening.suitable,
      );
      expect(
        _opening(
          temperatureC: 19,
          thresholds: (
            minTemperatureC: 20,
            maxWindKmh: 25,
            maxPrecipitationProbability: 40,
          ),
        ),
        HiveOpening.cold,
      );
    });

    test('rüzgar eşiği 35 olunca 30 km/s uygun, 15 olunca 15 rüzgarlı', () {
      expect(
        _opening(
          windKmh: 30,
          thresholds: (
            minTemperatureC: 15,
            maxWindKmh: 35,
            maxPrecipitationProbability: 40,
          ),
        ),
        HiveOpening.suitable,
      );
      expect(
        _opening(
          windKmh: 15,
          thresholds: (
            minTemperatureC: 15,
            maxWindKmh: 15,
            maxPrecipitationProbability: 40,
          ),
        ),
        HiveOpening.wind,
      );
    });

    test('yağış eşiği %60 olunca %50 uygun, %20 olunca %20 yağmur', () {
      expect(
        _opening(
          precipitationProbability: 50,
          thresholds: (
            minTemperatureC: 15,
            maxWindKmh: 25,
            maxPrecipitationProbability: 60,
          ),
        ),
        HiveOpening.suitable,
      );
      expect(
        _opening(
          precipitationProbability: 20,
          thresholds: (
            minTemperatureC: 15,
            maxWindKmh: 25,
            maxPrecipitationProbability: 20,
          ),
        ),
        HiveOpening.rain,
      );
    });
  });

  group('forecastHourAt ve hourOpening', () {
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
        hour?.time,
        DateTime.utc(2026, 10, 26, 9).millisecondsSinceEpoch ~/ 1000,
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

    test('sıcaklık ya da rüzgar eksikse uygunluk yok; yağış eksikse var', () {
      for (final forecast in [
        testForecast(at: at, temperatureC: null),
        testForecast(at: at, windKmh: null),
      ]) {
        expect(hourOpening(forecastHourAt(forecast, at)!, _defaults), null);
      }
      expect(
        hourOpening(
          forecastHourAt(
            testForecast(
              at: at,
              precipitationProbability: null,
              precipitationMm: null,
            ),
            at,
          )!,
          _defaults,
        ),
        HiveOpening.suitable,
      );
    });
  });

  group('günlük ve saatlik ayrıştırma', () {
    // 2026-10-24 06:40 yerel (UTC+3).
    final now = DateTime.utc(2026, 10, 24, 3, 40);

    for (final count in [3, 7]) {
      test('$count günlük yanıt: $count gün, ${count * 24} saat', () {
        final bundle = WeatherBundle.fromJson(_bundleJson(count));
        final forecast = bundle.forecasts.single.forecast;

        expect(forecast.place, 'Ula');
        expect(forecast.region, 'Mugla');
        expect(forecast.current.feelsLikeC, 21.4);
        expect(forecast.current.humidity, 48);
        expect(forecast.current.conditionCode, 1000);
        expect(forecast.hourly.time, hasLength(count * 24));

        final days = forecastDays(forecast, now);
        expect(days, hasLength(count));
        expect(days.first.day, DateTime(2026, 10, 24));
        expect(days.last.day, DateTime(2026, 10, 24 + count - 1));
        expect(days.last.temperatureMaxC, 20.0 + count - 1);
        expect(days.last.temperatureMinC, 10.0 + count - 1);
        expect(days.last.precipitationProbability, (count - 1) * 10.0);
        expect(days.last.windMaxKmh, 5.0 + count - 1);
        expect(days.last.conditionCode, 1000 + count - 1);

        final strip = hourlyStrip(forecast, now);
        expect(strip, hasLength(5));
        expect(
          [
            for (final hour in strip)
              forecastLocalTime(forecast, hour.time).hour,
          ],
          [6, 9, 12, 15, 18],
        );
        expect(strip.first.temperatureC, 16);
        expect(strip.first.conditionCode, 1003);
      });
    }

    test('eski paketin geçmiş günleri atlanır', () {
      final forecast = WeatherBundle.fromJson(_bundleJson(3))
          .forecasts
          .single
          .forecast;
      final days = forecastDays(
        forecast,
        DateTime.utc(2026, 10, 25, 22), // 26 Ekim 01:00 yerel
      );
      expect(days.map((d) => d.day), [DateTime(2026, 10, 26)]);
    });

    test('günün sonunda şerit ertesi güne geçer, tahmin bitince kısalır', () {
      final forecast = WeatherBundle.fromJson(_bundleJson(1))
          .forecasts
          .single
          .forecast;
      // 24 Ekim 20:10 yerel: 20, 21; sonrası tahminde yok.
      final strip = hourlyStrip(forecast, DateTime.utc(2026, 10, 24, 17, 10));
      expect(
        [for (final hour in strip) forecastLocalTime(forecast, hour.time).hour],
        [20, 21],
      );
      expect(hourlyStrip(forecast, DateTime.utc(2026, 10, 26)), isEmpty);
    });

    test('eksik sütun değeri null okunur', () {
      final json = _bundleJson(3);
      final forecast =
          ((json['forecasts']! as List<Object?>).single!
                  as Map<String, Object?>)['forecast']!
              as Map<String, Object?>;
      forecast['daily'] = <String, Object?>{
        ...forecast['daily']! as Map<String, Object?>,
        'wind_max_kmh': [8, null],
      };
      final parsed = WeatherBundle.fromJson(json).forecasts.single.forecast;
      final days = forecastDays(parsed, DateTime.utc(2026, 10, 24, 3));
      expect(days.map((d) => d.windMaxKmh), [8.0, null, null]);
      expect(dayOpening(days[1], _defaults), null);
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

  group('dayOpening', () {
    test('günün en yükseği, en sert rüzgarı ve olasılığıyla', () {
      final [ok, rain, wind, cold] = _days([_ok, _rain, _wind, _cold]);
      expect(dayOpening(ok, _defaults), HiveOpening.suitable);
      expect(dayOpening(rain, _defaults), HiveOpening.rain);
      expect(dayOpening(wind, _defaults), HiveOpening.wind);
      expect(dayOpening(cold, _defaults), HiveOpening.cold);
    });
  });

  group('inspectionPlan', () {
    test('tasarımdaki hafta: Salı–Çarşamba yağmur, Pazartesi önerilir', () {
      // Cmt 24, Paz 25, Pzt 26, Sal 27, Çar 28, Per 29, Cum 30.
      final days = _days([_ok, _ok, _ok, _rain, _rain, _wind, _ok]);
      final plan = inspectionPlan(days, _defaults)!;
      expect(plan.from, DateTime(2026, 10, 27));
      // Yağmurdan sonraki rüzgarlı Perşembe ayrı dizi.
      expect(plan.to, DateTime(2026, 10, 28));
      expect(plan.concern, HiveOpening.rain);
      expect(plan.day, DateTime(2026, 10, 26));
    });

    test('dizi bugünden başlıyorsa yağışlı günleri atlayıp ilk uygun gün', () {
      final days = _days([_rain, _rain, _cold, _ok, _ok]);
      final plan = inspectionPlan(days, _defaults)!;
      expect(plan.from, DateTime(2026, 10, 24));
      expect(plan.to, DateTime(2026, 10, 25));
      expect(plan.concern, HiveOpening.rain);
      expect(plan.day, DateTime(2026, 10, 27));
    });

    test('önce ve sonra aynı uzaklıkta uygun gün varsa önceki', () {
      final days = _days([_ok, _wind, _ok]);
      final plan = inspectionPlan(days, _defaults)!;
      expect(plan.concern, HiveOpening.wind);
      expect(plan.day, DateTime(2026, 10, 24));
    });

    test('yağışlı ya da rüzgarlı gün yoksa öneri yok', () {
      expect(inspectionPlan(_days([_ok, _cold, _ok]), _defaults), isNull);
      expect(inspectionPlan(const [], _defaults), isNull);
    });

    test('uygun gün yoksa öneri yok', () {
      expect(
        inspectionPlan(_days([_rain, _wind, _cold, _rain]), _defaults),
        isNull,
      );
    });

    test('eşik değişince öneri de değişir', () {
      final days = _days([_ok, _wind, _ok]);
      expect(
        inspectionPlan(days, (
          minTemperatureC: 15,
          maxWindKmh: 30,
          maxPrecipitationProbability: 40,
        )),
        isNull,
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
}
