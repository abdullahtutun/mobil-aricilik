import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

/// Uygulamaya gömülü Inter; PDF'in varsayılan yazı tipinde ı, ş, ğ yok.
/// Cihazda okunur, ağ gerekmez.
Future<pw.ThemeData> interPdfTheme() async => pw.ThemeData.withFont(
  base: pw.Font.ttf(
    await rootBundle.load('assets/fonts/inter/Inter-Regular.ttf'),
  ),
  bold: pw.Font.ttf(await rootBundle.load('assets/fonts/inter/Inter-Bold.ttf')),
);

/// PDF başlığından dosya adı: dosya adında sorun çıkaran karakterler tireye
/// döner.
String pdfFileName(String title) =>
    '${title.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-').trim()}.pdf';
