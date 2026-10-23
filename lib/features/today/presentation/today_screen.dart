import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

class TodayScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isDev = ref.watch(flavorProvider) == Flavor.dev;
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
      body: Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.today_rounded,
            title: l10n.todayEmptyTitle,
            message: l10n.todayEmptyMessage,
          ),
        ),
      ),
    );
  }
}
