import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/weather/data/weather_repository.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

import '../../../helpers/fake_weather_service.dart';
import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late WeatherRepository repository;
  final at = DateTime.utc(2026, 10, 26, 8);

  setUp(() {
    db = openTestDatabase();
    repository = WeatherRepository(db);
  });

  tearDown(() => db.close());

  test('paket yokken null', () async {
    expect(await repository.readBundle(), isNull);
    expect(await repository.watchBundle().first, isNull);
  });

  test(
    'saklanan paket okunur, yenisi yerine geçer ve Stream güncellenir',
    () async {
      final first = testBundle(
        generatedAt: at,
        forecasts: {'a1': testForecast(at: at)},
      );
      final second = testBundle(
        generatedAt: at.add(const Duration(hours: 1)),
        forecasts: {'a2': testForecast(at: at, temperatureC: 9)},
      );
      final emitted = <WeatherBundle?>[];
      final subscription = repository.watchBundle().listen(emitted.add);
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      await repository.saveBundle(first);
      expect(await repository.readBundle(), first);
      await pumpEventQueue();
      await repository.saveBundle(second);
      await pumpEventQueue();

      expect(await repository.readBundle(), second);
      expect(emitted, [null, first, second]);
    },
  );

  test("outbox'a yazılmaz", () async {
    await repository.saveBundle(
      testBundle(
        generatedAt: at,
        forecasts: {'a1': testForecast(at: at)},
      ),
    );
    expect(await db.select(db.outbox).get(), isEmpty);
  });

  test('bozuk paket null okunur', () async {
    await db
        .into(db.localSettings)
        .insert(
          LocalSettingsCompanion.insert(
            key: WeatherRepository.bundleKey,
            value: '{"generated_at": 1',
          ),
        );
    expect(await repository.readBundle(), isNull);
    expect(await repository.watchBundle().first, isNull);
  });

  test('durum adlı eski biçim null okunur; paket yeniden alınır', () async {
    final json = testBundle(
      generatedAt: at,
      forecasts: {'a1': testForecast(at: at)},
    ).toJson();
    final old = jsonDecode(jsonEncode(json)) as Map<String, Object?>;
    for (final forecast in old['forecasts']! as List<Object?>) {
      final series =
          (forecast! as Map<String, Object?>)['forecast']!
                as Map<String, Object?>
            ..remove('current');
      for (final key in ['hourly', 'daily']) {
        final columns = series[key]! as Map<String, Object?>;
        columns['condition'] = columns.remove('condition_code');
      }
    }
    await db
        .into(db.localSettings)
        .insert(
          LocalSettingsCompanion.insert(
            key: WeatherRepository.bundleKey,
            value: jsonEncode(old),
          ),
        );
    expect(await repository.readBundle(), isNull);
  });
}
