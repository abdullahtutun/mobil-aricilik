import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/transaction_form_controller.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';
import 'package:mobil_arici/features/harvest/domain/harvest_rules.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_widgets.dart';

/// Gelir ya da gider ekleme: tutar (işletmenin para birimi), kategori,
/// tarih, açıklama; bağlı arılık, lot ve (giderde) taşıma; lotlu gelirde
/// satılan bal (lotun stoğundan düşer); gelirde müşteri ve peşin alınan
/// (kalanı alacak); fiş fotoğrafı. Kaydedince 6 sn geri alınabilir. Gelir
/// müşteri ekranından açılırsa müşteri [customerId] seçili gelir.
class TransactionFormScreen extends ConsumerWidget {
  const new({required this.kind, super.key, this.customerId});

  final TransactionKind kind;
  final String? customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(switch (kind) {
          TransactionKind.income => l10n.financeFormIncomeTitle,
          TransactionKind.expense => l10n.financeFormExpenseTitle,
        }),
      ),
      body: _TransactionFormBody(kind, customerId),
    );
  }
}

class _TransactionFormBody extends ConsumerStatefulWidget {
  const new(this.kind, this.customerId);

  final TransactionKind kind;
  final String? customerId;

  @override
  ConsumerState<_TransactionFormBody> createState() =>
      _TransactionFormBodyState();
}

