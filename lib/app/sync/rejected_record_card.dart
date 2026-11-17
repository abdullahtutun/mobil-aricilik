import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/app/sync/sync_messages.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_indicator.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/core/utils/app_format.dart';

/// Sunucunun reddettiği bir kayıt: türü ve adı, neden ve ne zaman, nedene
/// göre ne yapılabileceği; "Yeniden dene" ve "Geri al". Geri al onay
/// ister: bu telefondaki değişiklik silinir, kayıt sunucudaki hâline döner
/// (sunucuya hiç ulaşmadıysa bu telefondan da silinir). İki eylemden
/// sonra hemen bir senkron turu başlar.
class RejectedRecordCard extends ConsumerWidget {
  const new({required this.record, super.key});

  final RejectedRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final typography = context.typography;
    final colors = context.colors;
    final format = AppFormat.of(context);
    final rejection = syncRejectionOf(record.error);
    final type = syncTableLabel(l10n, record.table);
    final title = switch (record.label) {
      final label? => l10n.syncRejectedRecordTitle(type, label),
      null => type,
    };

    Future<void> retry() async {
      await ref
          .read(syncRepositoryProvider)
          .retryRejected(record.table, record.recordId);
      if (context.mounted) {
        showMessageSnackBar(context, l10n.syncRejectedRetrying);
      }
      unawaited(ref.read(syncControllerProvider.notifier).sync());
    }

    Future<void> discard() async {
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.syncRejectedDiscardTitle,
        message: l10n.syncRejectedDiscardMessage,
        confirmLabel: l10n.syncRejectedDiscard,
      );
      if (!confirmed) return;
      await ref
          .read(syncRepositoryProvider)
          .discardRejected(record.table, record.recordId);
      if (context.mounted) {
        showMessageSnackBar(context, l10n.syncRejectedDiscarded);
      }
      unawaited(ref.read(syncControllerProvider.notifier).sync());
    }

    return AppCard(
      status: AppStatus.critical,
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MergeSemantics(
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
                        Text(title, style: typography.label),
                        Text(
                          l10n.syncRejectedSubtitle(
                            syncRejectionText(l10n, rejection),
                            format.dateTime(record.createdAt.toLocal()),
                          ),
                          style: typography.bodySmall,
                        ),
                        SizedBox(height: spacing.xs),
                        Text(
                          syncRejectionHint(l10n, rejection),
                          style: typography.body,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
            Wrap(
              spacing: spacing.sm,
              runSpacing: spacing.sm,
              alignment: WrapAlignment.end,
              children: [
                BigButton(
                  variant: BigButtonVariant.secondary,
                  expanded: false,
                  icon: Icons.refresh_rounded,
                  label: l10n.syncRejectedRetry,
                  onPressed: () => unawaited(retry()),
                ),
                BigButton(
                  variant: BigButtonVariant.dangerOutlined,
                  expanded: false,
                  icon: Icons.undo_rounded,
                  label: l10n.syncRejectedDiscard,
                  onPressed: () => unawaited(discard()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
