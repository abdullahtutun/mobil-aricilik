import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_label_sheet.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const LotLabelData _label = (
  url: 'https://arici-api.tutunsoft.com/l/0199a3b2-7c1e-7d40-8a5b-000000000001',
  number: 'Lot 2026-07',
  honey: 'Çam balı',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('tek A4 sayfa, kenar boşluğu yok', () {
    final document = lotLabelDocument(
      _label,
      title: 'Kavanoz etiketi',
      theme: pw.ThemeData.base(),
    );
    final pages = document.document.pdfPageList.pages;

    expect(pages, hasLength(1));
    expect(pages.single.pageFormat.width, PdfPageFormat.a4.width);
    expect(pages.single.pageFormat.height, PdfPageFormat.a4.height);
  });

  test('Türkçe harfli bal türüyle PDF üretir', () async {
    final bytes = await buildLotLabelPdf(
      _label,
      title: 'Kavanoz etiketi - Lot 2026-07',
    );

    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });
}
