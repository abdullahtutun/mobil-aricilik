import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:mobil_arici/features/queens/presentation/queen_rearing_providers.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_labels.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_rearing_labels.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Serinin takvimi (docs/design "Ana arı yetiştirme"): üstte aktarılan,
/// kabul (oranıyla) ve kutu sayısı; anne ana ve aktarma günü; G0–G24
/// adımları (bitti yeşil, sıradaki bal rengi, ileride halka). Adım takvim
/// görevi tamamlanınca biter. Altta çiftleşme kutuları; kutuya dokununca
/// içi değişir, yumurtlayan ana kovana verilir. Kutu yokken altta
/// "Memeleri kutulara dağıt". Viewer yalnız görür.
class RearingBatchScreen extends ConsumerWidget {
  const new({required this.batchId, super.key});

  final String batchId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);
    final batch = ref.watch(rearingBatchProvider(batchId));
    final nucs = ref.watch(rearingBatchNucsProvider(batchId));

    return switch ((batch, nucs)) {
      (AsyncData(value: final batch?), AsyncData(value: final nucs)) =>
        Scaffold(
          appBar: AppBar(
            title: Text(l10n.rearingBatchTitle(batch.number)),
            actions: [
              if (canWrite)
                IconButton(
                  tooltip: l10n.rearingEdit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.go(AppRoutes.rearingBatchEdit(batchId)),
                ),
            ],
          ),
          body: _BatchBody(batch, nucs, canWrite: canWrite),
        ),
      (AsyncData(value: null), _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.rearingNotFound)),
      ),
      (AsyncError(), _) || (_, AsyncError()) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.rearingLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      _ => Scaffold(appBar: AppBar()),
    };
  }
}

class _BatchBody extends ConsumerWidget {
  const new(this.batch, this.nucs, {required this.canWrite});

  final QueenRearingBatch batch;
  final List<MatingNuc> nucs;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final counted = [
      for (final nuc in nucs)
        if (countsForBatch(nuc)) nuc,
    ];
    final tasks = ref.watch(rearingBatchTasksProvider(batch.id)).value ?? [];
    final timeline = rearingTimeline(
      batch.graftedOn,
      completed: {
        for (final task in tasks)
          if (task.completedAt != null) ?RearingStep.ofDay(task.sourceStep),
      },
      open: {
        for (final task in tasks)
          if (task.completedAt == null) ?RearingStep.ofDay(task.sourceStep),
      },
      today: clock.now(),
    );
    final percent = acceptancePercent(
      grafted: batch.graftedCount,
      accepted: batch.acceptedCount,
    );

    final motherId = batch.motherQueenId;
    final mother = motherId == null
        ? null
        : ref.watch(queenProvider(motherId)).value;
    final motherHive = mother == null
        ? null
        : ref.watch(hivesByQueenProvider).value?[mother.id];
    final grafted = format.dayMonth(batch.graftedOn);

