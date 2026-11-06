import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/digits.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';

/// Satışa tahsilat ekleme: tutar (kalanla dolu gelir, kalanı aşamaz) ve
/// gün. Kaydedince 6 sn geri alınabilir.
class PaymentFormScreen extends ConsumerWidget {
  const new({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(l10n.customerAddPayment);
    return switch (ref.watch(transactionRowProvider(transactionId))) {
      AsyncData(value: final row?) when row.transaction.customerId != null =>
        Scaffold(
          appBar: AppBar(leading: const CloseButton(), title: title),
          body: _PaymentForm(row),
        ),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.financeNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }
}

class _PaymentForm extends ConsumerStatefulWidget {
  const new(this.row);

  final TransactionRow row;

  @override
  ConsumerState<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends ConsumerState<_PaymentForm> {
  late final _amount = TextEditingController(
    text: _editable(rowBalance(widget.row).remaining),
  );
  late DateTime _paidOn = dateOnly(clock.now());
  var _saving = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final transaction = widget.row.transaction;
    final remaining = rowBalance(widget.row).remaining;
    final amount = parseAmount(_amount.text);
    final tooMuch =
        amount != null && (amount * 100).round() > (remaining * 100).round();
    final problem = _amount.text.trim().isEmpty
        ? null
        : amount == null
        ? l10n.financeFormAmountInvalid
        : tooMuch
        ? l10n.customerPaymentTooMuch(
            financeMoney(context, remaining, transaction.currency),
          )
        : null;

    return BottomActionLayout(
      separated: true,
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          ListGroup(
            children: [
              ListRow(
                title: financeRowTitle(l10n, transaction),
                subtitle: widget.row.customerName,
                value: financeMoney(
                  context,
                  transaction.amount,
                  transaction.currency,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          SaleStatusBadge(widget.row),
          SizedBox(height: spacing.xl),
          LabeledField(
            label: l10n.financeFormAmount(
              format.currencySymbol(transaction.currency),
            ),
            child: TextField(
              controller: _amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                const AsciiDigitsFormatter(),
                FilteringTextInputFormatter.allow(RegExp('[0-9., ]')),
              ],
              style: context.typography.number,
              onChanged: (_) => setState(() {}),
            ),
          ),
          if (problem != null) ...[
            SizedBox(height: spacing.sm),
            StatusMessage(status: AppStatus.warning, message: problem),
          ],
          SizedBox(height: spacing.xl),
          ListGroup(
            children: [
              ListRow(
                title: l10n.financeFormDate,
                value: format.date(_paidOn),
                onTap: () => unawaited(_pickDate(context)),
              ),
            ],
          ),
        ],
      ),
      action: BigButton(
        label: l10n.customerPaymentSave,
        onPressed: amount != null && problem == null && !_saving
            ? () => unawaited(_save(context, amount))
            : null,
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = clock.now();
    final day = await showDatePicker(
      context: context,
      initialDate: _paidOn,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year, now.month, now.day),
    );
    if (day != null) setState(() => _paidOn = dateOnly(day));
  }

  Future<void> _save(BuildContext context, double amount) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(financeActionsProvider.notifier);
    setState(() => _saving = true);
    try {
      final payment = await actions.addPayment(
        widget.row.transaction,
        amount,
        paidOn: _paidOn,
      );
      if (!context.mounted) return;
      showUndoSnackBar(
        context,
        message: l10n.customerPaymentSaved,
        onUndo: () => unawaited(actions.removePayment(payment)),
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Alana yazılacak tutar: küsuratsızsa tam sayı, değilse virgüllü iki
  /// hane ([parseAmount] ikisini de okur).
  static String _editable(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(2).replaceAll('.', ',');
}
