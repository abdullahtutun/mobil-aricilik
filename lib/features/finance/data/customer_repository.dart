import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/customer_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';

/// Müşteri defteri; durum kaydı: son yazan kazanır. Satışlar müşteriye
/// bağlı gelirler (`TransactionRepository`), tahsilatlar
/// [CustomerPaymentRepository]'de.
class CustomerRepository extends BaseRepository<$CustomersTable, Customer> {
  new(super.db, {super.clock});

  @override
  $CustomersTable get table => db.customers;

  @override
  Insertable<Customer> toInsertable(Customer record) => record.toInsertable();

  /// İşletmenin müşterileri, ada göre.
  Stream<List<Customer>> watchAll(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [(t) => OrderingTerm.asc(t.name), (t) => OrderingTerm.asc(t.id)],
  );

  /// Yeni müşteriyi yazar. Alanlar geçersizse ([checkCustomer])
  /// [ArgumentError] atar ve bir şey yazmaz.
  Future<Customer> create({
    required String orgId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    final at = now();
    return await insertRecord(
      checkCustomer(
        Customer(
          id: generateId(),
          orgId: orgId,
          name: name,
          phone: phone,
          address: address,
          notes: notes,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
  }

  /// Müşterinin alanlarını yazar. Alanlar geçersizse [ArgumentError],
  /// müşteri yoksa [StateError] atar.
  Future<Customer> update(Customer customer) async =>
      await updateRecord(checkCustomer(customer));
}

/// Satışa alınan ödemeler; olay kaydı: yalnız eklenir, yanlış kayıt
/// silinir (Geri al da silmedir).
class CustomerPaymentRepository
    extends BaseRepository<$CustomerPaymentsTable, CustomerPayment> {
  new(super.db, {super.clock});

  @override
  $CustomerPaymentsTable get table => db.customerPayments;

  @override
  Insertable<CustomerPayment> toInsertable(CustomerPayment record) =>
      record.toInsertable();

  /// Satışın silinmemiş tahsilatları, eski önce.
  Future<List<CustomerPayment>> findBySale(String transactionId) =>
      (selectWhere((t) => t.transactionId.equals(transactionId))..orderBy([
            (t) => OrderingTerm.asc(t.paidOn),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
          .get();

  /// Satışın ödenen ve kalanı.
  Future<SaleBalance> balanceOf(FinanceTransaction sale) async => saleBalance(
    sale.amount,
    [for (final payment in await findBySale(sale.id)) payment.amount],
  );

  /// [sale]'e [amount] tahsilat yazar. Satış müşterili gelir değilse
  /// [StateError], tutar geçersizse ya da kalanı aşıyorsa [ArgumentError]
  /// atar ve bir şey yazmaz.
  Future<CustomerPayment> add(
    FinanceTransaction sale,
    double amount, {
    required DateTime paidOn,
  }) => db.transaction(() async {
    if (sale.customerId == null || sale.kind != TransactionKind.income) {
      throw StateError('Müşterili satış değil: ${sale.id}');
    }
    final balance = await balanceOf(sale);
    if ((amount * 100).round() > (balance.remaining * 100).round()) {
      throw ArgumentError.value(amount, 'amount');
    }
    final at = now();
    return await insertRecord(
      checkPayment(
        CustomerPayment(
          id: generateId(),
          orgId: sale.orgId,
          transactionId: sale.id,
          amount: amount,
          paidOn: paidOn,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
  });

  /// Satışın kalanını tek tahsilatla kapatır; kalan yoksa bir şey yazmaz ve
  /// null döner.
  Future<CustomerPayment?> payRemaining(
    FinanceTransaction sale, {
    required DateTime paidOn,
  }) => db.transaction(() async {
    final balance = await balanceOf(sale);
    if (balance.remaining <= 0) return null;
    return await add(sale, balance.remaining, paidOn: paidOn);
  });
}
