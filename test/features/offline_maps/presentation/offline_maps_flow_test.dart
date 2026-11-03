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
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_screen.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_connectivity_service.dart';
import '../../../helpers/fake_offline_maps.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

const List<({String id, Map<String, String> name, List<double> bbox})> _packs =
    [
      (
        id: 'tr-48',
        name: {'tr': 'Muğla', 'en': 'Mugla'},
        bbox: [27.2, 36.3, 29.6, 37.6],
      ),
      (
        id: 'tr-33',
        name: {'tr': 'Mersin', 'en': 'Mersin'},
        bbox: [32.5, 36.0, 35.2, 37.5],
      ),
      (
        id: 'tr-35',
        name: {'tr': 'İzmir', 'en': 'Izmir'},
        bbox: [26.2, 37.8, 28.5, 39.4],
      ),
    ];

void main() {
  late AppDatabase db;
  late FakeOfflineMaps maps;
  late FakeConnectivityService connectivity;

  setUp(() {
    db = openTestDatabase();
    maps = FakeOfflineMaps();
    connectivity = FakeConnectivityService();
  });

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

  /// Ayarlar'dan offline haritalara geçer.
  Future<ProviderContainer> openMaps(WidgetTester tester) async {
    final container = await openSettings(tester);
    // Küçük ekranda satır ilk görünümün altında kalır.
    await tester.scrollUntilVisible(
      find.text('Offline maps'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(SettingsScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tap(tester, find.text('Offline maps'));
    expect(find.byType(OfflineMapsScreen), findsOneWidget);
    return container;
  }

  Future<void> seedPlaces() async {
    await ApiaryRepository(db)
        .create(orgId: _orgId, name: 'Yayla', latitude: 37.1, longitude: 28.4);
    final repository = MigrationRepository(db);
    final migration = await repository.create(
      orgId: _orgId,
      year: 2026,
      name: 'Göç',
    );
    await repository.stops.create(
      orgId: _orgId,
      migrationId: migration.id,
      plan: (
        position: 1,
        name: 'Citrus',
        place: 'Erdemli, Mersin',
        plannedStartOn: DateTime(2027, 3),
        plannedEndOn: DateTime(2027, 4),
        apiaryId: null,
        hiveCount: null,
        status: MigrationStopStatus.planned,
      ),
    );
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

  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find
            .descendant(
              of: find.byType(OfflineMapsScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );

  Finder row(String title) =>
      find.ancestor(of: find.text(title), matching: find.byType(ListRow));

  testWidgets('Ayarlar satırı; önerilen ve tüm bölgeler boyutla', (
    tester,
  ) async {
    await seedPlaces();
    maps.publish(_packs);
    await openSettings(tester);
    expect(
      find.descendant(of: row('Offline maps'), matching: find.text('None')),
      findsOneWidget,
    );

    await tap(tester, find.text('Offline maps'));
    expect(
      find.text(
        'Download the regions where your apiaries are; the map opens even '
        'without signal.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('SUGGESTED · APIARIES AND MIGRATION PLAN'),
      findsOneWidget,
    );
    expect(find.text('1 apiary · ≈ 2 MB'), findsOneWidget);
    expect(find.text('Citrus stop · ≈ 2 MB'), findsOneWidget);
    expect(find.text('ALL REGIONS'), findsOneWidget);
    expect(
      find.descendant(of: row('Izmir'), matching: find.text('≈ 2 MB')),
      findsOneWidget,
    );
    expect(find.byTooltip('Download Mugla'), findsOneWidget);
    await scrollTo(
      tester,
      find.text('Map data © OpenStreetMap contributors · OpenFreeMap'),
    );
  });

  testWidgets(
    'indirirken yüzde ve MB; bitince indirilmiş kart ve ayar satırı',
    (tester) async {
      await seedPlaces();
      maps
        ..publish(_packs)
        ..hold = Completer<void>();
      await openMaps(tester);

      await tester.tap(find.byTooltip('Download Mugla'));
      await tester.pump();
      await tester.pump();
      expect(find.text('50%'), findsOneWidget);
      expect(find.text('Downloading on Wi‑Fi · 1 / 2 MB'), findsOneWidget);
      expect(find.byTooltip('Download Mugla'), findsNothing);

      maps.hold!.complete();
      await settle(tester);
      expect(find.text('Mugla downloaded'), findsOneWidget);
      expect(find.text('Downloaded · 2 MB'), findsOneWidget);
      expect(find.text('1 apiary · updated: Sep 2026'), findsOneWidget);
      expect(find.byTooltip('Download Mugla'), findsNothing);
      expect((await maps.store.packFile('tr-48')).existsSync(), isTrue);
      expect(await maps.store.readStyle(), isNotNull);

      await tap(tester, find.byTooltip('Back'));
      expect(find.text('1 region · 2 MB'), findsOneWidget);
    },
  );

  testWidgets('durdurulan indirme yarım dosya bırakmaz', (tester) async {
    maps
      ..publish(_packs)
      ..hold = Completer<void>();
    await openMaps(tester);

    await tester.tap(find.byTooltip('Download Izmir'));
    await tester.pump();
    await tester.pump();
    expect(find.text('50%'), findsOneWidget);

    await tester.tap(find.byTooltip('Stop download'));
    await tester.pumpAndSettle();
    expect(find.text('50%'), findsNothing);
    expect(find.byTooltip('Download Izmir'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(await maps.store.installed(), isEmpty);
    expect((await maps.store.partialFile('tr-35')).existsSync(), isFalse);
    maps.hold!.complete();
  });

  testWidgets('Wi‑Fi yokken başlamaz; seçenek kapatılınca mobil veriyle iner', (
    tester,
  ) async {
    maps.publish(_packs);
    connectivity.unmetered = false;
    await openMaps(tester);

    await tap(tester, find.byTooltip('Download Izmir'));
    expect(
      find.text('Connect to Wi‑Fi or turn off "Download on Wi‑Fi only".'),
      findsOneWidget,
    );
    expect(await maps.store.installed(), isEmpty);
    expect(maps.requested, isEmpty);

    await tap(tester, find.text('Download on Wi‑Fi only'));
    expect(await LocalSettingsRepository(db).mapWifiOnly(), isFalse);
    await tap(tester, find.byTooltip('Download Izmir'));
    await settle(tester);
    expect(find.text('Izmir downloaded'), findsOneWidget);
    expect(find.text('Downloaded · 2 MB'), findsOneWidget);
  });

  testWidgets('bozuk paket kurulmaz, hata söylenir', (tester) async {
    maps.publish(_packs);
    final url = maps.served.keys.firstWhere((url) => url.contains('tr-35'));
    maps.served[url] = maps.served[url]!.sublist(1);
    await openMaps(tester);

    await tap(tester, find.byTooltip('Download Izmir'));
    await settle(tester);
    expect(
      find.text(
        "Couldn't download Izmir. Check your connection and try again.",
      ),
      findsOneWidget,
    );
    expect(await maps.store.installed(), isEmpty);
    expect((await maps.store.partialFile('tr-35')).existsSync(), isFalse);
  });

  testWidgets('katalog yoksa mesaj ve yeniden dene; indirilen bölge listede', (
    tester,
  ) async {
    await maps.install('tr-48');
    await openMaps(tester);

    expect(find.text('Mugla'), findsOneWidget);
    expect(find.text('Downloaded · 84 MB'), findsOneWidget);
    expect(find.text("Couldn't load the region list"), findsOneWidget);

    maps.publish(_packs);
    await tap(tester, find.text('Try again'));
    expect(find.text("Couldn't load the region list"), findsNothing);
    expect(find.byTooltip('Download Izmir'), findsOneWidget);
    // İndirilmiş bölge yeniden önerilmez.
    expect(find.byTooltip('Download Mugla'), findsNothing);
  });

  testWidgets('yeniden denerken yükleniyor görünür; yine olmazsa mesaj', (
    tester,
  ) async {
    await openMaps(tester);
    expect(find.text("Couldn't load the region list"), findsOneWidget);

    maps.catalogHold = Completer<void>();
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(find.text("Couldn't load the region list"), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    maps.catalogHold!.complete();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text("Couldn't load the region list"), findsOneWidget);
  });

  testWidgets('silme onay ister; vazgeçince kalır', (tester) async {
    await maps.install('tr-48');
    maps.publish(_packs);
    await openMaps(tester);

    await tap(tester, find.byTooltip('Delete Mugla'));
    expect(find.text('Delete Mugla?'), findsOneWidget);
    await tap(tester, find.text('Cancel'));
    expect(find.text('Downloaded · 84 MB'), findsOneWidget);

    await tap(tester, find.byTooltip('Delete Mugla'));
    await tap(tester, find.widgetWithText(TextButton, 'Delete'));
    expect(find.text('Downloaded · 84 MB'), findsNothing);
    expect(find.byTooltip('Download Mugla'), findsOneWidget);
    expect(await maps.store.installed(), isEmpty);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await seedPlaces();
    await maps.install('tr-48');
    maps.publish(_packs);
    final container = await openSettings(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('1 bölge · 84 MB'), findsOneWidget);
    await tap(tester, find.text('Offline haritalar'));
    expect(
      find.text(
        'Arılıklarının olduğu bölgeyi indir; çekmeyen yerde de harita açılır.',
      ),
      findsOneWidget,
    );
    expect(find.text('Muğla'), findsOneWidget);
    expect(find.text('İndirildi · 84 MB'), findsOneWidget);
    expect(find.text('1 arılık · güncelleme: Eyl 2026'), findsOneWidget);
    expect(find.text("Sadece Wi‑Fi'da indir"), findsOneWidget);
    expect(find.text('ÖNERİLEN · ARILIKLAR VE GÖÇ PLANI'), findsOneWidget);
    expect(find.text('Citrus durağı · ≈ 2 MB'), findsOneWidget);
    expect(find.text('TÜM BÖLGELER'), findsOneWidget);
    expect(find.byTooltip('İzmir indir'), findsOneWidget);
    await scrollTo(
      tester,
      find.text('Harita verisi © OpenStreetMap katkıcıları · OpenFreeMap'),
    );

    await tap(tester, find.byTooltip('Muğla sil'));
    expect(find.text('Muğla silinsin mi?'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await seedPlaces();
    await maps.install(
      'tr-48',
      name: {'en': 'Muğla – Köyceğiz ve Ortaca Kıyı Şeridi'},
    );
    maps
      ..publish(_packs)
      ..hold = Completer<void>();
    final container = await openMaps(tester);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await scrollTo(tester, find.byTooltip('Download Izmir'));
    await tester.tap(find.byTooltip('Download Izmir'));
    await tester.pump();
    await tester.pump();
    expect(tester.takeException(), isNull);
    maps.hold!.complete();
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Izmir downloaded'), findsOneWidget);
  });
}
