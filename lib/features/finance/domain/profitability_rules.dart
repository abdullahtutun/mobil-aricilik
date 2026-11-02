import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';

/// Kovan başı maliyet: gider ÷ kovan, kuruşa yuvarlı; kovan yoksa null.
double? costPerHive(double expense, int hives) =>
    hives > 0 ? ((expense * 100).round() / hives).round() / 100 : null;

/// Lota bağlı bir hasat: hasadın arılığı ve kilogramı. Lotun geliri
/// hasatlarının arılıklarına kilogramla paylaştırılır.
typedef LotHarvestShare = ({String lotId, String apiaryId, double kg});

/// Konaklama noktasının (arılığın) sezon kârı; tutarlar kuruşa yuvarlı.
/// `costPerHive` arılığın gideri ÷ arılıktaki aktif kovan; kovan sayısı
/// bilinmiyorsa ya da sıfırsa null.
typedef ApiaryProfit = ({
  String apiaryId,
  double income,
  double expense,
  double net,
  double? costPerHive,
});

/// [year] yılında (takvim yılı) [currency] ile yazılmış hareketlerin
/// arılıklara göre kârı; büyük net önce, eşitse arılık kimliğiyle.
///
/// Gelir: lota bağlıysa lotun hasatlarının arılıklarına kilogramla
/// paylaştırılır ([lotHarvests]); lotun hasadı yoksa ya da lot yoksa
/// harekete bağlı arılığa yazılır. Gider: harekete bağlı arılığa, yoksa
/// bağlı taşımanın varış arılığına ([transportDestinations]) yazılır.
/// Hiçbir arılığa bağlanamayan hareket rapora girmez. Geliri ve gideri
/// olmayan arılık listede yok.
///
/// Paylaştırma kuruşla yapılır; küsurat en büyük paya gider, toplam
/// korunur.
List<ApiaryProfit> apiaryProfits(
  Iterable<FinanceTransaction> transactions, {
  required int year,
  required String currency,
  Iterable<LotHarvestShare> lotHarvests = const [],
  Map<String, String> transportDestinations = const {},
  Map<String, int> activeHives = const {},
}) {
  final sharesByLot = <String, Map<String, double>>{};
  for (final share in lotHarvests) {
    if (share.kg <= 0) continue;
    final shares = sharesByLot.putIfAbsent(share.lotId, () => {});
    shares[share.apiaryId] = (shares[share.apiaryId] ?? 0) + share.kg;
  }

  final income = <String, int>{};
  final expense = <String, int>{};
  void add(Map<String, int> into, String apiaryId, int cents) =>
      into[apiaryId] = (into[apiaryId] ?? 0) + cents;

  for (final transaction in transactions) {
    if (transaction.occurredOn.year != year ||
        transaction.currency != currency) {
      continue;
    }
    final cents = (transaction.amount * 100).round();
    switch (transaction.kind) {
      case TransactionKind.income:
        final shares = sharesByLot[transaction.lotId];
        if (shares != null) {
          _split(cents, shares).forEach((id, part) => add(income, id, part));
        } else if (transaction.apiaryId case final id?) {
          add(income, id, cents);
        }
      case TransactionKind.expense:
        final id =
            transaction.apiaryId ??
            transportDestinations[transaction.transportId];
        if (id != null) add(expense, id, cents);
    }
  }

  return [
    for (final id in {...income.keys, ...expense.keys})
      (
        apiaryId: id,
        income: (income[id] ?? 0) / 100,
        expense: (expense[id] ?? 0) / 100,
        net: ((income[id] ?? 0) - (expense[id] ?? 0)) / 100,
        costPerHive: costPerHive(
          (expense[id] ?? 0) / 100,
          activeHives[id] ?? 0,
        ),
      ),
  ]..sort((a, b) {
    final byNet = b.net.compareTo(a.net);
    return byNet != 0 ? byNet : a.apiaryId.compareTo(b.apiaryId);
  });
}

/// [cents]'i [weights] oranında böler; aşağı yuvarlananların küsuratı en
/// büyük ağırlığa eklenir.
Map<String, int> _split(int cents, Map<String, double> weights) {
  final total = weights.values.fold<double>(0, (sum, w) => sum + w);
  final parts = {
    for (final entry in weights.entries)
      entry.key: (cents * entry.value / total).floor(),
  };
  final rest = cents - parts.values.fold<int>(0, (sum, p) => sum + p);
  if (rest != 0) {
    final largest = weights.entries
        .reduce((a, b) => b.value > a.value ? b : a)
        .key;
    parts[largest] = parts[largest]! + rest;
  }
  return parts;
}
