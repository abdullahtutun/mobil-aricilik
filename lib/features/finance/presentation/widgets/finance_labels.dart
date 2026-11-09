import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/domain/customer_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_widgets.dart';

extension TransactionCategoryLabel on TransactionCategory {
  String label(AppLocalizations l10n) => switch (this) {
    TransactionCategory.feeding => l10n.financeCategoryFeeding,
    TransactionCategory.treatment => l10n.financeCategoryTreatment,
    TransactionCategory.equipment => l10n.financeCategoryEquipment,
    TransactionCategory.fuelTransport => l10n.financeCategoryFuelTransport,
    TransactionCategory.landRent => l10n.financeCategoryLandRent,
    TransactionCategory.labor => l10n.financeCategoryLabor,
    TransactionCategory.labAnalysis => l10n.financeCategoryLabAnalysis,
    TransactionCategory.honey => l10n.financeCategoryHoney,
    TransactionCategory.pollen => l10n.financeCategoryPollen,
    TransactionCategory.propolis => l10n.financeCategoryPropolis,
    TransactionCategory.wax => l10n.financeCategoryWax,
    TransactionCategory.nucs => l10n.financeCategoryNucs,
    TransactionCategory.queens => l10n.financeCategoryQueens,
    TransactionCategory.other => l10n.financeCategoryOther,
  };
}

/// Tutar; küsuratı yoksa kuruşsuz (`₺318.400`, `₺17,50`).
String financeMoney(BuildContext context, double amount, String currency) =>
    AppFormat.of(context).currency(
      amount,
      currencyCode: currency,
      decimalDigits: amount == amount.roundToDouble() ? 0 : null,
    );

/// Özet kartı ve kâr satırı gibi dar yerlerde tutar: 10 milyondan büyükse
/// kısaltılır (`₺1,22 Mr`), küçükse [financeMoney] gibi.
String financeCompactMoney(
  BuildContext context,
  double amount,
  String currency,
) => AppFormat.of(context).compactCurrency(
  amount,
  currencyCode: currency,
  decimalDigits: amount == amount.roundToDouble() ? 0 : null,
);

/// Yönüyle tutar: gelir `+₺56.000`, gider `−₺17.500`.
String financeSignedMoney(
  BuildContext context,
  FinanceTransaction transaction,
) {
  final l10n = AppLocalizations.of(context);
  final money = financeMoney(context, transaction.amount, transaction.currency);
  return switch (transaction.kind) {
    TransactionKind.income => l10n.financePlus(money),
    TransactionKind.expense => l10n.financeMinus(money),
  };
}

/// Lotu "Lot 2026-07", satıştaysa "Lot 2026-07 · 160 kg"; lot silinmişse
/// null.
String? financeLotLabel(
  WidgetRef ref,
  BuildContext context,
  TransactionRow row,
) {
  final l10n = AppLocalizations.of(context);
  final (year, seq) = (row.lotYear, row.lotSeq);
  if (year == null || seq == null) return null;
  return [
    l10n.lotNumber(formatLotNumber(year, seq)),
    if (row.saleKg case final kg?) lotWeight(ref, context, kg),
  ].join(l10n.titleSeparator);
}

/// "Kestane → Çam"; taşıma silinmişse ya da bağlı değilse null.
String? financeTransportLabel(AppLocalizations l10n, TransactionRow row) {
  if (row.transaction.transportId == null) return null;
  final (from, to) = (row.transportFrom, row.transportTo);
  if (from == null || to == null) return null;
  return l10n.financeTransportRoute(from, to);
}

/// Satırın başlığı: açıklama, yoksa kategori.
String financeRowTitle(AppLocalizations l10n, FinanceTransaction transaction) =>
    transaction.description ?? transaction.category.label(l10n);

/// Satırın alt yazısı: (açıklama varsa) kategori, lot, arılık, taşıma,
/// müşteri ve ödeme durumu ([financePaymentLabel]), fiş; boşsa null.
String? financeRowSubtitle(
  WidgetRef ref,
  BuildContext context,
  TransactionRow row,
) {
  final l10n = AppLocalizations.of(context);
  final transaction = row.transaction;
  final parts = [
    if (transaction.description != null) transaction.category.label(l10n),
    ?financeLotLabel(ref, context, row),
    ?row.apiaryName,
    ?financeTransportLabel(l10n, row),
    ?row.customerName,
    ?financePaymentLabel(context, row),
    if (transaction.receiptPath != null) l10n.financeReceiptAttached,
  ];
  return parts.isEmpty ? null : parts.join(l10n.titleSeparator);
}

/// Müşterili satışın ödeme durumu: "Ödendi", kısmi ödemede "₺2.000 ödendi,
/// ₺4.000 kalan", hiç ödenmediyse "Ödenmedi"; müşterisiz harekette null.
String? financePaymentLabel(BuildContext context, TransactionRow row) {
  if (row.transaction.customerId == null) return null;
  final l10n = AppLocalizations.of(context);
  final balance = rowBalance(row);
  if (isPaid(balance)) return l10n.customerPaid;
  if (balance.paid <= 0) return l10n.customerUnpaid;
  final currency = row.transaction.currency;
  return l10n.customerPartiallyPaid(
    financeMoney(context, balance.paid, currency),
    financeMoney(context, balance.remaining, currency),
  );
}

/// Satışın ödeme durumu: "Ödendi" ya da "Kalan ₺4.000" (renk + ikon +
/// kelime).
class SaleStatusBadge extends StatelessWidget {
  const new(this.row, {super.key});

  final TransactionRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final balance = rowBalance(row);
    return isPaid(balance)
        ? StatusBadge(status: AppStatus.good, label: l10n.customerPaid)
        : StatusBadge(
            status: AppStatus.warning,
            label: l10n.customerRemaining(
              financeMoney(
                context,
                balance.remaining,
                row.transaction.currency,
              ),
            ),
          );
  }
}

/// WhatsApp'a gidecek hazır sipariş özeti: selam, sipariş (başlık, gün,
/// lot), tutar, ödenen ve kalan ya da "ödendi", kargo adresi ve işletmenin
/// adı.
String orderSummaryMessage(
  WidgetRef ref,
  BuildContext context, {
  required Customer customer,
  required TransactionRow row,
  String? organizationName,
}) {
  final l10n = AppLocalizations.of(context);
  final transaction = row.transaction;
  final balance = rowBalance(row);
  String money(double amount) =>
      financeMoney(context, amount, transaction.currency);
  return [
    l10n.customerWhatsAppGreeting(customer.name),
    l10n.customerWhatsAppIntro,
    [
      financeRowTitle(l10n, transaction),
      AppFormat.of(context).date(transaction.occurredOn),
      ?financeLotLabel(ref, context, row),
    ].join(l10n.titleSeparator),
    l10n.customerWhatsAppAmount(money(balance.amount)),
    if (balance.paid > 0) l10n.customerWhatsAppPaid(money(balance.paid)),
    if (isPaid(balance))
      l10n.customerWhatsAppPaidInFull
    else
      l10n.customerWhatsAppRemaining(money(balance.remaining)),
    if (customer.address case final address?)
      l10n.customerWhatsAppAddress(address),
    ?organizationName,
  ].join('\n');
}
