import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/app/sync/sync_messages.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_indicator.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/utils/app_format.dart';

/// Senkron ayrıntısı: üstte durum kartı (ikon, durum, son eşitleme,
/// bekleyenler ya da turun sorunu), altında sunucunun reddettiği kayıtlar;
/// en altta sabit "Şimdi eşitle".
class SyncScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final format = AppFormat.of(context);

    final pending = ref.watch(syncPendingCountProvider).value ?? 0;
    final rejected = ref.watch(syncRejectedProvider).value ?? const [];
    final activity = ref.watch(syncControllerProvider);
    final lastResult = activity.lastResult;
    final lastSyncedAt = activity.lastSyncedAt;
    final problem = lastResult == null
        ? null
        : syncProblemText(l10n, lastResult.status);
    final indicator = syncIndicatorOf(
      pending: pending,
      rejected: rejected.length,
      lastStatus: lastResult?.status,
    );
    final status = syncIndicatorStatus(indicator);
    final secondary = typography.body.copyWith(color: colors.textSecondary);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncTitle)),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            AppCard(
              child: Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        SizedBox.square(
                          dimension: context.touchTargets.fieldLarge,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: status.containerIn(colors),
                            ),
                            child: Icon(
                              syncIndicatorIcon(indicator),
                              size: context.sizes.icon,
                              color: status.colorIn(colors),
                            ),
                          ),
                        ),
                        SizedBox(width: spacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Semantics(
                                header: true,
                                child: Text(
                                  syncIndicatorLabel(
                                    l10n,
                                    indicator,
                                    pending: pending,
                                  ),
                                  style: typography.title,
                                ),
                              ),
                              if (lastSyncedAt != null)
                                Text(
                                  l10n.syncLastSynced(
                                    format.time(lastSyncedAt),
                                  ),
                                  style: secondary,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.md),
                    if (pending > 0)
                      Text(
                        l10n.syncPendingMessage(pending),
                        style: typography.body,
                      )
                    else if (rejected.isEmpty)
                      Text(l10n.syncSyncedMessage, style: typography.body),
                    if (problem != null) ...[
                      SizedBox(height: spacing.sm),
                      Text(problem, style: typography.body),
                    ],
                  ],
                ),
              ),
            ),
            if (rejected.isNotEmpty) ...[
              SizedBox(height: spacing.xl),
              SectionLabel(
                l10n.syncRejectedTitle(rejected.length),
                status: AppStatus.critical,
              ),
              SizedBox(height: spacing.sm),
              Text(l10n.syncRejectedMessage, style: secondary),
              SizedBox(height: spacing.md),
              for (final record in rejected) ...[
                MergeSemantics(
                  child: AppCard(
                    status: AppStatus.critical,
                    child: Padding(
                      padding: EdgeInsets.all(spacing.lg),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            AppStatus.critical.icon,
                            size: context.sizes.icon,
                            color: AppStatus.critical.colorIn(colors),
                          ),
                          SizedBox(width: spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  syncTableLabel(l10n, record.table),
                                  style: typography.label,
                                ),
                                Text(
                                  l10n.syncRejectedSubtitle(
                                    syncRejectionText(
                                      l10n,
                                      syncRejectionOf(record.error),
                                    ),
                                    format.dateTime(record.createdAt.toLocal()),
                                  ),
                                  style: typography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: spacing.sm),
              ],
            ],
          ],
        ),
        action: BigButton(
          variant: BigButtonVariant.secondary,
          label: activity.running ? l10n.syncRunning : l10n.syncNow,
          onPressed: activity.running
              ? null
              : () =>
                    unawaited(ref.read(syncControllerProvider.notifier).sync()),
        ),
      ),
    );
  }
}
