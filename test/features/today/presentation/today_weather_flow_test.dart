import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/weather/data/weather_repository.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_attribution.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_weather_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;
const _attribution = 'Powered by WeatherAPI.com';

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
    // Konumsuz arılığın havası olmaz.
    await apiaries.create(orgId: _orgId, name: 'Ova');
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
    expect(_badge('Sert rüzgar'), findsOneWidget);
    expect(find.text('Ova'), findsNothing);
    expect(find.text(_attribution), findsOneWidget);
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
            condition: WeatherCondition.rain,
          ),
        },
      ),
    );
    final weather = FakeWeatherService()..fail = true;
    await _open(tester, db: db, weather: weather);

    expect(weather.fetchCount, 1);
    expect(find.text('10°'), findsOneWidget);
    expect(_badge('Yağışlı'), findsOneWidget);
    expect(find.byIcon(Icons.water_drop_outlined), findsOneWidget);
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
    expect(_badge('Serin'), findsOneWidget);
  });

  testWidgets('paket yoksa hava ve atıf görünmez', (tester) async {
    final weather = FakeWeatherService()..fail = true;
    await _open(tester, db: db, weather: weather);

    expect(weather.fetchCount, 1);
    expect(find.text(_attribution), findsNothing);
    // Arılıklar var, kovan yok: kurulumun sıradaki adımı görünür.
    expect(find.text('KURULUM 1/3'), findsOneWidget);
    expect(find.text('Kovanlarını oluştur'), findsOneWidget);
  });

  testWidgets('tahmin aralığı geçmiş ve silinmiş arılık gösterilmez', (
    tester,
  ) async {
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

    expect(find.text('Kızılçam'), findsNothing);
    expect(find.text('Yayla'), findsNothing);
    expect(find.text(_attribution), findsNothing);
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
    expect(_badge('Yağış olası'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(-300, 0),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(_badge('Sert rüzgar'), findsOneWidget);
  });
}
