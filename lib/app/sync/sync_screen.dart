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

/// Senkron ayrıntısı: durum, gönderilmeyi bekleyen kayıtlar, son turun
/// sorunu, sunucunun reddettiği kayıtlar ve "Şimdi eşitle".
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
    final secondary = typography.body.copyWith(color: colors.textSecondary);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.syncTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: StatusBadge(
                status: syncIndicatorStatus(indicator),
                label: syncIndicatorLabel(l10n, indicator, pending: pending),
              ),
            ),
            SizedBox(height: spacing.md),
            if (pending > 0)
              Text(l10n.syncPendingMessage(pending), style: typography.body)
            else if (rejected.isEmpty)
              Text(l10n.syncSyncedMessage, style: typography.body),
            if (problem != null) ...[
              SizedBox(height: spacing.sm),
              Text(problem, style: typography.body),
            ],
            if (lastSyncedAt != null) ...[
              SizedBox(height: spacing.sm),
              Text(
                l10n.syncLastSynced(format.time(lastSyncedAt)),
                style: secondary,
              ),
            ],
            SizedBox(height: spacing.lg),
            BigButton(
              label: activity.running ? l10n.syncRunning : l10n.syncNow,
              icon: Icons.sync_rounded,
              onPressed: activity.running
                  ? null
                  : () => unawaited(
                      ref.read(syncControllerProvider.notifier).sync(),
                    ),
            ),
            if (rejected.isNotEmpty) ...[
              SizedBox(height: spacing.xl),
              Semantics(
                header: true,
                child: Text(
                  l10n.syncRejectedTitle(rejected.length),
                  style: typography.title,
                ),
              ),
              SizedBox(height: spacing.sm),
              Text(l10n.syncRejectedMessage, style: secondary),
              for (final record in rejected)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    AppStatus.critical.icon,
                    color: AppStatus.critical.colorIn(colors),
                  ),
                  title: Text(syncTableLabel(l10n, record.table)),
                  subtitle: Text(
                    l10n.syncRejectedSubtitle(
                      syncRejectionText(l10n, syncRejectionOf(record.error)),
                      format.dateTime(record.createdAt.toLocal()),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
