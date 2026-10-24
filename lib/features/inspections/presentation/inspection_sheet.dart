import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/haptics.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_form_controller.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_providers.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/inspection_labels.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/inspection_reminder_choice.dart';

/// Hızlı muayene (teknik.md §9): kovan kartının üstünde alttan açılan
/// sayfa. Hepsi chip ve büyük sayaç, klavye yok. Önceki muayenenin değerleri
/// soluk gelir; dokunulmayanlar da olduğu gibi kaydedilir. Her değişiklik
/// taslak olarak saklanır. Kaydet titreşir ve sayfayı kapatır; bildirimde
/// Geri al ve "X gün sonra hatırlat" var.
class InspectionSheet extends ConsumerWidget {
  const new({required this.hiveId, super.key});

  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(inspectionFormControllerProvider(hiveId))) {
      AsyncData(value: final form?) => _InspectionForm(hiveId, form),
      AsyncData() => const HiveNotFound(),
      AsyncError() => Center(
        child: Text(AppLocalizations.of(context).inspectionLoadError),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => const SizedBox.shrink(),
    };
  }
}

class _InspectionForm extends ConsumerWidget {
  const new(this.hiveId, this.form);

  final String hiveId;
  final InspectionFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final gap = SizedBox(height: spacing.lg);
    final controller = ref.read(
      inspectionFormControllerProvider(hiveId).notifier,
    );
    final draft = form.draft;
    final values = draft.values;

    return BottomActionLayout(
      separated: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(form),
          // Kısa ve sabit form: alanların hepsi kurulu kalır (ekran okuyucu
          // da hepsini görür).
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (form.hasSuggestions) ...[
                    _Note(
                      icon: Icons.history_rounded,
                      text: l10n.inspectionSuggestedLegend,
                    ),
                    gap,
                  ],
                  if (form.hasChanges) ...[
                    _Note(
                      icon: Icons.save_rounded,
                      text: l10n.inspectionDraftSaved,
                      action: TextButton(
                        onPressed: form.saving ? null : controller.restart,
                        child: Text(l10n.inspectionRestart),
                      ),
                    ),
                    gap,
                  ],
                  _ChoiceField<QueenState>(
                    title: l10n.inspectionQueen,
                    columns: QueenState.values.length,
                    options: [
                      for (final state in QueenState.values)
                        ChoiceChipOption(
                          value: state,
                          label: state.label(l10n),
                        ),
                    ],
                    value: values.queenState,
                    suggested: draft.isSuggested(InspectionField.queenState),
                    onChanged: controller.setQueenState,
                  ),
                  gap,
                  _Section(
                    title: l10n.inspectionFrames,
                    child: Column(
                      children: [
                        BigStepper(
                          label: l10n.inspectionBeeFrames,
                          value: values.beeFrames,
                          max: maxInspectionFrames,
                          suggested: draft.isSuggested(
                            InspectionField.beeFrames,
                          ),
                          onChanged: controller.setBeeFrames,
                        ),
                        SizedBox(height: context.touchTargets.gap),
                        BigStepper(
                          label: l10n.inspectionBroodFrames,
                          value: values.broodFrames,
                          max: maxInspectionFrames,
                          suggested: draft.isSuggested(
                            InspectionField.broodFrames,
                          ),
                          onChanged: controller.setBroodFrames,
                        ),
                        SizedBox(height: context.touchTargets.gap),
                        BigStepper(
                          label: l10n.inspectionHoneyFrames,
                          value: values.honeyFrames,
                          max: maxInspectionFrames,
                          suggested: draft.isSuggested(
                            InspectionField.honeyFrames,
                          ),
                          onChanged: controller.setHoneyFrames,
                        ),
                      ],
                    ),
                  ),
                  gap,
                  _ChoiceField<Temperament>(
                    title: l10n.inspectionTemperament,
                    options: [
                      for (final temperament in Temperament.values)
                        ChoiceChipOption(
                          value: temperament,
                          label: temperament.label(l10n),
                        ),
                    ],
                    value: values.temperament,
                    suggested: draft.isSuggested(InspectionField.temperament),
                    onChanged: controller.setTemperament,
                  ),
                  gap,
                  _ChoiceField<bool>(
                    title: l10n.inspectionSwarmSigns,
                    options: _answers(l10n),
                    value: values.swarmSigns,
                    suggested: draft.isSuggested(InspectionField.swarmSigns),
                    onChanged: (seen) => controller.setSwarmSigns(seen: seen),
                  ),
                  gap,
                  _ChoiceField<QueenCells>(
                    title: l10n.inspectionQueenCells,
                    options: [
                      for (final cells in QueenCells.values)
                        ChoiceChipOption(
                          value: cells,
                          label: cells.label(l10n),
                        ),
                    ],
                    value: values.queenCells,
                    suggested: draft.isSuggested(InspectionField.queenCells),
                    onChanged: controller.setQueenCells,
                  ),
                  gap,
                  _ChoiceField<bool>(
                    title: l10n.inspectionDisease,
                    options: _answers(l10n),
                    value: values.diseaseSuspected,
                    suggested: draft.isSuggested(
                      InspectionField.diseaseSuspected,
                    ),
                    onChanged: (suspected) =>
                        controller.setDiseaseSuspected(suspected: suspected),
                  ),
                  gap,
                  _Section(
                    title: l10n.inspectionActions,
                    child: ChoiceChipGroup<InspectionAction>(
                      multiSelect: true,
                      options: [
                        for (final action in InspectionAction.values)
                          ChoiceChipOption(
                            value: action,
                            label: action.label(l10n),
                          ),
                      ],
                      selected: values.actions,
                      onChanged: controller.setActions,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      action: BigButton(
        label: l10n.inspectionSave,
        onPressed: form.saving ? null : () => _save(context, ref),
      ),
    );
  }

  static List<ChoiceChipOption<bool>> _answers(AppLocalizations l10n) => [
    ChoiceChipOption(value: false, label: l10n.inspectionAnswerNo),
    ChoiceChipOption(value: true, label: l10n.inspectionAnswerYes),
  ];

  /// Yazar, titreşir, bildirimi gösterir ve sayfayı kapatır. Bildirim
  /// kovan kartında kalır; Geri al ve hatırlatma sayfa kapandıktan sonra
  /// da çalışır.
  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(inspectionActionsProvider.notifier);
    final saved = await ref
        .read(inspectionFormControllerProvider(hiveId).notifier)
        .save();
    if (saved == null || !context.mounted) return;
    unawaited(AppHaptics.saved());
    showUndoSnackBar(
      context,
      message: l10n.inspectionSaved(form.hive.number),
      onUndo: () => actions.undo(saved),
      details: InspectionReminderChoice(
        onChanged: (days) => actions.remind(saved.inspection, days),
      ),
    );
    context.pop();
  }
}