class _TransactionFormBodyState extends ConsumerState<_TransactionFormBody> {
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _sale = TextEditingController();
  final _paidNow = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    _sale.dispose();
    _paidNow.dispose();
    super.dispose();
  }

  TransactionFormControllerProvider get _provider =>
      transactionFormControllerProvider(
        widget.kind,
        customerId: widget.customerId,
      );

  TransactionFormController get _controller => ref.read(_provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final form = ref.watch(_provider);
    final currency = ref.watch(financeCurrencyProvider);
    final lots = ref.watch(lotSummariesProvider).value ?? const [];
    final lot = lots.where((s) => s.lot.id == form.lotId).firstOrNull;
    final apiaries = ref.watch(apiaryListProvider).value ?? const [];
    final apiaryName = apiaries
        .where((s) => s.apiary.id == form.apiaryId)
        .firstOrNull
        ?.apiary
        .name;
    final transports = ref.watch(transportChoicesProvider).value ?? const [];
    final transport = transports
        .where((t) => t.id == form.transportId)
        .firstOrNull;
    final customers = ref.watch(customerListProvider).value ?? const [];
    final customer = customers
        .where((c) => c.id == form.customerId)
        .firstOrNull;
    final inputStyle = context.typography.subtitle.copyWith(
      fontWeight: context.typography.body.fontWeight,
    );

    final amountText = _amount.text.trim();
    final saleText = _sale.text.trim();
    final stock = lot == null ? null : lotStock(lot);
    final saleKg = form.saleKg;
    final saleProblem = !form.canSell || saleText.isEmpty
        ? null
        : saleKg == null
        ? l10n.harvestWeightInvalid
        : stock != null && saleKg > stock
        ? l10n.lotSaleTooMuch(lotWeight(ref, context, stock))
        : null;
    final paidText = _paidNow.text.trim();
    final paidNow = form.paidNow;
    final amount = form.amount;
    final paidProblem = !form.canTakePayment || paidText.isEmpty
        ? null
        : paidNow == null
        ? l10n.financeFormAmountInvalid
        : amount != null && (paidNow * 100).round() > (amount * 100).round()
        ? l10n.financeFormPaidTooMuch
        : null;
    final canSave =
        form.canSave &&
        currency != null &&
        saleProblem == null &&
        paidProblem == null;

    return BottomActionLayout(
      separated: true,
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          LabeledField(
            label: l10n.financeFormAmount(
              currency == null ? '' : format.currencySymbol(currency),
            ),
            child: TextField(
              controller: _amount,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9., ]')),
              ],
              textInputAction: TextInputAction.next,
              style: context.typography.number,
              onChanged: (text) {
                _controller.setAmount(parseAmount(text));
                setState(() {});
              },
            ),
          ),
          if (amountText.isNotEmpty && form.amount == null) ...[
            SizedBox(height: spacing.sm),
            StatusMessage(
              status: AppStatus.warning,
              message: l10n.financeFormAmountInvalid,
            ),
          ],
          SizedBox(height: spacing.xl),
          LabeledField(
            label: l10n.financeFormCategory,
            child: ChoiceChipGroup<TransactionCategory>(
              options: [
                for (final category in widget.kind.categories)
                  ChoiceChipOption(
                    value: category,
                    label: category.label(l10n),
                  ),
              ],
              selected: {?form.category},
              onChanged: (selected) {
                // Seçili kategoriye yeniden dokunmak seçimi kaldırmaz.
                if (selected.firstOrNull case final category?) {
                  _controller.setCategory(category);
                }
              },
            ),
          ),
          SizedBox(height: spacing.xl),
          LabeledField(
            label: l10n.financeFormDescription,
            child: TextField(
              controller: _description,
              maxLength: maxTransactionDescriptionLength,
              textCapitalization: TextCapitalization.sentences,
              style: inputStyle,
              decoration: InputDecoration(
                hintText: l10n.financeFormDescriptionHint,
                counterText: '',
              ),
              onChanged: _controller.setDescription,
            ),
          ),
          SizedBox(height: spacing.xl),
          ListGroup(
            children: [
              ListRow(
                title: l10n.financeFormDate,
                value: format.date(form.occurredOn),
                onTap: () => unawaited(_pickDate(context)),
              ),
            ],
          ),
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.financeFormLinks),
          SizedBox(height: spacing.sm),
          ListGroup(
            children: [
              ListRow(
                title: l10n.financeFormApiary,
                value: apiaryName ?? l10n.financeFormNone,
                onTap: () => unawaited(
                  _pick(
                    context,
                    title: l10n.financeFormChooseApiary,
                    selected: form.apiaryId,
                    icon: Icons.place_outlined,
                    options: [
                      for (final s in apiaries)
                        (id: s.apiary.id, label: s.apiary.name, hint: null),
                    ],
                    onPicked: _controller.setApiary,
                  ),
                ),
              ),
              ListRow(
                title: l10n.financeFormLot,
                value: lot?.lot.number(l10n) ?? l10n.financeFormNone,
                onTap: () => unawaited(
                  _pick(
                    context,
                    title: l10n.financeFormChooseLot,
                    emptyMessage: l10n.financeFormNoLots,
                    selected: form.lotId,
                    icon: Icons.inventory_outlined,
                    options: [
                      for (final s in lots)
                        (
                          id: s.lot.id,
                          label: s.lot.subtitle(l10n),
                          hint: l10n.lotStockValue(
                            lotWeight(ref, context, lotStock(s)),
                          ),
                        ),
                    ],
                    onPicked: (id) {
                      _sale.clear();
                      _controller.setLot(id);
                    },
                  ),
                ),
              ),
              if (widget.kind == TransactionKind.income)
                ListRow(
                  title: l10n.financeFormCustomer,
                  value: customer?.name ?? l10n.financeFormNone,
                  onTap: () => unawaited(
                    _pick(
                      context,
                      title: l10n.financeFormChooseCustomer,
                      emptyMessage: l10n.financeFormNoCustomers,
                      selected: form.customerId,
                      icon: Icons.person_outline_rounded,
                      options: [
                        for (final c in customers)
                          (id: c.id, label: c.name, hint: c.phone),
                      ],
                      onPicked: (id) {
                        _paidNow.clear();
                        _controller.setCustomer(id);
                      },
                    ),
                  ),
                ),
              if (widget.kind == TransactionKind.expense)
                ListRow(
                  title: l10n.financeFormTransport,
                  value: transport == null
                      ? l10n.financeFormNone
                      : l10n.financeTransportRoute(
                          transport.from ?? '–',
                          transport.to ?? '–',
                        ),
                  onTap: () => unawaited(
                    _pick(
                      context,
                      title: l10n.financeFormChooseTransport,
                      emptyMessage: l10n.financeFormNoTransports,
                      selected: form.transportId,
                      icon: Icons.local_shipping_outlined,
                      options: [
                        for (final t in transports)
                          (
                            id: t.id,
                            label: l10n.financeTransportRoute(
                              t.from ?? '–',
                              t.to ?? '–',
                            ),
                            hint: format.date(t.createdAt.toLocal()),
                          ),
                      ],
                      onPicked: _controller.setTransport,
                    ),
                  ),
                ),
            ],
          ),
          if (form.canSell) ...[
            SizedBox(height: spacing.xl),
            _saleField(l10n, saleProblem),
          ],
          if (form.canTakePayment) ...[
            SizedBox(height: spacing.xl),
            _paidNowField(l10n, paidProblem),
          ],
          SizedBox(height: spacing.xl),
          _receiptField(l10n, form),
        ],
      ),
      action: BigButton(
        label: l10n.financeFormSave,
        onPressed: canSave ? () => unawaited(_save(context)) : null,
      ),
    );
  }

  /// Lotlu gelirde satılan bal, kullanıcının kütle biriminde.
  Widget _saleField(AppLocalizations l10n, String? problem) {
    final mass = ref.watch(regionConfigProvider).defaultUnits.mass;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.financeFormSaleAmount(mass.label(l10n)),
          helper: l10n.financeFormSaleHelper,
          child: TextField(
            controller: _sale,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            style: context.typography.number,
            onChanged: (text) {
              final value = parseHarvestWeight(text.trim());
              _controller.setSaleKg(
                value == null ? null : storedHarvestKg(value, mass),
              );
              setState(() {});
            },
          ),
        ),
        if (problem != null) ...[
          SizedBox(height: context.spacing.sm),
          StatusMessage(status: AppStatus.warning, message: problem),
        ],
      ],
    );
  }

  /// Müşterili gelirde satışta alınan ödeme; boşsa tamamı alacak.
  Widget _paidNowField(AppLocalizations l10n, String? problem) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      LabeledField(
        label: l10n.financeFormPaidNow,
        helper: l10n.financeFormPaidNowHelper,
        child: TextField(
          controller: _paidNow,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9., ]')),
          ],
          style: context.typography.number,
          onChanged: (text) {
            _controller.setPaidNow(parseAmount(text));
            setState(() {});
          },
        ),
      ),
      if (problem != null) ...[
        SizedBox(height: context.spacing.sm),
        StatusMessage(status: AppStatus.warning, message: problem),
      ],
    ],
  );

  Widget _receiptField(AppLocalizations l10n, TransactionFormState form) {
    final spacing = context.spacing;
    return LabeledField(
      label: l10n.financeFormReceipt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.md,
        children: [
          if (form.receipt != null)
            StatusMessage(
              status: AppStatus.good,
              message: l10n.financeFormReceiptAdded,
            )
          else
            Text(
              l10n.financeFormNoReceipt,
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          Wrap(
            spacing: spacing.md,
            runSpacing: spacing.md,
            children: [
              BigButton(
                label: l10n.financeFormTakePhoto,
                icon: Icons.photo_camera_outlined,
                variant: BigButtonVariant.secondary,
                expanded: false,
                onPressed: () =>
                    unawaited(_capture(context, _controller.takePhoto)),
              ),
              BigButton(
                label: l10n.financeFormPickImage,
                icon: Icons.photo_library_outlined,
                variant: BigButtonVariant.secondary,
                expanded: false,
                onPressed: () =>
                    unawaited(_capture(context, _controller.pickImage)),
              ),
              if (form.receipt != null)
                BigButton(
                  label: l10n.financeFormRemoveReceipt,
                  icon: Icons.delete_outline_rounded,
                  variant: BigButtonVariant.secondary,
                  expanded: false,
                  onPressed: () => unawaited(_controller.removeReceipt()),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = await showDatePicker(
      context: context,
      initialDate: ref.read(_provider).occurredOn,
      firstDate: DateTime(today.year - 5),
      lastDate: today,
    );
    if (day != null) _controller.setOccurredOn(day);
  }

  /// Seçim sayfası: "Yok" ve [options]; seçilen kimlik [onPicked]'e,
  /// "Yok" null olarak gider. Kapatılırsa bir şey değişmez. Seçenek yoksa
  /// "Yok"un altında [emptyMessage] yazar.
  Future<void> _pick(
    BuildContext context, {
    required String title,
    required String? selected,
    required IconData icon,
    required List<({String id, String label, String? hint})> options,
    required void Function(String? id) onPicked,
    String? emptyMessage,
  }) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showOptionSheet<String>(
      context,
      (context) => OptionSheet<String>(
        title: title,
        options: [
          SheetOption(
            value: '',
            icon: Icons.block_rounded,
            label: l10n.financeFormNone,
            // Seçilecek kayıt yoksa nedeni "Yok"un altında.
            hint: options.isEmpty ? emptyMessage : null,
            selected: selected == null,
          ),
          for (final option in options)
            SheetOption(
              value: option.id,
              icon: icon,
              label: option.label,
              hint: option.hint,
              selected: selected == option.id,
            ),
        ],
      ),
    );
    if (picked != null) onPicked(picked.isEmpty ? null : picked);
  }

  Future<void> _capture(
    BuildContext context,
    Future<void> Function() capture,
  ) async {
    final l10n = AppLocalizations.of(context);
    final String problem;
    try {
      await capture();
      return;
    } on MediaCaptureException catch (error) {
      problem = switch (error.failure) {
        MediaCaptureFailure.permissionDenied => l10n.financeFormPhotoDenied,
        MediaCaptureFailure.failed => l10n.financeFormPhotoFailed,
      };
    } on Exception {
      problem = l10n.financeFormPhotoFailed;
    }
    if (context.mounted) showMessageSnackBar(context, problem);
  }

  Future<void> _save(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(financeActionsProvider.notifier);
    final saved = await _controller.save();
    if (saved == null || !context.mounted) return;
    showUndoSnackBar(
      context,
      message: switch (saved.kind) {
        TransactionKind.income => l10n.financeIncomeSaved,
        TransactionKind.expense => l10n.financeExpenseSaved,
      },
      onUndo: () => unawaited(actions.remove(saved)),
    );
    context.pop();
  }
}
