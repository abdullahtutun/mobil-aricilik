import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';

/// `public.inventory_items` aynası; durum tablosu. Sunucudaki `numeric`
/// eşik burada gerçek sayı.
@UseRowClass(InventoryItem, generateInsertable: true)
@TableIndex(name: 'inventory_items_org_id_idx', columns: {#orgId})
class InventoryItems extends Table with SyncColumns, OrgColumns {
  TextColumn get name => text()();
  TextColumn get category =>
      text().map(const ServerEnumConverter(InventoryCategory.values))();
  TextColumn get unit =>
      text().map(const ServerEnumConverter(InventoryUnit.values))();
  TextColumn get place => text().nullable()();
  RealColumn get threshold => real().nullable()();
}

/// `public.inventory_moves` aynası; olay tablosu. Mevcut stok bu tablonun
/// toplamı.
@UseRowClass(InventoryMove, generateInsertable: true)
@TableIndex(name: 'inventory_moves_org_id_idx', columns: {#orgId})
@TableIndex(name: 'inventory_moves_item_id_idx', columns: {#itemId})
class InventoryMoves extends Table with SyncColumns, OrgColumns {
  TextColumn get itemId => text()();
  TextColumn get kind =>
      text().map(const ServerEnumConverter(InventoryMoveKind.values))();
  RealColumn get quantity => real()();
  DateTimeColumn get movedAt => dateTime()();
  TextColumn get linkedTable => text().nullable()();
  TextColumn get linkedId => text().nullable()();
}
