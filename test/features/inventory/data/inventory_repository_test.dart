import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/inventory/data/inventory_repository.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late InventoryRepository repository;
  late InventoryMoveRepository moves;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = InventoryRepository(db, clock: clock.call);
    moves = repository.moves;
  });

  Future<InventoryItem> createItem({
    String orgId = 'org-1',
    String name = 'Temel petek',
    InventoryCategory category = InventoryCategory.comb,
    InventoryUnit unit = InventoryUnit.piece,
    String? place = 'depo',
    double? threshold = 100,
  }) => repository.create(
    orgId: orgId,
    name: name,
    category: category,
    unit: unit,
    place: place,
    threshold: threshold,
  );

  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  test('kalemi ve hareketi yazar; outbox payload’u sunucunun kolonlarıyla, '
      'metinler kırpılır, boş yer null', () async {
    final item = await createItem(name: '  Temel petek ', place: '  ');
    final move = await moves.add(
      item,
      InventoryMoveKind.stockOut,
      12,
      linkedTable: 'feedings',
      linkedId: 'feeding-1',
    );

    final outbox = await readOutbox(db);
    expect(outbox.map((e) => e.recordTable), [
      'inventory_items',
      'inventory_moves',
    ]);
    expect(outbox.first.payload, {
      'id': item.id,
      'org_id': 'org-1',
      'name': 'Temel petek',
      'category': 'comb',
      'unit': 'piece',
      'place': null,
      'threshold': 100.0,
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
    expect(outbox.last.payload, {
      'id': move.id,
      'org_id': 'org-1',
      'item_id': item.id,
      'kind': 'out',
      'quantity': -12.0,
      'moved_at': '2026-10-22T09:00:00.000Z',
      'linked_table': 'feedings',
      'linked_id': 'feeding-1',
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
  });

  test('geçersiz değerler ArgumentError atar ve bir şey yazmaz', () async {
    for (final invalid in [
      () => createItem(name: ' '),
      () => createItem(name: 'a' * (maxInventoryNameLength + 1)),
      () => createItem(place: 'a' * (maxInventoryPlaceLength + 1)),
      () => createItem(threshold: 0),
      () => createItem(threshold: inventoryQuantityLimit.toDouble()),
    ]) {
      await expectLater(invalid(), throwsArgumentError);
    }
    final item = await createItem();
    await expectLater(
      moves.add(item, InventoryMoveKind.stockIn, 0),
      throwsArgumentError,
    );
    await expectLater(
      moves.add(item, InventoryMoveKind.stockIn, 2.5),
      throwsArgumentError,
      reason: 'adet birimi tam sayı ister',
    );
    await expectLater(
      moves.add(item, InventoryMoveKind.adjustment, 2),
      throwsArgumentError,
    );
    await expectLater(
      moves.add(item, InventoryMoveKind.stockIn, 2, linkedTable: 'feedings'),
      throwsArgumentError,
    );
    await expectLater(moves.adjustTo(item, -1), throwsArgumentError);

    expect(await readOutbox(db), hasLength(1));
    expect(await moves.stockOf(item.id), 0);
  });

  test('stok hareketlerin toplamı; sayım farkı düzeltme olarak yazar, '
      'fark yoksa yazmaz', () async {
    final sugar = await createItem(
      name: 'Şeker',
      category: InventoryCategory.consumable,
      unit: InventoryUnit.kg,
      threshold: null,
    );
    await moves.add(sugar, InventoryMoveKind.stockIn, 150.5);
    await moves.add(sugar, InventoryMoveKind.stockOut, 0.25);
    expect(await moves.stockOf(sugar.id), 150.25);

    final adjustment = (await moves.adjustTo(sugar, 140))!;
    expect(adjustment.kind, InventoryMoveKind.adjustment);
    expect(adjustment.quantity, -10.25);
    expect(await moves.stockOf(sugar.id), 140);

    expect(await moves.adjustTo(sugar, 140), isNull);
    expect(await readOutbox(db), hasLength(4));

    final up = (await moves.adjustTo(sugar, 145.5))!;
    expect(up.quantity, 5.5);
  });

  test('kalemi günceller (son yazan kazanır), stok değişmez', () async {
    final item = await createItem();
    await moves.add(item, InventoryMoveKind.stockIn, 40);
    clock.advance(const Duration(minutes: 5));

    final updated = await repository.update(
      item.copyWith(name: ' Temel petek 1 ', place: 'kamyonet', threshold: 50),
    );

    expect(updated.name, 'Temel petek 1');
    expect(updated.place, 'kamyonet');
    expect(updated.threshold, 50);
    expect(updated.createdAt, item.createdAt);
    expect(updated.updatedAt, DateTime.utc(2026, 10, 22, 9, 5));
    expect(await moves.stockOf(item.id), 40);
    await expectLater(
      repository.update(item.copyWith(id: 'missing')),
      throwsStateError,
    );
  });

  test(
    'silinen hareket stoktan düşer; silme yumuşak ve outbox’a gider',
    () async {
      final item = await createItem();
      await moves.add(item, InventoryMoveKind.stockIn, 40);
      final out = await moves.add(item, InventoryMoveKind.stockOut, 12);

      await moves.delete(out.id);

      expect(await moves.stockOf(item.id), 40);
      final row = await (db.select(
        db.inventoryMoves,
      )..where((t) => t.id.equals(out.id))).getSingle();
      expect(row.deletedAt, isNotNull);
      final outbox = await readOutbox(db);
      expect(outbox.last.operation, OutboxOperation.delete);
      expect(outbox.last.payload['quantity'], -12.0);
    },
  );

  test('outbox yazılamazsa kalem ve hareket de yazılmaz', () async {
    final item = await createItem();
    await breakOutbox();

    await expectLater(
      createItem(name: 'Kavanoz'),
      throwsA(isA<SqliteException>()),
    );
    await expectLater(
      moves.add(item, InventoryMoveKind.stockIn, 5),
      throwsA(isA<SqliteException>()),
    );
    await expectLater(moves.adjustTo(item, 3), throwsA(isA<SqliteException>()));

    expect(await db.select(db.inventoryItems).get(), hasLength(1));
    expect(await db.select(db.inventoryMoves).get(), isEmpty);
  });

  test('stoklar işletmeye göre; silinmiş kalem ve silinmiş hareket '
      'sayılmaz; hareket gelince akış yeniden yayar', () async {
    final item = await createItem();
    final other = await createItem(orgId: 'org-2', name: 'Başka');
    final gone = await createItem(name: 'Silinecek');
    await moves.add(other, InventoryMoveKind.stockIn, 7);
    await repository.delete(gone.id);

    final emitted = <List<InventoryStock>>[];
    final subscription = repository.watchStocks('org-1').listen(emitted.add);
    addTearDown(subscription.cancel);
    await pumpEventQueue();
    expect(emitted.last, [(item: item, quantity: 0.0)]);

    await moves.add(item, InventoryMoveKind.stockIn, 40);
    final out = await moves.add(item, InventoryMoveKind.stockOut, 12);
    await pumpEventQueue();
    expect(emitted.last.single.quantity, 28);

    await moves.delete(out.id);
    await pumpEventQueue();
    expect(emitted.last.single.quantity, 40);

    expect(await repository.watchStock(gone.id).first, isNull);
    expect((await repository.watchStock(other.id).first)!.quantity, 7);
  });

  test('kalemin hareketleri yeni önce', () async {
    final item = await createItem();
    final first = await moves.add(item, InventoryMoveKind.stockIn, 40);
    clock.advance(const Duration(hours: 1));
    final second = await moves.add(item, InventoryMoveKind.stockOut, 2);

    expect((await moves.watchByItem(item.id).first).map((m) => m.id), [
      second.id,
      first.id,
    ]);
  });
}
