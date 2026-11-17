import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_conflict.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';

final _base = DateTime.utc(2026, 11, 10, 9);

HiveStatusEvent _event(
  String id,
  HiveStatus from,
  HiveStatus to, {
  int minute = 0,
  String hiveId = 'hive-1',
  DateTime? deletedAt,
}) {
  final at = _base.add(Duration(minutes: minute));
  return HiveStatusEvent(
    id: id,
    orgId: 'org-1',
    hiveId: hiveId,
    apiaryId: 'apiary-1',
    fromStatus: from,
    toStatus: to,
    changedAt: at,
    createdAt: at,
    updatedAt: at,
    deletedAt: deletedAt,
  );
}

void main() {
  const active = HiveStatus.active;
  const dead = HiveStatus.dead;
  const sold = HiveStatus.sold;

  test('ardışık zincir çakışma değildir', () {
    expect(
      findStatusConflicts([
        _event('a', active, dead),
        _event('b', dead, active, minute: 5),
        _event('c', active, sold, minute: 9),
      ]),
      isEmpty,
    );
  });

  test('aynı durumdan iki farklı duruma geçiş çakışmadır', () {
    final conflicts = findStatusConflicts([
      _event('sold', active, sold, minute: 3),
      _event('dead', active, dead),
    ]);

    expect(conflicts, hasLength(1));
    final conflict = conflicts.single;
    expect(conflict.hiveId, 'hive-1');
    // Zaman sırasıyla: önce yazılan first.
    expect(conflict.first.id, 'dead');
    expect(conflict.second.id, 'sold');
  });

  test('iki cihaz aynı durumu yazdıysa da çakışmadır (kayıp iki kez '
      'sayılmasın)', () {
    final conflicts = findStatusConflicts([
      _event('a', active, dead),
      _event('b', active, dead, minute: 1),
    ]);

    expect(conflicts.single.second.id, 'b');
  });

  test('silinmiş olay sayılmaz; çözülen çakışma kaybolur', () {
    expect(
      findStatusConflicts([
        _event('a', active, dead),
        _event('b', active, sold, minute: 1, deletedAt: _base),
      ]),
      isEmpty,
    );
  });

  test('kovan başına en eski kopukluk; kovanlar ayrı', () {
    final conflicts = findStatusConflicts([
      _event('a1', active, dead),
      _event('a2', active, sold, minute: 1),
      _event('a3', active, HiveStatus.lost, minute: 2),
      _event('b1', active, dead, hiveId: 'hive-2', minute: 10),
      _event('b2', active, sold, hiveId: 'hive-2', minute: 11),
    ]);

    expect(conflicts.map((c) => (c.first.id, c.second.id)), [
      ('a1', 'a2'),
      ('b1', 'b2'),
    ]);
  });

  test('aynı anda yazılan olaylar oluşturulma ve kimlikle sıralanır', () {
    final first = _event('x', active, dead);
    final second = _event('y', active, sold);

    expect(compareStatusEvents(first, second), lessThan(0));
    expect(findStatusConflicts([second, first]).single.first.id, 'x');
  });
}
