import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';

/// Seçilen ülkenin getirdikleri: açılan bölge modülleri (yoksa yalnız
/// birimlerin ülkeye göre seçildiği) ve altında birim, para birimi ve
/// yarımküre chip'leri. Karar `RegionConfig`'ten; ülke kodu kontrol
/// edilmez.
class RegionSummary extends StatelessWidget {
  const new({required this.config, required this.countryName, super.key});

  final RegionConfig config;
  final String countryName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final features = config.features;
    final enabled = [
      if (features.aks) l10n.regionFeatureAks,
      if (features.subsidies) l10n.regionFeatureSubsidies,
      if (features.regulations) l10n.regionFeatureRegulations,
      if (features.trDrugList) l10n.regionFeatureTrDrugList,
      if (features.trFlora) l10n.regionFeatureTrFlora,
      if (features.trMigrationDocs) l10n.regionFeatureTrMigrationDocs,
    ];
    final units = config.defaultUnits;
    final currency = config.currencyCode;
    final symbol = format.currencySymbol(currency);

    return NoteCard(
      title: enabled.isEmpty
          ? l10n.onboardingRegionDefaultsTitle(countryName)
          : l10n.onboardingRegionFeaturesTitle(countryName),
      message: enabled.isEmpty
          ? l10n.onboardingRegionDefaultsMessage
          : _sentence(format, enabled.join(l10n.listSeparator)),
      child: Wrap(
        spacing: context.spacing.sm,
        runSpacing: context.spacing.sm,
        children: [
          _Pill(switch (units.mass) {
            MassUnit.kilogram => l10n.unitKilogram,
            MassUnit.pound => l10n.unitPound,
          }),
          _Pill(switch (units.temperature) {
            TemperatureUnit.celsius => l10n.unitCelsius,
            TemperatureUnit.fahrenheit => l10n.unitFahrenheit,
          }),
          _Pill(symbol == currency ? currency : '$symbol $currency'),
          _Pill(switch (config.hemisphere) {
            Hemisphere.northern => l10n.hemisphereNorthern,
            Hemisphere.southern => l10n.hemisphereSouthern,
          }),
        ],
      ),
    );
  }

  /// Baş harfi büyük, sonu noktalı cümle.
  static String _sentence(AppFormat format, String text) =>
      '${format.upperCase(text.substring(0, 1))}${text.substring(1)}.';
}

class _Pill extends StatelessWidget {
  const new(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.tile,
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.xs,
        ),
        child: Text(label, style: context.typography.label),
      ),
    );
  }
}
