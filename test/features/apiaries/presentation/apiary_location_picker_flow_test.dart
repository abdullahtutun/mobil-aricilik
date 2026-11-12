import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/location_service_provider.dart';
import 'package:mobil_arici/core/services/place_search_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_location_picker_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_basemap_service.dart';
import '../../../helpers/fake_location_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_place_search_service.dart';
import '../../../helpers/test_database.dart';

const _kemaliye = PlaceResult(
  name: 'Kemaliye',
  displayName: 'Kemaliye, Erzincan, Türkiye',
  latitude: 39.2611,
  longitude: 38.495,
);

/// Uygulamayı açar ve [location]'a gider.
Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakeBasemapService? basemap,
  FakePlaceSearchService? placeSearch,
  List<Override> overrides = const [],
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(
        db: db,
        basemap: basemap ?? FakeBasemapService(fail: false),
        placeSearch: placeSearch,
      ),
      locationServiceProvider.overrideWithValue(FakeLocationService()),
      ...overrides,
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder get _searchField => find.descendant(
  of: find.byType(ApiaryLocationPickerScreen),
  matching: find.byType(TextField),
);

Future<void> _search(WidgetTester tester, String query) async {
  await tester.enterText(_searchField, query);
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

BigButton _button(WidgetTester tester, String label) =>
    tester.widget<BigButton>(find.widgetWithText(BigButton, label));

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());

  testWidgets('il/ilçe aranır, haritada seçilen konum kaydedilir', (
    tester,
  ) async {
    final placeSearch = FakePlaceSearchService(results: [_kemaliye]);
    await _open(
      tester,
      db: db,
      location: AppRoutes.apiaryNew,
      placeSearch: placeSearch,
    );
    await tester.enterText(
      find.descendant(
        of: find.ancestor(
          of: find.text('Apiary name'),
          matching: find.byType(LabeledField),
        ),
        matching: find.byType(TextField),
      ),
      'Yayla',
    );
    await _tap(tester, find.text('Pick on map'));

    expect(find.byType(ApiaryLocationPickerScreen), findsOneWidget);
    await _search(tester, 'Kemaliye');

    expect(placeSearch.queries.single.query, 'Kemaliye');
    expect(placeSearch.queries.single.languageCode, 'en');
    expect(
      placeSearch.queries.single.countryCode,
      testOrganization.countryCode,
    );
    expect(find.text('Kemaliye, Erzincan, Türkiye'), findsOneWidget);

    await _tap(tester, find.text('Kemaliye, Erzincan, Türkiye'));
    expect(find.text('Kemaliye, Erzincan, Türkiye'), findsNothing);
    expect(find.text('39.26110, 38.49500'), findsOneWidget);

    await _tap(tester, find.text('Use this location'));

    expect(find.byType(ApiaryLocationPickerScreen), findsNothing);
    expect(find.text('39.26110, 38.49500'), findsOneWidget);
    // Haritada seçilen konumun doğruluğu bilinmez.
    expect(find.textContaining('Accuracy'), findsNothing);
    expect(find.text('Remove location'), findsOneWidget);

    await _tap(tester, find.text('Save'));
    expect(find.byType(ApiaryDetailScreen), findsOneWidget);
    final saved = (await db.select(db.apiaries).get()).single;
    expect(saved.latitude, closeTo(39.2611, 1e-9));
    expect(saved.longitude, closeTo(38.495, 1e-9));
  });

  testWidgets('kayıtlı konumla açılır; kapatınca konum değişmez', (
    tester,
  ) async {
    final yayla = await ApiaryRepository(db).create(
      orgId: testOrganization.id,
      name: 'Yayla',
      latitude: 40,
      longitude: 29,
    );
    await _open(tester, db: db, location: AppRoutes.apiaryEdit(yayla.id));
    await _tap(tester, find.text('Pick on map'));

    expect(
      find.descendant(
        of: find.byType(ApiaryLocationPickerScreen),
        matching: find.text('40.00000, 29.00000'),
      ),
      findsOneWidget,
    );
    await _tap(tester, find.byType(CloseButton));

    expect(find.byType(ApiaryLocationPickerScreen), findsNothing);
    expect(find.text('40.00000, 29.00000'), findsOneWidget);
  });

  testWidgets('internet yokken arama bunu söyler', (tester) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.locationPicker,
      placeSearch: FakePlaceSearchService(fail: true),
    );

    await _search(tester, 'Kemaliye');
    expect(
      find.text("Couldn't search. Search needs internet."),
      findsOneWidget,
    );

    await _search(tester, '');
    expect(find.text("Couldn't search. Search needs internet."), findsNothing);
  });

  testWidgets('harita açılamazsa konum seçilemez; yeniden denenir', (
    tester,
  ) async {
    final basemap = FakeBasemapService();
    await _open(
      tester,
      db: db,
      location: AppRoutes.locationPicker,
      basemap: basemap,
    );
    expect(find.text('Map unavailable'), findsOneWidget);
    expect(_button(tester, 'Use this location').onPressed, isNull);

    basemap.fail = false;
    await _tap(tester, find.text('Try again'));
    expect(find.text('Map unavailable'), findsNothing);
    expect(_button(tester, 'Use this location').onPressed, isNotNull);
  });

  // P9.2 madde 2: ilk açılışta yüklenemeyen harita, ekran yeniden
  // açılınca uygulamayı kapatmadan gelir.
  testWidgets('harita yüklenemediyse ekran yeniden açılınca yeniden denenir', (
    tester,
  ) async {
    final basemap = FakeBasemapService();
    await _open(
      tester,
      db: db,
      location: AppRoutes.apiaryNew,
      basemap: basemap,
    );
    await _tap(tester, find.text('Pick on map'));
    expect(find.text('Map unavailable'), findsOneWidget);
    await _tap(tester, find.byType(CloseButton));
    final loads = basemap.loadCount;

    basemap.fail = false;
    await _tap(tester, find.text('Pick on map'));

    expect(basemap.loadCount, loads + 1);
    expect(find.text('Map unavailable'), findsNothing);
    expect(_button(tester, 'Use this location').onPressed, isNotNull);
  });

  testWidgets('aranan yer yoksa söylenir; Türkçe', (tester) async {
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.locationPicker,
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Haritada konum seç'), findsOneWidget);
    expect(find.text('İl, ilçe ya da köy ara'), findsOneWidget);
    await _search(tester, 'Yokköy');
    expect(find.text('Sonuç bulunamadı. Başka bir ad dene.'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.apiaryNew,
      placeSearch: FakePlaceSearchService(results: [_kemaliye]),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Pick on map'));
    expect(tester.takeException(), isNull);

    await _search(tester, 'Kemaliye');
    expect(tester.takeException(), isNull);
    await _tap(tester, find.text('Kemaliye, Erzincan, Türkiye'));
    await _tap(tester, find.text('Use this location'));
    expect(tester.takeException(), isNull);
    expect(find.text('39.26110, 38.49500'), findsOneWidget);
  });
}
