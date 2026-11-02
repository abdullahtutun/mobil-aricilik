import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';

/// AKS'de beyan edilen kovan sayısı en çok bu kadar (sunucudaki CHECK).
const maxAksHiveCount = 100000;

/// Başvuru döneminin bugüne göre yeri.
enum SupportPeriodPhase {
  /// Başvuru açık: başlangıç ≤ bugün ≤ bitiş.
  open,

  /// Başvuru henüz başlamadı.
  upcoming,

  /// Başvuru bitti.
  closed,
}

/// [period]'un [today] gününe göre yeri; iki gün de dahil.
SupportPeriodPhase supportPeriodPhase(SupportPeriod period, DateTime today) {
  final day = dateOnly(today);
  if (day.isBefore(dateOnly(period.applicationStartsOn))) {
    return SupportPeriodPhase.upcoming;
  }
  if (day.isAfter(dateOnly(period.applicationEndsOn))) {
    return SupportPeriodPhase.closed;
  }
  return SupportPeriodPhase.open;
}

/// Ekrandaki sıra: önce açıklar (bitişi yakın olan önce), sonra
/// yaklaşanlar (başlangıcı yakın olan önce), en sonda bitenler (en son
/// biten önce). Eşitlikte ada göre.
List<SupportPeriod> sortSupportPeriods(
  Iterable<SupportPeriod> periods,
  DateTime today,
) {
  int rank(SupportPeriod period) => supportPeriodPhase(period, today).index;
  int byDay(SupportPeriod a, SupportPeriod b) =>
      switch (supportPeriodPhase(a, today)) {
        SupportPeriodPhase.open => a.applicationEndsOn.compareTo(
          b.applicationEndsOn,
        ),
        SupportPeriodPhase.upcoming => a.applicationStartsOn.compareTo(
          b.applicationStartsOn,
        ),
        SupportPeriodPhase.closed => b.applicationEndsOn.compareTo(
          a.applicationEndsOn,
        ),
      };
  return periods.toList()..sort(
    (a, b) => switch (rank(a).compareTo(rank(b))) {
      0 => switch (byDay(a, b)) {
        0 => a.name.compareTo(b.name),
        final order => order,
      },
      final order => order,
    },
  );
}

/// Başvuru öncesi kovan sayısı kontrolünün sonucu.
enum AksHiveCountCheck {
  /// AKS'de beyan edilen sayı girilmemiş.
  notDeclared,

  /// Uygulamadaki aktif kovan sayısı beyanla aynı.
  matches,

  /// İkisi farklı; başvurmadan önce AKS güncellenmeli.
  differs,
}

/// Uygulamadaki [activeHives] ile AKS'de beyan edilen [declared] sayıyı
/// karşılaştırır.
AksHiveCountCheck checkAksHiveCount({
  required int activeHives,
  required int? declared,
}) => switch (declared) {
  null => AksHiveCountCheck.notDeclared,
  final declared when declared == activeHives => AksHiveCountCheck.matches,
  _ => AksHiveCountCheck.differs,
};

/// Beyan edilen sayının metni ("120"); boşsa null, sayı değilse ya da
/// aralık dışındaysa [FormatException]. Boşluk ve binlik ayırıcı ("1.200",
/// "1 200") yok sayılır.
int? parseAksHiveCount(String text) {
  final digits = text.replaceAll(RegExp(r'[\s.,]'), '');
  if (digits.isEmpty) return null;
  final value = int.tryParse(digits);
  if (value == null ||
      !RegExp(r'^\d+$').hasMatch(digits) ||
      value > maxAksHiveCount) {
    throw FormatException('Kovan sayısı değil', text);
  }
  return value;
}

/// "AKS'de güncellemeyi unutma" görevinin saati: değişikliğin ertesi günü
/// bu saatte (yerel).
const aksTaskHour = 9;

/// Değişiklik [changedAt]'te olduysa görevin son tarihi: ertesi gün
/// [aksTaskHour]'da, UTC.
DateTime aksTaskDueAt(DateTime changedAt) {
  final local = changedAt.toLocal();
  return DateTime(local.year, local.month, local.day + 1, aksTaskHour).toUtc();
}
