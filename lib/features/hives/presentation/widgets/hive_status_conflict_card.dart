import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_conflict.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Kovan durumu çakışması (teknik.md §3): iki kişinin birbirinden habersiz
/// kaydettiği iki durum, her biri kimin ve ne zaman kaydettiğiyle (kayıpta
/// nedeniyle). Kullanıcı doğru olana dokunur ve onaylar; öbür kayıt silinir,
/// kovan seçilen duruma geçer ve seçim senkronla ekibe ulaşır. Viewer
/// seçemez, yalnız görür.
class HiveStatusConflictCard extends ConsumerWidget {
  const new({required this.hive, required this.conflict, super.key});

  final Hive hive;
  final HiveStatusConflict conflict;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final userId = ref.watch(currentUserProvider.select((user) => user?.id));
    final emails = ref.watch(memberEmailsProvider).value ?? const {};
    final canWrite = ref.watch(canWriteRecordsProvider);

    String hint(HiveStatusEvent event) {
      final createdBy = event.createdBy;
      // Sunucuya henüz gitmemiş olay bu telefonda yazıldı.
      final who = createdBy == null || createdBy == userId
          ? l10n.hiveConflictByYou
          : emails[createdBy] ?? l10n.hiveConflictByOther;
      final date = format.dateTime(event.changedAt.toLocal());
      return event.toStatus.isLoss
          ? l10n.hiveConflictOptionHintReason(
              who,
              date,
              hiveLossReasonLabel(l10n, event.lossReason),
            )
          : l10n.hiveConflictOptionHint(who, date);
    }

    Future<void> keep(HiveStatusEvent kept, HiveStatusEvent discarded) async {
      final number = hive.number;
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.hiveConflictKeepTitle(number, kept.toStatus.label(l10n)),
        message: l10n.hiveConflictKeepMessage,
        confirmLabel: l10n.hiveConflictKeep,
      );
      if (!confirmed) return;
      await ref
          .read(hiveActionsProvider.notifier)
          .resolveStatusConflict(hive.id, discardEventId: discarded.id);
      if (context.mounted) {
        showMessageSnackBar(
          context,
          l10n.hiveStatusChanged(number, kept.toStatus.label(l10n)),
        );
      }
    }

    Widget option(HiveStatusEvent event, HiveStatusEvent other) {
      final status = event.toStatus.appStatus;
      return OptionTile(
        icon: status.icon,
        iconColor: status.colorIn(context.colors),
        label: event.toStatus.label(l10n),
        hint: hint(event),
        onTap: canWrite ? () => unawaited(keep(event, other)) : null,
      );
    }

    return AppCard(
      status: AppStatus.warning,
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.hiveLabel(hive.number), style: context.typography.label),
            Text(l10n.hiveConflictQuestion, style: context.typography.body),
            SizedBox(height: spacing.sm),
            option(conflict.first, conflict.second),
            option(conflict.second, conflict.first),
          ],
        ),
      ),
    );
  }
}
