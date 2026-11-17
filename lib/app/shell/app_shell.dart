import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/app/shell/app_tab.dart';
import 'package:mobil_arici/app/shell/quick_record_flow.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Sekmeli kabuk. Her sekme kendi gezinme yığınını korur.
class AppShell extends ConsumerWidget {
  const new({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(
        currentTab: AppTab.values[navigationShell.currentIndex],
        // Açık sekmeye yeniden dokunmak sekmenin başına döner.
        onTabSelected: (tab) => navigationShell.goBranch(
          tab.index,
          initialLocation: tab.index == navigationShell.currentIndex,
        ),
        onScan: () => context.push(AppRoutes.scan),
        // Viewer kayıt giremez; hızlı kayıt menüsü açılmaz.
        onQuickRecord: ref.watch(canWriteRecordsProvider)
            ? () => unawaited(startQuickRecord(context, ref))
            : null,
      ),
    );
  }
}
