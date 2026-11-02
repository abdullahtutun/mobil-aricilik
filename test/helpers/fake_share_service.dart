import 'dart:typed_data';

import 'package:mobil_arici/core/services/share_service.dart';

/// Paylaşılan metinleri ve dosyaları biriktirir.
class FakeShareService implements ShareService {
  final shared = <({String text, String? subject})>[];

  @override
  Future<void> shareText(String text, {String? subject}) async {
    shared.add((text: text, subject: subject));
  }

  final files = <({Uint8List bytes, String filename, String mimeType})>[];

  @override
  Future<void> shareFile(
    Uint8List bytes, {
    required String filename,
    required String mimeType,
  }) async {
    files.add((bytes: bytes, filename: filename, mimeType: mimeType));
  }
}
