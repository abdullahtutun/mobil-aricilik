import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';

/// İşletmenin arılıkları: ad, aktif kovan sayısı, son ziyaret. Liste yerel
/// DB'den gelir; senkron yeni veri yazınca kendiliğinden güncellenir.
class ApiariesScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final apiaries = ref.watch(apiaryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.tabApiaries),
        actions: const [SyncStatusButton()],
      ),
      floatingActionButton: (apiaries.value?.isNotEmpty ?? false)
          ? FloatingActionButton.extended(
              onPressed: () => context.go(AppRoutes.apiaryNew),
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.apiariesAdd),
            )
          : null,
      body: switch (apiaries) {
        AsyncData(value: []) => Center(
          child: SingleChildScrollView(
            child: EmptyState(
              icon: Icons.hive_rounded,
              title: l10n.apiariesEmptyTitle,
              message: l10n.apiariesEmptyMessage,
              actionLabel: l10n.apiariesAddFirst,
              onAction: () => context.go(AppRoutes.apiaryNew),
            ),
          ),
        ),
        AsyncData(:final value) => ListView.separated(
          // Son satır arılık ekle butonunun altında kalmasın.
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            context.touchTargets.fieldLarge + spacing.xl,
          ),
          itemCount: value.length,
          separatorBuilder: (context, _) => SizedBox(height: spacing.md),
          itemBuilder: (context, index) => _ApiaryListItem(value[index]),
        ),
        AsyncError() => Center(child: Text(l10n.apiariesLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _ApiaryListItem extends StatelessWidget {
  const new(this.summary);

  final ApiarySummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final lastVisit = summary.lastVisitAt;
    final visit = lastVisit == null
        ? l10n.apiaryNoVisit
        : l10n.apiaryLastVisit(AppFormat.of(context).date(lastVisit.toLocal()));

    return MergeSemantics(
      child: Material(
        color: colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.card),
          side: BorderSide(
            color: colors.divider,
            width: context.strokes.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go(AppRoutes.apiary(summary.apiary.id)),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: context.touchTargets.field),
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.apiary.name,
                          style: context.typography.subtitle,
                        ),
                        SizedBox(height: spacing.xs),
                        Text(
                          l10n.apiaryListSubtitle(
                            l10n.apiaryHiveCount(summary.activeHiveCount),
                            visit,
                          ),
                          style: context.typography.bodySmall.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: context.sizes.icon,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
