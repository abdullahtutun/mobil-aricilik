import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/step_header.dart';

/// Dil seçimi. Seçim hemen uygulanır; sonraki adımlar seçilen dilde açılır.
class LanguageStep extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // "Sistem" seçiliyse cihazdan çözülen dil seçili görünür.
    final current =
        Localizations.localeOf(context).languageCode ==
            AppLanguage.turkish.locale!.languageCode
        ? AppLanguage.turkish
        : AppLanguage.english;

    return ListView(
      padding: EdgeInsets.all(context.spacing.lg),
      children: [
        StepHeader(
          title: l10n.onboardingLanguageTitle,
          message: l10n.onboardingLanguageMessage,
        ),
        SizedBox(height: context.spacing.xl),
        ChoiceChipGroup<AppLanguage>(
          options: [
            ChoiceChipOption(
              value: AppLanguage.turkish,
              label: l10n.languageTurkish,
            ),
            ChoiceChipOption(
              value: AppLanguage.english,
              label: l10n.languageEnglish,
            ),
          ],
          selected: {current},
          onChanged: (selected) {
            // Bir dil hep seçili kalır.
            if (selected.isEmpty) return;
            ref.read(languageProvider.notifier).language = selected.single;
          },
        ),
      ],
    );
  }
}
