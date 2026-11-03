import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area_rules.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';

/// Offline haritalar (docs/design "Offline harita indir", il yerine arılık
/// çevresi): indirilmiş arılık çevreleri (boyut, indirme günü, sil), süren
/// indirmeler (yüzde, çubuk, inen / tahmini MB, durdur), "Sadece Wi‑Fi'da
/// indir" ve indirilecek konumlu arılıklar (bağlı göç durağı, taşınmışsa
/// uyarı, tahmini boyut). Her şey bu telefondan; liste için internet
/// gerekmez.
class OfflineMapsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final installed =
        ref.watch(installedMapAreasProvider).value ??
        const <InstalledMapArea>[];
    final downloads = ref.watch(mapAreaDownloadsProvider);
    final candidates = ref.watch(mapAreaCandidateListProvider);
    final waiting = [
      for (final candidate in candidates.value ?? const <MapAreaCandidate>[])
        if (!downloads.containsKey(candidate.area.id)) candidate,
    ];
    final gap = SizedBox(height: spacing.md);
    final sectionGap = SizedBox(height: spacing.xl);
    final secondary = context.typography.bodySmall.copyWith(
      color: context.colors.textSecondary,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.offlineMapsTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          Text(
            l10n.offlineMapsIntro,
            style: context.typography.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(l10n.offlineMapsCoverage, style: secondary),
          for (final row in installed)
            if (!downloads.containsKey(row.area.id)) ...[
              gap,
              _InstalledCard(installed: row),
            ],
          for (final progress in downloads.values) ...[
            gap,
            _DownloadCard(progress: progress),
          ],
          gap,
          const ListGroup(children: [_WifiOnlyTile()]),
          if (candidates case AsyncData(:final value)) ...[
            sectionGap,
            if (value.isEmpty && installed.isEmpty)
              NoteCard(
                icon: Icons.location_off_rounded,
                message: l10n.offlineMapsNoApiaries,
              )
            else if (waiting.isEmpty && downloads.isEmpty)
              NoteCard(
                icon: Icons.check_circle_rounded,
                message: l10n.offlineMapsAllDownloaded,
              )
            else if (waiting.isNotEmpty) ...[
              SectionLabel(l10n.offlineMapsToDownload),
              SizedBox(height: spacing.sm),
              ListGroup(
                children: [
                  for (final candidate in waiting)
                    _AreaRow(
                      candidate: candidate,
                      onDownload: () =>
                          unawaited(_download(context, ref, candidate.area)),
                    ),
                ],
              ),
            ],
          ],
          sectionGap,
          Text(l10n.offlineMapsAttribution, style: secondary),
        ],
      ),
    );
  }

  /// [area]'yı indirir; sonucu alttan bildirimle söyler. Satır indirme
  /// başlayınca listeden kalktığı için bildirim ekranın kendisinden.
  static Future<void> _download(
    BuildContext context,
    WidgetRef ref,
    MapArea area,
  ) async {
    final l10n = AppLocalizations.of(context);
    final outcome = await ref
        .read(mapAreaDownloadsProvider.notifier)
        .start(area);
    if (!context.mounted) return;
    final message = switch (outcome) {
      MapAreaDownloadOutcome.done => l10n.offlineMapsDone(area.name),
      MapAreaDownloadOutcome.needsWifi => l10n.offlineMapsNeedsWifi,
      MapAreaDownloadOutcome.failed => l10n.offlineMapsFailed(area.name),
      MapAreaDownloadOutcome.cancelled => null,
    };
    if (message != null) showMessageSnackBar(context, message);
  }
}

/// "84 MB".
String _megabytes(BuildContext context, int bytes) =>
    AppLocalizations.of(context)
        .offlineMapsMegabytes(AppFormat.of(context).megabytes(bytes));

/// İndirilmiş arılık çevresi: ad, "İndirildi · 3,2 MB" rozeti, indirme
/// günü; çöp kutusu onay ister.
class _InstalledCard extends ConsumerWidget {
  const new({required this.installed});

