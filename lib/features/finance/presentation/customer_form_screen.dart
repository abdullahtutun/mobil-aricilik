import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/finance/domain/customer.dart';
import 'package:mobil_arici/features/finance/presentation/customer_form_controller.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';

/// Müşteri ekleme ([customerId] null) ve düzenleme: ad, telefon (WhatsApp
/// için), kargo adresi ve not; düzenlemede "Müşteriyi sil" (onaylı,
/// satışları kalır). Kaydedince önceki ekrana dönülür.
class CustomerFormScreen extends ConsumerWidget {
  const new({super.key, this.customerId});

  final String? customerId;

  CustomerFormControllerProvider get _provider =>
      customerFormControllerProvider(customerId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      customerId == null
          ? l10n.customerFormNewTitle
          : l10n.customerFormEditTitle,
    );

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              _CustomerFormFields(_provider, form),
              if (customerId case final id?) ...[
                SizedBox(height: context.spacing.xl),
                BigButton(
                  label: l10n.customerDelete,
                  icon: Icons.delete_outline_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => unawaited(_delete(context, ref, id)),
                ),
              ],
            ],
          ),
          action: BigButton(
            label: l10n.customerFormSave,
            onPressed: form.canSave
                ? () => unawaited(_save(context, ref))
                : null,
          ),
        ),
      ),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.customerNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final saved = await ref.read(_provider.notifier).save();
    if (saved == null || !context.mounted) return;
    // Yeni müşteride açılan müşteri sayfası kaydı zaten gösterir.
    if (customerId == null) {
      context.pushReplacement(AppRoutes.customer(saved.id));
      return;
    }
    showMessageSnackBar(context, AppLocalizations.of(context).customerSaved);
    context.pop();
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.customerDeleteTitle,
      message: l10n.customerDeleteMessage,
      confirmLabel: l10n.customerDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    final customer = await ref.read(customerRepositoryProvider).findById(id);
    if (customer != null) {
      await ref.read(financeActionsProvider.notifier).removeCustomer(customer);
    }
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.customerDeleted);
    context.go(AppRoutes.customers);
  }
}

class _CustomerFormFields extends ConsumerStatefulWidget {
  const new(this.provider, this.form);

  final CustomerFormControllerProvider provider;
  final CustomerFormState form;

  @override
  ConsumerState<_CustomerFormFields> createState() =>
      _CustomerFormFieldsState();
}

class _CustomerFormFieldsState extends ConsumerState<_CustomerFormFields> {
  late final _name = TextEditingController(text: widget.form.name);
  late final _phone = TextEditingController(text: widget.form.phone);
  late final _address = TextEditingController(text: widget.form.address);
  late final _notes = TextEditingController(text: widget.form.notes);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  CustomerFormController get _controller => ref.read(widget.provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.customerFormName,
          child: TextField(
            controller: _name,
            autofocus: widget.form.name.isEmpty,
            maxLength: maxCustomerNameLength,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(counterText: ''),
            onChanged: _controller.setName,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.customerFormPhone,
          helper: l10n.customerFormPhoneHelper,
          child: TextField(
            controller: _phone,
            maxLength: maxCustomerPhoneLength,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(counterText: ''),
            onChanged: _controller.setPhone,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.customerFormAddress,
          child: TextField(
            controller: _address,
            maxLength: maxCustomerAddressLength,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(counterText: ''),
            onChanged: _controller.setAddress,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.customerFormNotes,
          child: TextField(
            controller: _notes,
            maxLength: maxCustomerNotesLength,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(counterText: ''),
            onChanged: _controller.setNotes,
          ),
        ),
      ],
    );
  }
}
