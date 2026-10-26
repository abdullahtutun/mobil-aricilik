import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';

final _at = DateTime.utc(2026, 10);

/// Yerel saatle 26 Ekim 2026 öğle.
final _now = DateTime(2026, 10, 26, 12);

Hive _hive(
  String id, {
  HiveStatus status = HiveStatus.active,
  String apiaryId = 'apiary-1',
}) => Hive(
  id: id,
  orgId: 'org-1',
  number: id,
  type: HiveType.langstroth,
  apiaryId: apiaryId,
  status: status,
  createdAt: _at,
  updatedAt: _at,
);

Inspection _inspection(
  String hiveId, {
  QueenState? queenState,
  int? beeFrames,
  bool? swarmSigns,
  QueenCells? queenCells,
}) => Inspection(
  id: 'inspection-$hiveId',
  orgId: 'org-1',
  hiveId: hiveId,
  apiaryId: 'apiary-1',
  inspectedAt: _at,
  queenState: queenState,
  beeFrames: beeFrames,
  swarmSigns: swarmSigns,
  queenCells: queenCells,
  createdAt: _at,
  updatedAt: _at,
);

Task _removalTask(
  String groupId,
  DateTime dueAt, {
  DateTime? completedAt,
  DateTime? deletedAt,
  TaskSource source = TaskSource.treatment,
}) => Task(
  id: 'task-$groupId-${dueAt.day}',
  orgId: 'org-1',
  dueAt: dueAt,
  source: source,
  sourceId: groupId,
  completedAt: completedAt,
  deletedAt: deletedAt,
  createdAt: _at,
  updatedAt: _at,
);

Treatment _treatment(
  String hiveId, {
  required String groupId,
  DateTime? deletedAt,
}) => Treatment(
  id: 'treatment-$hiveId-$groupId',
  orgId: 'org-1',
  hiveId: hiveId,
  apiaryId: 'apiary-1',
  applicationId: groupId,
  productName: 'Amitraz şerit',
  activeIngredient: DrugActiveIngredient.amitraz,
  dose: 2,
  doseUnit: DrugDoseUnit.strip,
  startedAt: _at,
  withdrawalDays: 0,
  deletedAt: deletedAt,
  createdAt: _at,
  updatedAt: _at,
);

TaskView _view(Task task) => (task: task, apiaryName: null, hiveNumber: null);

