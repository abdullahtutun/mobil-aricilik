import 'dart:io';

import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/receipt_file_store_provider.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/finance/data/customer_repository.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/customer_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/domain/profitability_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'finance_providers.g.dart';

@Riverpod(keepAlive: true)
TransactionRepository transactionRepository(Ref ref) =>
    TransactionRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) =>
    CustomerRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
CustomerPaymentRepository customerPaymentRepository(Ref ref) =>
    CustomerPaymentRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin hareketleri, yeni önce; işletme yoksa boş.
@riverpod
Stream<List<TransactionRow>> transactionRows(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(transactionRepositoryProvider).watchRows(orgId);
}

/// Hareket; yoksa ya da silinmişse (Geri al) null.
@riverpod
Stream<TransactionRow?> transactionRow(Ref ref, String id) =>
    ref.watch(transactionRepositoryProvider).watchRow(id);

/// Gidere bağlanabilecek son taşımalar; işletme yoksa boş.
@riverpod
Stream<List<TransportChoice>> transportChoices(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(transactionRepositoryProvider).watchTransportChoices(orgId);
}

/// İşletmenin para birimi; yeni hareketler bununla yazılır, eskiler kendi
/// para birimini taşır. İşletme henüz yüklenmediyse null.
@riverpod
String? financeCurrency(Ref ref) => ref.watch(organizationCurrencyProvider);

/// Bu sezonun (takvim yılı) özeti: işletmenin para birimindeki gelir,
/// gider, net ve aktif kovan başı maliyet.
@riverpod
Future<SeasonSummary?> financeSeason(Ref ref) async {
  final currency = ref.watch(financeCurrencyProvider);
  if (currency == null) return null;
  final rows = await ref.watch(transactionRowsProvider.future);
  final apiaries = await ref.watch(apiaryListProvider.future);
  return seasonSummary(
    [for (final row in rows) row.transaction],
    year: clock.now().year,
    currency: currency,
    activeHives: apiaries.fold(0, (sum, item) => sum + item.activeHiveCount),
  );
}

/// Bu sezonun işletmenin para birimi dışındaki hareketleri, para birimine
/// göre ayrı özetler (para birimi değişmeden önceki kayıtlar
/// dönüştürülmez); yoksa boş.
@riverpod
Future<Map<String, SeasonSummary>> financeOtherCurrencies(Ref ref) async {
  final currency = ref.watch(financeCurrencyProvider);
  if (currency == null) return const {};
  final rows = await ref.watch(transactionRowsProvider.future);
  return seasonSummariesByCurrency([
    for (final row in rows) row.transaction,
  ], year: clock.now().year)..remove(currency);
}

/// Bu sezonun konaklama noktası (arılık) kârları, büyük net önce
/// ([apiaryProfits]); işletmenin para birimindeki hareketlerden.
@riverpod
Future<List<ApiaryProfit>> apiaryProfitList(Ref ref) async {
  final orgId = ref.watch(currentOrgIdProvider);
  final currency = ref.watch(financeCurrencyProvider);
  if (orgId == null || currency == null) return const [];
  final rows = await ref.watch(transactionRowsProvider.future);
  final shares = await ref.watch(lotHarvestSharesProvider.future);
  final apiaries = await ref.watch(apiaryListProvider.future);
  return apiaryProfits(
    [for (final row in rows) row.transaction],
    year: clock.now().year,
    currency: currency,
    lotHarvests: shares,
    transportDestinations: {
      for (final row in rows)
        if ((row.transaction.transportId, row.transportToId) case (
          final id?,
          final to?,
        ))
          id: to,
    },
    activeHives: {
      for (final item in apiaries) item.apiary.id: item.activeHiveCount,
    },
  );
}

/// İşletmenin lota bağlı hasatları (lot, arılık, kg); işletme yoksa boş.
@riverpod
Stream<List<LotHarvestShare>> lotHarvestShares(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(transactionRepositoryProvider).watchLotHarvestShares(orgId);
}

