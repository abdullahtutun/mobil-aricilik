import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_screen.dart';
import 'package:mobil_arici/features/weather/data/weather_repository.dart';
import 'package:mobil_arici/features/weather/domain/weather_icons.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/apiary_no_weather_card.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_attribution.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_glyph.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_weather_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;
const _attribution = 'Powered by WeatherAPI.com';
Finder _attributionText() =>
    find.textContaining(_attribution, findRichText: true);

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required FakeWeatherService weather,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, weather: weather),
  );
  container.read(languageProvider.notifier).language = AppLanguage.turkish;
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  return container;
}

/// [label]'lı durum rozeti.
Finder _badge(String label) => find.widgetWithText(StatusBadge, label);

void main() {
  late AppDatabase db;
  late Apiary kizilcam;
  late Apiary yayla;
  late Apiary ova;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    final apiaries = ApiaryRepository(db);
    kizilcam = await apiaries.create(
      orgId: _orgId,
      name: 'Kızılçam',
      latitude: 37.105,
      longitude: 28.388,
    );
    yayla = await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 39.93,
      longitude: 32.86,
    );
    // Konumsuz arılığın havası olmaz; şeritte "konum ekle" kartı olur.
    ova = await apiaries.create(orgId: _orgId, name: 'Ova');
  });

  testWidgets('açılışta paket alınır; kartlar, rozetler ve atıf görünür', (
    tester,
  ) async {
    final now = DateTime.now();
    final weather = FakeWeatherService(
      bundle: testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: testForecast(at: now),
          yayla.id: testForecast(at: now, temperatureC: 13, windKmh: 31),
        },
      ),
    );
    await _open(tester, db: db, weather: weather);

    expect(weather.fetchCount, 1);
    expect(find.text('Kızılçam'), findsOneWidget);
    expect(find.text('22°'), findsOneWidget);
    expect(find.text('Rüzgar 8 km/s'), findsOneWidget);
    expect(_badge('Kovan açılır'), findsOneWidget);
    expect(find.text('Yayla'), findsOneWidget);
    expect(find.text('13°'), findsOneWidget);
    expect(find.text('Rüzgar 31 km/s'), findsOneWidget);
    expect(_badge('Rüzgarlı'), findsOneWidget);
    expect(find.text('Ova'), findsOneWidget);
    expect(find.text('Konum yok'), findsOneWidget);
    expect(_attributionText(), findsOneWidget);
    expect(find.textContaining('itibarıyla'), findsNothing);
    // Paket telefonda saklandı.
    expect(await WeatherRepository(db).readBundle(), weather.bundle);
  });

  testWidgets('çevrimdışıyken saklanan paket zamanıyla ve atıfla gösterilir', (
    tester,
  ) async {
    final now = DateTime.now();
    await WeatherRepository(db).saveBundle(
      testBundle(
        generatedAt: now.subtract(const Duration(hours: 3)),
        forecasts: {
          kizilcam.id: testForecast(
            at: now.subtract(const Duration(hours: 3)),
            temperatureC: 10,
            precipitationMm: 1.2,
            conditionCode: rainCode,
          ),
        },
      ),
    );
    final weather = FakeWeatherService()..fail = true;
    await _open(tester, db: db, weather: weather);

    expect(weather.fetchCount, 1);
    expect(find.text('10°'), findsOneWidget);
    expect(_badge('Yağmur'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is WeatherGlyph && w.icon == WeatherIcon.rainy,
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.textContaining('itibarıyla'), findsOneWidget);
    expect(find.byType(WeatherAttribution), findsOneWidget);
  });

  testWidgets('taze paket varken sunucuya sorulmaz', (tester) async {
    final now = DateTime.now();
    final stored = testBundle(
      generatedAt: now.subtract(const Duration(minutes: 5)),
      forecasts: {
        kizilcam.id: testForecast(at: now),
        yayla.id: testForecast(at: now, temperatureC: 14),
      },
    );
    await WeatherRepository(db).saveBundle(stored);
    final weather = FakeWeatherService(bundle: stored);
    await _open(tester, db: db, weather: weather);

    expect(weather.fetchCount, 0);
    expect(_badge('Soğuk'), findsOneWidget);
  });

  testWidgets('paket yoksa hava ve atıf görünmez; arılıklar kartla kalır', (
    tester,
  ) async {
    final weather = FakeWeatherService()..fail = true;
    await _open(tester, db: db, weather: weather);

    expect(weather.fetchCount, 1);
    expect(_attributionText(), findsNothing);
    expect(find.text('22°'), findsNothing);
    // Konumlu arılıklar "Hava bilgisi yok", konumsuz "Konum yok" kartıyla.
    expect(find.text('Kızılçam'), findsOneWidget);
    expect(find.text('Hava bilgisi yok'), findsNWidgets(2));
    expect(find.text('Ova'), findsOneWidget);
    // Arılıklar var, kovan yok: kurulumun sıradaki adımı görünür.
    expect(find.text('KURULUM 1/3'), findsOneWidget);
    expect(find.text('Kovanlarını oluştur'), findsOneWidget);
  });

  testWidgets('tahmin aralığı geçmiş arılık havasız kartla, silinmiş arılık '
      'hiç gösterilmez', (tester) async {
    final now = DateTime.now();
    await ApiaryRepository(db).delete(yayla.id);
    final weather = FakeWeatherService(
      bundle: testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: testForecast(at: now.subtract(const Duration(days: 8))),
          yayla.id: testForecast(at: now),
        },
      ),
    );
    await _open(tester, db: db, weather: weather);

    expect(find.text('Kızılçam'), findsOneWidget);
    expect(find.text('Hava bilgisi yok'), findsOneWidget);
    expect(find.text('Yayla'), findsNothing);
    expect(_attributionText(), findsNothing);
  });

  testWidgets('konum eklenen arılık kaybolmaz; senkron turundan sonra havası '
      'gelir', (tester) async {
    final now = DateTime.now();
    final covered = {
      kizilcam.id: testForecast(at: now),
      yayla.id: testForecast(at: now),
    };
    await WeatherRepository(db).saveBundle(
      testBundle(
        generatedAt: now.subtract(const Duration(minutes: 2)),
        forecasts: covered,
      ),
    );
    final weather = FakeWeatherService();
    final container = await _open(tester, db: db, weather: weather);
    expect(weather.fetchCount, 0);
    expect(find.text('Konum yok'), findsOneWidget);

    // Kullanıcı Ova'ya konum ekler; sunucu onu senkronla öğrenecek.
    await tester.runAsync(
      () =>
          ApiaryRepository(db)
              .update(ova.copyWith(latitude: 38.4, longitude: 27.1)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ova'), findsOneWidget);
    expect(find.text('Konum yok'), findsNothing);
    expect(find.text('Hava bilgisi yok'), findsOneWidget);
    expect(find.text('Bağlantı gelince gelir'), findsOneWidget);

    weather.bundle = testBundle(
      generatedAt: now,
      forecasts: {
        ...covered,
        ova.id: testForecast(at: now, temperatureC: 9),
      },
    );
    await container.read(syncControllerProvider.notifier).sync();
    await tester.pumpAndSettle();
    expect(weather.fetchCount, 1);
    expect(find.text('9°'), findsOneWidget);
    expect(find.text('Hava bilgisi yok'), findsNothing);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle kartlar taşmaz', (
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
          kizilcam.id: testForecast(at: now, precipitationProbability: 45),
          yayla.id: testForecast(at: now, temperatureC: -12, windKmh: 104),
        },
      ),
    );

    final container = await _open(tester, db: db, weather: weather);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(_badge('Yağmur'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(-300, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(_badge('Rüzgarlı'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(-300, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Hava için konum ekle'), findsOneWidget);
  });

  testWidgets('iki konumlu ve bir konumsuz arılıkta şerit kayar; konumsuz '
      'kart düzenleme formunu açar', (tester) async {
    final now = DateTime.now();
    final weather = FakeWeatherService(
      bundle: testBundle(
        generatedAt: now,
        forecasts: {
          kizilcam.id: testForecast(at: now),
          yayla.id: testForecast(at: now),
        },
      ),
    );
    await _open(tester, db: db, weather: weather);

    final strip = find.byType(SingleChildScrollView).first;
    final card = find.text('Ova');
    expect(card, findsOneWidget);
    // Kaydırmadan önce üçüncü kartın ucu sağ kenarda görünür.
    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final third = tester.getRect(find.byType(ApiaryNoWeatherCard));
    expect(third.left, lessThan(screenWidth));
    expect(third.right, greaterThan(screenWidth));
    final before = tester.getTopLeft(card);
    await tester.drag(strip, const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(card).dx, lessThan(before.dx));

    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(ApiaryFormScreen), findsOneWidget);
  });

  testWidgets('İngilizce: konumsuz kart metinleri', (tester) async {
    final container = await _open(
      tester,
      db: db,
      weather: FakeWeatherService()..fail = true,
    );
    container.read(languageProvider.notifier).language = AppLanguage.english;
    await tester.pumpAndSettle();
    expect(find.text('No location'), findsOneWidget);
    expect(find.text('Add a location for weather'), findsOneWidget);
  });
}