    final list = ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: context.touchTargets.gap,
            children: [
              Expanded(
                child: SummaryTile(
                  label: l10n.rearingGraftedLabel,
                  value: '${batch.graftedCount}',
                ),
              ),
              Expanded(
                child: SummaryTile(
                  label: l10n.rearingAcceptedLabel,
                  value:
                      batch.acceptedCount?.toString() ?? l10n.rearingNotCounted,
                  detail: percent == null
                      ? null
                      : l10n.rearingAcceptedPercent(percent),
                  status: percent == null ? null : AppStatus.good,
                ),
              ),
              Expanded(
                child: SummaryTile(
                  label: l10n.rearingNucsLabel,
                  value: '${counted.length}',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.md),
        Text(
          mother == null
              ? l10n.rearingMotherUnknownLine(grafted)
              : l10n.rearingMotherLine(
                  mother.reference(l10n, hive: motherHive),
                  grafted,
                ),
          style: context.typography.bodySmall.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.lg),
        for (final (index, entry) in timeline.indexed)
          _StepRow(
            entry,
            detail: rearingStepDetail(
              l10n,
              entry.step,
              batch,
              nucCount: counted.length,
            ),
            isLast: index == timeline.length - 1,
          ),
        if (nucs.isNotEmpty) ...[
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.rearingNucsSection),
          SizedBox(height: spacing.sm),
          ListGroup(
            children: [
              for (final nuc in nucs)
                _NucRow(
                  nuc,
                  onTap: canWrite && nuc.status != MatingNucStatus.given
                      ? () => _changeNuc(context, ref, nuc)
                      : null,
                ),
            ],
          ),
        ],
      ],
    );
    if (!canWrite || counted.isNotEmpty) return SafeArea(child: list);
    return BottomActionLayout(
      separated: true,
      body: list,
      action: BigButton(
        label: l10n.rearingDistribute,
        onPressed: () => _distribute(context, ref),
      ),
    );
  }

  /// Arılık ve kutu sayısını sorar, memeleri dağıtır.
  Future<void> _distribute(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showOptionSheet<({String apiaryId, int count})>(
      context,
      (context) => _DistributeSheet(
        initialCount: batch.acceptedCount ?? batch.graftedCount,
      ),
    );
    if (choice == null || !context.mounted) return;
    final nucs = await ref
        .read(rearingActionsProvider.notifier)
        .distribute(batch, apiaryId: choice.apiaryId, count: choice.count);
    if (context.mounted) {
      showMessageSnackBar(context, l10n.rearingDistributed(nucs.length));
    }
  }

  /// Kutunun içini seçtirir; "Kovana ver" seçilirse kovan sorulur ve ana
  /// verilir (6 sn Geri al'lı).
  Future<void> _changeNuc(
    BuildContext context,
    WidgetRef ref,
    MatingNuc nuc,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(rearingActionsProvider.notifier);
    final choice = await showOptionSheet<MatingNucStatus>(
      context,
      (context) => OptionSheet(
        title: l10n.rearingNucTitle(nuc.number),
        options: [
          // "Kovana verildi" seçenek değil; yumurtlayan kutuda "Kovana ver".
          if (canGiveQueen(nuc))
            SheetOption(
              value: MatingNucStatus.given,
              icon: Icons.move_down_rounded,
              label: l10n.rearingNucGive,
            ),
          for (final status in MatingNucStatus.values)
            if (status != MatingNucStatus.given)
              SheetOption(
                value: status,
                icon: status.badge.icon,
                iconColor: status.badge.colorIn(context.colors),
                label: status.label(l10n),
                selected: status == nuc.status,
              ),
        ],
      ),
    );
    if (choice == null || choice == nuc.status || !context.mounted) return;
    if (choice != MatingNucStatus.given) {
      await actions.setNucStatus(nuc, choice);
      return;
    }
    final hiveId = await _pickHive(context, ref);
    if (hiveId == null || !context.mounted) return;
    final given = await actions.giveQueen(nuc.id, hiveId);
    if (!context.mounted) return;
    showUndoSnackBar(
      context,
      message: l10n.queenGiven(given.given.hive.number),
      onUndo: () => actions.undoGiveQueen(given),
    );
  }

  /// Ananın verileceği kovan: arılık ve numara sırasıyla sayılan
  /// (aktif) kovanlar.
  Future<String?> _pickHive(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final summaries = ref.read(apiaryListProvider).value ?? const [];
    final apiaries = {
      for (final summary in summaries) summary.apiary.id: summary.apiary.name,
    };
    final hives =
        [
          for (final hive in await ref.read(organizationHivesProvider.future))
            if (hive.status.isCounted) hive,
        ]..sort(
          (a, b) => switch (compareNatural(
            apiaries[a.apiaryId] ?? '',
            apiaries[b.apiaryId] ?? '',
          )) {
            0 => compareNatural(a.number, b.number),
            final order => order,
          },
        );
    if (!context.mounted) return null;
    return await showOptionSheet<String>(
      context,
      (context) => OptionSheet(
        title: l10n.rearingNucChooseHive,
        emptyMessage: l10n.rearingNucNoHives,
        options: [
          for (final hive in hives)
            SheetOption(
              value: hive.id,
              icon: Icons.hive_outlined,
              label: l10n.hiveLabel(hive.number),
              hint: apiaries[hive.apiaryId],
            ),
        ],
      ),
    );
  }
}

/// Takvimde adım: solda gün dairesi (bitti dolu yeşil, sıradaki dolu bal
/// rengi, ileride halka) ve sonrakine inen çizgi; sağda ad, gün ("Bugün")
/// ve ayrıntı. Durum ekran okuyucuda kelimeyle de söylenir.
class _StepRow extends StatelessWidget {
  const new(this.entry, {required this.detail, required this.isLast});

