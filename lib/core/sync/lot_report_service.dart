import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/core/sync/storage_file_sync.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/harvest/data/lot_report_api.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';

/// Yayımdaki lotların analiz raporlarını lot sayfasına yükler. Belge
/// dosyaları telefonda kalır (2026-11-20); lot sayfası raporu yalnız bu
/// yolla alır. Dosyası bu telefonda olmayan rapor atlanır: belgeyi ekleyen
/// telefon yükler.
///
/// Her lot için önce sunucuya hangi raporu istediği sorulur; yalnız
/// sunucuda olmayan rapor gönderilir. Aynı anda tek tur çalışır.
///
/// Uygulamada tek örnek `lotReportServiceProvider`'dan gelir.
class LotReportService {
  new(this._lots, this._documents, this._files, this._api);

  final LotRepository _lots;
  final DocumentRepository _documents;
  final MediaFileStore _files;
  final LotReportApi _api;

  Future<FileSyncResult>? _running;

  /// [orgId]'nin yayımdaki lotlarından raporu sunucuda olmayanların
  /// raporunu yükler. Bağlantı ya da sunucu hatasında tur durur
  /// (`retryLater`); 409 (telefonun satırları geride) ve diğer hatalarda
  /// lot atlanır, sonraki turda yeniden denenir.
  Future<FileSyncResult> uploadReports(String orgId) =>
      _running ??= _upload(orgId).whenComplete(() => _running = null);

  Future<FileSyncResult> _upload(String orgId) async {
    var done = 0;
    var failed = 0;
    for (final lot in await _lots.listPublishedWithReport(orgId)) {
      try {
        final status = await _api.status(lot.id);
        final documentId = status.documentId;
        if (documentId == null || status.uploaded) continue;
        final document = await _documents.findById(documentId);
        if (document == null) continue;
        final name = documentFileName(document.storagePath);
        final file = await _files.find(name);
        // Dosya başka telefonda.
        if (file == null) continue;
        await _api.upload(
          lotId: lot.id,
          documentId: documentId,
          bytes: await file.readAsBytes(),
          fileName: name,
        );
        done++;
      } on PocketBaseApiException catch (error) {
        if (error.isNetwork) {
          return FileSyncResult(done: done, failed: failed, retryLater: true);
        }
        failed++;
      }
    }
    return FileSyncResult(done: done, failed: failed);
  }
}
