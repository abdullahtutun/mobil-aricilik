import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/apiary_weather_card.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_attribution.dart';

/// Bugün'ün üstündeki yatay kayan arılık hava kartları ve WeatherAPI.com
/// atfı.
/// Saklanan paket [weatherRefreshInterval]'den eskiyse tahminin zamanı da
/// yazar (çevrimdışı). Gösterilecek arılık yoksa hiç yer kaplamaz.
class WeatherStrip extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(apiaryWeatherProvider).value ?? const [];
    if (weather.isEmpty) return const SizedBox.shrink();
    final generatedAt = ref.watch(weatherBundleProvider).value?.generatedAt;
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final stale =
        generatedAt != null &&
        clock.now().difference(generatedAt) >= weatherRefreshInterval;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: spacing.md,
              children: [
                for (final item in weather)
                  SizedBox(
                    width: context.sizes.weatherCard,
                    child: ApiaryWeatherCard(weather: item),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(spacing.lg, spacing.sm, spacing.lg, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stale)
                Text(
                  l10n.weatherForecastAsOf(
                    AppFormat.of(context).dateTime(generatedAt.toLocal()),
                  ),
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              const WeatherAttribution(),
            ],
          ),
        ),
      ],
    );
  }
}
