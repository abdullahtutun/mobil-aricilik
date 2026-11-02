import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/customer_rules.dart';

void main() {
  final at = DateTime.utc(2026, 11, 4, 9);
  Customer customer({
    String name = 'Ayşe Hanım',
    String? phone,
    String? address,
    String? notes,
  }) => Customer(
    id: 'customer-1',
    orgId: 'org-1',
    name: name,
    phone: phone,
    address: address,
    notes: notes,
    createdAt: at,
    updatedAt: at,
  );

  group('checkCustomer', () {
    test('boşlukları atar, boş isteğe bağlı alanı null yapar', () {
      final checked = checkCustomer(
        customer(name: ' Ayşe ', phone: ' 0532 ', address: '  ', notes: ''),
      );
      expect(checked.name, 'Ayşe');
      expect(checked.phone, '0532');
      expect(checked.address, isNull);
      expect(checked.notes, isNull);
    });

    test('boş ad ve sınırı aşan alan reddedilir', () {
      expect(() => checkCustomer(customer(name: '  ')), throwsArgumentError);
      expect(
        () => checkCustomer(customer(name: 'a' * (maxCustomerNameLength + 1))),
        throwsArgumentError,
      );
      expect(
        () =>
            checkCustomer(customer(phone: '1' * (maxCustomerPhoneLength + 1))),
        throwsArgumentError,
      );
      expect(
        () => checkCustomer(
          customer(address: 'a' * (maxCustomerAddressLength + 1)),
        ),
        throwsArgumentError,
      );
    });
  });

  test('checkPayment tutarı kuruşa yuvarlar, günü saatsiz yapar; sıfır ve '
      'negatif reddedilir', () {
    CustomerPayment payment(double amount) => CustomerPayment(
      id: 'payment-1',
      orgId: 'org-1',
      transactionId: 'sale-1',
      amount: amount,
      paidOn: DateTime(2026, 11, 4, 15, 30),
      createdAt: at,
      updatedAt: at,
    );
    final checked = checkPayment(payment(1999.999));
    expect(checked.amount, 2000);
    expect(checked.paidOn, DateTime(2026, 11, 4));
    expect(() => checkPayment(payment(0)), throwsArgumentError);
    expect(() => checkPayment(payment(-5)), throwsArgumentError);
  });

  group('saleBalance', () {
    test('ödenen ve kalan kuruşla hesaplanır', () {
      final balance = saleBalance(6000, [0.1, 0.2, 1999.7]);
      expect(balance.paid, 2000);
      expect(balance.remaining, 4000);
      expect(isPaid(balance), isFalse);
    });

    test('tahsilat yoksa tamamı kalan; tamamı ödenince ödendi', () {
      expect(saleBalance(6000, const []).remaining, 6000);
      expect(isPaid(saleBalance(6000, [6000])), isTrue);
    });

    test('fazla ödeme kalanı sıfırın altına indirmez', () {
      final balance = saleBalance(6000, [4000, 4000]);
      expect(balance.paid, 8000);
      expect(balance.remaining, 0);
      expect(isPaid(balance), isTrue);
    });
  });

  test('receivablesSummary kalanları toplar, alacağı olan müşterileri '
      'bir kez sayar', () {
    final summary = receivablesSummary([
      (customerId: 'a', balance: saleBalance(6000, [2000])),
      (customerId: 'a', balance: saleBalance(500, const [])),
      (customerId: 'b', balance: saleBalance(18000, [18000])),
      (customerId: 'c', balance: saleBalance(0.3, [0.1])),
    ]);
    expect(summary.total, 4500.2);
    expect(summary.customers, 2);
    expect(receivablesSummary(const []), (total: 0.0, customers: 0));
  });

  group('whatsAppPhone', () {
    test('uluslararası biçim olduğu gibi kalır', () {
      expect(whatsAppPhone('+90 532 123 45 67'), '905321234567');
      expect(whatsAppPhone('0090 (532) 123-45-67'), '905321234567');
    });

    test('yerel numaraya ülke kodu eklenir, baştaki 0 atılır', () {
      expect(
        whatsAppPhone('0532 123 45 67', callingCode: '90'),
        '905321234567',
      );
      expect(whatsAppPhone('532 123 45 67', callingCode: '90'), '905321234567');
    });

    test('ülke kodu bilinmeyen yerel numara ve kısa numara çevrilmez', () {
      expect(whatsAppPhone('0532 123 45 67'), isNull);
      expect(whatsAppPhone('+90 12', callingCode: '90'), isNull);
      expect(whatsAppPhone(null, callingCode: '90'), isNull);
    });
  });

  test('whatsAppUri mesajı kodlar; numara yoksa kişi seçtirir', () {
    final uri = whatsAppUri('Merhaba Ayşe,\nTutar: ₺6.000', phone: '905321');
    expect(uri.host, 'wa.me');
    expect(uri.path, '/905321');
    expect(uri.queryParameters['text'], 'Merhaba Ayşe,\nTutar: ₺6.000');
    expect(uri.toString(), contains('Merhaba%20Ay'));
    expect(whatsAppUri('Merhaba').path, '/');
  });
}
