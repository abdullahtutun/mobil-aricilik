import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

final _created = DateTime.utc(2026, 10, 20);

TaskView _view(
  String id,
  DateTime dueAt, {
  String? apiaryId,
  String? apiaryName,
  String? assignedTo,
  DateTime? completedAt,
  DateTime? deletedAt,
}) => (
  task: Task(
    id: id,
    orgId: 'org-1',
    title: id,
    dueAt: dueAt.toUtc(),
    apiaryId: apiaryId,
    assignedTo: assignedTo,
    completedAt: completedAt,
    deletedAt: deletedAt,
    createdAt: _created,
    updatedAt: _created,
  ),
  apiaryName: apiaryName,
  hiveNumber: null,
);

List<String> _ids(Iterable<TaskView> views) => [
  for (final view in views) view.task.id,
];

void main() {
  // Cumartesi 24 Ekim 2026, öğleden sonra (yerel).
  final now = DateTime(2026, 10, 24, 15);

  group('overdueDays', () {
    test('günü geçmiş görev takvim günüyle sayılır; saat önemsiz', () {
      expect(overdueDays(DateTime(2026, 10, 19, 23), now: now), 5);
      expect(overdueDays(DateTime(2026, 10, 23, 23, 59), now: now), 1);
    });

    test('bugün, saati geçmiş olsa da gecikmiş sayılmaz; ilerisi 0', () {
      expect(overdueDays(DateTime(2026, 10, 24, 8), now: now), 0);
      expect(overdueDays(DateTime(2026, 10, 30), now: now), 0);
    });

    test('yaz saati geçişinde tam gün', () {
      // Türkiye'de yaz saati yok; yerel saat dilimi ne olursa olsun takvim
      // günü sayılır.
      expect(
        overdueDays(DateTime(2026, 3, 28, 12), now: DateTime(2026, 3, 30, 1)),
        2,
      );
    });

    test('isOverdue tamamlananı gecikmiş saymaz', () {
      final late = _view('a', DateTime(2026, 10, 20)).task;
      expect(isOverdue(late, now: now), isTrue);
      expect(
        isOverdue(late.copyWith(completedAt: _created), now: now),
        isFalse,
      );
    });
  });

  group('tasksByDay', () {
    final tasks = [
      _view('tomorrow', DateTime(2026, 10, 25, 9)),
      _view('overdue-2', DateTime(2026, 10, 22, 9)),
      _view('today-late', DateTime(2026, 10, 24, 18)),
      _view('overdue-5', DateTime(2026, 10, 19, 9)),
      _view('today-early', DateTime(2026, 10, 24, 7)),
      _view('in-6', DateTime(2026, 10, 30, 9)),
      _view('in-7', DateTime(2026, 10, 31, 9)),
      _view('done', DateTime(2026, 10, 24, 9), completedAt: _created),
      _view('deleted', DateTime(2026, 10, 24, 9), deletedAt: _created),
    ];

    test('bugün: önce gecikmişler, sonra bugün; son tarih sırasıyla', () {
      final groups = tasksByDay(tasks, now: now, days: 1);

      expect([for (final g in groups) g.day], [null, DateTime(2026, 10, 24)]);
      expect(_ids(groups[0].tasks), ['overdue-5', 'overdue-2']);
      expect(_ids(groups[1].tasks), ['today-early', 'today-late']);
    });

    test('bu hafta: bugünden 7 gün; görevi olmayan gün ve aralık dışı '
        'düşer', () {
      final groups = tasksByDay(tasks, now: now, days: taskWeekDays);

      expect(
        [for (final g in groups) g.day],
        [
          null,
          DateTime(2026, 10, 24),
          DateTime(2026, 10, 25),
          DateTime(2026, 10, 30),
        ],
      );
      expect([
        for (final g in groups) ..._ids(g.tasks),
      ], isNot(contains('in-7')));
    });

    test('tamamlanan ve silinen görev hiçbir gruba girmez', () {
      final ids = [
        for (final g in tasksByDay(tasks, now: now, days: 7)) ..._ids(g.tasks),
      ];
      expect(ids, isNot(contains('done')));
      expect(ids, isNot(contains('deleted')));
    });

    test('görev yoksa grup yok', () {
      expect(tasksByDay(const [], now: now, days: 7), isEmpty);
    });
  });

  test('tasksByApiary: arılıklar ad sırasıyla (Türkçe ve sayı), arılıksız '
      'en sonda; tarih sınırı yok', () {
    final groups = tasksByApiary([
      _view('none', DateTime(2026, 10, 24)),
      _view(
        'ova-later',
        DateTime(2027, 2, 2),
        apiaryId: 'o',
        apiaryName: 'Ova',
      ),
      _view('c', DateTime(2026, 10, 25), apiaryId: 'c', apiaryName: 'Çamlık'),
      _view('ova', DateTime(2026, 10, 2), apiaryId: 'o', apiaryName: 'Ova'),
      _view('a10', DateTime(2026, 10, 24), apiaryId: '10', apiaryName: 'A 10'),
      _view('a2', DateTime(2026, 10, 24), apiaryId: '2', apiaryName: 'A 2'),
    ]);

    expect(
      [for (final g in groups) g.apiaryName],
      ['A 2', 'A 10', 'Çamlık', 'Ova', null],
    );
    expect(_ids(groups[3].tasks), ['ova', 'ova-later']);
  });

  group('reminderPlan', () {
    test('kendime atanmış ya da atanmamış, açık ve ileride olanlar; en '
        'yakını önce', () {
      final plan = reminderPlan(
        [
          _view('later', DateTime(2026, 10, 26, 9), assignedTo: 'me'),
          _view('unassigned', DateTime(2026, 10, 25, 9)),
          _view('other', DateTime(2026, 10, 25, 9), assignedTo: 'someone'),
          _view('past', DateTime(2026, 10, 24, 14), assignedTo: 'me'),
          _view(
            'done',
            DateTime(2026, 10, 25, 9),
            assignedTo: 'me',
            completedAt: _created,
          ),
        ],
        userId: 'me',
        now: now,
      );

      expect(_ids(plan), ['unassigned', 'later']);
    });

    test('en fazla limit kadar, en yakınlar', () {
      final plan = reminderPlan(
        [
          for (var i = 60; i > 0; i--)
            _view('t$i', DateTime(2026, 10, 24, 16).add(Duration(hours: i))),
        ],
        userId: 'me',
        now: now,
      );

      expect(plan, hasLength(maxScheduledReminders));
      expect(plan.first.task.id, 't1');
      expect(plan.last.task.id, 't$maxScheduledReminders');
    });

    test('oturum yoksa yalnız atanmamışlar', () {
      final plan = reminderPlan(
        [
          _view('mine', DateTime(2026, 10, 25), assignedTo: 'me'),
          _view('unassigned', DateTime(2026, 10, 25)),
        ],
        userId: null,
        now: now,
      );
      expect(_ids(plan), ['unassigned']);
    });
  });

  test('bildirim kimliği görevle sabit, pozitif 31 bit ve görevler '
      'arasında farklı', () {
    final ids = {
      for (var i = 0; i < 1000; i++) reminderNotificationId('0199a3b2-7c1e-$i'),
    };

    expect(reminderNotificationId('t1'), reminderNotificationId('t1'));
    expect(ids, hasLength(1000));
    for (final id in ids) {
      expect(id, inInclusiveRange(0, 0x7fffffff));
    }
  });

  group('treatmentRemovalDueAt', () {
    test('çıkarma günü sabah $defaultTaskHour (yerel)', () {
      expect(
        treatmentRemovalDueAt(DateTime(2026, 12, 5, 12).toUtc(), now: now),
        DateTime(2026, 12, 5, defaultTaskHour),
      );
    });

    test('çıkarma yoksa görev yok', () {
      expect(treatmentRemovalDueAt(null, now: now), isNull);
    });

    test('günü geçtiyse görev yok; bugünse saati geçmiş olsa da var', () {
      expect(treatmentRemovalDueAt(DateTime(2026, 10, 23), now: now), isNull);
      expect(
        treatmentRemovalDueAt(DateTime(2026, 10, 24, 12), now: now),
        DateTime(2026, 10, 24, defaultTaskHour),
      );
    });
  });

  group('defaultTaskDueAt', () {
    test('sabah $defaultTaskHour’dan önce: bugün $defaultTaskHour', () {
      expect(
        defaultTaskDueAt(DateTime(2026, 10, 24, 7, 30)),
        DateTime(2026, 10, 24, defaultTaskHour),
      );
    });

    test('gün içinde: bir sonraki tam saat', () {
      expect(
        defaultTaskDueAt(DateTime(2026, 10, 24, 15, 10)),
        DateTime(2026, 10, 24, 16),
      );
    });

    test('gece 23’ten sonra: yarın $defaultTaskHour', () {
      expect(
        defaultTaskDueAt(DateTime(2026, 10, 31, 23, 30)),
        DateTime(2026, 11, 1, defaultTaskHour),
      );
    });
  });

  group('checkTaskPlan', () {
    Task task({
      TaskSource source = TaskSource.manual,
      String? apiaryId = 'apiary-1',
      String? refDrugId,
      String? drugId,
      double? dose,
    }) => Task(
      id: 'task-1',
      orgId: 'org-1',
      title: 'İlaçlama',
      dueAt: _created,
      createdAt: _created,
      updatedAt: _created,
      source: source,
      sourceId: source == TaskSource.manual ? null : 'source-1',
      apiaryId: apiaryId,
      refDrugId: refDrugId,
      drugId: drugId,
      dose: dose,
    );

    test('ilaçsız görev ve tek ilaçlı, dozlu, arılıklı elle görev geçer', () {
      checkTaskPlan(task());
      checkTaskPlan(task(apiaryId: null));
      checkTaskPlan(task(refDrugId: 'ref-1', dose: 2));
      checkTaskPlan(task(drugId: 'drug-1', dose: maxTaskDose.toDouble()));
    });

    test('ilaç ve doz birlikte, en çok bir ilaç, doz aralıkta, arılık ve '
        'elle açılma zorunlu', () {
      for (final invalid in [
        task(refDrugId: 'ref-1'),
        task(dose: 2),
        task(refDrugId: 'ref-1', drugId: 'drug-1', dose: 2),
        task(refDrugId: 'ref-1', dose: 0),
        task(refDrugId: 'ref-1', dose: maxTaskDose + 1),
        task(refDrugId: 'ref-1', dose: 2, apiaryId: null),
        task(refDrugId: 'ref-1', dose: 2, source: TaskSource.treatment),
      ]) {
        expect(() => checkTaskPlan(invalid), throwsArgumentError);
      }
    });
  });
}
