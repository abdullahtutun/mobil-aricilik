import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack_rules.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';

/// Offline haritalar (docs/design "Offline harita indir"): indirilmiş
/// bölgeler (boyut, içindeki arılıklar, verinin tarihi, sil), süren
/// indirmeler (yüzde, çubuk, inen / toplam MB, durdur), "Sadece Wi‑Fi'da
/// indir", katalogtan önerilen bölgeler (arılıkların ve geçmişte kalmamış
/// göç duraklarının içinde kalan) ve geri kalan bölgeler, tahmini boyutla.
/// Katalog internet ister; indirilmiş bölgeler internetsiz de listelenir.
class OfflineMapsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final installed =
        ref.watch(installedMapPacksProvider).value ??
        const <InstalledMapPack>[];
    final downloads = ref.watch(mapPackDownloadsProvider);
    final catalog = ref.watch(mapPackCatalogProvider);
    final suggestions =
        ref.watch(mapPackSuggestionsProvider).value ??
        const <MapPackSuggestion>[];
    final apiaries = [
      for (final summary
          in ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[])
        if (summary.apiary case Apiary(:final latitude?, :final longitude?))
          (latitude: latitude, longitude: longitude),
    ];

    final installedIds = {for (final row in installed) row.pack.id};
    final suggestedIds = {for (final s in suggestions) s.pack.id};
    final catalogPacks = catalog.value?.packs ?? const <MapPack>[];
    final downloading = [
      for (final pack in catalogPacks)
        if (downloads.containsKey(pack.id)) pack,
    ];
    final others = [
      for (final pack in catalogPacks)
        if (!installedIds.contains(pack.id) &&
            !suggestedIds.contains(pack.id) &&
            !downloads.containsKey(pack.id))
          pack,
    ];
    final gap = SizedBox(height: spacing.md);
    final sectionGap = SizedBox(height: spacing.xl);
    final labelGap = SizedBox(height: spacing.sm);

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
          for (final row in installed) ...[
            gap,
            _InstalledCard(
              installed: row,
              apiaryCount: apiaryCountInPack(row.pack, apiaries),
            ),
          ],
          for (final pack in downloading) ...[
            gap,
            _DownloadCard(pack: pack, received: downloads[pack.id] ?? 0),
          ],
          gap,
          const ListGroup(children: [_WifiOnlyTile()]),
          ...switch (catalog) {
            AsyncData(:final value) => [
              if (suggestions.isNotEmpty) ...[
                sectionGap,
                SectionLabel(l10n.offlineMapsSuggested),
                labelGap,
                ListGroup(
                  children: [
                    for (final suggestion in suggestions)
                      if (!downloads.containsKey(suggestion.pack.id))
                        _PackRow(
                          pack: suggestion.pack,
                          reason: _reason(l10n, suggestion),
                          onDownload: () => unawaited(
                            _download(context, ref, suggestion.pack, value),
                          ),
                        ),
                  ],
                ),
              ],
              if (others.isNotEmpty) ...[
                sectionGap,
                SectionLabel(l10n.offlineMapsAll),
                labelGap,
                ListGroup(
                  children: [
                    for (final pack in others)
                      _PackRow(
                        pack: pack,
                        onDownload: () =>
                            unawaited(_download(context, ref, pack, value)),
                      ),
                  ],
                ),
              ],
              if (value.packs.isEmpty) ...[
                sectionGap,
                NoteCard(
                  icon: Icons.map_outlined,
                  message: l10n.offlineMapsCatalogEmpty,
                ),
              ],
            ],
            AsyncError() => [
              sectionGap,
              NoteCard(
                icon: Icons.cloud_off_rounded,
                title: l10n.offlineMapsCatalogErrorTitle,
                message: l10n.offlineMapsCatalogErrorMessage,
                child: BigButton(
                  label: l10n.actionRetry,
                  icon: Icons.refresh_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => ref.invalidate(mapPackCatalogProvider),
                ),
              ),
            ],
            AsyncValue() => [
              sectionGap,
              const Center(child: CircularProgressIndicator()),
            ],
          },
          sectionGap,
          Text(
            l10n.offlineMapsAttribution,
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// [pack]'i indirir; sonucu alttan bildirimle söyler. Satır indirme
  /// başlayınca listeden kalktığı için bildirim ekranın kendisinden.
  static Future<void> _download(
    BuildContext context,
    WidgetRef ref,
    MapPack pack,
    MapPackCatalog catalog,
  ) async {
    final l10n = AppLocalizations.of(context);
    final name = mapPackName(
      pack,
      Localizations.localeOf(context).languageCode,
    );
    final outcome = await ref
        .read(mapPackDownloadsProvider.notifier)
        .start(pack, catalog);
    if (!context.mounted) return;
    final message = switch (outcome) {
      MapPackDownloadOutcome.done => l10n.offlineMapsDone(name),
      MapPackDownloadOutcome.needsWifi => l10n.offlineMapsNeedsWifi,
      MapPackDownloadOutcome.failed => l10n.offlineMapsFailed(name),
      MapPackDownloadOutcome.cancelled => null,
    };
    if (message != null) showMessageSnackBar(context, message);
  }

  /// "3 arılık · Narenciye durağı".
  static String _reason(AppLocalizations l10n, MapPackSuggestion suggestion) =>
      [
        if (suggestion.apiaryCount > 0)
          l10n.apiariesCount(suggestion.apiaryCount),
        for (final stop in suggestion.stopNames) l10n.offlineMapsStop(stop),
      ].join(' · ');
}

