import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';

/// Görünüm (tema chip'leri ve eldiven modu), genel (dil; işletmeden gelen
/// ülke) ve hesap. Seçimler şimdilik yalnızca bellekte. Ülke burada
/// seçilmez, yalnız gösterilir.
class SettingsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final language = ref.watch(languageProvider);
    final appearance = ref.watch(appearanceProvider);
    final user = ref.watch(currentUserProvider);
    final region = ref.watch(regionConfigProvider);
    final countryName = countryNamesFor(
      Localizations.localeOf(context).languageCode,
    )[region.countryCode];
    final sectionGap = SizedBox(height: spacing.xl);
    final labelGap = SizedBox(height: spacing.sm);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          SectionLabel(l10n.settingsColorMode),
          labelGap,
          ChoiceChipGroup<AppColorMode>(
            columns: 2,
            options: [
              for (final option in AppColorMode.values)
                ChoiceChipOption(
                  value: option,
                  label: _colorModeLabel(l10n, option),
                ),
            ],
            selected: {appearance.colorMode},
            onChanged: (selected) {
              // Ayarda her zaman bir seçim olur; seçili chip'e yeniden
              // dokunmak seçimi kaldırmasın.
              if (selected.isEmpty) return;
              ref
                  .read(appearanceProvider.notifier)
                  .setColorMode(selected.single);
            },
          ),
          SizedBox(height: spacing.md),
          ListGroup(
            children: [
              SwitchListTile(
                value: appearance.gloveMode,
                onChanged: (enabled) => ref
                    .read(appearanceProvider.notifier)
                    .setGloveMode(enabled: enabled),
                contentPadding: EdgeInsets.symmetric(horizontal: spacing.lg),
                title: Text(
                  l10n.settingsGloveMode,
                  style: context.typography.body,
                ),
                subtitle: Text(
                  l10n.settingsGloveModeHint,
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          sectionGap,
          SectionLabel(l10n.settingsGeneral),
          labelGap,
          ListGroup(
            children: [
              ListRow(
                title: l10n.settingsLanguage,
                value: _languageLabel(l10n, language),
                onTap: () => _chooseLanguage(context, ref, language),
              ),
              ListRow(
                title: l10n.settingsCountry,
                value: l10n.settingsCountryValue(
                  countryName ?? region.countryCode,
                  region.countryCode,
                ),
              ),
            ],
          ),
          sectionGap,
          SectionLabel(l10n.settingsAccount),
          labelGap,
          if (user?.email case final email?) ...[
            ListGroup(
              children: [ListRow(title: l10n.settingsSignedInAs(email))],
            ),
            SizedBox(height: spacing.md),
          ],
          BigButton(
            variant: BigButtonVariant.secondary,
            label: l10n.settingsSignOut,
            onPressed: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
    );
  }

  /// Dil seçimi alttan açılan sayfada; seçili dil onay ikonlu.
  static Future<void> _chooseLanguage(
    BuildContext context,
    WidgetRef ref,
    AppLanguage current,
  ) async {
    final l10n = AppLocalizations.of(context);
    final chosen = await showOptionSheet<AppLanguage>(
      context,
      (context) => OptionSheet(
        title: l10n.settingsLanguage,
        options: [
          for (final option in AppLanguage.values)
            SheetOption(
              value: option,
              icon: option == current
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              iconColor: option == current ? null : context.colors.outline,
              label: _languageLabel(l10n, option),
              selected: option == current,
            ),
        ],
      ),
    );
    if (chosen != null) ref.read(languageProvider.notifier).language = chosen;
  }

  /// Onaylanırsa yerel oturum silinir; router giriş ekranına geçer.
  static Future<void> _confirmSignOut(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.settingsSignOutConfirmTitle,
      message: l10n.settingsSignOutConfirmMessage,
      confirmLabel: l10n.settingsSignOut,
    );
    if (confirmed) await ref.read(currentUserProvider.notifier).signOut();
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
