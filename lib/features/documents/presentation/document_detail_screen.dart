import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_expiry_badge.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_file_view.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_labels.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Belge: türü, açıklaması, geçerlilik durumu ve dosyası (internetsiz).
/// Yazabilen üye için üst çubukta Düzenle.
class DocumentDetailScreen extends ConsumerWidget {
  const new({required this.documentId, super.key});

  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);

    return switch (ref.watch(documentProvider(documentId))) {
      AsyncData(value: final document?) => Scaffold(
        appBar: AppBar(
          title: Text(document.name),
          actions: [
            if (canWrite)
              TextButton(
                onPressed: () =>
                    context.go(AppRoutes.documentEdit(document.id)),
                child: Text(l10n.documentEdit),
              ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DocumentInfo(document),
              Expanded(child: DocumentFileView(document)),
            ],
          ),
        ),
      ),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.documentNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

/// Türü, açıklaması, geçerlilik rozeti ve son günü.
class _DocumentInfo extends StatelessWidget {
  const new(this.document);

  final VaultDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final secondary = context.typography.body.copyWith(
      color: context.colors.textSecondary,
    );
    final expiresOn = document.expiresOn;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing.xs,
        children: [
          Text(documentTypeLabel(l10n, document), style: secondary),
          if (document.description case final description?)
            Text(description, style: context.typography.body),
          SizedBox(height: spacing.xs),
          Wrap(
            spacing: spacing.md,
            runSpacing: spacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DocumentExpiryBadge(document),
              if (expiresOn != null)
                Text(
                  l10n.documentExpiresOn(format.date(expiresOn)),
                  style: secondary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
