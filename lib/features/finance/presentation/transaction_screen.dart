import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';

/// Hareketin ayrıntısı: yönüyle tutar, kategori, tarih, bağlı kayıtlar,
/// müşterili satışta müşteri, ödenen ve ödeme durumu, fiş fotoğrafı;
/// altta "Hareketi sil" (onaylı). Olay kaydı olduğu için düzenleme yok:
/// yanlış kayıt silinip yeniden girilir.
class TransactionScreen extends ConsumerWidget {
  const new({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(transactionRowProvider(transactionId))) {
      AsyncData(value: final row?) => Scaffold(
        appBar: AppBar(title: Text(financeRowTitle(l10n, row.transaction))),
        body: _TransactionDetail(row),
      ),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.financeNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

class _TransactionDetail extends ConsumerWidget {
  const new(this.row);

  final TransactionRow row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final transaction = row.transaction;
    final lot = financeLotLabel(ref, context, row);
    final transport = financeTransportLabel(l10n, row);
    final receiptPath = transaction.receiptPath;

    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        Text(
          financeSignedMoney(context, transaction),
          style: context.typography.numberLarge.copyWith(
            color: transaction.kind == TransactionKind.income
                ? colors.statusGood
                : colors.textPrimary,
          ),
        ),
        SizedBox(height: spacing.lg),
        ListGroup(
          children: [
            ListRow(
              title: l10n.financeFormCategory,
              value: transaction.category.label(l10n),
            ),
            ListRow(
              title: l10n.financeFormDate,
              value: format.date(transaction.occurredOn),
            ),
            if (row.apiaryName case final name?)
              ListRow(title: l10n.financeFormApiary, value: name),
            if (lot != null) ListRow(title: l10n.financeFormLot, value: lot),
            if (transport != null)
              ListRow(title: l10n.financeFormTransport, value: transport),
            if ((transaction.customerId, row.customerName) case (
              final id?,
              final name?,
            ))
              ListRow(
                title: l10n.financeFormCustomer,
                value: name,
                onTap: () => context.go(AppRoutes.customer(id)),
              ),
            if (transaction.customerId != null)
              ListRow(
                title: l10n.customerPaidAmount,
                value: financeMoney(context, row.paid, transaction.currency),
              ),
          ],
        ),
        if (transaction.customerId != null) ...[
          SizedBox(height: spacing.md),
          SaleStatusBadge(row),
        ],
        if (receiptPath != null) ...[
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.financeFormReceipt),
          SizedBox(height: spacing.sm),
          _Receipt(receiptPath),
        ],
        SizedBox(height: spacing.xl),
        BigButton(
          label: l10n.financeDelete,
          icon: Icons.delete_outline_rounded,
          variant: BigButtonVariant.secondary,
          onPressed: () => unawaited(_delete(context, ref)),
        ),
      ],
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.financeDeleteTitle,
      message: l10n.financeDeleteMessage,
      confirmLabel: l10n.financeDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(financeActionsProvider.notifier).remove(row.transaction);
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.financeDeleted);
    context.go(AppRoutes.finance);
  }
}

/// Fiş fotoğrafı; bu telefona henüz inmediyse nedeni.
class _Receipt extends ConsumerWidget {
  const new(this.storagePath);

  final String storagePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(receiptFileProvider(storagePath)).value;
    if (file == null) {
      return Text(
        AppLocalizations.of(context).financeReceiptPending,
        style: context.typography.body.copyWith(
          color: context.colors.textSecondary,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.radii.card),
      child: Image.file(file, fit: BoxFit.contain),
    );
  }
}
