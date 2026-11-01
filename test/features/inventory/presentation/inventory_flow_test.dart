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
import 'package:mobil_arici/features/inventory/data/inventory_repository.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Finder _button(String label) => find.widgetWithText(BigButton, label);

Finder _field(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is LabeledField && w.label == label),
  matching: find.byType(TextField),
);

Finder _rich(String text) => find.text(text, findRichText: true);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  // Kaydırılan listede henüz kurulmamış olabilir.
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

void main() {
  late AppDatabase db;
  late InventoryRepository repository;

  setUp(() {
    db = openTestDatabase();
    repository = InventoryRepository(db);
  });

  Future<ProviderContainer> open(
    WidgetTester tester, {
    String location = AppRoutes.inventory,
  }) async {
    final container = ProviderContainer.test(overrides: signedIn(db: db));
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    container.read(routerProvider).go(location);
    await tester.pumpAndSettle();
    return container;
  }

  /// Sarf: Temel petek 40 ad (eşik 100), Şeker 150 kg (eşik 125);
  /// Ekipman: Körük 3 ad (eşiksiz).
  Future<InventoryItem> seed() async {
    final foundation = await repository.create(
      orgId: _orgId,
      name: 'Temel petek',
      category: InventoryCategory.consumable,
      unit: InventoryUnit.piece,
      place: 'depo',
      threshold: 100,
    );
    await repository.moves.add(foundation, InventoryMoveKind.stockIn, 40);
    final sugar = await repository.create(
      orgId: _orgId,
      name: 'Şeker',
      category: InventoryCategory.consumable,
      unit: InventoryUnit.kg,
      place: 'depo',
      threshold: 125,
    );
    await repository.moves.add(sugar, InventoryMoveKind.stockIn, 150);
    final smoker = await repository.create(
      orgId: _orgId,
      name: 'Körük',
      category: InventoryCategory.equipment,
      unit: InventoryUnit.piece,
    );
    await repository.moves.add(smoker, InventoryMoveKind.stockIn, 3);
    return foundation;
  }

  testWidgets('Daha fazla → stok; boşken kalem eklenir, açık sekmenin '
      'kategorisiyle', (tester) async {
    await open(tester, location: AppRoutes.more);
    await _tap(tester, find.text('Supplies and stock'));
    expect(find.text('No stock items yet'), findsOneWidget);

    await _tap(tester, _button('Add item'));
    expect(find.text('New item'), findsOneWidget);
    expect(_button('Save'), findsOneWidget);
    expect(
      tester.widget<BigButton>(_button('Save')).onPressed,
      isNull,
      reason: 'ad ve birim yok',
    );

    await tester.enterText(_field('Name'), 'Temel petek');
    await _tap(tester, find.text('Piece'));
    await tester.enterText(_field('Location'), ' depo ');
    await tester.enterText(_field('Minimum (pcs)'), '100,5');
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid minimum'), findsOneWidget);
    await tester.enterText(_field('Minimum (pcs)'), '100');
    await tester.pumpAndSettle();
    await _tap(tester, _button('Save'));

    final item = (await db.select(db.inventoryItems).get()).single;
    expect(item.name, 'Temel petek');
    expect(item.category, InventoryCategory.consumable);
    expect(item.unit, InventoryUnit.piece);
    expect(item.place, 'depo');
    expect(item.threshold, 100);
    expect(_rich('Temel petek · depo'), findsOneWidget);
    expect(find.text('0 pcs'), findsOneWidget);
    expect(find.text('Below minimum · at least 100'), findsOneWidget);
  });

  testWidgets('kategori sekmeleri; eşiğin altındaki kalem ikon ve '
      'kelimeyle, eşiksiz kalemde çubuk yok', (tester) async {
    await seed();
    await open(tester);

    expect(_rich('Temel petek · depo'), findsOneWidget);
    expect(find.text('40 pcs'), findsOneWidget);
    expect(find.text('Below minimum · at least 100'), findsOneWidget);
    expect(find.byIcon(AppStatus.warning.icon), findsOneWidget);
    expect(_rich('Şeker · depo'), findsOneWidget);
    expect(find.text('150 kg'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNWidgets(2));
    expect(find.text('Körük'), findsNothing);

    await _tap(tester, find.text('Equipment'));
    expect(find.text('Körük'), findsOneWidget);
    expect(find.text('3 pcs'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    expect(find.text('Temel petek'), findsNothing);

    await _tap(tester, find.text('Comb'));
    expect(find.text('No items in this category'), findsOneWidget);
  });

  testWidgets('hızlı giriş, çıkış ve sayım; geri alınabilir', (tester) async {
    final item = await seed();
    await open(tester);

    await _tap(tester, _rich('Temel petek · depo'));
    expect(find.text('In stock: 40 pcs'), findsOneWidget);
    expect(tester.widget<BigButton>(_button('Add to stock')).onPressed, isNull);

    await tester.enterText(_field('Amount (pcs)'), '2,5');
    await tester.pumpAndSettle();
    expect(find.text('Use a whole number for this unit'), findsOneWidget);
    await tester.enterText(_field('Amount (pcs)'), '70');
    await tester.pumpAndSettle();
    await _tap(tester, _button('Add to stock'));
    expect(find.text('70 pcs added'), findsOneWidget);
    expect(find.text('110 pcs'), findsOneWidget);
    expect(find.text('Below minimum · at least 100'), findsNothing);
    expect(await repository.moves.stockOf(item.id), 110);

    await _tap(tester, _rich('Temel petek · depo'));
    await _tap(tester, find.text('Out'));
    await tester.enterText(_field('Amount (pcs)'), '12');
    await tester.pumpAndSettle();
    await _tap(tester, _button('Remove from stock'));
    expect(find.text('12 pcs removed'), findsOneWidget);
    expect(find.text('98 pcs'), findsOneWidget);
    expect(find.text('Below minimum · at least 100'), findsOneWidget);

    await _tap(tester, find.text('Undo'));
    expect(find.text('110 pcs'), findsOneWidget);
    expect(await repository.moves.stockOf(item.id), 110);

    await _tap(tester, _rich('Temel petek · depo'));
    await _tap(tester, find.text('Count'));
    await tester.enterText(_field('Counted amount (pcs)'), '105');
    await tester.pumpAndSettle();
    await _tap(tester, _button('Correct stock'));
    expect(find.text('Stock is now 105 pcs'), findsOneWidget);
    expect(find.text('105 pcs'), findsOneWidget);

    await _tap(tester, _rich('Temel petek · depo'));
    await _tap(tester, find.text('Count'));
    await tester.enterText(_field('Counted amount (pcs)'), '105');
    await tester.pumpAndSettle();
    await _tap(tester, _button('Correct stock'));
    expect(find.text('Stock is already 105 pcs'), findsOneWidget);
    expect(await repository.moves.stockOf(item.id), 105);
  });

  testWidgets('ayrıntı: hareket geçmişi; kalem düzenlenir ve silinir', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final item = await seed();
    await repository.moves.add(item, InventoryMoveKind.stockOut, 5);
    await open(tester);

    await _tap(tester, _rich('Temel petek · depo'));
    await _tap(tester, _button('Details and history'));
    expect(find.text('35 pcs'), findsOneWidget);
    expect(find.text('Supplies · depo'), findsOneWidget);
    expect(find.text('Minimum: at least 100 pcs'), findsOneWidget);
    expect(find.text('HISTORY'), findsOneWidget);
    expect(find.text('+40 pcs'), findsOneWidget);
    expect(find.text('-5 pcs'), findsOneWidget);

    await _tap(tester, find.byTooltip('Edit item'));
    expect(find.text('Edit item'), findsWidgets);
    await tester.enterText(_field('Minimum (pcs)'), '20');
    await tester.pumpAndSettle();
    await _tap(tester, _button('Save'));
    expect(find.text('Item saved'), findsOneWidget);
    expect(find.text('Minimum: at least 20 pcs'), findsOneWidget);
    expect((await repository.findById(item.id))!.threshold, 20);

    await _tap(tester, find.byTooltip('Edit item'));
    await _tap(tester, _button('Delete item'));
    await _tap(tester, find.widgetWithText(TextButton, 'Delete'));
    expect(find.text('Item deleted'), findsOneWidget);
    expect(find.text('Supplies and stock'), findsOneWidget);
    expect(_rich('Temel petek · depo'), findsNothing);
    expect(await repository.findById(item.id), isNull);
  });

  testWidgets('viewer kalem ekleyemez, hareket yazamaz; ayrıntıyı görür', (
    tester,
  ) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.viewer);
    await seed();
    await open(tester);

    expect(find.byTooltip('Add item'), findsNothing);
    await _tap(tester, _rich('Temel petek · depo'));
    expect(find.text('In stock: 40 pcs'), findsNothing);
    expect(find.text('+40 pcs'), findsOneWidget);
    expect(_button('Add / remove'), findsNothing);
    expect(find.byTooltip('Edit item'), findsNothing);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await seed();
    final container = await open(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Malzeme ve stok'), findsOneWidget);
    expect(find.text('Sarf'), findsOneWidget);
    expect(find.text('Ekipman'), findsOneWidget);
    expect(find.text('Petek'), findsOneWidget);
    expect(find.text('40 ad'), findsOneWidget);
    expect(find.text('Eşiğin altında · en az 100'), findsOneWidget);

    await _tap(tester, _rich('Temel petek · depo'));
    expect(find.text('Stokta 40 ad'), findsOneWidget);
    expect(find.text('Giriş'), findsOneWidget);
    expect(find.text('Çıkış'), findsOneWidget);
    expect(find.text('Sayım'), findsOneWidget);
    expect(find.text('Miktar (ad)'), findsOneWidget);
    expect(_button('Giriş yap'), findsOneWidget);
    expect(_button('Ayrıntılar ve hareketler'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final item = await seed();

    final container = await open(tester);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, _rich('Temel petek · depo'));
    expect(tester.takeException(), isNull);

    container.read(routerProvider).go(AppRoutes.inventoryItem(item.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    container.read(routerProvider).go(AppRoutes.inventoryItemEdit(item.id));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      _button('Delete item'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
