import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_aricilik/app/routes.dart';
import 'package:mobil_aricilik/app/shell/app_navigation_bar.dart';
import 'package:mobil_aricilik/app/shell/app_tab.dart';
import 'package:mobil_aricilik/app/shell/quick_record_sheet.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

/// Sekmeli kabuk. Her sekme kendi gezinme yığınını korur.
class AppShell extends StatelessWidget {
  const new({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  Future<void> _openQuickRecord(BuildContext context) async {
    final type = await showQuickRecordSheet(context);
    if (type == null || !context.mounted) return;
    // Kayıt formları kendi adımlarında gelecek.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).quickRecordComingSoon),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
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
        onQuickRecord: () => _openQuickRecord(context),
      ),
    );
  }
}
