import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/presentation/labels/hive_label_sheet.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

List<HiveLabelData> _labels(int count) => [
  for (var i = 0; i < count; i++)
    (
      hiveId: '0199a3b2-7c1e-7d40-8a5b-${(i + 1).toString().padLeft(12, '0')}',
      number: '${101 + i}',
      apiaryName: 'Çamlık Yaylası',
    ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HiveLabelSheet', () {
    test('A4 kenarsız 3 × 8: etiketler sayfaya sığar', () {
      const a4 = PdfPageFormat.a4;
      expect(HiveLabelSheet.perPage, 24);
      expect(
        HiveLabelSheet.columns * HiveLabelSheet.labelWidth,
        closeTo(a4.width, 0.01),
      );
      expect(
        HiveLabelSheet.rows * HiveLabelSheet.labelHeight,
        lessThanOrEqualTo(a4.height),
      );
      // 296 mm etiket, 297 mm sayfa.
      expect(
        a4.height - HiveLabelSheet.rows * HiveLabelSheet.labelHeight,
        closeTo(PdfPageFormat.mm, 0.01),
      );
    });

    test('sayfa sayısı: 24 etiket bir sayfa, 25 iki sayfa', () {
      expect(HiveLabelSheet.pageCount(1), 1);
      expect(HiveLabelSheet.pageCount(24), 1);
      expect(HiveLabelSheet.pageCount(25), 2);
      expect(HiveLabelSheet.pageCount(500), 21);
    });
  });

  group('hiveLabelDocument', () {
    final theme = pw.ThemeData.base();

    test('her 24 etikete bir A4 sayfa, kenar boşluğu yok', () {
      for (final (count, pages) in [(1, 1), (24, 1), (25, 2), (48, 2)]) {
        final document = hiveLabelDocument(
          _labels(count),
          title: 'Kovan etiketleri',
          theme: theme,
        );
        final pdfPages = document.document.pdfPageList.pages;

        expect(pdfPages, hasLength(pages), reason: '$count etiket');
        for (final page in pdfPages) {
          expect(page.pageFormat.width, PdfPageFormat.a4.width);
          expect(page.pageFormat.height, PdfPageFormat.a4.height);
        }
      }
    });
  });

  group('buildHiveLabelPdf', () {
    test('Türkçe harfli arılık adıyla PDF üretir', () async {
      final bytes = await buildHiveLabelPdf(
        _labels(25),
        title: 'Kovan etiketleri - Çamlık Yaylası',
      );

      expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
      expect(bytes.length, greaterThan(1000));
    });

    test('500 kovanlık (toplu oluşturma sınırı) PDF de üretilir', () async {
      final watch = Stopwatch()..start();
      final bytes = await buildHiveLabelPdf(_labels(500), title: 'Kovanlar');

      expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
      // Telefonda daha yavaş; bu ölçü yalnız kabaca bir tavan.
      expect(watch.elapsed, lessThan(const Duration(seconds: 20)));
    });
  });
}
