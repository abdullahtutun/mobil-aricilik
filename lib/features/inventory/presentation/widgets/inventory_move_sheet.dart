import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Sayfada yazılan hareket: `move` yazılan kayıt (sayımda fark yoksa
/// null), `quantity` girilen miktar ya da sayılan stok.
typedef _MoveResult = ({
  InventoryMoveKind kind,
  InventoryMove? move,
  double quantity,
});

/// Hızlı giriş, çıkış ya da sayım sayfasını [stock]'un kalemi için kök
/// navigator'da açar. Yazılınca sayfa kapanır ve [context]'te 6 sn geri
/// alınabilir bildirim çıkar. [showDetails] doğruysa sayfada kalemin
/// ayrıntılarına geçiş de var (listeden açılınca).
Future<void> showInventoryMoveSheet(
  BuildContext context,
  WidgetRef ref,
  InventoryStock stock, {
  bool showDetails = false,
}) async {
  final actions = ref.read(inventoryActionsProvider.notifier);
  final result = await showModalBottomSheet<_MoveResult>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        _MoveSheet(itemId: stock.item.id, showDetails: showDetails),
  );
  if (result == null || !context.mounted) return;

  final l10n = AppLocalizations.of(context);
  final quantity = inventoryQuantity(
    l10n,
    AppFormat.of(context),
    result.quantity,
    stock.item.unit,
  );
  final move = result.move;
  if (move == null) {
    showMessageSnackBar(context, l10n.inventoryUnchanged(quantity));
    return;
  }
  showUndoSnackBar(
    context,
    message: switch (result.kind) {
      InventoryMoveKind.stockIn => l10n.inventoryMovedIn(quantity),
      InventoryMoveKind.stockOut => l10n.inventoryMovedOut(quantity),
      InventoryMoveKind.adjustment => l10n.inventoryAdjusted(quantity),
    },
    onUndo: () => unawaited(actions.undoMove(move)),
  );
}

/// Kalemin adı ve stoğu, Giriş / Çıkış / Sayım sekmeleri, miktar alanı ve
/// kaydet. Stok sayfa açıkken de güncellenir (başka telefonun hareketi).
class _MoveSheet extends ConsumerStatefulWidget {
  const new({required this.itemId, required this.showDetails});

  final String itemId;
  final bool showDetails;

  @override
  ConsumerState<_MoveSheet> createState() => _MoveSheetState();
}

class _MoveSheetState extends ConsumerState<_MoveSheet> {
  final _amount = TextEditingController();
  InventoryMoveKind _kind = InventoryMoveKind.stockIn;
  var _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  bool get _counting => _kind == InventoryMoveKind.adjustment;

  double? _parsed(InventoryUnit unit) =>
      parseInventoryQuantity(_amount.text, unit, allowZero: _counting);

  Future<void> _save(InventoryItem item) async {
    final amount = _parsed(item.unit);
    if (amount == null) return;
    setState(() => _busy = true);
    final actions = ref.read(inventoryActionsProvider.notifier);
    try {
      final move = _counting
          ? await actions.count(item, amount)
          : await actions.move(item, _kind, amount);
      if (mounted) {
        Navigator.of(context)
            .pop<_MoveResult>((kind: _kind, move: move, quantity: amount));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final stock = ref.watch(inventoryStockProvider(widget.itemId)).value;
    if (stock == null) return const SizedBox.shrink();
    final item = stock.item;
    final format = AppFormat.of(context);
    final unit = item.unit.label(l10n);
    final text = _amount.text.trim();
    final amount = _parsed(item.unit);
    // Ondalıklı yazılan tam sayı birimi ayrı uyarılır.
    final wholeOnly =
        amount == null &&
        parseInventoryQuantity(text, InventoryUnit.kg, allowZero: _counting) !=
            null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        0,
        spacing.lg,
        spacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(item.name, style: context.typography.title),
            Text(
              l10n.inventoryInStock(
                inventoryQuantity(l10n, format, stock.quantity, item.unit),
              ),
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            if (isBelowThreshold(stock)) ...[
              SizedBox(height: spacing.sm),
              InventoryBelowThreshold(stock),
            ],
            SizedBox(height: spacing.lg),
            SegmentedTabs<InventoryMoveKind>(
              expanded: true,
              options: [
                SegmentOption(
                  value: InventoryMoveKind.stockIn,
                  label: l10n.inventoryMoveIn,
                ),
                SegmentOption(
                  value: InventoryMoveKind.stockOut,
                  label: l10n.inventoryMoveOut,
                ),
                SegmentOption(
                  value: InventoryMoveKind.adjustment,
                  label: l10n.inventoryMoveCount,
                ),
              ],
              selected: _kind,
              onChanged: (kind) => setState(() => _kind = kind),
            ),
            SizedBox(height: spacing.lg),
            LabeledField(
              label: _counting
                  ? l10n.inventoryCountedLabel(unit)
                  : l10n.inventoryAmountLabel(unit),
              child: TextField(
                controller: _amount,
                autofocus: true,
                enabled: !_busy,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: item.unit.allowsFraction,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ],
                textInputAction: TextInputAction.done,
                style: context.typography.number,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) {
                  if (amount != null && !_busy) unawaited(_save(item));
                },
              ),
            ),
            if (text.isNotEmpty && amount == null) ...[
              SizedBox(height: spacing.sm),
              StatusMessage(
                status: AppStatus.warning,
                message: wholeOnly
                    ? l10n.inventoryAmountWhole
                    : l10n.inventoryAmountInvalid,
              ),
            ],
            SizedBox(height: spacing.lg),
            BigButton(
              label: switch (_kind) {
                InventoryMoveKind.stockIn => l10n.inventorySaveIn,
                InventoryMoveKind.stockOut => l10n.inventorySaveOut,
                InventoryMoveKind.adjustment => l10n.inventorySaveCount,
              },
              onPressed: amount != null && !_busy
                  ? () => unawaited(_save(item))
                  : null,
            ),
            if (widget.showDetails) ...[
              SizedBox(height: spacing.md),
              BigButton(
                label: l10n.inventoryDetails,
                variant: BigButtonVariant.secondary,
                onPressed: () {
                  // Sayfa kök navigator'da; önce o kapanır.
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  router.go(AppRoutes.inventoryItem(item.id));
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Eşik altı uyarısı: uyarı ikonu ve "Eşiğin altında · en az 100", uyarı
/// renginde (renk tek başına anlam taşımaz).
class InventoryBelowThreshold extends StatelessWidget {
  const new(this.stock, {super.key});

  final InventoryStock stock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = AppStatus.warning.colorIn(context.colors);
    return Row(
      children: [
        Icon(
          AppStatus.warning.icon,
          size: context.sizes.iconSmall,
          color: color,
        ),
        SizedBox(width: context.spacing.xs),
        Expanded(
          child: Text(
            l10n.inventoryBelowThreshold(
              inventoryNumber(AppFormat.of(context), stock.item.threshold!),
            ),
            style: context.typography.label.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
