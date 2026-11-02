import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/subsidies/domain/subsidy_rules.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';

SupportPeriod _period(String name, DateTime starts, DateTime ends) =>
    SupportPeriod(
      id: name,
      name: name,
      applicationStartsOn: starts,
      applicationEndsOn: ends,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

void main() {
  group('supportPeriodPhase', () {
    final period = _period('A', DateTime(2027, 1, 15), DateTime(2027, 2, 15));

    test('başlangıçtan önce yakında, iki gün dahil açık, sonra bitti', () {
      expect(
        supportPeriodPhase(period, DateTime(2027, 1, 14, 23, 59)),
        SupportPeriodPhase.upcoming,
      );
      expect(
        supportPeriodPhase(period, DateTime(2027, 1, 15)),
        SupportPeriodPhase.open,
      );
      expect(
        supportPeriodPhase(period, DateTime(2027, 2, 15, 23, 59)),
        SupportPeriodPhase.open,
      );
      expect(
        supportPeriodPhase(period, DateTime(2027, 2, 16)),
        SupportPeriodPhase.closed,
      );
    });

    test('tek günlük dönem o gün açık', () {
      final day = _period('B', DateTime(2027, 3), DateTime(2027, 3));
      expect(
        supportPeriodPhase(day, DateTime(2027, 3, 1, 18)),
        SupportPeriodPhase.open,
      );
    });
  });

  test('sortSupportPeriods: açıklar bitişe, yaklaşanlar başlangıca, '
      'bitenler en son bitene göre; eşitlikte ad', () {
    final today = DateTime(2027, 2);
    final openLate = _period('Açık geç', DateTime(2027), DateTime(2027, 3));
    final openSoonB = _period(
      'Açık yakın B',
      DateTime(2027, 1, 20),
      DateTime(2027, 2, 10),
    );
    final openSoonA = _period(
      'Açık yakın A',
      DateTime(2027, 1, 25),
      DateTime(2027, 2, 10),
    );
    final upcomingLate = _period(
      'Gelecek geç',
      DateTime(2027, 6),
      DateTime(2027, 7),
    );
    final upcomingSoon = _period(
      'Gelecek yakın',
      DateTime(2027, 3),
      DateTime(2027, 4),
    );
    final closedOld = _period('Bitmiş eski', DateTime(2026), DateTime(2026, 2));
    final closedRecent = _period(
      'Bitmiş yeni',
      DateTime(2026, 10),
      DateTime(2026, 12),
    );

    expect(
      sortSupportPeriods([
        closedOld,
        upcomingLate,
        openLate,
        closedRecent,
        openSoonB,
        upcomingSoon,
        openSoonA,
      ], today).map((period) => period.name),
      [
        'Açık yakın A',
        'Açık yakın B',
        'Açık geç',
        'Gelecek yakın',
        'Gelecek geç',
        'Bitmiş yeni',
        'Bitmiş eski',
      ],
    );
  });

  test('checkAksHiveCount: girilmemiş, aynı, farklı', () {
    expect(
      checkAksHiveCount(activeHives: 12, declared: null),
      AksHiveCountCheck.notDeclared,
    );
    expect(
      checkAksHiveCount(activeHives: 12, declared: 12),
      AksHiveCountCheck.matches,
    );
    expect(
      checkAksHiveCount(activeHives: 0, declared: 0),
      AksHiveCountCheck.matches,
    );
    expect(
      checkAksHiveCount(activeHives: 132, declared: 120),
      AksHiveCountCheck.differs,
    );
    expect(
      checkAksHiveCount(activeHives: 0, declared: 5),
      AksHiveCountCheck.differs,
    );
  });

  group('parseAksHiveCount', () {
    test('boş metin null; boşluk ve binlik ayırıcı yok sayılır', () {
      expect(parseAksHiveCount(''), isNull);
      expect(parseAksHiveCount('  '), isNull);
      expect(parseAksHiveCount('120'), 120);
      expect(parseAksHiveCount(' 1.200 '), 1200);
      expect(parseAksHiveCount('1 200'), 1200);
      expect(parseAksHiveCount('0'), 0);
      expect(parseAksHiveCount('100000'), maxAksHiveCount);
    });

    test('sayı değilse ya da sınırı aşarsa FormatException', () {
      for (final text in ['abc', '-5', '12a', '100001', '1e3']) {
        expect(
          () => parseAksHiveCount(text),
          throwsFormatException,
          reason: text,
        );
      }
    });
  });

  test('aksTaskDueAt: değişikliğin ertesi günü 09:00 (yerel), UTC', () {
    final changedAt = DateTime(2026, 11, 5, 22, 30);
    final due = aksTaskDueAt(changedAt);
    expect(due.isUtc, isTrue);
    expect(due.toLocal(), DateTime(2026, 11, 6, aksTaskHour));
    // Ay sonu.
    expect(
      aksTaskDueAt(DateTime(2026, 11, 30, 8)).toLocal(),
      DateTime(2026, 12, 1, aksTaskHour),
    );
  });
}
