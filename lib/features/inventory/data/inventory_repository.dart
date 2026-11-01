import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/inventory_rules.dart';

/// Stok kalemleri; durum kaydı, son yazan kazanır. Hareketleri [moves].
/// Mevcut stok saklanmaz: silinmemiş hareketlerin toplamı, okurken
/// hesaplanır; iki telefonun hareketleri çakışmadan toplanır.
class InventoryRepository
    extends BaseRepository<$InventoryItemsTable, InventoryItem> {
  new(super.db, {super.clock});

  @override
  $InventoryItemsTable get table => db.inventoryItems;

  @override
  Insertable<InventoryItem> toInsertable(InventoryItem record) =>
      record.toInsertable();

  /// Kalemlerin hareketleri; aynı veritabanı ve saat.
  late final moves = InventoryMoveRepository(db, clock: clock);

  /// İşletmenin kalemleri ve mevcut stokları; kalem ya da hareket
  /// değişince yeniden yayar. Sıra ekranın ([inventoryInCategory]).
  Stream<List<InventoryStock>> watchStocks(String orgId) =>
      _watchStocks(db.inventoryItems.orgId.equals(orgId));

  /// Kalem ve mevcut stoğu; yoksa ya da silinmişse null.
  Stream<InventoryStock?> watchStock(String id) =>
      _watchStocks(db.inventoryItems.id.equals(id))
          .map((stocks) => stocks.singleOrNull);

  Stream<List<InventoryStock>> _watchStocks(Expression<bool> filter) {
    final items = db.inventoryItems;
    final moves = db.inventoryMoves;
    final total = moves.quantity.sum();
    final query =
        db.select(items).join([
            leftOuterJoin(
              moves,
              moves.itemId.equalsExp(items.id) & moves.deletedAt.isNull(),
              useColumns: false,
            ),
          ])
          ..addColumns([total])
          ..where(items.deletedAt.isNull() & filter)
          ..groupBy([items.id]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            item: row.readTable(items),
            quantity: roundQuantity(row.read(total) ?? 0),
          ),
      ],
    );
  }

  /// Yeni kalem; stoğu sıfır. Alanlar geçersizse ([checkInventoryItem])
  /// [ArgumentError] atar ve bir şey yazmaz.
  Future<InventoryItem> create({
    required String orgId,
    required String name,
    required InventoryCategory category,
    required InventoryUnit unit,
    String? place,
    double? threshold,
  }) async {
    final at = now();
    return await insertRecord(
      checkInventoryItem(
        InventoryItem(
          id: generateId(),
          orgId: orgId,
          name: name,
          category: category,
          unit: unit,
          place: place,
          threshold: threshold,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
  }

  /// Kalemin alanlarını yazar (son yazan kazanır). Kalem yoksa ya da
  /// silinmişse [StateError], alanlar geçersizse [ArgumentError] atar.
  Future<InventoryItem> update(InventoryItem item) =>
      updateRecord(checkInventoryItem(item));
}

/// Stok hareketleri; olay kaydı: yalnız eklenir, güncelleme yok, yanlış
/// kayıt silinir (Geri al da silmedir).
class InventoryMoveRepository
    extends BaseRepository<$InventoryMovesTable, InventoryMove> {
  new(super.db, {super.clock});

  @override
  $InventoryMovesTable get table => db.inventoryMoves;

  @override
  Insertable<InventoryMove> toInsertable(InventoryMove record) =>
      record.toInsertable();

  /// Kalemin hareketleri, yeni önce.
  Stream<List<InventoryMove>> watchByItem(String itemId) => watchWhere(
    (t) => t.itemId.equals(itemId),
    orderBy: [
      (t) => OrderingTerm.desc(t.movedAt),
      (t) => OrderingTerm.desc(t.id),
    ],
  );

  /// Kalemin mevcut stoğu: silinmemiş hareketlerin toplamı.
  Future<double> stockOf(String itemId) async {
    final total = table.quantity.sum();
    final row =
        await (db.selectOnly(table)
              ..addColumns([total])
              ..where(table.itemId.equals(itemId) & table.deletedAt.isNull()))
            .getSingle();
    return roundQuantity(row.read(total) ?? 0);
  }

  /// [item]'a giriş ya da çıkış yazar; [amount] pozitif, işareti türden
  /// gelir. [linkedTable] ve [linkedId] hareketin bağlı olduğu kayıt;
  /// ikisi birlikte verilir. Miktar geçersizse ([checkMoveAmount]) ya da
  /// bağ yarımsa [ArgumentError] atar ve bir şey yazmaz.
  Future<InventoryMove> add(
    InventoryItem item,
    InventoryMoveKind kind,
    double amount, {
    String? linkedTable,
    String? linkedId,
  }) async {
    if (kind == InventoryMoveKind.adjustment) {
      throw ArgumentError.value(kind, 'kind', 'düzeltme adjustTo ile yazılır');
    }
    checkMoveAmount(amount, item.unit);
    if ((linkedTable == null) != (linkedId == null)) {
      throw ArgumentError.value(linkedTable, 'linkedTable');
    }
    return await _insert(
      item,
      kind,
      signedMoveQuantity(kind, amount),
      linkedTable: linkedTable,
      linkedId: linkedId,
    );
  }

  /// Sayım: [item]'ın stoğu [counted] bulundu. Farkı düzeltme olarak
  /// yazar; stok okuma ve yazma tek transaction'da. Fark yoksa bir şey
  /// yazmaz, null döner. [counted] negatifse, sınırı aşıyorsa ya da birim
  /// tam sayı isterken ondalıklıysa [ArgumentError] atar.
  Future<InventoryMove?> adjustTo(InventoryItem item, double counted) async {
    if (counted != 0) checkMoveAmount(counted, item.unit);
    return await db.transaction(() async {
      final delta = adjustmentDelta(
        current: await stockOf(item.id),
        counted: counted,
      );
      if (delta == null) return null;
      if (delta.abs() >= inventoryQuantityLimit) {
        throw ArgumentError.value(counted, 'counted');
      }
      return await _insert(item, InventoryMoveKind.adjustment, delta);
    });
  }

  /// [linkedTable] tablosundaki [linkedIds] kayıtlarına bağlı hareketleri
  /// siler (kaydın Geri al'ı). Çağıranın transaction'ında çalışır.
  Future<void> deleteLinked(String linkedTable, Iterable<String> linkedIds) =>
      db.transaction(() async {
        final linked = await selectWhere(
          (t) => t.linkedTable.equals(linkedTable) & t.linkedId.isIn(linkedIds),
        ).get();
        for (final move in linked) {
          await delete(move.id);
        }
      });

  /// İşletmede besleme türüne göre son düşülen kalem: beslemeye bağlı en
  /// son silinmemiş hareketin kalemi. Silinmiş kalem sayılmaz. Hareket,
  /// besleme ya da kalem değişince yeniden yayar.
  Stream<Map<FeedingKind, String>> watchLastFeedingItems(String orgId) {
    final feedings = db.feedings;
    return _watchLastLinked(orgId, feedings, feedings.id, feedings.kind).map(
      (rows) => {
        for (final (kind, itemId) in rows.reversed)
          feedings.kind.converter.fromSql(kind): itemId,
      },
    );
  }

  /// İşletmede ilaca göre (referans ya da işletmenin ilacının kimliği) son
  /// düşülen kalem: uygulamaya bağlı en son silinmemiş hareketin kalemi.
  Stream<Map<String, String>> watchLastTreatmentItems(String orgId) {
    final treatments = db.treatments;
    return _watchLastLinked(
      orgId,
      treatments,
      treatments.id,
      coalesce<String>([treatments.refDrugId, treatments.drugId]),
    ).map(
      (rows) => {
        for (final (drugKey, itemId) in rows.reversed) drugKey: itemId,
      },
    );
  }

  /// [linked] tablosuna bağlı silinmemiş hareketlerin ([key], kalem)
  /// çiftleri, yeni önce; kalem ya da bağlı kayıt silinmişse yok.
  Stream<List<(String, String)>> _watchLastLinked(
    String orgId,
    TableInfo<Table, Object?> linked,
    Expression<String> linkedId,
    Expression<String> key,
  ) {
    final items = db.inventoryItems;
    final linkedDeletedAt = linked.columnsByName['deleted_at']!;
    final query =
        db.selectOnly(table).join([
            innerJoin(
              linked,
              linkedId.equalsExp(table.linkedId) & linkedDeletedAt.isNull(),
              useColumns: false,
            ),
            innerJoin(
              items,
              items.id.equalsExp(table.itemId) & items.deletedAt.isNull(),
              useColumns: false,
            ),
          ])
          ..addColumns([key, table.itemId])
          ..where(
            table.orgId.equals(orgId) &
                table.deletedAt.isNull() &
                table.linkedTable.equals(linked.actualTableName),
          )
          ..orderBy([
            OrderingTerm.desc(table.movedAt),
            OrderingTerm.desc(table.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          if (row.read(key) case final value?) (value, row.read(table.itemId)!),
      ],
    );
  }

  Future<InventoryMove> _insert(
    InventoryItem item,
    InventoryMoveKind kind,
    double quantity, {
    String? linkedTable,
    String? linkedId,
  }) {
    final at = now();
    return insertRecord(
      InventoryMove(
        id: generateId(),
        orgId: item.orgId,
        itemId: item.id,
        kind: kind,
        quantity: quantity,
        movedAt: at,
        linkedTable: linkedTable,
        linkedId: linkedId,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}

/// Kalemi yazılacak hâline getirir: ad ve konumun baştaki ve sondaki
/// boşlukları atılır, boş konum null olur, eşik üç ondalığa yuvarlanır. Ad
/// boşsa ya da uzunsa, konum uzunsa, eşik pozitif değilse ya da sınırı
/// aşıyorsa [ArgumentError] atar.
InventoryItem checkInventoryItem(InventoryItem item) {
  final name = item.name.trim();
  if (name.isEmpty || name.length > maxInventoryNameLength) {
    throw ArgumentError.value(item.name, 'name');
  }
  final place = item.place?.trim();
  if (place != null && place.length > maxInventoryPlaceLength) {
    throw ArgumentError.value(item.place, 'place');
  }
  final threshold = switch (item.threshold) {
    final value? => roundQuantity(value),
    null => null,
  };
  if (threshold != null &&
      !(threshold > 0 && threshold < inventoryQuantityLimit)) {
    throw ArgumentError.value(item.threshold, 'threshold');
  }
  return item.copyWith(
    name: name,
    place: place == null || place.isEmpty ? null : place,
    threshold: threshold,
  );
}

/// Hareket miktarı pozitif, [inventoryQuantityLimit]'in altında ve birim
/// tam sayı istiyorsa tam sayı olmalı; değilse [ArgumentError] atar.
void checkMoveAmount(double amount, InventoryUnit unit) {
  if (!(amount > 0 && amount < inventoryQuantityLimit) ||
      (!unit.allowsFraction && amount != amount.roundToDouble())) {
    throw ArgumentError.value(amount, 'amount');
  }
}
