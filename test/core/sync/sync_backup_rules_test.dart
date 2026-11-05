import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/sync/sync_backup_rules.dart';

void main() {
  group('isSyncOverdue', () {
    final now = DateTime(2026, 11, 5, 12);

    test('bekleyen yoksa gecikme yok', () {
      expect(isSyncOverdue(oldestPendingAt: null, now: now), isFalse);
    });

    test('en eski bekleyen 3 günü doldurunca gecikmiş sayılır', () {
      bool overdue(Duration age) =>
          isSyncOverdue(oldestPendingAt: now.subtract(age), now: now);

      expect(overdue(const Duration(days: 2, hours: 23)), isFalse);
      expect(overdue(const Duration(days: 3)), isTrue);
      expect(overdue(const Duration(days: 10)), isTrue);
    });

    test('saati ileride yazılmış kayıt gecikmiş sayılmaz', () {
      expect(
        isSyncOverdue(
          oldestPendingAt: now.add(const Duration(days: 5)),
          now: now,
        ),
        isFalse,
      );
    });
  });

  group('syncReminderAt', () {
    DateTime? at(DateTime oldest, {DateTime? now}) =>
        syncReminderAt(oldestPendingAt: oldest, now: now ?? DateTime(2026, 11));

    test('bekleyen yoksa bildirim yok', () {
      expect(
        syncReminderAt(oldestPendingAt: null, now: DateTime(2026, 11)),
        isNull,
      );
    });

    test('gündüz düşerse en eski kayıttan tam 3 gün sonra', () {
      expect(at(DateTime(2026, 11, 2, 14, 30)), DateTime(2026, 11, 5, 14, 30));
    });

    test("09:00'dan önce düşerse aynı gün 09:00'a kayar", () {
      expect(at(DateTime(2026, 11, 2, 3, 15)), DateTime(2026, 11, 5, 9));
    });

    test("21:00 ve sonrasına düşerse ertesi gün 09:00'a kayar", () {
      expect(at(DateTime(2026, 11, 2, 21)), DateTime(2026, 11, 6, 9));
      expect(at(DateTime(2026, 11, 30, 23)), DateTime(2026, 12, 4, 9));
    });

    test('an geçtiyse bildirim kurulmaz (uyarı ekranda)', () {
      expect(
        at(DateTime(2026, 11, 2, 14), now: DateTime(2026, 11, 5, 15)),
        isNull,
      );
    });

    test('UTC kayıt anı yerel saate çevrilir', () {
      final oldest = DateTime.utc(2026, 11, 2, 12);
      final local = oldest.toLocal();
      expect(
        at(oldest),
        anyOf(
          local.add(syncOverdueAfter),
          DateTime(local.year, local.month, local.day + 3, 9),
          DateTime(local.year, local.month, local.day + 4, 9),
        ),
      );
    });
  });

  group('daysSince', () {
    final now = DateTime(2026, 11, 5, 8);

    test('takvim gününe göre: bugün 0, dün 1', () {
      expect(daysSince(DateTime(2026, 11, 5, 0, 1), now), 0);
      expect(daysSince(DateTime(2026, 11, 4, 23, 59), now), 1);
      expect(daysSince(DateTime(2026, 11, 2, 18, 40), now), 3);
    });

    test('ileri tarih 0 sayılır', () {
      expect(daysSince(DateTime(2026, 11, 7), now), 0);
    });
  });
}
