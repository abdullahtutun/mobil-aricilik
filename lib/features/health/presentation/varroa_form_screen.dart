import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/varroa_form_controller.dart';
import 'package:mobil_arici/features/health/presentation/varroa_providers.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_chart.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_labels.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_result_card.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';

/// Varroa ölçümü (docs/design "Varroa ölçümü"): yöntem chip'leri; örnek arı
/// (alt tablada tablanın kaldığı gün) ve akar sayaçları; sonuç kartı eşiğe
/// göre uyarır; altta arılığın son ölçümleri. Klavye açılmaz. Kaydedince
/// karta dönülür ve 6 sn geri alınabilir.
class VarroaFormScreen extends ConsumerWidget {
  const new({required this.hiveId, super.key});

  final String hiveId;

  VarroaFormControllerProvider get _provider =>
      varroaFormControllerProvider(hiveId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: Text(l10n.varroaFormTitle(form.hive.number)),
        ),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [_VarroaFormFields(_provider, form)],
          ),
          action: BigButton(
            label: l10n.varroaSave,
            onPressed: form.canSave ? () => _save(context, ref, form) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(appBar: AppBar(), body: const HiveNotFound()),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    VarroaFormState form,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(varroaActionsProvider.notifier);
    final count = await ref.read(_provider.notifier).save();
    // Kovan bu arada silindiyse ekran bunu gösterir.
    if (count == null || !context.mounted) return;
    showUndoSnackBar(
      context,
      message: l10n.varroaSaved(form.hive.number),
      onUndo: () => actions.undoAdd(count),
    );
    context.pop();
  }
}

class _VarroaFormFields extends ConsumerWidget {
  const new(this.provider, this.form);

  final VarroaFormControllerProvider provider;
  final VarroaFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final controller = ref.read(provider.notifier);
    final thresholds =
        ref.watch(varroaThresholdsProvider).value ?? defaultVarroaThresholds;
    final apiaryName = ref
        .watch(apiarySummaryProvider(form.hive.apiaryId))
        .value
        ?.apiary
        .name;
    final load = form.load;
    final board = !form.method.usesSample;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.varroaMethod,
          group: true,
          child: ChoiceChipGroup<MiteCountMethod>(
            columns: 3,
            options: [
              for (final method in MiteCountMethod.values)
                ChoiceChipOption(value: method, label: method.label(l10n)),
            ],
            selected: {form.method},
            onChanged: (selected) {
              // Her zaman bir yöntem seçili; seçili chip'e yeniden dokunmak
              // seçimi kaldırmasın.
              if (selected.isEmpty) return;
              controller.selectMethod(selected.single);
            },
          ),
        ),
        SizedBox(height: spacing.lg),
        if (board)
          BigStepper(
            label: l10n.varroaBoardDays,
            value: form.days,
            min: 1,
            max: maxBoardDays,
            onChanged: controller.setDays,
          )
        else
          BigStepper(
            label: l10n.varroaSampleBees,
            value: form.sampleBees,
            min: sampleBeesStep,
            max: maxSampleBees,
            step: sampleBeesStep,
            onChanged: controller.setSampleBees,
          ),
        SizedBox(height: context.touchTargets.gap),
        BigStepper(
          label: board ? l10n.varroaBoardMites : l10n.varroaMites,
          value: form.mites,
          onChanged: controller.setMites,
        ),
        if (load != null) ...[
          SizedBox(height: spacing.lg),
          VarroaResultCard(load: load, thresholds: thresholds),
        ],
        if (apiaryName != null) ...[
          SizedBox(height: spacing.lg),
          ApiaryVarroaCard(
            apiaryId: form.hive.apiaryId,
            title: l10n.varroaChartTitle(apiaryName),
          ),
        ],
      ],
    );
  }
}
