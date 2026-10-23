import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Seyrek kullanılan modüllerin girişi. Şimdilik yalnızca Ayarlar var.
class MoreScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabMore),
        actions: const [SyncStatusButton()],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: Text(l10n.settingsTitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go(AppRoutes.settings),
          ),
          EmptyState(
            icon: Icons.grid_view_rounded,
            title: l10n.moreEmptyTitle,
            message: l10n.moreEmptyMessage,
          ),
        ],
      ),
    );
  }
}
