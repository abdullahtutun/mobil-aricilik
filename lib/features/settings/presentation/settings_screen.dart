import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_aricilik/app/routes.dart';
import 'package:mobil_aricilik/core/design_system/design_system.dart';
import 'package:mobil_aricilik/core/l10n/app_language.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';
import 'package:mobil_aricilik/core/l10n/language_provider.dart';
import 'package:mobil_aricilik/core/region/region_provider.dart';

/// Dil, ülke ve tema seçimi. Seçimler şimdilik yalnızca bellekte.
class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final language = ref.watch(languageProvider);
    final region = ref.watch(regionConfigProvider);
    final colorMode = ref.watch(appearanceProvider).colorMode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          SectionCard(
            title: l10n.settingsLanguage,
            child: ChoiceChipGroup<AppLanguage>(
              options: [
                for (final option in AppLanguage.values)
                  ChoiceChipOption(
                    value: option,
                    label: _languageLabel(l10n, option),
                  ),
              ],
              selected: {language},
              onChanged: (selected) {
                // Ayarda her zaman bir seçim olur; seçili chip'e yeniden
                // dokunmak seçimi kaldırmasın.
                if (selected.isEmpty) return;
                ref.read(languageProvider.notifier).language = selected.single;
              },
            ),
          ),
          SizedBox(height: spacing.lg),
          SectionCard(
            title: l10n.settingsCountry,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.settingsCountryTemporaryNote,
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.settingsCountryOption(
                      region.countryCode,
                      region.currencyCode,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go(AppRoutes.settingsCountry),
                ),
              ],
            ),
          ),
          SizedBox(height: spacing.lg),
          SectionCard(
            title: l10n.settingsColorMode,
            child: ChoiceChipGroup<AppColorMode>(
              options: [
                for (final option in AppColorMode.values)
                  ChoiceChipOption(
                    value: option,
                    label: _colorModeLabel(l10n, option),
                  ),
              ],
              selected: {colorMode},
              onChanged: (selected) {
                if (selected.isEmpty) return;
                ref
                    .read(appearanceProvider.notifier)
                    .setColorMode(selected.single);
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _languageLabel(AppLocalizations l10n, AppLanguage language) {
    return switch (language) {
      AppLanguage.system => l10n.settingsSystemDefault,
      AppLanguage.turkish => l10n.languageTurkish,
      AppLanguage.english => l10n.languageEnglish,
    };
  }

  static String _colorModeLabel(AppLocalizations l10n, AppColorMode mode) {
    return switch (mode) {
      AppColorMode.system => l10n.settingsSystemDefault,
      AppColorMode.light => l10n.settingsColorModeLight,
      AppColorMode.dark => l10n.settingsColorModeDark,
      AppColorMode.sun => l10n.settingsColorModeSun,
    };
  }
}
