import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';

/// İşletmeye yeni ilaç: ad, etken madde, doz birimi ve etiketteki bekleme
/// süresi (bilinmiyorsa boş). Eklenen ilaç, açan uygulama formuna döner ve
/// orada seçilir. Listede olmayan ilaç (ör. TR dışı bölgede ticari ad)
/// için.
class DrugFormScreen extends ConsumerStatefulWidget {
  const new({required this.hiveId, super.key});

  /// Uygulamanın açıldığı kovan; ilaç onun işletmesine eklenir.
  final String hiveId;

  @override
  ConsumerState<DrugFormScreen> createState() => _DrugFormScreenState();
}

class _DrugFormScreenState extends ConsumerState<DrugFormScreen> {
  final _name = TextEditingController();
  DrugActiveIngredient? _ingredient;
  DrugDoseUnit? _unit;
  int? _withdrawalDays;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canSave =>
      !_saving &&
      _name.text.trim().isNotEmpty &&
      _ingredient != null &&
      _unit != null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final orgId = ref.watch(hiveProvider(widget.hiveId)).value?.orgId;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.drugFormTitle)),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            LabeledField(
              label: l10n.drugName,
              child: TextField(
                controller: _name,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(height: spacing.xl),
            LabeledField(
              label: l10n.drugActiveIngredient,
              group: true,
              child: ChoiceChipGroup<DrugActiveIngredient>(
                options: [
                  for (final ingredient in DrugActiveIngredient.values)
                    ChoiceChipOption(
                      value: ingredient,
                      label: ingredient.label(l10n),
                    ),
                ],
                selected: {?_ingredient},
                onChanged: (selected) =>
                    setState(() => _ingredient = selected.firstOrNull),
              ),
            ),
            SizedBox(height: spacing.xl),
            LabeledField(
              label: l10n.drugDoseUnit,
              group: true,
              child: ChoiceChipGroup<DrugDoseUnit>(
                columns: DrugDoseUnit.values.length,
                options: [
                  for (final unit in DrugDoseUnit.values)
                    ChoiceChipOption(value: unit, label: unit.label(l10n)),
                ],
                selected: {?_unit},
                onChanged: (selected) =>
                    setState(() => _unit = selected.firstOrNull),
              ),
            ),
            SizedBox(height: spacing.xl),
            BigStepper(
              label: l10n.drugWithdrawalDays,
              value: _withdrawalDays,
              max: maxWithdrawalDays,
              onChanged: (days) => setState(() => _withdrawalDays = days),
            ),
          ],
        ),
        action: BigButton(
          label: l10n.drugSave,
          onPressed: _canSave && orgId != null ? () => _save(orgId) : null,
        ),
      ),
    );
  }

  Future<void> _save(String orgId) async {
    setState(() => _saving = true);
    try {
      final drug = await ref
          .read(treatmentActionsProvider.notifier)
          .addDrug(
            orgId: orgId,
            name: _name.text,
            activeIngredient: _ingredient!,
            doseUnit: _unit!,
            withdrawalDays: _withdrawalDays,
          );
      if (mounted) context.pop(drug);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
