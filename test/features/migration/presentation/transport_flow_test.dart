import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/data/transport_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_code_scanner.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_screen_awake.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Finder _button(String label) => find.widgetWithText(BigButton, label);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Kontrol listesinin dört maddesini işaretler.
Future<void> _tickChecklist(WidgetTester tester) async {
  for (final item in [
    'Entrances closed',
    'Ventilation open',
    'Straps tight',
    'Water ready',
  ]) {
    await _tap(tester, find.widgetWithText(CheckboxListTile, item));
  }
}

typedef _Seed = ({
  String migrationId,
  String camId,
  String kislakId,
  Map<String, Hive> hives,
});

void main() {
  late AppDatabase db;
  late FakeCodeScanner scanner;
  late FakeScreenAwake screenAwake;
  final today = DateUtils.dateOnly(DateTime.now());
  DateTime inDays(int days) =>
      DateTime(today.year, today.month, today.day + days);

  setUp(() {
    db = openTestDatabase();
    scanner = FakeCodeScanner();
    screenAwake = FakeScreenAwake();
  });

  /// Çam (şu an, kovan 101–103 ve sönmüş 104) → Kışlak (plan) göç planı;
  /// başka arılıkta kovan 7.
  Future<_Seed> seed({bool destinationApiary = true}) async {
    final apiaries = ApiaryRepository(db);
    final cam = await apiaries.create(orgId: _orgId, name: 'Çam');
    final kislak = await apiaries.create(orgId: _orgId, name: 'Kışlak');
    final other = await apiaries.create(orgId: _orgId, name: 'Ova');
    final hiveRepository = HiveRepository(db);
    final hives = <String, Hive>{};
    for (final (number, apiaryId, status) in [
      ('101', cam.id, HiveStatus.active),
      ('102', cam.id, HiveStatus.active),
      ('103', cam.id, HiveStatus.active),
      ('104', cam.id, HiveStatus.dead),
      ('7', other.id, HiveStatus.active),
    ]) {
      hives[number] = await hiveRepository.create(
        orgId: _orgId,
        number: number,
        type: HiveType.langstroth,
        apiaryId: apiaryId,
        status: status,
      );
    }
    final migrations = MigrationRepository(db);
    final migration = await migrations.create(
      orgId: _orgId,
      year: today.year,
      name: 'Göç planı',
    );
    Future<void> stop(
      int position,
      String name,
      MigrationStopStatus status,
      String? apiaryId,
    ) => migrations.stops.create(
      orgId: _orgId,
      migrationId: migration.id,
      plan: (
        position: position,
        name: name,
        place: null,
        plannedStartOn: inDays(position * 30 - 60),
        plannedEndOn: inDays(position * 30 - 31),
        apiaryId: apiaryId,
        hiveCount: 3,
        status: status,
      ),
    );
    await stop(1, 'Çam', MigrationStopStatus.current, cam.id);
    await stop(
      2,
      'Kışlak',
      MigrationStopStatus.planned,
      destinationApiary ? kislak.id : null,
    );
    return (
      migrationId: migration.id,
      camId: cam.id,
      kislakId: kislak.id,
      hives: hives,
    );
  }

  Future<ProviderContainer> open(WidgetTester tester, String location) async {
    final container = ProviderContainer.test(
      overrides: signedIn(db: db, scanner: scanner, screenAwake: screenAwake),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    container.read(routerProvider).go(location);
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> scan(WidgetTester tester, Hive hive) async {
    scanner.scan(hiveLabelCode(hive.id));
    await tester.pumpAndSettle();
  }

  Future<Transport> currentTransport() => db.select(db.transports).getSingle();

  testWidgets('kontrol listesi → okutarak yükleme → indirme → kovanlar '
      'hedef arılıkta', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final seeded = await seed();
    final hives = seeded.hives;
    await open(tester, AppRoutes.migrationMove(seeded.migrationId));

    // Kontrol: nereden, nereye; liste bitmeden yüklemeye geçilmez.
    expect(find.text('Move · Çam → Kışlak'), findsOneWidget);
    expect(find.text('3 active hives'), findsOneWidget);
    expect(
      tester.widget<BigButton>(_button('Start loading')).onPressed,
      isNull,
    );
    await _tickChecklist(tester);

    // İkinci araç; aynı ad reddedilir.
    await _tap(tester, _button('Add vehicle'));
    expect(find.text('Truck 2'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Truck 1');
    await _tap(tester, find.widgetWithText(TextButton, 'Add vehicle'));
    expect(find.text('A vehicle with this name exists'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Römork');
    await _tap(tester, find.widgetWithText(TextButton, 'Add vehicle'));
    expect(find.text('Römork'), findsOneWidget);

    await _tap(tester, _button('Start loading'));
    var transport = await currentTransport();
    expect(transport.vehicles, ['Truck 1', 'Römork']);
    expect(transport.sourceApiaryId, seeded.camId);
    expect(transport.destinationApiaryId, seeded.kislakId);

    // Yükleme: sayaç, araçlar ve okunmayanlar.
    expect(find.text('Truck 1 · 0'), findsOneWidget);
    expect(find.text('Römork · 0'), findsOneWidget);
    expect(find.text('0 / 3'), findsOneWidget);
    expect(find.text('3 hives not scanned yet'), findsOneWidget);
    expect(
      tester.widget<BigButton>(_button('Go to unloading')).onPressed,
      isNull,
    );

    // Sürekli okutma: kamera açık kalır, kovanlar ard arda okunur.
    await _tap(tester, _button('Start scanning'));
    expect(screenAwake.keptOn, isTrue);
    await scan(tester, hives['101']!);
    expect(find.text('101 loaded · Truck 1'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
    expect(scanner.isOpen, isTrue);
    // Aynı kod art arda gelince yeniden işlenmez.
    await scan(tester, hives['101']!);
    expect(find.text('101 loaded · Truck 1'), findsOneWidget);

    await _tap(tester, find.text('Römork · 0'));
    await scan(tester, hives['102']!);
    expect(find.text('102 loaded · Römork'), findsOneWidget);
    await scan(tester, hives['101']!);
    expect(find.text('101 is already loaded'), findsOneWidget);
    await scan(tester, hives['7']!);
    expect(
      find.text("7 loaded; this hive wasn't at this apiary"),
      findsOneWidget,
    );
    scanner.scan('bilinmeyen-kod');
    await tester.pumpAndSettle();
    expect(find.text('Unknown label'), findsOneWidget);
    expect(find.text('3 / 4'), findsOneWidget);

    await _tap(tester, _button('Done'));
    expect(screenAwake.keptOn, isFalse);
    expect(find.text('Truck 1 · 1'), findsOneWidget);
    expect(find.text('Römork · 2'), findsOneWidget);
    expect(find.text('Last scanned: 7'), findsOneWidget);
    expect(find.text('1 hive not scanned yet'), findsOneWidget);
    await _tap(tester, find.text('See list'));
    expect(find.text('Hives not scanned'), findsOneWidget);
    expect(find.text('Hive 103'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    // Okunmayan kovanla indirmeye geçmek onay ister.
    await _tap(tester, _button('Go to unloading'));
    expect(find.text('1 hive not scanned'), findsOneWidget);
    await _tap(tester, find.widgetWithText(TextButton, 'Go to unloading'));
    transport = await currentTransport();
    expect(transport.status, TransportStatus.unloading);

    // İndirme: yüklenenler üzerinden sayılır.
    expect(find.text('UNLOADED'), findsOneWidget);
    expect(find.text('0 / 3'), findsOneWidget);
    await _tap(tester, _button('Start scanning'));
    await scan(tester, hives['101']!);
    expect(find.text('101 unloaded'), findsOneWidget);
    await scan(tester, hives['103']!);
    expect(find.text("103 wasn't loaded on this move"), findsOneWidget);
    await scan(tester, hives['7']!);
    expect(find.text('7 unloaded'), findsOneWidget);
    await _tap(tester, _button('Done'));
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.text('1 hive not scanned yet'), findsOneWidget);

    // Eksikle bitirmek onay ister; indirilmeyen kovan yerinde kalır.
    await _tap(tester, _button('Finish move'));
    expect(find.text('1 hive not unloaded'), findsOneWidget);
    await _tap(tester, find.widgetWithText(TextButton, 'Finish'));

    expect(find.text('Move finished'), findsOneWidget);
    expect(find.text('Loaded 3 · Unloaded 2'), findsOneWidget);
    expect(find.text('2 hives moved to Kışlak.'), findsOneWidget);
    expect(find.text('HIVES NOT UNLOADED'), findsOneWidget);
    expect(find.text('Hive 102'), findsOneWidget);

    final hiveRepository = HiveRepository(db);
    expect(
      (await hiveRepository.findById(hives['101']!.id))!.apiaryId,
      seeded.kislakId,
    );
    expect(
      (await hiveRepository.findById(hives['7']!.id))!.apiaryId,
      seeded.kislakId,
    );
    expect(
      (await hiveRepository.findById(hives['102']!.id))!.apiaryId,
      seeded.camId,
    );
    final history = await tester.runAsync(
      () => HiveLocationRepository(db).watchByHive(hives['101']!.id).first,
    );
    expect(history!.map((e) => e.apiaryId), contains(seeded.kislakId));
    expect((await currentTransport()).status, TransportStatus.completed);

    // Hedef durak şu an, kovan sayısı indirilen; ekran özette kalır.
    final stops = await db.select(db.migrationStops).get();
    final arrived = stops.firstWhere((s) => s.name == 'Kışlak');
    expect(arrived.status, MigrationStopStatus.current);
    expect(arrived.hiveCount, 2);
    expect(
      stops.firstWhere((s) => s.name == 'Çam').status,
      MigrationStopStatus.past,
    );
    expect(find.text('Move · Çam → Kışlak'), findsOneWidget);
    expect(find.text('Move finished'), findsOneWidget);
  });

  testWidgets('numara girerek yükler; bilinmeyen numara söylenir', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(800, 2000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final seeded = await seed();
    final transport = await TransportRepository(db).start(
      orgId: _orgId,
      migrationStopId: (await db.select(db.migrationStops).get())
          .firstWhere((s) => s.name == 'Kışlak')
          .id,
      sourceApiaryId: seeded.camId,
      destinationApiaryId: seeded.kislakId,
      vehicles: ['Truck 1'],
    );
    await open(tester, AppRoutes.migrationMove(seeded.migrationId));

    await _tap(tester, _button('Enter number'));
    await tester.enterText(find.byType(TextField), '999');
    await _tap(tester, find.widgetWithText(TextButton, 'Loading'));
    expect(find.text('No hive numbered 999'), findsOneWidget);

    await _tap(tester, _button('Enter number'));
    await tester.enterText(find.byType(TextField), ' 102 ');
    await _tap(tester, find.widgetWithText(TextButton, 'Loading'));
    expect(find.text('102 loaded · Truck 1'), findsOneWidget);
    expect(find.text('1 / 3'), findsOneWidget);
    final items = await TransportRepository(db).items
        .findByTransport(transport.id);
    expect(items.single.hiveId, seeded.hives['102']!.id);
  });

  testWidgets('durağın arılığı yoksa durağı düzenlemeyi önerir', (
    tester,
  ) async {
    final seeded = await seed(destinationApiary: false);
    await open(tester, AppRoutes.migrationMove(seeded.migrationId));

    expect(find.text('The stop has no apiary'), findsOneWidget);
    await _tap(tester, find.text('Edit stop'));
    expect(find.text('Edit stop'), findsWidgets);
    expect(await db.select(db.transports).get(), isEmpty);
  });

  testWidgets('Türkçe metinler', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2000)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final seeded = await seed();
    final container = await open(
      tester,
      AppRoutes.migrationMove(seeded.migrationId),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Taşıma · Çam → Kışlak'), findsOneWidget);
    expect(find.text('YÜKLEME KONTROL LİSTESİ'), findsOneWidget);
    expect(find.text('Uçuş delikleri kapalı'), findsOneWidget);
    expect(find.text('Kamyon 1'), findsOneWidget);
    for (final item in [
      'Uçuş delikleri kapalı',
      'Havalandırma açık',
      'Kayışlar sıkı',
      'Su hazır',
    ]) {
      await _tap(tester, find.widgetWithText(CheckboxListTile, item));
    }
    await _tap(tester, _button('Yüklemeye başla'));

    expect(find.text('Kamyon 1 · 0'), findsOneWidget);
    expect(find.text('YÜKLENEN'), findsOneWidget);
    expect(find.text('3 kovan henüz okunmadı'), findsOneWidget);
    expect(find.text('Listeyi gör'), findsOneWidget);
    expect(_button('Numara gir'), findsOneWidget);
    expect(_button('Okutmaya başla'), findsOneWidget);

    await _tap(tester, _button('Okutmaya başla'));
    await scan(tester, seeded.hives['101']!);
    expect(find.text('101 yüklendi · Kamyon 1'), findsOneWidget);
    await _tap(tester, _button('Bitti'));
    expect(_button('Okutmaya devam'), findsOneWidget);
    expect(find.text('Son okunan: 101'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final seeded = await seed();
    final container = await open(
      tester,
      AppRoutes.migrationMove(seeded.migrationId),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tickChecklist(tester);
    await _tap(tester, _button('Start loading'));
    expect(tester.takeException(), isNull);

    await _tap(tester, _button('Start scanning'));
    await scan(tester, seeded.hives['101']!);
    expect(tester.takeException(), isNull);
    await _tap(tester, _button('Done'));
    expect(tester.takeException(), isNull);
  });
}
