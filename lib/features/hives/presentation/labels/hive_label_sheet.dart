import 'dart:typed_data';

import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Etikete basılacak kovan.
typedef HiveLabelData = ({String hiveId, String number, String apiaryName});

/// A4 etiket kâğıdı: 3 sütun × 8 satır, 70 × 37 mm, kenarsız; Türkiye'de
/// en yaygın 24'lü etiket. Etiketler 296 mm tutar, sayfanın üstünde ve
/// altında 0,5 mm kalır. Ölçüler kâğıdın kendisi, ekran tokenı değil.
abstract final class HiveLabelSheet {
  static const columns = 3;
  static const rows = 8;
  static const int perPage = columns * rows;

  static const double labelWidth = 70 * PdfPageFormat.mm;
  static const double labelHeight = 37 * PdfPageFormat.mm;

  /// Etiket kenarıyla içerik arası; kesim ve yazıcı kayması payı.
  static const double padding = 3 * PdfPageFormat.mm;

  /// QR ile yazılar arası.
  static const double gap = 3 * PdfPageFormat.mm;

  /// Kovan numarasının en büyük boyu (pt); uzun numara sığana kadar
  /// küçülür.
  static const double numberSize = 30;
  static const double apiarySize = 9;

  /// [count] etiketin kaç sayfa tuttuğu.
  static int pageCount(int count) => (count / perPage).ceil();
}

/// Seçilen kovanların etiket PDF'i: A4, sayfa başına 24 etiket; her
/// etikette QR (`mobilarici://h/<kimlik>`), büyük kovan numarası ve arılık
/// adı. Etiketler verilen sırayla soldan sağa, yukarıdan aşağı dizilir.
/// Cihazda üretilir, ağ gerekmez.
Future<Uint8List> buildHiveLabelPdf(
  List<HiveLabelData> labels, {
  required String title,
}) async {
  final document = hiveLabelDocument(
    labels,
    title: title,
    theme: await interPdfTheme(),
  );
  return await document.save();
}

/// [buildHiveLabelPdf]'in belgesi; testler sayfaları buradan sayar.
pw.Document hiveLabelDocument(
  List<HiveLabelData> labels, {
  required String title,
  required pw.ThemeData theme,
}) {
  final document = pw.Document(title: title, theme: theme);
  for (var start = 0; start < labels.length; start += HiveLabelSheet.perPage) {
    final page = labels.sublist(
      start,
      (start + HiveLabelSheet.perPage).clamp(0, labels.length),
    );
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              for (var row = 0; row < HiveLabelSheet.rows; row++)
                pw.Row(
                  children: [
                    for (
                      var column = 0;
                      column < HiveLabelSheet.columns;
                      column++
                    )
                      _cell(page, row * HiveLabelSheet.columns + column),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
  return document;
}

/// Boş hücre de yer tutar; son sayfada etiketler yerinde kalsın.
pw.Widget _cell(List<HiveLabelData> page, int index) => pw.SizedBox(
  width: HiveLabelSheet.labelWidth,
  height: HiveLabelSheet.labelHeight,
  child: index < page.length ? _label(page[index]) : null,
);

pw.Widget _label(HiveLabelData label) {
  const qrSize = HiveLabelSheet.labelHeight - 2 * HiveLabelSheet.padding;
  return pw.Padding(
    padding: const pw.EdgeInsets.all(HiveLabelSheet.padding),
    child: pw.Row(
      children: [
        pw.BarcodeWidget(
          // Dış mekânda çizilen, kirlenen etiket de okunsun: %25 onarım.
          barcode: pw.Barcode.qrCode(
            errorCorrectLevel: pw.BarcodeQRCorrectionLevel.quartile,
          ),
          data: hiveLabelCode(label.hiveId),
          width: qrSize,
          height: qrSize,
          drawText: false,
        ),
        pw.SizedBox(width: HiveLabelSheet.gap),
        pw.Expanded(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.FittedBox(
                fit: pw.BoxFit.scaleDown,
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  label.number,
                  style: const pw.TextStyle(
                    fontSize: HiveLabelSheet.numberSize,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                label.apiaryName,
                textDirection: pdfTextDirectionOf(label.apiaryName),
                maxLines: 2,
                overflow: pw.TextOverflow.clip,
                style: const pw.TextStyle(fontSize: HiveLabelSheet.apiarySize),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
