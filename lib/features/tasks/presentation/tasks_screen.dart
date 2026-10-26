import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/task_list.dart';

/// Görevler sekmesinin görünümleri.
enum TasksView { today, week, apiary }

/// Görevler (docs/design "Görevler"): büyük başlık ve yanında görev ekle;
/// Bugün / Bu hafta / Arılığa göre. Bugün ve Bu hafta önce gecikmişleri,
/// sonra günleri gösterir; Bu hafta'da üstte bugünden başlayan gün şeridi
/// (görevi olan günde nokta). Arılığa göre tarih sınırı olmadan arılık
/// arılık. Kutuya dokunmak görevi tamamlar (6 sn geri alınabilir), satıra
/// dokunmak düzenler. Liste yerel DB'den gelir; senkron yeni görev
/// indirince kendiliğinden güncellenir.
class TasksScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TasksView _view = TasksView.today;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final tasks = ref.watch(openTasksProvider);

    final header = Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(l10n.tabTasks, style: context.typography.headline),
            ),
          ),
          IconButton.filled(
            tooltip: l10n.tasksAdd,
            onPressed: () => context.go(AppRoutes.taskNew),
            icon: const Icon(Icons.add_rounded),
            style: IconButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
              fixedSize: Size.square(context.touchTargets.field),
              iconSize: context.sizes.icon,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.radii.card),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Expanded(
              child: switch (tasks) {
                AsyncData(value: []) => EmptyState(
                  icon: Icons.assignment_rounded,
                  title: l10n.tasksEmptyTitle,
                  message: l10n.tasksEmptyMessage,
                  actionLabel: l10n.tasksAdd,
                  onAction: () => context.go(AppRoutes.taskNew),
                  centered: true,
                ),
                AsyncData(:final value) => ListView(
                  padding: EdgeInsets.fromLTRB(
                    spacing.lg,
                    0,
                    spacing.lg,
                    spacing.lg,
                  ),
                  children: [
                    SegmentedTabs<TasksView>(
                      expanded: true,
                      options: [
                        SegmentOption(
                          value: TasksView.today,
                          label: l10n.tasksTabToday,
                        ),
                        SegmentOption(
                          value: TasksView.week,
                          label: l10n.tasksTabWeek,
                        ),
                        SegmentOption(
                          value: TasksView.apiary,
                          label: l10n.tasksTabApiary,
                        ),
                      ],
                      selected: _view,
                      onChanged: (view) => setState(() => _view = view),
                    ),
                    SizedBox(height: spacing.lg),
                    ..._content(context, value),
                  ],
                ),
                AsyncError() => Center(child: Text(l10n.tasksLoadError)),
                // Yerel DB'den okunuyor; hemen gelir.
                AsyncValue() => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, List<TaskView> tasks) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final now = clock.now();

    if (_view == TasksView.apiary) {
      return [
        for (final (i, group) in tasksByApiary(tasks).indexed) ...[
          if (i > 0) SizedBox(height: spacing.xl),
          SectionLabel(
            l10n.tasksApiaryGroup(
              group.apiaryName ?? l10n.tasksNoApiary,
              group.tasks.length,
            ),
          ),
          SizedBox(height: spacing.sm),
          TaskGroup(group.tasks, withApiary: false, withDue: true, now: now),
        ],
      ];
    }

    final days = _view == TasksView.today ? 1 : taskWeekDays;
    final groups = tasksByDay(tasks, now: now, days: days);
    return [
      if (_view == TasksView.week) ...[
        _WeekStrip(tasks, now: now),
        SizedBox(height: spacing.lg),
      ],
      if (groups.isEmpty)
        EmptyState(
          icon: Icons.event_available_rounded,
          title: _view == TasksView.today
              ? l10n.tasksEmptyTodayTitle
              : l10n.tasksEmptyWeekTitle,
          message: l10n.tasksEmptyAddHint,
        ),
      for (final (i, group) in groups.indexed) ...[
        if (i > 0) SizedBox(height: spacing.xl),
        if (group.day case final day?)
          SectionLabel(
            l10n.tasksDayGroup(
              taskDayName(l10n, format, day, now: now),
              group.tasks.length,
            ),
          )
        else
          SectionLabel(
            l10n.tasksOverdue(group.tasks.length),
            status: AppStatus.critical,
          ),
        SizedBox(height: spacing.sm),
        TaskGroup(group.tasks, now: now),
      ],
    ];
  }
}

/// Bugünden başlayan 7 gün: kısa gün adı ve ayın günü; bugün dolu zeminde,
/// görevi olan günün altında nokta.
class _WeekStrip extends StatelessWidget {
  const new(this.tasks, {required this.now});

  final List<TaskView> tasks;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final today = localDay(now);
    final counts = <DateTime, int>{};
    for (final group in tasksByDay(tasks, now: now, days: taskWeekDays)) {
      if (group.day case final day?) counts[day] = group.tasks.length;
    }

    return Row(
      children: [
        for (var offset = 0; offset < taskWeekDays; offset++)
          Expanded(
            child: Builder(
              builder: (context) {
                final day = DateTime(
                  today.year,
                  today.month,
                  today.day + offset,
                );
                final isToday = offset == 0;
                final count = counts[day] ?? 0;
                final foreground = isToday
                    ? colors.onPrimary
                    : colors.textPrimary;
                return Semantics(
                  label: l10n.tasksWeekDaySemantics(
                    '${format.weekday(day)} ${format.dayOfMonth(day)}',
                    count,
                  ),
                  excludeSemantics: true,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: spacing.sm),
                    decoration: BoxDecoration(
                      color: isToday ? colors.primary : null,
                      borderRadius: BorderRadius.circular(context.radii.card),
                    ),
                    child: Column(
                      children: [
                        Text(
                          format.weekdayShort(day),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: context.typography.labelSmall.copyWith(
                            color: foreground,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            format.dayOfMonth(day),
                            style: context.typography.subtitle.copyWith(
                              color: foreground,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.xs),
                        Container(
                          width: context.sizes.dayDot,
                          height: context.sizes.dayDot,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: count == 0
                                ? null
                                : isToday
                                ? colors.onPrimary
                                : colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
