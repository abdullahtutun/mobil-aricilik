import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_widgets.dart';

/// Hasat ve lotlar (docs/design "Hasat lotları"): üstte bu yılın hasadı
/// (koyu karo), stoktaki bal ve yılın kovan başı verimi; altında lot
/// kartları, yeni önce. Lot hasat kaydından açılır; karta dokununca lot.
class LotsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.lotsTitle)),
      body: switch (ref.watch(lotSummariesProvider)) {
        AsyncData(value: []) => EmptyState(
          icon: Icons.inventory_outlined,
          title: l10n.lotsEmptyTitle,
          message: l10n.lotsEmptyMessage,
          centered: true,
        ),
        AsyncData(value: final lots) => _LotList(lots),
        AsyncError() => Center(child: Text(l10n.lotsLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _LotList extends StatelessWidget {
  const new(this.lots);

  final List<LotSummary> lots;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        _Overview(lots),
        for (final summary in lots) ...[
          SizedBox(height: spacing.md),
          LotCard(
            summary,
            onTap: () => context.go(AppRoutes.lot(summary.lot.id)),
          ),
        ],
      ],
    );
  }
}

/// Üç karo: bu yıl (koyu), stokta, kovan başı. Dar ekranda ve büyük yazıda
/// alt alta kayar.
class _Overview extends ConsumerWidget {
  const new(this.lots);

  final List<LotSummary> lots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final year = clock.now().year;
    final overview = lotOverview(lots, year);
    final perHive = overview.perHive;

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = context.spacing;
        final tiles = [
          _YearTile(
            label: '$year',
            value: lotWeight(ref, context, overview.yearKg),
          ),
          SummaryTile(
            label: l10n.lotsInStock,
            value: lotWeight(ref, context, overview.stockKg),
          ),
          SummaryTile(
            label: l10n.lotsPerHive,
            value: perHive == null ? '–' : lotWeight(ref, context, perHive),
          ),
        ];
        // Üç karo yan yana ancak her biri yazısını taşıyacak kadar genişse.
        final scale = MediaQuery.textScalerOf(context).scale(1);
        if (constraints.maxWidth / scale < context.sizes.hiveTile * 3.4) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, tile) in tiles.indexed) ...[
                if (index > 0) SizedBox(height: spacing.sm),
                tile,
              ],
            ],
          );
        }
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, tile) in tiles.indexed) ...[
                if (index > 0) SizedBox(width: spacing.sm),
                Expanded(child: tile),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Bu yılın hasadı: ters zeminde yıl ve bal sarısı büyük değer.
class _YearTile extends StatelessWidget {
  const new({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.inverseSurface,
          borderRadius: BorderRadius.circular(context.radii.card),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.typography.label.copyWith(
                  color: colors.onInverseSurface,
                ),
              ),
              SizedBox(height: context.spacing.xs),
              Text(
                value,
                style: context.typography.title.copyWith(
                  color: colors.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
