import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_expiry_badge.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_labels.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Belge kasası (docs/design "Belge kasası"): üstte kaç belge olduğu ve
/// hepsinin internetsiz açılıp açılmadığı, belgeler süresi önce dolan
/// önce, altta bölgeye göre belge türü notu ve "Yol kontrolü" butonu.
/// Belgeye dokununca dosyası açılır. Viewer belge ekleyemez.
class DocumentsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.documentsTitle),
        actions: [
          if (canWrite)
            Padding(
              padding: EdgeInsetsDirectional.only(end: context.spacing.sm),
              child: _AddButton(
                onPressed: () => context.go(AppRoutes.documentNew),
              ),
            ),
        ],
      ),
      body: switch (ref.watch(documentsProvider)) {
        AsyncData(value: []) => EmptyState(
          icon: Icons.folder_copy_outlined,
          title: l10n.documentsEmptyTitle,
          message: l10n.documentsEmptyMessage,
          actionLabel: canWrite ? l10n.documentsAdd : null,
          onAction: canWrite ? () => context.go(AppRoutes.documentNew) : null,
          centered: true,
        ),
        AsyncData(value: final documents) => _DocumentList(documents),
        AsyncError() => Center(child: Text(l10n.documentsLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _DocumentList extends ConsumerWidget {
  const new(this.documents);

  final List<VaultDocument> documents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final presets = ref.watch(regionConfigProvider).features.trMigrationDocs;
    final local = ref.watch(documentLocalFilesProvider).value;
    final missing = local == null
        ? 0
        : documents.where((d) => !local.contains(d.storagePath)).length;

    return BottomActionLayout(
      separated: true,
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          if (local != null) ...[
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: missing == 0
                  ? StatusBadge(
                      status: AppStatus.good,
                      label: l10n.documentsSummaryOffline(documents.length),
                    )
                  : StatusBadge(
                      status: AppStatus.warning,
                      label: l10n.documentsSummaryMissing(
                        documents.length,
                        missing,
                      ),
                    ),
            ),
            SizedBox(height: spacing.lg),
          ],
          for (final document in documents) ...[
            _DocumentCard(document),
            SizedBox(height: spacing.md),
          ],
          SizedBox(height: spacing.sm),
          Text(
            presets
                ? l10n.documentsRegionNoteTr
                : l10n.documentsRegionNoteOther,
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
      action: BigButton(
        label: l10n.documentsRoadCheck,
        icon: Icons.badge_outlined,
        onPressed: () => context.go(AppRoutes.roadCheck),
      ),
    );
  }
}

/// Belge kartı: dosya türü karosu, ad ve açıklama, geçerlilik rozeti.
/// Süresi 30 gün içinde dolan ya da dolmuş belgenin kartı kritik tonda.
class _DocumentCard extends StatelessWidget {
  const new(this.document);

  final VaultDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final now = clock.now();
    final level = documentExpiry(document.expiresOn, now).level;
    final urgent =
        level == DocumentExpiryLevel.urgent ||
        level == DocumentExpiryLevel.expired;
    // Açıklama yoksa tür; ad türle aynıysa ikinci kez yazılmaz.
    final type = documentTypeLabel(l10n, document);
    final subtitle =
        document.description ?? (type == document.name ? '' : type);

    return MergeSemantics(
      child: AppCard(
        status: urgent ? AppStatus.critical : null,
        filled: false,
        onTap: () => context.go(AppRoutes.document(document.id)),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          // Dar ekranda ve büyük yazıda rozet en çok satırın %40'ı; kelime
          // alt satıra geçer.
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                _FileKindTile(document.fileKind),
                SizedBox(width: spacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(document.name, style: context.typography.subtitle),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: context.typography.body.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.md),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.4,
                  ),
                  child: DocumentExpiryBadge(document),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Belge ekle: soluk zeminde köşeli kare, birincil renkte "+"
/// (docs/design "Belge kasası").
class _AddButton extends StatelessWidget {
  const new({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.touchTargets.field;
    return IconButton(
      tooltip: AppLocalizations.of(context).documentsAdd,
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded),
      iconSize: context.sizes.icon,
      color: colors.primary,
      style: IconButton.styleFrom(
        backgroundColor: colors.surfaceContainer,
        fixedSize: Size.square(size),
        minimumSize: Size.square(size),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.card),
        ),
      ),
    );
  }
}

/// Dosya türü karosu: soluk zeminde altta "PDF" ya da "FOTO".
class _FileKindTile extends StatelessWidget {
  const new(this.kind);

  final DocumentFileKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.sizes.mediaThumbnail;
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(context.radii.button),
          border: Border.all(
            color: colors.divider,
            width: context.strokes.border,
          ),
        ),
        child: Align(
          alignment: AlignmentDirectional.bottomStart,
          child: Padding(
            padding: EdgeInsets.all(context.spacing.sm),
            child: Text(
              documentFileKindLabel(AppLocalizations.of(context), kind),
              style: context.typography.labelSmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
