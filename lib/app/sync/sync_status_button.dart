import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_messages.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/sync/sync_controller.dart';
import 'package:mobil_arici/core/sync/sync_indicator.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';

/// Bugün'ün başlığındaki senkron hapı (teknik.md §3): eşitlendi, X
/// bekliyor ya da hata. Bulut ikonu, renk ve kelime birlikte; dokununca
/// senkron ekranı açılır.
class SyncStatusButton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pending = ref.watch(syncPendingCountProvider).value ?? 0;
    final indicator = syncIndicatorOf(
      pending: pending,
      rejected: ref.watch(syncRejectedProvider).value?.length ?? 0,
      lastStatus: ref.watch(
        syncControllerProvider.select(
          (activity) => activity.lastResult?.status,
        ),
      ),
    );
    final label = syncIndicatorLabel(l10n, indicator, pending: pending);

    final color = syncIndicatorStatus(indicator).colorIn(context.colors);
    return OutlinedButton.icon(
      onPressed: () => context.push(AppRoutes.sync),
      style: OutlinedButton.styleFrom(
        backgroundColor: context.colors.tile,
        foregroundColor: color,
        side: BorderSide(
          color: context.colors.divider,
          width: context.strokes.focus,
        ),
        shape: const StadiumBorder(),
        textStyle: context.typography.label,
        padding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
      ),
      icon: Icon(syncIndicatorIcon(indicator), color: color),
      // Tek satır; sığmazsa sonu kesilir, alt satıra kaymaz.
      label: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        semanticsLabel: l10n.syncStatusSemantics(label),
      ),
    );
  }
}
