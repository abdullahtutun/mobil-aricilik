import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_sheets.dart';

/// Kovan kartı: büyük numara, arılık, durum rozeti ve ana arı şeridi;
/// altında taşıma ve durum değiştirme. Özet kartları, zaman tüneli ve
/// Muayene başlat kendi adımlarında gelecek.
///
/// [apiaryId] yoldaki arılık (geri tuşu oraya döner); gösterilen arılık
/// kovanın kendi arılığıdır.
class HiveCardScreen extends ConsumerWidget {
  const new({required this.apiaryId, required this.hiveId, super.key});

  final String apiaryId;
  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return switch (ref.watch(hiveProvider(hiveId))) {
      AsyncData(value: final hive?) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: l10n.hiveEdit,
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => context.go(AppRoutes.hiveEdit(apiaryId, hiveId)),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            _Header(hive),
            SizedBox(height: spacing.lg),
            const _QueenStrip(),
            SizedBox(height: spacing.xl),
            BigButton(
              variant: BigButtonVariant.secondary,
              label: l10n.hiveMove,
              icon: Icons.local_shipping_rounded,
              onPressed: () => _move(context, ref, hive),
            ),
            SizedBox(height: context.touchTargets.gap),
            BigButton(
              variant: BigButtonVariant.secondary,
              label: l10n.hiveChangeStatus,
              icon: Icons.swap_horiz_rounded,
              onPressed: () => _changeStatus(context, ref, hive),
            ),
          ],
        ),
      ),
      AsyncData() => Scaffold(appBar: AppBar(), body: const HiveNotFound()),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }

  /// Arılık seçilince hemen taşır; Geri al kovanı eski arılığına döndürür.
  Future<void> _move(BuildContext context, WidgetRef ref, Hive hive) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(hiveActionsProvider.notifier);
    final target = await showHiveMoveSheet(context, hive);
    if (target == null) return;
    final move = await actions.move(hive.id, apiaryId: target.id);
    if (move == null || !context.mounted) return;
    showUndoSnackBar(
      context,
      message: l10n.hiveMoved(hive.number, target.name),
      onUndo: () => actions.undoMove(move),
    );
  }

  /// Aktif kovan sayısını düşüren durum önce onay ister; öbürleri hemen
  /// yazılır ve geri alınabilir.
  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    Hive hive,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(hiveActionsProvider.notifier);
    final status = await showHiveStatusSheet(context, hive);
    if (status == null || !context.mounted) return;

    if (statusChangeNeedsConfirmation(from: hive.status, to: status)) {
      final confirmed = await confirmHiveStatusChange(
        context,
        number: hive.number,
        status: status,
      );
      if (confirmed) await actions.setStatus(hive.id, status);
      return;
    }

    final previous = hive.status;
    await actions.setStatus(hive.id, status);
    if (!context.mounted) return;
    showUndoSnackBar(
      context,
      message: l10n.hiveStatusChanged(hive.number, status.label(l10n)),
      onUndo: () => actions.setStatus(hive.id, previous),
    );
  }
}

class _Header extends ConsumerWidget {
  const new(this.hive);

  final Hive hive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final apiaryName = ref
        .watch(apiarySummaryProvider(hive.apiaryId))
        .value
        ?.apiary
        .name;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          label: l10n.hiveLabel(hive.number),
          excludeSemantics: true,
          // Uzun numara ve büyük yazı boyutunda kırılmasın, küçülsün.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              hive.number,
              maxLines: 1,
              style: context.typography.numberLarge,
            ),
          ),
        ),
        if (apiaryName != null) ...[
          SizedBox(height: spacing.xs),
          Semantics(
            label: l10n.hiveCardApiary(apiaryName),
            excludeSemantics: true,
            child: Row(
              children: [
                Icon(
                  Icons.place_rounded,
                  size: context.sizes.iconSmall,
                  color: colors.textSecondary,
                ),
                SizedBox(width: spacing.xs),
                Expanded(
                  child: Text(
                    apiaryName,
                    style: context.typography.subtitle.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: spacing.md),
        StatusBadge(
          status: hive.status.appStatus,
          label: hive.status.label(l10n),
        ),
      ],
    );
  }
}

/// Ana arı şeridi; ana arı kartı gelene kadar yer tutucu. Boş renk noktası
/// karodaki yerini gösterir.
class _QueenStrip extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return SectionCard(
      title: l10n.hiveQueenTitle,
      child: Row(
        children: [
          SizedBox.square(
            dimension: context.sizes.queenDot,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.outline,
                  width: context.strokes.border,
                ),
              ),
            ),
          ),
          SizedBox(width: context.spacing.md),
          Expanded(
            child: Text(
              l10n.hiveQueenPlaceholder,
              style: context.typography.body.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
