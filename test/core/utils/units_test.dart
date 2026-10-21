import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/utils/units.dart';

const _precision = 1e-9;
const _sample = 123.4;

void main() {
  group('MassUnit', () {
    test('1 lb tam olarak 0,45359237 kg', () {
      expect(
        MassUnit.pound.convert(1, to: MassUnit.kilogram),
        closeTo(0.45359237, _precision),
      );
    });

    test('kg → lb', () {
      expect(
        MassUnit.kilogram.convert(10, to: MassUnit.pound),
        closeTo(22.046226218, _precision),
      );
    });

    test('her çiftte gidiş-dönüş değeri korur', () {
      for (final from in MassUnit.values) {
        for (final to in MassUnit.values) {
          final back = to.convert(from.convert(_sample, to: to), to: from);
          expect(back, closeTo(_sample, _precision), reason: '$from ↔ $to');
        }
      }
    });

    test('aynı birime çevirmek değeri değiştirmez', () {
      for (final unit in MassUnit.values) {
        expect(unit.convert(_sample, to: unit), _sample);
      }
    });
  });

  group('TemperatureUnit', () {
    test('bilinen noktalar: donma, kaynama, -40 ve vücut ısısı', () {
      const points = <(double, double)>[
        (0, 32),
        (100, 212),
        (-40, -40),
        (37, 98.6),
      ];
      for (final (celsius, fahrenheit) in points) {
        expect(
          TemperatureUnit.celsius.convert(
            celsius,
            to: TemperatureUnit.fahrenheit,
          ),
          closeTo(fahrenheit, _precision),
        );
        expect(
          TemperatureUnit.fahrenheit.convert(
            fahrenheit,
            to: TemperatureUnit.celsius,
          ),
          closeTo(celsius, _precision),
        );
      }
    });

    test('aynı birime çevirmek değeri değiştirmez', () {
      for (final unit in TemperatureUnit.values) {
        expect(unit.convert(_sample, to: unit), _sample);
      }
    });
  });

  group('VolumeUnit', () {
    test('1 gal (ABD) tam olarak 3,785411784 L', () {
      expect(
        VolumeUnit.gallon.convert(1, to: VolumeUnit.liter),
        closeTo(3.785411784, _precision),
      );
    });

    test('L → gal', () {
      expect(
        VolumeUnit.liter.convert(10, to: VolumeUnit.gallon),
        closeTo(2.641720524, _precision),
      );
    });

    test('her çiftte gidiş-dönüş değeri korur', () {
      for (final from in VolumeUnit.values) {
        for (final to in VolumeUnit.values) {
          final back = to.convert(from.convert(_sample, to: to), to: from);
          expect(back, closeTo(_sample, _precision), reason: '$from ↔ $to');
        }
      }
    });

    test('aynı birime çevirmek değeri değiştirmez', () {
      for (final unit in VolumeUnit.values) {
        expect(unit.convert(_sample, to: unit), _sample);
      }
    });
  });
}
