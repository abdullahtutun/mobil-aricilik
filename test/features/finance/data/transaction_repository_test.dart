import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late TransactionRepository transactions;
  late LotRepository lots;
  late Lot lot;

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 10, 26, 9));
    transactions = TransactionRepository(db, clock: clock.call);
    lots = LotRepository(db, clock: clock.call);
    final hive = await HiveRepository(db, clock: clock.call).create(
      orgId: 'org-1',
      number: '101',
      type: HiveType.langstroth,
      apiaryId: 'apiary-1',
    );
    final harvest = (await HarvestRepository(db, clock: clock.call).add(
      orgId: 'org-1',
      plan: (
        apiaryId: 'apiary-1',
        harvestedAt: DateTime.utc(2026, 10, 20, 9),
        honeyKind: HoneyKind.pine,
        unit: HarvestUnit.superBox,
        unitCount: 24,
        netKg: 574,
      ),
      hiveIds: [hive.id],
    )).harvest;
    lot = await lots.createWithHarvest(harvest);
  });

  Future<List<OutboxEntry>> financeOutbox() async => [
    for (final entry in await readOutbox(db))
      if (entry.recordTable == 'transactions' ||
          entry.recordTable == 'lot_sales')
        entry,
  ];

  Future<double> stock() async =>
      lotStock((await lots.watchSummary(lot.id).first)!);

  Future<FinanceTransaction> expense({
    double amount = 17500,
    ReceiptCapture? receipt,
    DateTime? on,
  }) => transactions.create(
    orgId: 'org-1',
    kind: TransactionKind.expense,
    category: TransactionCategory.feeding,
    amount: amount,
    currency: 'TRY',
    occurredOn: on ?? DateTime(2026, 10, 25),
    description: ' Şeker 500 kg ',
    receipt: receipt,
  );

  Future<FinanceTransaction> sale({double? kg = 160}) => transactions.create(
    orgId: 'org-1',
    kind: TransactionKind.income,
    category: TransactionCategory.honey,
    amount: 56000,
    currency: 'TRY',
    occurredOn: DateTime(2026, 10, 26),
    lotId: lot.id,
    saleKg: kg,
  );

  test(
    "gider outbox'a sunucunun kolonlarıyla olay kaydı olarak gider",
    () async {
      final saved = await expense();

      expect(saved.description, 'Şeker 500 kg');
      final outbox = await financeOutbox();
      expect(outbox.single.operation, OutboxOperation.upsert);
      expect(outbox.single.payload, {
        'id': saved.id,
        'org_id': 'org-1',
        'kind': 'expense',
        'category': 'feeding',
        'amount': 17500.0,
        'currency': 'TRY',
        'occurred_on': '2026-10-25',
        'description': 'Şeker 500 kg',
        'receipt_path': null,
        'apiary_id': null,
        'lot_id': null,
        'transport_id': null,
        'lot_sale_id': null,
        'created_at': '2026-10-26T09:00:00.000Z',
        'updated_at': '2026-10-26T09:00:00.000Z',
        'created_by': null,
        'deleted_at': null,
      });
    },
  );

  test('lottan satış: satış ve gelir tek transactionda, stok düşer; '
      'silinince ikisi de silinir, stok geri gelir', () async {
    expect(await stock(), 574);

    final saved = await sale();

    expect(await stock(), 414);
    final saleRow = (await lots.sales.findById(saved.lotSaleId!))!;
    expect(saleRow.kg, 160);
    expect(saleRow.soldOn, DateTime(2026, 10, 26));
    expect((await financeOutbox()).map((e) => e.recordTable), [
      'lot_sales',
      'transactions',
    ]);

    await transactions.remove(saved.id);

    expect(await stock(), 574);
    expect(await transactions.findById(saved.id), isNull);
    expect(await lots.sales.findById(saved.lotSaleId!), isNull);
    expect(
      (await financeOutbox()).skip(2).map((e) => (e.recordTable, e.operation)),
      [
        ('transactions', OutboxOperation.delete),
        ('lot_sales', OutboxOperation.delete),
      ],
    );
  });

  test('satış kilogramı gidere ya da lotsuz gelire yazılmaz; geçersiz '
      'harekette satış da yazılmaz', () async {
    await expectLater(
      transactions.create(
        orgId: 'org-1',
        kind: TransactionKind.expense,
        category: TransactionCategory.other,
        amount: 10,
        currency: 'TRY',
        occurredOn: DateTime(2026, 10, 26),
        lotId: lot.id,
        saleKg: 10,
      ),
      throwsArgumentError,
    );
    await expectLater(
      transactions.create(
        orgId: 'org-1',
        kind: TransactionKind.income,
        category: TransactionCategory.feeding,
        amount: 10,
        currency: 'TRY',
        occurredOn: DateTime(2026, 10, 26),
        lotId: lot.id,
        saleKg: 10,
      ),
      throwsArgumentError,
    );
    expect(await db.select(db.lotSales).get(), isEmpty);
    expect(await db.select(db.transactions).get(), isEmpty);
    expect(await stock(), 574);
  });

  test('outbox yazılamazsa ne hareket ne satış yazılır', () async {
    await db.customStatement(
      'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
      "WHEN NEW.record_table = 'transactions' "
      "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
    );
    await expectLater(sale(), throwsA(anything));
    expect(await db.select(db.transactions).get(), isEmpty);
    expect(await db.select(db.lotSales).get(), isEmpty);
    expect(await db.select(db.receiptUploads).get(), isEmpty);
  });

  test('fiş kaydın klasörüne yazılır ve yükleme kuyruğuna girer; silinince '
      'yüklenmemiş fiş kuyruktan çıkar', () async {
    final saved = await expense(receipt: (fileId: 'file-1', byteSize: 2048));

    expect(saved.receiptPath, 'org-1/${saved.id}/file-1.jpg');
    final upload = await db.select(db.receiptUploads).getSingle();
    expect(upload.storagePath, saved.receiptPath);
    expect(upload.transactionId, saved.id);
    expect(upload.uploadStatus, MediaUploadStatus.pending);
    expect(await transactions.watchPendingReceiptCount().first, 1);
    expect((await transactions.listWithReceipts('org-1')).map((t) => t.id), [
      saved.id,
    ]);

    await transactions.remove(saved.id);

    expect(await db.select(db.receiptUploads).get(), isEmpty);
    expect(await transactions.listWithReceipts('org-1'), isEmpty);
  });

  test('satırlar yeni önce; bağlı lot, satış kilogramı, arılık ve taşıma '
      'adlarıyla; değişince yeniden yayar', () async {
    final apiaries = ApiaryRepository(db, clock: clock.call);
    final source = await apiaries.create(orgId: 'org-1', name: 'Kestane');
    final destination = await apiaries.create(orgId: 'org-1', name: 'Çam');
    await db.customStatement(
      'INSERT INTO transports (id, org_id, source_apiary_id, '
      'destination_apiary_id, vehicles, status, created_at, updated_at) '
      "VALUES ('transport-1', 'org-1', '${source.id}', '${destination.id}', "
      "'[]', 'completed', '2026-10-24T09:00:00.000Z', "
      "'2026-10-24T09:00:00.000Z')",
    );
    final fuel = await transactions.create(
      orgId: 'org-1',
      kind: TransactionKind.expense,
      category: TransactionCategory.fuelTransport,
      amount: 9800,
      currency: 'TRY',
      occurredOn: DateTime(2026, 10, 24),
      apiaryId: source.id,
      transportId: 'transport-1',
    );
    final sold = await sale();
    final feed = await expense(on: DateTime(2026, 10, 26));

    final rows = await transactions.watchRows('org-1').first;
    expect(rows.map((r) => r.transaction.id), [feed.id, sold.id, fuel.id]);
    final soldRow = rows[1];
    expect((soldRow.lotYear, soldRow.lotSeq, soldRow.saleKg), (2026, 1, 160));
    final fuelRow = rows[2];
    expect(fuelRow.apiaryName, 'Kestane');
    expect((fuelRow.transportFrom, fuelRow.transportTo), ('Kestane', 'Çam'));

    final updates = transactions.watchRow(sold.id);
    expect(await updates.first, isNotNull);
    await transactions.remove(sold.id);
    expect(await transactions.watchRow(sold.id).first, isNull);
    expect(
      (await transactions.watchRows('org-1').first).map(
        (r) => r.transaction.id,
      ),
      [feed.id, fuel.id],
    );
  });

  test('silinmiş harekette remove bir şey yazmaz', () async {
    final saved = await expense();
    await transactions.remove(saved.id);
    final before = (await readOutbox(db)).length;
    await transactions.remove(saved.id);
    expect((await readOutbox(db)).length, before);
  });

  test('taşıma seçenekleri yeni önce, arılık adlarıyla', () async {
    await db.customStatement(
      'INSERT INTO transports (id, org_id, source_apiary_id, '
      'destination_apiary_id, vehicles, status, created_at, updated_at) '
      "VALUES ('transport-1', 'org-1', 'a', 'b', '[]', 'loading', "
      "'2026-10-24T09:00:00.000Z', '2026-10-24T09:00:00.000Z'), "
      "('transport-2', 'org-1', 'a', 'b', '[]', 'loading', "
      "'2026-10-25T09:00:00.000Z', '2026-10-25T09:00:00.000Z'), "
      "('transport-3', 'org-2', 'a', 'b', '[]', 'loading', "
      "'2026-10-25T09:00:00.000Z', '2026-10-25T09:00:00.000Z')",
    );
    final choices = await transactions.watchTransportChoices('org-1').first;
    expect(choices.map((c) => c.id), ['transport-2', 'transport-1']);
    expect(choices.first.from, isNull);
    expect(choices.first.createdAt, DateTime.utc(2026, 10, 25, 9));
  });
}
