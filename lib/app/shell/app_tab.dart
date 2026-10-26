import 'package:flutter/material.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Alt gezinmedeki sekmeler. Sıra, router'daki dal (branch) sırasıyla aynı;
/// ortadaki Okut butonu sekme değildir.
enum AppTab {
  today(Icons.wb_sunny_outlined),
  apiaries(Icons.location_on_outlined),
  tasks(Icons.checklist_rounded),
  more(Icons.grid_view_outlined);

  new(this.icon);

  /// Çizgi ikon; seçili sekmede de aynı (docs/design "Bileşen · alt menü").
  final IconData icon;

  String label(AppLocalizations l10n) => switch (this) {
    today => l10n.tabToday,
    apiaries => l10n.tabApiaries,
    tasks => l10n.tabTasks,
    more => l10n.tabMore,
  };
}
