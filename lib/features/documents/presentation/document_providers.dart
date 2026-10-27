import 'dart:io';
import 'dart:typed_data';

import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/document_services_provider.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_providers.g.dart';

@Riverpod(keepAlive: true)
DocumentRepository documentRepository(Ref ref) =>
    DocumentRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin belgeleri kasa sırasıyla; işletme yoksa boş.
@riverpod
Stream<List<VaultDocument>> documents(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(documentRepositoryProvider).watchByOrg(orgId);
}

/// Belge; yoksa ya da silinmişse null.
@riverpod
Stream<VaultDocument?> document(Ref ref, String id) =>
    ref.watch(documentRepositoryProvider).watchById(id);

/// Daha önce yazılmış kullanıcı tanımlı türler (formda öneri).
@riverpod
Future<List<String>> customDocumentTypeNames(Ref ref) async =>
    customDocumentTypes(await ref.watch(documentsProvider.future));

/// Dosyası bu telefonda olan belgelerin `storage_path`'leri. Belgeler
/// değişince ve dosya indirilince (tetikleyici yeniler) yeniden hesaplanır.
@riverpod
Future<Set<String>> documentLocalFiles(Ref ref) async {
  final store = ref.watch(documentFileStoreProvider);
  final documents = await ref.watch(documentsProvider.future);
  return {
    for (final document in documents)
      if (await store.find(documentFileName(document.storagePath)) != null)
        document.storagePath,
  };
}

/// Belge dosyası bu telefonda varsa; yoksa null.
@riverpod
Future<File?> documentFile(Ref ref, String storagePath) =>
    ref.watch(documentFileStoreProvider).find(documentFileName(storagePath));

/// PDF belgenin sayfaları (PNG); dosya bu telefonda yoksa null.
@riverpod
Future<List<Uint8List>?> documentPdfPages(Ref ref, String storagePath) async {
  final file = await ref.watch(documentFileProvider(storagePath).future);
  if (file == null) return null;
  // Eşzamanlı okuma: widget testlerinin sahte zamanında da biter.
  return await ref
      .watch(pdfPageRendererProvider)
      .render(file.readAsBytesSync());
}

/// Belge kasasındaki eylemler.
@Riverpod(keepAlive: true)
class DocumentActions extends _$DocumentActions {
  @override
  void build() {}

  /// Belgeyi siler; dosyası bu telefondan da kalkar (Storage'da kalır).
  Future<void> delete(VaultDocument document) async {
    await ref.read(documentRepositoryProvider).remove(document.id);
    await ref
        .read(documentFileStoreProvider)
        .delete(documentFileName(document.storagePath));
  }
}
