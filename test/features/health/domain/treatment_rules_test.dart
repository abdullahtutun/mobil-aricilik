import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/treatment_rules.dart';

Treatment _treatment(
  String id, {
  required DrugActiveIngredient ingredient,
  required int day,
  String? applicationId,
  DateTime? deletedAt,
}) => Treatment(
  id: id,
  orgId: 'org-1',
  hiveId: 'hive-$id',
  apiaryId: 'apiary-1',
  refDrugId: 'ref-1',
  applicationId: applicationId,
  productName: 'İlaç',
  activeIngredient: ingredient,
  dose: 1,
  doseUnit: DrugDoseUnit.strip,
  startedAt: DateTime.utc(2026, 10, day, 9),
  withdrawalDays: 0,
  createdAt: DateTime.utc(2026, 10, day),
  updatedAt: DateTime.utc(2026, 10, day),
  deletedAt: deletedAt,
);

const DrugActiveIngredient _amitraz = DrugActiveIngredient.amitraz;
const DrugActiveIngredient _oxalic = DrugActiveIngredient.oxalicAcid;

void main() {
  group('sameIngredientStreak', () {
    test('uygulama yoksa 0', () {
      expect(sameIngredientStreak(const [], _amitraz), 0);
    });

    test('en sondan geriye aynı etken maddeleri sayar; farklıda durur', () {
      final treatments = [
        _treatment('a', ingredient: _amitraz, day: 1),
        _treatment('b', ingredient: _oxalic, day: 5),
        _treatment('c', ingredient: _amitraz, day: 10),
        _treatment('d', ingredient: _amitraz, day: 20),
      ];

      expect(sameIngredientStreak(treatments, _amitraz), 2);
      expect(sameIngredientStreak(treatments, _oxalic), 0);
    });

    test('verilen sıra önemli değil; başlangıca göre sıralanır', () {
      final treatments = [
        _treatment('d', ingredient: _amitraz, day: 20),
        _treatment('a', ingredient: _oxalic, day: 1),
        _treatment('c', ingredient: _amitraz, day: 10),
      ];

      expect(sameIngredientStreak(treatments.reversed, _amitraz), 2);
    });

    test('toplu uygulama (aynı grup) tek uygulama sayılır', () {
      final treatments = [
        for (final hive in ['1', '2', '3'])
          _treatment(
            'g1-$hive',
            ingredient: _amitraz,
            day: 10,
            applicationId: 'g1',
          ),
        for (final hive in ['1', '2'])
          _treatment(
            'g2-$hive',
            ingredient: _amitraz,
            day: 20,
            applicationId: 'g2',
          ),
      ];

      expect(sameIngredientStreak(treatments, _amitraz), 2);
    });

    test('grupsuz eski kayıt kendi grubudur', () {
      final treatments = [
        _treatment('a', ingredient: _amitraz, day: 10),
        _treatment('b', ingredient: _amitraz, day: 10),
      ];

      expect(sameIngredientStreak(treatments, _amitraz), 2);
    });

    test('silinmiş uygulama sayılmaz ve seriyi bölmez', () {
      final treatments = [
        _treatment('a', ingredient: _amitraz, day: 1),
        _treatment(
          'b',
          ingredient: _oxalic,
          day: 5,
          deletedAt: DateTime.utc(2026, 10, 6),
        ),
        _treatment('c', ingredient: _amitraz, day: 10),
      ];

      expect(sameIngredientStreak(treatments, _amitraz), 2);
    });

    test('"diğer" etken madde karşılaştırılamaz', () {
      final treatments = [
        _treatment('a', ingredient: DrugActiveIngredient.other, day: 1),
        _treatment('b', ingredient: DrugActiveIngredient.other, day: 2),
      ];

      expect(sameIngredientStreak(treatments, DrugActiveIngredient.other), 0);
    });
  });

  test('uyarı üst üste $rotationWarningStreak uygulamadan itibaren', () {
    expect(needsRotationWarning(0), isFalse);
    expect(needsRotationWarning(rotationWarningStreak - 1), isFalse);
    expect(needsRotationWarning(rotationWarningStreak), isTrue);
    expect(needsRotationWarning(rotationWarningStreak + 3), isTrue);
  });

  group('removalReminderAt', () {
    final now = DateTime(2026, 10, 25, 14);

    test('çıkarma günü sabah 9 (yerel)', () {
      expect(
        removalReminderAt(DateTime(2026, 12, 5, 12).toUtc(), now: now),
        DateTime(2026, 12, 5, removalReminderHour),
      );
    });

    test('çıkarma yoksa hatırlatma yok', () {
      expect(removalReminderAt(null, now: now), isNull);
    });

    test('saati geçmişse kurulmaz; bugün saatinden önceyse kurulur', () {
      expect(removalReminderAt(DateTime(2026, 10, 25, 12), now: now), isNull);
      expect(removalReminderAt(DateTime(2026, 10, 20), now: now), isNull);
      expect(
        removalReminderAt(
          DateTime(2026, 10, 25, 12),
          now: DateTime(2026, 10, 25, 8),
        ),
        DateTime(2026, 10, 25, removalReminderHour),
      );
    });
  });

  test('bildirim kimliği grupla sabit, pozitif 31 bit ve gruplar '
      'arasında farklı', () {
    final ids = {
      for (var i = 0; i < 1000; i++) removalReminderId('0199a3b2-7c1e-$i'),
    };

    expect(removalReminderId('g1'), removalReminderId('g1'));
    expect(ids, hasLength(1000));
    for (final id in ids) {
      expect(id, inInclusiveRange(0, 0x7fffffff));
    }
  });
}
