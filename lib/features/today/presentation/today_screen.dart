import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_aricilik/app/flavor.dart';
import 'package:mobil_aricilik/app/routes.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

class TodayScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDev = ref.watch(flavorProvider) == Flavor.dev;
    return Scaffold(
      appBar: isDev
          ? AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.developer_mode_rounded),
                  tooltip: l10n.devMenuTitle,
                  onPressed: () => context.go(AppRoutes.developerMenu),
                ),
              ],
            )
          : null,
      body: Center(
        child: Text(
          l10n.appTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
