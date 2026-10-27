import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';

/// Belge kasası; durum kaydı, son yazan kazanır.
///
/// Bu telefonda seçilen dosya, belgeyle aynı transaction'da yükleme
/// kuyruğuna (`document_uploads`, `pending`) yazılır; dosyayı arka planda
/// `DocumentSyncService` yükler. Dosyalara dokunmaz: dosya adları belge
/// klasöründeki adlardır ([documentFileName]).
class DocumentRepository
    extends BaseRepository<$DocumentsTable, VaultDocument> {
  new(super.db, {super.clock});

  @override
  $DocumentsTable get table => db.documents;

  @override
  Insertable<VaultDocument> toInsertable(VaultDocument record) =>
      record.toInsertable();

  /// İşletmenin belgeleri kasa sırasıyla ([sortDocuments]).
  Stream<List<VaultDocument>> watchByOrg(String orgId) =>
      watchWhere((t) => t.orgId.equals(orgId)).map(sortDocuments);

  /// İşletmenin belgeleri; bir kez okunur (dosya indirme).
  Future<List<VaultDocument>> listByOrg(String orgId) =>
      selectWhere((t) => t.orgId.equals(orgId)).get();

  /// Belgeyi [file] ile yazar ve dosyayı yükleme kuyruğuna ekler; ikisi
  /// tek transaction'da. Alanlar geçersizse ([checkDocument]) [ArgumentError]
  /// atar ve bir şey yazmaz.
  Future<VaultDocument> create({
    required String orgId,
    required DocumentType type,
    required String name,
    required DocumentFileCapture file,
    String? customTypeName,
    String? description,
    DateTime? expiresOn,
  }) => db.transaction(() async {
    final at = now();
    final id = generateId();
    final document = await insertRecord(
      checkDocument(
        VaultDocument(
          id: id,
          orgId: orgId,
          type: type,
          customTypeName: customTypeName,
          name: name,
          description: description,
          expiresOn: expiresOn,
          fileKind: file.kind,
          storagePath: documentStoragePath(
            orgId: orgId,
            documentId: id,
            fileId: file.fileId,
            kind: file.kind,
          ),
          byteSize: file.byteSize,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
    await _enqueueUpload(document);
    return document;
  });

  /// Belgenin alanlarını yazar. [file] verilirse belgenin dosyası o olur:
  /// yeni yol yükleme kuyruğuna girer, eski dosya henüz yüklenmediyse
  /// kuyruktan çıkar. Hepsi tek transaction'da. Belge yoksa ya da
  /// silinmişse [StateError], alanlar geçersizse [ArgumentError] atar.
  Future<VaultDocument> update(
    VaultDocument document, {
    DocumentFileCapture? file,
  }) => db.transaction(() async {
    final previous = await requireById(document.id);
    final next = file == null
        ? document.copyWith(
            fileKind: previous.fileKind,
            storagePath: previous.storagePath,
            byteSize: previous.byteSize,
          )
        : document.copyWith(
            fileKind: file.kind,
            storagePath: documentStoragePath(
              orgId: previous.orgId,
              documentId: previous.id,
              fileId: file.fileId,
              kind: file.kind,
            ),
            byteSize: file.byteSize,
          );
    final updated = await updateRecord(checkDocument(next));
    if (updated.storagePath != previous.storagePath) {
      await _dropPendingUpload(
        (t) => t.storagePath.equals(previous.storagePath),
      );
      await _enqueueUpload(updated);
    }
    return updated;
  });

  /// Belgeyi siler ve dosyası henüz yüklenmediyse kuyruktan çıkarır; ikisi
  /// tek transaction'da. Yüklenmiş dosya Storage'da kalır.
  Future<void> remove(String id) => db.transaction(() async {
    await delete(id);
    await _dropPendingUpload((t) => t.documentId.equals(id));
  });

  Future<void> _enqueueUpload(VaultDocument document) => db
      .into(db.documentUploads)
      .insert(
        DocumentUploadsCompanion.insert(
          storagePath: document.storagePath,
          documentId: document.id,
          orgId: document.orgId,
          uploadStatus: MediaUploadStatus.pending,
          createdAt: now(),
        ),
      );

  Future<void> _dropPendingUpload(
    Expression<bool> Function($DocumentUploadsTable t) filter,
  ) =>
      (db.delete(db.documentUploads)..where(
            (t) =>
                filter(t) &
                t.uploadStatus.equalsValue(MediaUploadStatus.uploaded).not(),
          ))
          .go();

  /// Yüklenmeyi bekleyen dosya sayısı (kalıcı hata alanlar dahil değil).
  Stream<int> watchPendingUploadCount() => _pendingCount().watchSingle();

  Future<int> pendingUploadCount() => _pendingCount().getSingle();

  Selectable<int> _pendingCount() {
    final count = db.documentUploads.storagePath.count();
    return (db.selectOnly(db.documentUploads)
          ..addColumns([count])
          ..where(
            db.documentUploads.uploadStatus.equalsValue(
              MediaUploadStatus.pending,
            ),
          ))
        .map((row) => row.read(count)!);
  }
}

/// Belgeyi yazılacak hâline getirir: ad, tür adı ve açıklamanın baştaki ve
/// sondaki boşlukları atılır, boş açıklama null olur, geçerlilik günü
/// saatsiz olur. Ad boşsa ya da uzunsa, kullanıcı tanımlı türün adı yoksa,
/// hazır türde ad varsa ya da dosya boyutu sınır dışındaysa [ArgumentError]
/// atar.
VaultDocument checkDocument(VaultDocument document) {
  final name = document.name.trim();
  if (name.isEmpty || name.length > maxDocumentNameLength) {
    throw ArgumentError.value(document.name, 'name');
  }
  final custom = document.customTypeName?.trim();
  if (document.type == DocumentType.custom) {
    if (custom == null ||
        custom.isEmpty ||
        custom.length > maxDocumentTypeLength) {
      throw ArgumentError.value(document.customTypeName, 'customTypeName');
    }
  } else if (custom != null) {
    throw ArgumentError.value(document.customTypeName, 'customTypeName');
  }
  final description = document.description?.trim();
  if (description != null &&
      description.length > maxDocumentDescriptionLength) {
    throw ArgumentError.value(document.description, 'description');
  }
  if (document.byteSize < 1 || document.byteSize > maxDocumentFileBytes) {
    throw ArgumentError.value(document.byteSize, 'byteSize');
  }
  return document.copyWith(
    name: name,
    customTypeName: custom,
    description: description == null || description.isEmpty
        ? null
        : description,
    expiresOn: switch (document.expiresOn) {
      final day? => dateOnly(day),
      null => null,
    },
  );
}