/// Başlık: hangi kovan, önceki muayene ne zaman; sağda Kapat.
class _Header extends StatelessWidget {
  const new(this.form);

  final InspectionFormState form;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final previous = form.previous;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: spacing.lg,
        end: spacing.sm,
        bottom: spacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  label: l10n.inspectionTitle(form.hive.number),
                  excludeSemantics: true,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: l10n.timelineInspection),
                        TextSpan(text: l10n.titleSeparator),
                        TextSpan(
                          text: form.hive.number,
                          style: TextStyle(color: context.colors.primary),
                        ),
                      ],
                    ),
                    style: context.typography.headline,
                  ),
                ),
                Text(
                  previous == null
                      ? l10n.inspectionFirst
                      : l10n.inspectionPrevious(
                          AppFormat.of(context)
                              .date(previous.inspectedAt.toLocal()),
                        ),
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(Icons.close_rounded),
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}

/// Formun üstündeki açıklama: ikon, metin ve metnin altında isteğe bağlı
/// buton (büyük yazıda ve eldivende buton metni sıkıştırmasın).
class _Note extends StatelessWidget {
  const new({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final action = this.action;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: context.sizes.iconSmall, color: colors.textSecondary),
        SizedBox(width: context.spacing.sm),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: context.typography.bodySmall.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              ?action,
            ],
          ),
        ),
      ],
    );
  }
}

/// Bölüm: büyük harfli küçük başlık, altında içerik.
class _Section extends StatelessWidget {
  const new({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionLabel(title),
        SizedBox(height: context.spacing.sm),
        child,
      ],
    );
  }
}

/// Tek seçimli chip alanı. Seçili chip'e yeniden dokunmak seçimi kaldırır;
/// öneriye dokunmak onu onaylar.
class _ChoiceField<T> extends StatelessWidget {
  const new({
    required this.title,
    required this.options,
    required this.value,
    required this.suggested,
    required this.onChanged,
    this.columns,
  });

  /// Verilirse chip'ler eşit sütunlarda.
  final int? columns;
  final String title;
  final List<ChoiceChipOption<T>> options;
  final T? value;
  final bool suggested;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    return _Section(
      title: title,
      child: ChoiceChipGroup<T>(
        columns: columns,
        options: options,
        selected: {?value},
        suggested: suggested,
        onChanged: (selected) => onChanged(selected.firstOrNull),
      ),
    );
  }
}
