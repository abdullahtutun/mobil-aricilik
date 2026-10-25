import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_labels.dart';

/// Ölçüm formundaki sonuç: solda büyük sonuç ve ne olduğu ("BULAŞIKLIK"),
/// sağda eşiğe göre durum ve eşiğin değeri. Eşiğe ulaşınca uyarı zemininde,
/// altındaysa iyi zemininde; durum ikon ve kelimeyle de yazar.
class VarroaResultCard extends StatelessWidget {
  const new({required this.load, required this.thresholds, super.key});

  final MiteLoad load;
  final VarroaThresholds thresholds;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final reached = reachesThreshold(load, thresholds);
    final status = reached ? AppStatus.warning : AppStatus.good;
    final statusColor = status.colorIn(colors);
    final isPercent = load.unit == MiteLoadUnit.percent;
    final threshold = miteValueText(
      l10n,
      thresholdFor(load.unit, thresholds),
      load.unit,
    );

    return MergeSemantics(
      child: AppCard(
        status: status,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isPercent
                            ? l10n.varroaPercent(load.value)
                            : AppFormat.of(context)
                                  .number(load.value, maxFractionDigits: 1),
                        // Alt tablada birimi altındaki kelime söyler.
                        semanticsLabel: miteLoadText(l10n, load),
                        style: context.typography.numberLarge.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ),
                    SectionLabel(
                      isPercent ? l10n.varroaInfestation : l10n.varroaDailyDrop,
                      status: status,
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          status.icon,
                          size: context.sizes.icon,
                          color: statusColor,
                        ),
                        SizedBox(width: spacing.xs),
                        Expanded(
                          child: Text(
                            reached ? l10n.varroaReached : l10n.varroaBelow,
                            style: context.typography.subtitle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      l10n.varroaThresholdNote(threshold),
                      style: context.typography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
