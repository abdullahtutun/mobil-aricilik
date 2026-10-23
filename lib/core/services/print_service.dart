import 'dart:typed_data';

import 'package:printing/printing.dart';

/// Cihazda üretilmiş PDF'i telefondan çıkarır; ağ gerekmez.
abstract interface class PrintService {
  /// Sistemin yazdırma ekranını açar; orada "PDF olarak kaydet" de var.
  /// [bytes] A4 sayfalardan oluşmalı.
  Future<void> printPdf(Uint8List bytes, {required String name});

  /// Sistemin paylaşma sayfasını açar (WhatsApp, e-posta, dosyalar).
  Future<void> sharePdf(Uint8List bytes, {required String filename});
}

class PrintingPrintService implements PrintService {
  const new();

  @override
  Future<void> printPdf(Uint8List bytes, {required String name}) =>
      Printing.layoutPdf(
        name: name,
        // Belge hazır; yazıcının kâğıdına göre yeniden dizilmez.
        onLayout: (_) => bytes,
      );

  @override
  Future<void> sharePdf(Uint8List bytes, {required String filename}) =>
      Printing.sharePdf(bytes: bytes, filename: filename);
}
