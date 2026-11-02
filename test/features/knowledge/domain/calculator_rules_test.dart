import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/knowledge/domain/calculator_rules.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';

void main() {
  test('rotadaki yazımdan hesaplayıcı; tanınmazsa null', () {
    for (final calculator in Calculator.values) {
      expect(Calculator.fromValue(calculator.value), calculator);
    }
    expect(Calculator.fromValue('yok'), isNull);
    expect(Calculator.fromValue(null), isNull);
  });

  test('kovan sayısı 1 ile üst sınır arası tam sayı', () {
    expect(parseCalculatorHives('60'), 60);
    expect(parseCalculatorHives(' 1 '), 1);
    expect(parseCalculatorHives('$maxCalculatorHives'), maxCalculatorHives);
    expect(parseCalculatorHives('0'), isNull);
    expect(parseCalculatorHives('${maxCalculatorHives + 1}'), isNull);
    expect(parseCalculatorHives(''), isNull);
    expect(parseCalculatorHives('2,5'), isNull);
  });

  test('miktar virgül ya da noktayla, sıfırdan büyük', () {
    expect(parseCalculatorAmount('2,5'), 2.5);
    expect(parseCalculatorAmount('0.125'), 0.125);
    expect(parseCalculatorAmount('1500'), 1500);
    expect(parseCalculatorAmount('0'), isNull);
    expect(parseCalculatorAmount('1.500,5'), isNull);
    expect(parseCalculatorAmount('1,2345'), isNull);
    expect(parseCalculatorAmount(''), isNull);
    expect(parseCalculatorAmount('abc'), isNull);
  });

  test('toplam doz: kovan × kovan başına', () {
    expect(totalDose(hives: 60, perHive: 2), 120);
    expect(totalDose(hives: 3, perHive: 2.5), 7.5);
  });

  test('kovan başına verim: toplam ÷ kovan', () {
    expect(yieldPerHive(total: 1500, hives: 60), 25);
    expect(yieldPerHive(total: 100, hives: 3), closeTo(33.333, 0.001));
  });

  test('ana takvimi aktarma gününden G0–G24; ay sonunu aşar', () {
    final calendar = queenCalendar(DateTime(2026, 5, 20));

    expect(calendar.map((entry) => entry.step), RearingStep.values);
    expect(calendar.map((entry) => entry.date), [
      DateTime(2026, 5, 20),
      DateTime(2026, 5, 21),
      DateTime(2026, 5, 25),
      DateTime(2026, 5, 30),
      DateTime(2026, 6),
      DateTime(2026, 6, 13),
    ]);
  });
}
