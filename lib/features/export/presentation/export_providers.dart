import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/share_service_provider.dart';
import 'package:mobil_arici/core/utils/xlsx.dart';
import 'package:mobil_arici/features/export/data/export_repository.dart';
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
