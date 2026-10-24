import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/hives/domain/hive_timeline.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

final _start = DateTime.utc(2026, 10, 1, 9);

HiveLocationEntry _entry(String id, String apiaryId, {required int day}) {
  final at = _start.add(Duration(days: day));
  return HiveLocationEntry(
    id: id,
    orgId: 'org-1',
    hiveId: 'hive-1',
    apiaryId: apiaryId,
    movedAt: at,
    createdAt: at,
    updatedAt: at,
  );
}

Inspection _inspection(String id, {required int day}) {
  final at = _start.add(Duration(days: day));
  return Inspection(
    id: id,
    orgId: 'org-1',
    hiveId: 'hive-1',
    apiaryId: 'yayla',
    inspectedAt: at,
    createdAt: at,
    updatedAt: at,
  );
}

void main() {
  group('locationEvents', () {
    test('ilk kayıt kovanın eklendiği arılık; sonrakiler bir öncekinden '
        'taşıma', () {
      final events = locationEvents([
        _entry('l1', 'yayla', day: 0),
        _entry('l2', 'ova', day: 5),
        _entry('l3', 'yayla', day: 9),
      ]);

      expect(
        [for (final e in events) (e.id, e.fromApiaryId, e.toApiaryId)],
        [('l1', null, 'yayla'), ('l2', 'yayla', 'ova'), ('l3', 'ova', 'yayla')],
      );
      expect(events.first.at, _start);
    });

    test('kayıtlar herhangi bir sırada gelebilir', () {
      final events = locationEvents([
        _entry('l3', 'yayla', day: 9),
        _entry('l1', 'yayla', day: 0),
        _entry('l2', 'ova', day: 5),
      ]);

      expect([for (final e in events) e.fromApiaryId], [null, 'yayla', 'ova']);
    });

    test('aynı andaki kayıtlarda önce kimliği küçük olan', () {
      final events = locationEvents([
        _entry('l2', 'ova', day: 0),
        _entry('l1', 'yayla', day: 0),
      ]);

      expect(
        [for (final e in events) (e.id, e.fromApiaryId)],
        [('l1', null), ('l2', 'yayla')],
      );
    });

    test('boş geçmiş', () {
      expect(locationEvents(const []), isEmpty);
    });
  });

  group('sortTimeline', () {
    test('türler karışık, en yeni önce', () {
      final timeline = sortTimeline([
        ...locationEvents([
          _entry('l1', 'yayla', day: 0),
          _entry('l2', 'ova', day: 5),
        ]),
        ...inspectionEvents([
          _inspection('i1', day: 2),
          _inspection('i2', day: 8),
        ]),
      ]);

      expect([for (final e in timeline) e.id], ['i2', 'l2', 'i1', 'l1']);
      expect(timeline.first, isA<InspectionEvent>());
      expect(timeline.last, isA<LocationEvent>());
    });

    test('aynı andaki olaylarda kimliği büyük (sonra yazılan) önce', () {
      final timeline = sortTimeline(
        inspectionEvents([
          _inspection('0199-a', day: 3),
          _inspection('0199-b', day: 3),
        ]),
      );

      expect([for (final e in timeline) e.id], ['0199-b', '0199-a']);
    });

    test('olay muayenenin kendisini ve zamanını taşır', () {
      final inspection = _inspection('i1', day: 4);
      final [event] = inspectionEvents([inspection]);

      expect(event.inspection, inspection);
      expect(event.at, inspection.inspectedAt);
    });

    test('boş tünel', () {
      expect(sortTimeline(const []), isEmpty);
    });
  });
}
