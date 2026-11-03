import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/weather/domain/weather_icons.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';

/// Tasarımdaki simgenin çizgi ikonu.
IconData weatherIconData(WeatherIcon icon) => switch (icon) {
  WeatherIcon.sunny => Icons.wb_sunny_outlined,
  WeatherIcon.partlyCloudy => Icons.wb_cloudy_outlined,
  WeatherIcon.cloudy => Icons.cloud_outlined,
  WeatherIcon.rainy => Icons.water_drop_outlined,
  WeatherIcon.windy => Icons.air_rounded,
  WeatherIcon.other => Icons.ac_unit_rounded,
};

/// Simgenin kelimesi ("Güneşli"); ekran okuyucu da bunu okur.
String weatherIconLabel(AppLocalizations l10n, WeatherIcon icon) =>
    switch (icon) {
      WeatherIcon.sunny => l10n.weatherConditionSunny,
      WeatherIcon.partlyCloudy => l10n.weatherConditionPartlyCloudy,
      WeatherIcon.cloudy => l10n.weatherConditionCloudy,
      WeatherIcon.rainy => l10n.weatherConditionRainy,
      WeatherIcon.windy => l10n.weatherConditionWindy,
      WeatherIcon.other => l10n.weatherConditionOther,
    };

/// Uygunluğun durum rengi: uygun yeşil, yağmur mavi, rüzgar ve soğuk
/// turuncu; kelime ve ikon rozetle birlikte gelir.
AppStatus hiveOpeningStatus(HiveOpening opening) => switch (opening) {
  HiveOpening.suitable => AppStatus.good,
  HiveOpening.rain => AppStatus.info,
  HiveOpening.wind || HiveOpening.cold => AppStatus.warning,
};

/// Rozet kelimesi: uygunsa [suitable] ("Kovan açılır" ya da kısa "Açılır"),
/// değilse etkenin adı.
String hiveOpeningLabel(
  AppLocalizations l10n,
  HiveOpening opening, {
  String? suitable,
}) => switch (opening) {
  HiveOpening.suitable => suitable ?? l10n.hiveOpeningSuitable,
  HiveOpening.rain => l10n.hiveOpeningRain,
  HiveOpening.wind => l10n.hiveOpeningWind,
  HiveOpening.cold => l10n.hiveOpeningCold,
};

/// Ölçülerin kullanıcının biriminde metni; paket metrik gelir.
class WeatherFormat {
  new(this.l10n, this.format, this.units);

  final AppLocalizations l10n;
  final AppFormat format;
  final DefaultUnits units;

  /// "22°" (°C ya da °F).
  String temperature(double celsius) => l10n.weatherTemperature(
    format.number(
      TemperatureUnit.celsius.convert(celsius, to: units.temperature).round(),
    ),
  );

  /// Yalnız sayı ("8"); birim sütun başlığında.
  String speedValue(double kmh) => format.number(
    SpeedUnit.kilometersPerHour.convert(kmh, to: units.speed).round(),
  );

  /// "km/s" ya da "mph".
  String get speedUnit => switch (units.speed) {
    SpeedUnit.kilometersPerHour => l10n.unitKmh,
    SpeedUnit.milesPerHour => l10n.unitMph,
  };

  /// "8 km/s".
  String speed(double kmh) => l10n.weatherSpeed(speedValue(kmh), speedUnit);

  /// "%40".
  String percent(double value) =>
      l10n.weatherPercent(format.number(value.round()));
}
