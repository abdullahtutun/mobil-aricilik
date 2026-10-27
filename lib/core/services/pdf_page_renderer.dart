import 'dart:typed_data';

import 'package:printing/printing.dart';

/// PDF sayfalarını görüntüye çevirir; belge kasasında PDF'i internetsiz
/// göstermek için. İşletim sisteminin PDF çizicisini kullanır.
abstract interface class PdfPageRenderer {
  /// [pdf]'in sayfaları sırayla PNG olarak. Çizilemezse hata atar.
  Future<List<Uint8List>> render(Uint8List pdf);
}

/// printing paketi: Android'de `PdfRenderer`, iOS'ta PDFKit.
class PrintingPdfPageRenderer implements PdfPageRenderer {
  const new();

  /// Telefonda okunaklı ama bellek dostu çözünürlük.
  static const dpi = 150.0;

  @override
  Future<List<Uint8List>> render(Uint8List pdf) =>
      Printing.raster(pdf, dpi: dpi).asyncMap((page) => page.toPng()).toList();
}
