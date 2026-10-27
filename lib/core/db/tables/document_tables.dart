import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/media_tables.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';

/// `public.documents` aynası; durum tablosu. Dosyanın kendisi burada yok:
/// bu telefonun belge klasöründe `storage_path`'in son parçasıyla aynı
/// adla durur; başka telefonda eklendiyse satır inince indirilir.
@UseRowClass(VaultDocument, generateInsertable: true)
@TableIndex(name: 'documents_org_id_idx', columns: {#orgId})
class Documents extends Table with SyncColumns, OrgColumns {
  TextColumn get type =>
      text().map(const ServerEnumConverter(DocumentType.values))();
  TextColumn get customTypeName => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get expiresOn =>
      text().map(const DateOnlyConverter()).nullable()();
  TextColumn get fileKind =>
      text().map(const ServerEnumConverter(DocumentFileKind.values))();
  TextColumn get storagePath => text()();
  IntColumn get byteSize => integer()();
}

/// Bu telefonda seçilen belge dosyalarının yükleme kuyruğu; yalnız bu
/// telefonda, sunucuda aynası yok. Belgeyle aynı transaction'da `pending`
/// olarak yazılır; dosya değişince yeni yol yeni satır olur.
@DataClassName('DocumentUpload')
class DocumentUploads extends Table {
  /// Belgenin `storage_path`'i; dosyanın yerel adı bunun son parçası.
  TextColumn get storagePath => text()();
  TextColumn get documentId => text()();
  TextColumn get orgId => text()();
  TextColumn get uploadStatus => textEnum<MediaUploadStatus>()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Boşsa hemen denenir.
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {storagePath};
}
