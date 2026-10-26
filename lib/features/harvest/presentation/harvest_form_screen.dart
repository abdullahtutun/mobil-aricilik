import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/haptics.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/harvest_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_form_controller.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/harvest_labels.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

/// Seçim kartında yazılan en çok kovan numarası.
const _previewNumbers = 5;

/// Hasada alınacak ve bekleme süresi yüzünden dışarıda kalan kovanlar;
/// kovan listesi ve kilitler gelene kadar boş. Form, kovan seçimi ve okutma
/// aynı hesabı kullanır.
HarvestTargets watchHarvestTargets(
  WidgetRef ref,
  String apiaryId,
  HarvestFormState form,
) {
  final hives = ref.watch(apiaryHivesProvider(apiaryId)).value ?? const [];
  final locks =
      ref.watch(harvestLocksProvider(apiaryId, form.day)).value ?? const {};
  return harvestTargets(
    hives: hives.where(canInspect),
    selected: form.selected,
    locks: locks,
    overrides: form.overrides,
  );
}

/// Hasat (docs/design "Hasat kaydı"): arılıkta seçilen kovanlar (okutarak
/// eklenebilir), bekleme süresindeki kovanların kırmızı kartı, tarih, bal
/// türü, alınan kat ya da çerçeve, süzülen bal (kullanıcının biriminde) ve
/// kovan başına ortalama. Bekleme süresindeki kovan kovan listesinden
/// gerekçeyle alınabilir. Kaydedince arılığa dönülür ve 6 sn geri
/// alınabilir. Lot, nem ve analiz Faz E'de.
class HarvestFormScreen extends ConsumerWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  HarvestFormControllerProvider get _provider =>
      harvestFormControllerProvider(apiaryId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(apiarySummaryProvider(apiaryId));

    return switch ((summary, ref.watch(_provider))) {
      (AsyncData(value: final summary?), AsyncData(value: final form)) =>
        Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: Text(l10n.harvestFormTitle(summary.apiary.name)),
          ),
          body: BottomActionLayout(
            separated: true,
            body: ListView(
              padding: EdgeInsets.all(context.spacing.lg),
              children: [_HarvestFormFields(apiaryId, form)],
            ),
            action: _SaveButton(apiaryId, form),
          ),
        ),
      (AsyncData(value: null), _) => Scaffold(
        appBar: AppBar(),
        body: const ApiaryNotFound(),
      ),
      (AsyncError(), _) || (_, AsyncError()) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.apiariesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      _ => Scaffold(appBar: AppBar()),
    };
  }
}

/// Süzülen balın kilogramı; yazılan geçersizse ya da sınırı aşıyorsa null.
double? _storedKg(WidgetRef ref, HarvestFormState form) {
  final weight = parseHarvestWeight(form.weight);
  if (weight == null) return null;
  final kg = storedHarvestKg(
    weight,
    ref.watch(regionConfigProvider).defaultUnits.mass,
  );
  return kg <= maxHarvestNetKg ? kg : null;
}

class _SaveButton extends ConsumerWidget {
  const new(this.apiaryId, this.form);

  final String apiaryId;
  final HarvestFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = watchHarvestTargets(ref, apiaryId, form).harvested.length;
    final ready =
        form.honeyKind != null &&
        _storedKg(ref, form) != null &&
        count > 0 &&
        !form.saving;

    return BigButton(
      label: AppLocalizations.of(context).harvestSave(count),
      onPressed: ready ? () => _save(context, ref) : null,
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(harvestActionsProvider.notifier);
    final record = await ref
        .read(harvestFormControllerProvider(apiaryId).notifier)
        .save();
    if (record == null || !context.mounted) return;
    unawaited(AppHaptics.saved());
    showUndoSnackBar(
      context,
      message: l10n.harvestSaved(record.hives.length),
      onUndo: () => actions.undoAdd(record),
    );
    context.pop();
  }
}

class _HarvestFormFields extends ConsumerWidget {
  const new(this.apiaryId, this.form);

