import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_strip.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  @override
  void initState() {
    super.initState();
    // Ekran saklanan paketi hemen gösterir; yenisi gelince kendiliğinden
    // güncellenir. İşletme açılışta sonradan yüklenebilir.
    ref.listenManual(currentOrgIdProvider, (_, orgId) {
      if (orgId != null) {
        unawaited(ref.read(weatherRefresherProvider).refreshIfStale());
      }
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDev = ref.watch(flavorProvider) == Flavor.dev;
    final hasWeather =
        ref.watch(apiaryWeatherProvider).value?.isNotEmpty ?? false;
    final empty = EmptyState(
      icon: Icons.today_rounded,
      title: l10n.todayEmptyTitle,
      message: l10n.todayEmptyMessage,
      centered: !hasWeather,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabToday),
        actions: [
          if (isDev)
            IconButton(
              icon: const Icon(Icons.developer_mode_rounded),
              tooltip: l10n.devMenuTitle,
              onPressed: () => context.go(AppRoutes.developerMenu),
            ),
          const SyncStatusButton(),
        ],
      ),
      body: hasWeather
          ? ListView(
              padding: EdgeInsets.symmetric(vertical: context.spacing.lg),
              children: [const WeatherStrip(), empty],
            )
          : empty,
    );
  }
}
