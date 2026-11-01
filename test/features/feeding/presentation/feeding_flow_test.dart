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
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/presentation/feeding_form_screen.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inventory/data/inventory_repository.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  RegionConfig? region,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db),
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

/// Adı [label] olan sayacın [tooltip] butonuna [times] kez dokunur.
Future<void> _step(
  WidgetTester tester,
  String label,
  String tooltip, {
  int times = 1,
}) async {
  final button = find.descendant(
    of: find.widgetWithText(BigStepper, label),
    matching: find.byTooltip(tooltip),
  );
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  for (var i = 0; i < times; i++) {
    await tester.tap(button);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

Finder _button(String label) => find.widgetWithText(BigButton, label);

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<BigButton>(_button(label)).onPressed != null;

Finder _rich(String text) => find.textContaining(text, findRichText: true);

void main() {
  late AppDatabase db;
  late Apiary yayla;
  late Hive withSuper;
  late Hive plain;
  late Hive third;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    final hives = HiveRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    Future<Hive> create(String number, {HiveStatus? status}) => hives.create(
      orgId: _orgId,
      number: number,
      type: HiveType.langstroth,
      apiaryId: yayla.id,
      status: status ?? HiveStatus.active,
    );
    withSuper = await create('101');
    plain = await create('102');
    await create('103', status: HiveStatus.dead);
    third = await create('104');
    await InspectionRepository(db).add(
      orgId: _orgId,
      hiveId: withSuper.id,
      apiaryId: yayla.id,
      values: const InspectionValues(actions: {InspectionAction.superAdded}),
    );
  });

  Future<List<Feeding>> liveFeedings() async => [
    for (final row in await db.select(db.feedings).get())
      if (row.deletedAt == null) row,
  ];

  testWidgets('karttan açılır; tür seçilene kadar Kaydet kapalı; şurupta '
      'şeker ve su hesaplanır; kayıt yazılır, Geri al siler', (tester) async {
    await _open(tester, db: db, location: AppRoutes.hive(yayla.id, plain.id));

    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Feed'));
    expect(find.byType(FeedingFormScreen), findsOneWidget);
    expect(find.text('Hive 102'), findsOneWidget);
    expect(find.text('Whole apiary · 3'), findsOneWidget);
    expect(_enabled(tester, 'Save'), isFalse);
    expect(find.byType(BigStepper), findsNothing);

    await _tap(tester, find.text('Syrup 2:1 · winter'));
    await _step(tester, 'Per hive (L)', 'Increase', times: 2);
    // Bal katı yok; uyarı çıkmaz.
    expect(_rich('honey super'), findsNothing);
    expect(find.text('TO PREPARE'), findsOneWidget);
    expect(find.text('1 hive × 3 L'), findsOneWidget);
    expect(find.text('3 L syrup'), findsOneWidget);
    // 3 L × 1,33 kg/L: 2/3'ü şeker, 1/3'ü su.
    expect(find.text('≈ 2.7 kg'), findsOneWidget);
    expect(find.text('≈ 1.3 L'), findsOneWidget);

    await _tap(tester, _button('Save'));
    expect(find.text('Feeding saved for hive 102'), findsOneWidget);
    expect(find.byType(FeedingFormScreen), findsNothing);
    final feeding = (await liveFeedings()).single;
    expect(feeding.hiveId, plain.id);
    expect(feeding.kind, FeedingKind.syrup2to1);
    expect(feeding.amount, 3);

    await _tap(tester, find.text('Undo'));
    expect(await liveFeedings(), isEmpty);
  });

  testWidgets('stoktan düşülecek kalem seçilir; kayıt çıkış yazar, Geri al '
      'siler; sonraki beslemede son kullanılan kalem gelir', (tester) async {
    final inventory = InventoryRepository(db);
    Future<InventoryItem> item(String name, InventoryUnit unit) =>
        inventory.create(
          orgId: _orgId,
          name: name,
          category: InventoryCategory.consumable,
          unit: unit,
        );
    final sugar = await item('Şeker', InventoryUnit.kg);
    await inventory.moves.add(sugar, InventoryMoveKind.stockIn, 50);
    await item('Hazır şurup', InventoryUnit.liter);
    await item('Kek', InventoryUnit.kg);
    Future<List<InventoryMove>> liveMoves() async => [
      for (final row in await db.select(db.inventoryMoves).get())
        if (row.deletedAt == null && row.quantity < 0) row,
    ];
    Future<void> openForm() async {
      await _tap(tester, find.byIcon(Icons.more_vert_rounded));
      await _tap(tester, find.text('Feed'));
      await _tap(tester, find.text('Syrup 2:1 · winter'));
    }

    await _open(tester, db: db, location: AppRoutes.hive(yayla.id, plain.id));
    await openForm();
    await _step(tester, 'Per hive (L)', 'Increase', times: 2);
    expect(find.text('Deduct from stock'), findsOneWidget);
    expect(find.text("Don't deduct"), findsOneWidget);

    await _tap(tester, find.text('Deduct from stock'));
    expect(find.text('Deduct from which item?'), findsOneWidget);
    expect(find.text('In stock: 50 kg'), findsOneWidget);
    expect(find.text('Hazır şurup'), findsOneWidget);
    await _tap(tester, find.text('Şeker'));
    // 3 L × 1,33 kg/L × 2/3 şeker.
    expect(find.text('Şeker · −2.66 kg'), findsOneWidget);

    await _tap(tester, _button('Save'));
    final move = (await liveMoves()).single;
    expect(move.itemId, sugar.id);
    expect(move.quantity, -2.66);
    expect(move.linkedId, (await liveFeedings()).single.id);

    await _tap(tester, find.text('Undo'));
    expect(await liveFeedings(), isEmpty);
    expect(await liveMoves(), isEmpty);

    await openForm();
    // Geri alınan düşüm son kullanılan sayılmaz.
    expect(find.text("Don't deduct"), findsOneWidget);
    await _tap(tester, find.text('Deduct from stock'));
    await _tap(tester, find.text('Şeker'));
    await _tap(tester, _button('Save'));
    expect(await liveMoves(), hasLength(1));
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();

    await openForm();
    expect(find.text('Şeker · −0.887 kg'), findsOneWidget);
    await _tap(tester, find.text('Bee cake'));
    // Kekte son kullanılan yok.
    expect(find.text("Don't deduct"), findsOneWidget);
  });

  testWidgets('toplu besleme şeker stoğunu düşürür; Geri al stoğu geri '
      'getirir', (tester) async {
    final inventory = InventoryRepository(db);
    final sugar = await inventory.create(
      orgId: _orgId,
      name: 'Şeker',
      category: InventoryCategory.consumable,
      unit: InventoryUnit.kg,
    );
    await inventory.moves.add(sugar, InventoryMoveKind.stockIn, 50);

    await _open(tester, db: db, location: AppRoutes.hive(yayla.id, plain.id));
    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Feed'));
    await _tap(tester, find.text('Whole apiary · 3'));
    await _tap(tester, find.text('Syrup 2:1 · winter'));
    await _step(tester, 'Per hive (L)', 'Increase', times: 2);
    await _tap(tester, find.text('Deduct from stock'));
    await _tap(tester, find.text('Şeker'));
    // Bal katlı 101 hariç 2 kovan × 3 L = 6 L; × 1,33 kg/L × 2/3 şeker.
    expect(find.text('Şeker · −5.32 kg'), findsOneWidget);

    await _tap(tester, _button('Save to 2 hives'));
    expect(find.text('Feeding saved for 2 hives'), findsOneWidget);
    expect(await liveFeedings(), hasLength(2));
    expect(await inventory.moves.stockOf(sugar.id), 44.68);

    await _tap(tester, find.text('Undo'));
    expect(await liveFeedings(), isEmpty);
    expect(await inventory.moves.stockOf(sugar.id), 50);
  });

  testWidgets('bal katı olan kovana şurupta uyarı; kayıt yine yazılır; kek '
      'seçilince uyarı kalkar, şeker hesabı yok', (tester) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.hiveFeed(yayla.id, withSuper.id),
    );

    await _tap(tester, find.text('Syrup 1:1 · stimulative'));
    expect(_rich('This hive has a honey super.'), findsOneWidget);
    expect(_rich('Syrup may get into the honey.'), findsOneWidget);
    expect(_enabled(tester, 'Save'), isTrue);

    await _tap(tester, find.text('Bee cake'));
    expect(_rich('honey super'), findsNothing);
    expect(find.text('Per hive (kg)'), findsOneWidget);
    expect(find.text('1 kg bee cake'), findsOneWidget);
    expect(find.text('Sugar'), findsNothing);

    await _tap(tester, find.text('Syrup 1:1 · stimulative'));
    await _tap(tester, _button('Save'));
    expect((await liveFeedings()).single.hiveId, withSuper.id);
  });

  testWidgets('arılığın tümünde şurup bal katlı kovanı dışarıda bırakır ve '
      'söyler; "N kovana kaydet"; kekte hepsine yazılır', (tester) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.hiveFeed(yayla.id, plain.id),
    );
    await _tap(tester, find.text('Whole apiary · 3'));
    await _tap(tester, find.text('Syrup 2:1 · winter'));

    expect(_rich('1 hive has a honey super'), findsOneWidget);
    expect(
      _rich("(101). Left out so the syrup doesn't get into the honey."),
      findsOneWidget,
    );
    expect(find.text('2 hives × 1 L'), findsOneWidget);
    expect(find.text('2 L syrup'), findsOneWidget);
    expect(find.text('≈ 1.8 kg'), findsOneWidget);
    expect(find.text('≈ 0.9 L'), findsOneWidget);

    await _tap(tester, _button('Save to 2 hives'));
    expect(find.text('Feeding saved for 2 hives'), findsOneWidget);
    final syrup = await liveFeedings();
    expect({for (final f in syrup) f.hiveId}, {plain.id, third.id});
    expect({for (final f in syrup) f.feedingGroupId}, hasLength(1));
    await _tap(tester, find.text('Undo'));
    expect(await liveFeedings(), isEmpty);
    // Bildirim kapanır.
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();

    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Feed'));
    await _tap(tester, find.text('Whole apiary · 3'));
    await _tap(tester, find.text('Pollen substitute'));
    expect(_rich('honey super'), findsNothing);
    expect(find.text('3 hives × 1 kg'), findsOneWidget);
    await _tap(tester, _button('Save to 3 hives'));
    expect(await liveFeedings(), hasLength(3));
  });

  testWidgets('arılıktaki bütün aktif kovanlar bal katlıysa şurup '
      'kaydedilemez', (tester) async {
    for (final hive in [plain, third]) {
      await InspectionRepository(db).add(
        orgId: _orgId,
        hiveId: hive.id,
        apiaryId: yayla.id,
        values: const InspectionValues(actions: {InspectionAction.superAdded}),
      );
    }
    await _open(
      tester,
      db: db,
      location: AppRoutes.hiveFeed(yayla.id, plain.id),
    );
    await _tap(tester, find.text('Whole apiary · 3'));
    await _tap(tester, find.text('Syrup 2:1 · winter'));

    expect(_rich('3 hives have a honey super'), findsOneWidget);
    expect(find.text('TO PREPARE'), findsNothing);
    expect(_enabled(tester, 'No hive to feed'), isFalse);
  });

  testWidgets('galon ve pound kullanan bölgede miktar o birimde girilir, '
      'litre ve kilogram yazılır', (tester) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.hiveFeed(yayla.id, plain.id),
      region: resolveRegionConfig('US'),
    );
    await _tap(tester, find.text('Syrup 1:1 · stimulative'));

    expect(find.text('Per hive (gal)'), findsOneWidget);
    expect(find.text('1 gal syrup'), findsOneWidget);
    // 3,785 L × 1,23 kg/L'nin yarısı: 2,33 kg ≈ 5,1 lb şeker, 2,33 L ≈ 0,6
    // gal su.
    expect(find.text('≈ 5.1 lb'), findsOneWidget);
    expect(find.text('≈ 0.6 gal'), findsOneWidget);
    await _tap(tester, _button('Save'));
    expect((await liveFeedings()).single.amount, 3.785);
    // Bildirim kapanır; alttaki butonun üstünde durmasın.
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();

    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Feed'));
    await _tap(tester, find.text('Bee cake'));
    await _step(tester, 'Per hive (lb)', 'Increase');
    await _tap(tester, _button('Save'));
    final cake = [
      for (final f in await liveFeedings())
        if (f.kind == FeedingKind.beeCake) f,
    ];
    expect(cake.single.amount, 0.907);
  });

  testWidgets('aktif olmayan kovanda Besle yok', (tester) async {
    final dead = (await db.select(db.hives).get()).firstWhere(
      (hive) => hive.number == '103',
    );
    await _open(tester, db: db, location: AppRoutes.hive(yayla.id, dead.id));

    expect(_button('Feed'), findsNothing);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, withSuper.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Besle'));
    expect(find.text('Besleme'), findsOneWidget);
    expect(find.text('Kovan 101'), findsOneWidget);
    expect(find.text('Arılığın tümü · 3'), findsOneWidget);
    expect(find.text('TÜR'), findsOneWidget);
    expect(find.text('Şurup 1:1 · teşvik'), findsOneWidget);
    expect(find.text('Arı keki'), findsOneWidget);
    expect(find.text('Polen ikamesi'), findsOneWidget);

    await _tap(tester, find.text('Şurup 2:1 · kışlık'));
    expect(find.text('Kovan başına (L)'), findsOneWidget);
    expect(_rich('Bu kovanda bal katı var.'), findsOneWidget);
    expect(_rich('Şurup bala karışabilir.'), findsOneWidget);
    expect(find.text('HAZIRLANACAK'), findsOneWidget);
    expect(find.text('1 kovan × 1 L'), findsOneWidget);
    expect(find.text('1 L şurup'), findsOneWidget);
    expect(find.text('Şeker'), findsOneWidget);
    expect(find.text('Su'), findsOneWidget);
    expect(find.text('≈ 0,9 kg'), findsOneWidget);

    await _tap(tester, find.text('Arılığın tümü · 3'));
    expect(_rich('1 kovanda bal katı var'), findsOneWidget);
    expect(
      _rich('(101). Şurup bala karışmasın diye hariç tutuldu.'),
      findsOneWidget,
    );
    await _tap(tester, _button('2 kovana kaydet'));
    expect(find.text('2 kovana besleme kaydedildi'), findsOneWidget);
    expect(find.text('Geri al'), findsOneWidget);

    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Besle'));
    await _tap(tester, find.text('Arı keki'));
    await _tap(tester, _button('Kaydet'));
    expect(find.text('Kovan 101 için besleme kaydedildi'), findsOneWidget);
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
      location: AppRoutes.hive(yayla.id, withSuper.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Besle'));
    expect(tester.takeException(), isNull);

    await _tap(tester, find.text('Arılığın tümü · 3'));
    await _tap(tester, find.text('Şurup 2:1 · kışlık'));
    await _step(tester, 'Kovan başına (L)', 'Artır', times: 19);
    await tester.scrollUntilVisible(
      find.text('Su'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(FeedingFormScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('40 L şurup'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
