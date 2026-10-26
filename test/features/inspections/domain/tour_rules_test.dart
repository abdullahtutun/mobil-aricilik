import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/tour_rules.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

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
  String? id,
  QueenState? queenState,
  int? beeFrames,
  bool? swarmSigns,
  QueenCells? queenCells,
}) => Inspection(
  id: id ?? 'inspection-$hiveId',
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

ApiaryTour _tour(
  List<String> hiveIds, {
  Map<String, String> inspections = const {},
  List<String> skipped = const [],
}) => ApiaryTour(
  orgId: 'org-1',
  apiaryId: 'apiary-1',
  startedAt: _at,
  hiveIds: hiveIds,
  inspections: inspections,
  skipped: skipped,
);

List<String> _ids(Iterable<Hive> hives) => [for (final h in hives) h.id];

void main() {
  final hives = [
    for (final id in ['101', '102', '103', '104']) _hive(id),
  ];

  test('tura yalnız aktif kovanlar, verilen sırayla alınır', () {
    expect(
      tourHiveIds([
        _hive('101'),
        _hive('102', status: HiveStatus.dead),
        _hive('103'),
        _hive('104', status: HiveStatus.sold),
      ]),
      ['101', '103'],
    );
  });

  group('sıra', () {
    test('kovanın durumu: bitti, atlandı, bekliyor', () {
      final tour = _tour(
        ['101', '102', '103'],
        inspections: {'101': 'i1'},
        skipped: ['102'],
      );

      expect(tourHiveState(tour, '101'), TourHiveState.done);
      expect(tourHiveState(tour, '102'), TourHiveState.skipped);
      expect(tourHiveState(tour, '103'), TourHiveState.pending);
    });

    test('silinen, taşınan ve muayene edilmeden aktifliği biten kovan '
        'düşer; muayene edilmişse aktif olmasa da kalır', () {
      final tour = _tour(
        ['101', '102', '103', '104'],
        inspections: {'103': 'i'},
      );
      final now = [
        _hive('101'),
        _hive('102', status: HiveStatus.dead),
        _hive('103', status: HiveStatus.merged),
      ];

      final entries = tourEntries(tour, now);

      expect(_ids([for (final e in entries) e.hive]), ['101', '103']);
      expect(entries.last.state, TourHiveState.done);
    });

    test('sıradaki: ilk bekleyen; yoksa ilk atlanan; hepsi bittiyse yok', () {
      var tour = _tour(['101', '102', '103', '104']);
      expect(nextTourHive(tour, tourEntries(tour, hives))?.id, '101');

      tour = _tour(
        ['101', '102', '103', '104'],
        inspections: {'101': 'a', '103': 'c'},
        skipped: ['104', '102'],
      );
      expect(nextTourHive(tour, tourEntries(tour, hives))?.id, '104');

      tour = _tour(['101', '102'], inspections: {'101': 'a', '102': 'b'});
      expect(nextTourHive(tour, tourEntries(tour, hives)), isNull);
    });

    test('bekleyen varken atlananlar beklenir', () {
      final tour = _tour(['101', '102', '103'], skipped: ['101']);

      expect(nextTourHive(tour, tourEntries(tour, hives))?.id, '102');
    });

    test('atlanan kovan sırada aktif değilse sıradaki olmaz', () {
      final tour = _tour(
        ['101', '102'],
        skipped: ['101'],
        inspections: {'102': 'b'},
      );

      expect(
        nextTourHive(
          tour,
          tourEntries(tour, [
            _hive('101', status: HiveStatus.lost),
            _hive('102'),
          ]),
        ),
        isNull,
      );
    });
  });

  group('atla', () {
    test('kovan atlananlara eklenir; yeniden atlanınca sona geçer', () {
      var tour = _tour(['101', '102', '103']);
      tour = skipTourHive(tour, '101');
      tour = skipTourHive(tour, '102');
      expect(tour.skipped, ['101', '102']);

      tour = skipTourHive(tour, '101');
      expect(tour.skipped, ['102', '101']);
    });

    test('muayene edilmiş ya da turda olmayan kovan atlanmaz', () {
      final tour = _tour(['101', '102'], inspections: {'101': 'a'});

      expect(skipTourHive(tour, '101'), tour);
      expect(skipTourHive(tour, '999'), tour);
    });

    test('tek atlanan yeniden atlanınca sıradaki yine o', () {
      final tour = skipTourHive(
        _tour(['101', '102'], inspections: {'102': 'b'}, skipped: ['101']),
        '101',
      );

      expect(nextTourHive(tour, tourEntries(tour, hives))?.id, '101');
    });
  });

  group('muayene', () {
    test('tura yazılır ve kovan atlananlardan düşer', () {
      final tour = recordTourInspection(
        _tour(['101', '102'], skipped: ['101']),
        _inspection('101', id: 'x'),
      );

      expect(tour.inspections, {'101': 'x'});
      expect(tour.skipped, isEmpty);
    });

    test('turda olmayan kovanın muayenesi turu değiştirmez', () {
      final tour = _tour(['101']);

      expect(recordTourInspection(tour, _inspection('999')), tour);
    });

    test('Geri al kovanı yeniden bekleyen yapar; başka muayene değişmez', () {
      final tour = _tour(['101', '102'], inspections: {'101': 'x', '102': 'y'});

      final undone = undoTourInspection(tour, _inspection('101', id: 'x'));
      expect(undone.inspections, {'102': 'y'});
      expect(tourHiveState(undone, '101'), TourHiveState.pending);

      expect(undoTourInspection(tour, _inspection('102', id: 'old')), tour);
    });
  });

  group('özet', () {
    test('Bugün kurallarıyla gruplanır; grupsuzlar güçlü / orta; bakılmayan '
        'atlanmış sayılır', () {
      final inspections = [
        _inspection('101', queenState: QueenState.none, beeFrames: 3),
        _inspection('102', beeFrames: 9, queenCells: QueenCells.swarm),
        _inspection('103', beeFrames: 7, queenState: QueenState.seen),
      ];
      final tour = _tour(
        ['101', '102', '103', '104'],
        inspections: {for (final i in inspections) i.hiveId: i.id},
      );

      final summary = tourSummary(tour, tourEntries(tour, hives), inspections);

      expect(_ids(summary.inspected), ['101', '102', '103']);
      expect(_ids(summary.skipped), ['104']);
      expect(_ids(summary.queenless), ['101']);
      // Anasız kovan 3 arılı çerçeveyle zayıf da (puan 1).
      expect(_ids(summary.weak), ['101']);
      expect(_ids(summary.swarming), ['102']);
      expect(_ids(summary.healthy), ['103']);
    });

    test('muayenesi bulunamayan (silinmiş) kovan atlanmış sayılır', () {
      final tour = _tour(['101'], inspections: {'101': 'gone'});

      final summary = tourSummary(tour, tourEntries(tour, hives), const []);

      expect(summary.inspected, isEmpty);
      expect(_ids(summary.skipped), ['101']);
    });
  });

  group('önerilen görevler', () {
    TourSummary summary({
      List<Hive> queenless = const [],
      List<Hive> weak = const [],
      List<Hive> swarming = const [],
      List<Hive> skipped = const [],
    }) => (
      inspected: const [],
      skipped: skipped,
      queenless: queenless,
      weak: weak,
      swarming: swarming,
      healthy: const [],
    );

    test('tür sırasıyla; kovanı olmayan tür önerilmez', () {
      final suggestions = tourTaskSuggestions(
        summary(queenless: [hives[0], hives[2]], skipped: [hives[3]]),
        now: _now,
      );

      expect(
        [for (final s in suggestions) s.kind],
        [TourTaskKind.requeen, TourTaskKind.revisitSkipped],
      );
      expect(_ids(suggestions.first.hives), ['101', '103']);
    });

    test('son tarih yerel takvimde 1 / 3 / 7 / 1 gün sonra saat 9', () {
      final suggestions = tourTaskSuggestions(
        summary(
          queenless: [hives[0]],
          weak: [hives[0]],
          swarming: [hives[1]],
          skipped: [hives[2]],
        ),
        now: _now,
      );

      expect(
        [for (final s in suggestions) s.dueAt],
        [
          DateTime(2026, 10, 27, defaultTaskHour),
          DateTime(2026, 10, 29, defaultTaskHour),
          DateTime(2026, 11, 2, defaultTaskHour),
          DateTime(2026, 10, 27, defaultTaskHour),
        ],
      );
    });

    test('hiç grup yoksa öneri yok', () {
      expect(tourTaskSuggestions(summary(), now: _now), isEmpty);
    });

    test('başlıkta en çok 10 numara, gerisi sayı olarak', () {
      final many = [for (var i = 1; i <= 13; i++) _hive('$i')];

      final (:shown, :more) = tourTaskNumbers(many);

      expect(shown, [for (var i = 1; i <= maxTourTaskNumbers; i++) '$i']);
      expect(more, 3);
      expect(tourTaskNumbers(many.take(10).toList()).more, 0);
    });
  });

  test('kaç gün sonra: yerel takvimde; geçmiş 0', () {
    expect(daysUntil(DateTime(2026, 10, 26, 23), now: _now), 0);
    expect(daysUntil(DateTime(2026, 10, 27, 1), now: _now), 1);
    expect(daysUntil(DateTime(2026, 11, 2, 9), now: _now), 7);
    expect(daysUntil(DateTime(2026, 10, 20), now: _now), 0);
  });
}
