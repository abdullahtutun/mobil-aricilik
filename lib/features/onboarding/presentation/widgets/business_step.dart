import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';

/// İkinci adım: işletme adı ve yaklaşık kovan sayısı (kovan oluşturmaz).
class BusinessStep extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<BusinessStep> createState() => _BusinessStepState();
}

class _BusinessStepState extends ConsumerState<BusinessStep> {
  // Geri dönülüp yeniden gelinince yazılan ad korunur.
  late final _name = TextEditingController(
    text: ref.read(onboardingControllerProvider).name,
  );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final controller = ref.read(onboardingControllerProvider.notifier);
    final range = ref.watch(
      onboardingControllerProvider.select((state) => state.hiveCountRange),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.onboardingBusinessTitle,
            style: context.typography.headline,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.onboardingNameLabel,
          helper: l10n.onboardingNameMessage,
          child: TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            style: context.typography.subtitle.copyWith(
              fontWeight: context.typography.body.fontWeight,
            ),
            decoration: InputDecoration(hintText: l10n.onboardingNameHint),
            onChanged: controller.updateName,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.onboardingHiveCountTitle,
          group: true,
          helper: l10n.onboardingHiveCountMessage,
          child: ChoiceChipGroup<HiveCountRange>(
            columns: 2,
            options: [
              for (final range in HiveCountRange.values)
                ChoiceChipOption(value: range, label: _label(l10n, range)),
            ],
            selected: {?range},
            onChanged: (ranges) =>
                controller.selectHiveCountRange(ranges.singleOrNull),
          ),
        ),
      ],
    );
  }

  static String _label(AppLocalizations l10n, HiveCountRange range) {
    return switch (range) {
      HiveCountRange.none => l10n.hiveCountRangeNone,
      HiveCountRange.upTo10 => l10n.hiveCountRangeUpTo10,
      HiveCountRange.upTo50 => l10n.hiveCountRangeUpTo50,
      HiveCountRange.upTo200 => l10n.hiveCountRangeUpTo200,
      HiveCountRange.over200 => l10n.hiveCountRangeOver200,
    };
  }
}
