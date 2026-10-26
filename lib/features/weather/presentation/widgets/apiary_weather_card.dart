import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';

/// Bir arılığın şu anki saati: ad, hava ikonu, sıcaklık (kullanıcının
/// biriminde), rüzgar ve kovan açma rozeti. Ekran okuyucu kartı tek öğe
/// olarak okur.
class ApiaryWeatherCard extends ConsumerWidget {
  const new({required this.weather, super.key});

  final ApiaryWeather weather;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final unit = ref.watch(regionConfigProvider).defaultUnits.temperature;
    final (:apiary, :hour, :advice) = weather;

    final temperature = switch (hour.temperatureC) {
      final celsius? => l10n.weatherTemperature(
        format.number(
          TemperatureUnit.celsius.convert(celsius, to: unit).round(),
        ),
      ),
      null => null,
    };
    final wind = switch (hour.windKmh) {
      final kmh? => l10n.weatherWind(format.number(kmh.round())),
      null => null,
    };

    return MergeSemantics(
      child: AppCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(apiary.name, style: typography.subtitle),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Icon(
                    _icon(hour.weatherCode, advice),
                    size: context.sizes.illustrationIcon,
                    color: colors.primary,
                  ),
                  SizedBox(width: spacing.sm),
                  if (temperature != null)
                    Flexible(
                      child: Text(temperature, style: typography.numberLarge),
                    ),
                ],
              ),
              if (wind != null) ...[
                SizedBox(height: spacing.sm),
                Text(
                  wind,
                  style: typography.body.copyWith(color: colors.textSecondary),
                ),
              ],
              if (advice != null) ...[
                SizedBox(height: spacing.md),
                StatusBadge(
                  status: switch (advice.level) {
                    HiveOpening.suitable => AppStatus.good,
                    HiveOpening.caution => AppStatus.warning,
                    HiveOpening.unsuitable => AppStatus.critical,
                  },
                  label: hiveOpeningLabel(l10n, advice),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// WMO hava kodundan ikon; rüzgar uygunluğu düşürüyorsa rüzgar ikonu.
  static IconData _icon(int? code, HiveOpeningAdvice? advice) {
    if (advice?.concern == WeatherConcern.wind) return Icons.air_rounded;
    return switch (code) {
      null => Icons.thermostat_rounded,
      0 || 1 => Icons.wb_sunny_rounded,
      2 => Icons.wb_cloudy_rounded,
      3 => Icons.cloud_rounded,
      45 || 48 => Icons.foggy,
      (>= 51 && <= 67) || (>= 80 && <= 82) => Icons.water_drop_rounded,
      (>= 71 && <= 77) || 85 || 86 => Icons.ac_unit_rounded,
      >= 95 && <= 99 => Icons.thunderstorm_rounded,
      _ => Icons.thermostat_rounded,
    };
  }
}

/// Rozet kelimesi: yeşilde "Kovan açılır", sarı ve kırmızıda etkenin adı;
/// sarı ve kırmızının kelimeleri de farklı.
String hiveOpeningLabel(AppLocalizations l10n, HiveOpeningAdvice advice) {
  return switch (advice) {
    (level: HiveOpening.suitable, concern: _) => l10n.hiveOpeningSuitable,
    (level: HiveOpening.caution, concern: WeatherConcern.rain) =>
      l10n.hiveOpeningCautionRain,
    (level: HiveOpening.caution, concern: WeatherConcern.wind) =>
      l10n.hiveOpeningCautionWind,
    (level: HiveOpening.caution, concern: _) => l10n.hiveOpeningCautionCold,
    (level: HiveOpening.unsuitable, concern: WeatherConcern.rain) =>
      l10n.hiveOpeningUnsuitableRain,
    (level: HiveOpening.unsuitable, concern: WeatherConcern.wind) =>
      l10n.hiveOpeningUnsuitableWind,
    (level: HiveOpening.unsuitable, concern: _) =>
      l10n.hiveOpeningUnsuitableCold,
  };
}
