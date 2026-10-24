import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Hızlı kayıt menüsündeki kayıt türleri (teknik.md §8).
enum QuickRecordType {
  inspection(Icons.description_outlined),
  feeding(Icons.water_drop_outlined),
  treatment(Icons.medication_outlined),
  harvest(Icons.scale_outlined),
  note(Icons.mic_none_rounded),
  expense(Icons.credit_card_rounded);

  new(this.icon);

  final IconData icon;

  /// İkon rengi türü ayırt etmeye yardım eder; anlamı kelime taşır.
  Color iconColorIn(AppColors colors) => switch (this) {
    inspection => colors.primary,
    feeding => colors.statusInfo,
    treatment => colors.statusCritical,
    harvest => colors.primary,
    note => colors.secondary,
    expense => colors.textSecondary,
  };

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

/// Büyük karolar; en sık kayıt (muayene) dolgulu ve ilk sırada.
class QuickRecordSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return OptionGridSheet(
      title: l10n.quickRecordTitle,
      highlighted: QuickRecordType.inspection,
      options: [
        for (final type in QuickRecordType.values)
          SheetOption(
            value: type,
            icon: type.icon,
            iconColor: type.iconColorIn(context.colors),
            label: type.label(l10n),
          ),
      ],
    );
  }
}
