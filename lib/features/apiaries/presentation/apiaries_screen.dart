import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/relative_date.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';

/// İşletmenin arılıkları: büyük başlık ve yanında arılık ekle; altında
/// toplam arılık ve kovan; her arılık bir kartta (ad, son ziyaret, sağda
/// büyük aktif kovan sayısı). Liste yerel DB'den gelir; senkron yeni veri
/// yazınca kendiliğinden güncellenir.
class ApiariesScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final apiaries = ref.watch(apiaryListProvider);

    final hasApiaries = apiaries.value?.isNotEmpty ?? false;
    final header = Padding(
      padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.md),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(l10n.tabApiaries, style: context.typography.headline),
            ),
          ),
          // Boşken boş durumun kendi butonu var.
          if (hasApiaries)
            IconButton.filled(
              tooltip: l10n.apiariesAdd,
              onPressed: () => context.go(AppRoutes.apiaryNew),
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
                fixedSize: Size.square(context.touchTargets.fieldLarge),
                iconSize: context.sizes.icon,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.radii.card),
                ),
              ),
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(actions: const [SyncStatusButton()]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Expanded(
            child: switch (apiaries) {
              AsyncData(value: []) => EmptyState(
                icon: Icons.add_rounded,
                title: l10n.apiariesEmptyTitle,
                message: l10n.apiariesEmptyMessage,
                actionLabel: l10n.apiariesAddFirst,
                onAction: () => context.go(AppRoutes.apiaryNew),
                centered: true,
              ),
              AsyncData(:final value) => ListView(
                padding: EdgeInsets.fromLTRB(
                  spacing.lg,
                  0,
                  spacing.lg,
                  spacing.lg,
                ),
                children: [
                  Text(
                    l10n.apiariesSummary(
                      l10n.apiariesCount(value.length),
                      l10n.apiaryHiveCount(
                        value.fold(
                          0,
                          (sum, item) => sum + item.activeHiveCount,
                        ),
                      ),
                    ),
                    style: context.typography.body.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  for (final (i, summary) in value.indexed) ...[
                    if (i > 0) SizedBox(height: spacing.md),
                    _ApiaryListItem(summary),
                  ],
                ],
              ),
              AsyncError() => Center(child: Text(l10n.apiariesLoadError)),
              // Yerel DB'den okunuyor; hemen gelir.
              AsyncValue() => const SizedBox.shrink(),
            },
          ),
        ],
      ),
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
        : l10n.apiaryLastVisit(
            relativeDay(
              l10n,
              AppFormat.of(context),
              lastVisit,
              now: clock.now(),
            ),
          );
    final count = summary.activeHiveCount;

    return MergeSemantics(
      child: AppCard(
        onTap: () => context.go(AppRoutes.apiary(summary.apiary.id)),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(summary.apiary.name, style: context.typography.title),
                    SizedBox(height: spacing.xs),
                    Text(
                      visit,
                      style: context.typography.body.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.md),
              // Sayı büyük, birimi altında; ekran okuyucu "40 kovan" okur.
              Semantics(
                label: l10n.apiaryHiveCount(count),
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppFormat.of(context).number(count),
                      style: context.typography.number,
                    ),
                    Text(
                      l10n.apiaryHiveCountUnit,
                      style: context.typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
