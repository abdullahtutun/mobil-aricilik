import 'package:flutter/gestures.dart' show kDoubleTapTimeout;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/directions_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_map.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/today/presentation/today_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_basemap_service.dart';
import '../../../helpers/fake_directions_service.dart';
import '../../../helpers/fake_offline_maps.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// Uygulamayı açar, Arılıklar sekmesine ve oradan haritaya geçer.
Future<ProviderContainer> _openMap(
  WidgetTester tester, {
  required AppDatabase db,
  required FakeBasemapService basemap,
  FakeOfflineMaps? offlineMaps,
  FakeUrlLauncher? urlLauncher,
  FakeDirectionsService? directions,
  List<Override> overrides = const [],
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(
        db: db,
        basemap: basemap,
        offlineMaps: offlineMaps,
        urlLauncher: urlLauncher,
        directions: directions,
      ),
      ...overrides,
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  await _tap(
    tester,
    find.descendant(
      of: find.byType(AppNavigationBar),
      matching: find.text('Apiaries'),
    ),
  );
  await _tap(tester, find.text('Map'));
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

const _attribution =
    '© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors';

void main() {
  late AppDatabase db;
  late ApiaryRepository apiaries;

  setUp(() {
    db = openTestDatabase();
    apiaries = ApiaryRepository(db);
  });

  Future<void> addHives(String apiaryId, List<String> numbers) async {
    for (final number in numbers) {
      await HiveRepository(db).create(
        orgId: _orgId,
        number: number,
        type: HiveType.local,
        apiaryId: apiaryId,
      );
    }
  }

  testWidgets('internet yoksa mesaj ve liste; tekrar denenince harita', (
    tester,
  ) async {
    await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 37.1,
      longitude: 28.4,
    );
    final basemap = FakeBasemapService();
    await _openMap(tester, db: db, basemap: basemap);

    expect(find.byType(FlutterMap), findsNothing);
    expect(find.text('Map unavailable'), findsOneWidget);
    expect(
      find.text('The map needs internet. Your apiaries are listed below.'),
      findsOneWidget,
    );
    expect(find.text('Yayla'), findsOneWidget);
    expect(find.text('1 apiary · No hives'), findsOneWidget);
    expect(basemap.loadCount, 1);

    // Listeye dönüp haritaya yeniden geçmek de dener.
    await _tap(tester, find.text('List'));
    await _tap(tester, find.text('Map'));
    expect(basemap.loadCount, 2);
    expect(find.text('Map unavailable'), findsOneWidget);

    basemap.fail = false;
    await _tap(tester, find.text('Try again'));

    expect(basemap.loadCount, 3);
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.text('Map unavailable'), findsNothing);
    expect(find.text(_attribution), findsOneWidget);

    // Yüklenen altlık yeniden okunmaz.
    await _tap(tester, find.text('List'));
    await _tap(tester, find.text('Map'));
    expect(basemap.loadCount, 3);
  });

  testWidgets('internet yokken arılık çevresi indirilmişse harita ondan '
      'açılır', (tester) async {
    final yayla = await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 37.1,
      longitude: 28.4,
    );
    final maps = FakeOfflineMaps();
    await maps.install(
      MapArea(id: yayla.id, name: 'Yayla', latitude: 37.1, longitude: 28.4),
    );
    await _openMap(
      tester,
      db: db,
      basemap: FakeBasemapService(),
      offlineMaps: maps,
    );

    expect(find.text('Map unavailable'), findsNothing);
    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byKey(const Key('offline-basemap')), findsOneWidget);
    expect(find.text(_attribution), findsOneWidget);
    expect(find.bySemanticsLabel('Yayla, No hives'), findsOneWidget);
  });

  testWidgets('konumlu arılıklar pin olur; uyarı rozeti, dokununca kart', (
    tester,
  ) async {
    final yayla = await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 37.10,
      longitude: 28.40,
    );
    final dere = await apiaries.create(
      orgId: _orgId,
      name: 'Dere',
      latitude: 37.15,
      longitude: 28.30,
    );
    await apiaries.create(orgId: _orgId, name: 'Konumsuz');
    await addHives(yayla.id, ['101', '102', '103']);
    await addHives(dere.id, ['201']);

    await _openMap(
      tester,
      db: db,
      basemap: FakeBasemapService(fail: false),
      overrides: [
        apiaryAttentionCountsProvider.overrideWith(
          (ref) async => {yayla.id: 2},
        ),
      ],
    );

    expect(find.text('3'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Konumsuz'), findsNothing);
    expect(find.byIcon(Icons.error_rounded), findsOneWidget);
    expect(
      find.bySemanticsLabel('Yayla, 3 hives, 2 hives need attention'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Dere, 1 hive'), findsOneWidget);
    expect(find.text(_attribution), findsOneWidget);
    expect(find.textContaining('No apiary has a location'), findsNothing);

    // Pin en az saha dokunma hedefi kadar.
    final pin = tester.getSize(find.bySemanticsLabel('Dere, 1 hive'));
    expect(pin.height, greaterThanOrEqualTo(56));

    await _tap(tester, find.text('3'));
    expect(find.byType(ApiaryDetailScreen), findsNothing);
    expect(find.text('Yayla'), findsOneWidget);
    expect(
      find.text('3 hives · 2 hives need attention · No visits yet'),
      findsOneWidget,
    );

    // Başka pine dokununca kart o arılığa geçer; boş yere dokununca kapanır.
    await _tap(tester, find.text('1'));
    expect(find.text('Yayla'), findsNothing);
    expect(find.text('Dere'), findsOneWidget);
    await tester.tapAt(
      tester.getTopLeft(find.byType(FlutterMap)) + const Offset(20, 20),
    );
    // Harita çift dokunmayı bekledikten sonra tek dokunmayı verir.
    await tester.pump(kDoubleTapTimeout);
    await tester.pumpAndSettle();
    expect(find.text('Dere'), findsNothing);
    expect(find.text('Directions'), findsNothing);

    await _tap(tester, find.text('3'));
    await _tap(tester, find.text('Show'));
    expect(find.byType(ApiaryDetailScreen), findsOneWidget);
    expect(find.text('Yayla'), findsOneWidget);
  });

  testWidgets('kurulu harita uygulaması yoksa Google Haritalar bağlantısı', (
    tester,
  ) async {
    await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 37.1,
      longitude: 28.4,
    );
    final launcher = FakeUrlLauncher();
    await _openMap(
      tester,
      db: db,
      basemap: FakeBasemapService(fail: false),
      urlLauncher: launcher,
    );

    await _tap(tester, find.text('0'));
    await _tap(tester, find.text('Directions'));
    expect(launcher.opened, [apiaryDirectionsUri(37.1, 28.4)]);
    expect(
      launcher.opened.single.toString(),
      'https://www.google.com/maps/dir/?api=1&destination=37.1%2C28.4',
    );

    launcher.available = false;
    await _tap(tester, find.text('Directions'));
    expect(find.text("Couldn't open a maps app."), findsOneWidget);
  });

  testWidgets('birden çok harita uygulaması varsa hangisi olacağı sorulur', (
    tester,
  ) async {
    await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 37.1,
      longitude: 28.4,
    );
    const apple = DirectionsApp(id: 'apple', name: 'Apple Maps');
    const yandex = DirectionsApp(id: 'yandexNavi', name: 'Yandex Navigator');
    final directions = FakeDirectionsService(apps: [apple, yandex]);
    final launcher = FakeUrlLauncher();
    await _openMap(
      tester,
      db: db,
      basemap: FakeBasemapService(fail: false),
      directions: directions,
      urlLauncher: launcher,
    );

    await _tap(tester, find.text('0'));
    await _tap(tester, find.text('Directions'));
    expect(find.text('Get directions with'), findsOneWidget);
    expect(find.text('Apple Maps'), findsOneWidget);
    expect(find.text('Yandex Navigator'), findsOneWidget);

    await _tap(tester, find.text('Yandex Navigator'));
    expect(find.text('Get directions with'), findsNothing);
    expect(directions.opened.single.app, yandex);
    expect(directions.opened.single.latitude, 37.1);
    expect(directions.opened.single.longitude, 28.4);
    expect(directions.opened.single.title, 'Yayla');
    expect(launcher.opened, isEmpty);

    // Sayfa kapatılırsa hiçbir şey açılmaz.
    await _tap(tester, find.text('Directions'));
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Get directions with'), findsNothing);
    expect(directions.opened, hasLength(1));

    directions.fail = true;
    await _tap(tester, find.text('Directions'));
    await _tap(tester, find.text('Apple Maps'));
    expect(find.text("Couldn't open a maps app."), findsOneWidget);
  });

  testWidgets('tek harita uygulaması doğrudan açılır', (tester) async {
    await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 37.1,
      longitude: 28.4,
    );
    const apple = DirectionsApp(id: 'apple', name: 'Apple Maps');
    final directions = FakeDirectionsService(apps: [apple]);
    await _openMap(
      tester,
      db: db,
      basemap: FakeBasemapService(fail: false),
      directions: directions,
    );

    await _tap(tester, find.text('0'));
    await _tap(tester, find.text('Directions'));
    expect(find.text('Get directions with'), findsNothing);
    expect(directions.opened.single.app, apple);
  });

  testWidgets('konumlu arılık yoksa harita üstünde açıklama', (tester) async {
    await apiaries.create(orgId: _orgId, name: 'Konumsuz');
    await _openMap(tester, db: db, basemap: FakeBasemapService(fail: false));

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.textContaining('No apiary has a location'), findsOneWidget);
    expect(find.text(_attribution), findsOneWidget);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await apiaries.create(
      orgId: _orgId,
      name: 'Yayla',
      latitude: 37.1,
      longitude: 28.4,
    );
    final basemap = FakeBasemapService();
    final container = await _openMap(tester, db: db, basemap: basemap);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Liste'), findsOneWidget);
    expect(find.text('Harita'), findsOneWidget);
    expect(find.text('Harita açılamadı'), findsOneWidget);
    expect(
      find.text('Harita için internet gerekiyor. Arılıklarınız aşağıda.'),
      findsOneWidget,
    );

    basemap.fail = false;
    await _tap(tester, find.text('Yeniden dene'));
    expect(
      find.text('© OpenFreeMap © OpenMapTiles © OpenStreetMap katkıcıları'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('Yayla, Kovan yok'), findsOneWidget);

    await _tap(tester, find.text('0'));
    expect(find.text('Yol tarifi'), findsOneWidget);
    expect(find.text('Göster'), findsOneWidget);
    expect(find.text('Kovan yok · Henüz ziyaret yok'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final yayla = await apiaries.create(
      orgId: _orgId,
      name: 'Yukarı Kocaçam Yaylası Kestane Arılığı',
      latitude: 37.1,
      longitude: 28.4,
    );
    await addHives(yayla.id, ['101']);

    final basemap = FakeBasemapService();
    final container = await _openMap(
      tester,
      db: db,
      basemap: basemap,
      overrides: [
        apiaryAttentionCountsProvider.overrideWith(
          (ref) async => {yayla.id: 1},
        ),
      ],
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Map unavailable'), findsOneWidget);

    basemap.fail = false;
    await _tap(tester, find.text('Try again'));
    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.error_rounded), findsOneWidget);
    expect(find.text(_attribution), findsOneWidget);

    await _tap(tester, find.text('1'));
    expect(tester.takeException(), isNull);
    expect(find.text('Directions'), findsOneWidget);
    expect(find.text('Show'), findsOneWidget);
  });
}
