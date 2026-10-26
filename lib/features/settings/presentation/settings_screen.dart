import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/analytics/analytics_providers.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/country_names.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_labels.dart';
import 'package:mobil_arici/features/media/presentation/media_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';

/// Görünüm (tema chip'leri ve eldiven modu), genel (dil; işletmeden gelen
/// ülke), veri ("sadece Wi‑Fi'da yükle", bekleyen dosyalar, "kullanım
/// verisi paylaş" ve PDF raporları), varroa
/// eşikleri, Android'de hatırlatıcıların tam saatinde çalması (kapalıysa
/// dokununca sistem ayarı açılır) ve hesap. Görünüm ve dil şimdilik
/// yalnızca bellekte; Wi‑Fi seçimi, analitik ve varroa eşikleri bu
/// telefonun yerel DB'sinde. Ülke burada seçilmez, yalnız gösterilir.
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
          SectionLabel(l10n.settingsData),
          labelGap,
          ListGroup(
            children: [
              const _MediaWifiOnlyTile(),
              const _AnalyticsTile(),
              ListRow(
                title: l10n.settingsReports,
                onTap: () => context.push(AppRoutes.reports),
              ),
            ],
          ),
          sectionGap,
          SectionLabel(l10n.settingsVarroa),
          labelGap,
          const _VarroaThresholds(),
          if (ref.watch(reminderAccessProvider).value case ReminderAccessState(
            supportsExact: true,
            :final exact,
          )) ...[
            sectionGap,
            SectionLabel(l10n.settingsReminders),
            labelGap,
            ListGroup(
              children: [
                ListRow(
                  title: l10n.settingsExactAlarms,
                  value: exact
                      ? l10n.settingsExactAlarmsOn
                      : l10n.settingsExactAlarmsOff,
                  onTap: exact
                      ? null
                      : () => ref
                            .read(reminderAccessProvider.notifier)
                            .requestExact(),
                ),
              ],
            ),
          ],
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

/// "Fotoğrafları sadece Wi‑Fi'da yükle"; altında yüklenmeyi bekleyen dosya
/// sayısı ya da açıklama.
class _MediaWifiOnlyTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wifiOnly = ref.watch(mediaWifiOnlyProvider).value ?? false;
    final pending = ref.watch(pendingMediaUploadsProvider).value ?? 0;

    return SwitchListTile(
      value: wifiOnly,
      onChanged: (enabled) => ref
          .read(localSettingsRepositoryProvider)
          .setMediaWifiOnly(enabled: enabled),
      contentPadding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
      title: Text(l10n.settingsMediaWifiOnly, style: context.typography.body),
      subtitle: Text(
        pending > 0
            ? l10n.settingsPendingUploads(pending)
            : l10n.settingsMediaWifiOnlyHint,
        style: context.typography.bodySmall.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

/// "Kullanım verisi paylaş"; kapatınca bekleyen olaylar da silinir.
class _AnalyticsTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final enabled = ref.watch(analyticsEnabledProvider).value ?? true;

    return SwitchListTile(
      value: enabled,
      onChanged: (enabled) =>
          ref.read(analyticsRepositoryProvider).setEnabled(enabled: enabled),
      contentPadding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
      title: Text(l10n.settingsAnalytics, style: context.typography.body),
      subtitle: Text(
        l10n.settingsAnalyticsHint,
        style: context.typography.bodySmall.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

/// Varroa uyarı eşikleri: bulaşıklık (pudra şekeri, alkol) ve alt tabla
/// günlük dökümü; seçim alttan açılan sayfada, klavyesiz.
class _VarroaThresholds extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final thresholds =
        ref.watch(varroaThresholdsProvider).value ?? defaultVarroaThresholds;
    final settings = ref.read(localSettingsRepositoryProvider);

    Future<void> choose(
      String title,
      MiteLoadUnit unit,
      List<double> options,
      double current,
      Future<void> Function(double value) save,
    ) async {
      final chosen = await showOptionSheet<double>(
        context,
        (context) => OptionSheet(
          title: title,
          options: [
            for (final option in options)
              SheetOption(
                value: option,
                icon: option == current
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                iconColor: option == current ? null : context.colors.outline,
                label: miteValueText(l10n, option, unit),
                selected: option == current,
              ),
          ],
        ),
      );
      if (chosen != null) await save(chosen);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListGroup(
          children: [
            ListRow(
              title: l10n.settingsVarroaPercent,
              value: miteValueText(
                l10n,
                thresholds.percent,
                MiteLoadUnit.percent,
              ),
              onTap: () => choose(
                l10n.settingsVarroaPercent,
                MiteLoadUnit.percent,
                percentThresholdOptions,
                thresholds.percent,
                settings.setVarroaPercentThreshold,
              ),
            ),
            ListRow(
              title: l10n.settingsVarroaPerDay,
              value: miteValueText(
                l10n,
                thresholds.perDay,
                MiteLoadUnit.perDay,
              ),
              onTap: () => choose(
                l10n.settingsVarroaPerDay,
                MiteLoadUnit.perDay,
                perDayThresholdOptions,
                thresholds.perDay,
                settings.setVarroaPerDayThreshold,
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing.sm),
        Text(
          l10n.settingsVarroaHint,
          style: context.typography.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
