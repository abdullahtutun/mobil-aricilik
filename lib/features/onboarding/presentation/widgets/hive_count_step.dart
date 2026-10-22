import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/step_header.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';

/// "Kaç kovanın var?" Yaklaşık aralık yeter; kovan oluşturmaz.
class HiveCountStep extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(
      onboardingControllerProvider.select((state) => state.hiveCountRange),
    );

    return ListView(
      padding: EdgeInsets.all(context.spacing.lg),
      children: [
        StepHeader(
          title: l10n.onboardingHiveCountTitle,
          message: l10n.onboardingHiveCountMessage,
        ),
        SizedBox(height: context.spacing.xl),
        ChoiceChipGroup<HiveCountRange>(
          options: [
            for (final range in HiveCountRange.values)
              ChoiceChipOption(value: range, label: _label(l10n, range)),
          ],
          selected: {?selected},
          onChanged: (ranges) => ref
              .read(onboardingControllerProvider.notifier)
              .selectHiveCountRange(ranges.singleOrNull),
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
