import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_lot_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/lots_screen.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_print_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// Testlerde lot sayfası açık; Supabase'de `LOT_PAGE_BASE_URL` verilmezse
/// bölüm gizli.
const _lotPageBaseUrl = 'https://lot.example.com';

/// [backend] verilirse lot sayfası kökü sabitlenmez, o backend'den çözülür.
Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakePrintService? printer,
  Backend? backend,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db, printer: printer),
      if (backend == null)
        lotPageBaseUrlProvider.overrideWithValue(_lotPageBaseUrl)
      else
        backendProvider.overrideWithValue(backend),
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

/// [screen] ekranının listesi; metin alanları da kaydırılabilir olduğu için
/// ilk kaydırılabilir.
Finder _list(Type screen) => find
    .descendant(of: find.byType(screen), matching: find.byType(Scrollable))
    .first;

Future<void> _tap(WidgetTester tester, Finder finder, {Type? screen}) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: screen == null ? null : _list(screen),
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _enter(WidgetTester tester, String label, String text) async {
  final field = find.descendant(
    of: find.widgetWithText(LabeledField, label),
    matching: find.byType(TextField),
  );
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await tester.pumpAndSettle();
}

/// Lot ekranının başına kaydırır (kart üstte).
Future<void> _top(WidgetTester tester) async {
  await tester.drag(_list(LotScreen), const Offset(0, 2000));
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
  late HarvestRepository harvests;
  late LotRepository lots;
  final year = DateTime.now().year;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    harvests = HarvestRepository(db);
    lots = LotRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    final hives = HiveRepository(db);
    Future<Hive> create(String number) => hives.create(
      orgId: _orgId,
      number: number,
      type: HiveType.langstroth,
      apiaryId: yayla.id,
    );
    first = await create('101');
    second = await create('104');
  });

  /// Bugünkü hasat; [override] verilirse 104 bekleme süresindeyken
  /// gerekçeyle alınır.
  Future<Harvest> harvest({double netKg = 574, bool override = false}) async {
    Treatment? treatment;
    if (override) {
      final now = DateTime.now();
      treatment = await TreatmentRepository(db).addToHive(
        second,
        TreatmentPlan(
          drug: const DrugChoice(
            refDrugId: 'tr-strip',
            name: 'Amitraz şerit',
            activeIngredient: DrugActiveIngredient.amitraz,
            doseUnit: DrugDoseUnit.strip,
          ),
          dose: 2,
          startedAt: now.subtract(const Duration(days: 1)),
          plannedRemovalAt: now.add(const Duration(days: 40)),
          withdrawalDays: 0,
        ),
      );
    }
    return (await harvests.add(
      orgId: _orgId,
      plan: (
        apiaryId: yayla.id,
        harvestedAt: DateTime.now(),
        honeyKind: HoneyKind.pine,
        unit: HarvestUnit.superBox,
        unitCount: 24,
        netKg: netKg,
      ),
      hiveIds: [first.id, second.id],
      overrides: {
        if (treatment != null)
          second.id: WithdrawalOverride(
            treatmentId: treatment.id,
            reason: WithdrawalOverrideReason.notForSale,
          ),
      },
    )).harvest;
  }

  Future<List<Lot>> liveLots() async => [
    for (final row in await db.select(db.lots).get())
      if (row.deletedAt == null) row,
  ];

  testWidgets('hasattan sonra yeni lot: yöre arılığın adıyla gelir, nem '
      'yazılır, numara yılın sırası; lot listede tasarımdaki gibi', (
    tester,
  ) async {
    final h = await harvest();
    await _open(
      tester,
      db: db,
      location: AppRoutes.apiaryHarvestLot(yayla.id, h.id),
    );

    expect(find.byType(HarvestLotScreen), findsOneWidget);
    expect(find.text('Harvest saved: 574 kg Pine'), findsOneWidget);
    expect(find.text('New lot'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.widgetWithText(LabeledField, 'Origin'),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text,
      'Yayla',
    );
    await _enter(tester, 'Moisture %', '35');
    expect(
      find.text('Enter a value between 10 and 30, like 17.2'),
      findsOneWidget,
    );
    expect(_enabled(tester, 'Create lot'), isFalse);
    await _enter(tester, 'Moisture %', '17,2');
    await _tap(tester, _button('Create lot'));

    expect(find.text('Lot $year-01 created'), findsOneWidget);
    expect(find.byType(HarvestLotScreen), findsNothing);
    final lot = (await liveLots()).single;
    expect(
      (lot.year, lot.seq, lot.origin, lot.moisture),
      (year, 1, 'Yayla', 17.2),
    );
    expect((await lots.findByHarvest(h.id))?.id, lot.id);

    tester.container().read(routerProvider).go(AppRoutes.lots);
    await tester.pumpAndSettle();
    expect(find.byType(LotsScreen), findsOneWidget);
    expect(find.text('Harvest & lots'), findsOneWidget);
    expect(find.text('$year'), findsOneWidget);
    expect(find.text('IN STOCK'), findsOneWidget);
    expect(find.text('PER HIVE'), findsOneWidget);
    expect(find.text('287 kg'), findsOneWidget);
    expect(find.text('Pine honey'), findsOneWidget);
    expect(find.text('Lot $year-01 · Yayla'), findsOneWidget);
    expect(find.text('Moisture 17.2%'), findsOneWidget);
    expect(find.text('Analysis pending'), findsOneWidget);
    expect(find.text('Stock 574 kg'), findsOneWidget);
  });

  testWidgets('hasat açık bir lota eklenir; kapalı lot listede yok; '
      'Şimdilik geç lotsuz bırakır', (tester) async {
    final open = await lots.createWithHarvest(await harvest(), origin: 'Ova');
    final closed = await lots.createWithHarvest(await harvest());
    await lots.update(closed.copyWith(status: LotStatus.closed));
    final h = await harvest(netKg: 26);
    await _open(
      tester,
      db: db,
      location: AppRoutes.apiaryHarvestLot(yayla.id, h.id),
    );

    expect(find.text('Lot $year-01 · Ova'), findsOneWidget);
    expect(find.textContaining('$year-02'), findsNothing);
    await _tap(tester, find.text('Lot $year-01 · Ova'));
    expect(find.text('Origin'), findsNothing);
    await _tap(tester, _button('Add to lot'));
    expect(find.text('Harvest added to Lot $year-01'), findsOneWidget);
    expect((await lots.findByHarvest(h.id))?.id, open.id);

    final skipped = await harvest();
    tester
        .container()
        .read(routerProvider)
        .go(AppRoutes.apiaryHarvestLot(yayla.id, skipped.id));
    await tester.pumpAndSettle();
    await _tap(tester, _button('Skip for now'), screen: HarvestLotScreen);
    expect(find.byType(HarvestLotScreen), findsNothing);
    expect(await lots.findByHarvest(skipped.id), isNull);
  });

  testWidgets('bekleme süresinde alınan kovan lotu kırmızı uyarılı yapar; '
      'son ilaçlama listelenir', (tester) async {
    final lot = await lots.createWithHarvest(await harvest(override: true));
    await _open(tester, db: db, location: AppRoutes.lots);

    expect(find.text('In withdrawal'), findsOneWidget);
    await _tap(tester, find.text('Pine honey'));
    expect(find.byType(LotScreen), findsOneWidget);
    expect(
      _rich('104 harvested during the withdrawal period.'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Hive 104 · Amitraz şerit'),
      200,
      scrollable: _list(LotScreen),
    );
    expect(find.text('Hive 104 · Amitraz şerit'), findsOneWidget);
    expect(
      (await lots.treatments.findByLot(lot.id)).single.withdrawalViolation,
      isTrue,
    );
  });

  testWidgets('satış düşülür, stok azalır; stoktan fazlası yazılamaz; Geri '
      'al siler', (tester) async {
    final lot = await lots.createWithHarvest(await harvest());
    await _open(tester, db: db, location: AppRoutes.lot(lot.id));
    Finder inStock(String value) => find.descendant(
      of: find.widgetWithText(ListRow, 'In stock'),
      matching: find.text(value),
    );

    await _tap(tester, _button('Record a sale'), screen: LotScreen);
    await _enter(tester, 'Honey sold (kg)', '600');
    expect(find.text('Only 574 kg in stock'), findsOneWidget);
    expect(_enabled(tester, 'Subtract from stock'), isFalse);
    await _enter(tester, 'Honey sold (kg)', '164');
    await _tap(tester, _button('Subtract from stock'));

    expect(find.text('164 kg sale recorded'), findsOneWidget);
    // "Satış düş" ekranın üstüne kaydırılmıştı; stok satırları yukarıda.
    await tester.scrollUntilVisible(
      find.text('In stock'),
      -200,
      scrollable: _list(LotScreen),
    );
    expect(inStock('410 kg'), findsOneWidget);
    expect((await lots.sales.findByLot(lot.id)).single.kg, 164);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(await lots.sales.findByLot(lot.id), isEmpty);
    expect(inStock('574 kg'), findsOneWidget);
  });

  testWidgets('analiz eklenir: değerler, kalıntı ve belge kasasındaki rapor; '
      'lot "Analiz ✓" olur', (tester) async {
    final lot = await lots.createWithHarvest(await harvest());
    final now = DateTime.now().toUtc();
    await db
        .into(db.documents)
        .insert(
          VaultDocument(
            id: 'doc-1',
            orgId: _orgId,
            type: DocumentType.analysisReport,
            name: 'Lab raporu 07',
            fileKind: DocumentFileKind.pdf,
            storagePath: '$_orgId/doc-1/file-1.pdf',
            byteSize: 1000,
            createdAt: now,
            updatedAt: now,
          ).toInsertable(),
        );
    await _open(tester, db: db, location: AppRoutes.lot(lot.id));

    await _tap(tester, _button('Add analysis'), screen: LotScreen);
    expect(find.text('Analysis · Lot $year-01'), findsOneWidget);
    expect(_enabled(tester, 'Save analysis'), isFalse);
    await _enter(tester, 'HMF (mg/kg)', '2000');
    expect(find.text('Enter a value between 0 and 1,000'), findsOneWidget);
    await _enter(tester, 'HMF (mg/kg)', '12,4');
    await _enter(tester, 'Proline (mg/kg)', '420');
    await _tap(tester, find.text('No residue'));
    await _tap(tester, find.text('Report'));
    await _tap(tester, find.text('Lab raporu 07'));
    expect(find.text('Lab raporu 07'), findsOneWidget);
    await _tap(tester, _button('Save analysis'));

    expect(find.text('Analysis saved'), findsOneWidget);
    expect(find.byType(LotScreen), findsOneWidget);
    await _top(tester);
    expect(find.text('Analysed ✓'), findsOneWidget);
    final result = (await lots.labResults.findByLot(lot.id)).single;
    expect(
      (result.hmf, result.proline, result.residue, result.documentId),
      (12.4, 420.0, ResidueResult.none, 'doc-1'),
    );
  });

  testWidgets('düzenleme: yöre, nem ve durum yazılır; silme onaylı', (
    tester,
  ) async {
    final lot = await lots.createWithHarvest(await harvest());
    await _open(tester, db: db, location: AppRoutes.lot(lot.id));

    await _tap(tester, find.byTooltip('Edit lot'));
    expect(find.text('Edit Lot $year-01'), findsOneWidget);
    await _enter(tester, 'Origin', 'Kızılçam');
    await _tap(tester, find.text('Closed'));
    await _tap(tester, _button('Save'));
    final saved = (await lots.findById(lot.id))!;
    expect((saved.origin, saved.status), ('Kızılçam', LotStatus.closed));

    await _tap(tester, find.byTooltip('Edit lot'));
    await _tap(tester, _button('Delete lot'));
    expect(find.text('Delete Lot $year-01?'), findsOneWidget);
    await _tap(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Delete lot'),
      ),
    );
    expect(find.byType(LotsScreen), findsOneWidget);
    expect(await liveLots(), isEmpty);
  });

  testWidgets('viewer lotu görür, düzenleyemez, satış ve analiz '
      'yazamaz', (tester) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.viewer);
    final lot = await lots.createWithHarvest(await harvest());
    await _open(tester, db: db, location: AppRoutes.lot(lot.id));

    expect(find.byType(LotScreen), findsOneWidget);
    expect(find.byTooltip('Edit lot'), findsNothing);
    expect(_button('Record a sale'), findsNothing);
    expect(_button('Add analysis'), findsNothing);
  });

  /// "Publish" anahtarı ve alan anahtarları.
  Finder toggle(String title) => find.widgetWithText(SwitchListTile, title);

  Future<void> showToggle(WidgetTester tester, String title) async {
    await tester.scrollUntilVisible(
      toggle(title),
      200,
      scrollable: _list(LotScreen),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('owner yayımlar: alanlar seçilir, kavanoz etiketi PDF olarak '
      'yazdırılır ve paylaşılır; yayımdan kaldırınca etiket kalkar', (
    tester,
  ) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    final lot = await lots.createWithHarvest(await harvest());
    final printer = FakePrintService();
    await _open(
      tester,
      db: db,
      location: AppRoutes.lot(lot.id),
      printer: printer,
    );

    await showToggle(tester, 'Publish');
    expect(
      find.text(
        "Anyone who scans the QR sees the lot's page. Phone, address and "
        'location are never shown.',
      ),
      findsOneWidget,
    );
    expect(toggle('Analysis report'), findsNothing);
    expect(_button('Print'), findsNothing);

    await _tap(tester, toggle('Publish'));
    expect((await lots.findById(lot.id))!.published, isTrue);

    await showToggle(tester, 'Analysis report');
    for (final title in [
      'Business name and hive count',
      'Origin and harvest month',
      'Analysis values',
    ]) {
      expect(
        tester.widget<SwitchListTile>(toggle(title)).value,
        isTrue,
        reason: title,
      );
    }
    await _tap(tester, toggle('Analysis report'));
    final saved = (await lots.findById(lot.id))!;
    expect((saved.published, saved.publicReport), (true, false));

    await _tap(tester, _button('Print'), screen: LotScreen);
    final printed = printer.printed.single;
    expect(printed.name, 'Jar labels - Lot $year-01');
    expect(ascii.decode(printed.bytes.sublist(0, 5)), '%PDF-');
    await _tap(tester, _button('Share PDF'), screen: LotScreen);
    expect(printer.shared.single.filename, 'Jar labels - Lot $year-01.pdf');

    await showToggle(tester, 'Publish');
    await _tap(tester, toggle('Publish'));
    expect((await lots.findById(lot.id))!.published, isFalse);
    expect(_button('Print'), findsNothing);
    expect(toggle('Analysis report'), findsNothing);
  });

  testWidgets("PocketBase'de sayfa adresi sunucudan gelir, bölüm görünür", (
    tester,
  ) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    final lot = await lots.createWithHarvest(await harvest());
    await lots.setPublication(lot.id, published: true);
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.lot(lot.id),
      backend: Backend.pocketbase,
    );

    expect(
      container.read(lotPageBaseUrlProvider),
      '${container.read(pocketbaseUrlProvider)}/l',
    );
    await showToggle(tester, 'Publish');
    expect(tester.widget<SwitchListTile>(toggle('Publish')).value, isTrue);
    await tester.scrollUntilVisible(
      _button('Print'),
      200,
      scrollable: _list(LotScreen),
    );
    expect(_button('Print'), findsOneWidget);
  });

  testWidgets("Supabase'de sayfa adresi yapılandırılmadıysa (derlemede "
      'LOT_PAGE_BASE_URL yok) bölüm gizli', (tester) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    final lot = await lots.createWithHarvest(await harvest());
    await lots.setPublication(lot.id, published: true);
    await _open(
      tester,
      db: db,
      location: AppRoutes.lot(lot.id),
      backend: Backend.supabase,
    );

    await tester.scrollUntilVisible(
      find.text('No sales recorded yet'),
      200,
      scrollable: _list(LotScreen),
    );
    expect(find.text('PUBLIC PAGE'), findsNothing);
    expect(find.text('Public page'), findsNothing);
    expect(toggle('Publish'), findsNothing);
    expect(_button('Print'), findsNothing);
  });

  testWidgets('owner olmayan yayımı görür ama değiştiremez; etiketi basar', (
    tester,
  ) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.worker);
    final lot = await lots.createWithHarvest(await harvest());
    await lots.setPublication(lot.id, published: true);
    await _open(tester, db: db, location: AppRoutes.lot(lot.id));

    await showToggle(tester, 'Publish');
    expect(
      find.text('Published · Only the business owner can publish.'),
      findsOneWidget,
    );
    expect(tester.widget<SwitchListTile>(toggle('Publish')).onChanged, isNull);
    await showToggle(tester, 'Analysis report');
    expect(
      tester.widget<SwitchListTile>(toggle('Analysis report')).onChanged,
      isNull,
    );
    await tester.scrollUntilVisible(
      _button('Print'),
      200,
      scrollable: _list(LotScreen),
    );
    expect(_enabled(tester, 'Print'), isTrue);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final lot = await lots.createWithHarvest(
      await harvest(override: true),
      origin: 'Kızılçam',
      moisture: 17.2,
    );
    final container = await _open(tester, db: db, location: AppRoutes.lots);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    for (final text in [
      'Hasat ve lotlar',
      'STOKTA',
      'KOVAN BAŞI',
      'Çam balı',
      'Lot $year-01 · Kızılçam',
      'Nem %17,2',
      'Analiz bekliyor',
      'Stok 574 kg',
      'Bekleme süresinde',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }

    container.read(routerProvider).go(AppRoutes.lot(lot.id));
    await tester.pumpAndSettle();
    expect(_rich('104 bekleme süresinde hasat edildi.'), findsOneWidget);
    expect(_button('Satış düş'), findsOneWidget);

    await lots.setPublication(lot.id, published: true);
    await showToggle(tester, 'Analiz raporu');
    for (final text in [
      'Yayımla',
      'Yayımda · Yalnız işletme sahibi yayımlayabilir.',
      'İşletme adı ve kovan sayısı',
      'Yöre ve hasat ayı',
      'Analiz değerleri',
      'Analiz raporu',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    await tester.scrollUntilVisible(
      _button('Yazdır'),
      200,
      scrollable: _list(LotScreen),
    );
    expect(
      find.text(
        'A4 sayfaya 24 etiket (70 × 37 mm); yazdırırken ölçeği %100 seç.',
      ),
      findsOneWidget,
    );
    expect(_button('PDF paylaş'), findsOneWidget);

    final h = await harvest(override: true);
    container
        .read(routerProvider)
        .go(AppRoutes.apiaryHarvestLot(yayla.id, h.id));
    await tester.pumpAndSettle();
    expect(find.text('Lota ekle'), findsWidgets);
    expect(find.text('Yeni lot'), findsOneWidget);
    expect(find.text('Yöre'), findsOneWidget);
    expect(_button('Lot oluştur'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final lot = await lots.createWithHarvest(
      await harvest(override: true),
      origin: 'Kızılçam',
      moisture: 17.2,
    );
    await lots.labResults.add(lot, (
      testedOn: DateTime.now(),
      hmf: 12.4,
      diastase: 18.2,
      proline: 420,
      moisture: 17.1,
      residue: ResidueResult.none,
      documentId: null,
    ));
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    await lots.setPublication(lot.id, published: true);
    final container = await _open(tester, db: db, location: AppRoutes.lots);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    container.read(routerProvider).go(AppRoutes.lot(lot.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Henüz satış düşülmedi'),
      200,
      scrollable: _list(LotScreen),
    );
    expect(tester.takeException(), isNull);

    container.read(routerProvider).go(AppRoutes.lotLabResult(lot.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final h = await harvest(override: true);
    container
        .read(routerProvider)
        .go(AppRoutes.apiaryHarvestLot(yayla.id, h.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
