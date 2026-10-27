import 'package:mobil_arici/core/services/document_picker.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/pdf_page_renderer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_services_provider.g.dart';

/// Belge kasasının dosyaları (uygulama klasöründe `documents/`). Testler
/// geçici klasörle override eder.
@Riverpod(keepAlive: true)
MediaFileStore documentFileStore(Ref ref) => MediaFileStore.app('documents');

/// Testler sahte seçiciyle override eder.
@Riverpod(keepAlive: true)
DocumentPicker documentPicker(Ref ref) => const DeviceDocumentPicker();

/// Testler sahte çiziciyle override eder.
@Riverpod(keepAlive: true)
PdfPageRenderer pdfPageRenderer(Ref ref) => const PrintingPdfPageRenderer();
