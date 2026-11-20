import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/document_services_provider.dart';
import 'package:mobil_arici/core/services/share_service_provider.dart';
import 'package:mobil_arici/core/utils/csv.dart';
import 'package:mobil_arici/core/utils/xlsx.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_labels.dart';
import 'package:mobil_arici/features/export/data/export_repository.dart';
import 'package:mobil_arici/features/export/domain/document_archive.dart';
import 'package:mobil_arici/features/export/presentation/export_workbook.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'export_providers.g.dart';

@riverpod
ExportRepository exportRepository(Ref ref) =>
    ExportRepository(ref.watch(appDatabaseProvider));

/// "Verileri dışa aktar": işletmenin ana kayıtlarını tek Excel dosyasına
/// yazar ve sistemin paylaşma sayfasıyla telefondan çıkarır (Drive,
/// e-posta, WhatsApp, Dosyalar). İnternet gerekmez; dosya yerel DB'den
/// üretilir. Durum hazırlanıyor mu; sürerken yeni istek yok sayılır.
@riverpod
class DataExport extends _$DataExport {
  @override
  bool build() => false;

  /// Dosyayı [l10n] dilinde hazırlayıp paylaşır; [includeFinance] ise
  /// gelir/gider de girer (`canExportFinance`). İşletme yoksa bir şey
  /// yapmaz. Hata çağırana geçer.
  Future<void> export(
    AppLocalizations l10n, {
    required bool includeFinance,
  }) async {
    if (state) return;
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    state = true;
    try {
      final data = await ref
          .read(exportRepositoryProvider)
          .load(orgId, includeFinance: includeFinance);
      final bytes = encodeXlsx(exportSheets(data, l10n));
      final day = DateFormat('yyyy-MM-dd').format(clock.now());
      await ref
          .read(shareServiceProvider)
          .shareFile(
            bytes,
            filename: xlsxFileName(l10n.exportFileName(day)),
            mimeType: xlsxMimeType,
          );
    } finally {
      if (ref.mounted) state = false;
    }
  }
}

/// Bu telefonda belge dosyası yok; paylaşılacak bir şey olmadı.
class NoDocumentFilesException implements Exception {
  const new();
}

/// "Belge dosyalarını dışa aktar": belge kasasının bu telefondaki
/// dosyalarını tek ZIP'e yazar ([encodeDocumentArchive]) ve paylaşma
/// sayfasıyla çıkarır. Belge dosyaları sunucuya yüklenmediği için telefon
/// değişirken yedek budur. İnternet gerekmez. Durum hazırlanıyor mu;
/// sürerken yeni istek yok sayılır.
@riverpod
class DocumentExport extends _$DocumentExport {
  @override
  bool build() => false;

  /// Dosyası bu telefonda olan belgeler yoksa
  /// [NoDocumentFilesException] atar; diğer hatalar da çağırana geçer.
  /// İşletme yoksa bir şey yapmaz.
  Future<void> export(AppLocalizations l10n) async {
    if (state) return;
    final orgId = ref.read(currentOrgIdProvider);
    if (orgId == null) return;
    state = true;
    try {
      final store = ref.read(documentFileStoreProvider);
      final documents = await ref
          .read(documentRepositoryProvider)
          .listByOrg(orgId);
      final archived = <ArchivedDocument>[];
      for (final document in sortDocuments(documents)) {
        final file = await store.find(documentFileName(document.storagePath));
        if (file == null) continue;
        archived.add((
          document: document,
          typeLabel: documentTypeLabel(l10n, document),
          // Eşzamanlı okuma: widget testlerinin sahte zamanında da biter.
          bytes: file.readAsBytesSync(),
        ));
      }
      if (archived.isEmpty) throw const NoDocumentFilesException();
      final bytes = encodeDocumentArchive(archived, (
        indexName: l10n.exportDocumentsIndexFile,
        file: l10n.exportColFile,
        name: l10n.exportColName,
        type: l10n.exportColType,
        expires: l10n.exportColExpires,
        description: l10n.exportColDescription,
        csvSeparator: csvSeparatorFor(l10n.localeName),
      ));
      final day = DateFormat('yyyy-MM-dd').format(clock.now());
      await ref
          .read(shareServiceProvider)
          .shareFile(
            bytes,
            filename: '${l10n.exportDocumentsFileName(day)}.zip',
            mimeType: zipMimeType,
          );
    } finally {
      if (ref.mounted) state = false;
    }
  }
}
