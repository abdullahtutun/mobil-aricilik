import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/shopping_rules.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

final _at = DateTime.utc(2026, 11);

InventoryStock _stock(
  String name,
  double quantity, {
  InventoryUnit unit = InventoryUnit.piece,
  double? threshold,
}) => (
  item: InventoryItem(
    id: name,
    orgId: 'org-1',
    name: name,
    category: InventoryCategory.consumable,
    unit: unit,
    threshold: threshold,
    createdAt: _at,
    updatedAt: _at,
  ),
  quantity: quantity,
);

TreatmentNeed _need(
  String drugKey,
  double amount, {
  DrugDoseUnit unit = DrugDoseUnit.strip,
}) => (
  drugKey: drugKey,
  drugName: 'İlaç $drugKey',
  doseUnit: unit,
  amount: amount,
);

Task _task(String id, {String? refDrugId, String? drugId, double? dose}) =>
    Task(
      id: id,
      orgId: 'org-1',
      title: id,
      dueAt: _at,
      apiaryId: 'apiary-1',
      refDrugId: refDrugId,
      drugId: drugId,
      dose: dose,
      createdAt: _at,
      updatedAt: _at,
    );

void main() {
  test('eşik altı kalem eşiğe tamamlanır; eşikte ya da eşiksiz kalem '
      'yok', () {
    final lines = shoppingList(
      stocks: [
        _stock('Temel petek', 40, threshold: 100),
        _stock('Kavanoz', 100, threshold: 100),
        _stock('Körük', 0),
        _stock('Şeker', 12.5, unit: InventoryUnit.kg, threshold: 50),
      ],
      needs: const [],
      itemByDrug: const {},
    );

    expect(
      [for (final line in lines) (line.name, line.quantity, line.planned)],
      [('Şeker', 37.5, 0.0), ('Temel petek', 60.0, 0.0)],
    );
  });

  test('ilacın ihtiyacı son düşülen kaleme eklenir; eşik görevden sonra da '
      'korunur', () {
    final lines = shoppingList(
      stocks: [
        _stock('Amitraz şerit', 12, threshold: 80),
        _stock('Oksalik', 0.5, unit: InventoryUnit.liter),
      ],
      needs: [
        _need('amitraz', 30),
        _need('amitraz', 10),
        _need('oxalic', 1000, unit: DrugDoseUnit.ml),
      ],
      itemByDrug: const {'amitraz': 'Amitraz şerit', 'oxalic': 'Oksalik'},
    );

    expect(
      [for (final line in lines) (line.name, line.quantity, line.planned)],
      [('Amitraz şerit', 108.0, 40.0), ('Oksalik', 0.5, 1.0)],
    );
  });

  test('stok yetiyorsa satır yok; kalemi olmayan ya da birimi uymayan ilaç '
      'doz biriminde kendi satırında', () {
    final lines = shoppingList(
      stocks: [
        _stock('Şerit', 200, threshold: 20),
        _stock('Şeker', 5, unit: InventoryUnit.kg),
      ],
      needs: [
        _need('a', 40),
        _need('b', 6, unit: DrugDoseUnit.dose),
        _need('c', 10),
      ],
      itemByDrug: const {'a': 'Şerit', 'c': 'Şeker'},
    );

    expect(
      [
        for (final line in lines)
          (line.name, line.quantity, line.stock, line.doseUnit),
      ],
      [
        ('İlaç b', 6.0, null, DrugDoseUnit.dose),
        ('İlaç c', 10.0, null, DrugDoseUnit.strip),
      ],
    );
  });

  test('planlı görevlerin ihtiyacı doz × kovan; listede olmayan ilaç ve '
      'kovansız arılık atlanır', () {
    const amitraz = DrugChoice(
      refDrugId: 'ref-1',
      name: 'Amitraz',
      activeIngredient: DrugActiveIngredient.amitraz,
      doseUnit: DrugDoseUnit.strip,
    );
    const thymol = DrugChoice(
      drugId: 'drug-1',
      name: 'Timol',
      activeIngredient: DrugActiveIngredient.thymol,
      doseUnit: DrugDoseUnit.g,
    );

    final needs = plannedTreatmentNeeds(
      [
        (task: _task('t1', refDrugId: 'ref-1', dose: 2), hives: 20),
        (task: _task('t2', drugId: 'drug-1', dose: 50), hives: 1),
        (task: _task('t3', refDrugId: 'ref-9', dose: 2), hives: 5),
        (task: _task('t4', refDrugId: 'ref-1', dose: 2), hives: 0),
        (task: _task('t5'), hives: 5),
      ],
      {'ref-1': amitraz, 'drug-1': thymol},
    );

    expect(needs, [
      (
        drugKey: 'ref-1',
        drugName: 'Amitraz',
        doseUnit: DrugDoseUnit.strip,
        amount: 40.0,
      ),
      (
        drugKey: 'drug-1',
        drugName: 'Timol',
        doseUnit: DrugDoseUnit.g,
        amount: 50.0,
      ),
    ]);
  });
}
