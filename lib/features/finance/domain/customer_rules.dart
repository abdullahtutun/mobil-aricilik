import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';

/// Müşteriyi yazılacak hâline getirir: alanların baştaki ve sondaki
/// boşlukları atılır, boş isteğe bağlı alan null olur. Ad boşsa ya da bir
/// alan sınırından uzunsa [ArgumentError] atar.
Customer checkCustomer(Customer customer) {
  String? clean(String? value, int max, String name) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    if (trimmed.length > max) throw ArgumentError.value(value, name);
    return trimmed;
  }

  final name = clean(customer.name, maxCustomerNameLength, 'name');
  if (name == null) throw ArgumentError.value(customer.name, 'name');
  return customer.copyWith(
    name: name,
    phone: clean(customer.phone, maxCustomerPhoneLength, 'phone'),
    address: clean(customer.address, maxCustomerAddressLength, 'address'),
    notes: clean(customer.notes, maxCustomerNotesLength, 'notes'),
  );
}

/// Tahsilatı yazılacak hâline getirir: tutar iki ondalığa yuvarlanır, gün
/// saatsiz olur. Tutar aralık dışındaysa [ArgumentError] atar.
CustomerPayment checkPayment(CustomerPayment payment) {
  final amount = (payment.amount * 100).round() / 100;
  if (!(amount > 0 && amount <= maxTransactionAmount)) {
    throw ArgumentError.value(payment.amount, 'amount');
  }
  return payment.copyWith(amount: amount, paidOn: dateOnly(payment.paidOn));
}

/// Satışın ödenen ve kalan kısmı. Kalan sıfırın altına inmez: offline iki
/// telefon aynı satışa ödeme yazarsa fazlası alacak sayılmaz.
typedef SaleBalance = ({double amount, double paid, double remaining});

/// [amount] tutarlı satışa [payments] alınınca ödenen ve kalan; kuruşa
/// yuvarlı.
SaleBalance saleBalance(double amount, Iterable<double> payments) {
  final total = (amount * 100).round();
  final paid = payments.fold<int>(0, (sum, p) => sum + (p * 100).round());
  final remaining = total - paid;
  return (
    amount: total / 100,
    paid: paid / 100,
    remaining: remaining > 0 ? remaining / 100 : 0,
  );
}

/// Satış tamamen ödendi.
bool isPaid(SaleBalance balance) => balance.remaining == 0;

/// Alacakların özeti: toplam kalan ve alacağı olan farklı müşteri sayısı.
typedef ReceivablesSummary = ({double total, int customers});

/// [sales] satışlarının (müşteri, bakiye) alacak özeti; kuruşa yuvarlı.
ReceivablesSummary receivablesSummary(
  Iterable<({String customerId, SaleBalance balance})> sales,
) {
  var total = 0;
  final customers = <String>{};
  for (final sale in sales) {
    final cents = (sale.balance.remaining * 100).round();
    if (cents <= 0) continue;
    total += cents;
    customers.add(sale.customerId);
  }
  return (total: total / 100, customers: customers.length);
}

/// WhatsApp'ın beklediği uluslararası numara: yalnız rakamlar, ülke koduyla,
/// `+` olmadan. `+90 532…` ve `0090 532…` olduğu gibi; yerel `0532…` ve
/// `532…` [callingCode] eklenerek. Ülke kodu bilinmiyorsa yerel numara
/// çevrilemez; rakamı yedi haneden azsa da null.
String? whatsAppPhone(String? phone, {String? callingCode}) {
  if (phone == null) return null;
  final trimmed = phone.trim();
  final digits = trimmed.replaceAll(RegExp('[^0-9]'), '');
  if (digits.length < 7) return null;
  if (trimmed.startsWith('+')) return digits;
  if (digits.startsWith('00')) return digits.substring(2);
  if (callingCode == null) return null;
  return '$callingCode${digits.startsWith('0') ? digits.substring(1) : digits}';
}

/// WhatsApp'ta [text]'i hazır mesaj olarak açan adres. Numara yoksa
/// WhatsApp kişi seçtirir. Boşluk `%20` olur; `+` yazılsa WhatsApp onu
/// harf olarak gösterirdi.
Uri whatsAppUri(String text, {String? phone}) =>
    Uri.parse('https://wa.me/${phone ?? ''}?text=${Uri.encodeComponent(text)}');
