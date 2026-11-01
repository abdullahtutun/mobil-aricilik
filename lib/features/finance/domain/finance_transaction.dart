import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/utils/date_only.dart';

part 'finance_transaction.freezed.dart';
part 'finance_transaction.g.dart';

/// Hareketin yönü (`public.transaction_kind`).
@JsonEnum(valueField: 'value')
enum TransactionKind implements ServerEnum {
  income('income'),
  expense('expense');

  new(this.value);

  @override
  final String value;

  /// Bu türde seçilebilen kategoriler, formdaki sırasıyla (ozellikler.md
  /// §11); "Diğer" sonda.
  List<TransactionCategory> get categories => switch (this) {
    income => const [
      TransactionCategory.honey,
      TransactionCategory.pollen,
      TransactionCategory.propolis,
      TransactionCategory.wax,
      TransactionCategory.queens,
      TransactionCategory.nucs,
      TransactionCategory.other,
    ],
    expense => const [
      TransactionCategory.feeding,
      TransactionCategory.treatment,
      TransactionCategory.queens,
      TransactionCategory.equipment,
      TransactionCategory.fuelTransport,
      TransactionCategory.landRent,
      TransactionCategory.labor,
      TransactionCategory.labAnalysis,
      TransactionCategory.other,
    ],
  };
}

/// Hareketin kategorisi (`public.transaction_category`). Kategori türüne
/// uymalı ([TransactionKind.categories]); "Ana arı" ve "Diğer" ikisinde de
/// var.
@JsonEnum(valueField: 'value')
enum TransactionCategory implements ServerEnum {
  feeding('feeding'),

  /// İlaç.
  treatment('treatment'),
  equipment('equipment'),

  /// Yakıt ve nakliye.
  fuelTransport('fuel_transport'),
  landRent('land_rent'),
  labor('labor'),
  labAnalysis('lab_analysis'),
  honey('honey'),
  pollen('pollen'),
  propolis('propolis'),

  /// Balmumu.
  wax('wax'),

  /// Oğulcuk.
  nucs('nucs'),

  /// Ana arı (alış ya da satış).
  queens('queens'),
  other('other');

  new(this.value);

  @override
  final String value;
}

/// Tutarın üst sınırı (sunucudaki CHECK).
const maxTransactionAmount = 1000000000.0;

/// Açıklama en çok bu kadar karakter.
const maxTransactionDescriptionLength = 200;

/// Fiş fotoğrafının bucket sınırı (10 MB).
const int maxReceiptBytes = 10 * 1024 * 1024;

/// Gelir ya da gider (`transactions`); olay kaydı: yalnız eklenir, yanlış
/// kayıt silinir. Tutar hep pozitif, yönü `kind`. Para birimi kaydın
/// yazıldığı andaki işletmenin.
///
/// Lottan satış gelirinde satılan kilogram `lot_sales`'te; gelir ona
/// `lot_sale_id` ile bağlı. Fiş fotoğrafı `receipts` bucket'ında
/// `receipt_path`'te ve bu telefonda aynı adla (`receiptFileName`).
@freezed
abstract class FinanceTransaction
    with _$FinanceTransaction
    implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required TransactionKind kind,
    required TransactionCategory category,

    /// Pozitif tutar, en çok iki ondalık.
    required double amount,

    /// ISO 4217 kodu.
    required String currency,
    @DateOnlyJsonConverter() required DateTime occurredOn,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,

    /// `receipts` bucket'ındaki yol (`receiptStoragePath`); fiş yoksa boş.
    String? receiptPath,
    String? apiaryId,
    String? lotId,
    String? transportId,

    /// Lottan satışta düşülen kilogramın kaydı.
    String? lotSaleId,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _FinanceTransaction;

  factory fromJson(Map<String, Object?> json) =>
      _$FinanceTransactionFromJson(json);
}

/// Bu telefonda çekilmiş, henüz harekete bağlanmamış fiş fotoğrafı.
/// Klasördeki adı `fileId.jpg`; Storage yolunun son parçasıyla aynı.
typedef ReceiptCapture = ({String fileId, int byteSize});

extension ReceiptCaptureName on ReceiptCapture {
  String get fileName => '$fileId.jpg';
}
