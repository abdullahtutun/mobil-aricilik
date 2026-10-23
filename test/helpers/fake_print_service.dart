import 'dart:typed_data';

import 'package:mobil_arici/core/services/print_service.dart';

/// Yazıcısız servis: verilen PDF'leri kaydeder, istenirse hata atar.
class FakePrintService implements PrintService {
  final printed = <({Uint8List bytes, String name})>[];
  final shared = <({Uint8List bytes, String filename})>[];

  /// Doluysa sonraki çağrı bunu atar.
  Exception? failure;

  @override
  Future<void> printPdf(Uint8List bytes, {required String name}) async {
    if (failure case final failure?) throw failure;
    printed.add((bytes: bytes, name: name));
  }

  @override
  Future<void> sharePdf(Uint8List bytes, {required String filename}) async {
    if (failure case final failure?) throw failure;
    shared.add((bytes: bytes, filename: filename));
  }
}
