import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/stock_usage_rules.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_providers.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_labels.dart';

/// Kaydın düşüleceği kalem: kullanıcının seçimi ([choice]), seçmediyse son
/// kullanılan ([defaultItemId]); birimi uymayan ya da silinmiş kalem yok
/// sayılır. Stoklar değişince yeniden hesaplanır.
InventoryStock? watchStockUse(
  WidgetRef ref, {
  required StockChoice choice,
  required String? defaultItemId,
  required StockUsage usage,
}) => resolveStockItem(
  choice: choice,
  defaultItemId: defaultItemId,
  stocks: ref.watch(inventoryStocksProvider).value ?? const [],
  usable: usage,
);

/// Kayıt formundaki "Stoktan düş" satırı: seçili kalem ve düşülecek
/// miktar ("Şeker · −45 kg") ya da "Düşme". Dokununca birimi uyan
/// kalemler ve "Düşme" listelenir. Uyan kalem yoksa görünmez. Üstündeki
/// boşluk kendisinde.
class StockUseField extends ConsumerWidget {
  const new({
    required this.selected,
    required this.usage,
    required this.onChanged,
    super.key,
  });

  final InventoryStock? selected;
  final StockUsage usage;

  /// Seçilen kalemin kimliği; "Düşme"de null.
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final stocks = usableStocks(
      ref.watch(inventoryStocksProvider).value ?? const [],
      usage,
    );
    if (stocks.isEmpty) return const SizedBox.shrink();
    final selected = this.selected;
    final amount = selected == null ? null : usage(selected.item.unit);

    return Padding(
      padding: EdgeInsets.only(top: context.spacing.lg),
      child: ListGroup(
        children: [
          ListRow(
            title: l10n.stockUseTitle,
            value: selected == null || amount == null
                ? l10n.stockUseNone
                : l10n.stockUseValue(
                    selected.item.name,
                    inventoryQuantity(l10n, format, amount, selected.item.unit),
                  ),
            onTap: () => _pick(context, stocks),
          ),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context, List<InventoryStock> stocks) async {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final picked = await showOptionSheet<String>(
      context,
      (context) => OptionSheet<String>(
        title: l10n.stockUseChoose,
        options: [
          SheetOption(
            value: '',
            icon: Icons.block_rounded,
            label: l10n.stockUseNone,
            selected: selected == null,
          ),
          for (final stock in stocks)
            SheetOption(
              value: stock.item.id,
              icon: Icons.inventory_2_outlined,
              label: stock.item.name,
              hint: l10n.inventoryInStock(
                inventoryQuantity(
                  l10n,
                  format,
                  stock.quantity,
                  stock.item.unit,
                ),
              ),
              selected: selected?.item.id == stock.item.id,
            ),
        ],
      ),
    );
    if (picked != null) onChanged(picked.isEmpty ? null : picked);
  }
}
