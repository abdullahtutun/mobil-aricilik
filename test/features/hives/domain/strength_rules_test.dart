import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/strength_rules.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

/// Hiç cezası olmayan muayene: ana görüldü, yavru var, hastalık yok.
InspectionValues _healthy(int beeFrames) => InspectionValues(
  queenState: QueenState.seen,
  beeFrames: beeFrames,
  broodFrames: 3,
  diseaseSuspected: false,
);

/// Ceza alanlarının bütün değerleri; boş "bakılmadı" demek.
const _queenStates = <QueenState?>[null, ...QueenState.values];
const _broodFrames = <int?>[null, 0, 1, 10];
const _diseaseAnswers = <bool?>[null, false, true];

/// Ceza alanlarının bütün birleşimleri, [beeFrames] ile.
Iterable<InspectionValues> _combinations(int beeFrames) sync* {
  for (final queenState in _queenStates) {
    for (final broodFrames in _broodFrames) {
      for (final diseaseSuspected in _diseaseAnswers) {
        yield InspectionValues(
          beeFrames: beeFrames,
          queenState: queenState,
          broodFrames: broodFrames,
          diseaseSuspected: diseaseSuspected,
        );
      }
    }
  }
}

void main() {
  group('strengthScore', () {
    group('taban: arılı çerçeve', () {
      test('her eşikte doğru puan; cezasız muayene tabanı aynen alır', () {
        const expected = {
          0: 1,
          1: 1,
          2: 1,
          3: 2,
          4: 2,
          5: 3,
          6: 3,
          7: 4,
          8: 4,
          9: 5,
          10: 5,
          12: 5,
          20: 5,
          100: 5,
        };
        for (final MapEntry(key: frames, value: score) in expected.entries) {
          expect(
            strengthScore(InspectionValues(beeFrames: frames)),
            score,
            reason: '$frames arılı çerçeve, diğerleri bakılmadı',
          );
          expect(
            strengthScore(_healthy(frames)),
            score,
            reason: '$frames arılı çerçeve, cezasız',
          );
        }
      });

      test('arılı çerçeve girilmemişse puan yok; diğer alanlar dolu olsa '
          'da', () {
        expect(strengthScore(const InspectionValues()), isNull);
        expect(
          strengthScore(
            const InspectionValues(
              queenState: QueenState.seen,
              broodFrames: 8,
              honeyFrames: 4,
              temperament: Temperament.calm,
              swarmSigns: false,
              queenCells: QueenCells.none,
              diseaseSuspected: false,
              actions: {InspectionAction.fed},
            ),
          ),
          isNull,
        );
        expect(
          strengthScore(
            const InspectionValues(
              queenState: QueenState.none,
              broodFrames: 0,
              diseaseSuspected: true,
            ),
          ),
          isNull,
        );
      });
    });

    group('cezalar', () {
      test('ana arı yok bir puan düşürür', () {
        expect(
          strengthScore(_healthy(9).copyWith(queenState: QueenState.none)),
          4,
        );
        expect(
          strengthScore(_healthy(5).copyWith(queenState: QueenState.none)),
          2,
        );
      });

      test('ana görülmedi ama taze yumurta var: ana var sayılır, ceza '
          'yok', () {
        expect(
          strengthScore(_healthy(9).copyWith(queenState: QueenState.eggs)),
          5,
        );
      });

      test('yavrulu çerçeve 0 bir puan düşürür; 1 ve üstü düşürmez', () {
        expect(strengthScore(_healthy(9).copyWith(broodFrames: 0)), 4);
        expect(strengthScore(_healthy(9).copyWith(broodFrames: 1)), 5);
        expect(strengthScore(_healthy(9).copyWith(broodFrames: 12)), 5);
      });

      test('hastalık şüphesi bir puan düşürür; "yok" düşürmez', () {
        expect(strengthScore(_healthy(7).copyWith(diseaseSuspected: true)), 3);
        expect(strengthScore(_healthy(7).copyWith(diseaseSuspected: false)), 4);
      });

      test('cezalar toplanır', () {
        const allPenalties = InspectionValues(
          beeFrames: 10,
          queenState: QueenState.none,
          broodFrames: 0,
          diseaseSuspected: true,
        );
        expect(strengthScore(allPenalties), 2);
        expect(
          strengthScore(
            const InspectionValues(
              beeFrames: 10,
              queenState: QueenState.none,
              broodFrames: 0,
            ),
          ),
          3,
        );
      });

      test("puan 1'in altına inmez", () {
        // Üç cezayla taban 4'e kadar (8 çerçeve) 1'de durur, 5'ten 2 kalır.
        for (final beeFrames in [0, 2, 3, 4, 5, 6, 7, 8, 9]) {
          expect(
            strengthScore(
              InspectionValues(
                beeFrames: beeFrames,
                queenState: QueenState.none,
                broodFrames: 0,
                diseaseSuspected: true,
              ),
            ),
            beeFrames <= 8 ? 1 : 2,
            reason: '$beeFrames arılı çerçeve, üç ceza',
          );
        }
        expect(
          strengthScore(
            const InspectionValues(beeFrames: 1, queenState: QueenState.none),
          ),
          1,
        );
      });

      test('bakılmayan (boş) alan ceza vermez', () {
        expect(strengthScore(const InspectionValues(beeFrames: 9)), 5);
        expect(
          strengthScore(const InspectionValues(beeFrames: 9, broodFrames: 2)),
          5,
        );
      });

      test('ballı çerçeve, mizaç, oğul belirtisi, meme ve işlemler puanı '
          'etkilemez', () {
        for (final beeFrames in [0, 4, 6, 9]) {
          final base = _healthy(beeFrames);
          final expected = strengthScore(base);
          final variants = [
            base.copyWith(honeyFrames: 0),
            base.copyWith(honeyFrames: 10),
            for (final temperament in Temperament.values)
              base.copyWith(temperament: temperament),
            base.copyWith(swarmSigns: true),
            base.copyWith(swarmSigns: false),
            for (final cells in QueenCells.values)
              base.copyWith(queenCells: cells),
            base.copyWith(actions: InspectionAction.values.toSet()),
          ];
          for (final variant in variants) {
            expect(strengthScore(variant), expected, reason: '$variant');
          }
        }
      });
    });

    group('her birleşimde', () {
      test('puan 1 ile 5 arasında', () {
        for (var beeFrames = 0; beeFrames <= 30; beeFrames++) {
          for (final values in _combinations(beeFrames)) {
            expect(
              strengthScore(values),
              inInclusiveRange(minStrength, maxStrength),
              reason: '$values',
            );
          }
        }
      });

      test('daha çok arılı çerçeve puanı hiç düşürmez', () {
        for (final shape in _combinations(0)) {
          int? previous;
          for (var beeFrames = 0; beeFrames <= 30; beeFrames++) {
            final score = strengthScore(shape.copyWith(beeFrames: beeFrames))!;
            if (previous != null) {
              expect(score, greaterThanOrEqualTo(previous), reason: '$shape');
            }
            previous = score;
          }
        }
      });

      test('cezalar puanı yükseltmez; ceza sayısı kadar düşürür, 1 '
          'sınırında durur', () {
        for (var beeFrames = 0; beeFrames <= 12; beeFrames++) {
          final base = strengthScore(InspectionValues(beeFrames: beeFrames))!;
          for (final values in _combinations(beeFrames)) {
            final penalties = [
              values.queenState == QueenState.none,
              values.broodFrames == 0,
              values.diseaseSuspected ?? false,
            ].where((applies) => applies).length;
            expect(
              strengthScore(values),
              (base - penalties).clamp(minStrength, maxStrength),
              reason: '$values',
            );
          }
        }
      });
    });
  });

  group('sortWeakestFirst', () {
    Hive hive(String id, String number) => Hive(
      id: id,
      orgId: 'org-1',
      number: number,
      type: HiveType.langstroth,
      apiaryId: 'apiary-1',
      createdAt: DateTime.utc(2026, 10, 24),
      updatedAt: DateTime.utc(2026, 10, 24),
    );

    List<String> numbers(List<Hive> hives) => [
      for (final hive in hives) hive.number,
    ];

    test("puanlılar 1'den 5'e, puansızlar en sonda", () {
      final hives = [
        hive('a', '1'),
        hive('b', '2'),
        hive('c', '3'),
        hive('d', '4'),
        hive('e', '5'),
      ];

      final sorted = sortWeakestFirst(hives, {'a': 5, 'c': 1, 'd': 3});

      expect(numbers(sorted), ['3', '4', '1', '2', '5']);
    });

    test('eşit puanda numara sırası ("9" < "10"); puansızlar da numara '
        'sırasıyla', () {
      final hives = [
        hive('a', '10'),
        hive('b', '9'),
        hive('c', '101'),
        hive('d', '20'),
        hive('e', '3'),
      ];

      final sorted = sortWeakestFirst(hives, {'a': 2, 'b': 2, 'c': 2});

      expect(numbers(sorted), ['9', '10', '101', '3', '20']);
    });

    test('aynı numara ve puanda kimlik sırası; sonuç girdi sırasına bağlı '
        'değil', () {
      final hives = [hive('b', '7'), hive('a', '7'), hive('c', '7')];
      const strengths = {'a': 4, 'b': 4};

      final sorted = sortWeakestFirst(hives, strengths);

      expect([for (final h in sorted) h.id], ['a', 'b', 'c']);
      expect(sortWeakestFirst(hives.reversed, strengths), sorted);
    });

    test('girdi değişmez, yeni liste döner', () {
      final hives = [hive('a', '1'), hive('b', '2')];

      final sorted = sortWeakestFirst(hives, {'b': 1});

      expect(numbers(hives), ['1', '2']);
      expect(numbers(sorted), ['2', '1']);
      expect(identical(sorted, hives), isFalse);
    });

    test('boş liste; haritada olup listede olmayan kovan yok sayılır', () {
      expect(sortWeakestFirst(const [], {'x': 1}), isEmpty);
      expect(numbers(sortWeakestFirst([hive('a', '1')], {'x': 1})), ['1']);
    });

    test('puanı hiç olmayan arılık numara sırasında kalır', () {
      final hives = [hive('a', '12'), hive('b', '2'), hive('c', '1')];

      expect(numbers(sortWeakestFirst(hives, const {})), ['1', '2', '12']);
    });
  });
}
