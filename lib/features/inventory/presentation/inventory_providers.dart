import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/inventory/data/inventory_repository.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/shopping_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inventory_providers.g.dart';

@Riverpod(keepAlive: true)
InventoryRepository inventoryRepository(Ref ref) =>
    InventoryRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin kalemleri ve stokları; işletme yoksa boş.
@riverpod
Stream<List<InventoryStock>> inventoryStocks(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(inventoryRepositoryProvider).watchStocks(orgId);
}

/// Kalem ve stoğu; yoksa ya da silinmişse null.
@riverpod
Stream<InventoryStock?> inventoryStock(Ref ref, String id) =>
    ref.watch(inventoryRepositoryProvider).watchStock(id);

/// Kalemin hareketleri, yeni önce.
@riverpod
Stream<List<InventoryMove>> inventoryMoves(Ref ref, String itemId) =>
    ref.watch(inventoryRepositoryProvider).moves.watchByItem(itemId);

/// Besleme türüne göre son düşülen kalem (formdaki varsayılan); işletme
/// yoksa boş.
@riverpod
Stream<Map<FeedingKind, String>> lastFeedingStockItems(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const {});
  return ref
      .watch(inventoryRepositoryProvider)
      .moves
      .watchLastFeedingItems(orgId);
}

/// İlaca göre son düşülen kalem (formdaki varsayılan, alışveriş listesinde
/// ilacın kalemi); işletme yoksa boş.
@riverpod
Stream<Map<String, String>> lastTreatmentStockItems(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const {});
  return ref
      .watch(inventoryRepositoryProvider)
      .moves
      .watchLastTreatmentItems(orgId);
}

/// Alışveriş listesi ([shoppingList]): eşik altı kalemler ve açık planlı
/// ilaçlama görevlerinin ihtiyacı; ilaç adları [languageCode] dilinde.
@riverpod
Future<List<ShoppingLine>> shoppingListOf(Ref ref, String languageCode) async {
  final stocks = await ref.watch(inventoryStocksProvider.future);
  final planned = await ref.watch(openPlannedTreatmentsProvider.future);
  final itemByDrug = await ref.watch(lastTreatmentStockItemsProvider.future);
  final catalog = planned.isEmpty
      ? const <DrugChoice>[]
      : await ref.watch(drugCatalogOfProvider(languageCode).future);
  return shoppingList(
    stocks: stocks,
    needs: plannedTreatmentNeeds(planned, {
      for (final drug in catalog) ?(drug.refDrugId ?? drug.drugId): drug,
    }),
    itemByDrug: itemByDrug,
  );
}

/// Stok hareketleri ve kalem silme. Bildirimin Geri al'ı sayfa kapandıktan
/// sonra da çalışsın diye sürekli yaşar.
@Riverpod(keepAlive: true)
class InventoryActions extends _$InventoryActions {
  @override
  void build() {}

  /// Giriş ya da çıkış; [amount] pozitif.
  Future<InventoryMove> move(
    InventoryItem item,
    InventoryMoveKind kind,
    double amount,
  ) => ref.read(inventoryRepositoryProvider).moves.add(item, kind, amount);

  /// Sayım: stok [counted] olur; fark yoksa null.
  Future<InventoryMove?> count(InventoryItem item, double counted) =>
      ref.read(inventoryRepositoryProvider).moves.adjustTo(item, counted);

  /// Geri al: hareket silinir.
  Future<void> undoMove(InventoryMove move) =>
      ref.read(inventoryRepositoryProvider).moves.delete(move.id);

  Future<void> deleteItem(String id) =>
      ref.read(inventoryRepositoryProvider).delete(id);
}
