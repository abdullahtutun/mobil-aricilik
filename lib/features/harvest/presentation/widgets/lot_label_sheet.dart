import 'dart:typed_data';

import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/features/hives/presentation/labels/hive_label_sheet.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Kavanoz etiketi: lotun sayfasının QR'ı, lot numarası ve bal türü.
typedef LotLabelData = ({String url, String number, String honey});

/// Lotun kavanoz etiketi PDF'i: kovan etiketiyle aynı A4 24'lü kâğıt
/// ([HiveLabelSheet]), bir sayfa, 24 aynı etiket. QR lotun herkese açık
/// sayfasını (`url`) taşır. Cihazda üretilir, ağ gerekmez.
Future<Uint8List> buildLotLabelPdf(
  LotLabelData label, {
  required String title,
}) async {
  final document = lotLabelDocument(
    label,
    title: title,
    theme: await interPdfTheme(),
  );
  return await document.save();
}

/// [buildLotLabelPdf]'in belgesi; testler buradan okur.
pw.Document lotLabelDocument(
  LotLabelData label, {
  required String title,
  required pw.ThemeData theme,
}) => pw.Document(title: title, theme: theme)
  ..addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) => pw.Center(
        child: pw.Column(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            for (var row = 0; row < HiveLabelSheet.rows; row++)
              pw.Row(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  for (
                    var column = 0;
                    column < HiveLabelSheet.columns;
                    column++
                  )
                    _label(label),
                ],
              ),
          ],
        ),
      ),
    ),
  );

pw.Widget _label(LotLabelData label) {
  const qrSize = HiveLabelSheet.labelHeight - 2 * HiveLabelSheet.padding;
  return pw.SizedBox(
    width: HiveLabelSheet.labelWidth,
    height: HiveLabelSheet.labelHeight,
    child: pw.Padding(
      padding: const pw.EdgeInsets.all(HiveLabelSheet.padding),
      child: pw.Row(
        children: [
          pw.BarcodeWidget(
            // Kavanozda çizilen, ıslanan etiket de okunsun: %25 onarım.
            barcode: pw.Barcode.qrCode(
              errorCorrectLevel: pw.BarcodeQRCorrectionLevel.quartile,
            ),
            data: label.url,
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
                      fontSize: _numberSize,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.Text(
                  label.honey,
                  maxLines: 2,
                  overflow: pw.TextOverflow.clip,
                  style: const pw.TextStyle(
                    fontSize: HiveLabelSheet.apiarySize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// "Lot 2026-07" kovan numarasından uzun; daha küçük başlar, sığmazsa
/// küçülür.
const double _numberSize = 16;
