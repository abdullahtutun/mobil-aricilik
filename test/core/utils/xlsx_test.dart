import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/xlsx.dart';

void main() {
  /// Zip'teki parçalar: yol → metin.
  Map<String, String> parts(List<XlsxSheet> sheets) {
    final archive = ZipDecoder().decodeBytes(encodeXlsx(sheets));
    return {
      for (final file in archive.files)
        if (file.isFile) file.name: utf8.decode(file.content),
    };
  }

  test('Excel’in istediği parçalar ve her sayfa için bir çalışma sayfası', () {
    final files = parts([
      const XlsxSheet(
        name: 'Arılıklar',
        rows: [
          ['Ad'],
        ],
      ),
      const XlsxSheet(
        name: 'Kovanlar',
        rows: [
          ['No'],
        ],
      ),
    ]);

    expect(
      files.keys,
      containsAll([
        '[Content_Types].xml',
        '_rels/.rels',
        'xl/workbook.xml',
        'xl/_rels/workbook.xml.rels',
        'xl/styles.xml',
        'xl/worksheets/sheet1.xml',
        'xl/worksheets/sheet2.xml',
      ]),
    );
    expect(files['[Content_Types].xml'], contains('/xl/worksheets/sheet2.xml'));
    expect(files['xl/workbook.xml'], contains('name="Arılıklar"'));
    expect(files['xl/workbook.xml'], contains('name="Kovanlar"'));
    expect(
      files['xl/_rels/workbook.xml.rels'],
      contains('Target="worksheets/sheet2.xml"'),
    );
  });

  test('hücreler: metin, sayı, tarih-saat, gün, boş; başlık kalın ve '
      'sabit', () {
    final sheet = parts([
      XlsxSheet(
        name: 'S',
        rows: [
          ['Ad', 'Sayı', 'Zaman', 'Gün', 'Boş'],
          [
            'Yayla & "Ova" <1>',
            12.5,
            DateTime(2026, 11, 5, 18),
            XlsxDate(DateTime(2026, 11, 5)),
            null,
          ],
        ],
      ),
    ])['xl/worksheets/sheet1.xml']!;

    expect(sheet, contains('<pane ySplit="1"'));
    expect(
      sheet,
      contains(
        '<c r="A1" t="inlineStr" s="1"><is><t xml:space="preserve">Ad</t>',
      ),
    );
    expect(sheet, contains('Yayla &amp; &quot;Ova&quot; &lt;1&gt;</t>'));
    expect(sheet, contains('<c r="B2"><v>12.5</v></c>'));
    // 2026-11-05 = gün 46331; 18:00 = 0.75.
    expect(sheet, contains('<c r="C2" s="3"><v>46331.75</v></c>'));
    expect(sheet, contains('<c r="D2" s="2"><v>46331</v></c>'));
    expect(sheet, isNot(contains('r="E2"')));
  });

  test('XML’de geçersiz denetim karakterleri atılır, sonsuz sayı yazılmaz', () {
    final sheet = parts([
      const XlsxSheet(
        name: 'S',
        rows: [
          ['a\u0001b', double.nan],
        ],
      ),
    ])['xl/worksheets/sheet1.xml']!;

    expect(sheet, contains('>ab</t>'));
    expect(sheet, isNot(contains('NaN')));
    // Tek satırda başlık sabitlenmez.
    expect(sheet, isNot(contains('<pane')));
  });

  test('sayfa adları Excel kısıtına uydurulur: yasak karakter, 31 '
      'karakter, tekil', () {
    final workbook = parts([
      for (final name in [
        'Gelir/gider: [2026]',
        'Çok çok çok çok çok uzun bir sayfa adı',
        'Stok',
        'stok',
        '',
      ])
        XlsxSheet(
          name: name,
          rows: const [
            ['x'],
          ],
        ),
    ])['xl/workbook.xml']!;

    expect(workbook, contains('name="Gelir-gider- -2026-"'));
    expect(workbook, contains('name="Çok çok çok çok çok uzun bir sa"'));
    expect(workbook, contains('name="Stok"'));
    expect(workbook, contains('name="stok (2)"'));
    expect(workbook, contains('name="Sheet5"'));
  });

  test('sütun harfleri', () {
    expect(xlsxColumn(0), 'A');
    expect(xlsxColumn(25), 'Z');
    expect(xlsxColumn(26), 'AA');
    expect(xlsxColumn(701), 'ZZ');
    expect(xlsxColumn(702), 'AAA');
  });

  test('gün seri numarası duvar saatine göre', () {
    expect(xlsxSerial(DateTime(1900, 3)), 61);
    expect(xlsxSerial(DateTime(2026, 11, 5, 6)), 46331.25);
  });

  test('dosya adı', () {
    expect(
      xlsxFileName('Mobil Arıcı 2026-11-05'),
      'Mobil Arıcı 2026-11-05.xlsx',
    );
    expect(xlsxFileName('a/b:c'), 'a-b-c.xlsx');
  });
}
