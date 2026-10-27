import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:mobil_arici/core/services/camera_service.dart';

/// Telefondaki dosyalardan PDF seçtirir (belge kasası). İnternet gerekmez.
abstract interface class DocumentPicker {
  /// PDF seçtirir; seçilen dosyanın okunabilir yolu (sistemin geçici
  /// kopyası olabilir). Kullanıcı vazgeçerse null. Hata
  /// [MediaCaptureException] olarak gelir.
  Future<String?> pickPdf();
}

/// file_picker sistemin dosya seçicisini açar (Android SAF, iOS
/// UIDocumentPicker); yalnız `.pdf` seçilebilir.
class DeviceDocumentPicker implements DocumentPicker {
  const new();

  @override
  Future<String?> pickPdf() async {
    final PlatformFile? file;
    try {
      file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );
    } on PlatformException catch (error) {
      throw MediaCaptureException(
        error.code.contains('permission')
            ? MediaCaptureFailure.permissionDenied
            : MediaCaptureFailure.failed,
      );
    }
    if (file == null) return null;
    return file.path ??
        (throw const MediaCaptureException(MediaCaptureFailure.failed));
  }
}
