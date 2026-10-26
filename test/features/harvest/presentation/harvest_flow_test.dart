import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_form_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_hives_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_scan_screen.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_code_scanner.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  RegionConfig? region,
  FakeCodeScanner? scanner,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db, scanner: scanner),
      if (region != null) regionConfigProvider.overrideWithValue(region),
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
  // Kaydırılan listede henüz kurulmamış olabilir.
  if (finder.evaluate().isEmpty) await tester.scrollUntilVisible(finder, 200);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _weight(WidgetTester tester, String text) async {
  final field = find.byType(TextField);
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await tester.pumpAndSettle();
}

Finder _button(String label) => find.widgetWithText(BigButton, label);

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<BigButton>(_button(label)).onPressed != null;

Finder _rich(String text) => find.textContaining(text, findRichText: true);

void main() {
  late AppDatabase db;
  late Apiary yayla;
  late Hive first;
  late Hive second;
  late Hive dead;
  late Hive locked;
  late Hive elsewhere;
  late Treatment treatment;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    final hives = HiveRepository(db);
    final apiaries = ApiaryRepository(db);
    yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
    final ova = await apiaries.create(orgId: _orgId, name: 'Ova');
    Future<Hive> create(
      String number, {
      String? apiaryId,
      HiveStatus status = HiveStatus.active,
    }) => hives.create(
      orgId: _orgId,
      number: number,
      type: HiveType.langstroth,
      apiaryId: apiaryId ?? yayla.id,
      status: status,
    );
    first = await create('101');
    second = await create('102');
    dead = await create('103', status: HiveStatus.dead);
    locked = await create('104');
    elsewhere = await create('201', apiaryId: ova.id);
    // Bugün başlayan şerit: kilit çıkarma gününe kadar; dün kilit yok.
    final now = DateTime.now();
    treatment = await TreatmentRepository(db).addToHive(
      locked,
      TreatmentPlan(
        drug: const DrugChoice(
          refDrugId: 'tr-strip',
          name: 'Amitraz şerit',
          activeIngredient: DrugActiveIngredient.amitraz,
          doseUnit: DrugDoseUnit.strip,
        ),
        dose: 2,
        startedAt: now,
        plannedRemovalAt: now.add(const Duration(days: 42)),
        withdrawalDays: 0,
      ),
    );
  });

  Future<List<Harvest>> liveHarvests() async => [
    for (final row in await db.select(db.harvests).get())
      if (row.deletedAt == null) row,
  ];

  Future<List<HarvestHive>> liveHarvestHives() async => [
    for (final row in await db.select(db.harvestHives).get())
      if (row.deletedAt == null) row,
  ];

  testWidgets('arılıktan açılır; kilitli kovan alınmaz ve kırmızı kartta '
      'yazar; bal türü ve ağırlık girilene kadar Kaydet kapalı; kayıt '
      'yazılır, Geri al siler', (tester) async {
    await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

    await _tap(tester, _button('Harvest'));
    expect(find.byType(HarvestFormScreen), findsOneWidget);
    expect(find.text('Harvest · Yayla'), findsOneWidget);
    expect(find.text('2 hives selected'), findsOneWidget);
    expect(
      find.text('101, 102 · tap to change or scan to add'),
      findsOneWidget,
    );
    expect(_rich('104 in withdrawal period.'), findsOneWidget);
    expect(_rich('Not harvested.'), findsOneWidget);
    expect(_enabled(tester, 'Save harvest'), isFalse);

    await _tap(tester, find.text('Pine'));
    expect(_enabled(tester, 'Save harvest'), isFalse);
    await _tap(tester, find.text('Supers taken'));
    final increase = find.descendant(
      of: find.widgetWithText(BigStepper, 'Supers taken'),
      matching: find.byTooltip('Increase'),
    );
    await tester.tap(increase);
    await tester.pump();
    await tester.tap(increase);
    await tester.pumpAndSettle();
    expect(find.text('Extracted honey (kg)'), findsOneWidget);
    await _weight(tester, '51');
    expect(find.text('Per hive'), findsOneWidget);
    expect(find.text('25.5 kg'), findsOneWidget);
    expect(_enabled(tester, 'Save harvest'), isTrue);

    await _tap(tester, _button('Save harvest'));
    expect(find.text('Harvest saved for 2 hives'), findsOneWidget);
    expect(find.byType(HarvestFormScreen), findsNothing);
    final harvest = (await liveHarvests()).single;
    expect(harvest.apiaryId, yayla.id);
    expect(harvest.honeyKind, HoneyKind.pine);
    expect(harvest.unit, HarvestUnit.superBox);
    expect(harvest.unitCount, 3);
    expect(harvest.netKg, 51);
    final harvested = await liveHarvestHives();
    expect({for (final h in harvested) h.hiveId}, {first.id, second.id});
    expect([for (final h in harvested) h.withdrawalOverride], [null, null]);

    await _tap(tester, find.text('Undo'));
    expect(await liveHarvests(), isEmpty);
    expect(await liveHarvestHives(), isEmpty);
  });

  testWidgets('kovan listesinde seçim değişir; kilitli kovan kilit '
      'diyaloğunda gerekçeyle alınır ve gerekçe kayda yazılır', (tester) async {
    await _open(tester, db: db, location: AppRoutes.apiaryHarvest(yayla.id));

    await _tap(tester, find.text('2 hives selected'));
    expect(find.byType(HarvestHivesScreen), findsOneWidget);
    // Sönmüş kovan listede yok.
    expect(find.text('Hive 103'), findsNothing);
    expect(find.text('Withdrawal · 42 days left'), findsOneWidget);

    await _tap(tester, find.text('Hive 101'));
    await _tap(tester, find.text('Hive 104'));
    expect(_rich('In withdrawal period.'), findsOneWidget);
    expect(_rich("It shouldn't be harvested before"), findsOneWidget);
    expect(_enabled(tester, 'Harvest anyway'), isFalse);

    // Vazgeçilirse seçilmez.
    await _tap(tester, _button("Cancel, don't harvest"));
    expect(find.text('Withdrawal · 42 days left'), findsOneWidget);

    await _tap(tester, find.text('Hive 104'));
    await _tap(tester, find.text("Honey won't be sold (own use/feed)"));
    await _tap(tester, _button('Harvest anyway'));
    expect(
      find.text("Taken anyway: Honey won't be sold (own use/feed)"),
      findsOneWidget,
    );

    await _tap(tester, _button('Done'));
    expect(find.byType(HarvestFormScreen), findsOneWidget);
    expect(find.text('2 hives selected'), findsOneWidget);
    expect(
      find.text('102, 104 · tap to change or scan to add'),
      findsOneWidget,
    );
    expect(_rich('in withdrawal period.'), findsNothing);

    await _tap(tester, find.text('Chestnut'));
    await _tap(tester, find.text('Frames'));
    expect(find.text('Frames taken'), findsOneWidget);
    await _weight(tester, '20,5');
    await _tap(tester, _button('Save harvest'));

    final harvest = (await liveHarvests()).single;
    expect(harvest.honeyKind, HoneyKind.chestnut);
    expect(harvest.unit, HarvestUnit.frame);
    expect(harvest.netKg, 20.5);
    final byHive = {for (final h in await liveHarvestHives()) h.hiveId: h};
    expect(byHive.keys, unorderedEquals([second.id, locked.id]));
    expect(byHive[second.id]!.withdrawalOverride, isNull);
    expect(
      byHive[locked.id]!.withdrawalOverride,
      WithdrawalOverride(
        treatmentId: treatment.id,
        reason: WithdrawalOverrideReason.notForSale,
      ),
    );
  });

  testWidgets('Okut seçime kovan ekler ve sonucu söyler; kilitli kovanda '
      'kilit diyaloğu açılır; aynı kod art arda işlenmez', (tester) async {
    final scanner = FakeCodeScanner();
    await _open(
      tester,
      db: db,
      location: AppRoutes.apiaryHarvest(yayla.id),
      scanner: scanner,
    );
    await _tap(tester, find.text('2 hives selected'));
    await _tap(tester, find.text('Hive 102'));
    await _tap(tester, _button('Done'));
    expect(find.text('1 hive selected'), findsOneWidget);

    await _tap(tester, _button('Scan'));
    expect(find.byType(HarvestScanScreen), findsOneWidget);
    expect(_button('Done · 1 hive'), findsOneWidget);

    Future<void> scan(String code) async {
      scanner.scan(code);
      await tester.pumpAndSettle();
    }

    await scan(hiveLabelCode(second.id));
    expect(find.text('Hive 102 added'), findsOneWidget);
    expect(_button('Done · 2 hives'), findsOneWidget);
    await scan(hiveLabelCode(first.id));
    expect(find.text('Hive 101 is already selected'), findsOneWidget);
    await scan(hiveLabelCode(dead.id));
    expect(find.text("Hive 103 isn't active"), findsOneWidget);
    await scan(hiveLabelCode(elsewhere.id));
    expect(find.text("Hive 201 isn't in this apiary"), findsOneWidget);
    await scan('YABANCI-123');
    expect(find.text("This label isn't linked to a hive"), findsOneWidget);

    await scan(hiveLabelCode(locked.id));
    expect(_rich('In withdrawal period.'), findsOneWidget);
    await _tap(tester, _button("Cancel, don't harvest"));
    // Kamera aynı kodu vermeye devam eder; diyalog yeniden açılmaz.
    await scan(hiveLabelCode(locked.id));
    expect(_rich('In withdrawal period.'), findsNothing);

    await scan(hiveLabelCode(first.id));
    await scan(hiveLabelCode(locked.id));
    await _tap(tester, find.text('Drug removed early'));
    await _tap(tester, _button('Harvest anyway'));
    expect(find.text('Hive 104 added'), findsOneWidget);

    await _tap(tester, _button('Done · 3 hives'));
    expect(find.byType(HarvestFormScreen), findsOneWidget);
    expect(find.text('3 hives selected'), findsOneWidget);
  });

  testWidgets('dünün hasadında bugün başlayan ilaç kilitlemez; hasat dünün '
      'tarihiyle yazılır', (tester) async {
    await _open(tester, db: db, location: AppRoutes.apiaryHarvest(yayla.id));
    expect(_rich('104 in withdrawal period.'), findsOneWidget);

    await _tap(tester, find.text('Yesterday'));
    expect(_rich('in withdrawal period.'), findsNothing);

    await _tap(tester, find.text('2 hives selected'));
    await _tap(tester, find.text('Hive 104'));
    // Kilit yok; diyalog açılmadan seçilir.
    expect(_rich('In withdrawal period.'), findsNothing);
    await _tap(tester, _button('Done'));
    expect(find.text('3 hives selected'), findsOneWidget);

    await _tap(tester, find.text('Flower'));
    await _weight(tester, '30');
    await _tap(tester, _button('Save harvest'));

    final harvest = (await liveHarvests()).single;
    final today = DateTime.now();
    expect(
      harvest.harvestedAt.toLocal(),
      DateTime(today.year, today.month, today.day - 1, 12),
    );
    expect(await liveHarvestHives(), hasLength(3));
    expect([
      for (final h in await liveHarvestHives()) h.withdrawalOverride,
    ], everyElement(isNull));
  });

  testWidgets('geçersiz ağırlıkta uyarı ve Kaydet kapalı', (tester) async {
    await _open(tester, db: db, location: AppRoutes.apiaryHarvest(yayla.id));
    await _tap(tester, find.text('Citrus'));

    await _weight(tester, '1.234,5');
    expect(find.text('Enter a weight like 574 or 574.5'), findsOneWidget);
    expect(_enabled(tester, 'Save harvest'), isFalse);

    await _weight(tester, '');
    expect(find.text('Enter a weight like 574 or 574.5'), findsNothing);
    expect(_enabled(tester, 'Save harvest'), isFalse);
  });

  testWidgets('pound kullanan bölgede ağırlık pound girilir, kilogram '
      'yazılır', (tester) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.apiaryHarvest(yayla.id),
      region: resolveRegionConfig('US'),
    );
    await _tap(tester, find.text('Other'));
    expect(find.text('Extracted honey (lb)'), findsOneWidget);
    await _weight(tester, '100');
    expect(find.text('50 lb'), findsOneWidget);

    await _tap(tester, _button('Save harvest'));
    expect((await liveHarvests()).single.netKg, 45.359);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.apiary(yayla.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _tap(tester, _button('Hasat'));
    expect(find.text('Hasat · Yayla'), findsOneWidget);
    expect(find.text('2 kovan seçildi'), findsOneWidget);
    expect(
      find.text('101, 102 · değiştirmek için dokun, okutarak ekle'),
      findsOneWidget,
    );
    expect(_button('Okut'), findsOneWidget);
    expect(_rich('104 bekleme süresinde.'), findsOneWidget);
    expect(_rich('Hasada alınmadı.'), findsOneWidget);
    for (final text in [
      'Tarih',
      'Bugün',
      'Dün',
      'Başka gün',
      'Bal türü',
      'Çam',
      'Çiçek',
      'Kestane',
      'Narenciye',
      'Diğer',
      'Alınan birim',
      'Kat',
      'Çerçeve',
      'Alınan kat',
      'Süzülen bal (kg)',
    ]) {
      expect(
        find.descendant(
          of: find.byType(HarvestFormScreen),
          matching: find.text(text),
        ),
        findsOneWidget,
        reason: text,
      );
    }

    await _tap(tester, find.text('Çam'));
    await _weight(tester, '574,5');
    expect(find.text('Kovan başına'), findsOneWidget);
    expect(find.text('287,3 kg'), findsOneWidget);
    await _tap(tester, _button('Hasadı kaydet'));
    expect(find.text('2 kovanın hasadı kaydedildi'), findsOneWidget);
    expect(find.text('Geri al'), findsOneWidget);

    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    await _tap(tester, _button('Hasat'));
    await _tap(tester, find.text('2 kovan seçildi'));
    expect(find.text('Hasat kovanları'), findsOneWidget);
    expect(find.text('Bekleme süresinde · 42 gün'), findsOneWidget);
    await _tap(tester, find.text('Kovan 104'));
    expect(_rich('Bekleme süresinde.'), findsOneWidget);
    expect(_rich('bu kovandan hasat yapılmamalı'), findsOneWidget);
    expect(find.text('Bal satılmayacak (kendi kullanım/yem)'), findsOneWidget);
    expect(_button('Vazgeç, hasada alma'), findsOneWidget);
    expect(_button('Yine de hasada al'), findsOneWidget);
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
      location: AppRoutes.apiary(yayla.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, _button('Hasat'));
    expect(tester.takeException(), isNull);
    await _tap(tester, find.text('Kestane'));
    await _weight(tester, '574,5');
    await tester.scrollUntilVisible(
      find.text('Kovan başına'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(HarvestFormScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('2 kovan seçildi'),
      -200,
      scrollable: find
          .descendant(
            of: find.byType(HarvestFormScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await _tap(tester, find.text('2 kovan seçildi'));
    await _tap(tester, find.text('Kovan 104'));
    expect(tester.takeException(), isNull);
  });
}
