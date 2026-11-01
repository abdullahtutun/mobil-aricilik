import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/inventory_rules.dart';

final _at = DateTime.utc(2026, 11);

InventoryItem _item({
  String id = 'item-1',
  String name = 'Şeker',
  InventoryCategory category = InventoryCategory.consumable,
  double? threshold,
}) => InventoryItem(
  id: id,
  orgId: 'org-1',
  name: name,
  category: category,
  unit: InventoryUnit.kg,
  threshold: threshold,
  createdAt: _at,
  updatedAt: _at,
);

InventoryMove _move(double quantity, {DateTime? deletedAt}) => InventoryMove(
  id: 'move-$quantity',
  orgId: 'org-1',
  itemId: 'item-1',
  kind: quantity > 0 ? InventoryMoveKind.stockIn : InventoryMoveKind.stockOut,
  quantity: quantity,
  movedAt: _at,
  createdAt: _at,
  updatedAt: _at,
  deletedAt: deletedAt,
);

void main() {
  group('parseInventoryQuantity', () {
    test('virgül ve nokta ondalık; kg ve litrede üç haneye kadar', () {
      expect(parseInventoryQuantity('12', InventoryUnit.kg), 12);
      expect(parseInventoryQuantity(' 12,5 ', InventoryUnit.kg), 12.5);
      expect(parseInventoryQuantity('0.125', InventoryUnit.liter), 0.125);
      expect(parseInventoryQuantity('1,2345', InventoryUnit.kg), isNull);
    });

    test('adet, rulo ve pakette yalnız tam sayı', () {
      expect(parseInventoryQuantity('40', InventoryUnit.piece), 40);
      expect(parseInventoryQuantity('40,5', InventoryUnit.piece), isNull);
      expect(parseInventoryQuantity('3.0', InventoryUnit.roll), isNull);
      expect(parseInventoryQuantity('2', InventoryUnit.pack), 2);
    });

    test('boş, sıfır, eksi ve sınır dışı geçersiz; sayımda sıfır geçerli', () {
      expect(parseInventoryQuantity('', InventoryUnit.kg), isNull);
      expect(parseInventoryQuantity('0', InventoryUnit.kg), isNull);
      expect(parseInventoryQuantity('-3', InventoryUnit.kg), isNull);
      expect(parseInventoryQuantity('1000000', InventoryUnit.kg), isNull);
      expect(parseInventoryQuantity('999999', InventoryUnit.kg), 999999);
      expect(
        parseInventoryQuantity('0', InventoryUnit.piece, allowZero: true),
        0,
      );
    });
  });

  test('giriş pozitif, çıkış negatif; düzeltme bu yoldan yazılmaz', () {
    expect(signedMoveQuantity(InventoryMoveKind.stockIn, 12.5), 12.5);
    expect(signedMoveQuantity(InventoryMoveKind.stockOut, 12.5), -12.5);
    expect(
      () => signedMoveQuantity(InventoryMoveKind.adjustment, 1),
      throwsArgumentError,
    );
  });

  test('düzeltme sayılanla mevcut stok arasındaki fark; fark yoksa null', () {
    expect(adjustmentDelta(current: 40, counted: 35), -5);
    expect(adjustmentDelta(current: 0.3, counted: 0.6), 0.3);
    expect(adjustmentDelta(current: 12, counted: 12), isNull);
    expect(adjustmentDelta(current: -4, counted: 0), 4);
  });

  test('stok silinmemiş hareketlerin toplamı, üç ondalığa yuvarlı', () {
    expect(stockOf(const []), 0);
    expect(
      stockOf([
        _move(0.1),
        _move(0.2),
        _move(-0.05),
        _move(100, deletedAt: _at),
      ]),
      0.25,
    );
  });

  test('eşik altı yalnız eşikli kalemde ve eşikten azsa', () {
    expect(isBelowThreshold((item: _item(threshold: 100), quantity: 40)), true);
    expect(
      isBelowThreshold((item: _item(threshold: 100), quantity: 100)),
      false,
    );
    expect(isBelowThreshold((item: _item(), quantity: -5)), false);
  });

  test('çubuk eşiğin iki katında dolu, eşiksiz kalemde yok', () {
    expect(stockFill((item: _item(threshold: 100), quantity: 40)), 0.2);
    expect(stockFill((item: _item(threshold: 100), quantity: 500)), 1);
    expect(stockFill((item: _item(threshold: 100), quantity: -5)), 0);
    expect(stockFill((item: _item(), quantity: 150)), isNull);
  });

  test('sekmedeki kalemler: yalnız o kategori, ada göre doğal sıra', () {
    InventoryStock stock(String id, String name, InventoryCategory category) =>
        (item: _item(id: id, name: name, category: category), quantity: 0);

    final stocks = [
      stock('a', 'Kavanoz 850 g', InventoryCategory.consumable),
      stock('b', 'Körük', InventoryCategory.equipment),
      stock('c', 'Kavanoz 300 g', InventoryCategory.consumable),
      stock('d', 'Arı keki', InventoryCategory.consumable),
    ];

    expect(
      inventoryInCategory(
        stocks,
        InventoryCategory.consumable,
      ).map((s) => s.item.id),
      ['d', 'c', 'a'],
    );
    expect(inventoryInCategory(stocks, InventoryCategory.comb), isEmpty);
  });
}
