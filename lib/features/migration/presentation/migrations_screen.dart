import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/migration/presentation/widgets/migration_labels.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Göç planları, yeni yıl önce; plana dokununca zaman çizelgesi açılır.
/// Viewer plan ekleyemez.
class MigrationsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.migrationsTitle),
        actions: [
          if (canWrite)
            IconButton(
              tooltip: l10n.migrationsAdd,
              icon: const Icon(Icons.add_rounded),
              onPressed: () => context.go(AppRoutes.migrationNew),
            ),
        ],
      ),
      body: switch (ref.watch(migrationsProvider)) {
        AsyncData(value: []) => EmptyState(
          icon: Icons.local_shipping_outlined,
          title: l10n.migrationsEmptyTitle,
          message: l10n.migrationsEmptyMessage,
          actionLabel: canWrite ? l10n.migrationsAdd : null,
          onAction: canWrite ? () => context.go(AppRoutes.migrationNew) : null,
          centered: true,
        ),
        AsyncData(value: final migrations) => ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [
            ListGroup(
              children: [
                for (final migration in migrations) _MigrationRow(migration),
              ],
            ),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.migrationsLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _MigrationRow extends ConsumerWidget {
  const new(this.migration);

  final Migration migration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stops = ref.watch(migrationStopsProvider(migration.id)).value;
    return ListRow(
      title: migrationTitle(l10n, migration),
      value: stops == null ? null : l10n.migrationStopCount(stops.length),
      onTap: () => context.go(AppRoutes.migration(migration.id)),
    );
  }
}
