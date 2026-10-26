import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/harvest/domain/harvest_rules.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

Hive _hive(String number) => Hive(
  id: 'hive-$number',
  orgId: 'org-1',
  number: number,
  type: HiveType.langstroth,
  apiaryId: 'apiary-1',
  createdAt: DateTime.utc(2026, 10, 22),
  updatedAt: DateTime.utc(2026, 10, 22),
);

WithdrawalLock _lock(String hiveId) => (
  treatment: Treatment(
    id: 'treatment-$hiveId',
    orgId: 'org-1',
    hiveId: hiveId,
    apiaryId: 'apiary-1',
    refDrugId: 'ref-drug-1',
    productName: 'Amitraz şerit',
    activeIngredient: DrugActiveIngredient.amitraz,
    dose: 2,
    doseUnit: DrugDoseUnit.strip,
    startedAt: DateTime.utc(2026, 10, 24),
    withdrawalDays: 14,
    createdAt: DateTime.utc(2026, 10, 24),
    updatedAt: DateTime.utc(2026, 10, 24),
  ),
  until: DateTime(2026, 11, 7),
  daysLeft: 12,
);

void main() {
  group('parseHarvestWeight', () {
    test('tam sayı, virgüllü ve noktalı ondalık', () {
      expect(parseHarvestWeight('574'), 574);
      expect(parseHarvestWeight(' 574,5 '), 574.5);
      expect(parseHarvestWeight('17.25'), 17.25);
      expect(parseHarvestWeight('0,125'), 0.125);
    });

    test('boş, sıfır, basamak ayracı ve bozuk yazı null', () {
      for (final text in [
        '',
        '0',
        '0,0',
        '1.234,5',
        '1,234.5',
        '12,',
        ',5',
        '5,1234',
        '-3',
        'abc',
        '1234567',
      ]) {
        expect(parseHarvestWeight(text), isNull, reason: text);
      }
    });
  });

  group('storedHarvestKg', () {
    test('kilogram aynen, üç ondalığa yuvarlanır', () {
      expect(storedHarvestKg(574.5, MassUnit.kilogram), 574.5);
      expect(storedHarvestKg(1.23456, MassUnit.kilogram), 1.235);
    });

    test('pound kilograma çevrilir', () {
      expect(storedHarvestKg(100, MassUnit.pound), 45.359);
    });
  });

  test('isValidHarvestAmount: sunucunun sınırları', () {
    expect(isValidHarvestAmount(unitCount: 1, netKg: 0.001), isTrue);
    expect(
      isValidHarvestAmount(
        unitCount: maxHarvestUnitCount,
        netKg: maxHarvestNetKg,
      ),
      isTrue,
    );
    expect(isValidHarvestAmount(unitCount: 0, netKg: 10), isFalse);
    expect(isValidHarvestAmount(unitCount: 1001, netKg: 10), isFalse);
    expect(isValidHarvestAmount(unitCount: 1, netKg: 0), isFalse);
    expect(isValidHarvestAmount(unitCount: 1, netKg: 100000.5), isFalse);
    expect(isValidHarvestAmount(unitCount: 1, netKg: double.nan), isFalse);
  });

  group('harvestTargets', () {
    final hives = [_hive('110'), _hive('104'), _hive('9'), _hive('108')];

    test('seçili kovanlar numara sırasıyla; seçilmeyenler dışarıda', () {
      final targets = harvestTargets(
        hives: hives,
        selected: {'hive-110', 'hive-9', 'hive-104'},
        locks: const {},
        overrides: const {},
      );

      expect(
        [for (final h in targets.harvested) h.number],
        ['9', '104', '110'],
      );
      expect(targets.locked, isEmpty);
    });

    test('kilitli kovan seçili olsa da alınmaz; seçilmemiş kilitli kovan da '
        '"alınmadı" listesinde', () {
      final targets = harvestTargets(
        hives: hives,
        selected: {'hive-104', 'hive-110'},
        locks: {'hive-104': _lock('hive-104'), 'hive-108': _lock('hive-108')},
        overrides: const {},
      );

      expect([for (final h in targets.harvested) h.number], ['110']);
      expect([for (final h in targets.locked) h.number], ['104', '108']);
    });

    test('gerekçesi olan kilitli kovan seçiliyse alınır', () {
      const override = WithdrawalOverride(
        treatmentId: 'treatment-hive-104',
        reason: WithdrawalOverrideReason.removedEarly,
      );
      final targets = harvestTargets(
        hives: hives,
        selected: {'hive-104'},
        locks: {'hive-104': _lock('hive-104')},
        overrides: {'hive-104': override},
      );

      expect([for (final h in targets.harvested) h.number], ['104']);
      expect(targets.locked, isEmpty);
    });
  });

  test('harvestPerHive: ortalama; kovan yoksa null', () {
    expect(harvestPerHive(574, 22), closeTo(26.09, 0.01));
    expect(harvestPerHive(574, 0), isNull);
  });
}