/// Oturumdaki işletmenin müşterileri, ada göre; işletme yoksa boş.
@riverpod
Stream<List<Customer>> customerList(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(customerRepositoryProvider).watchAll(orgId);
}

/// Müşteri; yoksa ya da silinmişse null.
@riverpod
Stream<Customer?> customer(Ref ref, String id) =>
    ref.watch(customerRepositoryProvider).watchById(id);

/// Müşterinin satışları, yeni önce.
@riverpod
Stream<List<TransactionRow>> customerSales(Ref ref, String customerId) =>
    ref.watch(transactionRepositoryProvider).watchCustomerRows(customerId);

/// Satırın ödenen ve kalanı ([saleBalance]).
SaleBalance rowBalance(TransactionRow row) =>
    saleBalance(row.transaction.amount, [row.paid]);

/// Müşteri ve alacağı (satışlarının kalanlarının toplamı).
typedef CustomerSummary = ({Customer customer, double receivable});

/// Müşteriler alacaklarıyla, ada göre.
@riverpod
Future<List<CustomerSummary>> customerSummaries(Ref ref) async {
  final customers = await ref.watch(customerListProvider.future);
  final rows = await ref.watch(transactionRowsProvider.future);
  return [
    for (final customer in customers)
      (
        customer: customer,
        receivable: receivablesSummary([
          for (final row in rows)
            if (row.transaction.customerId == customer.id)
              (customerId: customer.id, balance: rowBalance(row)),
        ]).total,
      ),
  ];
}

/// İşletmenin para birimindeki alacakların özeti: silinmemiş müşterilerin
/// satışlarının kalanı ve alacağı olan müşteri sayısı.
@riverpod
Future<ReceivablesSummary?> receivables(Ref ref) async {
  final currency = ref.watch(financeCurrencyProvider);
  if (currency == null) return null;
  final rows = await ref.watch(transactionRowsProvider.future);
  return receivablesSummary([
    for (final row in rows)
      if ((row.transaction.customerId, row.customerName) case (final id?, _?)
          when row.transaction.currency == currency)
        (customerId: id, balance: rowBalance(row)),
  ]);
}

/// Fiş fotoğrafı bu telefonda varsa; yoksa (henüz inmedi) null.
@riverpod
Future<File?> receiptFile(Ref ref, String storagePath) =>
    ref.watch(receiptFileStoreProvider).find(receiptFileName(storagePath));

/// Hareket yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da
/// çalışsın diye sürekli yaşar.
@Riverpod(keepAlive: true)
class FinanceActions extends _$FinanceActions {
  @override
  void build() {}

  /// Hareketi, (lot satışında) satışı ve tahsilatlarını siler; Geri al da
  /// budur.
  Future<void> remove(FinanceTransaction transaction) =>
      ref.read(transactionRepositoryProvider).remove(transaction.id);

  /// Satışın kalanını bugünkü tarihle tahsil eder; kalan yoksa null.
  Future<CustomerPayment?> payRemaining(FinanceTransaction sale) => ref
      .read(customerPaymentRepositoryProvider)
      .payRemaining(sale, paidOn: clock.now());

  /// Satışa [amount] tahsilat yazar.
  Future<CustomerPayment> addPayment(
    FinanceTransaction sale,
    double amount, {
    required DateTime paidOn,
  }) => ref
      .read(customerPaymentRepositoryProvider)
      .add(sale, amount, paidOn: paidOn);

  /// Tahsilatı siler; Geri al budur.
  Future<void> removePayment(CustomerPayment payment) =>
      ref.read(customerPaymentRepositoryProvider).delete(payment.id);

  /// Müşteriyi siler; satışları kalır.
  Future<void> removeCustomer(Customer customer) =>
      ref.read(customerRepositoryProvider).delete(customer.id);
}
