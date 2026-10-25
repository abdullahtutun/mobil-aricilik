import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/haptics.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/task_labels.dart';

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
      padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.md),
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
              fixedSize: Size.square(context.touchTargets.fieldLarge),
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
      appBar: AppBar(actions: const [SyncStatusButton()]),
      body: Column(
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
          _TaskGroup(group.tasks, withApiary: false, withDue: true, now: now),
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
              _dayName(l10n, format, day, now: now),
              group.tasks.length,
            ),
          )
        else
          SectionLabel(
            l10n.tasksOverdue(group.tasks.length),
            status: AppStatus.critical,
          ),
        SizedBox(height: spacing.sm),
        _TaskGroup(group.tasks, now: now),
      ],
    ];
  }
}

/// "Bugün", "Yarın" ya da gün adı ("Pazartesi").
String _dayName(
  AppLocalizations l10n,
  AppFormat format,
  DateTime day, {
  required DateTime now,
}) {
  final today = localDay(now);
  if (day == today) return l10n.tasksToday;
  if (day == DateTime(today.year, today.month, today.day + 1)) {
    return l10n.tasksTomorrow;
  }
  return format.weekday(day);
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

/// Görevler tek kartta, aralarında çizgiyle.
class _TaskGroup extends ConsumerWidget {
  const new(
    this.tasks, {
    required this.now,
    this.withApiary = true,
    this.withDue = false,
  });

  final List<TaskView> tasks;
  final DateTime now;

  /// Bağlamda arılık adı (arılığa göre görünümde başlıkta zaten var).
  final bool withApiary;

  /// Bağlamda son tarih (gün gruplarında başlıkta zaten var).
  final bool withDue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final members = ref.watch(organizationMembersProvider).value ?? const [];
    final userId = ref.watch(currentUserIdProvider);
    return ListGroup(
      children: [
        for (final view in tasks)
          _TaskRow(
            view,
            members: members,
            userId: userId,
            withApiary: withApiary,
            withDue: withDue,
            now: now,
          ),
      ],
    );
  }
}

/// Solda tamamlama kutusu, ortada başlık ve bağlam ("Kızılçam · ilaç",
/// gecikmişte "5 gün gecikti"), sağda atanan kişinin rozeti.
class _TaskRow extends ConsumerWidget {
  const new(
    this.view, {
    required this.members,
    required this.userId,
    required this.withApiary,
    required this.withDue,
    required this.now,
  });

  final TaskView view;
  final List<Member> members;
  final String? userId;
  final bool withApiary;
  final bool withDue;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final task = view.task;
    final title = taskTitle(l10n, view);
    final overdue = overdueDays(task.dueAt, now: now);
    final assignee = assigneeOf(l10n, members, task.assignedTo, userId: userId);
    final dueDay = _dayName(l10n, format, localDay(task.dueAt), now: now);
    final details = [
      ...taskContext(l10n, view, withApiary: withApiary),
      if (withDue && overdue == 0)
        '$dueDay ${format.time(task.dueAt.toLocal())}',
    ];
    final secondary = context.typography.bodySmall.copyWith(
      color: colors.textSecondary,
    );

    return InkWell(
      onTap: () => context.go(AppRoutes.taskEdit(task.id)),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.touchTargets.button),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: spacing.xs,
            end: spacing.lg,
            top: spacing.sm,
            bottom: spacing.sm,
          ),
          child: Row(
            children: [
              SizedBox.square(
                dimension: context.touchTargets.button,
                child: Checkbox(
                  value: false,
                  semanticLabel: l10n.taskCompleteAction(title),
                  onChanged: (_) => _complete(context, ref),
                ),
              ),
              SizedBox(width: spacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.typography.subtitle),
                    if (overdue > 0)
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: context.sizes.iconSmall,
                            color: colors.statusCritical,
                          ),
                          SizedBox(width: spacing.xs),
                          Flexible(
                            child: Text(
                              [
                                ...details,
                                l10n.taskOverdueDays(overdue),
                              ].join(' · '),
                              style: secondary.copyWith(
                                color: colors.statusCritical,
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (details.isNotEmpty)
                      Text(details.join(' · '), style: secondary),
                  ],
                ),
              ),
              if (assignee != null) ...[
                SizedBox(width: spacing.md),
                _AssigneeBadge(assignee, me: assignee.userId == userId),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(taskActionsProvider.notifier);
    final done = await actions.complete(view.task);
    unawaited(AppHaptics.saved());
    if (!context.mounted) return;
    showUndoSnackBar(
      context,
      message: l10n.taskCompleted,
      onUndo: () => actions.reopen(done),
    );
  }
}

/// Atanan kişinin baş harfi dairede; kendim koyu yeşil, diğerleri bal
/// rengi zeminde. Ekran okuyucu "Atanan: Ben" okur.
class _AssigneeBadge extends StatelessWidget {
  const new(this.assignee, {required this.me});

  final TaskAssignee assignee;
  final bool me;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return Semantics(
      label: l10n.taskAssignedTo(assignee.label),
      excludeSemantics: true,
      child: Container(
        width: context.sizes.avatar,
        height: context.sizes.avatar,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: me ? colors.secondary : colors.primary,
        ),
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(context.spacing.xs),
            child: Text(
              assignee.badge,
              style: context.typography.label.copyWith(
                color: me ? colors.onSecondary : colors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
