import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';

MatingNuc _nuc(
  String number, {
  MatingNucStatus status = MatingNucStatus.empty,
}) => MatingNuc(
  id: 'nuc-$number',
  orgId: 'org-1',
  number: number,
  apiaryId: 'apiary-1',
  status: status,
  rearingBatchId: status == MatingNucStatus.empty ? null : 'batch-0',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  group('takvim', () {
    test('aktarma gününden G1, G5, G10, G12, G24', () {
      final graftedOn = DateTime(2026, 5, 12);
      expect(
        {
          for (final step in RearingStep.values)
            step: rearingStepDate(graftedOn, step),
        },
        {
          RearingStep.graft: DateTime(2026, 5, 12),
          RearingStep.acceptance: DateTime(2026, 5, 13),
          RearingStep.capped: DateTime(2026, 5, 17),
          RearingStep.distribution: DateTime(2026, 5, 22),
          RearingStep.emergence: DateTime(2026, 5, 24),
          RearingStep.layingCheck: DateTime(2026, 6, 5),
        },
      );
    });

    test('ay ve yıl sınırını aşar', () {
      final graftedOn = DateTime(2026, 12, 20);
      expect(
        rearingStepDate(graftedOn, RearingStep.distribution),
        DateTime(2026, 12, 30),
      );
      expect(
        rearingStepDate(graftedOn, RearingStep.layingCheck),
        DateTime(2027, 1, 13),
      );
    });

    test('görev zamanı adım günü sabah 09:00 yerel saat, UTC', () {
      final dueAt = rearingStepDueAt(
        DateTime(2026, 5, 12),
        RearingStep.emergence,
      );
      expect(dueAt.isUtc, isTrue);
      expect(dueAt.toLocal(), DateTime(2026, 5, 24, rearingTaskHour));
    });

    test('görev açılan adımlar aktarma dışındakiler', () {
      expect(rearingTaskSteps.map((step) => step.day), [1, 5, 10, 12, 24]);
    });

    test('günden adıma; bilinmeyen gün ve null boş', () {
      expect(RearingStep.ofDay(10), RearingStep.distribution);
      expect(RearingStep.ofDay(0), RearingStep.graft);
      expect(RearingStep.ofDay(7), isNull);
      expect(RearingStep.ofDay(null), isNull);
    });
  });

  group('zaman çizelgesi', () {
    final graftedOn = DateTime(2026, 5, 12);

    List<RearingStepState> states({
      required DateTime today,
      Set<RearingStep> completed = const {},
      Set<RearingStep>? open,
    }) => [
      for (final entry in rearingTimeline(
        graftedOn,
        completed: completed,
        open: open ?? rearingTaskSteps.toSet().difference(completed),
        today: today,
      ))
        entry.state,
    ];

    test('aktarma hep bitti; tamamlanan görevler biter, ilk açık sıradaki', () {
      expect(
        states(
          completed: {RearingStep.acceptance, RearingStep.capped},
          today: DateTime(2026, 5, 22, 15),
        ),
        [
          RearingStepState.done,
          RearingStepState.done,
          RearingStepState.done,
          RearingStepState.current,
          RearingStepState.upcoming,
          RearingStepState.upcoming,
        ],
      );
    });

    test('günü geçmiş ama açık görev bitmiş sayılmaz', () {
      expect(states(today: DateTime(2026, 6, 30)), [
        RearingStepState.done,
        RearingStepState.current,
        RearingStepState.upcoming,
        RearingStepState.upcoming,
        RearingStepState.upcoming,
        RearingStepState.upcoming,
      ]);
    });

    test('görevi silinmiş adım günü geçince biter, bugün ve sonrası kalır', () {
      expect(states(open: const {}, today: DateTime(2026, 5, 17, 8)), [
        RearingStepState.done,
        RearingStepState.done,
        RearingStepState.current,
        RearingStepState.upcoming,
        RearingStepState.upcoming,
        RearingStepState.upcoming,
      ]);
    });

    test('hepsi tamamlanınca sıradaki yok', () {
      expect(
        states(
          completed: rearingTaskSteps.toSet(),
          today: DateTime(2026, 5, 12),
        ),
        everyElement(RearingStepState.done),
      );
    });

    test('her adımın günü takvimle aynı', () {
      final timeline = rearingTimeline(
        graftedOn,
        completed: const {},
        open: const {},
        today: graftedOn,
      );
      expect(timeline.map((entry) => entry.step), RearingStep.values);
      expect(timeline[3].on, DateTime(2026, 5, 22));
    });
  });

  group('sayılar', () {
    test('kabul oranı yuvarlanır; sayılmadıysa null', () {
      expect(acceptancePercent(grafted: 40, accepted: 34), 85);
      expect(acceptancePercent(grafted: 3, accepted: 2), 67);
      expect(acceptancePercent(grafted: 40, accepted: 0), 0);
      expect(acceptancePercent(grafted: 40, accepted: null), isNull);
    });

    test('yeni seri numarası en büyüğün bir fazlası, ilk seride 1', () {
      expect(nextRearingBatchNumber(const []), 1);
      expect(nextRearingBatchNumber(const [1, 4, 2]), 5);
    });
  });

  group('kutular', () {
    test('boş, başarısız ve verilmiş kutu yeniden kullanılır', () {
      expect(
        {
          for (final status in MatingNucStatus.values)
            status: isFreeNuc(_nuc('1', status: status)),
        },
        {
          MatingNucStatus.empty: true,
          MatingNucStatus.cell: false,
          MatingNucStatus.virgin: false,
          MatingNucStatus.laying: false,
          MatingNucStatus.failed: true,
          MatingNucStatus.given: true,
        },
      );
    });

    test('yalnız yumurtlayan ana kovana verilir', () {
      for (final status in MatingNucStatus.values) {
        expect(
          canGiveQueen(_nuc('1', status: status)),
          status == MatingNucStatus.laying,
        );
      }
    });

    test('dağıtma önce boş kutuları numara sırasıyla kullanır, kalan için '
        'en büyük numaradan devam eder', () {
      final plan = distributeCells([
        _nuc('10'),
        _nuc('2', status: MatingNucStatus.failed),
        _nuc('3', status: MatingNucStatus.cell),
        _nuc('1', status: MatingNucStatus.given),
      ], 5);
      expect(plan.reused.map((nuc) => nuc.number), ['1', '2', '10']);
      expect(plan.newNumbers, ['11', '12']);
    });

    test('yeterli boş kutu varsa yeni kutu açılmaz', () {
      final plan = distributeCells([_nuc('1'), _nuc('2'), _nuc('3')], 2);
      expect(plan.reused.map((nuc) => nuc.number), ['1', '2']);
      expect(plan.newNumbers, isEmpty);
    });

    test('kutusuz ya da sayısal olmayan numaralı arılıkta 1’den başlar', () {
      expect(distributeCells(const [], 3).newNumbers, ['1', '2', '3']);
      expect(
        distributeCells([
          _nuc('K-1', status: MatingNucStatus.cell),
        ], 1).newNumbers,
        ['1'],
      );
    });
  });
}
