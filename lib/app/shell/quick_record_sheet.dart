import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/design_system/design_system.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

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
Future<QuickRecordType?> showQuickRecordSheet(BuildContext context) {
  return showModalBottomSheet<QuickRecordType>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const QuickRecordSheet(),
  );
}

class QuickRecordSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: spacing.lg,
          right: spacing.lg,
          bottom: spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.quickRecordTitle,
                style: context.typography.title,
              ),
            ),
            SizedBox(height: spacing.md),
            for (final type in QuickRecordType.values)
              _Option(
                icon: type.icon,
                label: type.label(l10n),
                // Sayfa kök navigator'da; go_router'ın pop'u alttaki sekme
                // yığınını kapatabileceği için sayfanın kendi navigator'ı.
                onTap: () => Navigator.of(context).pop(type),
              ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Semantics(
      container: true,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radii.button),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.sm),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: context.sizes.icon,
                  color: context.colors.primary,
                ),
                SizedBox(width: spacing.lg),
                Expanded(child: Text(label, style: context.typography.label)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
