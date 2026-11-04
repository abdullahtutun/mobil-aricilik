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
class ApiaryWeatherCard extends ConsumerWidget {
  const new({required this.weather, super.key});

  final ApiaryWeather weather;

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
    final (:apiary, :hour, :opening, :thresholds) = weather;
    final icon = weatherIconFor(
      hour.conditionCode,
      windKmh: hour.windKmh,
      windLimitKmh: thresholds.maxWindKmh,
    );

    return MergeSemantics(
      child: AppCard(
        onTap: () => context.push(AppRoutes.apiaryWeather(apiary.id)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apiary.name, style: typography.subtitle),
                SizedBox(height: spacing.sm),
                Row(
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
                if (hour.windKmh case final kmh?) ...[
                  SizedBox(height: spacing.sm),
                  Text(
                    l10n.weatherWind(units.speed(kmh)),
                    style: typography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
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
