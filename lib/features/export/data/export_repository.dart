import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/export/domain/export_data.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/inventory_rules.dart';

/// Dışa aktarma için işletmenin ana kayıtlarını yerel DB'den bir kerede
/// okur. Ağa gitmez; silinmiş kayıtlar alınmaz. Yalnız okur, outbox'a
/// yazmaz.
class ExportRepository {
  new(this.db);

  final AppDatabase db;

  /// [orgId]'nin kayıtları. [includeFinance] yanlışsa gelir/gider okunmaz.
  Future<ExportData> load(String orgId, {required bool includeFinance}) =>
      db.transaction(() async {
        final harvestHives = await _live(db.harvestHives, orgId);
        final items = await _live(db.inventoryItems, orgId);
        final moves = <String, List<InventoryMove>>{};
        for (final move in await _live(db.inventoryMoves, orgId)) {
          (moves[move.itemId] ??= []).add(move);
        }
        return ExportData(
          apiaries: await _live(db.apiaries, orgId),
          hives: await _live(db.hives, orgId),
          queens: await _live(db.queens, orgId),
          inspections: await _live(db.inspections, orgId),
          feedings: await _live(db.feedings, orgId),
          treatments: await _live(db.treatments, orgId),
          miteCounts: await _live(db.miteCounts, orgId),
          harvests: await _live(db.harvests, orgId),
          harvestHiveCounts: harvestHives.fold({}, (counts, row) {
            counts.update(row.harvestId, (n) => n + 1, ifAbsent: () => 1);
            return counts;
          }),
          tasks: await _live(db.tasks, orgId),
          inventory: [
            for (final item in items)
              (item: item, quantity: stockOf(moves[item.id] ?? const [])),
          ],
          transactions: includeFinance
              ? await _live(db.transactions, orgId)
              : null,
        );
      });

  /// [table]'ın [orgId]'ye ait silinmemiş satırları. Her senkronlanan
  /// işletme tablosunda `org_id` ve `deleted_at` var (`OrgColumns`,
  /// `SyncColumns`).
  Future<List<R>> _live<T extends Table, R>(
    TableInfo<T, R> table,
    String orgId,
  ) {
    final org = table.columnsByName['org_id']! as GeneratedColumn<String>;
    final deleted =
        table.columnsByName['deleted_at']! as GeneratedColumn<DateTime>;
    return (db.select(
      table,
    )..where((_) => org.equals(orgId) & deleted.isNull())).get();
  }
}
