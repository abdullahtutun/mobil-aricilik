import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/task_list.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';
import 'package:mobil_arici/features/today/presentation/today_providers.dart';
import 'package:mobil_arici/features/today/presentation/widgets/attention_labels.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';
import 'package:mobil_arici/features/weather/presentation/widgets/weather_strip.dart';

/// Bugün paneli (teknik.md §9, docs/design "Bugün"): tarih ve selam, üst
/// barda senkron durumu; arılık hava kartları; "Dikkat isteyenler" (anasız,
/// zayıf, oğul eğilimli, ilacı çıkarılacak; dokununca filtreli liste) ve
/// bugünün görevleri arılığa göre. Kurulum bitmediyse adımları; hiç arılık
/// yoksa yalnız "İlk arılığını ekle". Hepsi yerel DB'deki mevcut veriden
/// birleşir; senkron yeni veri indirince kendiliğinden güncellenir.
class TodayScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  @override
  void initState() {
    super.initState();
    // Ekran saklanan paketi hemen gösterir; yenisi gelince kendiliğinden
    // güncellenir. İşletme açılışta sonradan yüklenebilir.
    ref.listenManual(currentOrgIdProvider, (_, orgId) {
      if (orgId != null) {
        unawaited(ref.read(weatherRefresherProvider).refreshIfStale());
      }
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final isDev = ref.watch(flavorProvider) == Flavor.dev;
    final setup = ref.watch(setupProgressProvider).value;
    final completed = setup?.completed ?? const <SetupStep>{};
    final hasApiary = completed.contains(SetupStep.apiary);

    final padded = EdgeInsets.symmetric(horizontal: spacing.lg);
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isDev)
            IconButton(
              icon: const Icon(Icons.developer_mode_rounded),
              tooltip: l10n.devMenuTitle,
              onPressed: () => context.go(AppRoutes.developerMenu),
            ),
          const SyncStatusButton(),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: spacing.xl),
        children: [
          Padding(padding: padded, child: const _Header()),
          SizedBox(height: spacing.lg),
          const WeatherStrip(),
          // Arılık DB'den hemen gelir; gelmeden boş durum yanıp sönmesin.
          if (setup != null && !hasApiary)
            EmptyState(
              icon: Icons.today_rounded,
              title: l10n.todayEmptyTitle,
              message: l10n.todayEmptyMessage,
              actionLabel: l10n.apiariesAddFirst,
              onAction: () => context.go(AppRoutes.apiaryNew),
            ),
          if (setup != null && completed.length < SetupStep.values.length) ...[
            SizedBox(height: spacing.lg),
            Padding(padding: padded, child: _SetupCard(setup)),
          ],
          if (hasApiary) ...[
            if (completed.contains(SetupStep.hives)) ...[
              SizedBox(height: spacing.xl),
              Padding(padding: padded, child: const _AttentionCard()),
            ],
            SizedBox(height: spacing.xl),
            Padding(padding: padded, child: const _TodayTasks()),
          ],
        ],
      ),
    );
  }
}

/// Gün adıyla tarih, altında günün saatine göre büyük selam.
class _Header extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = clock.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppFormat.of(context).weekdayDate(now),
          style: context.typography.subtitle.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Semantics(
          header: true,
          child: Text(switch (greetingAt(now)) {
            Greeting.morning => l10n.todayGreetingMorning,
            Greeting.afternoon => l10n.todayGreetingAfternoon,
            Greeting.evening => l10n.todayGreetingEvening,
          }, style: context.typography.headline),
        ),
      ],
    );
  }
}

/// Kurulum adımları: tamamlananlar onaylı, sıradaki adım dokunulabilir ve
/// ilgili ekranı açar.
class _SetupCard extends StatelessWidget {
  const new(this.setup);

  final SetupProgress setup;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final next = SetupStep.values
        .where((step) => !setup.completed.contains(step))
        .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          l10n.todaySetupProgress(
            setup.completed.length,
            SetupStep.values.length,
          ),
        ),
        SizedBox(height: spacing.sm),
        ListGroup(
          children: [
            for (final step in SetupStep.values)
              _SetupStepRow(
                label: switch (step) {
                  SetupStep.apiary => l10n.setupStepApiary,
                  SetupStep.hives => l10n.setupStepHives,
                  SetupStep.inspection => l10n.setupStepInspection,
                },
                done: setup.completed.contains(step),
                onTap: step == next ? _actionFor(context, step) : null,
              ),
          ],
        ),
      ],
    );
  }

  /// Adımın açacağı ekran; arılığı henüz yoksa null.
  VoidCallback? _actionFor(BuildContext context, SetupStep step) {
    final route = switch (step) {
      SetupStep.apiary => AppRoutes.apiaryNew,
      SetupStep.hives => switch (setup.firstApiaryId) {
        final id? => AppRoutes.hivesBulk(id),
        null => null,
      },
      SetupStep.inspection => switch (setup.hiveApiaryId) {
        final id? => AppRoutes.apiary(id),
        null => null,
      },
    };
    return route == null ? null : () => context.go(route);
  }
}

