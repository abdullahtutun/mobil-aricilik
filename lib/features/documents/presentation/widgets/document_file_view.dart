import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';

/// Belgenin dosyası, bu telefondaki kopyadan (internet gerekmez): foto
/// yakınlaştırılabilir, PDF'in sayfaları alt alta. Dosya henüz inmediyse
/// nedeni yazar. Bulunduğu alanı doldurur.
class DocumentFileView extends ConsumerWidget {
  const new(this.document, {super.key});

  final VaultDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final path = document.storagePath;
    return switch (ref.watch(documentFileProvider(path))) {
      AsyncData(value: final file?) => switch (document.fileKind) {
        DocumentFileKind.photo => InteractiveViewer(
          maxScale: 5,
          child: Center(
            child: Semantics(
              image: true,
              label: document.name,
              child: Image.file(file, fit: BoxFit.contain),
            ),
          ),
        ),
        DocumentFileKind.pdf => _PdfPages(document),
      },
      AsyncData() => _Message(l10n.documentFileMissing),
      AsyncError() => _Message(l10n.documentFileMissing),
      AsyncValue() => const SizedBox.expand(),
    };
  }
}

class _PdfPages extends ConsumerWidget {
  const new(this.document);

  final VaultDocument document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    return switch (ref.watch(documentPdfPagesProvider(document.storagePath))) {
      AsyncData(value: final pages?) => InteractiveViewer(
        maxScale: 5,
        child: ListView.separated(
          padding: EdgeInsets.all(spacing.sm),
          itemCount: pages.length,
          separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
          itemBuilder: (context, index) => Semantics(
            image: true,
            label: l10n.documentPdfPage(index + 1, pages.length),
            child: Image.memory(pages[index], fit: BoxFit.contain),
          ),
        ),
      ),
      AsyncData() => _Message(l10n.documentFileMissing),
      AsyncError() => _Message(l10n.documentPdfFailed),
      AsyncValue() => const Center(child: CircularProgressIndicator()),
    };
  }
}

class _Message extends StatelessWidget {
  const new(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(context.spacing.xl),
      child: NoteCard(icon: Icons.cloud_download_outlined, message: message),
    ),
  );
}
