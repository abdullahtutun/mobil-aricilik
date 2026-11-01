import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';

/// Miktar üç ondalığa yuvarlanır (sunucudaki `numeric(12, 3)`); gerçek
/// sayı toplamındaki kayma (0,1 + 0,2) böyle silinir.
double roundQuantity(double value) => (value * 1000).roundToDouble() / 1000;

/// Kullanıcının yazdığı miktar ("12", "12,5", "12.5"); geçersizse null.
/// Ondalık yalnız [InventoryUnit.allowsFraction] birimlerde, en çok üç
/// hane. [allowZero] sayımda: stok sıfır sayılabilir. Sınır
/// [inventoryQuantityLimit]'in altı.
double? parseInventoryQuantity(
  String text,
  InventoryUnit unit, {
  bool allowZero = false,
}) {
  final match = _quantity.firstMatch(text.trim());
  if (match == null) return null;
  final fraction = match.group(2);
  if (fraction != null && !unit.allowsFraction) return null;
  final value = double.parse('${match.group(1)}.${fraction ?? '0'}');
  if (value < 0 || value >= inventoryQuantityLimit) return null;
  if (value == 0 && !allowZero) return null;
  return value;
}

final _quantity = RegExp(r'^([0-9]{1,6})(?:[.,]([0-9]{1,3}))?$');

/// Giriş ve çıkışın işaretli miktarı: giriş pozitif, çıkış negatif.
/// [amount] pozitif olmalı.
double signedMoveQuantity(InventoryMoveKind kind, double amount) {
  assert(amount > 0, 'miktar pozitif olmalı');
  return switch (kind) {
    InventoryMoveKind.stockIn => roundQuantity(amount),
    InventoryMoveKind.stockOut => -roundQuantity(amount),
    InventoryMoveKind.adjustment => throw ArgumentError.value(
      kind,
      'kind',
      'düzeltme sayımdan hesaplanır (adjustmentDelta)',
    ),
  };
}

/// Sayımla bulunan [counted] stokla [current] stok arasındaki düzeltme;
/// fark yoksa null (hareket yazılmaz).
double? adjustmentDelta({required double current, required double counted}) {
  final delta = roundQuantity(counted - current);
  return delta == 0 ? null : delta;
}

/// Hareketlerin toplamı: mevcut stok. Silinmiş hareketler sayılmaz.
double stockOf(Iterable<InventoryMove> moves) => roundQuantity(
  moves
      .where((move) => move.deletedAt == null)
      .fold(0, (sum, move) => sum + move.quantity),
);

/// Stok eşiğin altında mı; eşiksiz kalemde hiç değil.
bool isBelowThreshold(InventoryStock stock) => switch (stock.item.threshold) {
  final threshold? => stock.quantity < threshold,
  null => false,
};

/// Stok çubuğunun doluluğu (0–1): eşiğin iki katı dolu sayılır, eşik
/// yarısı. Eşiksiz kalemde çubuk yok (null).
double? stockFill(InventoryStock stock) => switch (stock.item.threshold) {
  final threshold? => (stock.quantity / (2 * threshold)).clamp(0, 1),
  null => null,
};

/// [category]'deki kalemler ada göre ([compareNatural]); aynı adda kimlik.
List<InventoryStock> inventoryInCategory(
  Iterable<InventoryStock> stocks,
  InventoryCategory category,
) =>
    [
      for (final stock in stocks)
        if (stock.item.category == category) stock,
    ]..sort((a, b) {
      final byName = compareNatural(a.item.name, b.item.name);
      return byName != 0 ? byName : a.item.id.compareTo(b.item.id);
    });
