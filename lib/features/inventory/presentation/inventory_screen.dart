import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/inventory_rules.dart';
import 'package:mobil_arici/features/inventory/domain/shopping_rules.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_providers.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_labels.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_move_sheet.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Malzeme ve stok (docs/design "Malzeme ve stok"): alınacak bir şey
/// varsa üstte alışveriş listesi kartı; Sarf / Ekipman / Petek sekmeleri,
/// kalemler tek kartta: ad · konum, sağda stok, altında eşiğe göre çubuk
/// ve eşiğin altındaysa uyarı. Kaleme dokununca hızlı giriş / çıkış
/// sayfası açılır; viewer'da kalemin ayrıntısı.
class InventoryScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  InventoryCategory _category = InventoryCategory.consumable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);
    void add() => context.go(AppRoutes.inventoryNew(_category));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inventoryTitle),
        actions: [
          if (canWrite)
            AppBarAddButton(label: l10n.inventoryAdd, onPressed: add),
        ],
      ),
      body: switch (ref.watch(inventoryStocksProvider)) {
        AsyncData(value: []) => EmptyState(
          icon: Icons.inventory_2_outlined,
          title: l10n.inventoryEmptyTitle,
          message: l10n.inventoryEmptyMessage,
          actionLabel: canWrite ? l10n.inventoryAdd : null,
          onAction: canWrite ? add : null,
          centered: true,
        ),
        AsyncData(value: final stocks) => _StockList(
          stocks: inventoryInCategory(stocks, _category),
          category: _category,
          onCategoryChanged: (category) => setState(() => _category = category),
        ),
        AsyncError() => Center(child: Text(l10n.inventoryLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _StockList extends StatelessWidget {
  const new({
    required this.stocks,
    required this.category,
    required this.onCategoryChanged,
  });

  final List<InventoryStock> stocks;
  final InventoryCategory category;
  final ValueChanged<InventoryCategory> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        const _ShoppingCard(),
        SegmentedTabs<InventoryCategory>(
          expanded: true,
          options: [
            for (final category in InventoryCategory.values)
              SegmentOption(value: category, label: category.label(l10n)),
          ],
          selected: category,
          onChanged: onCategoryChanged,
        ),
        SizedBox(height: spacing.lg),
        if (stocks.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.xl),
            child: Text(
              l10n.inventoryCategoryEmpty,
              textAlign: TextAlign.center,
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          )
        else
          ListGroup(children: [for (final stock in stocks) _StockRow(stock)]),
      ],
    );
  }
}

/// Alışveriş listesi kartı: koyu zeminde çanta ikonu, "Alışveriş listesi ·
/// 3" ve alınacakların adları; dokununca liste açılır. Liste boşsa yok.
/// Alt boşluğu kendisinde.
class _ShoppingCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final languageCode = Localizations.localeOf(context).languageCode;
    final lines =
        ref.watch(shoppingListOfProvider(languageCode)).value ??
        const <ShoppingLine>[];
    if (lines.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.lg),
      child: MergeSemantics(
        child: Material(
          color: colors.inverseSurface,
          borderRadius: BorderRadius.circular(context.radii.card),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.go(AppRoutes.inventoryShopping),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: context.touchTargets.field,
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: context.sizes.icon,
                      color: colors.inversePrimary,
                    ),
                    SizedBox(width: spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.shoppingCardTitle(lines.length),
                            style: context.typography.subtitle.copyWith(
                              color: colors.onInverseSurface,
                            ),
                          ),
                          Text(
                            [for (final line in lines) line.name].join(', '),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.typography.bodySmall.copyWith(
                              color: colors.onInverseSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.onInverseSurface,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kalem satırı: kalın ad · konum, sağda stok; altında çubuk (eşiksiz
/// kalemde yok) ve eşiğin altındaysa uyarı. Eşiğin altındaki stok uyarı
/// renginde.
class _StockRow extends ConsumerWidget {
  const new(this.stock);

  final InventoryStock stock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final item = stock.item;
    final below = isBelowThreshold(stock);
    final tone = below ? colors.statusWarning : colors.statusGood;
    final place = item.place;
    final canWrite = ref.watch(canWriteRecordsProvider);

    return MergeSemantics(
      child: InkWell(
        onTap: canWrite
            ? () => unawaited(
                showInventoryMoveSheet(context, ref, stock, showDetails: true),
              )
            : () => context.go(AppRoutes.inventoryItem(item.id)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: item.name,
                          style: context.typography.subtitle,
                          children: [
                            if (place != null)
                              TextSpan(
                                text: '${l10n.titleSeparator}$place',
                                style: context.typography.body.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Text(
                      inventoryQuantity(
                        l10n,
                        AppFormat.of(context),
                        stock.quantity,
                        item.unit,
                      ),
                      style: context.typography.title.copyWith(color: tone),
                    ),
                  ],
                ),
                if (stockFill(stock) case final fill?) ...[
                  SizedBox(height: spacing.sm),
                  ExcludeSemantics(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.radii.pill),
                      child: LinearProgressIndicator(
                        value: fill,
                        minHeight: spacing.md,
                        color: tone,
                        backgroundColor: colors.divider,
                      ),
                    ),
                  ),
                ],
                if (below) ...[
                  SizedBox(height: spacing.sm),
                  InventoryBelowThreshold(stock),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
