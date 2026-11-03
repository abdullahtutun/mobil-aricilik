import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/weather/data/weather_repository.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/domain/weather_icons.dart';
import 'package:mobil_arici/features/weather/presentation/apiary_weather_screen.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_attribution.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_glyph.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/fake_weather_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// Günün (en yüksek sıcaklık, en sert rüzgar, yağış %).
typedef _Day = (double, double, double);

const _Day _ok = (22, 8, 0);
const _Day _rain = (17, 18, 80);
const _Day _wind = (16, 28, 20);

/// [now]'dan başlayan 48 saatlik ve [days] günlük tahmin.
Forecast _forecast(DateTime now, List<_Day> days) {
  final base = testForecast(at: now, hours: 48, days: days.length);
  return base.copyWith(
    place: 'Ula',
    region: 'Mugla',
    daily: base.daily.copyWith(
      conditionCode: [
        for (final (_, _, rain) in days)
          if (rain >= 40) rainCode else sunnyCode,
      ],
      temperatureMaxC: [for (final (t, _, _) in days) t],
      temperatureMinC: [for (final (t, _, _) in days) t - 10],
      windMaxKmh: [for (final (_, w, _) in days) w],
      precipitationProbabilityMax: [for (final (_, _, p) in days) p],
    ),
  );
}

