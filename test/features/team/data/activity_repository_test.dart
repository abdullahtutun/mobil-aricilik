import 'package:drift/drift.dart' show Variable;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/team/data/activity_repository.dart';
import 'package:mobil_arici/features/team/domain/activity_rules.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TaskRepository tasks;
  late ActivityRepository activity;
  const org = 'org-1';

  setUp(() {
    db = openTestDatabase();
    tasks = TaskRepository(db);
    activity = ActivityRepository(db);
  });

  tearDown(() => db.close());

  /// Sunucu `created_by`'ı senkronla doldurur.
  Future<void> stamp(String id, String? userId) => db.customUpdate(
    'update tasks set created_by = ? where id = ?',
    variables: [Variable<String>(userId), Variable<String>(id)],
    updates: {db.tasks},
  );

  test('created_by dolu kayıtlar kişi ve türle gelir', () async {
    final first = await tasks.create(
      orgId: org,
      title: 'Şurup',
      dueAt: DateTime.utc(2026, 11),
    );
    final second = await tasks.create(
      orgId: org,
      title: 'Ana arı',
      dueAt: DateTime.utc(2026, 11),
    );
    await stamp(first.id, 'u1');
    await stamp(second.id, 'u2');

    final records = await activity.watchRecent(org).first;

    expect(records.map((r) => r.userId).toSet(), {'u1', 'u2'});
    expect(records, hasLength(2));
    expect(records.every((r) => r.kind == ActivityKind.task), isTrue);
  });

  test('senkrona ulaşmamış, silinmiş ve başka işletmenin kaydı yok', () async {
    final pending = await tasks.create(
      orgId: org,
      title: 'Bekliyor',
      dueAt: DateTime.utc(2026, 11),
    );
    final deleted = await tasks.create(
      orgId: org,
      title: 'Silindi',
      dueAt: DateTime.utc(2026, 11),
    );
    final other = await tasks.create(
      orgId: 'org-2',
      title: 'Başkası',
      dueAt: DateTime.utc(2026, 11),
    );
    await stamp(deleted.id, 'u1');
    await stamp(other.id, 'u1');
    await tasks.delete(deleted.id);
    expect(pending.createdBy, isNull);

    expect(await activity.watchRecent(org).first, isEmpty);
  });

  test('arılık adı gelir; yeni kayıt akışı günceller', () async {
    final apiary = await ApiaryRepository(db)
        .create(orgId: org, name: 'Kızılçam');
    final task = await tasks.create(
      orgId: org,
      title: 'Kovanlara bak',
      dueAt: DateTime.utc(2026, 11),
      apiaryId: apiary.id,
    );
    await stamp(task.id, 'u1');

    final stream = activity.watchRecent(org);
    final emissions = <int>[];
    final subscription = stream.listen((rows) => emissions.add(rows.length));
    await pumpEventQueue();

    final next = await tasks.create(
      orgId: org,
      title: 'Bir daha',
      dueAt: DateTime.utc(2026, 11),
    );
    await stamp(next.id, 'u2');
    await pumpEventQueue();
    await subscription.cancel();

    final rows = await stream.first;
    expect(emissions.first, 1);
    expect(rows, hasLength(2));
    expect(rows.firstWhere((r) => r.userId == 'u1').apiaryName, 'Kızılçam');
  });
}
