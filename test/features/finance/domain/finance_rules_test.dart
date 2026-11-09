import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';

FinanceTransaction _transaction({
  TransactionKind kind = TransactionKind.expense,
  TransactionCategory category = TransactionCategory.feeding,
  double amount = 100,
  String currency = 'TRY',
  DateTime? occurredOn,
  String? description,
  String? lotId,
  String? lotSaleId,
  String id = 'transaction-1',
  DateTime? createdAt,
}) => FinanceTransaction(
  id: id,
  orgId: 'org-1',
  kind: kind,
  category: category,
  amount: amount,
  currency: currency,
  occurredOn: occurredOn ?? DateTime(2026, 10),
  description: description,
  lotId: lotId,
  lotSaleId: lotSaleId,
  createdAt: createdAt ?? DateTime.utc(2026, 10, 1, 9),
  updatedAt: createdAt ?? DateTime.utc(2026, 10, 1, 9),
);

void main() {
  group('parseAmount', () {
    test('binlik nokta, kuruş virgül ya da tek nokta', () {
      expect(parseAmount('17.500'), 17500);
      expect(parseAmount('1.234.567'), 1234567);
      expect(parseAmount('1.234,56'), 1234.56);
      expect(parseAmount('17,5'), 17.5);
      expect(parseAmount('17.50'), 17.5);
      expect(parseAmount(' 56 000 '), 56000);
      expect(parseAmount('9800'), 9800);
    });

    test('sıfır, boş, bozuk ve sınır dışı null', () {
      expect(parseAmount(''), isNull);
      expect(parseAmount('0'), isNull);
      expect(parseAmount('0,00'), isNull);
      expect(parseAmount('12,345'), isNull);
      expect(parseAmount('1,2,3'), isNull);
      expect(parseAmount('abc'), isNull);
      expect(parseAmount('-5'), isNull);
      expect(parseAmount('1000000000000'), maxTransactionAmount);
      expect(parseAmount('1.000.000.000.000'), maxTransactionAmount);
      expect(parseAmount('1000000000001'), isNull);
    });
  });

  group('checkTransaction', () {
    test('tutarı kuruşa yuvarlar, açıklamayı kırpar, günü saatsiz yapar', () {
      final checked = checkTransaction(
        _transaction(
          amount: 10.005,
          description: '  Şeker 500 kg ',
          occurredOn: DateTime(2026, 10, 1, 14, 30),
        ),
      );
      expect(checked.amount, 10.01);
      expect(checked.description, 'Şeker 500 kg');
      expect(checked.occurredOn, DateTime(2026, 10));
      expect(
        checkTransaction(_transaction(description: '  ')).description,
        isNull,
      );
    });

    test('kategori türüne uymalı; ana arı ve diğer iki türde', () {
      expect(
        () => checkTransaction(_transaction(kind: TransactionKind.income)),
        throwsArgumentError,
      );
      expect(
        () =>
            checkTransaction(_transaction(category: TransactionCategory.honey)),
        throwsArgumentError,
      );
      for (final kind in TransactionKind.values) {
        for (final category in [
          TransactionCategory.queens,
          TransactionCategory.other,
        ]) {
          expect(
            checkTransaction(_transaction(kind: kind, category: category))
                .category,
            category,
          );
        }
      }
    });

    test('her kategori en az bir türde', () {
      expect({
        for (final kind in TransactionKind.values) ...kind.categories,
      }, TransactionCategory.values.toSet());
    });

    test('tutar ve açıklama sınırları', () {
      expect(
        () => checkTransaction(_transaction(amount: 0)),
        throwsArgumentError,
      );
      expect(
        () => checkTransaction(_transaction(amount: 0.004)),
        throwsArgumentError,
      );
      expect(
        () => checkTransaction(_transaction(amount: maxTransactionAmount + 1)),
        throwsArgumentError,
      );
      expect(
        () => checkTransaction(
          _transaction(
            description: 'a' * (maxTransactionDescriptionLength + 1),
          ),
        ),
        throwsArgumentError,
      );
    });

    test('satış bağı yalnız lotlu gelirde', () {
      expect(
        () => checkTransaction(_transaction(lotId: 'lot-1', lotSaleId: 's')),
        throwsArgumentError,
      );
      expect(
        () => checkTransaction(
          _transaction(
            kind: TransactionKind.income,
            category: TransactionCategory.honey,
            lotSaleId: 's',
          ),
        ),
        throwsArgumentError,
      );
      expect(
        checkTransaction(
          _transaction(
            kind: TransactionKind.income,
            category: TransactionCategory.honey,
            lotId: 'lot-1',
            lotSaleId: 's',
          ),
        ).lotSaleId,
        's',
      );
    });
  });

  group('seasonSummary', () {
    test(
      'yılın ve para biriminin gelir, gider, net ve kovan başı maliyeti',
      () {
        final summary = seasonSummary(
          [
            _transaction(
              kind: TransactionKind.income,
              category: TransactionCategory.honey,
              amount: 56000,
            ),
            _transaction(amount: 17500),
            _transaction(
              category: TransactionCategory.fuelTransport,
              amount: 9800.1,
            ),
            // Geçen yıl ve başka para birimi sayılmaz.
            _transaction(amount: 1000, occurredOn: DateTime(2025, 12, 31)),
            _transaction(amount: 1000, currency: 'EUR'),
          ],
          year: 2026,
          currency: 'TRY',
          activeHives: 4,
        );
        expect(summary.income, 56000);
        expect(summary.expense, 27300.1);
        expect(summary.net, 28699.9);
        expect(summary.costPerHive, closeTo(6825.025, 1e-9));
      },
    );

    test('gider gelirden fazlaysa net eksi; kovan yoksa maliyet yok', () {
      final summary = seasonSummary(
        [_transaction(amount: 300)],
        year: 2026,
        currency: 'TRY',
        activeHives: 0,
      );
      expect(summary.net, -300);
      expect(summary.costPerHive, isNull);
    });
  });

  test('fiş yolu kaydın klasöründe; dosya adı son parça', () {
    final path = receiptStoragePath(
      orgId: 'org-1',
      transactionId: 'transaction-1',
      fileId: 'file-1',
    );
    expect(path, 'org-1/transaction-1/file-1.jpg');
    expect(receiptFileName(path), 'file-1.jpg');
  });

  test('sıra: yeni gün önce, aynı günde son eklenen önce', () {
    final old = _transaction(id: 'a', occurredOn: DateTime(2026, 9));
    final early = _transaction(
      id: 'b',
      createdAt: DateTime.utc(2026, 10, 1, 8),
    );
    final late = _transaction(
      id: 'c',
      createdAt: DateTime.utc(2026, 10, 1, 10),
    );
    expect(([old, early, late]..sort(compareTransactions)).map((t) => t.id), [
      'c',
      'b',
      'a',
    ]);
  });
}
