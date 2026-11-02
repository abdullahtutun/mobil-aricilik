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
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/finance/data/customer_repository.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/customer_form_screen.dart';
import 'package:mobil_arici/features/finance/presentation/customer_screen.dart';
import 'package:mobil_arici/features/finance/presentation/finance_screen.dart';
import 'package:mobil_arici/features/finance/presentation/payment_form_screen.dart';
import 'package:mobil_arici/features/finance/presentation/transaction_form_screen.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/migration/data/transport_repository.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakeUrlLauncher? urlLauncher,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, urlLauncher: urlLauncher),
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

void main() {
  late AppDatabase db;
  late CustomerRepository customers;
  late TransactionRepository transactions;
  late Customer ayse;

  /// İngilizce arayüzde ₺ tutarı (`₺4,000`).
  String lira(num amount) =>
      const AppFormat('en')
          .currency(amount, currencyCode: 'TRY', decimalDigits: 0);

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    customers = CustomerRepository(db);
    transactions = TransactionRepository(db);
    ayse = await customers.create(
      orgId: _orgId,
      name: 'Ayşe Hanım',
      phone: '0532 123 45 67',
      address: 'Rize',
    );
  });

  Future<FinanceTransaction> seedSale({double? paidNow = 2000}) =>
      transactions.create(
        orgId: _orgId,
        kind: TransactionKind.income,
        category: TransactionCategory.honey,
        amount: 6000,
        currency: 'TRY',
        occurredOn: DateTime.now(),
        description: 'Kestane balı 10 kg',
        customerId: ayse.id,
        paidNow: paidNow,
      );

  Future<void> openOrder(WidgetTester tester) =>
      _tap(tester, find.text('Kestane balı 10 kg'), screen: CustomerScreen);

  testWidgets('müşteri eklenir, satış peşinli yazılır; alacak Finans '
      'kartında, müşteri defterinde ve siparişte görünür', (tester) async {
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.customers,
    );
    expect(find.text('Ayşe Hanım'), findsOneWidget);

    await tester.tap(find.byTooltip('Add customer'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomerFormScreen), findsOneWidget);
    expect(_enabled(tester, 'Save'), isFalse);
    await _enter(tester, 'Name', 'Ali Bey');
    await _enter(tester, 'Phone', '+90 555 000 00 00');
    await _tap(tester, _button('Save'));
    expect(find.byType(CustomerScreen), findsOneWidget);
    expect(find.text('Ali Bey'), findsOneWidget);
    expect(find.text('No sales to this customer yet.'), findsOneWidget);

    await tester.tap(_button('Add sale'));
    await tester.pumpAndSettle();
    expect(find.byType(TransactionFormScreen), findsOneWidget);
    await tester.scrollUntilVisible(
      find.widgetWithText(ListRow, 'Ali Bey'),
      200,
      scrollable: _list(TransactionFormScreen),
    );
    expect(find.widgetWithText(ListRow, 'Ali Bey'), findsOneWidget);
    await tester.drag(_list(TransactionFormScreen), const Offset(0, 2000));
    await tester.pumpAndSettle();
    await _enter(tester, 'Amount (₺)', '6000');
    await _tap(tester, find.text('Honey'), screen: TransactionFormScreen);
    await _tap(
      tester,
      find.widgetWithText(LabeledField, 'Paid now'),
      screen: TransactionFormScreen,
    );
    await _enter(tester, 'Paid now', '7000');
    expect(find.text("Can't be more than the amount."), findsOneWidget);
    expect(_enabled(tester, 'Save'), isFalse);
    await _enter(tester, 'Paid now', '2000');
    await _tap(tester, _button('Save'));

    final sale = (await db.select(db.transactions).get()).single;
    expect(sale.customerId, isNotNull);
    final payment = (await db.select(db.customerPayments).get()).single;
    expect(payment.amount, 2000);
    expect(payment.transactionId, sale.id);

    container.read(routerProvider).go(AppRoutes.finance);
    await tester.pumpAndSettle();
    expect(find.text('${lira(4000)} owed · 1 customer'), findsOneWidget);
    await tester.tap(find.text('${lira(4000)} owed · 1 customer'));
    await tester.pumpAndSettle();
    expect(find.text('${lira(4000)} owed'), findsOneWidget);
    await tester.tap(find.text('Ali Bey'));
    await tester.pumpAndSettle();
    expect(find.text('${lira(4000)} owed'), findsOneWidget);
    expect(
      find.widgetWithText(StatusBadge, '${lira(4000)} left'),
      findsOneWidget,
    );
  });

  testWidgets('son hareketlerde müşterili satırda ödeme durumu: kısmi, '
      'ödenmedi ve ödendi', (tester) async {
    final partial = await seedSale();
    await seedSale(paidNow: null);
    await seedSale(paidNow: 6000);
    final container = await _open(tester, db: db, location: AppRoutes.finance);
    Finder row(String status) =>
        find.widgetWithText(ListRow, 'Honey · Ayşe Hanım · $status');
    Future<void> see(String status) => tester.scrollUntilVisible(
      row(status),
      200,
      scrollable: _list(FinanceScreen),
    );
    await see('${lira(2000)} paid, ${lira(4000)} left');
    await see('Unpaid');
    await see('Paid');

    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(
      find.text('Bal · Ayşe Hanım · ₺2.000 ödendi, ₺4.000 kalan'),
      findsOneWidget,
    );

    // Tahsilat gelince satır kendiliğinden güncellenir.
    await tester.runAsync(
      () =>
          CustomerPaymentRepository(db)
              .add(partial, 4000, paidOn: DateTime.now()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Bal · Ayşe Hanım · Ödendi'), findsNWidgets(2));
  });

  testWidgets('Ödendi olarak işaretle kalanı kapatır; Geri al geri getirir', (
    tester,
  ) async {
    await seedSale();
    await _open(tester, db: db, location: AppRoutes.customer(ayse.id));
    await openOrder(tester);
    expect(find.text(lira(4000)).evaluate(), isEmpty);
    await tester.tap(find.text('Mark as paid'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(StatusBadge, 'Paid'), findsOneWidget);
    expect(find.text('Nothing owed'), findsOneWidget);
    expect(await db.select(db.customerPayments).get(), hasLength(2));

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(StatusBadge, '${lira(4000)} left'),
      findsOneWidget,
    );
    final live = [
      for (final p in await db.select(db.customerPayments).get())
        if (p.deletedAt == null) p,
    ];
    expect(live.single.amount, 2000);
  });

  testWidgets('tahsilat formu kalanla dolu gelir, fazlasını yazdırmaz', (
    tester,
  ) async {
    await seedSale();
    await _open(tester, db: db, location: AppRoutes.customer(ayse.id));
    await openOrder(tester);
    await tester.tap(find.text('Record payment'));
    await tester.pumpAndSettle();
    expect(find.byType(PaymentFormScreen), findsOneWidget);
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.widgetWithText(LabeledField, 'Amount (₺)'),
              matching: find.byType(TextField),
            ),
          )
          .controller!
          .text,
      '4000',
    );
    await _enter(tester, 'Amount (₺)', '5000');
    expect(find.text('Only ${lira(4000)} is left.'), findsOneWidget);
    expect(_enabled(tester, 'Save payment'), isFalse);
    await _enter(tester, 'Amount (₺)', '1500');
    await _tap(tester, _button('Save payment'));
    expect(find.byType(CustomerScreen), findsOneWidget);
    expect(
      find.widgetWithText(StatusBadge, '${lira(2500)} left'),
      findsOneWidget,
    );
  });

  testWidgets('WhatsApp ile gönder hazır sipariş özetini müşterinin '
      'numarasıyla açar; açılamazsa söyler', (tester) async {
    await seedSale();
    final launcher = FakeUrlLauncher();
    await _open(
      tester,
      db: db,
      location: AppRoutes.customer(ayse.id),
      urlLauncher: launcher,
    );
    await openOrder(tester);
    await tester.tap(find.text('Send via WhatsApp'));
    await tester.pumpAndSettle();
    final uri = launcher.opened.single;
    expect(uri.host, 'wa.me');
    expect(uri.path, '/905321234567');
    final text = uri.queryParameters['text']!;
    expect(text, startsWith('Hello Ayşe Hanım,\nYour order summary:\n'));
    expect(text, contains('Kestane balı 10 kg'));
    expect(text, contains('Total: ${lira(6000)}'));
    expect(text, contains('Paid: ${lira(2000)}'));
    expect(text, contains('Remaining: ${lira(4000)}'));
    expect(text, contains('Shipping address: Rize'));
    expect(text, endsWith(testOrganization.name));

    launcher.available = false;
    await openOrder(tester);
    await tester.tap(find.text('Send via WhatsApp'));
    await tester.pumpAndSettle();
    expect(find.text("Couldn't open WhatsApp"), findsOneWidget);
  });

  testWidgets('müşteri düzenlenir ve silinir; satışı kalır', (tester) async {
    await seedSale(paidNow: null);
    await _open(tester, db: db, location: AppRoutes.customer(ayse.id));
    await tester.tap(find.byTooltip('Edit customer'));
    await tester.pumpAndSettle();
    await _enter(tester, 'Name', 'Ayşe Yılmaz');
    await _tap(tester, _button('Save'));
    expect(find.text('Ayşe Yılmaz'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit customer'));
    await tester.pumpAndSettle();
    await _tap(tester, _button('Delete customer'), screen: CustomerFormScreen);
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Customer deleted'), findsOneWidget);
    expect(find.text('No customers yet'), findsOneWidget);
    expect(await db.select(db.transactions).get(), hasLength(1));
  });

  group('Konaklama kârlılığı', () {
    late Apiary cam;
    late Apiary kestane;

    setUp(() async {
      final apiaries = ApiaryRepository(db);
      cam = await apiaries.create(orgId: _orgId, name: 'Çam');
      kestane = await apiaries.create(orgId: _orgId, name: 'Kestane');
      final hive = await HiveRepository(db).create(
        orgId: _orgId,
        number: '101',
        type: HiveType.langstroth,
        apiaryId: cam.id,
      );
      final harvest = (await HarvestRepository(db).add(
        orgId: _orgId,
        plan: (
          apiaryId: cam.id,
          harvestedAt: DateTime.now(),
          honeyKind: HoneyKind.pine,
          unit: HarvestUnit.superBox,
          unitCount: 10,
          netKg: 300,
        ),
        hiveIds: [hive.id],
      )).harvest;
      final lot = await LotRepository(db).createWithHarvest(harvest);
      final transport = await TransportRepository(db).start(
        orgId: _orgId,
        sourceApiaryId: kestane.id,
        destinationApiaryId: cam.id,
        vehicles: ['Kamyon'],
      );
      Future<void> add(
        TransactionKind kind,
        double amount, {
        String? apiaryId,
        String? lotId,
        String? transportId,
      }) => transactions.create(
        orgId: _orgId,
        kind: kind,
        category: kind == TransactionKind.income
            ? TransactionCategory.honey
            : TransactionCategory.fuelTransport,
        amount: amount,
        currency: 'TRY',
        occurredOn: DateTime.now(),
        apiaryId: apiaryId,
        lotId: lotId,
        transportId: transportId,
      );
      // Çam: lottan 150.000 gelir, taşımanın mazotu 8.000 → +142.000.
      await add(TransactionKind.income, 150000, lotId: lot.id);
      await add(TransactionKind.expense, 8000, transportId: transport.id);
      // Kestane: 5.000 gelir, 8.000 kira → −3.000.
      await add(TransactionKind.income, 5000, apiaryId: kestane.id);
      await add(TransactionKind.expense, 8000, apiaryId: kestane.id);
      // Arılığa bağlanamayan gider karta girmez.
      await add(TransactionKind.expense, 999);
    });

    testWidgets('arılık başı net, kâr önce; kâr yeşil +, zarar kırmızı −', (
      tester,
    ) async {
      await _open(tester, db: db, location: AppRoutes.finance);
      expect(find.text('Profit by apiary'), findsOneWidget);
      final card = find.ancestor(
        of: find.text('Profit by apiary'),
        matching: find.byType(SectionCard),
      );
      Finder inCard(String text) =>
          find.descendant(of: card, matching: find.text(text));
      expect(inCard('Çam'), findsOneWidget);
      expect(inCard('+${lira(142000)}'), findsOneWidget);
      expect(inCard('Kestane'), findsOneWidget);
      expect(inCard('−${lira(3000)}'), findsOneWidget);
      expect(
        tester.getTopLeft(inCard('Çam')).dy,
        lessThan(tester.getTopLeft(inCard('Kestane')).dy),
      );
      final colors = tester.element(find.byType(FinanceScreen)).colors;
      expect(
        tester.widget<Text>(inCard('−${lira(3000)}')).style!.color,
        colors.statusCritical,
      );
      expect(
        find.descendant(
          of: card,
          matching: find.byIcon(Icons.trending_down_rounded),
        ),
        findsOneWidget,
      );
    });

    testWidgets('Türkçe metinler', (tester) async {
      await seedSale();
      final container = await _open(
        tester,
        db: db,
        location: AppRoutes.finance,
      );
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();
      expect(find.text('Konaklama kârlılığı'), findsOneWidget);
      expect(find.text('+₺142.000'), findsOneWidget);
      expect(find.text('−₺3.000'), findsOneWidget);
      expect(find.text('₺4.000 alacak · 1 müşteri'), findsOneWidget);
      expect(find.text('Müşteri defteri'), findsOneWidget);

      container.read(routerProvider).go(AppRoutes.customers);
      await tester.pumpAndSettle();
      expect(find.text('Müşteri defteri'), findsOneWidget);
      expect(find.byTooltip('Müşteri ekle'), findsOneWidget);
      expect(find.text('₺4.000 alacak'), findsOneWidget);

      container.read(routerProvider).go(AppRoutes.customer(ayse.id));
      await tester.pumpAndSettle();
      for (final text in ['Telefon', 'Kargo adresi', 'SİPARİŞLER']) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(_button('Satış ekle'), findsOneWidget);
      expect(find.widgetWithText(StatusBadge, 'Kalan ₺4.000'), findsOneWidget);
      await openOrder(tester);
      for (final text in [
        'Ödendi olarak işaretle',
        'Tahsilat ekle',
        'WhatsApp ile gönder',
        'Hareketi aç',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      await tester.tap(find.text('Ödendi olarak işaretle'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(StatusBadge, 'Ödendi'), findsOneWidget);
      expect(find.text('Alacak yok'), findsOneWidget);

      container.read(routerProvider).go(AppRoutes.customerNew);
      await tester.pumpAndSettle();
      for (final text in [
        'Yeni müşteri',
        'Ad',
        'Telefon',
        'Kargo adresi',
        'Not',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }

      container
          .read(routerProvider)
          .go(AppRoutes.financeNew(TransactionKind.income));
      await tester.pumpAndSettle();
      await _tap(
        tester,
        find.widgetWithText(ListRow, 'Müşteri'),
        screen: TransactionFormScreen,
      );
      expect(find.text('Müşteri seç'), findsOneWidget);
      await tester.tap(find.text('Ayşe Hanım'));
      await tester.pumpAndSettle();
      await _tap(
        tester,
        find.text('Peşin alınan'),
        screen: TransactionFormScreen,
      );
      expect(find.text('Boş bırakırsan tamamı alacak olur.'), findsOneWidget);
    });

    testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final sale = await seedSale();
      final long = await customers.create(
        orgId: _orgId,
        name: 'Karadeniz Doğal Ürünler Kooperatifi',
      );
      await transactions.create(
        orgId: _orgId,
        kind: TransactionKind.income,
        category: TransactionCategory.honey,
        amount: 1234567.5,
        currency: 'TRY',
        occurredOn: DateTime.now(),
        description: 'Toptancıya kestane ve çam balı karışık',
        customerId: long.id,
      );
      final container = await _open(
        tester,
        db: db,
        location: AppRoutes.finance,
      );
      container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      for (final location in [
        AppRoutes.customers,
        AppRoutes.customer(long.id),
        AppRoutes.customer(ayse.id),
        AppRoutes.customerEdit(ayse.id),
        AppRoutes.financePayment(sale.id),
        AppRoutes.financeTransaction(sale.id),
        AppRoutes.financeSale(ayse.id),
      ]) {
        container.read(routerProvider).go(location);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: location);
      }
      await _tap(
        tester,
        find.text('Peşin alınan'),
        screen: TransactionFormScreen,
      );
      expect(tester.takeException(), isNull);

      container.read(routerProvider).go(AppRoutes.customer(ayse.id));
      await tester.pumpAndSettle();
      await openOrder(tester);
      expect(tester.takeException(), isNull);
    });
  });
}
