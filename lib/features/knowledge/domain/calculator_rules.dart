import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';

/// Bilgi bankasındaki hesaplayıcılar; hepsi internetsiz ve kayıt yazmaz.
enum Calculator {
  /// Şurup: kovan sayısı × kovan başına → şeker ve su.
  syrup('syrup'),

  /// İlaç dozu: kovan sayısı × kovan başına doz.
  dose('dose'),

  /// Ana arı yetiştirme takvimi: aktarma gününden adımların günleri.
  queen('queen'),

  /// Verim: toplam bal ÷ kovan sayısı.
  yield_('yield');

  new(this.value);

  /// Rotadaki yazımı.
  final String value;

  /// Rotadaki yazıma göre; tanınmıyorsa null.
  static Calculator? fromValue(String? value) {
    for (final calculator in values) {
      if (calculator.value == value) return calculator;
    }
    return null;
  }
}

/// Hesaplayıcılardaki kovan sayısının üst sınırı.
const maxCalculatorHives = 10000;

/// Kullanıcının yazdığı kovan sayısı: 1 ile [maxCalculatorHives] arası tam
/// sayı; boş, bozuk ya da aralık dışıysa null.
int? parseCalculatorHives(String text) => switch (int.tryParse(text.trim())) {
  final hives? when hives >= 1 && hives <= maxCalculatorHives => hives,
  _ => null,
};

/// Kullanıcının yazdığı sıfırdan büyük sayı: rakamlar ve en çok bir
/// ondalık ayracı (virgül ya da nokta, en çok üç hane). Basamak ayracı
/// kabul edilmez. Boş, bozuk ya da sıfırsa null.
double? parseCalculatorAmount(String text) {
  final match = _amount.firstMatch(text.trim());
  if (match == null) return null;
  final value = double.parse('${match.group(1)}.${match.group(2) ?? '0'}');
  return value > 0 ? value : null;
}

final _amount = RegExp(r'^([0-9]{1,7})(?:[.,]([0-9]{1,3}))?$');

/// Toplam ilaç: [hives] kovan × kovan başına [perHive] doz.
double totalDose({required int hives, required double perHive}) =>
    hives * perHive;

/// Kovan başına verim: [total] bal ÷ [hives] kovan, aynı birimde.
double yieldPerHive({required double total, required int hives}) =>
    total / hives;

/// Ana takviminin bir adımı ve günü.
typedef QueenCalendarEntry = ({RearingStep step, DateTime date});

/// [graftedOn] aktarma gününden ana yetiştirme takvimi: G0 aktarma, G1
/// kabul, G5 kapanma, G10 dağıtım, G12 çıkış, G24 yumurtlama kontrolü
/// ([rearingStepDate]).
List<QueenCalendarEntry> queenCalendar(DateTime graftedOn) => [
  for (final step in RearingStep.values)
    (step: step, date: rearingStepDate(graftedOn, step)),
];
