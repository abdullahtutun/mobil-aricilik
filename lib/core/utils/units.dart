/// Kütle birimi.
enum MassUnit {
  kilogram(1),

  /// Uluslararası pound; tanım gereği tam olarak 0,45359237 kg.
  pound(0.45359237);

  new(this._kilograms);

  /// Bu birimin bir tanesi kaç kilogram.
  final double _kilograms;

  /// [value]'yu bu birimden [to] birimine çevirir.
  double convert(double value, {required MassUnit to}) {
    if (to == this) return value;
    return value * _kilograms / to._kilograms;
  }
}

/// Sıcaklık birimi.
enum TemperatureUnit {
  celsius,
  fahrenheit;

  /// [value]'yu bu birimden [to] birimine çevirir.
  double convert(double value, {required TemperatureUnit to}) {
    if (to == this) return value;
    return switch (to) {
      TemperatureUnit.fahrenheit => value * 9 / 5 + 32,
      TemperatureUnit.celsius => (value - 32) * 5 / 9,
    };
  }
}

/// Hacim birimi.
enum VolumeUnit {
  liter(1),

  /// ABD sıvı galonu; tanım gereği tam olarak 3,785411784 L.
  gallon(3.785411784);

  new(this._liters);

  /// Bu birimin bir tanesi kaç litre.
  final double _liters;

  /// [value]'yu bu birimden [to] birimine çevirir.
  double convert(double value, {required VolumeUnit to}) {
    if (to == this) return value;
    return value * _liters / to._liters;
  }
}
