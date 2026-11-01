import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/stock_usage_rules.dart';

final _at = DateTime.utc(2026, 11);

InventoryStock _stock(String id, InventoryUnit unit, {double quantity = 0}) => (
  item: InventoryItem(
    id: id,
    orgId: 'org-1',
    name: id,
    category: InventoryCategory.consumable,
    unit: unit,
    createdAt: _at,
    updatedAt: _at,
  ),
  quantity: quantity,
);

void main() {
  group('feedingStockUsage', () {
    test('şurup kilogramlık kalemden şeker, litrelikten şurup olarak', () {
      // 10 L 1:1 şurup = 12,3 kg; yarısı şeker.
      expect(
        feedingStockUsage(FeedingKind.syrup1to1, 10, InventoryUnit.kg),
        6.15,
      );
      expect(
        feedingStockUsage(FeedingKind.syrup2to1, 10, InventoryUnit.liter),
        10,
      );
    });

    test('kek ve polen kilogram; litrelik kalemle uymaz', () {
      expect(
        feedingStockUsage(FeedingKind.beeCake, 2.5, InventoryUnit.kg),
        2.5,
      );
      expect(
        feedingStockUsage(
          FeedingKind.pollenSubstitute,
          2.5,
          InventoryUnit.liter,
        ),
        isNull,
      );
    });

    test('adet, rulo ve pakette yukarı yuvarlanır; sıfır düşülmez', () {
      for (final unit in [
        InventoryUnit.piece,
        InventoryUnit.roll,
        InventoryUnit.pack,
      ]) {
        expect(feedingStockUsage(FeedingKind.beeCake, 2.2, unit), 3);
      }
      expect(
        feedingStockUsage(FeedingKind.beeCake, 0, InventoryUnit.kg),
        isNull,
      );
    });
  });

  group('treatmentStockUsage', () {
    test('şerit ve doz adet, rulo, pakette aynı sayı', () {
      expect(
        treatmentStockUsage(DrugDoseUnit.strip, 40, InventoryUnit.piece),
        40,
      );
      expect(
        treatmentStockUsage(DrugDoseUnit.dose, 12, InventoryUnit.pack),
        12,
      );
    });

    test('ml litreden, g kilogramdan binde biriyle', () {
      expect(
        treatmentStockUsage(DrugDoseUnit.ml, 250, InventoryUnit.liter),
        0.25,
      );
      expect(treatmentStockUsage(DrugDoseUnit.g, 1500, InventoryUnit.kg), 1.5);
    });

    test('uymayan birimler null', () {
      expect(
        treatmentStockUsage(DrugDoseUnit.strip, 4, InventoryUnit.kg),
        isNull,
      );
      expect(
        treatmentStockUsage(DrugDoseUnit.ml, 4, InventoryUnit.piece),
        isNull,
      );
      expect(
        treatmentStockUsage(DrugDoseUnit.g, 4, InventoryUnit.liter),
        isNull,
      );
    });
  });

  group('resolveStockItem', () {
    final sugar = _stock('sugar', InventoryUnit.kg);
    final strips = _stock('strips', InventoryUnit.piece);
    final stocks = [sugar, strips];
    double? kgOnly(InventoryUnit unit) => unit == InventoryUnit.kg ? 1 : null;

    test('seçilmediyse son kullanılan, seçildiyse o; "Düşme" null', () {
      expect(
        resolveStockItem(
          choice: defaultStockChoice,
          defaultItemId: 'sugar',
          stocks: stocks,
          usable: kgOnly,
        ),
        sugar,
      );
      expect(
        resolveStockItem(
          choice: (chosen: true, itemId: null),
          defaultItemId: 'sugar',
          stocks: stocks,
          usable: kgOnly,
        ),
        isNull,
      );
    });

    test('silinmiş ya da birimi uymayan kalem null', () {
      expect(
        resolveStockItem(
          choice: defaultStockChoice,
          defaultItemId: 'deleted',
          stocks: stocks,
          usable: kgOnly,
        ),
        isNull,
      );
      expect(
        resolveStockItem(
          choice: (chosen: true, itemId: 'strips'),
          defaultItemId: null,
          stocks: stocks,
          usable: kgOnly,
        ),
        isNull,
      );
    });

    test('usableStocks yalnız birimi uyanları verir', () {
      expect(usableStocks(stocks, kgOnly), [sugar]);
    });
  });
}
