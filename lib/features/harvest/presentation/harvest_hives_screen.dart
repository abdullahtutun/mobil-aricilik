import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_form_controller.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_providers.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/health/presentation/widgets/withdrawal_lock_dialog.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';

/// Hasada alınacak kovanlar: arılığın aktif kovanları onay kutusuyla.
/// Bekleme süresindeki kovan kritik rozetle görünür; seçilince kilit
/// diyaloğu açılır ve ancak gerekçeyle alınır. "Tümünü seç" kilitli
/// kovanları seçmez. Seçim hasat formunda tutulur.
class HarvestHivesScreen extends ConsumerWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final provider = harvestFormControllerProvider(apiaryId);
    final form = ref.watch(provider).value;
    final hives = [
      for (final hive
          in ref.watch(apiaryHivesProvider(apiaryId)).value ?? const <Hive>[])
        if (canInspect(hive)) hive,
    ];
    if (form == null) return Scaffold(appBar: AppBar());
    final locks =
        ref.watch(harvestLocksProvider(apiaryId, form.day)).value ?? const {};
    final controller = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.harvestHivesTitle)),
      body: hives.isEmpty
          ? EmptyState(
              icon: Icons.hive_outlined,
              title: l10n.hivesEmptyTitle,
              message: l10n.harvestNoActiveHives,
              centered: true,
            )
          : BottomActionLayout(
              separated: true,
              body: ListView(
                padding: EdgeInsets.all(spacing.lg),
                children: [
                  Wrap(
                    spacing: spacing.sm,
                    children: [
                      TextButton(
                        onPressed: () => controller.selectAll([
                          for (final hive in hives)
                            if (!locks.containsKey(hive.id)) hive,
                        ]),
                        child: Text(l10n.harvestSelectAll),
                      ),
                      TextButton(
                        onPressed: controller.clearSelection,
                        child: Text(l10n.harvestSelectNone),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.sm),
                  ListGroup(
                    children: [
                      for (final hive in hives)
                        _HiveRow(
                          hive: hive,
                          form: form,
                          lockDays: locks[hive.id]?.daysLeft,
                          onChanged: (selected) => selected
                              ? selectForHarvest(
                                  context,
                                  ref,
                                  apiaryId: apiaryId,
                                  hive: hive,
                                )
                              : controller.deselect(hive.id),
                        ),
                    ],
                  ),
                ],
              ),
              action: BigButton(
                label: l10n.harvestHivesDone,
                onPressed: () => context.pop(),
              ),
            ),
    );
  }
}

/// [hive]'ı hasat seçimine ekler. Hasat gününde bekleme süresindeyse kilit
/// diyaloğu açılır; gerekçe seçilirse gerekçesiyle eklenir, vazgeçilirse
/// eklenmez. Eklendiyse true.
Future<bool> selectForHarvest(
  BuildContext context,
  WidgetRef ref, {
  required String apiaryId,
  required Hive hive,
}) async {
  final provider = harvestFormControllerProvider(apiaryId);
  final form = ref.read(provider).value;
  if (form == null) return false;
  final locks = await ref.read(harvestLocksProvider(apiaryId, form.day).future);
  final lock = locks[hive.id];
  if (lock == null) {
    ref.read(provider.notifier).select(hive.id);
    return true;
  }
  if (!context.mounted) return false;
  final reason = await showWithdrawalLockDialog(
    context,
    hiveNumber: hive.number,
    lock: lock,
    action: WithdrawalLockedAction.harvest,
  );
  if (reason == null || !context.mounted) return false;
  ref
      .read(provider.notifier)
      .select(
        hive.id,
        withdrawalOverride: WithdrawalOverride(
          treatmentId: lock.treatment.id,
          reason: reason,
        ),
      );
  return true;
}

class _HiveRow extends StatelessWidget {
  const new({
    required this.hive,
    required this.form,
    required this.lockDays,
    required this.onChanged,
  });

  final Hive hive;
  final HarvestFormState form;

  /// Bekleme süresinde kalan gün; kilitsizse null.
  final int? lockDays;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lockDays = this.lockDays;
    final override = form.overrides[hive.id];
    final harvested =
        form.selected.contains(hive.id) &&
        (lockDays == null || override != null);

    return CheckboxListTile(
      value: harvested,
      onChanged: (value) => onChanged(value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.symmetric(horizontal: context.spacing.md),
      title: Text(l10n.hiveLabel(hive.number), style: context.typography.label),
      subtitle: lockDays == null
          ? null
          : Align(
              alignment: AlignmentDirectional.centerStart,
              child: override != null && harvested
                  ? StatusBadge(
                      status: AppStatus.warning,
                      label: l10n.harvestHiveOverridden(
                        override.reason.harvestLabel(l10n),
                      ),
                    )
                  : StatusBadge(
                      status: AppStatus.critical,
                      label: l10n.harvestHiveLocked(lockDays),
                    ),
            ),
    );
  }
}
