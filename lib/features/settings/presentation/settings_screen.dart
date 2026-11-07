import 'dart:async';

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
import 'package:mobil_arici/core/services/app_info_service_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/export/presentation/export_providers.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_labels.dart';
import 'package:mobil_arici/features/media/presentation/media_providers.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';
import 'package:mobil_arici/features/organization/domain/role_permissions.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_labels.dart';

/// Görünüm (tema chip'leri ve eldiven modu), genel (dil; işletmeden gelen
/// ülke), veri ("sadece Wi‑Fi'da yükle", bekleyen dosyalar, "kullanım
/// verisi paylaş", offline haritalar, Excel'e dışa aktarma), varroa ve kovan
/// açma eşikleri, Android'de hatırlatıcıların tam saatinde çalması (kapalıysa
/// dokununca sistem ayarı açılır) ve hesap (çıkış, Hesabımı sil). Görünüm
/// ve dil şimdilik yalnızca bellekte; Wi‑Fi seçimi, analitik ve eşikler bu
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
    final pending = ref.watch(syncPendingCountProvider).value ?? 0;
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
          const ListGroup(
            children: [
              _MediaWifiOnlyTile(),
              _OfflineMapsRow(),
              _PushTile(),
              _AnalyticsTile(),
              _ExportRow(),
              _PrivacyPolicyRow(),
            ],
          ),
          sectionGap,
          SectionLabel(l10n.settingsVarroa),
          labelGap,
          const _VarroaThresholds(),
          sectionGap,
          SectionLabel(l10n.settingsHiveOpening),
          labelGap,
          const _HiveOpeningThresholds(),
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
            onPressed: () => _confirmSignOut(context, ref, pending: pending),
          ),
          SizedBox(height: spacing.md),
          BigButton(
            variant: BigButtonVariant.dangerOutlined,
            icon: Icons.delete_outline_rounded,
            label: l10n.settingsDeleteAccount,
            onPressed: () => unawaited(_openAccountDeletion(context, ref)),
          ),
          if (ref.watch(appVersionProvider).value case final version?) ...[
            sectionGap,
            Text(
              l10n.settingsVersion(version),
              textAlign: TextAlign.center,
              style: context.typography.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
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
  /// Gönderilmeyi bekleyen kayıt varsa ([pending]) onay penceresi bunların
  /// yalnız bu telefonda olduğunu söyler.
  static Future<void> _confirmSignOut(
    BuildContext context,
    WidgetRef ref, {
    required int pending,
  }) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.settingsSignOutConfirmTitle,
      message: pending > 0
          ? l10n.settingsSignOutPendingMessage(pending)
          : l10n.settingsSignOutConfirmMessage,
      confirmLabel: pending > 0
          ? l10n.settingsSignOutAnyway
          : l10n.settingsSignOut,
    );
    if (!confirmed) return;
    // Oturum kapanınca sunucu çağrısı yetkisiz kalır; önce token silinir.
    await ref
        .read(pushRegistrationProvider.notifier)
        .unregister(deleteDeviceToken: true);
    await ref.read(currentUserProvider.notifier).signOut();
  }

  /// Hesap silme internet ister; bağlantı yoksa akış açılmaz, nedeni tek
  /// cümleyle söylenir.
  static Future<void> _openAccountDeletion(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final l10n = AppLocalizations.of(context);
    final online = await ref.read(connectivityServiceProvider).isOnline();
    if (!context.mounted) return;
    if (!online) {
      showMessageSnackBar(context, l10n.settingsDeleteAccountOffline);
      return;
    }
    context.go(AppRoutes.deleteAccount);
  }

  static String _languageLabel(AppLocalizations l10n, AppLanguage language) {
    return language == AppLanguage.system
        ? l10n.settingsSystemDefault
        : language.nativeName;
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

/// "Offline haritalar": indirilmiş arılık çevresi sayısı ve toplam boyut;
/// dokununca offline harita ekranı açılır.
class _OfflineMapsRow extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final installed = ref.watch(installedMapAreasProvider).value ?? const [];
    final bytes = installed.fold(0, (sum, row) => sum + row.bytes);

    return ListRow(
      title: l10n.settingsOfflineMaps,
      value: l10n.settingsOfflineMapsValue(
        installed.length,
        l10n.offlineMapsMegabytes(AppFormat.of(context).megabytes(bytes)),
      ),
      onTap: () => context.go(AppRoutes.offlineMaps),
    );
  }
}

