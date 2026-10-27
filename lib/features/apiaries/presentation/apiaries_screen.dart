import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/basemap_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/relative_date.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_map.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/today/presentation/today_providers.dart';

/// Arılıklar sekmesinin görünümü.
enum _ApiariesView { list, map }

/// İşletmenin arılıkları: büyük başlık ve yanında arılık ekle; altında
/// Liste / Harita seçici. Listede toplam arılık ve kovan, her arılık bir
/// kartta (ad, son ziyaret, sağda büyük aktif kovan sayısı). Haritada
/// konumlu arılıklar pin olarak; internet yoksa haritanın yerine mesaj ve
/// liste. Arılıklar yerel DB'den gelir; senkron yeni veri yazınca
/// kendiliğinden güncellenir.
class ApiariesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ApiariesScreen> createState() => _ApiariesScreenState();
}

class _ApiariesScreenState extends ConsumerState<ApiariesScreen> {
  _ApiariesView _view = _ApiariesView.list;

  void _select(_ApiariesView view) {
    // Haritaya her geçişte, önceki deneme başarısızsa altlık yeniden
    // denenir; internet arada gelmiş olabilir.
    if (view == _ApiariesView.map && ref.read(basemapProvider).hasError) {
      ref.invalidate(basemapProvider);
    }
    setState(() => _view = view);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final apiaries = ref.watch(apiaryListProvider);
    final canWrite = ref.watch(canWriteRecordsProvider);

    final hasApiaries = apiaries.value?.isNotEmpty ?? false;
    final header = Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(l10n.tabApiaries, style: context.typography.headline),
            ),
          ),
          // Boşken boş durumun kendi butonu var.
          if (hasApiaries && canWrite)
            IconButton.filled(
              tooltip: l10n.apiariesAdd,
              onPressed: () => context.go(AppRoutes.apiaryNew),
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
                fixedSize: Size.square(context.touchTargets.field),
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
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            if (hasApiaries)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.lg,
                  0,
                  spacing.lg,
                  spacing.md,
                ),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SegmentedTabs(
                    options: [
                      SegmentOption(
                        value: _ApiariesView.list,
                        label: l10n.apiariesViewList,
                      ),
                      SegmentOption(
                        value: _ApiariesView.map,
                        label: l10n.apiariesViewMap,
                      ),
                    ],
                    selected: _view,
                    onChanged: _select,
                  ),
                ),
              ),
            Expanded(
              child: switch (apiaries) {
                AsyncData(value: []) => EmptyState(
                  icon: Icons.add_rounded,
                  title: l10n.apiariesEmptyTitle,
                  message: l10n.apiariesEmptyMessage,
                  actionLabel: canWrite ? l10n.apiariesAddFirst : null,
                  onAction: canWrite
                      ? () => context.go(AppRoutes.apiaryNew)
                      : null,
                  centered: true,
                ),
                AsyncData(:final value) => switch (_view) {
                  _ApiariesView.list => _ApiaryList(value),
                  _ApiariesView.map => _ApiaryMapView(value),
                },
                AsyncError() => Center(child: Text(l10n.apiariesLoadError)),
                // Yerel DB'den okunuyor; hemen gelir.
                AsyncValue() => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Haritanın altlığı yüklenince harita; yüklenemezse (internet yok) mesaj,
/// Tekrar dene ve liste.
class _ApiaryMapView extends ConsumerWidget {
  const new(this.summaries);

  final List<ApiarySummary> summaries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final attention = ref.watch(apiaryAttentionCountsProvider).value;

    return switch (ref.watch(basemapProvider)) {
      AsyncValue(isLoading: true) => const Center(
        child: CircularProgressIndicator(),
      ),
      AsyncData(:final value) => ApiaryMap(
        basemap: value,
        summaries: summaries,
        attentionCounts: attention ?? const {},
      ),
      AsyncValue() => _ApiaryList(
        summaries,
        leading: [
          NoteCard(
            icon: Icons.cloud_off_rounded,
            title: l10n.apiariesMapOfflineTitle,
            message: l10n.apiariesMapOfflineMessage,
            child: BigButton(
              label: l10n.actionRetry,
              icon: Icons.refresh_rounded,
              variant: BigButtonVariant.secondary,
              onPressed: () => ref.invalidate(basemapProvider),
            ),
          ),
          SizedBox(height: spacing.lg),
        ],
      ),
    };
  }
}

/// Toplam arılık ve kovan, altında arılık kartları; [leading] en üstte.
class _ApiaryList extends StatelessWidget {
  const new(this.summaries, {this.leading = const []});

  final List<ApiarySummary> summaries;
  final List<Widget> leading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return ListView(
      padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.lg),
      children: [
        ...leading,
        Text(
          l10n.apiariesSummary(
            l10n.apiariesCount(summaries.length),
            l10n.apiaryHiveCount(
              summaries.fold(0, (sum, item) => sum + item.activeHiveCount),
            ),
          ),
          style: context.typography.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.md),
        for (final (i, summary) in summaries.indexed) ...[
          if (i > 0) SizedBox(height: spacing.md),
          _ApiaryListItem(summary),
        ],
      ],
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
