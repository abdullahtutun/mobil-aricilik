import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/digits.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_form_controller.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_providers.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_labels.dart';

/// Stok kalemi ekleme ([itemId] null) ve düzenleme: ad, kategori, birim,
/// konum ve eşik; düzenlemede "Kalemi sil". Yeni kalemin kategorisi
/// [category]. Kaydedince listeye ya da kaleme dönülür.
class InventoryFormScreen extends ConsumerWidget {
  const new({super.key, this.itemId, this.category});

  final String? itemId;
  final InventoryCategory? category;

  InventoryFormControllerProvider get _provider =>
      inventoryFormControllerProvider(itemId, category: category);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      itemId == null ? l10n.inventoryFormNewTitle : l10n.inventoryFormEditTitle,
    );

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              _InventoryFormFields(_provider, form),
              if (itemId case final id?) ...[
                SizedBox(height: context.spacing.xl),
                BigButton(
                  label: l10n.inventoryFormDelete,
                  icon: Icons.delete_outline_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => _delete(context, ref, id),
                ),
              ],
            ],
          ),
          action: BigButton(
            label: l10n.inventoryFormSave,
            onPressed: form.canSave ? () => _save(context, ref) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.inventoryNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.inventoryLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final saved = await ref.read(_provider.notifier).save();
    if (saved == null || !context.mounted) return;
    if (itemId != null) {
      showMessageSnackBar(context, AppLocalizations.of(context).inventorySaved);
    }
    context.pop();
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.inventoryDeleteTitle,
      message: l10n.inventoryDeleteMessage,
      confirmLabel: l10n.inventoryDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(inventoryActionsProvider.notifier).deleteItem(id);
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.inventoryDeleted);
    context.go(AppRoutes.inventory);
  }
}

class _InventoryFormFields extends ConsumerStatefulWidget {
  const new(this.provider, this.form);

  final InventoryFormControllerProvider provider;
  final InventoryFormState form;

  @override
  ConsumerState<_InventoryFormFields> createState() =>
      _InventoryFormFieldsState();
}

class _InventoryFormFieldsState extends ConsumerState<_InventoryFormFields> {
  late final _name = TextEditingController(text: widget.form.name);
  late final _place = TextEditingController(text: widget.form.place);
  late final _threshold = TextEditingController(text: widget.form.threshold);

  @override
  void dispose() {
    _name.dispose();
    _place.dispose();
    _threshold.dispose();
    super.dispose();
  }

  InventoryFormController get _controller => ref.read(widget.provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final form = widget.form;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.inventoryFormName,
          child: TextField(
            controller: _name,
            maxLength: maxInventoryNameLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(counterText: ''),
            onChanged: _controller.setName,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.inventoryFormCategory,
          group: true,
          child: ChoiceChipGroup<InventoryCategory>(
            options: [
              for (final category in InventoryCategory.values)
                ChoiceChipOption(value: category, label: category.label(l10n)),
            ],
            selected: {?form.category},
            onChanged: (selected) {
              // Seçili chip'e yeniden dokunmak seçimi kaldırmasın.
              if (selected.isEmpty) return;
              _controller.setCategory(selected.single);
            },
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.inventoryFormUnit,
          group: true,
          child: ChoiceChipGroup<InventoryUnit>(
            options: [
              for (final unit in InventoryUnit.values)
                ChoiceChipOption(value: unit, label: unit.fullName(l10n)),
            ],
            selected: {?form.unit},
            onChanged: (selected) {
              if (selected.isEmpty) return;
              _controller.setUnit(selected.single);
            },
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.inventoryFormLocation,
          helper: l10n.inventoryFormLocationHint,
          child: TextField(
            controller: _place,
            maxLength: maxInventoryPlaceLength,
            decoration: const InputDecoration(counterText: ''),
            onChanged: _controller.setPlace,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: switch (form.unit) {
            final unit? => l10n.inventoryFormThresholdUnit(unit.label(l10n)),
            null => l10n.inventoryFormThreshold,
          },
          helper: l10n.inventoryFormThresholdHint,
          child: TextField(
            controller: _threshold,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              const AsciiDigitsFormatter(),
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            textInputAction: TextInputAction.done,
            style: context.typography.number,
            onChanged: _controller.setThreshold,
          ),
        ),
        if (form.thresholdInvalid) ...[
          SizedBox(height: spacing.sm),
          StatusMessage(
            status: AppStatus.warning,
            message: l10n.inventoryFormThresholdInvalid,
          ),
        ],
      ],
    );
  }
}
