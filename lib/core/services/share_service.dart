import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

/// Metni ya da dosyayı sistemin paylaşma sayfasıyla telefondan çıkarır
/// (WhatsApp, SMS, e-posta, dosyalar); ağ gerekmez.
abstract interface class ShareService {
  Future<void> shareText(String text, {String? subject});

  /// Bellekteki dosyayı [filename] adıyla paylaşır (ör. CSV).
  Future<void> shareFile(
    Uint8List bytes, {
    required String filename,
    required String mimeType,
  });
}

class SharePlusShareService implements ShareService {
  const new();

  @override
  Future<void> shareText(String text, {String? subject}) =>
      SharePlus.instance.share(ShareParams(text: text, subject: subject));

  @override
  Future<void> shareFile(
    Uint8List bytes, {
    required String filename,
    required String mimeType,
  }) => SharePlus.instance.share(
    ShareParams(
      files: [XFile.fromData(bytes, mimeType: mimeType, name: filename)],
      fileNameOverrides: [filename],
    ),
  );
}
