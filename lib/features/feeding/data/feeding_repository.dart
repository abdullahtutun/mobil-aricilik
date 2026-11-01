import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inventory/data/inventory_repository.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/stock_usage_rules.dart';

/// Beslemeler; olay kaydı: yalnız eklenir, güncelleme yok, yanlış kayıt
/// silinir (Geri al da silmedir). Bir kayıtta yazılan beslemeler ortak
/// `feeding_group_id` taşır; toplu besleme hepsini ya da hiçbirini yazar.
/// Stok kalemi verilirse kullanılan miktar ([feedingStockUsage]) aynı
/// transaction'da kalemden çıkış olarak yazılır ve grubun ilk beslemesine
/// bağlanır; Geri al onu da siler.
class FeedingRepository extends BaseRepository<$FeedingsTable, Feeding> {
  new(super.db, {super.clock});

  late final _inspections = InspectionRepository(db, clock: clock);
  late final _moves = InventoryMoveRepository(db, clock: clock);

  @override
  $FeedingsTable get table => db.feedings;

  @override
  Insertable<Feeding> toInsertable(Feeding record) => record.toInsertable();

  /// [plan]'ı [hive]'a, kovanın şimdiki arılığında yazar. Bal katı uyarısı
  /// ekranın; tek kovanda kayıt yine yazılır. [stockItem] verilirse
  /// kullanılan miktar ondan düşülür.
  Future<Feeding> addToHive(
    Hive hive,
    FeedingPlan plan, {
    InventoryItem? stockItem,
  }) async => (await _addAll([hive], plan, stockItem: stockItem)).single;

  /// [plan]'ı [apiaryId] arılığındaki aktif kovanlara tek transaction'da
  /// yazar ve kovan numarası sırasıyla döner. Şurupta bal katı olan kovanlar
  /// atlanır ([feedingTargets]); bal katı aynı transaction'da muayenelerden
  /// okunur. Beslenecek kovan yoksa bir şey yazmaz, boş döner.
  /// [stockItem] verilirse beslenen kovanların toplamı ondan düşülür.
  Future<List<Feeding>> addToApiary(
    String apiaryId,
    FeedingPlan plan, {
    InventoryItem? stockItem,
  }) => db.transaction(() async {
    final hives =
        await (db.select(db.hives)
              ..where(
                (t) =>
                    t.apiaryId.equals(apiaryId) &
                    t.deletedAt.isNull() &
                    t.status.equalsValue(HiveStatus.active),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.number)]))
            .get();
    final supers = honeySuperHiveIds(
      await _inspections.findSuperChangesByApiary(apiaryId),
    );
    return await _addAll(
      feedingTargets(hives, supers, plan.kind).fed,
      plan,
      stockItem: stockItem,
    );
  });

  /// Geri al: [feedings]'i ve bağlı stok çıkışını tek transaction'da
  /// siler.
  Future<void> deleteAll(Iterable<Feeding> feedings) =>
      db.transaction(() async {
        for (final feeding in feedings) {
          await delete(feeding.id);
        }
        await _moves.deleteLinked(table.actualTableName, [
          for (final feeding in feedings) feeding.id,
        ]);
      });

  /// Miktar sunucunun kısıtına uymazsa ya da kalemin birimi uymazsa
  /// [ArgumentError] atar ve bir şey yazmaz.
  Future<List<Feeding>> _addAll(
    List<Hive> hives,
    FeedingPlan plan, {
    InventoryItem? stockItem,
  }) {
    if (!(plan.amount > 0 && plan.amount <= maxStoredFeedingAmount)) {
      throw ArgumentError.value(plan.amount, 'amount');
    }
    final groupId = generateId();
    return db.transaction(() async {
      final at = now();
      final feedings = [
        for (final hive in hives)
          await insertRecord(
            Feeding(
              id: generateId(),
              orgId: hive.orgId,
              hiveId: hive.id,
              apiaryId: hive.apiaryId,
              feedingGroupId: groupId,
              fedAt: plan.fedAt.toUtc(),
              kind: plan.kind,
              amount: plan.amount,
              createdAt: at,
              updatedAt: at,
            ),
          ),
      ];
      if (stockItem != null && feedings.isNotEmpty) {
        final usage = feedingStockUsage(
          plan.kind,
          plan.amount * feedings.length,
          stockItem.unit,
        );
        if (usage == null) {
          throw ArgumentError.value(stockItem.unit, 'stockItem.unit');
        }
        await _moves.add(
          stockItem,
          InventoryMoveKind.stockOut,
          usage,
          linkedTable: table.actualTableName,
          linkedId: feedings.first.id,
        );
      }
      return feedings;
    });
  }
}
