import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/finance/data/customer_repository.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late CustomerRepository customers;
  late CustomerPaymentRepository payments;
  late TransactionRepository transactions;
  late Customer ayse;

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 11, 4, 9));
    customers = CustomerRepository(db, clock: clock.call);
    payments = CustomerPaymentRepository(db, clock: clock.call);
    transactions = TransactionRepository(db, clock: clock.call);
    ayse = await customers.create(
      orgId: 'org-1',
      name: ' Ayşe Hanım ',
      phone: '0532 123 45 67',
      address: ' ',
    );
  });

  Future<FinanceTransaction> sale({
    double amount = 6000,
    double? paidNow,
    String? customerId,
  }) => transactions.create(
    orgId: 'org-1',
    kind: TransactionKind.income,
    category: TransactionCategory.honey,
    amount: amount,
    currency: 'TRY',
    occurredOn: DateTime(2026, 11, 3),
    description: 'Kestane balı 10 kg',
    customerId: customerId ?? ayse.id,
    paidNow: paidNow,
  );

  Future<List<OutboxEntry>> outboxOf(String table) async => [
    for (final entry in await readOutbox(db))
      if (entry.recordTable == table) entry,
  ];

  group('CustomerRepository', () {
    test(
      'müşteriyi temizleyip yazar; outbox payload sunucunun kolonları',
      () async {
        expect(ayse.name, 'Ayşe Hanım');
        expect(ayse.address, isNull);
        final entry = (await outboxOf('customers')).single;
        final payload = entry.payload;
        expect(payload, containsPair('name', 'Ayşe Hanım'));
        expect(payload, containsPair('phone', '0532 123 45 67'));
        expect(payload.keys, containsAll(['address', 'notes', 'org_id']));
        expect(payload.keys, isNot(contains('server_seq')));
      },
    );

    test(
      'düzenleme son yazan kazanır; silme yumuşak ve listeden düşer',
      () async {
        clock.current = clock.current.add(const Duration(minutes: 1));
        final updated = await customers.update(ayse.copyWith(notes: 'Toptan'));
        expect(updated.notes, 'Toptan');
        expect(updated.updatedAt.isAfter(ayse.updatedAt), isTrue);

        final list = customers.watchAll('org-1');
        expect((await list.first).single.notes, 'Toptan');
        await customers.delete(ayse.id);
        expect(await list.first, isEmpty);
        expect(await customers.findById(ayse.id), isNull);
        expect(
          (await db.select(db.customers).get()).single.deletedAt,
          isNotNull,
        );
      },
    );

    test('liste ada göre; geçersiz ad yazılmaz', () async {
      await customers.create(orgId: 'org-1', name: 'Ali Bey');
      await customers.create(orgId: 'org-2', name: 'Başka');
      expect((await customers.watchAll('org-1').first).map((c) => c.name), [
        'Ali Bey',
        'Ayşe Hanım',
      ]);
      await expectLater(
        customers.create(orgId: 'org-1', name: '  '),
        throwsArgumentError,
      );
      expect(await outboxOf('customers'), hasLength(3));
    });
  });

  group('tahsilat', () {
    test('peşin ödeme satışla tek transactionda tahsilat olur; kalan '
        'satırda görünür', () async {
      final sold = await sale(paidNow: 2000);
      expect(sold.customerId, ayse.id);
      final payment = (await payments.findBySale(sold.id)).single;
      expect(payment.amount, 2000);
      expect(payment.paidOn, DateTime(2026, 11, 3));
      final row = (await transactions.watchRow(sold.id).first)!;
      expect(row.customerName, 'Ayşe Hanım');
      expect(row.paid, 2000);
      expect((await payments.balanceOf(sold)).remaining, 4000);
      final payload = (await outboxOf('customer_payments')).single.payload;
      expect(payload, containsPair('transaction_id', sold.id));
      expect(payload, containsPair('paid_on', '2026-11-03'));
    });

    test(
      'kalanı aşan tahsilat, müşterisiz satış ve gider reddedilir',
      () async {
        final sold = await sale(paidNow: 2000);
        await expectLater(
          payments.add(sold, 4000.01, paidOn: DateTime(2026, 11, 4)),
          throwsArgumentError,
        );
        await expectLater(sale(paidNow: 6000.5), throwsArgumentError);
        final plain = await transactions.create(
          orgId: 'org-1',
          kind: TransactionKind.income,
          category: TransactionCategory.honey,
          amount: 100,
          currency: 'TRY',
          occurredOn: DateTime(2026, 11, 3),
        );
        await expectLater(
          payments.add(plain, 50, paidOn: DateTime(2026, 11, 4)),
          throwsStateError,
        );
        await expectLater(
          transactions.create(
            orgId: 'org-1',
            kind: TransactionKind.expense,
            category: TransactionCategory.other,
            amount: 100,
            currency: 'TRY',
            occurredOn: DateTime(2026, 11, 3),
            customerId: ayse.id,
          ),
          throwsArgumentError,
        );
        expect(await db.select(db.customerPayments).get(), hasLength(1));
        expect(await db.select(db.transactions).get(), hasLength(2));
      },
    );

    test('payRemaining kalanı kapatır; kalan yoksa bir şey yazmaz', () async {
      final sold = await sale(paidNow: 2000);
      final payment = await payments.payRemaining(
        sold,
        paidOn: DateTime(2026, 11, 4),
      );
      expect(payment!.amount, 4000);
      expect((await payments.balanceOf(sold)).remaining, 0);
      expect(
        await payments.payRemaining(sold, paidOn: DateTime(2026, 11, 4)),
        isNull,
      );
      // Geri al: tahsilat silinir, kalan geri gelir.
      await payments.delete(payment.id);
      expect((await payments.balanceOf(sold)).remaining, 4000);
      expect((await transactions.watchRow(sold.id).first)!.paid, 2000);
    });

    test('outbox yazılamazsa ne satış ne tahsilat yazılır', () async {
      await db.customStatement(
        'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
        "WHEN NEW.record_table = 'customer_payments' "
        "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
      );
      await expectLater(sale(paidNow: 2000), throwsA(anything));
      expect(await db.select(db.transactions).get(), isEmpty);
      expect(await db.select(db.customerPayments).get(), isEmpty);
    });

    test('satış silinince tahsilatları da silinir', () async {
      final sold = await sale(paidNow: 2000);
      await payments.add(sold, 1000, paidOn: DateTime(2026, 11, 4));
      await transactions.remove(sold.id);
      expect(await payments.findBySale(sold.id), isEmpty);
      expect(await outboxOf('customer_payments'), hasLength(4));
    });

    test('müşterinin satışları yeni önce; tahsilat gelince satır yeniden '
        'yayar', () async {
      final first = await sale(amount: 500);
      final ali = await customers.create(orgId: 'org-1', name: 'Ali Bey');
      await sale(customerId: ali.id);
      final second = await transactions.create(
        orgId: 'org-1',
        kind: TransactionKind.income,
        category: TransactionCategory.honey,
        amount: 900,
        currency: 'TRY',
        occurredOn: DateTime(2026, 11, 4),
        customerId: ayse.id,
      );
      final rows = transactions.watchCustomerRows(ayse.id);
      expect((await rows.first).map((r) => r.transaction.id), [
        second.id,
        first.id,
      ]);
      await payments.add(first, 500, paidOn: DateTime(2026, 11, 4));
      expect(
        (await rows.first).firstWhere((r) => r.transaction.id == first.id).paid,
        500,
      );
    });
  });

  test('lot hasat payları hasadın arılığı ve kilogramıyla gelir', () async {
    final hive = await HiveRepository(db, clock: clock.call).create(
      orgId: 'org-1',
      number: '101',
      type: HiveType.langstroth,
      apiaryId: 'apiary-cam',
    );
    final harvest = (await HarvestRepository(db, clock: clock.call).add(
      orgId: 'org-1',
      plan: (
        apiaryId: 'apiary-cam',
        harvestedAt: DateTime.utc(2026, 10, 20, 9),
        honeyKind: HoneyKind.pine,
        unit: HarvestUnit.superBox,
        unitCount: 24,
        netKg: 574,
      ),
      hiveIds: [hive.id],
    )).harvest;
    final lot = await LotRepository(
      db,
      clock: clock.call,
    ).createWithHarvest(harvest);
    expect(await transactions.watchLotHarvestShares('org-1').first, [
      (lotId: lot.id, apiaryId: 'apiary-cam', kg: 574.0),
    ]);
    expect(await transactions.watchLotHarvestShares('org-2').first, isEmpty);
  });
}