  final InstalledMapArea installed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final name = installed.area.name;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.fromLTRB(spacing.lg, spacing.md, 0, spacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: context.typography.title),
                  SizedBox(height: spacing.xs),
                  StatusBadge(
                    status: AppStatus.good,
                    label: l10n.offlineMapsDownloaded(
                      _megabytes(context, installed.bytes),
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    l10n.offlineMapsDownloadedOn(
                      AppFormat.of(context).date(installed.downloadedAt),
                    ),
                    style: context.typography.bodySmall.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.offlineMapsDelete(name),
              icon: const Icon(Icons.delete_outline_rounded),
              iconSize: context.sizes.icon,
              constraints: BoxConstraints.tight(
                Size.square(context.touchTargets.field),
              ),
              onPressed: () => _confirmDelete(context, ref, name),
            ),
            SizedBox(width: spacing.sm),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.offlineMapsDeleteTitle(name),
      message: l10n.offlineMapsDeleteMessage,
      confirmLabel: l10n.offlineMapsDeleteConfirm,
    );
    if (!confirmed) return;
    await ref
        .read(installedMapAreasProvider.notifier)
        .remove(installed.area.id);
  }
}

/// Süren indirme: ad ve yüzde (karoya göre), çubuk, "Wi‑Fi ile
/// indiriliyor · 1,2 / ≈ 3,9 MB" ve durdur.
class _DownloadCard extends ConsumerWidget {
  const new({required this.progress});

  final MapAreaProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final wifiOnly = ref.watch(mapWifiOnlyProvider).value ?? true;
    final ratio = progress.total == 0
        ? 0.0
        : (progress.done / progress.total).clamp(0.0, 1.0);
    final received = format.megabytes(progress.bytes);
    final total = l10n.offlineMapsApproxSize(
      _megabytes(context, estimateTileBytes(mapAreaTiles(progress.area))),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radii.card),
        border: Border.all(color: colors.primary, width: context.strokes.focus),
        color: colors.tile,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(spacing.lg, spacing.md, 0, spacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          progress.area.name,
                          style: context.typography.title,
                        ),
                      ),
                      Text(
                        format.percent(ratio),
                        style: context.typography.title,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.radii.pill),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: spacing.md,
                      color: colors.primary,
                      backgroundColor: colors.divider,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    wifiOnly
                        ? l10n.offlineMapsDownloadingWifi(received, total)
                        : l10n.offlineMapsDownloading(received, total),
                    style: context.typography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.offlineMapsCancel,
              icon: const Icon(Icons.close_rounded),
              iconSize: context.sizes.icon,
              constraints: BoxConstraints.tight(
                Size.square(context.touchTargets.field),
              ),
              onPressed: () => ref
                  .read(mapAreaDownloadsProvider.notifier)
                  .cancel(progress.area.id),
            ),
            SizedBox(width: spacing.sm),
          ],
        ),
      ),
    );
  }
}

/// İndirilecek arılık: ad; bağlı göç durağı ya da taşındı uyarısı ve
/// tahmini boyut; sağda indir butonu.
class _AreaRow extends StatelessWidget {
  const new({required this.candidate, required this.onDownload});

  final MapAreaCandidate candidate;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final area = candidate.area;
    final size = l10n.offlineMapsApproxSize(
      _megabytes(context, estimateTileBytes(mapAreaTiles(area))),
    );
    final buttonSize = context.touchTargets.button;

    return ListRow(
      title: area.name,
      subtitle: [
        if (candidate.moved) l10n.offlineMapsMoved,
        for (final stop in candidate.stopNames) l10n.offlineMapsStop(stop),
        size,
      ].join(' · '),
      trailing: IconButton(
        tooltip: l10n.offlineMapsDownload(area.name),
        icon: const Icon(Icons.download_rounded),
        iconSize: context.sizes.icon,
        style: IconButton.styleFrom(
          fixedSize: Size.square(buttonSize),
          minimumSize: Size.square(buttonSize),
          backgroundColor: colors.surfaceContainer,
          foregroundColor: colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.radii.button),
          ),
        ),
        onPressed: onDownload,
      ),
    );
  }
}

/// "Sadece Wi‑Fi'da indir"; varsayılan açık.
class _WifiOnlyTile extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final wifiOnly = ref.watch(mapWifiOnlyProvider).value ?? true;

    return SwitchListTile(
      value: wifiOnly,
      onChanged: (enabled) => ref
          .read(localSettingsRepositoryProvider)
          .setMapWifiOnly(enabled: enabled),
      contentPadding: EdgeInsets.symmetric(horizontal: context.spacing.lg),
      title: Text(l10n.offlineMapsWifiOnly, style: context.typography.body),
      subtitle: Text(
        l10n.offlineMapsWifiOnlyHint,
        style: context.typography.bodySmall.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}
