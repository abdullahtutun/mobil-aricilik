import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/export/presentation/export_providers.dart';

/// "Belge dosyalarını dışa aktar · ZIP": belge kasasının bu telefondaki
/// dosyaları; dosyalar sunucuya yüklenmediği için telefon değişirken yedek.
/// Ayarlar'da ve hesap silmenin "önce verini al" adımında.
class DocumentExportRow extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final busy = ref.watch(documentExportProvider);

    Future<void> export() async {
      try {
        await ref.read(documentExportProvider.notifier).export(l10n);
      } on NoDocumentFilesException {
        if (context.mounted) {
          showMessageSnackBar(context, l10n.exportDocumentsNone);
        }
      } on Object {
        if (context.mounted) showMessageSnackBar(context, l10n.exportFailed);
      }
    }

    return ListRow(
      title: l10n.settingsExportDocuments,
      subtitle: l10n.settingsExportDocumentsHint,
      value: busy ? l10n.exportPreparing : l10n.settingsExportDocumentsValue,
      onTap: busy ? null : () => unawaited(export()),
    );
  }
}