class _SetupStepRow extends StatelessWidget {
  const new({required this.label, required this.done, this.onTap});

  final String label;
  final bool done;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final onTap = this.onTap;

    // Satır tek düğüm: adım ve durumu birlikte okunur, dokunma eylemi kalır.
    return Semantics(
      container: true,
      button: onTap != null,
      label: done ? l10n.setupStepDone(label) : label,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            child: Row(
              children: [
                Icon(
                  done
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: context.sizes.icon,
                  color: done ? colors.statusGood : colors.textSecondary,
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: context.typography.body.copyWith(
                      color: done ? colors.textSecondary : null,
                    ),
                  ),
                ),
                if (onTap != null) ...[
                  SizedBox(width: spacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: context.sizes.icon,
                    color: colors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Dikkat isteyenler": başlık ve kaç ayrı kovan; altında 2×2 karo. Kovanı
/// olan karo durum renginde, ikonlu ve dokununca filtreli listeyi açar.
class _AttentionCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final groups = ref.watch(todayAttentionProvider).value;
    if (groups == null) return const SizedBox.shrink();
    final total = attentionHiveCount(groups);

    Widget tile(AttentionKind kind) =>
        _AttentionTile(kind: kind, count: groups[kind]?.length ?? 0);

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.todayAttentionTitle,
                      style: context.typography.title,
                    ),
                  ),
                ),
                if (total > 0)
                  Text(
                    l10n.todayAttentionHiveCount(total),
                    style: context.typography.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
              ],
            ),
            SizedBox(height: spacing.md),
            if (total == 0)
              StatusMessage(
                status: AppStatus.good,
                message: l10n.todayAttentionNone,
              )
            else
              for (final (i, row) in const [
                [AttentionKind.queenless, AttentionKind.weak],
                [AttentionKind.swarming, AttentionKind.treatmentRemoval],
              ].indexed) ...[
                if (i > 0) SizedBox(height: spacing.md),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: spacing.md,
                    children: [
                      for (final kind in row) Expanded(child: tile(kind)),
                    ],
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}

/// Büyük sayı ve altında ikonlu grup adı. Kovan yoksa nötr ve dokunulmaz.
class _AttentionTile extends StatelessWidget {
  const new({required this.kind, required this.count});

  final AttentionKind kind;
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final status = count > 0 ? kind.status : null;
    final color = status?.colorIn(colors) ?? colors.textSecondary;

    return MergeSemantics(
      child: AppCard(
        status: status,
        onTap: status == null
            ? null
            : () => context.go(AppRoutes.attention(kind)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  style: context.typography.numberLarge.copyWith(color: color),
                ),
                SizedBox(height: spacing.xs),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (status != null) ...[
                      Icon(
                        status.icon,
                        size: context.sizes.iconSmall,
                        color: color,
                      ),
                      SizedBox(width: spacing.xs),
                    ],
                    Flexible(
                      child: Text(
                        kind.label(l10n),
                        style: context.typography.subtitle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bugünün görevleri (gecikmişler dahil), arılığa göre; yoksa tek satır.
class _TodayTasks extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final tasks = ref.watch(todayTasksProvider).value ?? const <TaskView>[];
    final now = clock.now();
    final secondary = context.typography.bodySmall.copyWith(
      color: context.colors.textSecondary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l10n.todayTasksTitle,
                  style: context.typography.title,
                ),
              ),
            ),
            if (tasks.isNotEmpty)
              Text(l10n.todayTasksCount(tasks.length), style: secondary),
          ],
        ),
        SizedBox(height: spacing.md),
        if (tasks.isEmpty)
          Text(l10n.tasksEmptyTodayTitle, style: secondary)
        else
          for (final (i, group) in tasksByApiary(tasks).indexed) ...[
            if (i > 0) SizedBox(height: spacing.lg),
            SectionLabel(
              l10n.tasksApiaryGroup(
                group.apiaryName ?? l10n.tasksNoApiary,
                group.tasks.length,
              ),
            ),
            SizedBox(height: spacing.sm),
            TaskGroup(group.tasks, withApiary: false, now: now),
          ],
      ],
    );
  }
}