  final RearingTimelineEntry entry;
  final String detail;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final current = entry.state == RearingStepState.current;
    final isToday = entry.on == dateOnly(clock.now());

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              _DayDot(entry),
              if (!isLast)
                Expanded(
                  child: SizedBox(
                    width: context.strokes.focus,
                    child: ColoredBox(
                      color: entry.state == RearingStepState.done
                          ? colors.statusGood
                          : colors.divider,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: spacing.xs,
                bottom: isLast ? 0 : spacing.lg,
              ),
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            rearingStepTitle(l10n, entry.step),
                            style: typography.subtitle,
                          ),
                        ),
                        SizedBox(width: spacing.sm),
                        Flexible(
                          child: Text(
                            isToday
                                ? l10n.rearingToday
                                : format.dayMonth(entry.on),
                            textAlign: TextAlign.end,
                            style: typography.label.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      detail,
                      style: typography.bodySmall.copyWith(
                        color: current ? colors.primary : colors.textSecondary,
                      ),
                    ),
                    Semantics(
                      label: rearingStepStateLabel(l10n, entry.state),
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gün dairesi: içinde "G10"; ekran okuyucuya gösterilmez (gün adımın
/// gününde yazar).
class _DayDot extends StatelessWidget {
  const new(this.entry);

  final RearingTimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final ring = context.strokes.focus;
    final (decoration, foreground) = switch (entry.state) {
      RearingStepState.done => (
        BoxDecoration(shape: BoxShape.circle, color: colors.statusGood),
        colors.onStatus,
      ),
      RearingStepState.current => (
        BoxDecoration(
          shape: BoxShape.circle,
          color: colors.primary,
          border: Border.all(color: colors.statusWarningContainer, width: ring),
        ),
        colors.onPrimary,
      ),
      RearingStepState.upcoming => (
        BoxDecoration(
          shape: BoxShape.circle,
          color: colors.surface,
          border: Border.all(color: colors.outline, width: ring),
        ),
        colors.textSecondary,
      ),
    };

    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: context.sizes.avatar,
        child: DecoratedBox(
          decoration: decoration,
          child: Padding(
            padding: EdgeInsets.all(context.spacing.xs),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                l10n.rearingDay(entry.step.day),
                style: context.typography.labelSmall.copyWith(
                  color: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kutu satırı: "Kutu 3", arılığı ve içi rozet olarak (renk + ikon +
/// kelime).
class _NucRow extends ConsumerWidget {
  const new(this.nuc, {required this.onTap});

  final MatingNuc nuc;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final apiary = ref.watch(apiarySummaryProvider(nuc.apiaryId)).value;
    return ListRow(
      title: l10n.rearingNucTitle(nuc.number),
      subtitle: apiary?.apiary.name,
      trailing: StatusBadge(
        status: nuc.status.badge,
        label: nuc.status.label(l10n),
      ),
      onTap: onTap,
    );
  }
}

/// Memeleri dağıtma sayfası: arılık, kutu sayısı ve kaç boş kutunun
/// yeniden kullanılıp kaç yeni kutu açılacağı ([distributeCells]).
/// Dağıt'a basılınca seçim döner.
class _DistributeSheet extends ConsumerStatefulWidget {
  const new({required this.initialCount});

  final int initialCount;

  @override
  ConsumerState<_DistributeSheet> createState() => _DistributeSheetState();
}

class _DistributeSheetState extends ConsumerState<_DistributeSheet> {
  String? _apiaryId;
  late int _count = widget.initialCount.clamp(1, maxGraftedCount);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final apiaries = ref.watch(apiaryListProvider).value ?? const [];
    final apiaryId = _apiaryId ?? apiaries.firstOrNull?.apiary.id;
    final apiaryNucs = apiaryId == null
        ? null
        : ref.watch(apiaryNucsProvider(apiaryId)).value;
    final plan = apiaryNucs == null
        ? null
        : distributeCells(apiaryNucs, _count);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: spacing.lg,
          right: spacing.lg,
          bottom: spacing.lg + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              header: true,
              child: Text(
                l10n.rearingDistribute,
                style: context.typography.title,
              ),
            ),
            SizedBox(height: spacing.lg),
            if (apiaries.isEmpty)
              Text(l10n.rearingDistributeNoApiary)
            else ...[
              LabeledField(
                label: l10n.rearingDistributeApiary,
                child: ChoiceChipGroup<String>(
                  options: [
                    for (final summary in apiaries)
                      ChoiceChipOption(
                        value: summary.apiary.id,
                        label: summary.apiary.name,
                      ),
                  ],
                  selected: {?apiaryId},
                  onChanged: (selected) {
                    if (selected.firstOrNull case final id?) {
                      setState(() => _apiaryId = id);
                    }
                  },
                ),
              ),
              SizedBox(height: spacing.xl),
              BigStepper(
                label: l10n.rearingDistributeCount,
                value: _count,
                min: 1,
                max: maxGraftedCount,
                onChanged: (count) => setState(() => _count = count),
              ),
              if (plan != null) ...[
                SizedBox(height: spacing.md),
                Text(
                  l10n.rearingDistributePlan(
                    plan.reused.length,
                    plan.newNumbers.length,
                  ),
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ],
            SizedBox(height: spacing.xl),
            BigButton(
              label: l10n.rearingDistributeSave,
              onPressed: apiaryId == null
                  ? null
                  : () =>
                        Navigator.of(context)
                            .pop((apiaryId: apiaryId, count: _count)),
            ),
          ],
        ),
      ),
    );
  }
}