  final String apiaryId;
  final HarvestFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final controller = ref.read(
      harvestFormControllerProvider(apiaryId).notifier,
    );
    final mass = ref.watch(regionConfigProvider).defaultUnits.mass;
    final targets = watchHarvestTargets(ref, apiaryId, form);
    final kg = _storedKg(ref, form);
    final perHive = kg == null
        ? null
        : harvestPerHive(
            MassUnit.kilogram.convert(kg, to: mass),
            targets.harvested.length,
          );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SelectionCard(apiaryId: apiaryId, targets: targets),
        if (targets.locked.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          CriticalLockCard(
            title: l10n.harvestLockedTitle(
              [for (final hive in targets.locked) hive.number].join(', '),
            ),
            message: l10n.harvestLockedMessage,
          ),
        ],
        SizedBox(height: spacing.xl),
        _DateField(form: form, onChanged: controller.setDay),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.harvestHoneyKind,
          group: true,
          child: ChoiceChipGroup<HoneyKind>(
            options: [
              for (final kind in HoneyKind.values)
                ChoiceChipOption(value: kind, label: kind.label(l10n)),
            ],
            selected: {?form.honeyKind},
            onChanged: (selected) {
              // Seçili chip'e yeniden dokunmak seçimi kaldırmasın.
              if (selected.isEmpty) return;
              controller.selectHoneyKind(selected.single);
            },
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.harvestUnit,
          group: true,
          child: SegmentedTabs<HarvestUnit>(
            options: [
              for (final unit in HarvestUnit.values)
                SegmentOption(value: unit, label: unit.label(l10n)),
            ],
            selected: form.unit,
            onChanged: controller.setUnit,
          ),
        ),
        SizedBox(height: spacing.md),
        BigStepper(
          label: form.unit.takenLabel(l10n),
          value: form.unitCount,
          min: 1,
          max: maxHarvestUnitCount,
          onChanged: controller.setUnitCount,
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.harvestWeight(mass.label(l10n)),
          child: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            textInputAction: TextInputAction.done,
            style: context.typography.number,
            onChanged: controller.setWeight,
          ),
        ),
        if (form.weight.trim().isNotEmpty && kg == null) ...[
          SizedBox(height: spacing.sm),
          StatusMessage(
            status: AppStatus.warning,
            message: parseHarvestWeight(form.weight) == null
                ? l10n.harvestWeightInvalid
                : l10n.harvestWeightTooLarge(
                    format.number(
                      MassUnit.kilogram.convert(maxHarvestNetKg, to: mass),
                      maxFractionDigits: 0,
                    ),
                    mass.label(l10n),
                  ),
          ),
        ],
        if (perHive != null) ...[
          SizedBox(height: spacing.lg),
          _PerHive(
            value: l10n.harvestWeightValue(
              format.number(perHive, maxFractionDigits: 1),
              mass.label(l10n),
            ),
          ),
        ],
      ],
    );
  }
}

/// Seçili kovanlar: sayı, ilk numaralar; dokununca kovan listesi, yanda
/// Okut.
class _SelectionCard extends StatelessWidget {
  const new({required this.apiaryId, required this.targets});

  final String apiaryId;
  final HarvestTargets targets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final numbers = [for (final hive in targets.harvested) hive.number];
    final preview = [
      ...numbers.take(_previewNumbers),
      if (numbers.length > _previewNumbers) '…',
    ].join(', ');

    return AppCard(
      onTap: () => context.go(AppRoutes.apiaryHarvestHives(apiaryId)),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.harvestSelectedCount(numbers.length),
                    style: context.typography.subtitle,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    numbers.isEmpty
                        ? l10n.harvestSelectedEmptyHint
                        : l10n.harvestSelectedHint(preview),
                    style: context.typography.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing.md),
            BigButton(
              variant: BigButtonVariant.secondary,
              label: l10n.harvestScan,
              expanded: false,
              onPressed: () =>
                  context.go(AppRoutes.apiaryHarvestScan(apiaryId)),
            ),
          ],
        ),
      ),
    );
  }
}

enum _DayChoice { today, yesterday, other }

/// Hasat günü: Bugün / Dün / Başka gün (geçmiş; gelecek seçilemez).
class _DateField extends StatelessWidget {
  const new({required this.form, required this.onChanged});

  final HarvestFormState form;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = localDay(clock.now());
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    final choice = form.day == today
        ? _DayChoice.today
        : form.day == yesterday
        ? _DayChoice.yesterday
        : _DayChoice.other;

    return LabeledField(
      label: l10n.harvestDate,
      group: true,
      child: ChoiceChipGroup<_DayChoice>(
        options: [
          ChoiceChipOption(value: _DayChoice.today, label: l10n.harvestToday),
          ChoiceChipOption(
            value: _DayChoice.yesterday,
            label: l10n.harvestYesterday,
          ),
          ChoiceChipOption(
            value: _DayChoice.other,
            label: choice == _DayChoice.other
                ? AppFormat.of(context).date(form.day)
                : l10n.harvestPickDate,
          ),
        ],
        selected: {choice},
        onChanged: (selected) async {
          switch (selected.firstOrNull ?? _DayChoice.other) {
            case _DayChoice.today:
              onChanged(today);
            case _DayChoice.yesterday:
              onChanged(yesterday);
            case _DayChoice.other:
              final day = await showDatePicker(
                context: context,
                initialDate: form.day,
                firstDate: DateTime(today.year - 1, today.month, today.day),
                lastDate: today,
              );
              if (day != null) onChanged(day);
          }
        },
      ),
    );
  }
}

/// Kovan başına ortalama: iyi durum zemininde, solda adı sağda değer.
class _PerHive extends StatelessWidget {
  const new({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return MergeSemantics(
      child: AppCard(
        status: AppStatus.good,
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: context.spacing.sm,
            children: [
              Text(l10n.harvestPerHive, style: context.typography.body),
              Text(
                value,
                style: context.typography.subtitle.copyWith(
                  color: colors.statusGood,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
