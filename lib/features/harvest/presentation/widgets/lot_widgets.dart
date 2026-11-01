import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/harvest_labels.dart';

extension LotStatusLabel on LotStatus {
  String label(AppLocalizations l10n) => switch (this) {
    LotStatus.open => l10n.lotStatusOpen,
    LotStatus.closed => l10n.lotStatusClosed,
  };
}

extension ResidueResultLabel on ResidueResult {
  String label(AppLocalizations l10n) => switch (this) {
    ResidueResult.none => l10n.labResidueNone,
    ResidueResult.detected => l10n.labResidueDetected,
  };
}

extension LotLabels on Lot {
  /// "Lot 2026-07".
  String number(AppLocalizations l10n) =>
      l10n.lotNumber(formatLotNumber(year, seq));

  /// "Lot 2026-07 · Kızılçam".
  String subtitle(AppLocalizations l10n) =>
      [number(l10n), ?origin].join(l10n.titleSeparator);

  /// "Çam balı".
  String title(AppLocalizations l10n) =>
      l10n.lotHoneyTitle(honeyKind.label(l10n));
}

/// [kg] kilogramı kullanıcının kütle biriminde ("574 kg", "1.265 lb").
String lotWeight(WidgetRef ref, BuildContext context, double kg) {
  final l10n = AppLocalizations.of(context);
  final mass = ref.watch(regionConfigProvider).defaultUnits.mass;
  return l10n.harvestWeightValue(
    AppFormat.of(context)
        .number(MassUnit.kilogram.convert(kg, to: mass), maxFractionDigits: 1),
    mass.label(l10n),
  );
}

/// Bal türünün kavanoz rengi; anlamı yanındaki ad taşır.
class HoneySwatch extends StatelessWidget {
  const new(this.kind, {super.key});

  final HoneyKind kind;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: context.sizes.avatar,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.honeySwatch(kind),
          borderRadius: BorderRadius.circular(context.radii.button),
        ),
      ),
    ),
  );
}

/// Lot kartındaki yalın etiket ("Nem %17,2", "Stok 410 kg"): kart zemininde
/// tam yuvarlak.
class LotTag extends StatelessWidget {
  const new(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Text(label, style: context.typography.label),
      ),
    );
  }
}

/// Lotun etiketleri: nem, analiz durumu, stok ve varsa bekleme süresi
/// ihlali (renk + ikon + kelime).
class LotTags extends ConsumerWidget {
  const new(this.summary, {super.key});

  final LotSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final moisture = summary.lot.moisture;

    return Wrap(
      spacing: context.spacing.sm,
      runSpacing: context.spacing.sm,
      children: [
        if (summary.violation)
          StatusBadge(
            status: AppStatus.critical,
            label: l10n.lotWithdrawalBadge,
          ),
        if (moisture != null)
          LotTag(
            l10n.lotMoistureValue(
              format.number(moisture, maxFractionDigits: 1),
            ),
          ),
        if (summary.analyzed)
          StatusBadge(status: AppStatus.good, label: l10n.lotAnalyzed)
        else
          StatusBadge(
            status: AppStatus.warning,
            label: l10n.lotAnalysisPending,
          ),
        LotTag(l10n.lotStockValue(lotWeight(ref, context, lotStock(summary)))),
      ],
    );
  }
}

/// Lot kartı (docs/design "Hasat lotları"): bal rengi, bal türü, "Lot
/// 2026-07 · yöre", sağda kilogram; altında etiketler. İhlalli lot kritik
/// zeminde. [onTap] verilirse kart dokunulabilir.
class LotCard extends ConsumerWidget {
  const new(this.summary, {super.key, this.onTap});

  final LotSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final lot = summary.lot;

    return MergeSemantics(
      child: AppCard(
        status: summary.violation ? AppStatus.critical : null,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HoneySwatch(lot.honeyKind),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lot.title(l10n), style: context.typography.title),
                        Text(
                          lot.subtitle(l10n),
                          style: context.typography.body.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Text(
                    lotWeight(ref, context, summary.kg),
                    style: context.typography.subtitle,
                  ),
                ],
              ),
              SizedBox(height: spacing.md),
              LotTags(summary),
            ],
          ),
        ),
      ),
    );
  }
}