void main() {
  group('isQueenless', () {
    test('yalnız ana arı "Yok" anasız; yumurta ya da bakılmamış değil', () {
      expect(
        isQueenless(const InspectionValues(queenState: QueenState.none)),
        isTrue,
      );
      expect(
        isQueenless(const InspectionValues(queenState: QueenState.eggs)),
        isFalse,
      );
      expect(
        isQueenless(const InspectionValues(queenState: QueenState.seen)),
        isFalse,
      );
      expect(isQueenless(const InspectionValues()), isFalse);
    });
  });

  group('isWeak', () {
    test('güç puanı 2 ve altı zayıf, 3 değil', () {
      // 3–4 arılı çerçeve → 2, 5–6 → 3.
      expect(isWeak(const InspectionValues(beeFrames: 4)), isTrue);
      expect(isWeak(const InspectionValues(beeFrames: 1)), isTrue);
      expect(isWeak(const InspectionValues(beeFrames: 5)), isFalse);
    });

    test('anasızlık puanı düşürür ve kovanı zayıf yapabilir', () {
      expect(
        isWeak(
          const InspectionValues(beeFrames: 5, queenState: QueenState.none),
        ),
        isTrue,
      );
    });

    test('arılı çerçeve girilmemişse zayıf sayılmaz', () {
      expect(
        isWeak(const InspectionValues(queenState: QueenState.none)),
        isFalse,
      );
    });
  });

  group('hasSwarmTendency', () {
    test('oğul belirtisi ya da oğul memesi', () {
      expect(
        hasSwarmTendency(const InspectionValues(swarmSigns: true)),
        isTrue,
      );
      expect(
        hasSwarmTendency(const InspectionValues(queenCells: QueenCells.swarm)),
        isTrue,
      );
    });

    test('sessiz ana değiştirme ve acil meme oğul değil', () {
      for (final cells in [
        QueenCells.none,
        QueenCells.supersedure,
        QueenCells.emergency,
      ]) {
        expect(
          hasSwarmTendency(
            InspectionValues(swarmSigns: false, queenCells: cells),
          ),
          isFalse,
          reason: '$cells',
        );
      }
      expect(hasSwarmTendency(const InspectionValues()), isFalse);
    });
  });

  group('removalDueHives', () {
    test('günü bugün ya da geçmiş açık görevin grubundaki kovanlar', () {
      final due = removalDueHives(
        tasks: [
          _removalTask('today', DateTime(2026, 10, 26, 23, 59)),
          _removalTask('late', DateTime(2026, 10, 20, 9)),
          _removalTask('tomorrow', DateTime(2026, 10, 27, 0, 1)),
        ],
        treatments: [
          _treatment('101', groupId: 'today'),
          _treatment('102', groupId: 'late'),
          _treatment('103', groupId: 'late'),
          _treatment('104', groupId: 'tomorrow'),
        ],
        now: _now,
      );

      expect(due, {
        '101': DateTime(2026, 10, 26, 23, 59),
        '102': DateTime(2026, 10, 20, 9),
        '103': DateTime(2026, 10, 20, 9),
      });
    });

    test('tamamlanan ya da silinen görev, silinen uygulama ve başka kaynak '
        'sayılmaz', () {
      final due = removalDueHives(
        tasks: [
          _removalTask('done', _now, completedAt: _now),
          _removalTask('deleted', _now, deletedAt: _now),
          _removalTask('open', _now),
          _removalTask('inspection', _now, source: TaskSource.inspection),
        ],
        treatments: [
          _treatment('101', groupId: 'done'),
          _treatment('102', groupId: 'deleted'),
          _treatment('103', groupId: 'open', deletedAt: _now),
          _treatment('104', groupId: 'inspection'),
        ],
        now: _now,
      );

      expect(due, isEmpty);
    });

    test('kovanın birden çok grubu varsa en eski gün', () {
      final due = removalDueHives(
        tasks: [
          _removalTask('a', DateTime(2026, 10, 25, 9)),
          _removalTask('b', DateTime(2026, 10, 22, 9)),
        ],
        treatments: [
          _treatment('101', groupId: 'a'),
          _treatment('101', groupId: 'b'),
        ],
        now: _now,
      );

      expect(due, {'101': DateTime(2026, 10, 22, 9)});
    });
  });

  group('attentionGroups', () {
    test('kovan son muayenesine ve çıkarmaya göre gruplara düşer; bir kovan '
        'birden çok grupta olabilir', () {
      final hives = [_hive('101'), _hive('102'), _hive('103'), _hive('104')];
      final groups = attentionGroups(
        hives: hives,
        latest: {
          '101': _inspection('101', queenState: QueenState.none, beeFrames: 4),
          '102': _inspection('102', beeFrames: 9, swarmSigns: true),
          '103': _inspection('103', beeFrames: 9),
        },
        removalDue: {'103': DateTime(2026, 10, 26, 9)},
      );

      List<String> ids(AttentionKind kind) => [
        for (final entry in groups[kind]!) entry.hive.id,
      ];
      expect(ids(AttentionKind.queenless), ['101']);
      expect(ids(AttentionKind.weak), ['101']);
      expect(ids(AttentionKind.swarming), ['102']);
      expect(ids(AttentionKind.treatmentRemoval), ['103']);
      expect(
        groups[AttentionKind.treatmentRemoval]!.single.removalDueAt,
        DateTime(2026, 10, 26, 9),
      );
      expect(
        groups[AttentionKind.queenless]!.single.inspection?.id,
        'inspection-101',
      );
      expect(attentionHiveCount(groups), 3);
    });

    test('aktif olmayan kovan hiçbir grupta yok; her grup haritada', () {
      final groups = attentionGroups(
        hives: [_hive('101', status: HiveStatus.dead)],
        latest: {'101': _inspection('101', queenState: QueenState.none)},
        removalDue: {'101': _now},
      );

      expect(groups.keys, AttentionKind.values);
      expect(groups.values.every((entries) => entries.isEmpty), isTrue);
      expect(attentionHiveCount(groups), 0);
    });
  });

  group('attentionHiveCountsByApiary', () {
    test('arılık başına ayrı kovan sayılır; dikkat isteyeni olmayan arılık '
        'yok', () {
      final groups = attentionGroups(
        hives: [
          _hive('101'),
          _hive('102'),
          _hive('201', apiaryId: 'apiary-2'),
          _hive('301', apiaryId: 'apiary-3'),
        ],
        latest: {
          // Hem anasız hem zayıf: bir kez sayılır.
          '101': _inspection('101', queenState: QueenState.none, beeFrames: 4),
          '201': _inspection('201', swarmSigns: true),
          '301': _inspection('301', beeFrames: 9),
        },
        removalDue: {'102': _now},
      );

      expect(attentionHiveCountsByApiary(groups), {
        'apiary-1': 2,
        'apiary-2': 1,
      });
    });
  });

  test('tasksDueToday: gecikmiş ve bugünkü açık görevler, son tarih '
      'sırasıyla', () {
    final late = _removalTask('late', DateTime(2026, 10, 20, 9));
    final today = _removalTask('today', DateTime(2026, 10, 26, 22));
    final tomorrow = _removalTask('tomorrow', DateTime(2026, 10, 27, 9));
    final done = _removalTask(
      'done',
      DateTime(2026, 10, 26, 9),
      completedAt: _now,
    );

    expect(
      tasksDueToday([
        _view(today),
        _view(tomorrow),
        _view(done),
        _view(late),
      ], now: _now),
      [_view(late), _view(today)],
    );
  });

  test('greetingAt: 05–11 sabah, 12–17 gün, gerisi akşam', () {
    Greeting at(int hour) => greetingAt(DateTime(2026, 10, 26, hour));
    expect(at(4), Greeting.evening);
    expect(at(5), Greeting.morning);
    expect(at(11), Greeting.morning);
    expect(at(12), Greeting.afternoon);
    expect(at(17), Greeting.afternoon);
    expect(at(18), Greeting.evening);
  });

  test('completedSetupSteps: her adım kendi verisiyle tamam', () {
    expect(
      completedSetupSteps(
        hasApiary: false,
        hasHive: false,
        hasInspection: false,
      ),
      isEmpty,
    );
    expect(
      completedSetupSteps(hasApiary: true, hasHive: true, hasInspection: false),
      {SetupStep.apiary, SetupStep.hives},
    );
  });
}
