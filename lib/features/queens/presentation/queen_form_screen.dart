import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';
import 'package:mobil_arici/features/queens/presentation/queen_form_controller.dart';
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_labels.dart';

/// Kovana yeni ana verme ([editing] false) ya da kovandaki anayı
/// düzenleme: yıl, işaret rengi, ırk ve hat, kaynak, kanat ve anne ana.
/// Klavye yalnız ırk ve hat için açılır. Yeni ana kovandaki anının yerine
/// geçer; kaydedince önceki ekrana dönülür ve 6 sn geri alınabilir.
class QueenFormScreen extends ConsumerWidget {
  const new({required this.hiveId, super.key, this.editing = false});

  final String hiveId;
  final bool editing;

  QueenFormControllerProvider get _provider =>
      queenFormControllerProvider(hiveId: hiveId, editing: editing);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: Text(
            editing
                ? l10n.queenFormEditTitle
                : l10n.queenFormNewTitle(form.hive.number),
          ),
        ),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [_QueenFormFields(_provider)],
          ),
          action: BigButton(
            label: l10n.queenFormSave,
            onPressed: form.saving ? null : () => _save(context, ref, form),
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: editing
            ? Padding(
                padding: EdgeInsets.all(context.spacing.lg),
                child: EmptyState(
                  icon: Icons.workspace_premium_outlined,
                  title: l10n.queenNoneTitle,
                  message: l10n.queenNoneMessage,
                ),
              )
            : const HiveNotFound(),
      ),
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
    QueenFormState form,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(queenActionsProvider.notifier);
    final given = await ref.read(_provider.notifier).save();
    // Kovan ya da ana bu arada silindiyse ekran bunu gösterir.
    if (!context.mounted || ref.read(_provider).value == null) return;
    if (given != null) {
      showUndoSnackBar(
        context,
        message: l10n.queenGiven(form.hive.number),
        onUndo: () => actions.undoGive(given),
      );
    }
    context.pop();
  }
}

class _QueenFormFields extends ConsumerStatefulWidget {
  const new(this.provider);

  final QueenFormControllerProvider provider;

  @override
  ConsumerState<_QueenFormFields> createState() => _QueenFormFieldsState();
}

class _QueenFormFieldsState extends ConsumerState<_QueenFormFields> {
  late final _breed = TextEditingController(
    text: ref.read(widget.provider).value!.breed,
  );
  late final _breedLine = TextEditingController(
    text: ref.read(widget.provider).value!.breedLine,
  );

  /// Kayıtlı yıl formun açıldığı andaki; seçenekler yıl değiştikçe
  /// kaymasın.
  late final List<int> _yearOptions = queenYearOptions(
    currentYear: clock.now().year,
    savedYear: ref.read(widget.provider).value!.year,
  );

  @override
  void dispose() {
    _breed.dispose();
    _breedLine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final form = ref.watch(widget.provider).value;
    if (form == null) return const SizedBox.shrink();
    final controller = ref.read(widget.provider.notifier);
    final year = form.year;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.queenYear,
          helper: l10n.queenYearHelper,
          group: true,
          child: ChoiceChipGroup<int>(
            options: [
              for (final option in _yearOptions)
                ChoiceChipOption(value: option, label: '$option'),
            ],
            selected: {?year},
            onChanged: (selected) =>
                controller.selectYear(selected.firstOrNull),
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.queenMark,
          helper: year == null
              ? null
              : l10n.queenMarkSuggestion(
                  '$year',
                  markColorForYear(year).label(l10n),
                ),
          group: true,
          child: ChoiceChipGroup<QueenMarkColor?>(
            options: [
              for (final color in QueenMarkColor.values)
                ChoiceChipOption(value: color, label: color.label(l10n)),
              ChoiceChipOption(value: null, label: l10n.queenUnmarked),
            ],
            selected: {form.markColor},
            onChanged: (selected) {
              if (selected.isNotEmpty) {
                controller.selectMarkColor(selected.single);
              }
            },
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.queenBreed,
          child: TextField(
            controller: _breed,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(hintText: l10n.queenBreedHint),
            onChanged: controller.updateBreed,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.queenBreedLine,
          child: TextField(
            controller: _breedLine,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(hintText: l10n.queenBreedLineHint),
            onChanged: controller.updateBreedLine,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.queenSource,
          group: true,
          child: ChoiceChipGroup<QueenSource>(
            options: [
              for (final source in QueenSource.values)
                ChoiceChipOption(value: source, label: source.label(l10n)),
            ],
            selected: {?form.source},
            onChanged: (selected) =>
                controller.selectSource(selected.firstOrNull),
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.queenWing,
          group: true,
          child: ChoiceChipGroup<bool>(
            columns: 2,
            options: [
              ChoiceChipOption(value: false, label: l10n.queenWingIntact),
              ChoiceChipOption(value: true, label: l10n.queenWingClipped),
            ],
            selected: {form.wingClipped},
            onChanged: (selected) {
              if (selected.isNotEmpty) {
                controller.selectWingClipped(clipped: selected.single);
              }
            },
          ),
        ),
        SizedBox(height: spacing.xl),
        _MotherField(form: form, onChanged: controller.selectMother),
      ],
    );
  }
}

/// Anne ana satırı; dokununca işletmenin analarından seçilir. Düzenlenen
/// ana kendi annesi olamaz, listede yok.
class _MotherField extends ConsumerWidget {
  const new({required this.form, required this.onChanged});

  final QueenFormState form;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final queens = ref.watch(organizationQueensProvider).value ?? const [];
    final hives = ref.watch(hivesByQueenProvider).value ?? const {};
    final mother = queens
        .where((queen) => queen.id == form.motherQueenId)
        .firstOrNull;

    return ListGroup(
      children: [
        ListRow(
          title: l10n.queenMother,
          value:
              mother?.reference(l10n, hive: hives[mother.id]) ??
              l10n.queenMotherUnknown,
          onTap: () async {
            final choice = await showOptionSheet<(String?,)>(
              context,
              (context) => OptionSheet(
                title: l10n.queenMother,
                options: [
                  SheetOption(
                    value: (null,),
                    icon: Icons.help_outline_rounded,
                    label: l10n.queenMotherUnknown,
                    selected: form.motherQueenId == null,
                  ),
                  // En yeni önce; anne çoğunlukla yakın zamanın anasıdır.
                  for (final queen in queens.reversed)
                    if (queen.id != form.queenId)
                      SheetOption(
                        value: (queen.id,),
                        icon: Icons.workspace_premium_outlined,
                        label: queen.reference(l10n, hive: hives[queen.id]),
                        selected: queen.id == form.motherQueenId,
                      ),
                ],
              ),
            );
            // Kapatılırsa null; "Bilinmiyor" `(null,)` döner.
            if (choice != null) onChanged(choice.$1);
          },
        ),
      ],
    );
  }
}
