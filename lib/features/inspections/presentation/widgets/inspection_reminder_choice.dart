import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';

/// Kaydettikten sonraki bildirimde "Tekrar bakmayı hatırlat: 3 / 7 / 14
/// gün". Seçili chip'e yeniden dokunmak hatırlatmayı kaldırır ([onChanged]
/// null alır).
class InspectionReminderChoice extends StatefulWidget {
  const new({required this.onChanged, super.key});

  final ValueChanged<int?> onChanged;

  @override
  State<InspectionReminderChoice> createState() =>
      _InspectionReminderChoiceState();
}

class _InspectionReminderChoiceState extends State<InspectionReminderChoice> {
  int? _days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.inspectionRemindPrompt),
        SizedBox(height: context.spacing.sm),
        ChoiceChipGroup<int>(
          options: [
            for (final days in inspectionReminderDays)
              ChoiceChipOption(
                value: days,
                label: l10n.inspectionRemindDays(days),
              ),
          ],
          selected: {?_days},
          onChanged: (selected) {
            setState(() => _days = selected.firstOrNull);
            widget.onChanged(_days);
          },
        ),
      ],
    );
  }
}
