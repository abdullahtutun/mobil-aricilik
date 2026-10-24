import 'package:flutter/material.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

class TasksScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabTasks),
        actions: const [SyncStatusButton()],
      ),
      body: EmptyState(
        icon: Icons.assignment_rounded,
        title: l10n.tasksEmptyTitle,
        message: l10n.tasksEmptyMessage,
        centered: true,
      ),
    );
  }
}
