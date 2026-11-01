import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/app/shell/more_screen.dart';
import 'package:mobil_arici/app/shell/quick_record_sheet.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/finance_screen.dart';
import 'package:mobil_arici/features/finance/presentation/transaction_form_screen.dart';
import 'package:mobil_arici/features/finance/presentation/transaction_screen.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_media.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_receipts.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakeMedia? media,
  FakeReceipts? receipts,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, media: media, receipts: receipts),
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

Finder _button(String label) => find.widgetWithText(BigButton, label);

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<BigButton>(_button(label)).onPressed != null;

/// Alt gezinmedeki Okut butonu (adı yalnız ekran okuyucuda).
Finder _scanButton(String label) => find.descendant(
  of: find.byType(AppNavigationBar),
  matching: find.byWidgetPredicate(
    (widget) => widget is Icon && widget.semanticLabel == label,
  ),
);

void main() {
  late AppDatabase db;
  late Apiary yayla;
  late LotRepository lots;
  late Lot lot;
  late TransactionRepository transactions;
  final year = DateTime.now().year;
  final lotNumber = 'Lot $year-01';

  /// İngilizce arayüzde ₺ tutarı (`₺17,500`).
  String lira(num amount) =>
      const AppFormat('en')
          .currency(amount, currencyCode: 'TRY', decimalDigits: 0);

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    lots = LotRepository(db);
    transactions = TransactionRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    final hives = HiveRepository(db);
    final first = await hives.create(
      orgId: _orgId,
      number: '101',
      type: HiveType.langstroth,
      apiaryId: yayla.id,
    );
    await hives.create(
      orgId: _orgId,
      number: '104',
      type: HiveType.langstroth,
      apiaryId: yayla.id,
    );
    final harvest = (await HarvestRepository(db).add(
      orgId: _orgId,
      plan: (
        apiaryId: yayla.id,
        harvestedAt: DateTime.now(),
        honeyKind: HoneyKind.pine,
        unit: HarvestUnit.superBox,
        unitCount: 24,
        netKg: 574,
      ),
      hiveIds: [first.id],
    )).harvest;
    lot = await lots.createWithHarvest(harvest, origin: 'Yayla');
  });

  Future<double> stock() async =>
      lotStock((await lots.watchSummary(lot.id).first)!);

  Future<FinanceTransaction> seedExpense({
    double amount = 17500,
    bool receipt = false,
  }) => transactions.create(
    orgId: _orgId,
    kind: TransactionKind.expense,
    category: TransactionCategory.feeding,
    amount: amount,
    currency: 'TRY',
    occurredOn: DateTime.now(),
    description: 'Şeker 500 kg',
    receipt: receipt ? (fileId: 'receipt-1', byteSize: 10) : null,
  );

  testWidgets('gider eklenir: tutar, kategori, açıklama ve fiş; listede ve '
      'sezon kartında görünür; Geri al siler', (tester) async {
    final media = FakeMedia();
    final receipts = FakeReceipts();
    await _open(
      tester,
      db: db,
      location: AppRoutes.finance,
      media: media,
      receipts: receipts,
    );
    expect(find.text('Finance · $year'), findsOneWidget);
    expect(find.text('No entries yet'), findsOneWidget);

    await _tap(tester, _button('− Expense'));
    expect(find.byType(TransactionFormScreen), findsOneWidget);
    expect(find.text('Add expense'), findsOneWidget);
    expect(_enabled(tester, 'Save'), isFalse);

    final amountLabel =
        'Amount (${const AppFormat('en').currencySymbol('TRY')})';
    await _enter(tester, amountLabel, '0');
    expect(
      find.text('Enter an amount above 0, like 17500 or 17.50'),
      findsOneWidget,
    );
    await _enter(tester, amountLabel, '17.500');
    // Gelir kategorileri giderde yok.
    expect(find.text('Honey'), findsNothing);
    await _tap(tester, find.text('Feeding'));
    expect(_enabled(tester, 'Save'), isTrue);
    await _enter(tester, 'Description', 'Şeker 500 kg');
    await _tap(tester, _button('Take photo'), screen: TransactionFormScreen);
    expect(find.text('Receipt photo added'), findsOneWidget);
    expect(receipts.fileNames, hasLength(1));
    await _tap(tester, _button('Save'));

    expect(find.byType(FinanceScreen), findsOneWidget);
    expect(find.text('Expense saved'), findsOneWidget);
    expect(find.text('Şeker 500 kg'), findsOneWidget);
    expect(find.text('Feeding · receipt attached'), findsOneWidget);
    // Satırdaki tutar ve sezon neti.
    expect(find.text('−${lira(17500)}'), findsNWidgets(2));
    // Gider 2 aktif kovana bölünür.
    expect(find.text(lira(8750)), findsOneWidget);
    final saved = (await db.select(db.transactions).get()).single;
    expect(saved.amount, 17500);
    expect(saved.currency, 'TRY');
    expect(saved.receiptPath, endsWith(receipts.fileNames.single));
    expect(await db.select(db.receiptUploads).get(), hasLength(1));

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(await transactions.findById(saved.id), isNull);
    expect(find.text('No entries yet'), findsOneWidget);
  });

  testWidgets('lottan satış geliri lotun stoğunu düşürür; stoktan fazlası '
      'yazılamaz', (tester) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.financeNew(TransactionKind.income),
    );
    expect(find.text('Add income'), findsOneWidget);
    // Taşıma yalnız giderde.
    expect(find.text('Move'), findsNothing);
    final amountLabel =
        'Amount (${const AppFormat('en').currencySymbol('TRY')})';
    await _enter(tester, amountLabel, '56000');
    await _tap(tester, find.text('Honey'));
    await _enter(tester, 'Description', 'Toptancıya çam balı');

    expect(find.text('Honey sold (kg)'), findsNothing);
    await _tap(
      tester,
      find.widgetWithText(ListRow, 'Lot'),
      screen: TransactionFormScreen,
    );
    expect(find.text('Stock 574 kg'), findsOneWidget);
    await tester.tap(find.text('$lotNumber · Yayla'));
    await tester.pumpAndSettle();

    await _enter(tester, 'Honey sold (kg)', '600');
    expect(find.text('Only 574 kg in stock'), findsOneWidget);
    expect(_enabled(tester, 'Save'), isFalse);
    await _enter(tester, 'Honey sold (kg)', '160');
    expect(_enabled(tester, 'Save'), isTrue);
    await _tap(tester, _button('Save'));

    expect(find.text('Income saved'), findsOneWidget);
    expect(find.text('Toptancıya çam balı'), findsOneWidget);
    expect(find.text('Honey · $lotNumber · 160 kg'), findsOneWidget);
    expect(find.text('+${lira(56000)}'), findsWidgets);
    expect(await stock(), 414);
  });

  testWidgets('ayrıntı: kategori, tarih, lot ve fiş; silme onaylı, lot '
      'satışını da siler', (tester) async {
    final receipts = FakeReceipts();
    final saved = await transactions.create(
      orgId: _orgId,
      kind: TransactionKind.income,
      category: TransactionCategory.honey,
      amount: 56000,
      currency: 'TRY',
      occurredOn: DateTime.now(),
      lotId: lot.id,
      saleKg: 160,
      apiaryId: yayla.id,
      receipt: (fileId: 'receipt-1', byteSize: 10),
    );
    expect(await stock(), 414);
    await _open(
      tester,
      db: db,
      location: AppRoutes.financeTransaction(saved.id),
      receipts: receipts,
    );

    expect(find.byType(TransactionScreen), findsOneWidget);
    expect(find.text('+${lira(56000)}'), findsOneWidget);
    expect(find.widgetWithText(ListRow, 'Honey'), findsOneWidget);
    expect(find.widgetWithText(ListRow, 'Yayla'), findsOneWidget);
    expect(find.widgetWithText(ListRow, '$lotNumber · 160 kg'), findsOneWidget);
    // Fiş bu telefonda yok (başka telefonda çekilmiş gibi).
    await tester.scrollUntilVisible(
      find.text("The receipt hasn't reached this phone yet"),
      200,
      scrollable: _list(TransactionScreen),
    );

    await _tap(tester, _button('Delete entry'), screen: TransactionScreen);
    expect(find.text('Delete this entry?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(FinanceScreen), findsOneWidget);
    expect(find.text('Entry deleted'), findsOneWidget);
    expect(await transactions.findById(saved.id), isNull);
    expect(await stock(), 574);
  });

  testWidgets('Okut menüsündeki Gider gider formunu açar; Finans karosu '
      'Daha fazla ekranında', (tester) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.partner);
    final container = await _open(tester, db: db, location: AppRoutes.more);

    await tester.ensureVisible(find.text('Finance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finance'));
    await tester.pumpAndSettle();
    expect(find.byType(FinanceScreen), findsOneWidget);

    container.read(routerProvider).go(AppRoutes.today);
    await tester.pumpAndSettle();
    await tester.longPress(_scanButton('Scan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Expense'));
    await tester.pumpAndSettle();

    expect(find.byType(QuickRecordSheet), findsNothing);
    expect(find.byType(TransactionFormScreen), findsOneWidget);
    expect(find.text('Add expense'), findsOneWidget);

    // Kapatınca finans ekranına dönülür.
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    expect(find.byType(FinanceScreen), findsOneWidget);
  });

  testWidgets('worker finansı görmez: karo ve Okut menüsündeki Gider yok', (
    tester,
  ) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.worker);
    final container = await _open(tester, db: db, location: AppRoutes.more);

    await tester.drag(_list(MoreScreen), const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(find.text('Finance'), findsNothing);
    expect(find.text('Settings'), findsOneWidget);

    container.read(routerProvider).go(AppRoutes.today);
    await tester.pumpAndSettle();
    await tester.longPress(_scanButton('Scan'));
    await tester.pumpAndSettle();
    expect(find.byType(QuickRecordSheet), findsOneWidget);
    expect(find.text('Feeding'), findsOneWidget);
    expect(find.text('Expense'), findsNothing);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await seedExpense(receipt: true);
    final container = await _open(tester, db: db, location: AppRoutes.finance);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    for (final text in [
      'Finans · $year',
      'SEZON NET',
      'Gelir',
      'Gider',
      'Maliyet/kovan',
      'SON HAREKETLER',
      'Besleme · fiş eklendi',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    expect(find.textContaining('17.500'), findsWidgets);
    expect(_button('− Gider'), findsOneWidget);
    expect(_button('+ Gelir'), findsOneWidget);

    container
        .read(routerProvider)
        .go(AppRoutes.financeNew(TransactionKind.income));
    await tester.pumpAndSettle();
    for (final text in [
      'Gelir ekle',
      'Tutar (₺)',
      'Kategori',
      'Bal',
      'Polen',
      'Propolis',
      'Mum',
      'Ana arı',
      'Oğulcuk',
      'Diğer',
      'Açıklama',
      'Tarih',
      'BAĞLI KAYIT',
      'Arılık',
      'Lot',
    ]) {
      await tester.scrollUntilVisible(
        find.text(text),
        200,
        scrollable: _list(TransactionFormScreen),
      );
      expect(find.text(text), findsOneWidget, reason: text);
    }
    await tester.scrollUntilVisible(
      find.text('Fiş / fatura'),
      200,
      scrollable: _list(TransactionFormScreen),
    );
    expect(find.text('Fiş eklenmedi'), findsOneWidget);
    expect(_button('Fotoğraf çek'), findsOneWidget);
    expect(_button('Kaydet'), findsOneWidget);

    container
        .read(routerProvider)
        .go(AppRoutes.financeNew(TransactionKind.expense));
    await tester.pumpAndSettle();
    for (final text in [
      'Gider ekle',
      'Besleme',
      'İlaç',
      'Ekipman',
      'Yakıt / nakliye',
      'Arazi kirası',
      'İşçilik',
      'Analiz',
      'Taşıma',
    ]) {
      await tester.scrollUntilVisible(
        find.text(text),
        200,
        scrollable: _list(TransactionFormScreen),
      );
      expect(find.text(text), findsOneWidget, reason: text);
    }
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final saved = await seedExpense(amount: 1234567.5, receipt: true);
    await transactions.create(
      orgId: _orgId,
      kind: TransactionKind.income,
      category: TransactionCategory.honey,
      amount: 56000,
      currency: 'TRY',
      occurredOn: DateTime.now(),
      description: 'Toptancıya çam balı',
      lotId: lot.id,
      saleKg: 160,
      apiaryId: yayla.id,
    );
    final container = await _open(tester, db: db, location: AppRoutes.finance);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    container
        .read(routerProvider)
        .go(AppRoutes.financeNew(TransactionKind.expense));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    container
        .read(routerProvider)
        .go(AppRoutes.financeNew(TransactionKind.income));
    await tester.pumpAndSettle();
    await _tap(
      tester,
      find.widgetWithText(ListRow, 'Lot'),
      screen: TransactionFormScreen,
    );
    await tester.tap(find.text('$lotNumber · Yayla'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    container.read(routerProvider).go(AppRoutes.financeTransaction(saved.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
