import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/core/services/document_picker.dart';
import 'package:mobil_arici/core/services/document_services_provider.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/pdf_page_renderer.dart';
import 'package:mobil_arici/core/sync/document_sync_service.dart';
import 'package:mobil_arici/core/sync/document_sync_service_provider.dart';
import 'package:mobil_arici/core/sync/storage_file_sync.dart';

import 'fake_media.dart';

/// Cihazsız belge kasası: geçici klasörde belge dosyaları, sahte PDF
/// seçici, PDF çizici ve Storage. Dosyalar eşzamanlı yazılır; widget
/// testlerinin sahte zamanında asenkron dosya işlemi bitmez.
class FakeDocuments {
  new() : directory = Directory.systemTemp.createTempSync('fake_documents') {
    addTearDown(() => directory.deleteSync(recursive: true));
  }

  final Directory directory;
  late final store = MediaFileStore(Future.value(directory));
  late final picker = FakeDocumentPicker(directory);
  final renderer = FakePdfPageRenderer();
  final sync = FakeDocumentSyncService();

  /// Belge klasöründeki dosya adları.
  List<String> get fileNames => [
    for (final file in directory.listSync().whereType<File>())
      file.uri.pathSegments.last,
  ]..sort();

  /// [fileName]'i belge klasörüne yazar (ör. başka telefondan inmiş dosya).
  void addFile(String fileName, [List<int> bytes = tinyImage]) =>
      File('${directory.path}/$fileName').writeAsBytesSync(bytes);

  List<Override> get overrides => [
    documentFileStoreProvider.overrideWithValue(store),
    documentPickerProvider.overrideWithValue(picker),
    pdfPageRendererProvider.overrideWithValue(renderer),
    documentSyncServiceProvider.overrideWithValue(sync),
  ];
}

/// Seçilen PDF, belge klasörünün dışındaki bir alt klasörde durur (sistem
/// seçicisinin geçici kopyası gibi).
class FakeDocumentPicker implements DocumentPicker {
  new(Directory directory)
    : _source = Directory('${directory.path}/$sourceFolder')..createSync();

  static const sourceFolder = 'picked';

  final Directory _source;

  /// Seçilecek dosyanın boyutu.
  int byteSize = 2048;
  MediaCaptureFailure? failure;
  bool cancel = false;
  int pickCount = 0;

  @override
  Future<String?> pickPdf() async {
    if (failure case final failure?) throw MediaCaptureException(failure);
    if (cancel) return null;
    pickCount++;
    final file = File('${_source.path}/picked-$pickCount.pdf')
      ..writeAsBytesSync(List.filled(byteSize, 1));
    return file.path;
  }
}

/// Her PDF'i [pageCount] sayfa olarak "çizer" (1x1 PNG).
class FakePdfPageRenderer implements PdfPageRenderer {
  int pageCount = 2;
  bool fail = false;

  @override
  Future<List<Uint8List>> render(Uint8List pdf) async {
    if (fail) throw Exception('pdf');
    return [for (var i = 0; i < pageCount; i++) Uint8List.fromList(tinyImage)];
  }
}

/// Storage'sız: çağrıları sayar.
class FakeDocumentSyncService implements DocumentSyncService {
  int uploadCount = 0;
  final downloads = <String>[];

  @override
  DateTime Function() get clock => DateTime.now;

  @override
  Future<FileSyncResult> uploadPending() async {
    uploadCount++;
    return const FileSyncResult();
  }

  @override
  Future<FileSyncResult> downloadMissing(String orgId) async {
    downloads.add(orgId);
    return const FileSyncResult();
  }
}
