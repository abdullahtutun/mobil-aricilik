import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/inventory_rules.dart';

/// Stoktan düşen kaydın kalem seçimi: kullanıcı seçtiyse o (boşsa
/// "Düşme"), seçmediyse varsayılan.
typedef StockChoice = ({bool chosen, String? itemId});

/// Kalemin biriminde düşülecek miktar; birim uymuyorsa null.
typedef StockUsage = double? Function(InventoryUnit unit);

/// Seçilmemiş kalem: varsayılan kullanılır.
const StockChoice defaultStockChoice = (chosen: false, itemId: null);

/// Beslemede kalemden düşülecek miktar, kalemin biriminde. [total]
/// kayıttaki toplam: şurupta litre, değilse kilogram (kovan başı miktar ×
/// beslenen kovan). Şurup kilogramlık kalemden (şeker) tarifteki şeker
/// olarak, litrelik kalemden şurup olarak düşer; kek ve polen ikamesi
/// kilogramlık kalemden kilogram olarak. Adet, rulo ve pakette toplam
/// yukarı yuvarlanır (ör. 1 kg'lık kek paketi). Birim uymuyorsa ya da
/// miktar sıfırsa null.
double? feedingStockUsage(FeedingKind kind, double total, InventoryUnit unit) {
  final value = switch ((kind.isSyrup, unit)) {
    (true, InventoryUnit.kg) => syrupRecipe(kind, total)?.sugarKg,
    (true, InventoryUnit.liter) => total,
    (false, InventoryUnit.kg) => total,
    (false, InventoryUnit.liter) => null,
    (_, InventoryUnit.piece || InventoryUnit.roll || InventoryUnit.pack) =>
      total,
  };
  return value == null ? null : _fit(value, unit);
}

/// İlaçta kalemden düşülecek miktar, kalemin biriminde. [total] doz
/// biriminde toplam (kovan başı doz × kovan). Şerit ve doz adet, rulo ya
/// da paketten aynı sayıyla; ml litreden, g kilogramdan binde biriyle
/// düşer. Birim uymuyorsa ya da miktar sıfırsa null.
double? treatmentStockUsage(
  DrugDoseUnit doseUnit,
  double total,
  InventoryUnit unit,
) {
  final value = switch ((doseUnit, unit)) {
    (
      DrugDoseUnit.strip || DrugDoseUnit.dose,
      InventoryUnit.piece || InventoryUnit.roll || InventoryUnit.pack,
    ) =>
      total,
    (DrugDoseUnit.ml, InventoryUnit.liter) => total / 1000,
    (DrugDoseUnit.g, InventoryUnit.kg) => total / 1000,
    _ => null,
  };
  return value == null ? null : _fit(value, unit);
}

/// Kalemin birimine uydurur: ondalıklı birimde üç ondalık, değilse yukarı
/// tam sayı. Sıfır ya da eksiyse null.
double? _fit(double value, InventoryUnit unit) {
  final fitted = unit.allowsFraction
      ? roundQuantity(value)
      : roundQuantity(value).ceilToDouble();
  return fitted > 0 ? fitted : null;
}

/// Kaydın düşüleceği kalem: kullanıcı seçtiyse o, seçmediyse son
/// kullanılan ([defaultItemId]). Kalem [stocks] içinde yoksa (silinmiş)
/// ya da birimi uymuyorsa ([usable] null döner) null; "Düşme" de null.
InventoryStock? resolveStockItem({
  required StockChoice choice,
  required String? defaultItemId,
  required Iterable<InventoryStock> stocks,
  required StockUsage usable,
}) {
  final id = choice.chosen ? choice.itemId : defaultItemId;
  if (id == null) return null;
  for (final stock in stocks) {
    if (stock.item.id == id) {
      return usable(stock.item.unit) == null ? null : stock;
    }
  }
  return null;
}

/// Seçim sayfasındaki kalemler: birimi uyanlar ([usable] null değil),
/// [inventoryInCategory] sırasıyla, kategori sırası korunur.
List<InventoryStock> usableStocks(
  Iterable<InventoryStock> stocks,
  StockUsage usable,
) => [
  for (final category in InventoryCategory.values)
    for (final stock in inventoryInCategory(stocks, category))
      if (usable(stock.item.unit) != null) stock,
];
