import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';

void main() {
  group('bulkHiveNumbers', () {
    test("101'den 20 kovan: 101–120", () {
      final numbers = bulkHiveNumbers(start: '101', count: 20);

      expect(numbers, hasLength(20));
      expect(numbers.first, '101');
      expect(numbers.last, '120');
      expect(numbers.toSet(), hasLength(20));
    });

    test('tek kovan', () {
      expect(bulkHiveNumbers(start: '7', count: 1), ['7']);
    });

    test('baştaki sıfırlar korunur, hane aşılınca uzar', () {
      expect(bulkHiveNumbers(start: '001', count: 3), ['001', '002', '003']);
      expect(bulkHiveNumbers(start: '098', count: 4), [
        '098',
        '099',
        '100',
        '101',
      ]);
      expect(bulkHiveNumbers(start: '9', count: 2), ['9', '10']);
      expect(bulkHiveNumbers(start: '0', count: 2), ['0', '1']);
    });

    test('64 bit sınırını aşan numara da sayılır', () {
      expect(bulkHiveNumbers(start: '99999999999999999999', count: 2), [
        '99999999999999999999',
        '100000000000000000000',
      ]);
    });

    test('rakam dışı başlangıç reddedilir', () {
      for (final start in ['', ' 1', '1 ', 'A1', '-1', '1.5', '١٢']) {
        expect(
          () => bulkHiveNumbers(start: start, count: 1),
          throwsArgumentError,
          reason: start,
        );
        expect(isBulkStartNumber(start), isFalse, reason: start);
      }
    });

    test('sayı 1 ile üst sınır arasında olmalı', () {
      expect(
        bulkHiveNumbers(start: '1', count: maxBulkHiveCount),
        hasLength(maxBulkHiveCount),
      );
      for (final count in [0, -1, maxBulkHiveCount + 1]) {
        expect(
          () => bulkHiveNumbers(start: '1', count: count),
          throwsArgumentError,
          reason: '$count',
        );
      }
    });
  });

  group('durum', () {
    test('yalnız aktif kovan sayılır', () {
      expect(
        [
          for (final status in HiveStatus.values)
            if (status.isCounted) status,
        ],
        [HiveStatus.active],
      );
    });

    test('aktif sayıyı düşüren her geçiş onay ister', () {
      for (final to in HiveStatus.values) {
        expect(
          statusChangeNeedsConfirmation(from: HiveStatus.active, to: to),
          to != HiveStatus.active,
          reason: '$to',
        );
      }
    });

    test('aktif olmayandan geçişler onay istemez', () {
      for (final from in HiveStatus.values.where((s) => !s.isCounted)) {
        for (final to in HiveStatus.values) {
          expect(
            statusChangeNeedsConfirmation(from: from, to: to),
            isFalse,
            reason: '$from → $to',
          );
        }
      }
    });
  });
}
