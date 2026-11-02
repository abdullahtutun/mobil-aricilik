import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/utils/date_only.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

/// Müşterinin adı en çok bu kadar karakter.
const maxCustomerNameLength = 100;

/// Telefon en çok bu kadar karakter.
const maxCustomerPhoneLength = 30;

/// Kargo adresi en çok bu kadar karakter.
const maxCustomerAddressLength = 300;

/// Not en çok bu kadar karakter.
const maxCustomerNotesLength = 500;

/// Müşteri (`customers`); durum kaydı: son yazan kazanır. Satışları
/// müşteriye bağlı gelirler (`transactions.customer_id`), alacağı satışların
/// tahsil edilmemiş kısmı.
@freezed
abstract class Customer with _$Customer implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// WhatsApp için; uluslararası (`+90…`) ya da yerel biçimde.
    String? phone,

    /// Kargo adresi.
    String? address,
    String? notes,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Customer;

  factory fromJson(Map<String, Object?> json) => _$CustomerFromJson(json);
}

/// Müşterili satışa alınan ödeme (`customer_payments`); olay kaydı: yalnız
/// eklenir, yanlış kayıt silinir. Gelir değildir; gelir satışta yazıldı.
/// Para birimi satışınki.
@freezed
abstract class CustomerPayment with _$CustomerPayment implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String transactionId,

    /// Pozitif tutar, en çok iki ondalık.
    required double amount,
    @DateOnlyJsonConverter() required DateTime paidOn,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _CustomerPayment;

  factory fromJson(Map<String, Object?> json) =>
      _$CustomerPaymentFromJson(json);
}