/// Hava ekranının listesini [finder] görünene kadar kaydırır (altta kalan
/// Bugün listesini değil).
Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find
        .descendant(
          of: find.byType(ApiaryWeatherScreen),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  // Önbellek alanında çizilmiş ama ekranın dışındaysa.
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

/// [icon] simgesi.
Finder _glyph(WeatherIcon icon) =>
    find.byWidgetPredicate((w) => w is WeatherGlyph && w.icon == icon);

/// Haftanın günü (`DateTime.weekday`) → "Pazartesi'ye".
const Map<int, String> _trDative = {
  DateTime.monday: "Pazartesi'ye",
  DateTime.tuesday: "Salı'ya",
  DateTime.wednesday: "Çarşamba'ya",
  DateTime.thursday: "Perşembe'ye",
  DateTime.friday: "Cuma'ya",
  DateTime.saturday: "Cumartesi'ye",
  DateTime.sunday: "Pazar'a",
};

void main() {
  late AppDatabase db;
  late Apiary kizilcam;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    kizilcam = await ApiaryRepository(db).create(
      orgId: _orgId,
      name: 'Kızılçam',
      latitude: 37.105,
      longitude: 28.388,
    );
  });

  Future<ProviderContainer> open(
    WidgetTester tester, {
    required FakeWeatherService weather,
    FakeUrlLauncher? urlLauncher,
    AppLanguage language = AppLanguage.turkish,
    RegionConfig? region,
    bool viaRouter = false,
  }) async {
    final container = ProviderContainer.test(
      overrides: [
        ...signedIn(db: db, weather: weather, urlLauncher: urlLauncher),
        if (region != null) regionConfigProvider.overrideWithValue(region),
      ],
    );
    container.read(languageProvider.notifier).language = language;
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    if (viaRouter) {
      container.read(routerProvider).go(AppRoutes.apiaryWeather(kizilcam.id));
    } else {
      // Bugün'deki hava kartından.
      await tester.tap(find.text('Kızılçam').first);
    }
    await tester.pumpAndSettle();
    return container;
  }

  Finder badge(String label) => find.widgetWithText(StatusBadge, label);

  testWidgets(
    "Bugün'deki karttan açılır: şimdiki durum, bant, saatler, 7 gün, atıf",
    (tester) async {
      final now = DateTime.now();
      final launcher = FakeUrlLauncher();
      final weather = FakeWeatherService(
        bundle: testBundle(
          generatedAt: now,
          forecasts: {
            kizilcam.id: _forecast(now, [
              _ok,
              _ok,
              _ok,
              _rain,
              _rain,
              _wind,
              _ok,
            ]),
          },
        ),
      );
      await open(tester, weather: weather, urlLauncher: launcher);

      expect(find.text('Kızılçam'), findsOneWidget);
      expect(find.text('Ula, Mugla · 7 günlük hava'), findsOneWidget);
      expect(find.textContaining('Güncelleme '), findsOneWidget);
      expect(find.text('Güneşli · hissedilen 22°'), findsOneWidget);
      expect(find.text('Rüzgar 8 km/s'), findsOneWidget);
      expect(find.text('Nem %48'), findsOneWidget);
      expect(find.text('Bugün kovan açmaya uygun'), findsOneWidget);
      expect(find.text('Şimdi'), findsOneWidget);

      await _scrollTo(tester, find.text('Planla'));
      expect(find.text('Bugün'), findsOneWidget);
      expect(badge('Açılır'), findsNWidgets(4));
      expect(badge('Yağmur'), findsNWidgets(2));
      expect(badge('Rüzgarlı'), findsOneWidget);
      // Rozet: ✓ Açılır, × Yağmur, ! Rüzgarlı (renk tek başına değil).
      expect(find.byIcon(Icons.check_rounded), findsWidgets);
      expect(find.byIcon(Icons.close_rounded), findsNWidgets(2));
      expect(find.byIcon(Icons.priority_high_rounded), findsOneWidget);
      // Simge gökyüzünden: yağmurlu iki gün; rüzgarlı gün bulut (tasarım).
      expect(_glyph(WeatherIcon.rainy), findsNWidgets(2));
      expect(_glyph(WeatherIcon.windy), findsNothing);
      // Yağmurlu Salı–Çarşamba gibi iki gün; rüzgarlı gün ayrı dizi. En
      // yakın uygun gün yağmurdan önceki gün.
      final rainFrom = DateTime(now.year, now.month, now.day + 3);
      final rainTo = DateTime(now.year, now.month, now.day + 4);
      final target = DateTime(now.year, now.month, now.day + 2);
      String weekday(DateTime day) => DateFormat.EEEE('tr').format(day);
      expect(
        find.text(
          '${weekday(rainFrom)}–${weekday(rainTo)} yağmur. '
          'Muayeneleri ${_trDative[target.weekday]} al.',
          findRichText: true,
        ),
        findsOneWidget,
      );

      await _scrollTo(tester, find.byType(WeatherAttribution));
      expect(
        find.textContaining('15° üstü, rüzgar 25 km/s altı, yağış %40 altı'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Powered by WeatherAPI.com', findRichText: true),
        findsOneWidget,
      );
      await tester.tap(find.byType(WeatherAttribution));
      expect(launcher.opened, [Uri.parse('https://www.weatherapi.com/')]);
    },
  );

  testWidgets('3 günlük paket 3 gün listelenir; uygun gün yoksa bant yok', (
    tester,
  ) async {
    final now = DateTime.now();
    final weather = FakeWeatherService(
      bundle: testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: _forecast(now, [_rain, _wind, _rain]),
        },
      ),
    );
    await open(tester, weather: weather);

    expect(find.text('Ula, Mugla · 3 günlük hava'), findsOneWidget);
    expect(
      find.text('Bugün yağmur var; kovan açmaya uygun değil'),
      findsOneWidget,
    );
    await _scrollTo(tester, find.byType(WeatherAttribution));
    expect(badge('Yağmur'), findsNWidgets(2));
    expect(badge('Rüzgarlı'), findsOneWidget);
    expect(badge('Açılır'), findsNothing);
    expect(find.text('Planla'), findsNothing);
  });

  testWidgets('çevrimdışıyken saklanan paket güncelleme saatiyle gösterilir', (
    tester,
  ) async {
    final now = DateTime.now();
    final fetched = now.subtract(const Duration(hours: 3));
    await WeatherRepository(db).saveBundle(
      testBundle(
        generatedAt: fetched,
        forecasts: {
          kizilcam.id: _forecast(fetched, [_ok, _ok, _ok]),
        },
      ),
    );
    final weather = FakeWeatherService()..fail = true;
    await open(tester, weather: weather);

    expect(weather.fetchCount, greaterThan(0));
    expect(find.textContaining('Güncelleme '), findsOneWidget);
    expect(find.text('Ula, Mugla · 3 günlük hava'), findsOneWidget);
    expect(find.text('Hava bilgisi yok'), findsNothing);
  });

  testWidgets('paket yoksa boş durum; Yenile alınamazsa söyler, alınca açar', (
    tester,
  ) async {
    final weather = FakeWeatherService()..fail = true;
    await open(tester, weather: weather, viaRouter: true);

    expect(find.text('Hava bilgisi yok'), findsOneWidget);
    expect(find.byType(WeatherAttribution), findsOneWidget);
    await tester.tap(find.text('Yenile'));
    await tester.pumpAndSettle();
    expect(
      find.text('Tahmin alınamadı. İnternet bağlantını kontrol et.'),
      findsOneWidget,
    );

    final now = DateTime.now();
    weather
      ..fail = false
      ..bundle = testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: _forecast(now, [_ok, _ok, _ok]),
        },
      );
    await tester.tap(find.text('Yenile'));
    await tester.pumpAndSettle();
    expect(find.text('Hava bilgisi yok'), findsNothing);
    expect(find.text('Bugün kovan açmaya uygun'), findsOneWidget);
  });

  testWidgets('konumsuz arılıkta yenile yok, konum eklemesi istenir', (
    tester,
  ) async {
    await ApiaryRepository(db)
        .update(kizilcam.copyWith(latitude: null, longitude: null));
    await open(tester, weather: FakeWeatherService(), viaRouter: true);

    expect(
      find.text('Arılığın konumu yok. Tahmin için arılığa konum ekle.'),
      findsOneWidget,
    );
    expect(find.text('Yenile'), findsNothing);
  });

  testWidgets('Planla görev formunu önerilen günle açar; kaydedince yazılır', (
    tester,
  ) async {
    final now = DateTime.now();
    final weather = FakeWeatherService(
      bundle: testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: _forecast(now, [_ok, _ok, _rain, _rain, _ok]),
        },
      ),
    );
    await open(tester, weather: weather);

    await _scrollTo(tester, find.text('Planla'));
    expect(await db.select(db.tasks).get(), isEmpty);
    await tester.tap(find.text('Planla'));
    await tester.pumpAndSettle();

    expect(find.text('Yeni görev'), findsOneWidget);
    expect(find.text('Kızılçam muayenesi'), findsOneWidget);
    // Form görev yazmaz; kullanıcı onaylar.
    expect(await db.select(db.tasks).get(), isEmpty);

    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    final task = (await db.select(db.tasks).get()).single;
    final due = task.dueAt.toLocal();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    expect(task.title, 'Kızılçam muayenesi');
    expect(task.apiaryId, kizilcam.id);
    expect(DateTime(due.year, due.month, due.day), tomorrow);
    expect(due.hour, 9);
    // Hava ekranına dönüldü.
    expect(find.text('Planla'), findsOneWidget);
  });

  testWidgets('eşikler değişince günün durumu da değişir', (tester) async {
    await LocalSettingsRepository(db).setHiveOpeningMaxWind(30);
    final now = DateTime.now();
    final weather = FakeWeatherService(
      bundle: testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: _forecast(now, [_wind, _ok]),
        },
      ),
    );
    await open(tester, weather: weather);

    expect(find.text('Bugün kovan açmaya uygun'), findsOneWidget);
    await _scrollTo(tester, find.byType(WeatherAttribution));
    expect(badge('Rüzgarlı'), findsNothing);
    expect(find.textContaining('rüzgar 30 km/s altı'), findsOneWidget);
  });

  testWidgets("Ayarlar'daki kovan açma eşikleri bu telefona yazılır", (
    tester,
  ) async {
    final container = await open(
      tester,
      weather: FakeWeatherService()..fail = true,
      viaRouter: true,
    );
    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('KOVAN AÇMA EŞİKLERİ'), 200);
    final temperatureRow = find.widgetWithText(ListRow, 'Sıcaklık');
    final windRow = find.widgetWithText(ListRow, 'Rüzgar');
    final rainRow = find.widgetWithText(ListRow, 'Yağış olasılığı');
    await tester.scrollUntilVisible(rainRow, 200);
    expect(
      find.descendant(of: temperatureRow, matching: find.text('15° üstü')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: windRow, matching: find.text('25 km/s altı')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: rainRow, matching: find.text('%40 altı')),
      findsOneWidget,
    );

    for (final (row, option) in [
      (temperatureRow, '12° üstü'),
      (windRow, '30 km/s altı'),
      (rainRow, '%60 altı'),
    ]) {
      await tester.tap(row);
      await tester.pumpAndSettle();
      await tester.tap(find.text(option).last);
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: row, matching: find.text(option)),
        findsOneWidget,
      );
    }
    expect(
      await tester.runAsync(
        () => LocalSettingsRepository(db).watchHiveOpeningThresholds().first,
      ),
      (
        minTemperatureC: 12.0,
        maxWindKmh: 30.0,
        maxPrecipitationProbability: 60.0,
      ),
    );
  });

  testWidgets('İngilizce ve ABD birimleri: °F ve mph', (tester) async {
    final now = DateTime.now();
    final weather = FakeWeatherService(
      bundle: testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: _forecast(now, [_ok, _rain, _ok]),
        },
      ),
    );
    await open(
      tester,
      weather: weather,
      language: AppLanguage.english,
      region: resolveRegionConfig('US'),
    );

    expect(find.text('Ula, Mugla · 3-day forecast'), findsOneWidget);
    expect(find.text('Wind 5 mph'), findsOneWidget);
    expect(find.text('Sunny · feels like 72°'), findsOneWidget);
    expect(find.text('Good day to open hives'), findsOneWidget);
    await _scrollTo(tester, find.byType(WeatherAttribution));
    expect(badge('Rain'), findsOneWidget);
    expect(
      find.textContaining('above 59°', findRichText: true),
      findsOneWidget,
    );
  });

  for (final width in [380.0, 390.0, 430.0]) {
    testWidgets('${width.toInt()}dp tabloda başlık ve değerler tek satır', (
      tester,
    ) async {
      tester.view
        ..physicalSize = Size(width, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final now = DateTime.now();
      final weather = FakeWeatherService(
        bundle: testBundle(
          generatedAt: now,
          forecasts: {
            kizilcam.id: _forecast(now, [_ok, (17, 18, 100), _wind]),
          },
        ),
      );
      await open(tester, weather: weather);
      await _scrollTo(tester, find.text('SICAKLIK'));

      // Aynı biçimdeki tek satırlık hücreyle aynı yükseklikte olmalı.
      double height(String text) => tester.getSize(find.text(text)).height;
      final header = height('GÜN');
      for (final text in ['SICAKLIK', 'YAĞIŞ', 'KM/S', 'KOVAN']) {
        expect(height(text), header, reason: text);
      }
      expect(height('%100'), height('18'));
      expect(tester.takeException(), isNull);
    });
  }

  for (final mode in AppColorMode.values) {
    testWidgets('360dp, 1.5x yazı ve eldivenle taşmaz (${mode.name})', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final now = DateTime.now();
      final weather = FakeWeatherService(
        bundle: testBundle(
          generatedAt: now,
          forecasts: {
            kizilcam.id: _forecast(now, [
              _ok,
              _ok,
              _rain,
              _rain,
              _wind,
              _ok,
              _ok,
            ]),
          },
        ),
      );
      final container = await open(tester, weather: weather);
      container.read(appearanceProvider.notifier)
        ..setColorMode(mode)
        ..setGloveMode(enabled: true);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await _scrollTo(tester, find.text('Planla'));
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.widgetWithText(TextButton, 'Planla')).height,
        greaterThanOrEqualTo(56),
      );
      await _scrollTo(tester, find.byType(WeatherAttribution));
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(WeatherAttribution)).height,
        greaterThanOrEqualTo(56),
      );
    });
  }
}
