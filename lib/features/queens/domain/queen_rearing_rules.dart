import 'dart:math' as math;

import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';

/// Ana yetiştirme takviminin adımları; [day] larva aktarma gününden
/// sonraki gün (G0 aktarma günü).
enum RearingStep {
  /// G0: larva aktarma.
  graft(0),

  /// G1: kabul kontrolü, kabul edilen memeler sayılır.
  acceptance(1),

  /// G5: memeler kapanır; kovan rahatsız edilmez.
  capped(5),

  /// G10: memeler ana çıkmadan önce çiftleşme kutularına dağıtılır.
  distribution(10),

  /// G12: ana çıkışı; kutularda kontrol edilir.
  emergence(12),

  /// G24: yumurtlama kontrolü; çiftleşme başarısı işaretlenir.
  layingCheck(24);

  new(this.day);

  final int day;

  /// Takvim gününe göre adım; böyle bir adım yoksa null.
  static RearingStep? ofDay(int? day) {
    for (final step in values) {
      if (step.day == day) return step;
    }
    return null;
  }
}

/// Otomatik görev açılan adımlar: aktarma dışındakiler.
final List<RearingStep> rearingTaskSteps = [
  for (final step in RearingStep.values)
    if (step != RearingStep.graft) step,
];

/// Otomatik görevlerin saati: adım gününün sabahı.
const rearingTaskHour = 9;

/// [step] adımının günü: aktarma gününden [RearingStep.day] gün sonra
/// (yerel takvim günü).
DateTime rearingStepDate(DateTime graftedOn, RearingStep step) =>
    DateTime(graftedOn.year, graftedOn.month, graftedOn.day + step.day);

/// [step] adımının görev zamanı: adım günü [rearingTaskHour]'da, UTC.
DateTime rearingStepDueAt(DateTime graftedOn, RearingStep step) => DateTime(
  graftedOn.year,
  graftedOn.month,
  graftedOn.day + step.day,
  rearingTaskHour,
).toUtc();

/// Takvimde adımın yeri: bitti, sıradaki ya da ileride.
enum RearingStepState { done, current, upcoming }

/// Zaman çizelgesinde bir adım: günü ve durumu.
typedef RearingTimelineEntry = ({
  RearingStep step,
  DateTime on,
  RearingStepState state,
});

/// Serinin takvimi ([graftedOn]'dan). Aktarma (G0) hep bitmiştir. Bir adım
/// görevi tamamlandıysa ([completed]) biter; görevi yoksa (açık görevler
/// [open] içinde değilse, ör. silindiyse) günü [today]'den önceyse biter.
/// Bitmemiş ilk adım sıradaki, sonrakiler ileride.
List<RearingTimelineEntry> rearingTimeline(
  DateTime graftedOn, {
  required Set<RearingStep> completed,
  required Set<RearingStep> open,
  required DateTime today,
}) {
  final day = dateOnly(today);
  var currentFound = false;
  final timeline = <RearingTimelineEntry>[];
  for (final step in RearingStep.values) {
    final on = rearingStepDate(graftedOn, step);
    final done =
        step == RearingStep.graft ||
        completed.contains(step) ||
        (!open.contains(step) && on.isBefore(day));
    final RearingStepState state;
    if (done) {
      state = RearingStepState.done;
    } else if (!currentFound) {
      currentFound = true;
      state = RearingStepState.current;
    } else {
      state = RearingStepState.upcoming;
    }
    timeline.add((step: step, on: on, state: state));
  }
  return timeline;
}

/// Kabul oranı yüzde olarak, yuvarlanmış; kabul sayılmadıysa null.
int? acceptancePercent({required int grafted, required int? accepted}) =>
    accepted == null || grafted <= 0
    ? null
    : (accepted * 100 / grafted).round();

/// Yeni serinin numarası: işletmedeki en büyük numaranın bir fazlası, ilk
/// seride 1.
int nextRearingBatchNumber(Iterable<int> numbers) =>
    numbers.fold(0, math.max) + 1;

/// Yeni seride kullanılabilen kutu: boş, başarısız ya da anası verilmiş.
bool isFreeNuc(MatingNuc nuc) => switch (nuc.status) {
  MatingNucStatus.empty ||
  MatingNucStatus.failed ||
  MatingNucStatus.given => true,
  MatingNucStatus.cell ||
  MatingNucStatus.virgin ||
  MatingNucStatus.laying => false,
};

/// Ana kovana verilebilir: kutudaki ana yumurtluyor.
bool canGiveQueen(MatingNuc nuc) => nuc.status == MatingNucStatus.laying;

/// Seriye sayılan kutu: memesi ya da anası bu seriden ve boşaltılmamış.
bool countsForBatch(MatingNuc nuc) => nuc.status != MatingNucStatus.empty;

/// Memeleri dağıtma planı: yeniden kullanılacak kutular ve açılacak yeni
/// kutuların numaraları.
typedef NucDistribution = ({List<MatingNuc> reused, List<String> newNumbers});

/// [count] memeyi arılığın kutularına ([apiaryNucs]) dağıtır: önce boş
/// kutular ([isFreeNuc]) numara sırasıyla, kalanlar için yeni kutular.
/// Yeni kutuların numarası arılıktaki en büyük sayısal numaradan devam
/// eder; sayısal numara yoksa 1'den.
NucDistribution distributeCells(List<MatingNuc> apiaryNucs, int count) {
  final free = [
    for (final nuc in apiaryNucs)
      if (isFreeNuc(nuc)) nuc,
  ]..sort((a, b) => compareNatural(a.number, b.number));
  final reused = free.take(math.max(0, count)).toList();
  final last = apiaryNucs.fold(
    0,
    (highest, nuc) => math.max(highest, int.tryParse(nuc.number.trim()) ?? 0),
  );
  return (
    reused: reused,
    newNumbers: [
      for (var i = 1; i <= count - reused.length; i++) '${last + i}',
    ],
  );
}
