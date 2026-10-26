import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';

/// Foto ya da ses kaydı alınamadığında nedeni.
enum MediaCaptureFailure {
  /// Kamera ya da mikrofon izni verilmedi.
  permissionDenied,

  /// Cihazda kamera ya da mikrofon yok, ya da çekim bozuldu.
  failed,
}

class MediaCaptureException implements Exception {
  const new(this.failure);

  final MediaCaptureFailure failure;

  @override
  String toString() => 'MediaCaptureException(${failure.name})';
}

/// Cihaz kamerasıyla tek foto ya da galeriden tek görüntü. İnternet
/// gerekmez.
abstract interface class CameraService {
  /// Kamerayı açar; çekilen fotoğrafı uzun kenarı ~1600 px JPEG olarak
  /// [targetPath]'e yazar ve boyutunu (bayt) döner. Kullanıcı vazgeçerse
  /// null. Hata [MediaCaptureException] olarak gelir.
  Future<int?> takePhoto(String targetPath);

  /// Galeriden bir görüntü seçtirir (ör. ekran görüntüsü); [takePhoto]
  /// gibi küçültüp JPEG olarak [targetPath]'e yazar.
  Future<int?> pickImage(String targetPath);
}

/// image_picker sistem kamerasını açar; flutter_image_compress küçültür,
/// EXIF yönünü uygular ve EXIF'i (konum dahil) atar.
class DeviceCameraService implements CameraService {
  new([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// JPEG kalitesi; 1600 px'te ~250–400 KB.
  static const quality = 80;

  @override
  Future<int?> takePhoto(String targetPath) =>
      _capture(ImageSource.camera, targetPath);

  @override
  Future<int?> pickImage(String targetPath) =>
      _capture(ImageSource.gallery, targetPath);

  Future<int?> _capture(ImageSource source, String targetPath) async {
    final XFile? shot;
    try {
      shot = await _picker.pickImage(
        source: source,
        requestFullMetadata: false,
      );
    } on PlatformException catch (error) {
      throw MediaCaptureException(
        error.code.contains('access_denied')
            ? MediaCaptureFailure.permissionDenied
            : MediaCaptureFailure.failed,
      );
    }
    if (shot == null) return null;

    try {
      final shortEdge = await _shortEdgeFor(shot.path);
      final compressed = await FlutterImageCompress.compressAndGetFile(
        shot.path,
        targetPath,
        minWidth: shortEdge,
        minHeight: shortEdge,
        quality: quality,
      );
      if (compressed == null) {
        throw const MediaCaptureException(MediaCaptureFailure.failed);
      }
      return await compressed.length();
    } finally {
      try {
        // Galeriden seçilende de image_picker geçici bir kopya verir;
        // galerideki asıl dosyaya dokunulmaz.
        await File(shot.path).delete();
      } on FileSystemException {
        // image_picker'ın geçici kopyası; silinemezse işletim sistemi
        // önbellekle birlikte temizler.
      }
    }
  }

  /// Sıkıştırıcının kısa kenarı: görüntünün başlığından okunan boyutla
  /// [compressShortEdge].
  static Future<int> _shortEdgeFor(String path) async {
    final buffer = await ui.ImmutableBuffer.fromFilePath(path);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    try {
      return compressShortEdge(descriptor.width, descriptor.height);
    } finally {
      descriptor.dispose();
      buffer.dispose();
    }
  }
}