/// "84 MB".
String _megabytes(BuildContext context, int bytes) =>
    AppLocalizations.of(context)
        .offlineMapsMegabytes(AppFormat.of(context).megabytes(bytes));

/// İndirilmiş bölge: ad, "İndirildi · 84 MB" rozeti, içindeki arılıklar ve
/// verinin tarihi; çöp kutusu onay ister.
class _InstalledCard extends ConsumerWidget {
  const new({required this.installed, required this.apiaryCount});

  final InstalledMapPack installed;
  final int apiaryCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final name = mapPackName(
      installed.pack,
      Localizations.localeOf(context).languageCode,
    );
    final details = [
      if (apiaryCount > 0) l10n.apiariesCount(apiaryCount),
      l10n.offlineMapsUpdated(
        AppFormat.of(context).monthYear(installed.generatedAt),
      ),
    ].join(' · ');

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
                      _megabytes(context, installed.pack.bytes),
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    details,
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
        .read(installedMapPacksProvider.notifier)
        .remove(installed.pack.id);
  }
}

/// Süren indirme: ad ve yüzde, çubuk, "Wi‑Fi ile indiriliyor · 41 / 66 MB"
/// ve durdur.
class _DownloadCard extends ConsumerWidget {
  const new({required this.pack, required this.received});

  final MapPack pack;
  final int received;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final wifiOnly = ref.watch(mapWifiOnlyProvider).value ?? true;
    final ratio = pack.bytes == 0 ? 0.0 : (received / pack.bytes).clamp(0, 1);
    final sizes = (
      received: format.megabytes(received),
      total: _megabytes(context, pack.bytes),
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
                          mapPackName(
                            pack,
                            Localizations.localeOf(context).languageCode,
                          ),
                          style: context.typography.title,
                        ),
                      ),
                      Text(
                        format.percent(ratio.toDouble()),
                        style: context.typography.title,
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.radii.pill),
                    child: LinearProgressIndicator(
                      value: ratio.toDouble(),
                      minHeight: spacing.md,
                      color: colors.primary,
                      backgroundColor: colors.divider,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    wifiOnly
                        ? l10n.offlineMapsDownloadingWifi(
                            sizes.received,
                            sizes.total,
                          )
                        : l10n.offlineMapsDownloading(
                            sizes.received,
                            sizes.total,
                          ),
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
              onPressed: () =>
                  ref.read(mapPackDownloadsProvider.notifier).cancel(pack.id),
            ),
            SizedBox(width: spacing.sm),
          ],
        ),
      ),
    );
  }
}

/// İndirilebilir bölge: ad, neden önerildiği ve tahmini boyut; sağda
/// indir butonu.
class _PackRow extends StatelessWidget {
  const new({required this.pack, required this.onDownload, this.reason});

  final MapPack pack;
  final VoidCallback onDownload;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final name = mapPackName(
      pack,
      Localizations.localeOf(context).languageCode,
    );
    final size = l10n.offlineMapsApproxSize(_megabytes(context, pack.bytes));
    final buttonSize = context.touchTargets.button;

    return ListRow(
      title: name,
      subtitle: [?reason, size].join(' · '),
      trailing: IconButton(
        tooltip: l10n.offlineMapsDownload(name),
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
