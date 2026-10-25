import 'dart:math';

import 'package:clock/clock.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/varroa_providers.dart';

/// Arılığın son varroa ölçümleri kartı: [title] ve gün başına ortalama
/// bulaşıklığın çubuk grafiği ([apiaryVarroaBars]); kesikli çizgi
/// bulaşıklık eşiği. Her çubuğun üstünde değeri; eşiğe ulaşan gün uyarı
/// renginde ve değeri kalın. Ölçüm yoksa nasıl ekleneceğini söyler.
class ApiaryVarroaCard extends ConsumerWidget {
  const new({required this.apiaryId, required this.title, super.key});

  final String apiaryId;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final bars = ref.watch(apiaryVarroaBarsOfProvider(apiaryId));
    final thresholds =
        ref.watch(varroaThresholdsProvider).value ?? defaultVarroaThresholds;
    // Yüklenirken boş kalır; "ölçüm yok" yanıp sönmesin.
    if (!bars.hasValue) return const SizedBox.shrink();
    final values = bars.value!;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(title, style: context.typography.subtitle),
            ),
            SizedBox(height: spacing.md),
            if (values.isEmpty)
              Text(
                l10n.varroaChartEmpty,
                style: context.typography.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              )
            else
              VarroaBarChart(bars: values, threshold: thresholds.percent),
          ],
        ),
      ),
    );
  }
}

/// Bulaşıklık çubukları ve eşik çizgisi. Ekran okuyucu grafiği tek cümle
/// okur: eşik ve her günün değeri.
class VarroaBarChart extends StatelessWidget {
  const new({required this.bars, required this.threshold, super.key});

  final List<VarroaBar> bars;

  /// Bulaşıklık eşiği (%).
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final typography = context.typography;
    final now = clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final warning = AppStatus.warning.colorIn(colors);
    final thresholdText = l10n.varroaPercent(threshold);
    final highest = bars.map((bar) => bar.percent).fold(threshold, max);

    String dayText(DateTime day) =>
        day == today ? l10n.relativeToday : format.dayMonth(day);
    bool reached(VarroaBar bar) => bar.percent >= threshold;

    final summary = l10n.varroaChartSemantics(
      thresholdText,
      [
        for (final bar in bars)
          l10n.varroaChartBar(
            dayText(bar.day),
            [
              l10n.varroaPercent(bar.percent),
              if (reached(bar)) l10n.hiveVarroaReached,
            ].join(l10n.titleSeparator),
          ),
      ].join(l10n.listSeparator),
    );

    return Semantics(
      label: summary,
      excludeSemantics: true,
      child: SizedBox(
        height: context.sizes.chart,
        child: BarChart(
          BarChartData(
            // Değer yazısı ve eşik etiketi için üstte pay.
            maxY: highest * 1.4,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            barTouchData: const BarTouchData(enabled: false),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: typography.bodySmall.fontSize! * 2,
                  getTitlesWidget: (value, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(
                      dayText(bars[value.toInt()].day),
                      style: typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: threshold,
                  color: warning,
                  strokeWidth: context.strokes.border,
                  dashArray: const [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(bottom: context.spacing.xs),
                    style: typography.labelSmall.copyWith(color: warning),
                    labelResolver: (_) =>
                        l10n.varroaChartThreshold(thresholdText),
                  ),
                ),
              ],
            ),
            barGroups: [
              for (final (index, bar) in bars.indexed)
                BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: bar.percent,
                      color: reached(bar) ? warning : colors.divider,
                      width: context.touchTargets.minimum,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(context.radii.small),
                      ),
                      label: BarChartRodLabel(
                        text: l10n.varroaPercent(bar.percent),
                        style: reached(bar)
                            ? typography.labelSmall.copyWith(color: warning)
                            : typography.bodySmall.copyWith(
                                color: colors.textSecondary,
                              ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
