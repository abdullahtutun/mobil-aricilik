import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/team/domain/activity_rules.dart';

ActivityRecord _record(
  ActivityKind kind,
  String userId,
  DateTime at, {
  String? apiaryId = 'a1',
}) => (
  kind: kind,
  userId: userId,
  at: at,
  apiaryId: apiaryId,
  apiaryName: apiaryId,
);

void main() {
  final t0 = DateTime.utc(2026, 10, 27, 12);

  group('groupActivity', () {
    test('art arda aynı kişi, tür ve arılık tek satır olur', () {
      final entries = groupActivity([
        for (var i = 0; i < 12; i++)
          _record(
            ActivityKind.inspection,
            'u1',
            t0.subtract(Duration(minutes: i)),
          ),
      ]);

      expect(entries, hasLength(1));
      expect(entries.single.count, 12);
      expect(entries.single.at, t0);
    });

    test('kişi, tür ya da arılık değişince ayrı satır olur', () {
      final entries = groupActivity([
        _record(ActivityKind.inspection, 'u1', t0),
        _record(
          ActivityKind.inspection,
          'u2',
          t0.subtract(const Duration(minutes: 1)),
        ),
        _record(
          ActivityKind.feeding,
          'u2',
          t0.subtract(const Duration(minutes: 2)),
        ),
        _record(
          ActivityKind.feeding,
          'u2',
          t0.subtract(const Duration(minutes: 3)),
          apiaryId: 'a2',
        ),
      ]);

      expect(entries.map((e) => e.count), [1, 1, 1, 1]);
    });

    test('aradaki süre pencereyi aşarsa ayrı satır olur', () {
      final entries = groupActivity([
        _record(ActivityKind.treatment, 'u1', t0),
        _record(
          ActivityKind.treatment,
          'u1',
          t0.subtract(activityGroupWindow + const Duration(seconds: 1)),
        ),
      ]);

      expect(entries, hasLength(2));
    });

    test('sıra gelmese de yeniden eskiye dizer ve sınırı uygular', () {
      final entries = groupActivity(
        [
          for (var i = 0; i < 8; i++)
            _record(
              ActivityKind.task,
              'u${i % 2}',
              t0.subtract(Duration(hours: i)),
            ),
        ].reversed,
        limit: 3,
      );

      expect(entries, hasLength(3));
      expect(entries.first.at, t0);
    });
  });

  group('activityAge', () {
    final now = DateTime(2026, 10, 27, 15);

    ActivityAge age(DateTime at) => activityAge(at, now);

    test('dakika, saat, dün, gün ve tarih', () {
      expect(age(now).unit, ActivityAgeUnit.justNow);
      expect(age(now.subtract(const Duration(minutes: 5))), (
        unit: ActivityAgeUnit.minutes,
        value: 5,
      ));
      expect(age(now.subtract(const Duration(hours: 2))), (
        unit: ActivityAgeUnit.hours,
        value: 2,
      ));
      expect(age(DateTime(2026, 10, 26, 23)).unit, ActivityAgeUnit.yesterday);
      expect(age(DateTime(2026, 10, 24, 9)), (
        unit: ActivityAgeUnit.days,
        value: 3,
      ));
      expect(age(DateTime(2026, 10, 10)).unit, ActivityAgeUnit.date);
    });
  });
}
