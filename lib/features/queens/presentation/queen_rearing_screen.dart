import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/presentation/queen_rearing_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Ana yetiştirme serileri, son aktarılan önce; seriye dokununca takvimi
/// açılır. Viewer seri ekleyemez.
class QueenRearingScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.rearingTitle),
        actions: [
          if (canWrite)
            IconButton(
              tooltip: l10n.rearingAdd,
              icon: const Icon(Icons.add_rounded),
              onPressed: () => context.go(AppRoutes.rearingNew),
            ),
        ],
      ),
      body: switch (ref.watch(rearingBatchesProvider)) {
        AsyncData(value: []) => EmptyState(
          icon: Icons.egg_outlined,
          title: l10n.rearingEmptyTitle,
          message: l10n.rearingEmptyMessage,
          actionLabel: canWrite ? l10n.rearingAdd : null,
          onAction: canWrite ? () => context.go(AppRoutes.rearingNew) : null,
          centered: true,
        ),
        AsyncData(value: final batches) => ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [
            ListGroup(
              children: [for (final batch in batches) _BatchRow(batch)],
            ),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.rearingLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _BatchRow extends StatelessWidget {
  const new(this.batch);

  final QueenRearingBatch batch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    return ListRow(
      title: l10n.rearingBatchName(batch.number),
      subtitle: l10n.rearingListGrafted(format.date(batch.graftedOn)),
      value: '${batch.graftedCount}',
      onTap: () => context.go(AppRoutes.rearingBatch(batch.id)),
    );
  }
}
