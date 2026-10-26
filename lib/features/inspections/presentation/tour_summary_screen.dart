import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';
import 'package:mobil_arici/features/inspections/domain/tour_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_providers.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/tour_labels.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/task_labels.dart';

/// Tur sonu özeti (docs/design "Tur özeti"): kaç kovan muayene edildi,
/// kaçı atlandı ve süre; anasız / zayıf / oğul eğilimli / güçlü-orta
/// sayıları; önerilen görevler (onay kutulu) ve turda muayeneden açılan
/// "tekrar bak" görevleri. "Görevleri kaydet" işaretlileri yazar ve turu
/// kapatır; geri tuşu görev yazmadan kapatır.
class TourSummaryScreen extends ConsumerStatefulWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  ConsumerState<TourSummaryScreen> createState() => _TourSummaryScreenState();
}

class _TourSummaryScreenState extends ConsumerState<TourSummaryScreen> {
  /// İşareti kaldırılan öneriler.
  final _unchecked = <TourTaskKind>{};
  var _closing = false;

  // Kapatırken tur silinir; ekran gidene kadar son hâli gösterilsin.
  TourProgress? _progress;
  TourSummary? _summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apiaryId = widget.apiaryId;
    final progress = ref.watch(apiaryTourProvider(apiaryId));
    final summary = ref.watch(apiaryTourSummaryProvider(apiaryId));
    if (!_closing) {
      _progress = progress.value;
      _summary = summary.value;
    }

    return switch ((_progress, _summary)) {
      (final progress?, final summary?) => PopScope(
        onPopInvokedWithResult: (didPop, _) {
          if (didPop && !_closing) unawaited(_close());
        },
        child: _buildSummary(context, progress, summary),
      ),
      _ when progress.isLoading || summary.isLoading => Scaffold(
        appBar: AppBar(),
      ),
      _ => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.tourNotFound)),
      ),
    };
  }

  Widget _buildSummary(
    BuildContext context,
    TourProgress progress,
    TourSummary summary,
  ) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final tour = progress.tour;
    final now = clock.now();
    final apiaryName = ref
        .watch(apiarySummaryProvider(widget.apiaryId))
        .value
        ?.apiary
        .name;
    final suggestions = tourTaskSuggestions(summary, now: now);
    final reminders =
        ref.watch(tourReminderTasksProvider(widget.apiaryId)).value ??
        const <Task>[];
    final numbers = {
      for (final entry in progress.entries) entry.hive.id: entry.hive.number,
    };
    final selected = [
      for (final suggestion in suggestions)
        if (!_unchecked.contains(suggestion.kind)) suggestion,
    ];

    Widget tile(int count, String label, AppStatus status) => CountTile(
      count: count,
      label: label,
      status: count > 0 ? status : null,
    );

    return Scaffold(
      appBar: AppBar(),
      body: BottomActionLayout(
        separated: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.statusGoodContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Icon(
                      Icons.check_rounded,
                      size: context.sizes.illustrationIcon,
                      color: colors.statusGood,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacing.lg),
              Semantics(
                header: true,
                child: Text(
                  l10n.tourCompleteTitle,
                  textAlign: TextAlign.center,
                  style: context.typography.headline,
                ),
              ),
              SizedBox(height: spacing.sm),
              Text(
                [
                  ?apiaryName,
                  l10n.tourInspectedCount(summary.inspected.length),
                  if (summary.skipped.isNotEmpty)
                    l10n.tourSkippedCount(summary.skipped.length),
                  tourDuration(
                    l10n,
                    (tour.finishedAt ?? now).difference(tour.startedAt),
                  ),
                ].join(l10n.titleSeparator),
                textAlign: TextAlign.center,
                style: context.typography.body.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(height: spacing.xl),
              for (final (i, row) in [
                [
                  tile(
                    summary.queenless.length,
                    l10n.attentionQueenless,
                    AppStatus.critical,
                  ),
                  tile(
                    summary.weak.length,
                    l10n.attentionWeak,
                    AppStatus.warning,
                  ),
                ],
                [
                  tile(
                    summary.swarming.length,
                    l10n.attentionSwarming,
                    AppStatus.warning,
                  ),
                  tile(
                    summary.healthy.length,
                    l10n.tourHealthy,
                    AppStatus.good,
                  ),
                ],
              ].indexed) ...[
                if (i > 0) SizedBox(height: spacing.md),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: spacing.md,
                    children: [for (final tile in row) Expanded(child: tile)],
                  ),
                ),
              ],
              SizedBox(height: spacing.xl),
              Semantics(
                header: true,
                child: Text(
                  l10n.tourTasksTitle,
                  style: context.typography.title,
                ),
              ),
              SizedBox(height: spacing.md),
              if (suggestions.isEmpty && reminders.isEmpty)
                Text(
                  l10n.tourNoTasks,
                  style: context.typography.body.copyWith(
                    color: colors.textSecondary,
                  ),
                )
              else
                ListGroup(
                  children: [
                    for (final suggestion in suggestions)
                      CheckboxListTile(
                        value: !_unchecked.contains(suggestion.kind),
                        onChanged: _closing
                            ? null
                            : (checked) => setState(
                                () => (checked ?? false)
                                    ? _unchecked.remove(suggestion.kind)
                                    : _unchecked.add(suggestion.kind),
                              ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: spacing.md,
                        ),
                        title: Text(
                          tourTaskTitle(l10n, suggestion),
                          style: context.typography.body,
                        ),
                        subtitle: Text(
                          l10n.tourTaskDue(
                            daysUntil(suggestion.dueAt, now: now),
                          ),
                        ),
                      ),
                    for (final task in reminders)
                      ListRow(
                        title: autoTaskTitle(
                          l10n,
                          task.source,
                          hiveNumber: numbers[task.hiveId],
                        ),
                        subtitle: taskSourceLabel(l10n, task.source),
                        value: l10n.tourTaskDue(
                          daysUntil(task.dueAt, now: now),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
        action: BigButton(
          label: l10n.tourSaveTasks(selected.length),
          onPressed: _closing ? null : () => _save(tour, selected),
        ),
      ),
    );
  }

  /// İşaretli önerileri görev olarak yazar, turu kapatır ve arılığa döner.
  Future<void> _save(ApiaryTour tour, List<TourTaskSuggestion> selected) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _closing = true);
    await ref.read(tourActionsProvider.notifier).saveTasks(tour, [
      for (final suggestion in selected)
        (
          title: tourTaskTitle(l10n, suggestion),
          dueAt: suggestion.dueAt,
          // Tek kovanlık görev kovana bağlanır.
          hiveId: suggestion.hives.length == 1
              ? suggestion.hives.single.id
              : null,
        ),
    ]);
    if (!mounted) return;
    if (selected.isNotEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.tourTasksSaved(selected.length))),
        );
    }
    context.go(AppRoutes.apiary(widget.apiaryId));
  }

  Future<void> _close() async {
    _closing = true;
    await ref.read(tourActionsProvider.notifier).close();
  }
}
