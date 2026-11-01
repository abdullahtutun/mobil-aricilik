import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
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

/// Satırın alt yazısı: (açıklama varsa) kategori, lot, arılık, taşıma ve
/// fiş; boşsa null.
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
    if (transaction.receiptPath != null) l10n.financeReceiptAttached,
  ];
  return parts.isEmpty ? null : parts.join(l10n.titleSeparator);
}
