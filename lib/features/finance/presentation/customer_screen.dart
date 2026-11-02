import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/country_calling_codes.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/url_launcher_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/customer_rules.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

/// Müşterinin ayrıntısı: telefon, kargo adresi, not; alacak; siparişler
/// (müşteriye bağlı satışlar, yeni önce) ödendi ya da kalan rozetiyle.
/// Siparişe dokununca: "Ödendi olarak işaretle", "Tahsilat ekle",
/// "WhatsApp ile gönder" (hazır sipariş özeti) ve "Hareketi aç". Altta
/// "Satış ekle" müşterili gelir formunu açar. Açılan sayfalar kapanınca
/// müşteriye dönülür.
class CustomerScreen extends ConsumerWidget {
  const new({required this.customerId, super.key});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(customerProvider(customerId))) {
      AsyncData(value: final customer?) => Scaffold(
        appBar: AppBar(
          title: Text(customer.name),
          actions: [
            IconButton(
              tooltip: l10n.customerEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.go(AppRoutes.customerEdit(customer.id)),
            ),
          ],
        ),
        body: BottomActionLayout(
          separated: true,
          body: _CustomerDetail(customer),
          action: BigButton(
            label: l10n.customerAddSale,
            icon: Icons.add_rounded,
            onPressed: () => context.push(AppRoutes.financeSale(customer.id)),
          ),
        ),
      ),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.customerNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

class _CustomerDetail extends ConsumerWidget {
  const new(this.customer);

  final Customer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final currency = ref.watch(financeCurrencyProvider);
    final sales = ref.watch(customerSalesProvider(customer.id)).value;
    final receivable = sales == null
        ? null
        : receivablesSummary([
            for (final row in sales)
              if (row.transaction.currency == currency)
                (customerId: customer.id, balance: rowBalance(row)),
          ]).total;

    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        if (customer.phone != null ||
            customer.address != null ||
            customer.notes != null) ...[
          ListGroup(
            children: [
              if (customer.phone case final phone?)
                ListRow(title: l10n.customerFormPhone, value: phone),
              if (customer.address case final address?)
                ListRow(title: l10n.customerFormAddress, subtitle: address),
              if (customer.notes case final notes?)
                ListRow(title: l10n.customerFormNotes, subtitle: notes),
            ],
          ),
          SizedBox(height: spacing.xl),
        ],
        if (receivable != null && currency != null && sales!.isNotEmpty) ...[
          StatusMessage(
            status: receivable > 0 ? AppStatus.warning : AppStatus.good,
            message: receivable > 0
                ? l10n.customerReceivableValue(
                    financeMoney(context, receivable, currency),
                  )
                : l10n.customerNoReceivable,
          ),
          SizedBox(height: spacing.xl),
        ],
        SectionLabel(l10n.customerOrders),
        SizedBox(height: spacing.sm),
        if (sales != null && sales.isEmpty)
          Text(
            l10n.customerNoOrders,
            style: context.typography.body.copyWith(
              color: context.colors.textSecondary,
            ),
          )
        else if (sales != null)
          ListGroup(
            children: [
              for (final row in sales)
                _SaleRow(
                  row,
                  onTap: () => unawaited(_openOrder(context, ref, row)),
                ),
            ],
          ),
      ],
    );
  }

  Future<void> _openOrder(
    BuildContext context,
    WidgetRef ref,
    TransactionRow row,
  ) async {
    final l10n = AppLocalizations.of(context);
    final balance = rowBalance(row);
    final money = financeMoney(
      context,
      balance.remaining,
      row.transaction.currency,
    );
    final action = await showOptionSheet<_OrderAction>(
      context,
      (context) => OptionSheet<_OrderAction>(
        title: financeRowTitle(l10n, row.transaction),
        options: [
          if (!isPaid(balance)) ...[
            SheetOption(
              value: _OrderAction.markPaid,
              icon: Icons.check_circle_outline_rounded,
              label: l10n.customerMarkPaid,
              hint: l10n.customerRemaining(money),
            ),
            SheetOption(
              value: _OrderAction.addPayment,
              icon: Icons.payments_outlined,
              label: l10n.customerAddPayment,
            ),
          ],
          SheetOption(
            value: _OrderAction.whatsApp,
            icon: Icons.send_outlined,
            label: l10n.customerSendWhatsApp,
            hint: customer.phone ?? l10n.customerWhatsAppNoPhone,
          ),
          SheetOption(
            value: _OrderAction.open,
            icon: Icons.receipt_long_outlined,
            label: l10n.customerOpenTransaction,
          ),
        ],
      ),
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case _OrderAction.markPaid:
        final actions = ref.read(financeActionsProvider.notifier);
        final payment = await actions.payRemaining(row.transaction);
        if (payment == null || !context.mounted) return;
        showUndoSnackBar(
          context,
          message: l10n.customerMarkedPaid,
          onUndo: () => unawaited(actions.removePayment(payment)),
        );
      case _OrderAction.addPayment:
        unawaited(context.push(AppRoutes.financePayment(row.transaction.id)));
      case _OrderAction.whatsApp:
        await _sendWhatsApp(context, ref, row);
      case _OrderAction.open:
        unawaited(
          context.push(AppRoutes.financeTransaction(row.transaction.id)),
        );
    }
  }

  Future<void> _sendWhatsApp(
    BuildContext context,
    WidgetRef ref,
    TransactionRow row,
  ) async {
    final l10n = AppLocalizations.of(context);
    final text = orderSummaryMessage(
      ref,
      context,
      customer: customer,
      row: row,
      organizationName: ref.read(currentOrganizationProvider).value?.name,
    );
    final phone = whatsAppPhone(
      customer.phone,
      callingCode:
          countryCallingCodes[ref.read(regionConfigProvider).countryCode],
    );
    final opened = await ref
        .read(urlLauncherServiceProvider)
        .open(whatsAppUri(text, phone: phone));
    if (!opened && context.mounted) {
      showMessageSnackBar(context, l10n.customerWhatsAppFailed);
    }
  }
}

enum _OrderAction { markPaid, addPayment, whatsApp, open }

/// Sipariş satırı: başlık, gün ve tutar; altında ödendi ya da kalan
/// rozeti (renk + ikon + kelime).
class _SaleRow extends StatelessWidget {
  const new(this.row, {required this.onTap});

  final TransactionRow row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final transaction = row.transaction;
    final details = [
      AppFormat.of(context).date(transaction.occurredOn),
      financeMoney(context, transaction.amount, transaction.currency),
    ].join(l10n.titleSeparator);

    return MergeSemantics(
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: spacing.xs,
                    children: [
                      Text(
                        financeRowTitle(l10n, transaction),
                        style: context.typography.body,
                      ),
                      Text(
                        details,
                        style: context.typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      SaleStatusBadge(row),
                    ],
                  ),
                ),
                SizedBox(width: spacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  size: context.sizes.icon,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
