import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
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

/// "Bugün", "Yarın" ya da gün adı ("Pazartesi").
String taskDayName(
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

/// Görevler tek kartta, aralarında çizgiyle. Kutuya dokunmak görevi
/// tamamlar (6 sn geri alınabilir), satıra dokunmak düzenler. Görevler ve
/// Bugün sekmeleri kullanır.
class TaskGroup extends ConsumerWidget {
  const new(
    this.tasks, {
    required this.now,
    super.key,
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
    final dueDay = taskDayName(l10n, format, localDay(task.dueAt), now: now);
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
