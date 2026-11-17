import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/weather/domain/weather_icons.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_labels.dart';

/// Bir arılığın şu anki saati: ad, hava ikonu, sıcaklık ve rüzgar
/// (kullanıcının biriminde) ve kovan açma rozeti. Dokununca arılığın hava
/// ekranı açılır. Ekran okuyucu kartı tek öğe olarak okur.
///
/// [expanded] (şeritte tek arılık, kart ekranın enini kaplar): içerik
/// ortalanır; durum adı ile rüzgarın yanında nem ve yağış olasılığı da
/// yazar, kart boş görünmez.
class ApiaryWeatherCard extends ConsumerWidget {
  const new({required this.weather, this.expanded = false, super.key});

  final ApiaryWeather weather;
  final bool expanded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final units = WeatherFormat(
      l10n,
      AppFormat.of(context),
      ref.watch(regionConfigProvider).defaultUnits,
    );
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final (:apiary, :hour, :humidity, :opening, :thresholds) = weather;
    final icon = weatherIconFor(
      hour.conditionCode,
      windKmh: hour.windKmh,
      windLimitKmh: thresholds.maxWindKmh,
    );
    final secondary = typography.bodySmall.copyWith(
      color: colors.textSecondary,
    );

    // "Rüzgar 8 km/s": ad soluk, değer kalın.
    Widget measure(String label, String value) => Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: TextStyle(
              color: colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      style: secondary,
    );

    final measures = expanded
        ? [
            if (hour.windKmh case final kmh?)
              measure(l10n.weatherWindLabel, units.speed(kmh)),
            if (humidity case final value?)
              measure(l10n.weatherHumidityLabel, units.percent(value)),
            if (hour.precipitationProbability case final value?)
              measure(l10n.weatherPrecipitationLabel, units.percent(value)),
          ]
        : [
            if (hour.windKmh case final kmh?)
              Text(l10n.weatherWind(units.speed(kmh)), style: secondary),
          ];

    return MergeSemantics(
      child: AppCard(
        onTap: () => context.push(AppRoutes.apiaryWeather(apiary.id)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: expanded
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  apiary.name,
                  style: typography.subtitle,
                  textAlign: expanded ? TextAlign.center : TextAlign.start,
                ),
                SizedBox(height: spacing.sm),
                Row(
                  mainAxisSize: expanded ? MainAxisSize.min : MainAxisSize.max,
                  children: [
                    weatherGlyph(context, l10n, icon, size: context.sizes.icon),
                    SizedBox(width: spacing.sm),
                    if (hour.temperatureC case final celsius?)
                      Flexible(
                        child: Text(
                          units.temperature(celsius),
                          style: typography.number,
                        ),
                      ),
                  ],
                ),
                if (expanded && hour.conditionCode != null)
                  Text(
                    weatherConditionLabel(l10n, hour.conditionCode),
                    style: secondary,
                    textAlign: TextAlign.center,
                  ),
                if (measures.isNotEmpty) ...[
                  SizedBox(height: spacing.sm),
                  Wrap(
                    alignment: expanded
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    spacing: spacing.lg,
                    runSpacing: spacing.xs,
                    children: measures,
                  ),
                ],
                if (opening != null) ...[
                  SizedBox(height: spacing.md),
                  StatusBadge(
                    status: hiveOpeningStatus(opening),
                    icon: hiveOpeningIcon(opening),
                    label: hiveOpeningLabel(l10n, opening),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
