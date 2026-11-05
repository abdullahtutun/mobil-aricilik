import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/export/data/export_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ExportRepository repository;
  final at = DateTime.utc(2026, 11, 5, 9);

  setUp(() {
    db = openTestDatabase();
    repository = ExportRepository(db);
  });

  Apiary apiary(String id, {String org = 'org-1', DateTime? deletedAt}) =>
      Apiary(
        id: id,
        orgId: org,
        name: id,
        createdAt: at,
        updatedAt: at,
        deletedAt: deletedAt,
      );

  Hive hive(String id, String apiaryId) => Hive(
    id: id,
    orgId: 'org-1',
    number: id,
    type: HiveType.langstroth,
    apiaryId: apiaryId,
    createdAt: at,
    updatedAt: at,
  );

  test('yalnız işletmenin silinmemiş kayıtları gelir', () async {
    await db.batch(
      (batch) => batch.insertAll(db.apiaries, [
        apiary('yayla').toInsertable(),
        apiary('silinen', deletedAt: at).toInsertable(),
        apiary('baska', org: 'org-2').toInsertable(),
      ]),
    );

    final data = await repository.load('org-1', includeFinance: true);

    expect(data.apiaries.map((a) => a.id), ['yayla']);
    // Outbox'a bir şey yazılmaz.
    expect(await readOutbox(db), isEmpty);
  });

  test('hasattaki kovan sayısı ve stoktaki mevcut miktar hesaplanır', () async {
    await db.into(db.apiaries).insert(apiary('yayla').toInsertable());
    await db.batch(
      (batch) => batch
        ..insertAll(db.hives, [
          hive('1', 'yayla').toInsertable(),
          hive('2', 'yayla').toInsertable(),
        ])
        ..insert(
          db.harvests,
          Harvest(
            id: 'h1',
            orgId: 'org-1',
            apiaryId: 'yayla',
            harvestedAt: at,
            honeyKind: HoneyKind.flower,
            unit: HarvestUnit.superBox,
            unitCount: 3,
            netKg: 42.5,
            createdAt: at,
            updatedAt: at,
          ).toInsertable(),
        )
        ..insertAll(db.harvestHives, [
          for (final hiveId in ['1', '2'])
            HarvestHive(
              id: 'hh$hiveId',
              orgId: 'org-1',
              harvestId: 'h1',
              hiveId: hiveId,
              createdAt: at,
              updatedAt: at,
            ).toInsertable(),
        ])
        ..insert(
          db.inventoryItems,
          InventoryItem(
            id: 'seker',
            orgId: 'org-1',
            name: 'Şeker',
            category: InventoryCategory.consumable,
            unit: InventoryUnit.kg,
            createdAt: at,
            updatedAt: at,
          ).toInsertable(),
        )
        ..insertAll(db.inventoryMoves, [
          for (final (id, kind, quantity) in [
            ('m1', InventoryMoveKind.stockIn, 50.0),
            ('m2', InventoryMoveKind.stockOut, -12.5),
          ])
            InventoryMove(
              id: id,
              orgId: 'org-1',
              itemId: 'seker',
              kind: kind,
              quantity: quantity,
              movedAt: at,
              createdAt: at,
              updatedAt: at,
            ).toInsertable(),
        ]),
    );

    final data = await repository.load('org-1', includeFinance: false);

    expect(data.hives, hasLength(2));
    expect(data.harvestHiveCounts, {'h1': 2});
    expect(data.inventory.single.quantity, 37.5);
  });

  test('finans yalnız istenirse okunur', () async {
    await db
        .into(db.transactions)
        .insert(
          FinanceTransaction(
            id: 't1',
            orgId: 'org-1',
            kind: TransactionKind.expense,
            category: TransactionCategory.feeding,
            amount: 900,
            currency: 'TRY',
            occurredOn: DateTime.utc(2026, 11, 4),
            createdAt: at,
            updatedAt: at,
          ).toInsertable(),
        );

    final withFinance = await repository.load('org-1', includeFinance: true);
    final without = await repository.load('org-1', includeFinance: false);

    expect(withFinance.transactions!.single.amount, 900);
    expect(without.transactions, isNull);
  });
}
