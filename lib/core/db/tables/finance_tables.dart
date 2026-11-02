import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/media_tables.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';

/// `public.transactions` aynası; olay tablosu. Sunucudaki `numeric` tutar
/// burada gerçek sayı. Fiş dosyası burada yok: bu telefonun fiş klasöründe
/// `receipt_path`'in son parçasıyla aynı adla durur.
@UseRowClass(FinanceTransaction, generateInsertable: true)
@TableIndex(name: 'transactions_org_id_idx', columns: {#orgId})
@TableIndex(name: 'transactions_lot_id_idx', columns: {#lotId})
@TableIndex(name: 'transactions_customer_id_idx', columns: {#customerId})
class Transactions extends Table with SyncColumns, OrgColumns {
  TextColumn get kind =>
      text().map(const ServerEnumConverter(TransactionKind.values))();
  TextColumn get category =>
      text().map(const ServerEnumConverter(TransactionCategory.values))();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  TextColumn get occurredOn => text().map(const DateOnlyConverter())();
  TextColumn get description => text().nullable()();
  TextColumn get receiptPath => text().nullable()();
  TextColumn get apiaryId => text().nullable()();
  TextColumn get lotId => text().nullable()();
  TextColumn get transportId => text().nullable()();
  TextColumn get lotSaleId => text().nullable()();
  TextColumn get customerId => text().nullable()();
}

/// `public.customers` aynası; durum tablosu.
@UseRowClass(Customer, generateInsertable: true)
@TableIndex(name: 'customers_org_id_idx', columns: {#orgId})
class Customers extends Table with SyncColumns, OrgColumns {
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// `public.customer_payments` aynası; olay tablosu. Yerelde satışa FK yok,
/// senkron satırları sırasız indirir.
@UseRowClass(CustomerPayment, generateInsertable: true)
@TableIndex(name: 'customer_payments_org_id_idx', columns: {#orgId})
@TableIndex(
  name: 'customer_payments_transaction_id_idx',
  columns: {#transactionId},
)
class CustomerPayments extends Table with SyncColumns, OrgColumns {
  TextColumn get transactionId => text()();
  RealColumn get amount => real()();
  TextColumn get paidOn => text().map(const DateOnlyConverter())();
}

/// Bu telefonda çekilen fiş fotoğraflarının yükleme kuyruğu; yalnız bu
/// telefonda, sunucuda aynası yok. Hareketle aynı transaction'da `pending`
/// olarak yazılır.
@DataClassName('ReceiptUpload')
class ReceiptUploads extends Table {
  /// Hareketin `receipt_path`'i; dosyanın yerel adı bunun son parçası.
  TextColumn get storagePath => text()();
  TextColumn get transactionId => text()();
  TextColumn get orgId => text()();
  TextColumn get uploadStatus => textEnum<MediaUploadStatus>()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Boşsa hemen denenir.
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {storagePath};
}