/// "Görev bildirimleri": sana görev atanınca push gelir; kapatınca bu
/// telefonun kaydı sunucudan silinir.
class _PushTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final enabled = ref.watch(pushEnabledProvider).value ?? true;

    return SwitchListTile(
      value: enabled,
      onChanged: (enabled) => unawaited(
        ref
            .read(pushRegistrationProvider.notifier)
            .setEnabled(enabled: enabled),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
      title: Text(l10n.settingsPush, style: context.typography.body),
      subtitle: Text(
        l10n.settingsPushHint,
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

/// Kovan açma eşikleri: sıcaklık, rüzgar ve yağış olasılığı. Hava ekranı ve
/// Bugün kartları bunlara göre "Açılır" der. Değerler metrik saklanır,
/// kullanıcının biriminde gösterilir; seçim alttan açılan sayfada.
class _HiveOpeningThresholds extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final units = WeatherFormat(
      l10n,
      AppFormat.of(context),
      ref.watch(regionConfigProvider).defaultUnits,
    );
    final thresholds =
        ref.watch(hiveOpeningThresholdsProvider).value ??
        defaultHiveOpeningThresholds;
    final settings = ref.read(localSettingsRepositoryProvider);

    Future<void> choose(
      String title,
      List<double> options,
      double current,
      String Function(double value) label,
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
                label: label(option),
                selected: option == current,
              ),
          ],
        ),
      );
      if (chosen != null) await save(chosen);
    }

    String temperature(double value) =>
        l10n.settingsHiveOpeningTemperatureValue(units.temperature(value));
    String wind(double value) =>
        l10n.settingsHiveOpeningBelow(units.speed(value));
    String precipitation(double value) =>
        l10n.settingsHiveOpeningBelow(units.percent(value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListGroup(
          children: [
            ListRow(
              title: l10n.settingsHiveOpeningTemperature,
              value: temperature(thresholds.minTemperatureC),
              onTap: () => choose(
                l10n.settingsHiveOpeningTemperature,
                minTemperatureOptions,
                thresholds.minTemperatureC,
                temperature,
                settings.setHiveOpeningMinTemperature,
              ),
            ),
            ListRow(
              title: l10n.settingsHiveOpeningWind,
              value: wind(thresholds.maxWindKmh),
              onTap: () => choose(
                l10n.settingsHiveOpeningWind,
                maxWindOptions,
                thresholds.maxWindKmh,
                wind,
                settings.setHiveOpeningMaxWind,
              ),
            ),
            ListRow(
              title: l10n.settingsHiveOpeningPrecipitation,
              value: precipitation(thresholds.maxPrecipitationProbability),
              onTap: () => choose(
                l10n.settingsHiveOpeningPrecipitation,
                maxPrecipitationOptions,
                thresholds.maxPrecipitationProbability,
                precipitation,
                settings.setHiveOpeningMaxPrecipitation,
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing.sm),
        Text(
          l10n.settingsHiveOpeningHint,
          style: context.typography.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// "Verileri dışa aktar · Excel": tüm ana kayıtlar tek dosyada, paylaşma
/// sayfasıyla; gelir/gider yalnız owner ve partner'da. Hazırlanırken satır
/// pasif; hazırlanamazsa mesaj gösterilir.
/// Mağazalara verilen gizlilik politikası; Apple uygulama içinden de
/// ulaşılabilmesini istiyor. Kaynağı `docs/legal/privacy-policy.html`.
final Uri privacyPolicyUri = Uri.parse(
  'https://tutunsoft.com/mobil-arici/privacy-policy',
);

class _PrivacyPolicyRow extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListRow(
    title: AppLocalizations.of(context).settingsPrivacyPolicy,
    trailing: Icon(
      Icons.open_in_new_rounded,
      color: context.colors.textSecondary,
    ),
    onTap: () =>
        unawaited(ref.read(urlLauncherServiceProvider).open(privacyPolicyUri)),
  );
}

class _ExportRow extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(dataExportProvider);
    // Dinlenir ki üyelik inince rol hazır olsun.
    final includeFinance = canExportFinance(ref.watch(currentRoleProvider));

    Future<void> export() async {
      try {
        await ref
            .read(dataExportProvider.notifier)
            .export(l10n, includeFinance: includeFinance);
      } on Object {
        if (context.mounted) showMessageSnackBar(context, l10n.exportFailed);
      }
    }

    return ListRow(
      title: l10n.settingsExport,
      subtitle: l10n.settingsExportHint,
      value: busy ? l10n.exportPreparing : l10n.settingsExportValue,
      onTap: busy ? null : () => unawaited(export()),
    );
  }
}
