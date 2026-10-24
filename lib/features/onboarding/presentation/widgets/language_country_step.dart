import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/country_picker.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/region_summary.dart';

/// İlk adım: uygulama dili ve ülke. Dil seçimi hemen uygulanır; ülke
/// alttan açılan aranabilir listeden seçilir ve getirdikleri altta
/// özetlenir.
class LanguageCountryStep extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final state = ref.watch(onboardingControllerProvider);
    final countryCode = state.countryCode;
    final names = countryNamesFor(Localizations.localeOf(context).languageCode);
    final countryName = countryCode == null ? null : names[countryCode];
    // "Sistem" seçiliyse cihazdan çözülen dil seçili görünür.
    final current =
        Localizations.localeOf(context).languageCode ==
            AppLanguage.turkish.locale!.languageCode
        ? AppLanguage.turkish
        : AppLanguage.english;
    final device = resolveAppLocale(
      WidgetsBinding.instance.platformDispatcher.locales,
      AppLocalizations.supportedLocales,
    ).languageCode;
    String? deviceHint(AppLanguage language) =>
        language.locale!.languageCode == device
        ? l10n.onboardingDeviceLanguage
        : null;

    Future<void> pickCountry() async {
      final code = await showCountryPicker(
        context,
        selected: countryCode,
        suggested: state.suggestedCountryCode,
      );
      if (code == null) return;
      ref.read(onboardingControllerProvider.notifier).selectCountry(code);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(
            l10n.onboardingLanguageCountryTitle,
            style: context.typography.headline,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.onboardingAppLanguage,
          group: true,
          child: RadioCardGroup<AppLanguage>(
            options: [
              for (final (language, label) in [
                (AppLanguage.turkish, l10n.languageTurkish),
                (AppLanguage.english, l10n.languageEnglish),
              ])
                RadioCardOption(
                  value: language,
                  label: label,
                  hint: deviceHint(language),
                ),
            ],
            selected: current,
            onChanged: (language) =>
                ref.read(languageProvider.notifier).language = language,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.onboardingCountryLabel,
          child: _SelectField(
            value: countryName ?? l10n.onboardingCountryChoose,
            placeholder: countryName == null,
            onTap: pickCountry,
          ),
        ),
        if (countryCode != null && countryName != null) ...[
          SizedBox(height: spacing.xl),
          RegionSummary(
            config: resolveRegionConfig(countryCode),
            countryName: countryName,
          ),
        ],
      ],
    );
  }
}

/// Açılır seçim gibi görünen alan: değer ve aşağı ok; dokununca seçici
/// açılır.
class _SelectField extends StatelessWidget {
  const new({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String value;

  /// Henüz seçilmedi; değer yerine soluk ipucu.
  final bool placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Semantics(
      button: true,
      child: Material(
        color: colors.tile,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.card),
          side: BorderSide(color: colors.divider, width: context.strokes.focus),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.touchTargets.fieldLarge,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: context.typography.subtitle.copyWith(
                        color: placeholder
                            ? colors.textSecondary
                            : colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.expand_more_rounded,
                    size: context.sizes.icon,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
