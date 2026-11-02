import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/finance/data/customer_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/domain/profitability_rules.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';

/// Hareket ve bağlı kayıtların ekranda gösterilen adları: lotun yılı ve
/// sırası, satışta düşülen kilogram, arılığın adı, taşımanın çıkış ve
/// varış arılıkları (varışın kimliği de), müşterinin adı. Bağlı kayıt
/// silinmişse ilgili alan boş. `paid` satışa alınan silinmemiş
/// tahsilatların toplamı; tahsilat yoksa 0.
typedef TransactionRow = ({
  FinanceTransaction transaction,
  int? lotYear,
  int? lotSeq,
  double? saleKg,
  String? apiaryName,
  String? transportFrom,
  String? transportTo,
  String? transportToId,
  String? customerName,
  double paid,
});

/// Gidere bağlanabilecek taşıma: çıkış ve varış arılıklarının adı.
typedef TransportChoice = ({
  String id,
  String? from,
  String? to,
  DateTime createdAt,
});

/// Gelir ve gider hareketleri; olay kaydı: yalnız eklenir, yanlış kayıt
/// silinir (Geri al da silmedir).
///
/// Lottan satış gelirinde kilogram aynı transaction'da `lot_sales`'e
/// yazılır; hareket silinince satış da silinir ve lotun stoğu geri gelir.
/// Bu telefonda çekilen fiş fotoğrafı hareketle aynı transaction'da
/// yükleme kuyruğuna (`receipt_uploads`, `pending`) yazılır; dosyayı arka
/// planda `ReceiptSyncService` yükler.
class TransactionRepository
    extends BaseRepository<$TransactionsTable, FinanceTransaction> {
  new(super.db, {super.clock});

  @override
  $TransactionsTable get table => db.transactions;

  @override
  Insertable<FinanceTransaction> toInsertable(FinanceTransaction record) =>
      record.toInsertable();

  late final _lots = LotRepository(db, clock: clock);
  late final _payments = CustomerPaymentRepository(db, clock: clock);

  /// İşletmenin hareketleri bağlı kayıtların adlarıyla, yeni önce
  /// ([compareTransactions]); hareket ya da bağlı kayıt değişince yeniden
  /// yayar.
  Stream<List<TransactionRow>> watchRows(String orgId) =>
      _watchRows('t.org_id = ?', orgId);

  /// Müşterinin satışları, yeni önce.
  Stream<List<TransactionRow>> watchCustomerRows(String customerId) =>
      _watchRows('t.customer_id = ?', customerId);

  /// Hareket ve bağlı kayıtların adları; yoksa ya da silinmişse null.
  Stream<TransactionRow?> watchRow(String id) =>
      _watchRows('t.id = ?', id).map((rows) => rows.singleOrNull);

  Stream<List<TransactionRow>> _watchRows(String filter, String value) {
    final sql =
        'select t.*, l.year as lot_year, l.seq as lot_seq, '
        's.kg as sale_kg, a.name as apiary_name, '
        'sa.name as transport_from, da.name as transport_to, '
        'tr.destination_apiary_id as transport_to_id, '
        'c.name as customer_name, '
        '(select coalesce(sum(p.amount), 0) from customer_payments p '
        'where p.transaction_id = t.id and p.deleted_at is null) as paid '
        'from transactions t '
        'left join lots l on l.id = t.lot_id and l.deleted_at is null '
        'left join lot_sales s on s.id = t.lot_sale_id '
        'and s.deleted_at is null '
        'left join apiaries a on a.id = t.apiary_id and a.deleted_at is null '
        'left join transports tr on tr.id = t.transport_id '
        'and tr.deleted_at is null '
        'left join apiaries sa on sa.id = tr.source_apiary_id '
        'left join apiaries da on da.id = tr.destination_apiary_id '
        'left join customers c on c.id = t.customer_id '
        'and c.deleted_at is null '
        'where t.deleted_at is null and $filter';
    return db
        .customSelect(
          sql,
          variables: [Variable.withString(value)],
          readsFrom: {
            db.transactions,
            db.lots,
            db.lotSales,
            db.apiaries,
            db.transports,
            db.customers,
            db.customerPayments,
          },
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              (
                transaction: db.transactions.map(row.data),
                lotYear: row.readNullable<int>('lot_year'),
                lotSeq: row.readNullable<int>('lot_seq'),
                saleKg: row.readNullable<double>('sale_kg'),
                apiaryName: row.readNullable<String>('apiary_name'),
                transportFrom: row.readNullable<String>('transport_from'),
                transportTo: row.readNullable<String>('transport_to'),
                transportToId: row.readNullable<String>('transport_to_id'),
                customerName: row.readNullable<String>('customer_name'),
                paid: row.read<double>('paid'),
              ),
          ]..sort((a, b) => compareTransactions(a.transaction, b.transaction)),
        );
  }

  /// İşletmenin lota bağlı hasatları: lot, hasadın arılığı ve kilogramı;
  /// lotun gelirini arılıklara paylaştırmak için ([apiaryProfits]).
  Stream<List<LotHarvestShare>> watchLotHarvestShares(String orgId) => db
      .customSelect(
        'select lh.lot_id, h.apiary_id, h.net_kg from lot_harvests lh '
        'join harvests h on h.id = lh.harvest_id and h.deleted_at is null '
        'where lh.deleted_at is null and lh.org_id = ?',
        variables: [Variable.withString(orgId)],
        readsFrom: {db.lotHarvests, db.harvests},
      )
      .watch()
      .map(
        (rows) => [
          for (final row in rows)
            (
              lotId: row.read<String>('lot_id'),
              apiaryId: row.read<String>('apiary_id'),
              kg: row.read<double>('net_kg'),
            ),
        ],
      );

  /// İşletmenin son [limit] taşıması, yeni önce; gidere bağlamak için.
  Stream<List<TransportChoice>> watchTransportChoices(
    String orgId, {
    int limit = 20,
  }) => db
      .customSelect(
        'select tr.id, tr.created_at, sa.name as source_name, '
        'da.name as destination_name from transports tr '
        'left join apiaries sa on sa.id = tr.source_apiary_id '
        'left join apiaries da on da.id = tr.destination_apiary_id '
        'where tr.deleted_at is null and tr.org_id = ? '
        'order by tr.created_at desc, tr.id desc limit ?',
        variables: [Variable.withString(orgId), Variable.withInt(limit)],
        readsFrom: {db.transports, db.apiaries},
      )
      .watch()
      .map(
        (rows) => [
          for (final row in rows)
            (
              id: row.read<String>('id'),
              from: row.readNullable<String>('source_name'),
              to: row.readNullable<String>('destination_name'),
              createdAt: db.typeMapping.read(
                DriftSqlType.dateTime,
                row.data['created_at'],
              )!,
            ),
        ],
      );

  /// Hareketi yazar; [receipt] verilirse fişi yükleme kuyruğuna ekler.
  /// [saleKg] verilirse [lotId] lotundan o kadar satış düşer ve hareket
  /// satışa bağlanır. [customerId] gelirin müşterisi; [paidNow] satışta
  /// alınan ödeme, tahsilat olarak yazılır (kalanı alacak). Hepsi tek
  /// transaction'da. Alanlar geçersizse ([checkTransaction]), satış
  /// kilogramı sınır dışındaysa ya da peşin ödeme tutarı aşıyorsa
  /// [ArgumentError], satılan lot yoksa [StateError] atar ve bir şey
  /// yazmaz.
  Future<FinanceTransaction> create({
    required String orgId,
    required TransactionKind kind,
    required TransactionCategory category,
    required double amount,
    required String currency,
    required DateTime occurredOn,
    String? description,
    ReceiptCapture? receipt,
    String? apiaryId,
    String? lotId,
    String? transportId,
    double? saleKg,
    String? customerId,
    double? paidNow,
  }) => db.transaction(() async {
    final at = now();
    final id = generateId();
    String? lotSaleId;
    if (saleKg != null) {
      if (kind != TransactionKind.income || lotId == null) {
        throw ArgumentError.value(saleKg, 'saleKg');
      }
      final lot =
          await _lots.findById(lotId) ?? (throw StateError('Lot yok: $lotId'));
      lotSaleId = (await _lots.sales.add(lot, saleKg, soldOn: occurredOn)).id;
    }
    final transaction = await insertRecord(
      checkTransaction(
        FinanceTransaction(
          id: id,
          orgId: orgId,
          kind: kind,
          category: category,
          amount: amount,
          currency: currency,
          occurredOn: occurredOn,
          description: description,
          receiptPath: receipt == null
              ? null
              : receiptStoragePath(
                  orgId: orgId,
                  transactionId: id,
                  fileId: receipt.fileId,
                ),
          apiaryId: apiaryId,
          lotId: lotId,
          transportId: transportId,
          lotSaleId: lotSaleId,
          customerId: customerId,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
    if (paidNow != null) {
      if (customerId == null) throw ArgumentError.value(paidNow, 'paidNow');
      await _payments.add(transaction, paidNow, paidOn: occurredOn);
    }
    if (transaction.receiptPath case final path?) {
      await db
          .into(db.receiptUploads)
          .insert(
            ReceiptUploadsCompanion.insert(
              storagePath: path,
              transactionId: id,
              orgId: orgId,
              uploadStatus: MediaUploadStatus.pending,
              createdAt: at,
            ),
          );
    }
    return transaction;
  });

  /// Hareketi, bağlı lot satışını ve tahsilatlarını siler, fişi henüz
  /// yüklenmediyse kuyruktan çıkarır; hepsi tek transaction'da. Yüklenmiş
  /// fiş Storage'da kalır. Hareket yoksa ya da zaten silinmişse bir şey yazmaz.
  Future<void> remove(String id) => db.transaction(() async {
    final transaction = await findById(id);
    if (transaction == null) return;
    await delete(id);
    if (transaction.lotSaleId case final saleId?) {
      await _lots.sales.delete(saleId);
    }
    for (final payment in await _payments.findBySale(id)) {
      await _payments.delete(payment.id);
    }
    await (db.delete(db.receiptUploads)..where(
          (t) =>
              t.transactionId.equals(id) &
              t.uploadStatus.equalsValue(MediaUploadStatus.uploaded).not(),
        ))
        .go();
  });

  /// Yüklenmeyi bekleyen fiş sayısı (kalıcı hata alanlar dahil değil).
  Stream<int> watchPendingReceiptCount() {
    final count = db.receiptUploads.storagePath.count();
    return (db.selectOnly(db.receiptUploads)
          ..addColumns([count])
          ..where(
            db.receiptUploads.uploadStatus.equalsValue(
              MediaUploadStatus.pending,
            ),
          ))
        .map((row) => row.read(count)!)
        .watchSingle();
  }

  /// İşletmenin silinmemiş fişli hareketleri; bir kez okunur (fiş
  /// indirme).
  Future<List<FinanceTransaction>> listWithReceipts(String orgId) =>
      selectWhere((t) => t.orgId.equals(orgId) & t.receiptPath.isNotNull())
          .get();
}
