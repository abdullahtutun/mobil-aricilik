import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/map_area_downloader.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area_rules.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_screen.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_connectivity_service.dart';
import '../../../helpers/fake_offline_maps.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

MapArea _area(Apiary apiary) => MapArea(
  id: apiary.id,
  name: apiary.name,
  latitude: apiary.latitude!,
  longitude: apiary.longitude!,
);

/// Satırdaki tahmini boyut, İngilizce: "≈ 2.8 MB".
String _approx(MapArea area) {
  final mb = estimateTileBytes(mapAreaTiles(area)) / (1024 * 1024);
  final text = mb < 10 ? mb.toStringAsFixed(1) : mb.toStringAsFixed(0);
  final trimmed = text.endsWith('.0')
      ? text.substring(0, text.length - 2)
      : text;
  return '≈ $trimmed MB';
}

void main() {
  late AppDatabase db;
  late FakeOfflineMaps maps;
  late FakeConnectivityService connectivity;

  setUp(() {
    db = openTestDatabase();
    maps = FakeOfflineMaps();
    connectivity = FakeConnectivityService();
  });

  Future<Apiary> addApiary(
    String name, {
    double? latitude = 37.1,
    double? longitude = 28.4,
  }) => ApiaryRepository(
    db,
  ).create(orgId: _orgId, name: name, latitude: latitude, longitude: longitude);

  /// Ayarlar'ı açar.
  Future<ProviderContainer> openSettings(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: [
        ...signedIn(db: db, offlineMaps: maps),
        connectivityServiceProvider.overrideWithValue(connectivity),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// İndirmenin sahte HTTP'de gerçek olay döngüsüne düşen adımlarını da
  /// bekler.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 1)),
      );
      await tester.pumpAndSettle();
    }
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder, Type screen) =>
      tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find
            .descendant(
              of: find.byType(screen),
              matching: find.byType(Scrollable),
            )
            .first,
      );

  /// Ayarlar'dan offline haritalara geçer.
  Future<ProviderContainer> openMaps(WidgetTester tester) async {
    final container = await openSettings(tester);
    // Küçük ekranda satır ilk görünümün altında kalır.
    await scrollTo(tester, find.text('Offline maps'), SettingsScreen);
    await tap(tester, find.text('Offline maps'));
    expect(find.byType(OfflineMapsScreen), findsOneWidget);
    return container;
  }

  Finder row(String title) =>
      find.ancestor(of: find.text(title), matching: find.byType(ListRow));

  testWidgets('Ayarlar satırı; konumlu arılıklar tahmini boyut ve göç '
      'durağıyla', (tester) async {
    final yayla = await addApiary('Yayla');
    final cam = await addApiary('Çam', latitude: 41, longitude: 37.6);
    await addApiary('Ova', latitude: null, longitude: null);
    final migrations = MigrationRepository(db);
    final migration = await migrations.create(
      orgId: _orgId,
      year: 2026,
      name: 'Göç',
    );
    await migrations.stops.create(
      orgId: _orgId,
      migrationId: migration.id,
      plan: (
        position: 1,
        name: 'Citrus',
        place: null,
        plannedStartOn: DateTime(2027, 3),
        plannedEndOn: DateTime(2027, 4),
        apiaryId: cam.id,
        hiveCount: null,
        status: MigrationStopStatus.planned,
      ),
    );
    await openSettings(tester);
    expect(
      find.descendant(of: row('Offline maps'), matching: find.text('None')),
      findsOneWidget,
    );

    await tap(tester, find.text('Offline maps'));
    expect(
      find.text(
        'Download the area around your apiaries; the map opens even without '
        'signal.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Each apiary gets 6 km around it in detail and 40 km as an overview.',
      ),
      findsOneWidget,
    );
    expect(find.text('APIARIES TO DOWNLOAD'), findsOneWidget);
    expect(
      find.descendant(
        of: row('Yayla'),
        matching: find.text(_approx(_area(yayla))),
      ),
      findsOneWidget,
    );
    expect(find.text('Citrus stop · ${_approx(_area(cam))}'), findsOneWidget);
    expect(find.byTooltip('Download Ova'), findsNothing);
    await scrollTo(
      tester,
      find.text('Map data © OpenStreetMap contributors · OpenFreeMap'),
      OfflineMapsScreen,
    );
  });

  testWidgets('indirirken yüzde ve MB; bitince indirilmiş kart ve ayar '
      'satırı; istekler User-Agent ile', (tester) async {
    final yayla = await addApiary('Yayla');
    maps.hold = Completer<void>();
    await openMaps(tester);

    await tester.tap(find.byTooltip('Download Yayla'));
    await settle(tester);
    final total = mapAreaTiles(_area(yayla)).length;
    final percent = (maps.holdAfter / total * 100).round();
    expect(find.text('$percent%'), findsOneWidget);
    expect(
      find.text('Downloading on Wi‑Fi · 0.2 / ${_approx(_area(yayla))}'),
      findsOneWidget,
    );
    expect(find.byTooltip('Download Yayla'), findsNothing);

    maps.hold!.complete();
    await settle(tester);
    expect(find.text('Area around Yayla downloaded'), findsOneWidget);
    expect(find.textContaining('Downloaded · '), findsOneWidget);
    expect(find.textContaining('downloaded: '), findsOneWidget);
    expect(find.byTooltip('Download Yayla'), findsNothing);
    expect(
      find.text('All apiaries with a location are downloaded.'),
      findsOneWidget,
    );
    expect((await maps.store.areaFile(yayla.id)).existsSync(), isTrue);
    expect(await maps.store.readStyle(), isNotNull);
    expect((await maps.store.installed()).single.tileCount, total);
    expect(
      maps.requested.where((url) => url.startsWith('https://tiles.test/')),
      hasLength(total),
    );
    expect(maps.userAgents, {MapAreaDownloader.defaultUserAgent});

    await tap(tester, find.byTooltip('Back'));
    expect(find.textContaining('1 apiary · '), findsOneWidget);
  });

  testWidgets('durdurulan indirme yarım dosya bırakmaz', (tester) async {
    final yayla = await addApiary('Yayla');
    maps.hold = Completer<void>();
    await openMaps(tester);

    await tester.tap(find.byTooltip('Download Yayla'));
    await settle(tester);
    expect(find.byTooltip('Stop download'), findsOneWidget);

    await tester.tap(find.byTooltip('Stop download'));
    await settle(tester);
    expect(find.byTooltip('Stop download'), findsNothing);
    expect(find.byTooltip('Download Yayla'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(await maps.store.installed(), isEmpty);
    expect((await maps.store.partialFile(yayla.id)).existsSync(), isFalse);
    maps.hold!.complete();
    await settle(tester);
  });

  testWidgets('Wi‑Fi yokken başlamaz; seçenek kapatılınca mobil veriyle iner', (
    tester,
  ) async {
    await addApiary('Yayla');
    connectivity.unmetered = false;
    await openMaps(tester);

    await tap(tester, find.byTooltip('Download Yayla'));
    await settle(tester);
    expect(
      find.text('Connect to Wi‑Fi or turn off "Download on Wi‑Fi only".'),
      findsOneWidget,
    );
    expect(maps.requested, isEmpty);

    await tap(tester, find.text('Download on Wi‑Fi only'));
    expect(await LocalSettingsRepository(db).mapWifiOnly(), isFalse);
    await tap(tester, find.byTooltip('Download Yayla'));
    await settle(tester);
    expect(find.text('Area around Yayla downloaded'), findsOneWidget);
  });

  testWidgets('sunucu hatasında alan kurulmaz, hata söylenir', (tester) async {
    final yayla = await addApiary('Yayla');
    maps.tileStatus = 500;
    await openMaps(tester);

    await tap(tester, find.byTooltip('Download Yayla'));
    await settle(tester);
    expect(
      find.text(
        "Couldn't download the area around Yayla. Check your connection and "
        'try again.',
      ),
      findsOneWidget,
    );
    expect(await maps.store.installed(), isEmpty);
    expect((await maps.store.partialFile(yayla.id)).existsSync(), isFalse);
    expect(find.byTooltip('Download Yayla'), findsOneWidget);
  });

  testWidgets('taşınan arılık yeniden indirilmeye çıkar', (tester) async {
    final yayla = await addApiary('Yayla');
    await maps.install(_area(yayla).copyWith(latitude: 37.2));
    await openMaps(tester);

    expect(find.text('Downloaded · 3 MB'), findsOneWidget);
    expect(
      find.text('Apiary moved, download again · ${_approx(_area(yayla))}'),
      findsOneWidget,
    );
  });

  testWidgets('konumlu arılık yoksa açıklama', (tester) async {
    await addApiary('Ova', latitude: null, longitude: null);
    await openMaps(tester);
    expect(
      find.text(
        'No apiaries with a location. Add a location to an apiary and it '
        'shows up here.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('silme onay ister; vazgeçince kalır', (tester) async {
    final yayla = await addApiary('Yayla');
    await maps.install(_area(yayla));
    await openMaps(tester);

    await tap(tester, find.byTooltip('Delete Yayla'));
    expect(find.text('Delete Yayla?'), findsOneWidget);
    await tap(tester, find.text('Cancel'));
    expect(find.text('Downloaded · 3 MB'), findsOneWidget);

    await tap(tester, find.byTooltip('Delete Yayla'));
    await tap(tester, find.widgetWithText(TextButton, 'Delete'));
    expect(find.text('Downloaded · 3 MB'), findsNothing);
    expect(find.byTooltip('Download Yayla'), findsOneWidget);
    expect(await maps.store.installed(), isEmpty);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final yayla = await addApiary('Yayla');
    await addApiary('Çam', latitude: 41, longitude: 37.6);
    await maps.install(_area(yayla));
    final container = await openSettings(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('1 arılık · 3 MB'), findsOneWidget);
    await tap(tester, find.text('Offline haritalar'));
    expect(
      find.text(
        'Arılıklarının çevresini indir; çekmeyen yerde de harita açılır.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Her arılığın 6 km çevresi ayrıntılı, 40 km çevresi genel görünümle '
        'iner.',
      ),
      findsOneWidget,
    );
    expect(find.text('İndirildi · 3 MB'), findsOneWidget);
    expect(find.text('indirildi: 2 Kas 2026'), findsOneWidget);
    expect(find.text("Sadece Wi‑Fi'da indir"), findsOneWidget);
    expect(find.text('İNDİRİLECEK ARILIKLAR'), findsOneWidget);
    expect(find.byTooltip('Çam indir'), findsOneWidget);
    await scrollTo(
      tester,
      find.text('Harita verisi © OpenStreetMap katkıcıları · OpenFreeMap'),
      OfflineMapsScreen,
    );

    await tap(tester, find.byTooltip('Yayla sil'));
    expect(find.text('Yayla silinsin mi?'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final yayla = await addApiary('Yukarı Kocaçam Yaylası Kestane Arılığı');
    await maps.install(_area(yayla).copyWith(latitude: 37.3));
    const name = 'Ortaca Kıyı Şeridi Narenciye Bahçeleri';
    await addApiary(name, latitude: 36.8);
    maps.hold = Completer<void>();
    final container = await openMaps(tester);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final download = find.byTooltip('Download $name');
    await scrollTo(tester, download, OfflineMapsScreen);
    await tester.ensureVisible(download);
    await tester.pumpAndSettle();
    await tester.tap(download);
    await settle(tester);
    expect(find.byTooltip('Stop download'), findsOneWidget);
    expect(tester.takeException(), isNull);
    maps.hold!.complete();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Area around $name downloaded'), findsOneWidget);
  });
}
