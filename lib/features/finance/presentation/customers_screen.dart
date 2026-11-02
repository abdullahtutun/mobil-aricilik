import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';

/// Müşteri defteri: müşteriler ada göre, alacağı olanın yanında kalan
/// tutar; sağ üstte "Müşteri ekle". Müşteriye dokununca siparişleri ve
/// alacağı açılır.
class CustomersScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final currency = ref.watch(financeCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customersTitle),
        actions: [
          AppBarAddButton(
            label: l10n.customersAdd,
            onPressed: () => context.go(AppRoutes.customerNew),
          ),
        ],
      ),
      body: switch (ref.watch(customerSummariesProvider)) {
        AsyncData(value: final summaries) when summaries.isEmpty => EmptyState(
          icon: Icons.people_outline_rounded,
          title: l10n.customersEmptyTitle,
          message: l10n.customersEmptyMessage,
        ),
        AsyncData(value: final summaries) => ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [
            ListGroup(
              children: [
                for (final summary in summaries)
                  ListRow(
                    title: summary.customer.name,
                    subtitle: summary.customer.phone,
                    value: summary.receivable > 0 && currency != null
                        ? l10n.customerReceivableValue(
                            financeMoney(context, summary.receivable, currency),
                          )
                        : null,
                    valueColor: colors.statusWarning,
                    onTap: () =>
                        context.go(AppRoutes.customer(summary.customer.id)),
                  ),
              ],
            ),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.financeLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}
