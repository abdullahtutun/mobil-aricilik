import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';

/// `receipts` bucket'ındaki yol: `org_id/hareket_id/dosya_id.jpg`. Sunucu
/// aynı kuralı CHECK ile denetler.
String receiptStoragePath({
  required String orgId,
  required String transactionId,
  required String fileId,
}) => '$orgId/$transactionId/$fileId.jpg';

/// Fiş dosyasının bu telefondaki adı: yolun son parçası.
String receiptFileName(String storagePath) => storagePath.split('/').last;

/// Kullanıcının yazdığı tutar: rakamlar, binlik ayracı olarak nokta ya da
/// boşluk ve en çok iki haneli kuruş (virgül; tek ayraç varsa nokta da
/// olur). Sıfır, boş, bozuk ya da [maxTransactionAmount]'tan büyükse null.
///
/// "17.500" on yedi bin beş yüz, "17,5" ve "17.50" on yedi buçuk.
double? parseAmount(String text) {
  final trimmed = text.trim().replaceAll(' ', '');
  final match = RegExp(
    r'^([0-9]{1,3}(?:\.[0-9]{3})+|[0-9]+)(?:[.,]([0-9]{1,2}))?$',
  ).firstMatch(trimmed);
  if (match == null) return null;
  final whole = match.group(1)!.replaceAll('.', '');
  final value = double.parse('$whole.${match.group(2) ?? '0'}');
  return value > 0 && value <= maxTransactionAmount ? value : null;
}

/// Hareketi yazılacak hâline getirir: tutar iki ondalığa yuvarlanır,
/// açıklamanın baştaki ve sondaki boşlukları atılır, boş açıklama null
/// olur, gün saatsiz olur. Tutar aralık dışındaysa, kategori türe
/// uymuyorsa, açıklama uzunsa, satış bağı lotlu gelirde değilse ya da
/// müşteri gelirde değilse [ArgumentError] atar.
FinanceTransaction checkTransaction(FinanceTransaction transaction) {
  final amount = (transaction.amount * 100).round() / 100;
  if (!(amount > 0 && amount <= maxTransactionAmount)) {
    throw ArgumentError.value(transaction.amount, 'amount');
  }
  if (!transaction.kind.categories.contains(transaction.category)) {
    throw ArgumentError.value(transaction.category, 'category');
  }
  final description = transaction.description?.trim();
  if (description != null &&
      description.length > maxTransactionDescriptionLength) {
    throw ArgumentError.value(transaction.description, 'description');
  }
  if (transaction.lotSaleId != null &&
      (transaction.kind != TransactionKind.income ||
          transaction.lotId == null)) {
    throw ArgumentError.value(transaction.lotSaleId, 'lotSaleId');
  }
  if (transaction.customerId != null &&
      transaction.kind != TransactionKind.income) {
    throw ArgumentError.value(transaction.customerId, 'customerId');
  }
  return transaction.copyWith(
    amount: amount,
    description: description == null || description.isEmpty
        ? null
        : description,
    occurredOn: dateOnly(transaction.occurredOn),
  );
}

/// Sezonun özeti: gelir, gider, net (gelir − gider) ve kovan başı maliyet
/// (gider ÷ aktif kovan; kovan yoksa null).
typedef SeasonSummary = ({
  double income,
  double expense,
  double net,
  double? costPerHive,
});

/// [year] yılında (takvim yılı) [currency] ile yazılmış hareketlerin
/// özeti. Başka para birimindeki hareketler toplanmaz; tutarlar kuruşa
/// yuvarlıdır.
SeasonSummary seasonSummary(
  Iterable<FinanceTransaction> transactions, {
  required int year,
  required String currency,
  required int activeHives,
}) {
  var income = 0;
  var expense = 0;
  for (final transaction in transactions) {
    if (transaction.occurredOn.year != year ||
        transaction.currency != currency) {
      continue;
    }
    // Kuruş olarak toplanır; ondalık toplama kaymaz.
    final cents = (transaction.amount * 100).round();
    switch (transaction.kind) {
      case TransactionKind.income:
        income += cents;
      case TransactionKind.expense:
        expense += cents;
    }
  }
  return (
    income: income / 100,
    expense: expense / 100,
    net: (income - expense) / 100,
    costPerHive: activeHives > 0 ? expense / 100 / activeHives : null,
  );
}

/// Liste sırası: yeni gün önce, aynı günde son eklenen önce.
int compareTransactions(FinanceTransaction a, FinanceTransaction b) {
  final byDay = b.occurredOn.compareTo(a.occurredOn);
  if (byDay != 0) return byDay;
  final byCreated = b.createdAt.compareTo(a.createdAt);
  return byCreated != 0 ? byCreated : b.id.compareTo(a.id);
}
