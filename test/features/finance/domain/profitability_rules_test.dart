import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/domain/profitability_rules.dart';

void main() {
  final at = DateTime.utc(2026, 11, 4, 9);
  var seq = 0;
  FinanceTransaction transaction(
    TransactionKind kind,
    double amount, {
    String? apiaryId,
    String? lotId,
    String? transportId,
    DateTime? on,
    String currency = 'TRY',
  }) => FinanceTransaction(
    id: 'transaction-${seq++}',
    orgId: 'org-1',
    kind: kind,
    category: kind == TransactionKind.income
        ? TransactionCategory.honey
        : TransactionCategory.other,
    amount: amount,
    currency: currency,
    occurredOn: on ?? DateTime(2026, 8),
    apiaryId: apiaryId,
    lotId: lotId,
    transportId: transportId,
    createdAt: at,
    updatedAt: at,
  );
  FinanceTransaction income(
    double amount, {
    String? apiaryId,
    String? lotId,
    DateTime? on,
    String currency = 'TRY',
  }) => transaction(
    TransactionKind.income,
    amount,
    apiaryId: apiaryId,
    lotId: lotId,
    on: on,
    currency: currency,
  );
  FinanceTransaction expense(
    double amount, {
    String? apiaryId,
    String? transportId,
  }) => transaction(
    TransactionKind.expense,
    amount,
    apiaryId: apiaryId,
    transportId: transportId,
  );

  group('costPerHive', () {
    test('gider ÷ kovan, kuruşa yuvarlı', () {
      expect(costPerHive(193600, 152), 1273.68);
      expect(costPerHive(1000, 3), 333.33);
    });

    test('kovan yoksa null', () {
      expect(costPerHive(1000, 0), isNull);
    });
  });

  group('apiaryProfits', () {
    test('lotun geliri hasatlarının arılıklarına kilogramla paylaşılır', () {
      final profits = apiaryProfits(
        [income(56000, lotId: 'lot-1', apiaryId: 'cam')],
        year: 2026,
        currency: 'TRY',
        lotHarvests: const [
          (lotId: 'lot-1', apiaryId: 'cam', kg: 300),
          (lotId: 'lot-1', apiaryId: 'kestane', kg: 100),
        ],
      );
      expect(
        {for (final p in profits) p.apiaryId: p.income},
        {'cam': 42000, 'kestane': 14000},
      );
    });

    test('paylaşımda küsurat en büyük paya gider, toplam korunur', () {
      final profits = apiaryProfits(
        [income(100, lotId: 'lot-1')],
        year: 2026,
        currency: 'TRY',
        lotHarvests: const [
          (lotId: 'lot-1', apiaryId: 'a', kg: 1),
          (lotId: 'lot-1', apiaryId: 'b', kg: 1),
          (lotId: 'lot-1', apiaryId: 'c', kg: 1.5),
        ],
      );
      final byId = {for (final p in profits) p.apiaryId: p.income};
      expect(byId, {'a': 28.57, 'b': 28.57, 'c': 42.86});
      expect(byId.values.fold<double>(0, (s, v) => s + v), closeTo(100, 1e-9));
    });

    test('aynı arılığın lottaki hasatları toplanır; hasadı olmayan lotun '
        'geliri hareketin arılığına yazılır', () {
      final profits = apiaryProfits(
        [
          income(900, lotId: 'lot-1'),
          income(500, lotId: 'lot-empty', apiaryId: 'yayla'),
        ],
        year: 2026,
        currency: 'TRY',
        lotHarvests: const [
          (lotId: 'lot-1', apiaryId: 'cam', kg: 100),
          (lotId: 'lot-1', apiaryId: 'cam', kg: 200),
        ],
      );
      expect(
        {for (final p in profits) p.apiaryId: p.income},
        {'cam': 900, 'yayla': 500},
      );
    });

    test('gider bağlı arılığa, yoksa taşımanın varış arılığına yazılır', () {
      final profits = apiaryProfits(
        [
          expense(9800, transportId: 'move-1'),
          expense(3000, apiaryId: 'kestane', transportId: 'move-1'),
          expense(500, transportId: 'move-unknown'),
        ],
        year: 2026,
        currency: 'TRY',
        transportDestinations: const {'move-1': 'cam'},
      );
      expect(
        {for (final p in profits) p.apiaryId: p.expense},
        {'cam': 9800, 'kestane': 3000},
      );
    });

    test('net = gelir − gider; büyük net önce, zarar en sonda; kovan başı '
        'maliyet arılığın kovanıyla', () {
      final profits = apiaryProfits(
        [
          income(150000, apiaryId: 'cam'),
          expense(8000, apiaryId: 'cam'),
          income(5000, apiaryId: 'narenciye'),
          expense(8000, apiaryId: 'narenciye'),
          income(130000, apiaryId: 'kestane'),
          expense(12000, apiaryId: 'kestane'),
        ],
        year: 2026,
        currency: 'TRY',
        activeHives: const {'cam': 40, 'narenciye': 0},
      );
      expect(profits.map((p) => p.apiaryId), ['cam', 'kestane', 'narenciye']);
      expect(profits.first, (
        apiaryId: 'cam',
        income: 150000.0,
        expense: 8000.0,
        net: 142000.0,
        costPerHive: 200.0,
      ));
      expect(profits.last.net, -3000);
      expect(profits.last.costPerHive, isNull);
      expect(profits[1].costPerHive, isNull);
    });

    test('başka yıl, başka para birimi ve arılığa bağlanamayan hareket '
        'girmez', () {
      final profits = apiaryProfits(
        [
          income(100, apiaryId: 'cam', on: DateTime(2025, 12, 31)),
          income(100, apiaryId: 'cam', currency: 'EUR'),
          income(100),
          expense(100),
        ],
        year: 2026,
        currency: 'TRY',
      );
      expect(profits, isEmpty);
    });
  });
}
