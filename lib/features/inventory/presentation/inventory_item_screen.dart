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
import 'package:mobil_arici/features/inventory/presentation/inventory_providers.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_labels.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_move_sheet.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Stok kalemi: stok, konum, eşik ve hareket geçmişi (yeni önce). Altta
/// "Giriş / çıkış" hızlı hareket sayfasını açar; üstte düzenleme. Viewer
/// yalnız okur.
class InventoryItemScreen extends ConsumerWidget {
  const new({required this.itemId, super.key});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);

    return switch (ref.watch(inventoryStockProvider(itemId))) {
      AsyncData(value: final stock?) => Scaffold(
        appBar: AppBar(
          title: Text(stock.item.name),
          actions: [
            if (canWrite)
              IconButton(
                tooltip: l10n.inventoryEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    context.go(AppRoutes.inventoryItemEdit(stock.item.id)),
              ),
          ],
        ),
        body: canWrite
            ? BottomActionLayout(
                separated: true,
                body: _Body(stock),
                action: BigButton(
                  label: l10n.inventoryQuickMove,
                  icon: Icons.swap_vert_rounded,
                  onPressed: () =>
                      unawaited(showInventoryMoveSheet(context, ref, stock)),
                ),
              )
            : _Body(stock),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.inventoryNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.inventoryLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

class _Body extends StatelessWidget {
  const new(this.stock);

  final InventoryStock stock;

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(context.spacing.lg),
    children: [
      _StockCard(stock),
      SizedBox(height: context.spacing.xl),
      SectionLabel(AppLocalizations.of(context).inventoryHistory),
      SizedBox(height: context.spacing.sm),
      _History(stock.item),
    ],
  );
}

/// Büyük stok, kategori · konum, eşik ve eşiğin altındaysa uyarı.
class _StockCard extends StatelessWidget {
  const new(this.stock);

  final InventoryStock stock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final item = stock.item;
    final below = isBelowThreshold(stock);
    final threshold = item.threshold;

    return MergeSemantics(
      child: AppCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inventoryQuantity(l10n, format, stock.quantity, item.unit),
                style: context.typography.number.copyWith(
                  color: below ? colors.statusWarning : colors.statusGood,
                ),
              ),
              Text(
                [
                  item.category.label(l10n),
                  ?item.place,
                ].join(l10n.titleSeparator),
                style: context.typography.body.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(height: spacing.sm),
              Text(
                threshold == null
                    ? l10n.inventoryNoThreshold
                    : l10n.inventoryThreshold(
                        inventoryQuantity(l10n, format, threshold, item.unit),
                      ),
                style: context.typography.body,
              ),
              if (below) ...[
                SizedBox(height: spacing.sm),
                InventoryBelowThreshold(stock),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Hareketler: tür, tarih ve işaretli miktar ("+12 kg", "−5 kg").
class _History extends ConsumerWidget {
  const new(this.item);

  final InventoryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final moves = ref.watch(inventoryMovesProvider(item.id)).value;
    if (moves == null) return const SizedBox.shrink();
    if (moves.isEmpty) {
      return Text(
        l10n.inventoryHistoryEmpty,
        style: context.typography.body.copyWith(
          color: context.colors.textSecondary,
        ),
      );
    }
    return ListGroup(
      children: [
        for (final move in moves)
          ListRow(
            title: move.kind.label(l10n),
            subtitle: format.dateTime(move.movedAt.toLocal()),
            value: inventorySignedQuantity(
              l10n,
              format,
              move.quantity,
              item.unit,
            ),
          ),
      ],
    );
  }
}
