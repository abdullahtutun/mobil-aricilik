import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';

/// Yerel takvimde [day] günü, saat [hour].
DateTime _at(int month, int day, [int hour = 9]) =>
    DateTime(2026, month, day, hour);

Treatment _treatment({
  String id = 'treatment-1',
  String hiveId = 'hive-1',
  DateTime? startedAt,
  DateTime? plannedRemovalAt,
  int withdrawalDays = 0,
  DateTime? deletedAt,
}) => Treatment(
  id: id,
  orgId: 'org-1',
  hiveId: hiveId,
  apiaryId: 'apiary-1',
  refDrugId: 'ref-drug-1',
  productName: 'Amitraz şerit',
  activeIngredient: DrugActiveIngredient.amitraz,
  dose: 2,
  doseUnit: DrugDoseUnit.strip,
  startedAt: (startedAt ?? _at(10, 24)).toUtc(),
  plannedRemovalAt: plannedRemovalAt?.toUtc(),
  withdrawalDays: withdrawalDays,
  createdAt: DateTime.utc(2026, 10, 24),
  updatedAt: DateTime.utc(2026, 10, 24),
  deletedAt: deletedAt,
);

void main() {
  group('withdrawalEndDate', () {
    test('planlanan çıkarma günü + bekleme günü; gün başı', () {
      expect(
        withdrawalEndDate(
          startedAt: _at(10, 24),
          plannedRemovalAt: _at(12, 5, 15),
          withdrawalDays: 14,
        ),
        DateTime(2026, 12, 19),
      );
    });

    test('bekleme 0 ise çıkarma günü', () {
      expect(
        withdrawalEndDate(
          startedAt: _at(10, 24),
          plannedRemovalAt: _at(12, 5),
          withdrawalDays: 0,
        ),
        DateTime(2026, 12, 5),
      );
    });

    test('çıkarma yoksa (tek seferlik) başlangıç günü + bekleme', () {
      expect(
        withdrawalEndDate(startedAt: _at(10, 24, 18), withdrawalDays: 7),
        DateTime(2026, 10, 31),
      );
    });

    test('ay ve yıl sınırını geçer', () {
      expect(
        withdrawalEndDate(
          startedAt: _at(12, 1),
          plannedRemovalAt: _at(12, 20),
          withdrawalDays: 30,
        ),
        DateTime(2027, 1, 19),
      );
    });

    test('UTC saklanan zaman yerel güne çevrilir', () {
      final local = DateTime(2026, 10, 24, 0, 30);
      expect(
        withdrawalEndDate(startedAt: local.toUtc(), withdrawalDays: 1),
        DateTime(2026, 10, 25),
      );
    });

    test(
      'treatmentWithdrawalEnd uygulamanın alanlarıyla aynı sonucu verir',
      () {
        final treatment = _treatment(
          plannedRemovalAt: _at(12, 5),
          withdrawalDays: 3,
        );
        expect(treatmentWithdrawalEnd(treatment), DateTime(2026, 12, 8));
      },
    );
  });

  group('withdrawalLock', () {
    test('uygulama yoksa kilit yok', () {
      expect(withdrawalLock(const [], now: _at(10, 25)), isNull);
    });

    test('tasarımdaki örnek: 24 Eki şerit, 5 Ara çıkarma → 42 gün kalan', () {
      final treatment = _treatment(plannedRemovalAt: _at(12, 5));

      expect(withdrawalLock([treatment], now: _at(10, 24, 10)), (
        treatment: treatment,
        until: DateTime(2026, 12, 5),
        daysLeft: 42,
      ));
    });

    test('başlangıç günü kilitli, saatinden önce de', () {
      final treatment = _treatment(
        startedAt: _at(10, 24, 18),
        plannedRemovalAt: _at(12, 5),
      );

      expect(withdrawalLock([treatment], now: _at(10, 24, 6)), isNotNull);
    });

    test('bitişten önceki gün kilitli (1 gün kalan), bitiş günü serbest', () {
      final treatment = _treatment(
        plannedRemovalAt: _at(12, 5),
        withdrawalDays: 2,
      );

      expect(withdrawalLock([treatment], now: _at(12, 6, 23))?.daysLeft, 1);
      expect(withdrawalLock([treatment], now: _at(12, 7, 0)), isNull);
      expect(withdrawalLock([treatment], now: _at(12, 20)), isNull);
    });

    test('çıkarma günü geçse de bekleme süresi bitene kadar kilitli', () {
      final treatment = _treatment(
        plannedRemovalAt: _at(12, 5),
        withdrawalDays: 14,
      );

      final lock = withdrawalLock([treatment], now: _at(12, 10))!;
      expect(lock.until, DateTime(2026, 12, 19));
      expect(lock.daysLeft, 9);
    });

    test('tek seferlik uygulama beklemesizse hiç kilitlemez', () {
      final treatment = _treatment();

      expect(withdrawalLock([treatment], now: _at(10, 24, 12)), isNull);
    });

    test('tek seferlik uygulama bekleme süresince kilitler', () {
      final treatment = _treatment(withdrawalDays: 3);

      expect(withdrawalLock([treatment], now: _at(10, 26))?.daysLeft, 1);
      expect(withdrawalLock([treatment], now: _at(10, 27)), isNull);
    });

    test('başlangıcı gelecekte olan uygulama henüz kilitlemez', () {
      final treatment = _treatment(
        startedAt: _at(11, 1),
        plannedRemovalAt: _at(12, 5),
      );

      expect(withdrawalLock([treatment], now: _at(10, 31, 23)), isNull);
      expect(withdrawalLock([treatment], now: _at(11, 1, 0)), isNotNull);
    });

    test('silinmiş uygulama kilitlemez', () {
      final treatment = _treatment(
        plannedRemovalAt: _at(12, 5),
        deletedAt: DateTime.utc(2026, 10, 25),
      );

      expect(withdrawalLock([treatment], now: _at(10, 25)), isNull);
    });

    test('birden çok uygulamada kilidi en geç kalkan döner', () {
      final early = _treatment(id: 'early', plannedRemovalAt: _at(11, 10));
      final late = _treatment(
        id: 'late',
        startedAt: _at(10, 1),
        plannedRemovalAt: _at(11, 1),
        withdrawalDays: 30,
      );
      final over = _treatment(
        id: 'over',
        startedAt: _at(9, 1),
        plannedRemovalAt: _at(9, 20),
      );

      final lock = withdrawalLock([early, over, late], now: _at(10, 25))!;
      expect(lock.treatment.id, 'late');
      expect(lock.until, DateTime(2026, 12));
    });

    test('eşit bitişte en son başlayan döner; sıra önemli değil', () {
      final first = _treatment(
        id: 'first',
        startedAt: _at(10, 20),
        plannedRemovalAt: _at(12, 5),
      );
      final second = _treatment(
        id: 'second',
        startedAt: _at(10, 24),
        plannedRemovalAt: _at(12, 5),
      );

      expect(
        withdrawalLock([first, second], now: _at(10, 25))!.treatment.id,
        'second',
      );
      expect(
        withdrawalLock([second, first], now: _at(10, 25))!.treatment.id,
        'second',
      );
    });

    test('kalan gün yaz saati geçişinden etkilenmez', () {
      // Avrupa'da 25 Ekim 2026'da saatler geri alınır; takvim günü sayılır.
      final treatment = _treatment(
        startedAt: _at(10, 20),
        plannedRemovalAt: _at(10, 30),
      );

      expect(withdrawalLock([treatment], now: _at(10, 24, 23))?.daysLeft, 6);
      expect(withdrawalLock([treatment], now: _at(10, 26, 1))?.daysLeft, 4);
    });

    test('her gün için: kilit varsa kalan gün en az 1, bitiş gelecekte ve '
        'başlamış hiçbir uygulamanın bitişi daha geç değil; kilit yoksa '
        'başlamış her uygulamanın süresi dolmuş', () {
      final treatments = [
        _treatment(id: 'a', plannedRemovalAt: _at(11, 5), withdrawalDays: 5),
        _treatment(id: 'b', startedAt: _at(11, 1), withdrawalDays: 20),
        _treatment(id: 'c', startedAt: _at(10, 1)),
      ];
      for (var day = 0; day < 90; day++) {
        final now = DateTime(2026, 9, 25 + day, 12);
        final today = DateTime(now.year, now.month, now.day);
        final started = [
          for (final treatment in treatments)
            if (!treatment.startedAt.toLocal().isAfter(now)) treatment,
        ];
        final lock = withdrawalLock(treatments, now: now);
        if (lock == null) {
          for (final treatment in started) {
            expect(
              treatmentWithdrawalEnd(treatment).isAfter(today),
              isFalse,
              reason: '$now',
            );
          }
          continue;
        }
        expect(lock.daysLeft, greaterThanOrEqualTo(1), reason: '$now');
        expect(lock.until.isAfter(today), isTrue, reason: '$now');
        expect(started, contains(lock.treatment), reason: '$now');
        for (final treatment in started) {
          final end = treatmentWithdrawalEnd(treatment);
          expect(end.isAfter(lock.until), isFalse, reason: '$now');
        }
      }
    });
  });

  group('defaultPlannedRemoval', () {
    test('şeritte başlangıçtan 42 gün sonra', () {
      expect(
        defaultPlannedRemoval(DrugDoseUnit.strip, DateTime(2026, 10, 24)),
        DateTime(2026, 12, 5),
      );
    });

    test('ürün bilgisinde süre varsa şeritte o kadar gün sonra', () {
      expect(
        defaultPlannedRemoval(
          DrugDoseUnit.strip,
          DateTime(2026, 10, 24),
          treatmentDays: 63,
        ),
        DateTime(2026, 12, 26),
      );
    });

    test('ml, g ve dozda çıkarma yok (tek seferlik), süre verilse de', () {
      for (final unit in [DrugDoseUnit.ml, DrugDoseUnit.g, DrugDoseUnit.dose]) {
        expect(defaultPlannedRemoval(unit, DateTime(2026, 10, 24)), isNull);
        expect(
          defaultPlannedRemoval(
            unit,
            DateTime(2026, 10, 24),
            treatmentDays: 42,
          ),
          isNull,
        );
      }
    });
  });

  group('withdrawalLocksByHive', () {
    test('kovan başına en geç kalkan kilit; kilitsiz kovan haritada yok', () {
      final locks = withdrawalLocksByHive([
        _treatment(id: 'early', withdrawalDays: 5),
        _treatment(id: 'late', withdrawalDays: 20),
        _treatment(id: 'other', hiveId: 'hive-2', withdrawalDays: 3),
        _treatment(id: 'done', hiveId: 'hive-3', withdrawalDays: 1),
      ], now: _at(10, 26));

      expect(locks.keys, unorderedEquals(['hive-1', 'hive-2']));
      expect(locks['hive-1']!.treatment.id, 'late');
      expect(locks['hive-1']!.daysLeft, 18);
      expect(locks['hive-2']!.until, DateTime(2026, 10, 27));
    });

    test('gün, verilen ana göre: uygulamadan önceki gün kilit yok', () {
      expect(
        withdrawalLocksByHive([
          _treatment(withdrawalDays: 20),
        ], now: _at(10, 23, 23)),
        isEmpty,
      );
    });
  });
}
