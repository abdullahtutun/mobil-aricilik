import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/share_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/inventory/domain/shopping_rules.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_providers.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_labels.dart';

/// Alışveriş listesi (docs/design "Malzeme ve stok" kartı): eşiğin altındaki
/// kalemler eşiğe tamamlanacak miktarla, açık planlı ilaçlama görevlerinin
/// ihtiyacı ilacın son düşüldüğü kaleme eklenerek; kalemi olmayan ilaç
/// kendi satırında. Her satırda neden listede olduğu yazar; kaleme
/// dokununca ayrıntısı açılır. "Paylaş" listeyi metin olarak paylaşır.
class ShoppingListScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shoppingTitle)),
      body: switch (ref.watch(shoppingListOfProvider(languageCode))) {
        AsyncData(value: []) => EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: l10n.shoppingEmptyTitle,
          message: l10n.shoppingEmptyMessage,
          centered: true,
        ),
        AsyncData(value: final lines) => BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              ListGroup(children: [for (final line in lines) _Line(line)]),
            ],
          ),
          action: BigButton(
            label: l10n.shoppingShare,
            icon: Icons.share_outlined,
            onPressed: () => ref
                .read(shareServiceProvider)
                .shareText(
                  shoppingListText(l10n, AppFormat.of(context), lines),
                  subject: l10n.shoppingTitle,
                ),
          ),
        ),
        AsyncError() => Center(child: Text(l10n.shoppingLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

/// Satır: ad, sağda alınacak miktar; altında nedeni (stok ve eşik, planlı
/// ilaçlama ya da kalemsiz ilaç).
class _Line extends StatelessWidget {
  const new(this.line);

  final ShoppingLine line;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final stock = line.stock;
    final threshold = stock?.item.threshold;
    final reasons = [
      if (stock != null && threshold != null)
        l10n.shoppingReasonThreshold(
          inventoryQuantity(l10n, format, stock.quantity, stock.item.unit),
          inventoryNumber(format, threshold),
        ),
      if (stock != null && line.planned > 0)
        l10n.shoppingReasonPlanned(
          shoppingQuantity(l10n, format, line, line.planned),
        ),
      if (stock == null) l10n.shoppingReasonNoItem,
    ];

    return ListRow(
      title: line.name,
      subtitle: reasons.join(l10n.titleSeparator),
      value: shoppingQuantity(l10n, format, line, line.quantity),
      onTap: stock == null
          ? null
          : () => context.go(AppRoutes.inventoryItem(stock.item.id)),
    );
  }
}
