import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/inventory_rules.dart';
import 'package:mobil_arici/features/inventory/domain/stock_usage_rules.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

/// Açık planlı ilaçlama görevlerinin bir ilaç için toplam ihtiyacı, doz
/// biriminde (kovan başı doz × kovan).
typedef TreatmentNeed = ({
  String drugKey,
  String drugName,
  DrugDoseUnit doseUnit,
  double amount,
});

/// Alışveriş listesinin bir satırı. `stock` doluysa kalem: alınacak
/// `quantity` ve görevlerin ihtiyacı `planned` kalemin biriminde. Boşsa
/// kaleme bağlanmamış ilaç ihtiyacı: ikisi de `doseUnit` biriminde.
typedef ShoppingLine = ({
  String name,
  double quantity,
  double planned,
  InventoryStock? stock,
  DrugDoseUnit? doseUnit,
});

/// Kovan başı [dose] ile [hives] kovanın ihtiyacı, doz biriminde.
double treatmentNeedAmount(double dose, int hives) =>
    roundQuantity(dose * hives);

/// Açık planlı ilaçlama görevlerinin ihtiyaçları: ilaç [drugs] içinden
/// (anahtar referans ya da işletmenin ilacının kimliği) bulunur; listede
/// olmayan ilacın ya da kovansız arılığın görevi atlanır.
List<TreatmentNeed> plannedTreatmentNeeds(
  Iterable<({Task task, int hives})> planned,
  Map<String, DrugChoice> drugs,
) => [
  for (final (:task, :hives) in planned)
    if ((task.plannedDrugKey, task.dose) case (final key?, final dose?)
        when hives > 0)
      if (drugs[key] case final drug?)
        (
          drugKey: key,
          drugName: drug.name,
          doseUnit: drug.doseUnit,
          amount: treatmentNeedAmount(dose, hives),
        ),
];

/// Aynı ilacın ihtiyaçlarını toplar; ilk görünen ad kalır.
List<TreatmentNeed> mergeTreatmentNeeds(Iterable<TreatmentNeed> needs) {
  final merged = <String, TreatmentNeed>{};
  for (final need in needs) {
    final previous = merged[need.drugKey];
    merged[need.drugKey] = previous == null
        ? need
        : (
            drugKey: previous.drugKey,
            drugName: previous.drugName,
            doseUnit: previous.doseUnit,
            amount: roundQuantity(previous.amount + need.amount),
          );
  }
  return [...merged.values];
}

/// Alışveriş listesi: eşiği olan kalemlerde stoğu, görevlerin ihtiyacı
/// düşüldükten sonra eşiğe tamamlayan miktar; eşiksiz kalemde görevlerin
/// ihtiyacından eksik kalan. İlacın ihtiyacı, o ilacın son düşüldüğü
/// kaleme ([itemByDrug]) birimi uyuyorsa ([treatmentStockUsage]) eklenir;
/// kalem yoksa ya da birimi uymuyorsa ilaç kendi satırında, doz biriminde
/// görünür. Alınacak bir şey yoksa satır yok. Ada göre sıralı
/// ([compareNatural]).
List<ShoppingLine> shoppingList({
  required Iterable<InventoryStock> stocks,
  required Iterable<TreatmentNeed> needs,
  required Map<String, String> itemByDrug,
}) {
  final byId = {for (final stock in stocks) stock.item.id: stock};
  final plannedByItem = <String, double>{};
  final unmatched = <TreatmentNeed>[];
  for (final need in mergeTreatmentNeeds(needs)) {
    final stock = byId[itemByDrug[need.drugKey]];
    final usage = stock == null
        ? null
        : treatmentStockUsage(need.doseUnit, need.amount, stock.item.unit);
    if (stock == null || usage == null) {
      unmatched.add(need);
      continue;
    }
    final id = stock.item.id;
    plannedByItem[id] = roundQuantity((plannedByItem[id] ?? 0) + usage);
  }

  final lines = <ShoppingLine>[
    for (final stock in byId.values)
      if (_toBuy(stock, plannedByItem[stock.item.id] ?? 0) case final quantity?)
        (
          name: stock.item.name,
          quantity: quantity,
          planned: plannedByItem[stock.item.id] ?? 0,
          stock: stock,
          doseUnit: null,
        ),
    for (final need in unmatched)
      (
        name: need.drugName,
        quantity: need.amount,
        planned: need.amount,
        stock: null,
        doseUnit: need.doseUnit,
      ),
  ];
  return lines..sort((a, b) => compareNatural(a.name, b.name));
}

/// Kalemden alınacak: (eşik + görevlerin ihtiyacı) − stok; tam sayı
/// birimde yukarı yuvarlanır. Eşik de ihtiyaç da yoksa ya da eksik yoksa
/// null.
double? _toBuy(InventoryStock stock, double planned) {
  final threshold = stock.item.threshold;
  if (threshold == null && planned == 0) return null;
  final missing = roundQuantity((threshold ?? 0) + planned - stock.quantity);
  if (missing <= 0) return null;
  return stock.item.unit.allowsFraction ? missing : missing.ceilToDouble();
}
