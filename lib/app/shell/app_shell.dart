import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/app/shell/app_tab.dart';
import 'package:mobil_arici/app/shell/quick_record_sheet.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Sekmeli kabuk. Her sekme kendi gezinme yığınını korur.
class AppShell extends ConsumerWidget {
  const new({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  Future<void> _openQuickRecord(BuildContext context, WidgetRef ref) async {
    final type = await showQuickRecordSheet(
      context,
      showExpense: ref.read(canSeeFinanceProvider),
    );
    if (type == null || !context.mounted) return;
    if (type == QuickRecordType.expense) {
      context.go(AppRoutes.financeNew(TransactionKind.expense));
      return;
    }
    // Diğer kayıt formları kendi adımlarında gelecek.
    showMessageSnackBar(
      context,
      AppLocalizations.of(context).quickRecordComingSoon,
    );
  }

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
            ? () => _openQuickRecord(context, ref)
            : null,
      ),
    );
  }
}
