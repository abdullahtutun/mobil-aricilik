import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

/// Alt gezinmedeki sekmeler. Sıra, router'daki dal (branch) sırasıyla aynı;
/// ortadaki Okut butonu sekme değildir.
enum AppTab {
  today(Icons.today_outlined, Icons.today_rounded),
  apiaries(Icons.hive_outlined, Icons.hive_rounded),
  tasks(Icons.assignment_outlined, Icons.assignment_rounded),
  more(Icons.grid_view_outlined, Icons.grid_view_rounded);

  new(this.icon, this.selectedIcon);

  final IconData icon;

  /// Seçim yalnızca renkle değil, dolu ikonla da gösterilir.
  final IconData selectedIcon;

  String label(AppLocalizations l10n) => switch (this) {
    today => l10n.tabToday,
    apiaries => l10n.tabApiaries,
    tasks => l10n.tabTasks,
    more => l10n.tabMore,
  };
}
