import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';

/// Kovan tipi; zorunlu, seçili chip'e yeniden dokunmak seçimi kaldırmaz.
class HiveTypeField extends StatelessWidget {
  const new({required this.selected, required this.onChanged, super.key});

  final HiveType selected;
  final ValueChanged<HiveType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      title: l10n.hiveFormType,
      child: ChoiceChipGroup<HiveType>(
        options: [
          for (final type in HiveType.values)
            ChoiceChipOption(value: type, label: type.label(l10n)),
        ],
        selected: {selected},
        onChanged: (selected) {
          if (selected.isNotEmpty) onChanged(selected.single);
        },
      ),
    );
  }
}

/// Kovan kaynağı; isteğe bağlı, seçili chip'e yeniden dokunmak kaldırır.
class HiveSourceField extends StatelessWidget {
  const new({required this.selected, required this.onChanged, super.key});

  final HiveSource? selected;
  final ValueChanged<HiveSource?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SectionCard(
      title: l10n.hiveFormSource,
      child: ChoiceChipGroup<HiveSource>(
        options: [
          for (final source in HiveSource.values)
            ChoiceChipOption(value: source, label: source.label(l10n)),
        ],
        selected: {?selected},
        onChanged: (selected) => onChanged(selected.firstOrNull),
      ),
    );
  }
}
