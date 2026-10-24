import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Hızlı kayıt menüsündeki kayıt türleri (teknik.md §8).
enum QuickRecordType {
  inspection(Icons.fact_check_rounded),
  feeding(Icons.water_drop_rounded),
  treatment(Icons.medication_rounded),
  harvest(Icons.scale_rounded),
  note(Icons.sticky_note_2_rounded),
  expense(Icons.payments_rounded);

  new(this.icon);

  final IconData icon;

  String label(AppLocalizations l10n) => switch (this) {
    inspection => l10n.quickRecordInspection,
    feeding => l10n.quickRecordFeeding,
    treatment => l10n.quickRecordTreatment,
    harvest => l10n.quickRecordHarvest,
    note => l10n.quickRecordNote,
    expense => l10n.quickRecordExpense,
  };
}

/// Menüyü sekmelerin üstünde açar; seçilen türü, kapatılırsa null döner.
Future<QuickRecordType?> showQuickRecordSheet(BuildContext context) =>
    showOptionSheet(context, (context) => const QuickRecordSheet());

class QuickRecordSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return OptionSheet(
      title: l10n.quickRecordTitle,
      options: [
        for (final type in QuickRecordType.values)
          SheetOption(value: type, icon: type.icon, label: type.label(l10n)),
      ],
    );
  }
}
