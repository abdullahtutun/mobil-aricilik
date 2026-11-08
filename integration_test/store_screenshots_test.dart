// Mağaza ekran görüntüleri: uygulamayı yerel Supabase'deki demo hesabıyla
// açar, ekranları sırayla gezer ve her ekranda `SHOT:<ad>` basıp bekler.
// Görüntüyü `tool/store_screenshots.py` simülatörden alır (durum çubuğu
// dahil). Yalnız o betikle çalıştırılır; `flutter test` bu klasörü koşmaz.
//
// Kimlikler `--dart-define` ile gelir (betik yerel DB'den okur). Yerelde
// WeatherAPI anahtarı olmadığı için hava durumu, yerel DB'deki arılıklara
// mevsime uygun örnek tahminle doldurulur (bütün veri zaten demo verisi).

import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/auth/data/secure_session_storage.dart';
import 'package:mobil_arici/features/weather/data/weather_service.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'helpers/test_device.dart' show supabaseKey, supabaseUrl;

const _email = String.fromEnvironment('DEMO_EMAIL');
const _password = String.fromEnvironment('DEMO_PASSWORD');
const _language = String.fromEnvironment('LANGUAGE', defaultValue: 'tr');
const _apiary = String.fromEnvironment('APIARY_ID');
const _hive = String.fromEnvironment('HIVE_ID');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mağaza ekran görüntüleri', (tester) async {
    // Mağaza görüntüsünde DEBUG şeridi olmasın.
    WidgetsApp.debugAllowBannerOverride = false;
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseKey,
      authOptions: FlutterAuthClientOptions(
        localStorage: SecureSessionStorage(supabaseUrl: supabaseUrl),
        detectSessionInUri: false,
      ),
    );
    await Supabase.instance.client.auth.signInWithPassword(
      email: _email,
      password: _password,
    );

    final container = ProviderContainer(
      overrides: [
        flavorProvider.overrideWithValue(Flavor.dev),
        weatherServiceProvider.overrideWithValue(const _SampleWeatherService()),
      ],
    )..listen(syncTriggersProvider, (_, _) {});
    container.read(languageProvider.notifier).language = AppLanguage.values
        .firstWhere((l) => l.locale?.languageCode == _language);
    useLatinDigitsForDates();
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );

    // İlk çekme bitene kadar bekle.
    await _wait(tester, const Duration(seconds: 12));

    final router = container.read(routerProvider);
    Future<void> shot(String name, String location, {int seconds = 4}) async {
      router.go(location);
      await _wait(tester, Duration(seconds: seconds));
      // Betik bu satırı görünce simülatörden görüntü alır.
      // ignore: avoid_print
      print('SHOT:$name');
      await _wait(tester, const Duration(seconds: 3));
    }

    await shot('today', '/', seconds: 8);
    await shot('apiary', '/apiaries/$_apiary');
    await shot('inspect', '/apiaries/$_apiary/hives/$_hive/inspect');
    await shot('hive', '/apiaries/$_apiary/hives/$_hive');
    await shot('season', '/more/season');
    await shot('finance', '/more/finance');
    await shot('team', '/more/team');
    await shot('weather', '/weather/$_apiary');
    await shot('tasks', '/tasks');

    // Arılık haritası: liste sekmesinden haritaya geçilir, karolar iner.
    router.go('/apiaries');
    await _wait(tester, const Duration(seconds: 3));
    final l10n = lookupAppLocalizations(const Locale(_language));
    await tester.tap(find.text(l10n.apiariesViewMap));
    await _wait(tester, const Duration(seconds: 10));
    // ignore: avoid_print, betik bu satırı görünce görüntü alır.
    print('SHOT:map');
    await _wait(tester, const Duration(seconds: 3));
  }, timeout: const Timeout(Duration(minutes: 10)));
}

/// Gerçek zamanla bekler; bu sürede kareler çizilmeye devam eder.
Future<void> _wait(WidgetTester tester, Duration duration) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Yerel DB'deki her arılık için 7 günlük, mevsime uygun örnek tahmin.
class _SampleWeatherService implements WeatherService {
  const new();

  /// Yalnız 5. gün yağmurlu.
  static double _rain(int day, double rainy, double dry) =>
      day == 4 ? rainy : dry;

  static const _places = {
    'Yayla Arılığı': ('Menteşe', 'Muğla', 20.0),
    'Kestane Arılığı': ('Altınordu', 'Ordu', 19.0),
    'Köy Arılığı': ('Osmangazi', 'Bursa', 19.0),
  };

  @override
  Future<WeatherBundle> fetchBundle() async {
    final rows = await Supabase.instance.client
        .from('apiaries')
        .select('id, name')
        .isFilter('deleted_at', null);
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    const offset = 3 * 3600;
    const codes = [1000, 1003, 1003, 1006, 1063, 1003, 1000];
    return WeatherBundle(
      generatedAt: now.toUtc(),
      forecasts: [
        for (final row in rows)
          () {
            final name = row['name'] as String;
            final (place, region, base) = _places[name] ?? ('', '', 15.0);
            final hours = [
              for (var h = 0; h < 7 * 24; h++) start.add(Duration(hours: h)),
            ];
            double temp(DateTime t) =>
                base +
                5 * math.sin((t.hour - 9) / 24 * 2 * math.pi) -
                t.difference(start).inDays * 0.4;
            return ApiaryForecast(
              apiaryId: row['id'] as String,
              cell: '00.00,00.00',
              fetchedAt: now.toUtc(),
              forecast: Forecast(
                timezone: 'Europe/Istanbul',
                utcOffsetSeconds: offset,
                place: place,
                region: region,
                current: CurrentWeather(
                  time: now.millisecondsSinceEpoch ~/ 1000,
                  temperatureC: temp(now).roundToDouble(),
                  feelsLikeC: temp(now).roundToDouble() - 1,
                  humidity: 62,
                  windKmh: 9,
                  precipitationMm: 0,
                  conditionCode: 1003,
                ),
                hourly: HourlySeries(
                  time: [
                    for (final t in hours) t.millisecondsSinceEpoch ~/ 1000,
                  ],
                  temperatureC: [for (final t in hours) temp(t)],
                  windKmh: [for (final t in hours) 8 + (t.hour % 5).toDouble()],
                  precipitationMm: [
                    for (final t in hours)
                      _rain(t.difference(start).inDays, 0.6, 0),
                  ],
                  precipitationProbability: [
                    for (final t in hours)
                      _rain(t.difference(start).inDays, 70, 10),
                  ],
                  conditionCode: [
                    for (final t in hours) codes[t.difference(start).inDays],
                  ],
                ),
                daily: DailySeries(
                  time: [
                    for (var d = 0; d < 7; d++)
                      start.add(Duration(days: d)).millisecondsSinceEpoch ~/
                          1000,
                  ],
                  conditionCode: codes,
                  temperatureMaxC: [
                    for (var d = 0; d < 7; d++)
                      (base + 5 - d * 0.4).roundToDouble(),
                  ],
                  temperatureMinC: [
                    for (var d = 0; d < 7; d++)
                      (base - 5 - d * 0.4).roundToDouble(),
                  ],
                  precipitationMm: [for (var d = 0; d < 7; d++) _rain(d, 4, 0)],
                  precipitationProbabilityMax: [
                    for (var d = 0; d < 7; d++) _rain(d, 70, 10),
                  ],
                  windMaxKmh: [for (var d = 0; d < 7; d++) 14],
                ),
              ),
            );
          }(),
      ],
    );
  }
}
