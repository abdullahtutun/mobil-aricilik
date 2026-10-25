import 'dart:math';

import 'package:mobil_arici/features/health/domain/mite_count.dart';

/// Yeni ölçümde örnek arı: yarım bardak ≈ 300 arı.
const defaultSampleBees = 300;

/// Örnek arı sayacının adımı.
const sampleBeesStep = 50;

/// Yeni alt tabla sayımında tablanın kaldığı gün.
const defaultBoardDays = 3;

/// Sunucudaki sınırlarla aynı (`mite_counts` CHECK'leri).
const maxSampleBees = 5000;
const maxBoardDays = 60;

/// Ölçüm sonucunun birimi: örnekli yöntemde bulaşıklık yüzdesi, alt tablada
/// günlük akar dökümü.
enum MiteLoadUnit { percent, perDay }

/// Ölçümün sonucu.
typedef MiteLoad = ({double value, MiteLoadUnit unit});

/// Uyarı eşikleri; bu telefonun ayarı.
typedef VarroaThresholds = ({double percent, double perDay});

/// Ayar yapılmamışsa: %3 bulaşıklık, günde 10 akar.
const VarroaThresholds defaultVarroaThresholds = (percent: 3, perDay: 10);

/// Ayarlarda seçilebilen eşikler.
const percentThresholdOptions = <double>[1, 2, 3, 4, 5];
const perDayThresholdOptions = <double>[5, 10, 15, 20, 30];

/// [method]'un sonucu: örnekli yöntemde akar / örnek arı × 100, alt tablada
/// akar / gün. Payda girilmemiş ya da sıfırsa null.
MiteLoad? miteLoad(
  MiteCountMethod method, {
  required int mites,
  int? sampleBees,
  int? days,
}) {
  if (method.usesSample) {
    if (sampleBees == null || sampleBees <= 0) return null;
    return (value: mites / sampleBees * 100, unit: MiteLoadUnit.percent);
  }
  if (days == null || days <= 0) return null;
  return (value: mites / days, unit: MiteLoadUnit.perDay);
}

/// Kayıtlı ölçümün sonucu ([miteLoad]).
MiteLoad? miteLoadOf(MiteCount count) => miteLoad(
  count.method,
  mites: count.mites,
  sampleBees: count.sampleBees,
  days: count.days,
);

/// [unit] birimindeki sonucun eşiği.
double thresholdFor(MiteLoadUnit unit, VarroaThresholds thresholds) =>
    switch (unit) {
      MiteLoadUnit.percent => thresholds.percent,
      MiteLoadUnit.perDay => thresholds.perDay,
    };

/// Sonuç eşiğe ulaştı mı; eşiğe eşit sonuç da uyarı verir ("eşikte ·
/// mücadele planla").
bool reachesThreshold(MiteLoad load, VarroaThresholds thresholds) =>
    load.value >= thresholdFor(load.unit, thresholds);

/// Arılık grafiğinin bir çubuğu: bir gündeki örnekli ölçümlerin ortalama
/// bulaşıklığı.
typedef VarroaBar = ({DateTime day, double percent});

/// Arılıktaki örnekli ölçümlerin (pudra şekeri, alkol) gün başına
/// ortalaması; en son [maxBars] gün, eskisi önce. Gün yerel saate göre.
/// Alt tabla sayımları birimi farklı olduğu için katılmaz.
List<VarroaBar> apiaryVarroaBars(
  Iterable<MiteCount> counts, {
  int maxBars = 6,
}) {
  final byDay = <DateTime, List<double>>{};
  for (final count in counts) {
    final load = miteLoadOf(count);
    if (load == null || load.unit != MiteLoadUnit.percent) continue;
    final local = count.countedAt.toLocal();
    final day = DateTime(local.year, local.month, local.day);
    (byDay[day] ??= []).add(load.value);
  }
  final days = byDay.keys.toList()..sort();
  return [
    for (final day in days.skip(max(0, days.length - maxBars)))
      (
        day: day,
        percent: byDay[day]!.reduce((a, b) => a + b) / byDay[day]!.length,
      ),
  ];
}
