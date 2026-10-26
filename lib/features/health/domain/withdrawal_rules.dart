import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';

/// Bekleme süresi kilidi (teknik.md §10, "Kritik uyarılar
/// engelleyicidir"): ilacı süren ya da bekleme süresindeki kovana bal katı
/// verilmesi ve hasat işaretlenmesi engellenir; bilerek geçilirse gerekçe
/// istenir.
///
/// Günler telefonun yerel takvimiyle sayılır. Kilit, uygulamanın başladığı
/// gün başlar ve [withdrawalEndDate] günü kalkar: o gün kat verilebilir.

/// Şeritli uygulamada önerilen süre: başlangıçtan sonra planlanan çıkarma.
const defaultStripTreatmentDays = 42;

/// Formda bekleme süresinin üst sınırı (sunucu da 365'te keser).
const maxWithdrawalDays = 365;

/// Kovan başına dozun üst sınırı (formdaki sayaç).
const maxTreatmentDose = 100;

/// Bal katı ve hasatın serbest kaldığı gün (yerel takvimde gün başı):
/// planlanan çıkarma, yoksa (tek seferlik uygulama) başlangıç günü,
/// üstüne [withdrawalDays] gün.
DateTime withdrawalEndDate({
  required DateTime startedAt,
  required int withdrawalDays,
  DateTime? plannedRemovalAt,
}) {
  final base = _day(plannedRemovalAt ?? startedAt);
  return DateTime(base.year, base.month, base.day + withdrawalDays);
}

/// [treatment]'ın kilidinin kalktığı gün.
DateTime treatmentWithdrawalEnd(Treatment treatment) => withdrawalEndDate(
  startedAt: treatment.startedAt,
  plannedRemovalAt: treatment.plannedRemovalAt,
  withdrawalDays: treatment.withdrawalDays,
);

/// Kovanı kilitleyen uygulama (`treatment`, kilidi en geç kalkan), kilidin
/// kalktığı gün (`until`, yerel takvimde gün başı; o gün serbest) ve
/// bugünden o güne kalan gün (`daysLeft`, kilitliyse en az 1).
typedef WithdrawalLock = ({Treatment treatment, DateTime until, int daysLeft});

/// Kovanın [treatments]'ına göre [now] anında bal katı verilmesi ve hasat
/// kilitli mi; kilitliyse en geç kalkan uygulamanın kilidi, değilse null.
///
/// Silinmiş uygulama ve başlangıç günü henüz gelmemiş uygulama kilitlemez.
/// Kilit başlangıç gününden [treatmentWithdrawalEnd] gününe kadar sürer;
/// bitiş günü serbesttir. Eşit bitişte en son başlayan uygulama döner.
WithdrawalLock? withdrawalLock(
  Iterable<Treatment> treatments, {
  required DateTime now,
}) {
  final today = _day(now);
  WithdrawalLock? latest;
  for (final treatment in treatments) {
    if (treatment.deletedAt != null) continue;
    if (_day(treatment.startedAt).isAfter(today)) continue;
    final until = treatmentWithdrawalEnd(treatment);
    final daysLeft = _daysBetween(today, until);
    if (daysLeft <= 0) continue;
    final current = latest;
    if (current == null ||
        until.isAfter(current.until) ||
        (until == current.until &&
            treatment.startedAt.isAfter(current.treatment.startedAt))) {
      latest = (treatment: treatment, until: until, daysLeft: daysLeft);
    }
  }
  return latest;
}

/// [treatments]'ın kovanlarından [now] anında kilitli olanlar, kovan
/// kimliğine göre ([withdrawalLock]). Kilitsiz kovan haritada yok.
Map<String, WithdrawalLock> withdrawalLocksByHive(
  Iterable<Treatment> treatments, {
  required DateTime now,
}) {
  final byHive = <String, List<Treatment>>{};
  for (final treatment in treatments) {
    (byHive[treatment.hiveId] ??= []).add(treatment);
  }
  return {
    for (final MapEntry(key: hiveId, value: hiveTreatments) in byHive.entries)
      hiveId: ?withdrawalLock(hiveTreatments, now: now),
  };
}

/// Önerilen planlanan çıkarma: şeritte başlangıçtan
/// [defaultStripTreatmentDays] gün sonra; diğer birimlerde tek seferlik
/// uygulama, çıkarma yok.
DateTime? defaultPlannedRemoval(DrugDoseUnit unit, DateTime startedAt) =>
    switch (unit) {
      DrugDoseUnit.strip => DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day + defaultStripTreatmentDays,
      ),
      DrugDoseUnit.ml || DrugDoseUnit.g || DrugDoseUnit.dose => null,
    };

/// Yerel takvimde günün başı.
DateTime _day(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// İki gün başı arasındaki takvim günü; yaz saati geçişinden etkilenmez.
int _daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
